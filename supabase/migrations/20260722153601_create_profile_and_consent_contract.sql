begin;

set local lock_timeout = '5s';
set local statement_timeout = '30s';

create table public.profiles (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null,
  derived_from_profile_id uuid,
  status text not null default 'draft',
  current_step text not null default 'welcome',
  revision integer not null default 1,
  name text,
  age smallint,
  adult_confirmed_at timestamptz,
  gender text,
  height_cm numeric(5, 2),
  weight_kg numeric(5, 2),
  fit_preference text,
  submitted_at timestamptz,
  last_activity_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint profiles_owner_fk
    foreign key (owner_id) references auth.users(id) on delete cascade,
  constraint profiles_derived_from_fk
    foreign key (derived_from_profile_id)
    references public.profiles(id) on delete set null,
  constraint profiles_owner_id_key unique (owner_id, id),
  constraint profiles_not_self_derived_check check (
    derived_from_profile_id is null or derived_from_profile_id <> id
  ),
  constraint profiles_status_check check (
    status in ('draft', 'submitted', 'active', 'archived')
  ),
  constraint profiles_current_step_check check (
    current_step in (
      'welcome',
      'personal_details',
      'brand_sizing',
      'photos',
      'photo_review',
      'taste',
      'account',
      'profile_review',
      'complete'
    )
  ),
  constraint profiles_revision_check check (revision >= 1),
  constraint profiles_name_check check (
    name is null
    or (
      name = btrim(name)
      and char_length(name) between 1 and 120
    )
  ),
  constraint profiles_age_check check (
    age is null or age between 18 and 120
  ),
  constraint profiles_gender_check check (
    gender is null
    or (
      gender = btrim(gender)
      and char_length(gender) between 1 and 80
    )
  ),
  constraint profiles_height_cm_check check (
    height_cm is null or height_cm between 80 and 250
  ),
  constraint profiles_weight_kg_check check (
    weight_kg is null or weight_kg between 25 and 400
  ),
  constraint profiles_fit_preference_check check (
    fit_preference is null
    or fit_preference in ('fitted', 'regular', 'relaxed', 'varies')
  ),
  constraint profiles_submission_state_check check (
    (
      status = 'draft'
      and submitted_at is null
    )
    or (
      status <> 'draft'
      and submitted_at is not null
      and name is not null
      and age is not null
      and adult_confirmed_at is not null
      and gender is not null
      and height_cm is not null
      and fit_preference is not null
      and current_step = 'complete'
    )
  )
);

create index profiles_derived_from_profile_id_idx
on public.profiles (derived_from_profile_id)
where derived_from_profile_id is not null;

create index profiles_owner_status_idx
on public.profiles (owner_id, status, updated_at desc, id desc);

create unique index profiles_one_active_idx
on public.profiles (owner_id)
where status = 'active';

create index profiles_anonymous_cleanup_idx
on public.profiles (last_activity_at, id)
where status = 'draft';

create function private.enforce_profile_contract()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $function$
begin
  if tg_op = 'UPDATE' then
    if new.id is distinct from old.id then
      raise exception using
        errcode = '23514',
        message = 'profile ID is immutable';
    end if;

    if new.owner_id is distinct from old.owner_id
      and current_user <> 'postgres'
    then
      raise exception using
        errcode = '23514',
        message = 'profile owner is immutable outside the transfer transaction';
    end if;

    if new.derived_from_profile_id is distinct from old.derived_from_profile_id
      and not (
        old.derived_from_profile_id is not null
        and new.derived_from_profile_id is null
      )
    then
      raise exception using
        errcode = '23514',
        message = 'profile lineage is immutable';
    end if;

    if new.created_at is distinct from old.created_at then
      raise exception using
        errcode = '23514',
        message = 'profile creation time is immutable';
    end if;

    if new.revision < old.revision then
      raise exception using
        errcode = '23514',
        message = 'profile revision cannot decrease';
    end if;

    if new.revision > old.revision + 1 then
      raise exception using
        errcode = '23514',
        message = 'profile revision can advance by only one';
    end if;

    if old.status <> 'draft'
      and row(
        new.name,
        new.age,
        new.adult_confirmed_at,
        new.gender,
        new.height_cm,
        new.weight_kg,
        new.fit_preference
      ) is distinct from row(
        old.name,
        old.age,
        old.adult_confirmed_at,
        old.gender,
        old.height_cm,
        old.weight_kg,
        old.fit_preference
      )
    then
      raise exception using
        errcode = '23514',
        message = 'submitted profile evidence is immutable';
    end if;

    if old.status = 'draft'
      and row(
        new.status,
        new.current_step,
        new.name,
        new.age,
        new.adult_confirmed_at,
        new.gender,
        new.height_cm,
        new.weight_kg,
        new.fit_preference,
        new.submitted_at
      ) is distinct from row(
        old.status,
        old.current_step,
        old.name,
        old.age,
        old.adult_confirmed_at,
        old.gender,
        old.height_cm,
        old.weight_kg,
        old.fit_preference,
        old.submitted_at
      )
      and new.revision <> old.revision + 1
    then
      raise exception using
        errcode = '23514',
        message = 'accepted draft mutations must advance the profile revision';
    end if;
  end if;

  if new.derived_from_profile_id is not null
    and not exists (
      select 1
      from public.profiles as source_profile
      where source_profile.id = new.derived_from_profile_id
        and source_profile.owner_id = new.owner_id
    )
  then
    raise exception using
      errcode = '23503',
      message = 'derived profile must reference a profile with the same owner';
  end if;

  return new;
end;
$function$;

comment on function private.enforce_profile_contract() is
  'Enforces profile ownership, lineage, evidence freeze, and revision invariants.';

revoke execute on function private.enforce_profile_contract()
  from public, anon, authenticated, service_role;

create trigger profiles_enforce_contract
before insert or update on public.profiles
for each row execute function private.enforce_profile_contract();

create trigger profiles_set_updated_at
before update on public.profiles
for each row execute function private.set_updated_at();

alter table public.profiles enable row level security;

revoke all privileges on table public.profiles
  from public, anon, authenticated, service_role;
grant select, insert, delete on table public.profiles to authenticated;
grant update (
  status,
  current_step,
  revision,
  name,
  age,
  adult_confirmed_at,
  gender,
  height_cm,
  weight_kg,
  fit_preference,
  submitted_at,
  last_activity_at
) on table public.profiles to authenticated;
grant select, insert, update, delete on table public.profiles to service_role;

create policy profiles_select_own
on public.profiles for select
to authenticated
using (
  (select auth.uid()) is not null
  and owner_id = (select auth.uid())
);

create policy profiles_insert_own
on public.profiles for insert
to authenticated
with check (
  (select auth.uid()) is not null
  and owner_id = (select auth.uid())
);

create policy profiles_update_own_draft
on public.profiles for update
to authenticated
using (
  (select auth.uid()) is not null
  and owner_id = (select auth.uid())
  and status = 'draft'
)
with check (
  (select auth.uid()) is not null
  and owner_id = (select auth.uid())
  and status = 'draft'
);

create policy profiles_delete_own_draft
on public.profiles for delete
to authenticated
using (
  (select auth.uid()) is not null
  and owner_id = (select auth.uid())
  and status = 'draft'
);

commit;
