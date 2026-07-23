begin;

set local lock_timeout = '5s';
set local statement_timeout = '30s';

create table public.bag_items (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null,
  profile_id uuid not null,
  source text not null,
  catalog_product_ref text not null,
  catalog_shop_ref text not null,
  catalog_variant_ref text,
  source_recommendation_id uuid,
  source_live_session_id uuid,
  saved_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  constraint bag_items_owner_fk
    foreign key (owner_id) references auth.users(id) on delete cascade,
  constraint bag_items_owner_profile_fk
    foreign key (owner_id, profile_id)
    references public.profiles(owner_id, id)
    on update cascade
    on delete cascade
    deferrable initially immediate,
  constraint bag_items_source_recommendation_fk
    foreign key (source_recommendation_id)
    references public.recommendations(id)
    on delete set null,
  constraint bag_items_source_live_session_fk
    foreign key (source_live_session_id)
    references public.live_sessions(id)
    on delete set null,
  constraint bag_items_owner_id_key unique (owner_id, id),
  constraint bag_items_source_check check (
    source in ('recommendation', 'live_session', 'product_detail')
  ),
  constraint bag_items_catalog_product_check check (
    catalog_product_ref = btrim(catalog_product_ref)
    and char_length(catalog_product_ref) between 1 and 512
  ),
  constraint bag_items_catalog_shop_check check (
    catalog_shop_ref = btrim(catalog_shop_ref)
    and char_length(catalog_shop_ref) between 1 and 512
  ),
  constraint bag_items_catalog_variant_check check (
    catalog_variant_ref is null
    or (
      catalog_variant_ref = btrim(catalog_variant_ref)
      and char_length(catalog_variant_ref) between 1 and 512
    )
  ),
  constraint bag_items_source_shape_check check (
    case source
      when 'recommendation' then source_live_session_id is null
      when 'live_session' then source_recommendation_id is null
      when 'product_detail' then
        source_recommendation_id is null
        and source_live_session_id is null
      else false
    end
  ),
  constraint bag_items_timestamp_order_check check (
    saved_at >= created_at
  )
);

create index bag_items_profile_saved_idx
on public.bag_items (profile_id, saved_at desc, id desc);

create unique index bag_items_stable_unique_idx
on public.bag_items (
  profile_id,
  catalog_shop_ref,
  catalog_product_ref,
  coalesce(catalog_variant_ref, '')
);

create index bag_items_source_recommendation_idx
on public.bag_items (source_recommendation_id)
where source_recommendation_id is not null;

create index bag_items_source_live_session_idx
on public.bag_items (source_live_session_id)
where source_live_session_id is not null;

create function private.enforce_bag_item_contract()
returns trigger
language plpgsql
security definer
set search_path = ''
as $function$
declare
  owner_is_anonymous boolean;
  profile_status text;
  source_recommendation public.recommendations%rowtype;
  source_live_session public.live_sessions%rowtype;
begin
  if tg_op = 'UPDATE' then
    if pg_catalog.pg_trigger_depth() > 1
      and (
        (
          old.source_recommendation_id is not null
          and new.source_recommendation_id is null
          and new.source_live_session_id
            is not distinct from old.source_live_session_id
        )
        or (
          old.source_live_session_id is not null
          and new.source_live_session_id is null
          and new.source_recommendation_id
            is not distinct from old.source_recommendation_id
        )
      )
      and row(
        new.id,
        new.owner_id,
        new.profile_id,
        new.source,
        new.catalog_product_ref,
        new.catalog_shop_ref,
        new.catalog_variant_ref,
        new.saved_at,
        new.created_at
      ) is not distinct from row(
        old.id,
        old.owner_id,
        old.profile_id,
        old.source,
        old.catalog_product_ref,
        old.catalog_shop_ref,
        old.catalog_variant_ref,
        old.saved_at,
        old.created_at
      )
    then
      return new;
    end if;

    raise exception using
      errcode = '23514',
      message = 'bag items are immutable after creation';
  end if;

  select user_record.is_anonymous
  into owner_is_anonymous
  from auth.users as user_record
  where user_record.id = new.owner_id;

  if owner_is_anonymous is distinct from false then
    raise exception using
      errcode = '23514',
      message = 'bag items require a permanent account';
  end if;

  select profile.status
  into profile_status
  from public.profiles as profile
  where profile.owner_id = new.owner_id
    and profile.id = new.profile_id;

  if profile_status is distinct from 'active' then
    raise exception using
      errcode = '23514',
      message = 'bag items require an active owned profile';
  end if;

  if new.source = 'recommendation' then
    if new.source_recommendation_id is null then
      raise exception using
        errcode = '23514',
        message = 'recommendation bag items require recommendation provenance';
    end if;

    select recommendation.*
    into source_recommendation
    from public.recommendations as recommendation
    where recommendation.id = new.source_recommendation_id;

    if source_recommendation.id is null
      or source_recommendation.owner_id <> new.owner_id
      or source_recommendation.profile_id <> new.profile_id
      or source_recommendation.catalog_product_ref
        is distinct from new.catalog_product_ref
      or source_recommendation.catalog_shop_ref
        is distinct from new.catalog_shop_ref
      or source_recommendation.catalog_variant_ref
        is distinct from new.catalog_variant_ref
    then
      raise exception using
        errcode = '23514',
        message = 'recommendation provenance must match the owned stable product reference';
    end if;
  elsif new.source = 'live_session' then
    if new.source_live_session_id is null then
      raise exception using
        errcode = '23514',
        message = 'live-session bag items require live-session provenance';
    end if;

    select live_session.*
    into source_live_session
    from public.live_sessions as live_session
    where live_session.id = new.source_live_session_id;

    if source_live_session.id is null
      or source_live_session.owner_id <> new.owner_id
      or source_live_session.profile_id <> new.profile_id
      or source_live_session.catalog_product_ref
        is distinct from new.catalog_product_ref
      or source_live_session.catalog_shop_ref
        is distinct from new.catalog_shop_ref
      or source_live_session.catalog_variant_ref
        is distinct from new.catalog_variant_ref
    then
      raise exception using
        errcode = '23514',
        message = 'live-session provenance must match the owned stable product reference';
    end if;
  end if;

  return new;
end;
$function$;

comment on function private.enforce_bag_item_contract() is
  'Enforces permanent-account ownership, active-profile writes, immutable stable references, and source provenance for bag records.';

revoke execute on function private.enforce_bag_item_contract()
  from public, anon, authenticated, service_role;

create trigger bag_items_enforce_contract
before insert or update on public.bag_items
for each row execute function private.enforce_bag_item_contract();

alter table public.bag_items enable row level security;

revoke all privileges on table public.bag_items
  from public, anon, authenticated, service_role;

grant select, insert, delete on table public.bag_items to authenticated;
grant select, insert, delete on table public.bag_items to service_role;

create policy bag_items_select_own_permanent
on public.bag_items for select
to authenticated
using (
  (select auth.uid()) is not null
  and owner_id = (select auth.uid())
  and coalesce(
    ((select auth.jwt()) ->> 'is_anonymous')::boolean,
    true
  ) is false
);

create policy bag_items_insert_own_permanent
on public.bag_items for insert
to authenticated
with check (
  (select auth.uid()) is not null
  and owner_id = (select auth.uid())
  and coalesce(
    ((select auth.jwt()) ->> 'is_anonymous')::boolean,
    true
  ) is false
);

create policy bag_items_delete_own_permanent
on public.bag_items for delete
to authenticated
using (
  (select auth.uid()) is not null
  and owner_id = (select auth.uid())
  and coalesce(
    ((select auth.jwt()) ->> 'is_anonymous')::boolean,
    true
  ) is false
);

comment on table public.bag_items is
  'Private customer bag records containing stable Shopify catalog references and immutable save provenance; live price, inventory, product media, and retailer URLs are resolved at read time.';

commit;
