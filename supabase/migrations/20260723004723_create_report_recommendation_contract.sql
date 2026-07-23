begin;

set local lock_timeout = '5s';
set local statement_timeout = '30s';

create table public.recommendations (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null,
  profile_id uuid not null,
  report_id uuid not null,
  position smallint not null,
  category text not null,
  title text not null,
  rationale text not null,
  styling_note text not null,
  catalog_product_ref text not null,
  catalog_shop_ref text not null,
  catalog_variant_ref text,
  preview_asset_id uuid,
  outfit_group_key text,
  outfit_group_title text,
  outfit_item_position smallint,
  created_at timestamptz not null default now(),
  constraint recommendations_owner_fk
    foreign key (owner_id) references auth.users(id) on delete cascade,
  constraint recommendations_owner_profile_report_fk
    foreign key (owner_id, profile_id, report_id)
    references public.style_reports(owner_id, profile_id, id)
    on update cascade
    on delete cascade
    deferrable initially immediate,
  constraint recommendations_preview_asset_fk
    foreign key (preview_asset_id)
    references public.generated_assets(id)
    on delete set null,
  constraint recommendations_owner_id_key unique (owner_id, id),
  constraint recommendations_owner_profile_id_key
    unique (owner_id, profile_id, id),
  constraint recommendations_position_check check (position between 1 and 24),
  constraint recommendations_category_check check (
    category = btrim(category) and char_length(category) between 1 and 80
  ),
  constraint recommendations_title_check check (
    title = btrim(title) and char_length(title) between 1 and 120
  ),
  constraint recommendations_rationale_check check (
    rationale = btrim(rationale) and char_length(rationale) between 1 and 2000
  ),
  constraint recommendations_styling_note_check check (
    styling_note = btrim(styling_note)
    and char_length(styling_note) between 1 and 2000
  ),
  constraint recommendations_catalog_product_check check (
    catalog_product_ref = btrim(catalog_product_ref)
    and char_length(catalog_product_ref) between 1 and 512
  ),
  constraint recommendations_catalog_shop_check check (
    catalog_shop_ref = btrim(catalog_shop_ref)
    and char_length(catalog_shop_ref) between 1 and 512
  ),
  constraint recommendations_catalog_variant_check check (
    catalog_variant_ref is null
    or (
      catalog_variant_ref = btrim(catalog_variant_ref)
      and char_length(catalog_variant_ref) between 1 and 512
    )
  ),
  constraint recommendations_outfit_group_key_check check (
    outfit_group_key is null
    or (
      outfit_group_key = btrim(outfit_group_key)
      and char_length(outfit_group_key) between 1 and 80
    )
  ),
  constraint recommendations_outfit_group_title_check check (
    outfit_group_title is null
    or (
      outfit_group_title = btrim(outfit_group_title)
      and char_length(outfit_group_title) between 1 and 120
    )
  ),
  constraint recommendations_outfit_position_check check (
    outfit_item_position is null or outfit_item_position between 1 and 6
  ),
  constraint recommendations_outfit_shape_check check (
    (
      outfit_group_key is null
      and outfit_group_title is null
      and outfit_item_position is null
    ) or (
      outfit_group_key is not null
      and outfit_group_title is not null
      and outfit_item_position is not null
    )
  )
);

create unique index recommendations_report_position_idx
on public.recommendations (report_id, position);

create unique index recommendations_outfit_position_idx
on public.recommendations (
  report_id, outfit_group_key, outfit_item_position
)
where outfit_group_key is not null;

create index recommendations_owner_report_idx
on public.recommendations (owner_id, profile_id, report_id);

create index recommendations_preview_asset_idx
on public.recommendations (preview_asset_id)
where preview_asset_id is not null;

create table private.recommendation_preview_attachments (
  recommendation_id uuid primary key,
  asset_id uuid not null,
  attached_at timestamptz not null default now(),
  constraint recommendation_preview_attachments_recommendation_fk
    foreign key (recommendation_id)
    references public.recommendations(id)
    on delete cascade
);

revoke all privileges on table private.recommendation_preview_attachments
  from public, anon, authenticated, service_role;
grant select, insert on table private.recommendation_preview_attachments
  to service_role;

create function private.enforce_recommendation_contract()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $function$
declare
  asset_record public.generated_assets%rowtype;
  consent_record public.consent_records%rowtype;
  current_consent_id uuid;
begin
  if tg_op = 'INSERT' then
    if new.preview_asset_id is not null then
      raise exception using
        errcode = '23514',
        message = 'recommendation preview must attach after publication';
    end if;

    if new.outfit_group_key is not null and exists (
      select 1
      from public.recommendations as grouped_recommendation
      where grouped_recommendation.report_id = new.report_id
        and grouped_recommendation.outfit_group_key = new.outfit_group_key
        and grouped_recommendation.outfit_group_title <> new.outfit_group_title
    ) then
      raise exception using
        errcode = '23514',
        message = 'one outfit group key must use one customer-facing title';
    end if;

    return new;
  end if;

  if pg_catalog.pg_trigger_depth() > 1
    and old.preview_asset_id is not null
    and new.preview_asset_id is null
    and row(
      new.id, new.owner_id, new.profile_id, new.report_id, new.position,
      new.category, new.title, new.rationale, new.styling_note,
      new.catalog_product_ref, new.catalog_shop_ref,
      new.catalog_variant_ref, new.outfit_group_key,
      new.outfit_group_title, new.outfit_item_position, new.created_at
    ) is not distinct from row(
      old.id, old.owner_id, old.profile_id, old.report_id, old.position,
      old.category, old.title, old.rationale, old.styling_note,
      old.catalog_product_ref, old.catalog_shop_ref,
      old.catalog_variant_ref, old.outfit_group_key,
      old.outfit_group_title, old.outfit_item_position, old.created_at
    )
  then
    return new;
  end if;

  if row(
    new.id, new.owner_id, new.profile_id, new.report_id, new.position,
    new.category, new.title, new.rationale, new.styling_note,
    new.catalog_product_ref, new.catalog_shop_ref,
    new.catalog_variant_ref, new.outfit_group_key,
    new.outfit_group_title, new.outfit_item_position, new.created_at
  ) is distinct from row(
    old.id, old.owner_id, old.profile_id, old.report_id, old.position,
    old.category, old.title, old.rationale, old.styling_note,
    old.catalog_product_ref, old.catalog_shop_ref,
    old.catalog_variant_ref, old.outfit_group_key,
    old.outfit_group_title, old.outfit_item_position, old.created_at
  ) or old.preview_asset_id is not null
    or new.preview_asset_id is null
  then
    raise exception using
      errcode = '23514',
      message = 'recommendations are immutable except for one preview attachment';
  end if;

  if exists (
    select 1
    from private.recommendation_preview_attachments as attachment
    where attachment.recommendation_id = old.id
  ) then
    raise exception using
      errcode = '23514',
      message = 'recommendation preview has already been attached';
  end if;

  select asset.*
  into asset_record
  from public.generated_assets as asset
  where asset.id = new.preview_asset_id;

  if not found
    or asset_record.owner_id <> new.owner_id
    or asset_record.profile_id <> new.profile_id
    or asset_record.kind <> 'wardrobe_preview'
    or asset_record.status <> 'accepted'
    or asset_record.expires_at <= transaction_timestamp()
  then
    raise exception using
      errcode = '23514',
      message = 'recommendation preview must be an owned accepted wardrobe preview';
  end if;

  if not exists (
    select 1
    from public.generated_asset_sources as source
    where source.asset_id = asset_record.id
      and source.owner_id = new.owner_id
      and source.profile_id = new.profile_id
      and source.catalog_product_ref = new.catalog_product_ref
      and source.catalog_shop_ref = new.catalog_shop_ref
  ) then
    raise exception using
      errcode = '23514',
      message = 'recommendation preview must match its stable catalog product and shop';
  end if;

  select consent.*
  into consent_record
  from public.consent_records as consent
  where consent.id = asset_record.generation_consent_record_id;

  select consent.id
  into current_consent_id
  from public.consent_records as consent
  where consent.owner_id = new.owner_id
    and consent.profile_id = new.profile_id
    and consent.purpose = 'generated_likeness_preview'
  order by consent.captured_at desc, consent.id desc
  limit 1;

  if consent_record.id is null
    or consent_record.owner_id <> new.owner_id
    or consent_record.profile_id <> new.profile_id
    or consent_record.purpose <> 'generated_likeness_preview'
    or consent_record.decision <> 'granted'
    or current_consent_id is distinct from asset_record.generation_consent_record_id
  then
    raise exception using
      errcode = '23514',
      message = 'recommendation preview requires current granted likeness consent';
  end if;

  insert into private.recommendation_preview_attachments (
    recommendation_id, asset_id
  ) values (
    old.id, new.preview_asset_id
  );

  return new;
end;
$function$;

comment on function private.enforce_recommendation_contract() is
  'Keeps report recommendation evidence immutable and permits one consent-valid owned preview attachment for the row lifetime.';

revoke execute on function private.enforce_recommendation_contract()
  from public, anon, authenticated, service_role;

create trigger recommendations_enforce_contract
before insert or update on public.recommendations
for each row execute function private.enforce_recommendation_contract();

alter table public.recommendations enable row level security;

revoke all privileges on table public.recommendations
  from public, anon, authenticated, service_role;

grant select on table public.recommendations to authenticated;
grant select, insert, update, delete on table public.recommendations
  to service_role;

create policy recommendations_select_own_permanent
on public.recommendations for select
to authenticated
using (
  (select auth.uid()) is not null
  and owner_id = (select auth.uid())
  and coalesce(
    (select (auth.jwt() ->> 'is_anonymous')::boolean),
    true
  ) is false
);

comment on table public.recommendations is
  'Immutable report-local styling guidance with stable Shopify references only; live retailer facts are refreshed at read time.';

comment on table private.recommendation_preview_attachments is
  'Internal lifetime tombstone that prevents a recommendation from receiving a second generated preview after retention clears the first pointer.';

commit;
