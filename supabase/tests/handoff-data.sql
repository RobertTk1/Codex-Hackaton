begin;

create extension if not exists pgtap with schema extensions;
select plan(29);

select has_table(
  'private',
  'outbound_events',
  'retailer handoff events exist only in the private schema'
);

select columns_are(
  'private',
  'outbound_events',
  array[
    'id',
    'owner_id',
    'profile_id',
    'event_type',
    'catalog_product_ref',
    'catalog_shop_ref',
    'catalog_variant_ref',
    'disclosure_version',
    'occurred_at'
  ],
  'handoff events expose only stable references and bounded evidence'
);

select is(
  (
    select relation.relrowsecurity
    from pg_class as relation
    where relation.oid = 'private.outbound_events'::regclass
  ),
  true,
  'handoff events use RLS as private-schema defense in depth'
);

select ok(
  not has_schema_privilege('anon', 'private', 'USAGE')
  and not has_table_privilege('anon', 'private.outbound_events', 'SELECT')
  and not has_table_privilege('anon', 'private.outbound_events', 'INSERT'),
  'anon cannot access handoff events'
);

select ok(
  not has_schema_privilege('authenticated', 'private', 'USAGE')
  and not has_table_privilege(
    'authenticated',
    'private.outbound_events',
    'SELECT'
  )
  and not has_table_privilege(
    'authenticated',
    'private.outbound_events',
    'INSERT'
  )
  and not has_table_privilege(
    'authenticated',
    'private.outbound_events',
    'DELETE'
  ),
  'authenticated customers cannot access handoff events'
);

select ok(
  has_schema_privilege('service_role', 'private', 'USAGE')
  and has_table_privilege(
    'service_role',
    'private.outbound_events',
    'SELECT'
  )
  and has_table_privilege(
    'service_role',
    'private.outbound_events',
    'INSERT'
  )
  and has_table_privilege(
    'service_role',
    'private.outbound_events',
    'DELETE'
  )
  and not has_table_privilege(
    'service_role',
    'private.outbound_events',
    'UPDATE'
  )
  and not has_table_privilege(
    'service_role',
    'private.outbound_events',
    'TRUNCATE'
  ),
  'service_role receives only append, read, and retention-delete access'
);

select ok(
  exists (
    select 1
    from pg_constraint as constraint_record
    where constraint_record.conrelid = 'private.outbound_events'::regclass
      and constraint_record.conname = 'outbound_events_owner_profile_fk'
      and constraint_record.confrelid = 'public.profiles'::regclass
  ),
  'handoff event ownership is constrained by the matching profile'
);

select ok(
  exists (
    select 1
    from pg_indexes
    where schemaname = 'private'
      and tablename = 'outbound_events'
      and indexname = 'outbound_events_owner_profile_idx'
      and indexdef like '%(owner_id, profile_id)%'
  ),
  'the composite profile foreign key has a covering index'
);

select ok(
  exists (
    select 1
    from pg_indexes
    where schemaname = 'private'
      and tablename = 'outbound_events'
      and indexname = 'outbound_events_profile_time_idx'
      and indexdef like '%(profile_id, occurred_at DESC, id DESC)%'
  ),
  'customer-scoped diagnostic history uses the approved index'
);

select ok(
  exists (
    select 1
    from pg_indexes
    where schemaname = 'private'
      and tablename = 'outbound_events'
      and indexname = 'outbound_events_cleanup_idx'
      and indexdef like '%(occurred_at, id)%'
  ),
  '30-day physical deletion has the approved cleanup index'
);

select ok(
  not exists (
    select 1
    from information_schema.columns
    where table_schema = 'private'
      and table_name = 'outbound_events'
      and (
        column_name like '%url%'
        or column_name like '%email%'
        or column_name like '%name%'
        or column_name like '%gender%'
        or column_name like '%age%'
        or column_name like '%height%'
        or column_name like '%weight%'
        or column_name like '%report%'
        or column_name like '%image%'
        or column_name like '%price%'
        or column_name like '%inventory%'
        or column_name like '%token%'
      )
  ),
  'handoff events persist no destination URL, token, customer trait, or volatile retailer fact'
);

select has_function(
  'private',
  'enforce_outbound_event_contract',
  array[]::text[],
  'handoff event contract helper exists'
);

select has_trigger(
  'private',
  'outbound_events',
  'outbound_events_enforce_contract',
  'handoff event writes are contract guarded'
);

select ok(
  not has_function_privilege(
    'authenticated',
    'private.enforce_outbound_event_contract()'::regprocedure,
    'EXECUTE'
  )
  and not has_function_privilege(
    'anon',
    'private.enforce_outbound_event_contract()'::regprocedure,
    'EXECUTE'
  )
  and not has_function_privilege(
    'service_role',
    'private.enforce_outbound_event_contract()'::regprocedure,
    'EXECUTE'
  ),
  'the handoff event guard is trigger-only'
);

select ok(
  (
    select prosecdef
      and coalesce('search_path=""' = any(proconfig), false)
    from pg_proc
    where oid =
      'private.enforce_outbound_event_contract()'::regprocedure
  ),
  'the auth-aware handoff guard is a fixed-search-path security definer'
);

insert into auth.users (id, email, is_anonymous)
values (
  '33333333-3333-4333-8333-333333333333',
  'anonymous-handoff@magic-mirror.test',
  true
);

insert into public.profiles (
  id,
  owner_id,
  status,
  current_step,
  name,
  age,
  adult_confirmed_at,
  gender,
  height_cm,
  fit_preference,
  submitted_at
) values
  (
    'a3400000-0000-4000-8000-000000000001',
    '11111111-1111-4111-8111-111111111111',
    'active',
    'complete',
    'Handoff owner',
    34,
    now(),
    'woman',
    165,
    'regular',
    now()
  ),
  (
    'b3400000-0000-4000-8000-000000000001',
    '22222222-2222-4222-8222-222222222222',
    'active',
    'complete',
    'Other handoff owner',
    35,
    now(),
    'woman',
    168,
    'regular',
    now()
  ),
  (
    'c3400000-0000-4000-8000-000000000001',
    '33333333-3333-4333-8333-333333333333',
    'active',
    'complete',
    'Anonymous handoff owner',
    36,
    now(),
    'woman',
    170,
    'regular',
    now()
  );

set local role service_role;

insert into private.outbound_events (
  id,
  owner_id,
  profile_id,
  event_type,
  catalog_product_ref,
  catalog_shop_ref,
  catalog_variant_ref,
  disclosure_version
) values (
  'a3410000-0000-4000-8000-000000000001',
  '11111111-1111-4111-8111-111111111111',
  'a3400000-0000-4000-8000-000000000001',
  'retailer_handoff',
  'gid://shopify/Product/1001',
  'gid://shopify/Shop/2001',
  'gid://shopify/ProductVariant/3001',
  'retailer-handoff-v1'
);

select is(
  (
    select catalog_product_ref
    from private.outbound_events
    where id = 'a3410000-0000-4000-8000-000000000001'
  ),
  'gid://shopify/Product/1001',
  'confirmed handoff stores the stable product reference'
);

select is(
  (
    select catalog_shop_ref
    from private.outbound_events
    where id = 'a3410000-0000-4000-8000-000000000001'
  ),
  'gid://shopify/Shop/2001',
  'confirmed handoff stores the stable shop reference'
);

select is(
  (
    select catalog_variant_ref
    from private.outbound_events
    where id = 'a3410000-0000-4000-8000-000000000001'
  ),
  'gid://shopify/ProductVariant/3001',
  'confirmed handoff stores the optional stable variant reference'
);

select is(
  (
    select disclosure_version
    from private.outbound_events
    where id = 'a3410000-0000-4000-8000-000000000001'
  ),
  'retailer-handoff-v1',
  'confirmed handoff stores the disclosure version shown to the customer'
);

insert into private.outbound_events (
  id,
  owner_id,
  profile_id,
  event_type,
  catalog_product_ref,
  catalog_shop_ref,
  disclosure_version
) values (
  'a3410000-0000-4000-8000-000000000002',
  '11111111-1111-4111-8111-111111111111',
  'a3400000-0000-4000-8000-000000000001',
  'retailer_handoff',
  'gid://shopify/Product/1002',
  'gid://shopify/Shop/2001',
  'retailer-handoff-v1'
) on conflict (id) do nothing;

insert into private.outbound_events (
  id,
  owner_id,
  profile_id,
  event_type,
  catalog_product_ref,
  catalog_shop_ref,
  disclosure_version
) values (
  'a3410000-0000-4000-8000-000000000002',
  '11111111-1111-4111-8111-111111111111',
  'a3400000-0000-4000-8000-000000000001',
  'retailer_handoff',
  'gid://shopify/Product/1002',
  'gid://shopify/Shop/2001',
  'retailer-handoff-v1'
) on conflict (id) do nothing;

select is(
  (
    select count(*)::integer
    from private.outbound_events
    where id = 'a3410000-0000-4000-8000-000000000002'
  ),
  1,
  'replaying one validated confirmation identifier records one event'
);

select throws_like(
  $$
    insert into private.outbound_events (
      id,
      owner_id,
      profile_id,
      event_type,
      catalog_product_ref,
      catalog_shop_ref,
      disclosure_version
    ) values (
      'a3410000-0000-4000-8000-000000000003',
      '11111111-1111-4111-8111-111111111111',
      'a3400000-0000-4000-8000-000000000001',
      'retailer_redirect',
      'gid://shopify/Product/1003',
      'gid://shopify/Shop/2001',
      'retailer-handoff-v1'
    )
  $$,
  '%outbound_events_type_check%',
  'only the approved retailer handoff event type is accepted'
);

select throws_like(
  $$
    insert into private.outbound_events (
      id,
      owner_id,
      profile_id,
      event_type,
      catalog_product_ref,
      catalog_shop_ref,
      disclosure_version
    ) values (
      'a3410000-0000-4000-8000-000000000004',
      '11111111-1111-4111-8111-111111111111',
      'a3400000-0000-4000-8000-000000000001',
      'retailer_handoff',
      'https://retailer.example/product/1004',
      'gid://shopify/Shop/2001',
      'retailer-handoff-v1'
    )
  $$,
  '%outbound_events_catalog_product_check%',
  'untrimmed or destination-like product values fail the stable-reference bound'
);

select throws_like(
  $$
    insert into private.outbound_events (
      id,
      owner_id,
      profile_id,
      event_type,
      catalog_product_ref,
      catalog_shop_ref,
      disclosure_version
    ) values (
      'a3410000-0000-4000-8000-000000000005',
      '11111111-1111-4111-8111-111111111111',
      'a3400000-0000-4000-8000-000000000001',
      'retailer_handoff',
      'gid://shopify/Product/1005',
      'gid://shopify/Shop/2001',
      ''
    )
  $$,
  '%outbound_events_disclosure_version_check%',
  'an empty disclosure version is rejected'
);

select throws_like(
  $$
    insert into private.outbound_events (
      id,
      owner_id,
      profile_id,
      event_type,
      catalog_product_ref,
      catalog_shop_ref,
      disclosure_version
    ) values (
      'a3410000-0000-4000-8000-000000000006',
      '11111111-1111-4111-8111-111111111111',
      'b3400000-0000-4000-8000-000000000001',
      'retailer_handoff',
      'gid://shopify/Product/1006',
      'gid://shopify/Shop/2001',
      'retailer-handoff-v1'
    )
  $$,
  '%retailer handoff events require an active owned profile%',
  'an event cannot point at another owner profile'
);

select throws_like(
  $$
    insert into private.outbound_events (
      id,
      owner_id,
      profile_id,
      event_type,
      catalog_product_ref,
      catalog_shop_ref,
      disclosure_version
    ) values (
      'a3410000-0000-4000-8000-000000000007',
      '33333333-3333-4333-8333-333333333333',
      'c3400000-0000-4000-8000-000000000001',
      'retailer_handoff',
      'gid://shopify/Product/1007',
      'gid://shopify/Shop/2001',
      'retailer-handoff-v1'
    )
  $$,
  '%retailer handoff events require a permanent account%',
  'anonymous owners cannot create retailer handoff evidence'
);

update public.profiles
set status = 'archived'
where id = 'b3400000-0000-4000-8000-000000000001';

select throws_like(
  $$
    insert into private.outbound_events (
      id,
      owner_id,
      profile_id,
      event_type,
      catalog_product_ref,
      catalog_shop_ref,
      disclosure_version
    ) values (
      'b3410000-0000-4000-8000-000000000001',
      '22222222-2222-4222-8222-222222222222',
      'b3400000-0000-4000-8000-000000000001',
      'retailer_handoff',
      'gid://shopify/Product/2001',
      'gid://shopify/Shop/2002',
      'retailer-handoff-v1'
    )
  $$,
  '%retailer handoff events require an active owned profile%',
  'archived profiles cannot create new retailer handoff evidence'
);

reset role;

select throws_like(
  $$
    update private.outbound_events
    set disclosure_version = 'retailer-handoff-v2'
    where id = 'a3410000-0000-4000-8000-000000000001'
  $$,
  '%outbound events are immutable after creation%',
  'recorded handoff evidence is immutable even for a privileged writer'
);

set local role authenticated;
select set_config(
  'request.jwt.claim.sub',
  '11111111-1111-4111-8111-111111111111',
  true
);

select throws_like(
  $$
    select *
    from private.outbound_events
  $$,
  '%permission denied%',
  'authenticated customer reads fail closed'
);

select throws_like(
  $$
    insert into private.outbound_events (
      id,
      owner_id,
      profile_id,
      event_type,
      catalog_product_ref,
      catalog_shop_ref,
      disclosure_version
    ) values (
      'a3410000-0000-4000-8000-000000000008',
      '11111111-1111-4111-8111-111111111111',
      'a3400000-0000-4000-8000-000000000001',
      'retailer_handoff',
      'gid://shopify/Product/1008',
      'gid://shopify/Shop/2001',
      'retailer-handoff-v1'
    )
  $$,
  '%permission denied%',
  'authenticated customer writes fail closed'
);

reset role;

select * from finish();
rollback;
