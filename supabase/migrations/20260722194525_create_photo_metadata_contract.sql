begin;

set local lock_timeout = '5s';
set local statement_timeout = '30s';

create table public.photos (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null,
  profile_id uuid not null,
  storage_path text not null,
  status text not null default 'uploaded',
  position smallint not null,
  media_type text not null,
  byte_size bigint not null,
  width_px integer not null,
  height_px integer not null,
  sha256 bytea not null,
  rejection_code text,
  accepted_at timestamptz,
  expires_at timestamptz not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint photos_owner_profile_fk
    foreign key (owner_id, profile_id)
    references public.profiles(owner_id, id)
    on update cascade
    on delete cascade
    deferrable initially immediate,
  constraint photos_owner_id_key unique (owner_id, id),
  constraint photos_storage_path_key unique (storage_path),
  constraint photos_profile_position_key
    unique (profile_id, position)
    deferrable initially immediate,
  constraint photos_profile_sha_idx unique (profile_id, sha256),
  constraint photos_position_check check (position between 1 and 12),
  constraint photos_storage_path_check check (
    storage_path = btrim(storage_path)
    and char_length(storage_path) between 1 and 1024
  ),
  constraint photos_status_check check (
    status in (
      'uploaded',
      'accepted',
      'rejected',
      'processing',
      'partial',
      'complete',
      'failed'
    )
  ),
  constraint photos_media_type_check check (
    media_type in (
      'image/jpeg',
      'image/png',
      'image/webp',
      'image/heic',
      'image/heif'
    )
  ),
  constraint photos_byte_size_check check (
    byte_size between 1 and 15728640
  ),
  constraint photos_width_px_check check (width_px between 640 and 12000),
  constraint photos_height_px_check check (height_px between 640 and 12000),
  constraint photos_sha256_check check (octet_length(sha256) = 32),
  constraint photos_rejection_code_check check (
    rejection_code is null
    or (
      rejection_code = btrim(rejection_code)
      and char_length(rejection_code) between 1 and 80
    )
  ),
  constraint photos_expiry_check check (expires_at > created_at),
  constraint photos_state_check check (
    (
      status = 'uploaded'
      and accepted_at is null
      and rejection_code is null
    )
    or (
      status in ('accepted', 'processing', 'complete')
      and accepted_at is not null
      and rejection_code is null
    )
    or (
      status = 'rejected'
      and accepted_at is null
      and rejection_code is not null
    )
    or (
      status in ('partial', 'failed')
      and accepted_at is not null
      and rejection_code is not null
    )
  )
);

create index photos_owner_profile_idx
on public.photos (owner_id, profile_id);

create index photos_profile_status_idx
on public.photos (profile_id, status, position);

create index photos_expiry_idx
on public.photos (expires_at, id);

create function private.enforce_photo_contract()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $function$
declare
  parent_status text;
begin
  if tg_op = 'INSERT' then
    if new.status <> 'uploaded' then
      raise exception using
        errcode = '23514',
        message = 'photo metadata must begin in uploaded state';
    end if;

    if new.expires_at <= transaction_timestamp()
      or new.expires_at > transaction_timestamp() + interval '7 days'
    then
      raise exception using
        errcode = '23514',
        message = 'photo metadata requires a future initial deadline no later than seven days';
    end if;
  else
    if new.id is distinct from old.id
      or new.profile_id is distinct from old.profile_id
      or new.storage_path is distinct from old.storage_path
      or new.media_type is distinct from old.media_type
      or new.byte_size is distinct from old.byte_size
      or new.width_px is distinct from old.width_px
      or new.height_px is distinct from old.height_px
      or new.sha256 is distinct from old.sha256
      or new.created_at is distinct from old.created_at
    then
      raise exception using
        errcode = '23514',
        message = 'verified photo identity and object metadata are immutable';
    end if;

    if new.owner_id is distinct from old.owner_id
      and current_user <> 'postgres'
    then
      raise exception using
        errcode = '23514',
        message = 'photo owner is immutable outside the transfer transaction';
    end if;

    if new.expires_at > old.expires_at then
      raise exception using
        errcode = '23514',
        message = 'photo deadline cannot be extended outside a named retention transaction';
    end if;

    if old.expires_at <= transaction_timestamp()
      and row(
        new.position,
        new.status,
        new.accepted_at,
        new.rejection_code
      ) is distinct from row(
        old.position,
        old.status,
        old.accepted_at,
        old.rejection_code
      )
    then
      raise exception using
        errcode = '23514',
        message = 'expired photo metadata cannot be processed or reordered';
    end if;

    if new.status is distinct from old.status
      and not (
        (old.status = 'uploaded' and new.status in ('accepted', 'rejected'))
        or (old.status = 'accepted' and new.status = 'processing')
        or (old.status = 'processing' and new.status in ('complete', 'partial', 'failed'))
        or (old.status in ('partial', 'failed') and new.status = 'processing')
      )
    then
      raise exception using
        errcode = '23514',
        message = 'invalid photo state transition';
    end if;
  end if;

  if tg_op = 'INSERT'
    or row(new.position, new.status, new.accepted_at, new.rejection_code)
      is distinct from row(old.position, old.status, old.accepted_at, old.rejection_code)
  then
    select profile.status
    into parent_status
    from public.profiles as profile
    where profile.id = new.profile_id;

    if parent_status is distinct from 'draft' then
      raise exception using
        errcode = '23514',
        message = 'photo evidence is mutable only while the owning profile is draft';
    end if;
  end if;

  return new;
end;
$function$;

comment on function private.enforce_photo_contract() is
  'Enforces photo identity, draft mutation, bounded initial expiry, transition, and transfer invariants.';

revoke execute on function private.enforce_photo_contract()
  from public, anon, authenticated, service_role;

create trigger photos_enforce_contract
before insert or update on public.photos
for each row execute function private.enforce_photo_contract();

create trigger photos_set_updated_at
before update on public.photos
for each row execute function private.set_updated_at();

alter table public.photos enable row level security;

revoke all privileges on table public.photos
  from public, anon, authenticated, service_role;
grant select on table public.photos to authenticated;
grant select, insert, update, delete on table public.photos to service_role;

create policy photos_select_own_unexpired
on public.photos for select
to authenticated
using (
  (select auth.uid()) is not null
  and owner_id = (select auth.uid())
  and expires_at > transaction_timestamp()
);

commit;
