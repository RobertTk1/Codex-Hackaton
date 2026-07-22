begin;

set local lock_timeout = '5s';
set local statement_timeout = '30s';

create table public.taste_candidates (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null,
  profile_id uuid not null,
  source text not null,
  extracted_garment_id uuid,
  source_fingerprint bytea,
  catalog_product_ref text,
  catalog_variant_ref text,
  catalog_shop_ref text,
  curated_asset_key text,
  category text not null,
  color_family text not null,
  silhouette text not null,
  representation_tags text[] not null default '{}'::text[],
  position smallint not null,
  status text not null default 'ready',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint taste_candidates_owner_profile_fk
    foreign key (owner_id, profile_id)
    references public.profiles(owner_id, id)
    on update cascade
    on delete cascade
    deferrable initially immediate,
  constraint taste_candidates_extracted_garment_fk
    foreign key (extracted_garment_id)
    references public.extracted_garments(id)
    on delete set null
    deferrable initially immediate,
  constraint taste_candidates_owner_id_key unique (owner_id, id),
  constraint taste_candidates_owner_profile_id_key
    unique (owner_id, profile_id, id),
  constraint taste_candidates_source_check check (
    source in ('extracted_garment', 'shopify_catalog', 'curated_fallback')
  ),
  constraint taste_candidates_fingerprint_check check (
    source_fingerprint is null
    or octet_length(source_fingerprint) = 32
  ),
  constraint taste_candidates_catalog_product_ref_check check (
    catalog_product_ref is null
    or (
      catalog_product_ref = btrim(catalog_product_ref)
      and char_length(catalog_product_ref) between 1 and 512
    )
  ),
  constraint taste_candidates_catalog_variant_ref_check check (
    catalog_variant_ref is null
    or (
      catalog_variant_ref = btrim(catalog_variant_ref)
      and char_length(catalog_variant_ref) between 1 and 512
    )
  ),
  constraint taste_candidates_catalog_shop_ref_check check (
    catalog_shop_ref is null
    or (
      catalog_shop_ref = btrim(catalog_shop_ref)
      and char_length(catalog_shop_ref) between 1 and 512
    )
  ),
  constraint taste_candidates_curated_asset_key_check check (
    curated_asset_key is null
    or (
      char_length(curated_asset_key) between 1 and 240
      and curated_asset_key = btrim(curated_asset_key)
      and curated_asset_key !~ '(^/|\\.\\.|://)'
      and curated_asset_key ~ '^[A-Za-z0-9][A-Za-z0-9._/-]*$'
    )
  ),
  constraint taste_candidates_category_check check (
    category = btrim(category)
    and char_length(category) between 1 and 80
  ),
  constraint taste_candidates_color_family_check check (
    color_family = btrim(color_family)
    and char_length(color_family) between 1 and 80
  ),
  constraint taste_candidates_silhouette_check check (
    silhouette = btrim(silhouette)
    and char_length(silhouette) between 1 and 80
  ),
  constraint taste_candidates_representation_tags_check check (
    private.extraction_text_array_is_valid(representation_tags, 8, 80)
  ),
  constraint taste_candidates_position_check check (position between 1 and 20),
  constraint taste_candidates_status_check check (
    status in ('ready', 'unavailable', 'retired')
  ),
  constraint taste_candidates_source_family_check check (
    (
      source = 'extracted_garment'
      and source_fingerprint is not null
      and catalog_product_ref is null
      and catalog_variant_ref is null
      and catalog_shop_ref is null
      and curated_asset_key is null
    )
    or (
      source = 'shopify_catalog'
      and extracted_garment_id is null
      and source_fingerprint is null
      and catalog_product_ref is not null
      and catalog_shop_ref is not null
      and curated_asset_key is null
    )
    or (
      source = 'curated_fallback'
      and extracted_garment_id is null
      and source_fingerprint is null
      and catalog_product_ref is null
      and catalog_variant_ref is null
      and catalog_shop_ref is null
      and curated_asset_key is not null
    )
  )
);

create unique index taste_candidates_profile_position_idx
on public.taste_candidates (profile_id, position);

create unique index taste_candidates_profile_fingerprint_idx
on public.taste_candidates (profile_id, source_fingerprint)
where source = 'extracted_garment';

create index taste_candidates_extracted_garment_id_idx
on public.taste_candidates (extracted_garment_id)
where extracted_garment_id is not null;

create table public.taste_reactions (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null,
  profile_id uuid not null,
  candidate_id uuid not null,
  reaction text not null,
  undone_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint taste_reactions_owner_profile_fk
    foreign key (owner_id, profile_id)
    references public.profiles(owner_id, id)
    on update cascade
    on delete cascade
    deferrable initially immediate,
  constraint taste_reactions_owner_profile_candidate_fk
    foreign key (owner_id, profile_id, candidate_id)
    references public.taste_candidates(owner_id, profile_id, id)
    on update cascade
    on delete cascade
    deferrable initially immediate,
  constraint taste_reactions_owner_id_key unique (owner_id, id),
  constraint taste_reactions_reaction_check check (
    reaction in ('love', 'hate', 'maybe')
  ),
  constraint taste_reactions_undone_at_check check (
    undone_at is null or undone_at >= created_at
  )
);

create unique index taste_reactions_candidate_idx
on public.taste_reactions (candidate_id);

create index taste_reactions_profile_active_idx
on public.taste_reactions (profile_id, created_at, id)
where undone_at is null;

create index taste_reactions_owner_profile_candidate_idx
on public.taste_reactions (owner_id, profile_id, candidate_id);

create function private.enforce_taste_candidate_contract()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $function$
declare
  parent_status text;
  source_garment public.extracted_garments%rowtype;
  current_candidate_count integer;
begin
  if tg_op = 'UPDATE' and new.owner_id is distinct from old.owner_id then
    if current_user <> 'postgres' then
      raise exception using
        errcode = '23514',
        message = 'taste candidate owner is immutable outside the transfer transaction';
    end if;

    if row(
      new.id,
      new.profile_id,
      new.source,
      new.extracted_garment_id,
      new.source_fingerprint,
      new.catalog_product_ref,
      new.catalog_variant_ref,
      new.catalog_shop_ref,
      new.curated_asset_key,
      new.category,
      new.color_family,
      new.silhouette,
      new.representation_tags,
      new.position,
      new.status,
      new.created_at
    ) is distinct from row(
      old.id,
      old.profile_id,
      old.source,
      old.extracted_garment_id,
      old.source_fingerprint,
      old.catalog_product_ref,
      old.catalog_variant_ref,
      old.catalog_shop_ref,
      old.curated_asset_key,
      old.category,
      old.color_family,
      old.silhouette,
      old.representation_tags,
      old.position,
      old.status,
      old.created_at
    ) then
      raise exception using
        errcode = '23514',
        message = 'taste candidate owner transfer cannot change candidate evidence';
    end if;

    return new;
  end if;

  select profile.status
  into parent_status
  from public.profiles as profile
  where profile.id = new.profile_id
    and profile.owner_id = new.owner_id;

  if parent_status is null then
    raise exception using
      errcode = '23514',
      message = 'taste candidate must belong to one owned profile';
  end if;

  if tg_op = 'INSERT' then
    if parent_status <> 'draft' then
      raise exception using
        errcode = '23514',
        message = 'taste candidates can be created only for a draft profile';
    end if;

    select count(*)
    into current_candidate_count
    from public.taste_candidates as candidate
    where candidate.profile_id = new.profile_id;

    if current_candidate_count >= 20 then
      raise exception using
        errcode = '23514',
        message = 'a profile can retain at most twenty taste candidates';
    end if;

    if new.source = 'extracted_garment' then
      if new.extracted_garment_id is null then
        raise exception using
          errcode = '23514',
          message = 'extracted-garment candidate requires its source at creation';
      end if;

      select garment.*
      into source_garment
      from public.extracted_garments as garment
      where garment.id = new.extracted_garment_id
        and garment.owner_id = new.owner_id
        and garment.profile_id = new.profile_id;

      if not found
        or source_garment.review_status = 'rejected'
        or source_garment.expires_at <= transaction_timestamp()
      then
        raise exception using
          errcode = '23514',
          message = 'extracted-garment candidate requires a current accepted owned source';
      end if;
    end if;

    return new;
  end if;

  if old.source = 'extracted_garment'
    and old.extracted_garment_id is not null
    and new.extracted_garment_id is null
    and row(
      new.id,
      new.owner_id,
      new.profile_id,
      new.source,
      new.source_fingerprint,
      new.catalog_product_ref,
      new.catalog_variant_ref,
      new.catalog_shop_ref,
      new.curated_asset_key,
      new.category,
      new.color_family,
      new.silhouette,
      new.representation_tags,
      new.position,
      new.status,
      new.created_at
    ) is not distinct from row(
      old.id,
      old.owner_id,
      old.profile_id,
      old.source,
      old.source_fingerprint,
      old.catalog_product_ref,
      old.catalog_variant_ref,
      old.catalog_shop_ref,
      old.curated_asset_key,
      old.category,
      old.color_family,
      old.silhouette,
      old.representation_tags,
      old.position,
      old.status,
      old.created_at
    )
  then
    return new;
  end if;

  if row(
    new.id,
    new.owner_id,
    new.profile_id,
    new.source,
    new.extracted_garment_id,
    new.source_fingerprint,
    new.catalog_product_ref,
    new.catalog_variant_ref,
    new.catalog_shop_ref,
    new.curated_asset_key,
    new.category,
    new.color_family,
    new.silhouette,
    new.representation_tags,
    new.position,
    new.created_at
  ) is distinct from row(
    old.id,
    old.owner_id,
    old.profile_id,
    old.source,
    old.extracted_garment_id,
    old.source_fingerprint,
    old.catalog_product_ref,
    old.catalog_variant_ref,
    old.catalog_shop_ref,
    old.curated_asset_key,
    old.category,
    old.color_family,
    old.silhouette,
    old.representation_tags,
    old.position,
    old.created_at
  ) then
    raise exception using
      errcode = '23514',
      message = 'taste candidate source and balancing evidence is immutable';
  end if;

  if parent_status <> 'draft' and new.status is distinct from old.status then
    raise exception using
      errcode = '23514',
      message = 'submitted taste candidate state is immutable';
  end if;

  if old.status = 'retired' and new.status is distinct from old.status then
    raise exception using
      errcode = '23514',
      message = 'retired taste candidate state is terminal';
  end if;

  return new;
end;
$function$;

comment on function private.enforce_taste_candidate_contract() is
  'Enforces bounded draft-only candidate creation, exact source lineage, immutable balance evidence, and source-purge survival.';

revoke execute on function private.enforce_taste_candidate_contract()
  from public, anon, authenticated, service_role;

create trigger taste_candidates_enforce_contract
before insert or update on public.taste_candidates
for each row execute function private.enforce_taste_candidate_contract();

create trigger taste_candidates_set_updated_at
before update on public.taste_candidates
for each row execute function private.set_updated_at();

create function private.enforce_taste_reaction_contract()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $function$
declare
  parent_status text;
  candidate_status text;
  current_active_count integer;
begin
  if tg_op = 'UPDATE' and new.owner_id is distinct from old.owner_id then
    if current_user <> 'postgres' then
      raise exception using
        errcode = '23514',
        message = 'taste reaction owner is immutable outside the transfer transaction';
    end if;

    if row(
      new.id,
      new.profile_id,
      new.candidate_id,
      new.reaction,
      new.undone_at,
      new.created_at
    ) is distinct from row(
      old.id,
      old.profile_id,
      old.candidate_id,
      old.reaction,
      old.undone_at,
      old.created_at
    ) then
      raise exception using
        errcode = '23514',
        message = 'taste reaction owner transfer cannot change reaction evidence';
    end if;

    return new;
  end if;

  select profile.status, candidate.status
  into parent_status, candidate_status
  from public.profiles as profile
  join public.taste_candidates as candidate
    on candidate.profile_id = profile.id
    and candidate.owner_id = profile.owner_id
  where profile.id = new.profile_id
    and profile.owner_id = new.owner_id
    and candidate.id = new.candidate_id;

  if parent_status is null then
    raise exception using
      errcode = '23514',
      message = 'taste reaction must match one owned profile and candidate';
  end if;

  if parent_status <> 'draft' then
    raise exception using
      errcode = '23514',
      message = 'taste reactions are mutable only while the profile is draft';
  end if;

  if tg_op = 'INSERT' then
    if candidate_status <> 'ready' then
      raise exception using
        errcode = '23514',
        message = 'taste reaction requires a ready candidate';
    end if;

    if new.undone_at is not null then
      raise exception using
        errcode = '23514',
        message = 'new taste reaction must begin active';
    end if;

    select count(*)
    into current_active_count
    from public.taste_reactions as reaction_record
    where reaction_record.profile_id = new.profile_id
      and reaction_record.undone_at is null;

    if current_active_count >= 20 then
      raise exception using
        errcode = '23514',
        message = 'a profile can retain at most twenty active taste reactions';
    end if;

    return new;
  end if;

  if row(
    new.id,
    new.owner_id,
    new.profile_id,
    new.candidate_id,
    new.created_at
  ) is distinct from row(
    old.id,
    old.owner_id,
    old.profile_id,
    old.candidate_id,
    old.created_at
  ) then
    raise exception using
      errcode = '23514',
      message = 'taste reaction identity is immutable';
  end if;

  if new.reaction is distinct from old.reaction and new.undone_at is not null then
    raise exception using
      errcode = '23514',
      message = 'changing a taste reaction must reactivate it';
  end if;

  if old.undone_at is null and new.undone_at is not null then
    new.undone_at := transaction_timestamp();
  elsif old.undone_at is not null and new.undone_at is not null
    and new.undone_at is distinct from old.undone_at
  then
    raise exception using
      errcode = '23514',
      message = 'taste reaction undo timestamp is immutable';
  end if;

  if new.undone_at is null
    and (
      old.undone_at is not null
      or new.reaction is distinct from old.reaction
    )
  then
    if candidate_status <> 'ready' then
      raise exception using
        errcode = '23514',
        message = 'active taste reaction requires a ready candidate';
    end if;

    select count(*)
    into current_active_count
    from public.taste_reactions as reaction_record
    where reaction_record.profile_id = new.profile_id
      and reaction_record.undone_at is null
      and reaction_record.id <> new.id;

    if current_active_count >= 20 then
      raise exception using
        errcode = '23514',
        message = 'a profile can retain at most twenty active taste reactions';
    end if;
  end if;

  return new;
end;
$function$;

comment on function private.enforce_taste_reaction_contract() is
  'Enforces owner/candidate lineage, a twenty-signal ceiling, draft-only reaction mutation, and server-timestamped auditable undo state.';

revoke execute on function private.enforce_taste_reaction_contract()
  from public, anon, authenticated, service_role;

create trigger taste_reactions_enforce_contract
before insert or update on public.taste_reactions
for each row execute function private.enforce_taste_reaction_contract();

create trigger taste_reactions_set_updated_at
before update on public.taste_reactions
for each row execute function private.set_updated_at();

alter table public.taste_candidates enable row level security;
alter table public.taste_reactions enable row level security;

revoke all privileges on table public.taste_candidates
  from public, anon, authenticated, service_role;
revoke all privileges on table public.taste_reactions
  from public, anon, authenticated, service_role;

grant select on table public.taste_candidates to authenticated;
grant select, insert, update on table public.taste_reactions to authenticated;

grant select, insert, update, delete on table public.taste_candidates
  to service_role;
grant select, insert, update, delete on table public.taste_reactions
  to service_role;

create policy taste_candidates_select_own
on public.taste_candidates for select
to authenticated
using (
  (select auth.uid()) is not null
  and owner_id = (select auth.uid())
);

create policy taste_reactions_select_own
on public.taste_reactions for select
to authenticated
using (
  (select auth.uid()) is not null
  and owner_id = (select auth.uid())
);

create policy taste_reactions_insert_own_draft
on public.taste_reactions for insert
to authenticated
with check (
  (select auth.uid()) is not null
  and owner_id = (select auth.uid())
  and undone_at is null
  and exists (
    select 1
    from public.profiles as profile
    join public.taste_candidates as candidate
      on candidate.profile_id = profile.id
      and candidate.owner_id = profile.owner_id
    where profile.id = profile_id
      and profile.owner_id = taste_reactions.owner_id
      and profile.status = 'draft'
      and candidate.id = candidate_id
      and candidate.status = 'ready'
  )
);

create policy taste_reactions_update_own_draft
on public.taste_reactions for update
to authenticated
using (
  (select auth.uid()) is not null
  and owner_id = (select auth.uid())
  and exists (
    select 1
    from public.profiles as profile
    where profile.id = profile_id
      and profile.owner_id = taste_reactions.owner_id
      and profile.status = 'draft'
  )
)
with check (
  (select auth.uid()) is not null
  and owner_id = (select auth.uid())
  and exists (
    select 1
    from public.profiles as profile
    where profile.id = profile_id
      and profile.owner_id = taste_reactions.owner_id
      and profile.status = 'draft'
  )
);

comment on table public.taste_candidates is
  'Bounded ordered candidate descriptors and stable source references; no catalog image, product body, price, inventory, or raw provider payload is stored.';

comment on table public.taste_reactions is
  'One bounded Love/Hate/Maybe state per candidate; undo is timestamped evidence rather than deletion.';

commit;
