begin;

set local lock_timeout = '5s';
set local statement_timeout = '30s';

create table public.consent_records (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null,
  profile_id uuid not null,
  purpose text not null,
  decision text not null,
  policy_version text not null,
  copy_sha256 bytea not null,
  captured_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  constraint consent_records_owner_profile_fk
    foreign key (owner_id, profile_id)
    references public.profiles(owner_id, id)
    on update cascade on delete cascade
    deferrable initially immediate,
  constraint consent_records_owner_id_key unique (owner_id, id),
  constraint consent_records_purpose_check check (
    purpose in (
      'profile_processing',
      'photo_analysis',
      'garment_extraction',
      'generated_likeness_preview',
      'account_connection',
      'live_camera',
      'live_microphone',
      'gemini_visual_context'
    )
  ),
  constraint consent_records_decision_check check (
    decision in ('granted', 'revoked')
  ),
  constraint consent_records_policy_version_check check (
    policy_version = btrim(policy_version)
    and char_length(policy_version) between 1 and 80
  ),
  constraint consent_records_copy_sha256_check check (
    octet_length(copy_sha256) = 32
  )
);

create index consent_records_owner_profile_idx
on public.consent_records (owner_id, profile_id);

create index consent_records_current_idx
on public.consent_records (
  profile_id,
  purpose,
  captured_at desc,
  id desc
);

create function private.enforce_consent_event_immutability()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $function$
begin
  if current_user = 'postgres'
    and row(
      new.id,
      new.profile_id,
      new.purpose,
      new.decision,
      new.policy_version,
      new.copy_sha256,
      new.captured_at,
      new.created_at
    ) is not distinct from row(
      old.id,
      old.profile_id,
      old.purpose,
      old.decision,
      old.policy_version,
      old.copy_sha256,
      old.captured_at,
      old.created_at
    )
  then
    return new;
  end if;

  raise exception using
    errcode = '23514',
    message = 'consent events are append-only';
end;
$function$;

comment on function private.enforce_consent_event_immutability() is
  'Rejects consent-event mutation while permitting only the system owner reassignment used by anonymous-account transfer.';

revoke execute on function private.enforce_consent_event_immutability()
  from public, anon, authenticated, service_role;

create trigger consent_records_enforce_immutability
before update on public.consent_records
for each row execute function private.enforce_consent_event_immutability();

alter table public.consent_records enable row level security;

revoke all privileges on table public.consent_records
  from public, anon, authenticated, service_role;

grant select, insert on table public.consent_records to authenticated;
grant select, insert on table public.consent_records to service_role;

create policy consent_records_select_own
on public.consent_records for select
to authenticated
using (
  (select auth.uid()) is not null
  and owner_id = (select auth.uid())
);

create policy consent_records_insert_own
on public.consent_records for insert
to authenticated
with check (
  (select auth.uid()) is not null
  and owner_id = (select auth.uid())
);

commit;
