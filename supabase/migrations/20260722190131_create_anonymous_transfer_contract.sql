begin;

set local lock_timeout = '5s';
set local statement_timeout = '30s';

create table private.anonymous_transfers (
  id uuid primary key default gen_random_uuid(),
  source_owner_id uuid not null,
  source_profile_id uuid not null,
  source_profile_revision integer not null,
  target_owner_id uuid,
  token_sha256 bytea not null,
  status text not null default 'prepared',
  expires_at timestamptz not null,
  consumed_at timestamptz,
  created_at timestamptz not null default now(),
  constraint anonymous_transfers_source_owner_fk
    foreign key (source_owner_id) references auth.users(id) on delete cascade,
  constraint anonymous_transfers_source_profile_fk
    foreign key (source_profile_id) references public.profiles(id) on delete cascade,
  constraint anonymous_transfers_target_owner_fk
    foreign key (target_owner_id) references auth.users(id) on delete cascade,
  constraint anonymous_transfers_source_profile_revision_check check (
    source_profile_revision >= 1
  ),
  constraint anonymous_transfers_token_sha256_check check (
    octet_length(token_sha256) = 32
  ),
  constraint anonymous_transfers_status_check check (
    status in ('prepared', 'consumed', 'expired', 'cancelled')
  ),
  constraint anonymous_transfers_expiry_window_check check (
    expires_at > created_at
    and expires_at <= created_at + interval '15 minutes'
  ),
  constraint anonymous_transfers_state_check check (
    (
      status in ('prepared', 'expired', 'cancelled')
      and target_owner_id is null
      and consumed_at is null
    )
    or (
      status = 'consumed'
      and target_owner_id is not null
      and target_owner_id <> source_owner_id
      and consumed_at is not null
      and consumed_at <= expires_at
    )
  )
);

create unique index anonymous_transfers_token_sha256_idx
on private.anonymous_transfers (token_sha256);

create index anonymous_transfers_expiry_idx
on private.anonymous_transfers (expires_at, id)
where status = 'prepared';

create index anonymous_transfers_source_owner_idx
on private.anonymous_transfers (source_owner_id);

create index anonymous_transfers_source_profile_idx
on private.anonymous_transfers (source_profile_id);

create index anonymous_transfers_target_owner_idx
on private.anonymous_transfers (target_owner_id)
where target_owner_id is not null;

create function private.enforce_anonymous_transfer_contract()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $function$
begin
  if tg_op = 'INSERT' then
    if not exists (
      select 1
      from auth.users as source_user
      join public.profiles as source_profile
        on source_profile.owner_id = source_user.id
      where source_user.id = new.source_owner_id
        and source_user.is_anonymous is true
        and source_profile.id = new.source_profile_id
        and source_profile.revision = new.source_profile_revision
        and source_profile.status = 'draft'
        and source_profile.derived_from_profile_id is null
    ) then
      raise exception using
        errcode = '23514',
        message = 'anonymous transfer source must be an owned root draft at the recorded revision';
    end if;

    return new;
  end if;

  if row(
    new.id,
    new.source_owner_id,
    new.source_profile_id,
    new.source_profile_revision,
    new.token_sha256,
    new.expires_at,
    new.created_at
  ) is distinct from row(
    old.id,
    old.source_owner_id,
    old.source_profile_id,
    old.source_profile_revision,
    old.token_sha256,
    old.expires_at,
    old.created_at
  ) then
    raise exception using
      errcode = '23514',
      message = 'anonymous transfer identity and expiry evidence are immutable';
  end if;

  if old.status <> 'prepared'
    and row(new.status, new.target_owner_id, new.consumed_at)
      is distinct from row(old.status, old.target_owner_id, old.consumed_at)
  then
    raise exception using
      errcode = '23514',
      message = 'terminal anonymous transfer state is immutable';
  end if;

  return new;
end;
$function$;

comment on function private.enforce_anonymous_transfer_contract() is
  'Validates anonymous root-draft preparation and makes transfer identity, expiry, and terminal state immutable.';

revoke execute on function private.enforce_anonymous_transfer_contract()
  from public, anon, authenticated, service_role;

create trigger anonymous_transfers_enforce_contract
before insert or update on private.anonymous_transfers
for each row execute function private.enforce_anonymous_transfer_contract();

alter table private.anonymous_transfers enable row level security;

revoke all privileges on table private.anonymous_transfers
  from public, anon, authenticated, service_role;
grant select, insert, update, delete on table private.anonymous_transfers
  to service_role;

create function private.consume_anonymous_transfer(
  p_token_sha256 bytea,
  p_target_owner_id uuid
)
returns table (
  result_transfer_id uuid,
  result_profile_id uuid,
  result_target_owner_id uuid,
  result_status text,
  result_already_consumed boolean
)
language plpgsql
security definer
set search_path = ''
as $function$
declare
  transfer_row private.anonymous_transfers%rowtype;
  source_user_is_anonymous boolean;
  target_user_is_anonymous boolean;
  target_active_profile_id uuid;
  moved_profile_count integer;
  operation_time timestamptz;
begin
  if p_token_sha256 is null or octet_length(p_token_sha256) <> 32 then
    raise exception using
      errcode = '22023',
      message = 'invalid anonymous transfer token';
  end if;

  if p_target_owner_id is null then
    raise exception using
      errcode = '22023',
      message = 'target account is required';
  end if;

  set constraints all deferred;

  select transfer.*
  into transfer_row
  from private.anonymous_transfers as transfer
  where transfer.token_sha256 = p_token_sha256
  for update;

  if not found then
    raise exception using
      errcode = '22023',
      message = 'invalid anonymous transfer token';
  end if;

  if transfer_row.status = 'consumed' then
    if transfer_row.target_owner_id <> p_target_owner_id then
      raise exception using
        errcode = '42501',
        message = 'anonymous transfer token has already been consumed';
    end if;

    return query select
      transfer_row.id,
      transfer_row.source_profile_id,
      transfer_row.target_owner_id,
      transfer_row.status,
      true;
    return;
  end if;

  if transfer_row.status in ('expired', 'cancelled') then
    return query select
      transfer_row.id,
      transfer_row.source_profile_id,
      null::uuid,
      transfer_row.status,
      false;
    return;
  end if;

  operation_time := clock_timestamp();

  if transfer_row.expires_at <= operation_time then
    update private.anonymous_transfers as transfer
    set status = 'expired'
    where transfer.id = transfer_row.id
    returning transfer.* into transfer_row;

    return query select
      transfer_row.id,
      transfer_row.source_profile_id,
      null::uuid,
      transfer_row.status,
      false;
    return;
  end if;

  perform 1
  from auth.users as account
  where account.id in (transfer_row.source_owner_id, p_target_owner_id)
  order by account.id
  for update;

  select source_user.is_anonymous
  into source_user_is_anonymous
  from auth.users as source_user
  where source_user.id = transfer_row.source_owner_id;

  select target_user.is_anonymous
  into target_user_is_anonymous
  from auth.users as target_user
  where target_user.id = p_target_owner_id;

  if source_user_is_anonymous is distinct from true then
    raise exception using
      errcode = '23514',
      message = 'anonymous transfer source account is not anonymous';
  end if;

  if target_user_is_anonymous is distinct from false then
    raise exception using
      errcode = '23514',
      message = 'anonymous transfer target account must be permanent';
  end if;

  select target_profile.id
  into target_active_profile_id
  from public.profiles as target_profile
  where target_profile.owner_id = p_target_owner_id
    and target_profile.status = 'active';

  perform 1
  from public.profiles as locked_profile
  where locked_profile.id in (
    transfer_row.source_profile_id,
    target_active_profile_id
  )
  order by locked_profile.id
  for update;

  if not exists (
    select 1
    from public.profiles as source_profile
    where source_profile.id = transfer_row.source_profile_id
      and source_profile.owner_id = transfer_row.source_owner_id
      and source_profile.revision = transfer_row.source_profile_revision
      and source_profile.status = 'draft'
      and source_profile.derived_from_profile_id is null
  ) then
    raise exception using
      errcode = '40001',
      message = 'anonymous transfer source draft no longer matches the prepared revision';
  end if;

  update public.profiles as source_profile
  set owner_id = p_target_owner_id
  where source_profile.id = transfer_row.source_profile_id
    and source_profile.owner_id = transfer_row.source_owner_id;

  get diagnostics moved_profile_count = row_count;
  if moved_profile_count <> 1 then
    raise exception using
      errcode = '40001',
      message = 'anonymous transfer source draft could not be moved';
  end if;

  update private.anonymous_transfers as transfer
  set
    target_owner_id = p_target_owner_id,
    status = 'consumed',
    consumed_at = operation_time
  where transfer.id = transfer_row.id
  returning transfer.* into transfer_row;

  return query select
    transfer_row.id,
    transfer_row.source_profile_id,
    transfer_row.target_owner_id,
    transfer_row.status,
    false;
end;
$function$;

comment on function private.consume_anonymous_transfer(bytea, uuid) is
  'Atomically consumes a 15-minute hashed token once, moving an anonymous root draft and its owned graph into a permanent account without replacing existing account state.';

revoke execute on function private.consume_anonymous_transfer(bytea, uuid)
  from public, anon, authenticated;
grant execute on function private.consume_anonymous_transfer(bytea, uuid)
  to service_role;

commit;
