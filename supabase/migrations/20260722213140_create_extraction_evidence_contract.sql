begin;

set local lock_timeout = '5s';
set local statement_timeout = '30s';

create table public.photo_style_signals (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null,
  profile_id uuid not null,
  photo_id uuid not null,
  dominant_colors text[] not null default '{}'::text[],
  categories text[] not null default '{}'::text[],
  silhouettes text[] not null default '{}'::text[],
  aesthetic_tags text[] not null default '{}'::text[],
  confidence numeric(4,3) not null,
  provider_name text not null,
  provider_model text not null,
  expires_at timestamptz not null,
  created_at timestamptz not null default now(),
  constraint photo_style_signals_owner_profile_fk
    foreign key (owner_id, profile_id)
    references public.profiles(owner_id, id)
    on update cascade
    on delete cascade
    deferrable initially immediate,
  constraint photo_style_signals_owner_photo_fk
    foreign key (owner_id, photo_id)
    references public.photos(owner_id, id)
    on update cascade
    on delete cascade
    deferrable initially immediate,
  constraint photo_style_signals_owner_id_key unique (owner_id, id),
  constraint photo_style_signals_dominant_colors_check check (
    cardinality(dominant_colors) <= 8
    and array_position(dominant_colors, null) is null
  ),
  constraint photo_style_signals_categories_check check (
    cardinality(categories) <= 8
    and array_position(categories, null) is null
  ),
  constraint photo_style_signals_silhouettes_check check (
    cardinality(silhouettes) <= 6
    and array_position(silhouettes, null) is null
  ),
  constraint photo_style_signals_aesthetic_tags_check check (
    cardinality(aesthetic_tags) <= 12
    and array_position(aesthetic_tags, null) is null
  ),
  constraint photo_style_signals_confidence_check check (
    confidence between 0 and 1
  ),
  constraint photo_style_signals_provider_name_check check (
    provider_name = btrim(provider_name)
    and char_length(provider_name) between 1 and 120
  ),
  constraint photo_style_signals_provider_model_check check (
    provider_model = btrim(provider_model)
    and char_length(provider_model) between 1 and 120
  ),
  constraint photo_style_signals_expiry_check check (expires_at > created_at)
);

create unique index photo_style_signals_photo_idx
on public.photo_style_signals (photo_id);

create index photo_style_signals_owner_profile_idx
on public.photo_style_signals (owner_id, profile_id);

create index photo_style_signals_expiry_idx
on public.photo_style_signals (expires_at, id);

create table public.extracted_garments (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null,
  profile_id uuid not null,
  source_photo_id uuid not null,
  source_kind text not null,
  category text not null,
  colors text[] not null default '{}'::text[],
  materials text[] not null default '{}'::text[],
  patterns text[] not null default '{}'::text[],
  silhouette text,
  fit text,
  confidence numeric(4,3) not null,
  duplicate_group_id uuid,
  review_status text not null default 'not_required',
  provider_name text not null,
  provider_model text not null,
  expires_at timestamptz not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint extracted_garments_owner_profile_fk
    foreign key (owner_id, profile_id)
    references public.profiles(owner_id, id)
    on update cascade
    on delete cascade
    deferrable initially immediate,
  constraint extracted_garments_owner_photo_fk
    foreign key (owner_id, source_photo_id)
    references public.photos(owner_id, id)
    on update cascade
    on delete cascade
    deferrable initially immediate,
  constraint extracted_garments_owner_id_key unique (owner_id, id),
  constraint extracted_garments_source_kind_check check (
    source_kind in ('wardrobe_extraction', 'direct_photo_signal')
  ),
  constraint extracted_garments_category_check check (
    category = btrim(category)
    and char_length(category) between 1 and 80
  ),
  constraint extracted_garments_colors_check check (
    cardinality(colors) <= 8
    and array_position(colors, null) is null
  ),
  constraint extracted_garments_materials_check check (
    cardinality(materials) <= 8
    and array_position(materials, null) is null
  ),
  constraint extracted_garments_patterns_check check (
    cardinality(patterns) <= 8
    and array_position(patterns, null) is null
  ),
  constraint extracted_garments_silhouette_check check (
    silhouette is null
    or (
      silhouette = btrim(silhouette)
      and char_length(silhouette) between 1 and 80
    )
  ),
  constraint extracted_garments_fit_check check (
    fit is null
    or (
      fit = btrim(fit)
      and char_length(fit) between 1 and 80
    )
  ),
  constraint extracted_garments_confidence_check check (
    confidence between 0 and 1
  ),
  constraint extracted_garments_review_status_check check (
    review_status in ('not_required', 'pending', 'confirmed', 'rejected')
  ),
  constraint extracted_garments_provider_name_check check (
    provider_name = btrim(provider_name)
    and char_length(provider_name) between 1 and 120
  ),
  constraint extracted_garments_provider_model_check check (
    provider_model = btrim(provider_model)
    and char_length(provider_model) between 1 and 120
  ),
  constraint extracted_garments_expiry_check check (expires_at > created_at)
);

create index extracted_garments_owner_profile_idx
on public.extracted_garments (owner_id, profile_id);

create index extracted_garments_photo_idx
on public.extracted_garments (
  source_photo_id,
  review_status,
  created_at,
  id
);

create index extracted_garments_profile_idx
on public.extracted_garments (profile_id, review_status, id);

create index extracted_garments_expiry_idx
on public.extracted_garments (expires_at, id);

create function private.extraction_text_array_is_valid(
  values_to_check text[],
  maximum_items integer,
  maximum_characters integer
)
returns boolean
language sql
immutable
strict
security invoker
set search_path = ''
as $function$
  select
    cardinality(values_to_check) <= maximum_items
    and not exists (
      select 1
      from unnest(values_to_check) as item(value)
      where value is null
        or value <> pg_catalog.btrim(value)
        or pg_catalog.char_length(value) not between 1 and maximum_characters
    );
$function$;

comment on function private.extraction_text_array_is_valid(text[], integer, integer) is
  'Validates bounded normalized extraction-label arrays without accepting provider payload objects.';

revoke execute on function private.extraction_text_array_is_valid(text[], integer, integer)
  from public, anon, authenticated;
grant execute on function private.extraction_text_array_is_valid(text[], integer, integer)
  to service_role;

alter table public.photo_style_signals
  add constraint photo_style_signals_array_entries_check check (
    private.extraction_text_array_is_valid(dominant_colors, 8, 40)
    and private.extraction_text_array_is_valid(categories, 8, 80)
    and private.extraction_text_array_is_valid(silhouettes, 6, 80)
    and private.extraction_text_array_is_valid(aesthetic_tags, 12, 80)
  );

alter table public.extracted_garments
  add constraint extracted_garments_array_entries_check check (
    private.extraction_text_array_is_valid(colors, 8, 80)
    and private.extraction_text_array_is_valid(materials, 8, 80)
    and private.extraction_text_array_is_valid(patterns, 8, 80)
  );

create function private.enforce_photo_style_signal_contract()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $function$
declare
  source_photo public.photos%rowtype;
  parent_status text;
begin
  if tg_op = 'UPDATE' and new.owner_id is distinct from old.owner_id then
    if current_user <> 'postgres' then
      raise exception using
        errcode = '23514',
        message = 'photo style signal owner is immutable outside the transfer transaction';
    end if;

    if row(
      new.id,
      new.profile_id,
      new.photo_id,
      new.dominant_colors,
      new.categories,
      new.silhouettes,
      new.aesthetic_tags,
      new.confidence,
      new.provider_name,
      new.provider_model,
      new.expires_at,
      new.created_at
    ) is distinct from row(
      old.id,
      old.profile_id,
      old.photo_id,
      old.dominant_colors,
      old.categories,
      old.silhouettes,
      old.aesthetic_tags,
      old.confidence,
      old.provider_name,
      old.provider_model,
      old.expires_at,
      old.created_at
    ) then
      raise exception using
        errcode = '23514',
        message = 'photo style signal owner transfer cannot change extraction evidence';
    end if;

    return new;
  end if;

  select photo.*
  into source_photo
  from public.photos as photo
  where photo.id = new.photo_id
    and photo.owner_id = new.owner_id
  for update;

  if not found or source_photo.profile_id <> new.profile_id then
    raise exception using
      errcode = '23514',
      message = 'photo style signal must match one owned source photo and profile';
  end if;

  if new.expires_at > source_photo.expires_at then
    raise exception using
      errcode = '23514',
      message = 'photo style signal deadline cannot exceed its source photo';
  end if;

  if tg_op = 'INSERT' then
    if new.expires_at <= transaction_timestamp()
      or source_photo.expires_at <= transaction_timestamp()
      or source_photo.status not in ('processing', 'partial', 'complete', 'failed')
    then
      raise exception using
        errcode = '23514',
        message = 'photo style signal requires a current processing or terminal analyzed photo';
    end if;

    select profile.status
    into parent_status
    from public.profiles as profile
    where profile.id = new.profile_id;

    if parent_status = 'submitted' and source_photo.status <> 'processing' then
      raise exception using
        errcode = '23514',
        message = 'submitted profile accepts only already-processing extraction evidence';
    end if;

    if parent_status not in ('draft', 'submitted') then
      raise exception using
        errcode = '23514',
        message = 'photo style signal cannot be added to frozen profile evidence';
    end if;

    return new;
  end if;

  if row(
    new.id,
    new.owner_id,
    new.profile_id,
    new.photo_id,
    new.dominant_colors,
    new.categories,
    new.silhouettes,
    new.aesthetic_tags,
    new.confidence,
    new.provider_name,
    new.provider_model,
    new.created_at
  ) is distinct from row(
    old.id,
    old.owner_id,
    old.profile_id,
    old.photo_id,
    old.dominant_colors,
    old.categories,
    old.silhouettes,
    old.aesthetic_tags,
    old.confidence,
    old.provider_name,
    old.provider_model,
    old.created_at
  ) then
    raise exception using
      errcode = '23514',
      message = 'photo style signal analysis evidence is immutable';
  end if;

  if new.expires_at > old.expires_at then
    raise exception using
      errcode = '23514',
      message = 'photo style signal deadline cannot be extended directly';
  end if;

  return new;
end;
$function$;

comment on function private.enforce_photo_style_signal_contract() is
  'Enforces exact photo/profile lineage, immutable normalized signal evidence, transfer safety, and source-bounded expiry.';

revoke execute on function private.enforce_photo_style_signal_contract()
  from public, anon, authenticated, service_role;

create trigger photo_style_signals_enforce_contract
before insert or update on public.photo_style_signals
for each row execute function private.enforce_photo_style_signal_contract();

create function private.enforce_extracted_garment_contract()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $function$
declare
  source_photo public.photos%rowtype;
  parent_status text;
  current_garment_count integer;
begin
  if tg_op = 'UPDATE' and new.owner_id is distinct from old.owner_id then
    if current_user <> 'postgres' then
      raise exception using
        errcode = '23514',
        message = 'extracted garment owner is immutable outside the transfer transaction';
    end if;

    if row(
      new.id,
      new.profile_id,
      new.source_photo_id,
      new.source_kind,
      new.category,
      new.colors,
      new.materials,
      new.patterns,
      new.silhouette,
      new.fit,
      new.confidence,
      new.duplicate_group_id,
      new.review_status,
      new.provider_name,
      new.provider_model,
      new.expires_at,
      new.created_at
    ) is distinct from row(
      old.id,
      old.profile_id,
      old.source_photo_id,
      old.source_kind,
      old.category,
      old.colors,
      old.materials,
      old.patterns,
      old.silhouette,
      old.fit,
      old.confidence,
      old.duplicate_group_id,
      old.review_status,
      old.provider_name,
      old.provider_model,
      old.expires_at,
      old.created_at
    ) then
      raise exception using
        errcode = '23514',
        message = 'extracted garment owner transfer cannot change extraction evidence';
    end if;

    return new;
  end if;

  select photo.*
  into source_photo
  from public.photos as photo
  where photo.id = new.source_photo_id
    and photo.owner_id = new.owner_id
  for update;

  if not found or source_photo.profile_id <> new.profile_id then
    raise exception using
      errcode = '23514',
      message = 'extracted garment must match one owned source photo and profile';
  end if;

  if new.expires_at > source_photo.expires_at then
    raise exception using
      errcode = '23514',
      message = 'extracted garment deadline cannot exceed its source photo';
  end if;

  if tg_op = 'INSERT' then
    if new.expires_at <= transaction_timestamp()
      or source_photo.expires_at <= transaction_timestamp()
      or source_photo.status not in ('processing', 'partial', 'complete', 'failed')
    then
      raise exception using
        errcode = '23514',
        message = 'extracted garment requires a current processing or terminal analyzed photo';
    end if;

    select profile.status
    into parent_status
    from public.profiles as profile
    where profile.id = new.profile_id;

    if parent_status = 'submitted' and source_photo.status <> 'processing' then
      raise exception using
        errcode = '23514',
        message = 'submitted profile accepts only already-processing extraction evidence';
    end if;

    if parent_status not in ('draft', 'submitted') then
      raise exception using
        errcode = '23514',
        message = 'extracted garment cannot be added to frozen profile evidence';
    end if;

    select count(*)
    into current_garment_count
    from public.extracted_garments as garment
    where garment.source_photo_id = new.source_photo_id;

    if current_garment_count >= 20 then
      raise exception using
        errcode = '23514',
        message = 'a source photo can retain at most twenty extracted garments';
    end if;

    return new;
  end if;

  if row(
    new.id,
    new.owner_id,
    new.profile_id,
    new.source_photo_id,
    new.source_kind,
    new.category,
    new.colors,
    new.materials,
    new.patterns,
    new.silhouette,
    new.fit,
    new.confidence,
    new.duplicate_group_id,
    new.provider_name,
    new.provider_model,
    new.created_at
  ) is distinct from row(
    old.id,
    old.owner_id,
    old.profile_id,
    old.source_photo_id,
    old.source_kind,
    old.category,
    old.colors,
    old.materials,
    old.patterns,
    old.silhouette,
    old.fit,
    old.confidence,
    old.duplicate_group_id,
    old.provider_name,
    old.provider_model,
    old.created_at
  ) then
    raise exception using
      errcode = '23514',
      message = 'extracted garment analysis evidence is immutable';
  end if;

  if new.expires_at > old.expires_at then
    raise exception using
      errcode = '23514',
      message = 'extracted garment deadline cannot be extended directly';
  end if;

  if new.review_status is distinct from old.review_status then
    if old.expires_at <= transaction_timestamp() then
      raise exception using
        errcode = '23514',
        message = 'expired extracted garment cannot be reviewed';
    end if;

    if old.review_status <> 'pending'
      or new.review_status not in ('confirmed', 'rejected')
    then
      raise exception using
        errcode = '23514',
        message = 'invalid extracted garment review transition';
    end if;

    select profile.status
    into parent_status
    from public.profiles as profile
    where profile.id = new.profile_id;

    if parent_status <> 'draft' then
      raise exception using
        errcode = '23514',
        message = 'extracted garment review is mutable only while the profile is draft';
    end if;
  end if;

  return new;
end;
$function$;

comment on function private.enforce_extracted_garment_contract() is
  'Enforces exact photo/profile lineage, bounded partial extraction evidence, review transitions, transfer safety, and source-bounded expiry.';

revoke execute on function private.enforce_extracted_garment_contract()
  from public, anon, authenticated, service_role;

create trigger extracted_garments_enforce_contract
before insert or update on public.extracted_garments
for each row execute function private.enforce_extracted_garment_contract();

create trigger extracted_garments_set_updated_at
before update on public.extracted_garments
for each row execute function private.set_updated_at();

alter table public.photo_style_signals enable row level security;
alter table public.extracted_garments enable row level security;

revoke all privileges on table public.photo_style_signals
  from public, anon, authenticated, service_role;
revoke all privileges on table public.extracted_garments
  from public, anon, authenticated, service_role;

grant select on table public.photo_style_signals to authenticated;
grant select on table public.extracted_garments to authenticated;

grant select, insert, update, delete on table public.photo_style_signals
  to service_role;
grant select, insert, update, delete on table public.extracted_garments
  to service_role;

create policy photo_style_signals_select_own_unexpired
on public.photo_style_signals for select
to authenticated
using (
  (select auth.uid()) is not null
  and owner_id = (select auth.uid())
  and expires_at > transaction_timestamp()
  and exists (
    select 1
    from public.photos as photo
    where photo.id = photo_id
      and photo.owner_id = photo_style_signals.owner_id
      and photo.profile_id = photo_style_signals.profile_id
      and photo.expires_at > transaction_timestamp()
  )
);

create policy extracted_garments_select_own_unexpired
on public.extracted_garments for select
to authenticated
using (
  (select auth.uid()) is not null
  and owner_id = (select auth.uid())
  and expires_at > transaction_timestamp()
  and exists (
    select 1
    from public.photos as photo
    where photo.id = source_photo_id
      and photo.owner_id = extracted_garments.owner_id
      and photo.profile_id = extracted_garments.profile_id
      and photo.expires_at > transaction_timestamp()
  )
);

comment on table public.photo_style_signals is
  'Bounded direct-analysis fallback evidence; provider response bodies are never persisted.';

comment on table public.extracted_garments is
  'Bounded per-garment extraction evidence that can coexist with source-photo partial failure state.';

commit;
