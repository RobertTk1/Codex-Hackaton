begin;

set local lock_timeout = '5s';
set local statement_timeout = '30s';

create table private.notification_deliveries (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null,
  profile_id uuid not null,
  report_id uuid not null,
  kind text not null,
  status text not null default 'queued',
  idempotency_key text not null,
  provider_message_ref text,
  attempt_count smallint not null default 0,
  last_error_code text,
  sent_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint notification_deliveries_report_fk
    foreign key (owner_id, profile_id, report_id)
    references public.style_reports(owner_id, profile_id, id)
    on update cascade
    on delete cascade,
  constraint notification_deliveries_kind_check check (
    kind = 'report_ready'
  ),
  constraint notification_deliveries_status_check check (
    status in ('queued', 'sent', 'failed')
  ),
  constraint notification_deliveries_idempotency_key_check check (
    idempotency_key = btrim(idempotency_key)
    and char_length(idempotency_key) between 1 and 512
  ),
  constraint notification_deliveries_provider_message_ref_check check (
    provider_message_ref is null
    or (
      provider_message_ref = btrim(provider_message_ref)
      and char_length(provider_message_ref) between 1 and 512
    )
  ),
  constraint notification_deliveries_attempt_count_check check (
    attempt_count between 0 and 3
  ),
  constraint notification_deliveries_last_error_code_check check (
    last_error_code is null
    or (
      last_error_code = btrim(last_error_code)
      and char_length(last_error_code) between 1 and 80
    )
  ),
  constraint notification_deliveries_state_check check (
    case status
      when 'queued' then
        provider_message_ref is null
        and last_error_code is null
        and sent_at is null
      when 'sent' then
        attempt_count >= 1
        and provider_message_ref is not null
        and last_error_code is null
        and sent_at is not null
      when 'failed' then
        attempt_count >= 1
        and provider_message_ref is null
        and last_error_code is not null
        and sent_at is null
      else false
    end
  )
);

alter table private.notification_deliveries enable row level security;

revoke all privileges on table private.notification_deliveries
  from public, anon, authenticated, service_role;
grant select, insert, update, delete on table private.notification_deliveries
  to service_role;

create unique index notification_delivery_key_idx
on private.notification_deliveries (idempotency_key);

create unique index notification_deliveries_report_kind_idx
on private.notification_deliveries (report_id, kind);

create index notification_deliveries_owner_profile_idx
on private.notification_deliveries (owner_id, profile_id);

create index notification_deliveries_cleanup_idx
on private.notification_deliveries (updated_at, id)
where status in ('sent', 'failed');

create function private.enforce_notification_delivery_transition()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $function$
begin
  if tg_op = 'INSERT' then
    if new.status <> 'queued' or new.attempt_count <> 0 then
      raise exception using
        errcode = '23514',
        message = 'notification delivery must begin as an unattempted request';
    end if;

    return new;
  end if;

  if new.id is distinct from old.id
    or new.owner_id is distinct from old.owner_id
    or new.profile_id is distinct from old.profile_id
    or new.report_id is distinct from old.report_id
    or new.kind is distinct from old.kind
    or new.idempotency_key is distinct from old.idempotency_key
    or new.created_at is distinct from old.created_at
  then
    raise exception using
      errcode = '23514',
      message = 'notification delivery identity is immutable';
  end if;

  if new.attempt_count < old.attempt_count
    or new.attempt_count > old.attempt_count + 1
  then
    raise exception using
      errcode = '23514',
      message = 'notification delivery attempts must advance one at a time';
  end if;

  if old.status = 'sent' and row(
    new.status,
    new.provider_message_ref,
    new.attempt_count,
    new.last_error_code,
    new.sent_at
  ) is distinct from row(
    old.status,
    old.provider_message_ref,
    old.attempt_count,
    old.last_error_code,
    old.sent_at
  ) then
    raise exception using
      errcode = '23514',
      message = 'sent notification delivery is terminal';
  end if;

  if old.status = 'failed' then
    if new.status = 'queued'
      and new.attempt_count <> old.attempt_count + 1
    then
      raise exception using
        errcode = '23514',
        message = 'notification delivery retry must increment attempt count';
    elsif new.status = 'failed' and row(
      new.provider_message_ref,
      new.attempt_count,
      new.last_error_code,
      new.sent_at
    ) is distinct from row(
      old.provider_message_ref,
      old.attempt_count,
      old.last_error_code,
      old.sent_at
    ) then
      raise exception using
        errcode = '23514',
        message = 'failed notification delivery must retry before changing';
    elsif new.status not in ('failed', 'queued') then
      raise exception using
        errcode = '23514',
        message = 'failed notification delivery must retry before success';
    end if;
  elsif old.status = 'queued' and new.status = 'queued'
    and new.attempt_count = old.attempt_count
  then
    raise exception using
      errcode = '23514',
      message = 'notification delivery claim must increment attempt count';
  end if;

  return new;
end;
$function$;

comment on function private.enforce_notification_delivery_transition() is
  'Keeps report-ready notification retries bounded and successful delivery terminal.';

revoke execute on function private.enforce_notification_delivery_transition()
  from public, anon, authenticated, service_role;

create trigger notification_deliveries_enforce_transition
before insert or update on private.notification_deliveries
for each row execute function private.enforce_notification_delivery_transition();

create trigger notification_deliveries_set_updated_at
before update on private.notification_deliveries
for each row execute function private.set_updated_at();

commit;
