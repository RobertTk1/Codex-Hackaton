begin;

set local lock_timeout = '5s';
set local statement_timeout = '30s';

create table public.generated_assets (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null,
  profile_id uuid not null,
  kind text not null,
  status text not null default 'processing',
  generation_consent_record_id uuid,
  storage_path text,
  media_type text,
  byte_size bigint,
  width_px integer,
  height_px integer,
  sha256 bytea,
  provider_name text not null,
  provider_model text not null,
  rejection_code text,
  expires_at timestamptz not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint generated_assets_owner_profile_fk
    foreign key (owner_id, profile_id)
    references public.profiles(owner_id, id)
    on update cascade
    on delete cascade
    deferrable initially immediate,
  constraint generated_assets_owner_consent_fk
    foreign key (owner_id, generation_consent_record_id)
    references public.consent_records(owner_id, id)
    on update cascade
    on delete restrict
    deferrable initially immediate,
  constraint generated_assets_owner_id_key unique (owner_id, id),
  constraint generated_assets_owner_profile_id_key
    unique (owner_id, profile_id, id),
  constraint generated_assets_storage_path_key unique (storage_path),
  constraint generated_assets_kind_check check (
    kind in ('garment_cutout', 'wardrobe_preview', 'tryon_still')
  ),
  constraint generated_assets_status_check check (
    status in ('processing', 'accepted', 'rejected', 'failed')
  ),
  constraint generated_assets_consent_shape_check check (
    (kind = 'garment_cutout' and generation_consent_record_id is null)
    or (
      kind in ('wardrobe_preview', 'tryon_still')
      and generation_consent_record_id is not null
    )
  ),
  constraint generated_assets_storage_path_check check (
    storage_path is null
    or (
      storage_path = btrim(storage_path)
      and char_length(storage_path) between 1 and 1024
    )
  ),
  constraint generated_assets_media_type_check check (
    media_type is null
    or media_type in ('image/png', 'image/jpeg', 'image/webp')
  ),
  constraint generated_assets_byte_size_check check (
    byte_size is null or byte_size between 1 and 26214400
  ),
  constraint generated_assets_width_check check (
    width_px is null or width_px between 64 and 12000
  ),
  constraint generated_assets_height_check check (
    height_px is null or height_px between 64 and 12000
  ),
  constraint generated_assets_sha256_check check (
    sha256 is null or octet_length(sha256) = 32
  ),
  constraint generated_assets_provider_name_check check (
    provider_name = btrim(provider_name)
    and char_length(provider_name) between 1 and 120
  ),
  constraint generated_assets_provider_model_check check (
    provider_model = btrim(provider_model)
    and char_length(provider_model) between 1 and 120
  ),
  constraint generated_assets_rejection_code_check check (
    rejection_code is null
    or (
      rejection_code = btrim(rejection_code)
      and char_length(rejection_code) between 1 and 80
    )
  ),
  constraint generated_assets_expiry_check check (expires_at > created_at),
  constraint generated_assets_preview_expiry_check check (
    kind = 'garment_cutout'
    or expires_at <= created_at + interval '30 days'
  ),
  constraint generated_assets_state_check check (
    (
      status = 'processing'
      and storage_path is null
      and media_type is null
      and byte_size is null
      and width_px is null
      and height_px is null
      and sha256 is null
      and rejection_code is null
    )
    or (
      status = 'accepted'
      and storage_path is not null
      and media_type is not null
      and byte_size is not null
      and width_px is not null
      and height_px is not null
      and sha256 is not null
      and rejection_code is null
    )
    or (
      status in ('rejected', 'failed')
      and storage_path is null
      and media_type is null
      and byte_size is null
      and width_px is null
      and height_px is null
      and sha256 is null
      and rejection_code is not null
    )
  )
);

create index generated_assets_profile_kind_idx
on public.generated_assets (profile_id, kind, created_at desc, id desc);

create index generated_assets_expiry_idx
on public.generated_assets (expires_at, id)
where status = 'accepted';

create index generated_assets_consent_idx
on public.generated_assets (generation_consent_record_id)
where generation_consent_record_id is not null;

create index generated_assets_owner_profile_idx
on public.generated_assets (owner_id, profile_id);

create index generated_assets_owner_consent_idx
on public.generated_assets (owner_id, generation_consent_record_id)
where generation_consent_record_id is not null;

create table public.generated_asset_sources (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null,
  profile_id uuid not null,
  asset_id uuid not null,
  source_photo_id uuid,
  source_garment_id uuid,
  catalog_product_ref text,
  catalog_shop_ref text,
  catalog_image_transmitted boolean not null default false,
  created_at timestamptz not null default now(),
  constraint generated_asset_sources_owner_asset_fk
    foreign key (owner_id, profile_id, asset_id)
    references public.generated_assets(owner_id, profile_id, id)
    on update cascade
    on delete cascade
    deferrable initially immediate,
  constraint generated_asset_sources_owner_photo_fk
    foreign key (owner_id, source_photo_id)
    references public.photos(owner_id, id)
    on update cascade
    on delete cascade
    deferrable initially immediate,
  constraint generated_asset_sources_owner_garment_fk
    foreign key (owner_id, source_garment_id)
    references public.extracted_garments(owner_id, id)
    on update cascade
    on delete cascade
    deferrable initially immediate,
  constraint generated_asset_sources_owner_id_key unique (owner_id, id),
  constraint generated_asset_sources_family_check check (
    (
      source_photo_id is not null
      and source_garment_id is null
      and catalog_product_ref is null
      and catalog_shop_ref is null
      and not catalog_image_transmitted
    )
    or (
      source_photo_id is null
      and source_garment_id is not null
      and catalog_product_ref is null
      and catalog_shop_ref is null
      and not catalog_image_transmitted
    )
    or (
      source_photo_id is null
      and source_garment_id is null
      and catalog_product_ref is not null
      and catalog_shop_ref is not null
    )
  ),
  constraint generated_asset_sources_catalog_product_check check (
    catalog_product_ref is null
    or (
      catalog_product_ref = btrim(catalog_product_ref)
      and char_length(catalog_product_ref) between 1 and 512
    )
  ),
  constraint generated_asset_sources_catalog_shop_check check (
    catalog_shop_ref is null
    or (
      catalog_shop_ref = btrim(catalog_shop_ref)
      and char_length(catalog_shop_ref) between 1 and 512
    )
  )
);

create index generated_asset_sources_asset_idx
on public.generated_asset_sources (asset_id, id);

create index generated_asset_sources_owner_asset_idx
on public.generated_asset_sources (owner_id, profile_id, asset_id);

create index generated_asset_sources_owner_photo_idx
on public.generated_asset_sources (owner_id, source_photo_id)
where source_photo_id is not null;

create index generated_asset_sources_owner_garment_idx
on public.generated_asset_sources (owner_id, source_garment_id)
where source_garment_id is not null;

create function private.enforce_generated_asset_contract()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $function$
declare
  consent_record public.consent_records%rowtype;
  current_consent_id uuid;
begin
  if tg_op = 'INSERT' then
    if new.status <> 'processing' then
      raise exception using
        errcode = '23514',
        message = 'generated assets must begin in processing state';
    end if;

    if new.expires_at <= transaction_timestamp() then
      raise exception using
        errcode = '23514',
        message = 'generated assets require a future retention deadline';
    end if;

    if new.generation_consent_record_id is not null then
      select consent.*
      into consent_record
      from public.consent_records as consent
      where consent.id = new.generation_consent_record_id;

      if not found
        or consent_record.owner_id <> new.owner_id
        or consent_record.profile_id <> new.profile_id
        or consent_record.purpose <> 'generated_likeness_preview'
        or consent_record.decision <> 'granted'
      then
        raise exception using
          errcode = '23514',
          message = 'likeness assets require exact owned granted generation consent';
      end if;

      select consent.id
      into current_consent_id
      from public.consent_records as consent
      where consent.owner_id = new.owner_id
        and consent.profile_id = new.profile_id
        and consent.purpose = 'generated_likeness_preview'
      order by consent.captured_at desc, consent.id desc
      limit 1;

      if current_consent_id is distinct from new.generation_consent_record_id then
        raise exception using
          errcode = '23514',
          message = 'likeness asset creation requires the current granted generation consent';
      end if;
    end if;

    return new;
  end if;

  if new.owner_id is distinct from old.owner_id then
    if current_user <> 'postgres'
      or row(
        new.id, new.profile_id, new.kind, new.status,
        new.generation_consent_record_id, new.storage_path, new.media_type,
        new.byte_size, new.width_px, new.height_px, new.sha256,
        new.provider_name, new.provider_model, new.rejection_code,
        new.expires_at, new.created_at
      ) is distinct from row(
        old.id, old.profile_id, old.kind, old.status,
        old.generation_consent_record_id, old.storage_path, old.media_type,
        old.byte_size, old.width_px, old.height_px, old.sha256,
        old.provider_name, old.provider_model, old.rejection_code,
        old.expires_at, old.created_at
      )
    then
      raise exception using
        errcode = '23514',
        message = 'generated asset owner is immutable outside account transfer';
    end if;

    return new;
  end if;

  if new.id is distinct from old.id
    or new.profile_id is distinct from old.profile_id
    or new.kind is distinct from old.kind
    or new.generation_consent_record_id is distinct from old.generation_consent_record_id
    or new.provider_name is distinct from old.provider_name
    or new.provider_model is distinct from old.provider_model
    or new.created_at is distinct from old.created_at
  then
    raise exception using
      errcode = '23514',
      message = 'generated asset identity, class, consent, and provenance are immutable';
  end if;

  if new.expires_at > old.expires_at then
    raise exception using
      errcode = '23514',
      message = 'generated asset expiry may only be shortened';
  end if;

  if old.status <> 'processing' then
    if row(
      new.status, new.storage_path, new.media_type, new.byte_size,
      new.width_px, new.height_px, new.sha256, new.rejection_code
    ) is distinct from row(
      old.status, old.storage_path, old.media_type, old.byte_size,
      old.width_px, old.height_px, old.sha256, old.rejection_code
    ) then
      raise exception using
        errcode = '23514',
        message = 'terminal generated asset evidence is immutable';
    end if;
  elsif new.status not in ('processing', 'accepted', 'rejected', 'failed') then
    raise exception using
      errcode = '23514',
      message = 'invalid generated asset state transition';
  end if;

  return new;
end;
$function$;

comment on function private.enforce_generated_asset_contract() is
  'Enforces generated-asset class, consent, immutable provenance, terminal state, and retention transitions.';

revoke execute on function private.enforce_generated_asset_contract()
  from public, anon, authenticated, service_role;

create function private.enforce_generated_asset_source_contract()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $function$
declare
  asset_profile_id uuid;
  source_profile_id uuid;
begin
  if tg_op = 'UPDATE' then
    if new.owner_id is distinct from old.owner_id
      and current_user = 'postgres'
      and row(
        new.id, new.profile_id, new.asset_id, new.source_photo_id,
        new.source_garment_id, new.catalog_product_ref,
        new.catalog_shop_ref, new.catalog_image_transmitted, new.created_at
      ) is not distinct from row(
        old.id, old.profile_id, old.asset_id, old.source_photo_id,
        old.source_garment_id, old.catalog_product_ref,
        old.catalog_shop_ref, old.catalog_image_transmitted, old.created_at
      )
    then
      return new;
    end if;

    raise exception using
      errcode = '23514',
      message = 'generated asset source evidence is immutable';
  end if;

  select asset.profile_id
  into asset_profile_id
  from public.generated_assets as asset
  where asset.id = new.asset_id
    and asset.owner_id = new.owner_id;

  if not found or asset_profile_id <> new.profile_id then
    raise exception using
      errcode = '23514',
      message = 'generated asset source must match the owned asset profile';
  end if;

  if new.source_photo_id is not null then
    select photo.profile_id
    into source_profile_id
    from public.photos as photo
    where photo.id = new.source_photo_id
      and photo.owner_id = new.owner_id;
  elsif new.source_garment_id is not null then
    select garment.profile_id
    into source_profile_id
    from public.extracted_garments as garment
    where garment.id = new.source_garment_id
      and garment.owner_id = new.owner_id;
  else
    source_profile_id := new.profile_id;
  end if;

  if source_profile_id is distinct from new.profile_id then
    raise exception using
      errcode = '23514',
      message = 'generated asset source must belong to the same profile';
  end if;

  return new;
end;
$function$;

comment on function private.enforce_generated_asset_source_contract() is
  'Validates exact same-profile source lineage and keeps source evidence immutable.';

revoke execute on function private.enforce_generated_asset_source_contract()
  from public, anon, authenticated, service_role;

create function private.enforce_generated_asset_source_completeness()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $function$
declare
  affected_asset_id uuid;
  asset_record public.generated_assets%rowtype;
  source_photo_count integer;
begin
  if tg_table_name = 'generated_assets' then
    affected_asset_id := case when tg_op = 'DELETE' then old.id else new.id end;
  else
    affected_asset_id := case when tg_op = 'DELETE' then old.asset_id else new.asset_id end;
  end if;

  select asset.*
  into asset_record
  from public.generated_assets as asset
  where asset.id = affected_asset_id;

  if not found then
    return null;
  end if;

  select count(*)
  into source_photo_count
  from public.generated_asset_sources
  where asset_id = affected_asset_id
    and source_photo_id is not null;

  if source_photo_count < 1 then
    raise exception using
      errcode = '23514',
      message = 'generated asset requires at least one direct customer-photo source';
  end if;

  if exists (
    select 1
    from public.generated_asset_sources as source
    join public.photos as photo on photo.id = source.source_photo_id
    where source.asset_id = affected_asset_id
      and source.source_photo_id is not null
      and asset_record.expires_at > photo.expires_at
  ) or exists (
    select 1
    from public.generated_asset_sources as source
    join public.extracted_garments as garment on garment.id = source.source_garment_id
    where source.asset_id = affected_asset_id
      and source.source_garment_id is not null
      and asset_record.expires_at > garment.expires_at
  ) then
    raise exception using
      errcode = '23514',
      message = 'generated asset expiry cannot outlive its customer source evidence';
  end if;

  return null;
end;
$function$;

comment on function private.enforce_generated_asset_source_completeness() is
  'At transaction completion, requires direct photo lineage and source-bounded generated-asset expiry.';

revoke execute on function private.enforce_generated_asset_source_completeness()
  from public, anon, authenticated, service_role;

create trigger generated_assets_enforce_contract
before insert or update on public.generated_assets
for each row execute function private.enforce_generated_asset_contract();

create trigger generated_assets_set_updated_at
before update on public.generated_assets
for each row execute function private.set_updated_at();

create trigger generated_asset_sources_enforce_contract
before insert or update on public.generated_asset_sources
for each row execute function private.enforce_generated_asset_source_contract();

create constraint trigger generated_assets_enforce_source_completeness
after insert or update on public.generated_assets
deferrable initially deferred
for each row execute function private.enforce_generated_asset_source_completeness();

create constraint trigger generated_asset_sources_enforce_completeness
after insert or update or delete on public.generated_asset_sources
deferrable initially deferred
for each row execute function private.enforce_generated_asset_source_completeness();

alter table public.generated_assets enable row level security;
alter table public.generated_asset_sources enable row level security;

revoke all privileges on table public.generated_assets
  from public, anon, authenticated, service_role;
revoke all privileges on table public.generated_asset_sources
  from public, anon, authenticated, service_role;

grant select on table public.generated_assets to authenticated;
grant select on table public.generated_asset_sources to authenticated;
grant select, insert, update, delete on table public.generated_assets to service_role;
grant select, insert, update, delete on table public.generated_asset_sources to service_role;

create policy generated_assets_select_own_unexpired
on public.generated_assets for select
to authenticated
using (
  (select auth.uid()) is not null
  and owner_id = (select auth.uid())
  and expires_at > transaction_timestamp()
);

create policy generated_asset_sources_select_own_unexpired
on public.generated_asset_sources for select
to authenticated
using (
  (select auth.uid()) is not null
  and owner_id = (select auth.uid())
  and exists (
    select 1
    from public.generated_assets as asset
    where asset.id = generated_asset_sources.asset_id
      and asset.owner_id = (select auth.uid())
      and asset.expires_at > transaction_timestamp()
  )
);

comment on table public.generated_assets is
  'Private generated media metadata with exact class, consent, lifecycle, and retention evidence; bytes remain in private Storage.';

comment on table public.generated_asset_sources is
  'Immutable bounded source lineage for generated assets; catalog rows retain stable references only.';

commit;
