begin;

set local lock_timeout = '5s';
set local statement_timeout = '30s';

create table public.favorite_brands (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null,
  profile_id uuid not null,
  brand_name text not null,
  brand_key text not null,
  preference_order smallint not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint favorite_brands_owner_profile_fk
    foreign key (owner_id, profile_id)
    references public.profiles(owner_id, id)
    on update cascade on delete cascade
    deferrable initially immediate,
  constraint favorite_brands_owner_id_key unique (owner_id, id),
  constraint favorite_brands_brand_name_check check (
    brand_name = btrim(brand_name)
    and char_length(brand_name) between 1 and 80
  ),
  constraint favorite_brands_brand_key_check check (
    brand_key = lower(
      regexp_replace(btrim(brand_key), '[[:space:]]+', ' ', 'g')
    )
    and char_length(brand_key) between 1 and 80
  ),
  constraint favorite_brands_preference_order_check check (
    preference_order between 1 and 20
  )
);

create unique index favorite_brands_profile_order_idx
on public.favorite_brands (profile_id, preference_order);

create unique index favorite_brands_profile_key_idx
on public.favorite_brands (profile_id, brand_key);

create table public.brand_sizes (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null,
  profile_id uuid not null,
  brand_name text not null,
  brand_key text not null,
  garment_type text not null,
  size_status text not null,
  size_label text,
  preference_order smallint not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint brand_sizes_owner_profile_fk
    foreign key (owner_id, profile_id)
    references public.profiles(owner_id, id)
    on update cascade on delete cascade
    deferrable initially immediate,
  constraint brand_sizes_favorite_brand_fk
    foreign key (profile_id, brand_key)
    references public.favorite_brands(profile_id, brand_key)
    on update cascade on delete cascade
    deferrable initially immediate,
  constraint brand_sizes_owner_id_key unique (owner_id, id),
  constraint brand_sizes_brand_name_check check (
    brand_name = btrim(brand_name)
    and char_length(brand_name) between 1 and 80
  ),
  constraint brand_sizes_brand_key_check check (
    brand_key = lower(
      regexp_replace(btrim(brand_key), '[[:space:]]+', ' ', 'g')
    )
    and char_length(brand_key) between 1 and 80
  ),
  constraint brand_sizes_garment_type_check check (
    garment_type in (
      'tops',
      'knitwear',
      'dresses',
      'skirts',
      'jeans',
      'trousers',
      'shorts',
      'outerwear',
      'activewear',
      'swimwear',
      'shoes',
      'other'
    )
  ),
  constraint brand_sizes_size_status_check check (
    size_status in ('known', 'unknown', 'not_applicable')
  ),
  constraint brand_sizes_size_label_check check (
    (
      size_status = 'known'
      and size_label is not null
      and size_label = btrim(size_label)
      and char_length(size_label) between 1 and 40
    )
    or (
      size_status in ('unknown', 'not_applicable')
      and size_label is null
    )
  ),
  constraint brand_sizes_preference_order_check check (
    preference_order between 1 and 20
  )
);

create index brand_sizes_profile_order_idx
on public.brand_sizes (profile_id, preference_order, id);

create unique index brand_sizes_profile_brand_garment_type_idx
on public.brand_sizes (profile_id, brand_key, garment_type);

create function private.enforce_draft_profile_evidence()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $function$
declare
  evidence_owner_id uuid;
  evidence_profile_id uuid;
  parent_status text;
begin
  if current_user = 'postgres' then
    if tg_op = 'DELETE' then
      return old;
    end if;
    return new;
  end if;

  if tg_op = 'DELETE' then
    evidence_owner_id := old.owner_id;
    evidence_profile_id := old.profile_id;
  else
    evidence_owner_id := new.owner_id;
    evidence_profile_id := new.profile_id;
  end if;

  select profile.status
  into parent_status
  from public.profiles as profile
  where profile.id = evidence_profile_id
    and profile.owner_id = evidence_owner_id;

  if parent_status is null then
    if tg_op = 'DELETE' then
      return old;
    end if;

    raise exception using
      errcode = '23503',
      message = 'profile evidence requires an owned parent profile';
  end if;

  if parent_status <> 'draft' then
    raise exception using
      errcode = '23514',
      message = 'profile evidence is immutable after submission';
  end if;

  if tg_op = 'UPDATE' then
    if new.id is distinct from old.id then
      raise exception using
        errcode = '23514',
        message = 'profile evidence ID is immutable';
    end if;

    if new.owner_id is distinct from old.owner_id
      and current_user <> 'postgres'
    then
      raise exception using
        errcode = '23514',
        message = 'profile evidence owner is immutable outside the transfer transaction';
    end if;

    if new.profile_id is distinct from old.profile_id then
      raise exception using
        errcode = '23514',
        message = 'profile evidence parent is immutable';
    end if;

    if new.created_at is distinct from old.created_at then
      raise exception using
        errcode = '23514',
        message = 'profile evidence creation time is immutable';
    end if;
  end if;

  if tg_op = 'DELETE' then
    return old;
  end if;
  return new;
end;
$function$;

comment on function private.enforce_draft_profile_evidence() is
  'Keeps favorite-brand and garment-size evidence owned, immutable by identity, and writable only while the parent profile is a draft.';

revoke execute on function private.enforce_draft_profile_evidence()
  from public, anon, authenticated, service_role;

create trigger favorite_brands_enforce_draft_profile
before insert or update or delete on public.favorite_brands
for each row execute function private.enforce_draft_profile_evidence();

create trigger favorite_brands_set_updated_at
before update on public.favorite_brands
for each row execute function private.set_updated_at();

create trigger brand_sizes_enforce_draft_profile
before insert or update or delete on public.brand_sizes
for each row execute function private.enforce_draft_profile_evidence();

create trigger brand_sizes_set_updated_at
before update on public.brand_sizes
for each row execute function private.set_updated_at();

alter table public.favorite_brands enable row level security;
alter table public.brand_sizes enable row level security;

revoke all privileges on table public.favorite_brands
  from public, anon, authenticated, service_role;
revoke all privileges on table public.brand_sizes
  from public, anon, authenticated, service_role;

grant select, insert, delete on table public.favorite_brands to authenticated;
grant update (
  brand_name,
  brand_key,
  preference_order
) on table public.favorite_brands to authenticated;

grant select, insert, delete on table public.brand_sizes to authenticated;
grant update (
  brand_name,
  brand_key,
  garment_type,
  size_status,
  size_label,
  preference_order
) on table public.brand_sizes to authenticated;

grant select, insert, update, delete on table public.favorite_brands
  to service_role;
grant select, insert, update, delete on table public.brand_sizes
  to service_role;

create policy favorite_brands_select_own
on public.favorite_brands for select
to authenticated
using (
  (select auth.uid()) is not null
  and owner_id = (select auth.uid())
);

create policy favorite_brands_insert_own_draft
on public.favorite_brands for insert
to authenticated
with check (
  (select auth.uid()) is not null
  and owner_id = (select auth.uid())
  and exists (
    select 1
    from public.profiles as profile
    where profile.id = favorite_brands.profile_id
      and profile.owner_id = favorite_brands.owner_id
      and profile.status = 'draft'
  )
);

create policy favorite_brands_update_own_draft
on public.favorite_brands for update
to authenticated
using (
  (select auth.uid()) is not null
  and owner_id = (select auth.uid())
  and exists (
    select 1
    from public.profiles as profile
    where profile.id = favorite_brands.profile_id
      and profile.owner_id = favorite_brands.owner_id
      and profile.status = 'draft'
  )
)
with check (
  (select auth.uid()) is not null
  and owner_id = (select auth.uid())
  and exists (
    select 1
    from public.profiles as profile
    where profile.id = favorite_brands.profile_id
      and profile.owner_id = favorite_brands.owner_id
      and profile.status = 'draft'
  )
);

create policy favorite_brands_delete_own_draft
on public.favorite_brands for delete
to authenticated
using (
  (select auth.uid()) is not null
  and owner_id = (select auth.uid())
  and exists (
    select 1
    from public.profiles as profile
    where profile.id = favorite_brands.profile_id
      and profile.owner_id = favorite_brands.owner_id
      and profile.status = 'draft'
  )
);

create policy brand_sizes_select_own
on public.brand_sizes for select
to authenticated
using (
  (select auth.uid()) is not null
  and owner_id = (select auth.uid())
);

create policy brand_sizes_insert_own_draft
on public.brand_sizes for insert
to authenticated
with check (
  (select auth.uid()) is not null
  and owner_id = (select auth.uid())
  and exists (
    select 1
    from public.profiles as profile
    where profile.id = brand_sizes.profile_id
      and profile.owner_id = brand_sizes.owner_id
      and profile.status = 'draft'
  )
);

create policy brand_sizes_update_own_draft
on public.brand_sizes for update
to authenticated
using (
  (select auth.uid()) is not null
  and owner_id = (select auth.uid())
  and exists (
    select 1
    from public.profiles as profile
    where profile.id = brand_sizes.profile_id
      and profile.owner_id = brand_sizes.owner_id
      and profile.status = 'draft'
  )
)
with check (
  (select auth.uid()) is not null
  and owner_id = (select auth.uid())
  and exists (
    select 1
    from public.profiles as profile
    where profile.id = brand_sizes.profile_id
      and profile.owner_id = brand_sizes.owner_id
      and profile.status = 'draft'
  )
);

create policy brand_sizes_delete_own_draft
on public.brand_sizes for delete
to authenticated
using (
  (select auth.uid()) is not null
  and owner_id = (select auth.uid())
  and exists (
    select 1
    from public.profiles as profile
    where profile.id = brand_sizes.profile_id
      and profile.owner_id = brand_sizes.owner_id
      and profile.status = 'draft'
  )
);

commit;
