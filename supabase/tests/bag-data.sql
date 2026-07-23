begin;

create extension if not exists pgtap with schema extensions;
select no_plan();

select has_table('public', 'bag_items', 'bag items table exists');

select columns_are(
  'public',
  'bag_items',
  array[
    'id',
    'owner_id',
    'profile_id',
    'source',
    'catalog_product_ref',
    'catalog_shop_ref',
    'catalog_variant_ref',
    'source_recommendation_id',
    'source_live_session_id',
    'saved_at',
    'created_at'
  ],
  'bag items persist only stable references and provenance'
);

select is(
  (
    select count(*)
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'bag_items'
      and (
        column_name like '%price%'
        or column_name like '%inventory%'
        or column_name like '%availability%'
        or column_name like '%retailer_url%'
        or column_name like '%title%'
        or column_name like '%image%'
      )
  ),
  0::bigint,
  'bag rows cannot persist volatile catalog facts or product presentation'
);

select is(
  (select relrowsecurity from pg_class where oid = 'public.bag_items'::regclass),
  true,
  'bag items have row-level security enabled'
);

select ok(
  not has_table_privilege('anon', 'public.bag_items', 'SELECT')
  and not has_table_privilege('anon', 'public.bag_items', 'INSERT')
  and not has_table_privilege('anon', 'public.bag_items', 'UPDATE')
  and not has_table_privilege('anon', 'public.bag_items', 'DELETE'),
  'bare anonymous requests have no bag privileges'
);

select ok(
  has_table_privilege('authenticated', 'public.bag_items', 'SELECT')
  and has_table_privilege('authenticated', 'public.bag_items', 'INSERT')
  and not has_table_privilege('authenticated', 'public.bag_items', 'UPDATE')
  and has_table_privilege('authenticated', 'public.bag_items', 'DELETE'),
  'permanent customers receive bounded bag operations without mutation'
);

select ok(
  has_table_privilege('service_role', 'public.bag_items', 'SELECT')
  and has_table_privilege('service_role', 'public.bag_items', 'INSERT')
  and not has_table_privilege('service_role', 'public.bag_items', 'UPDATE')
  and has_table_privilege('service_role', 'public.bag_items', 'DELETE')
  and not has_table_privilege('service_role', 'public.bag_items', 'TRUNCATE'),
  'service operations receive the same immutable bag write surface'
);

select results_eq(
  $$
    select policyname
    from pg_policies
    where schemaname = 'public' and tablename = 'bag_items'
    order by policyname
  $$,
  array[
    'bag_items_delete_own_permanent',
    'bag_items_insert_own_permanent',
    'bag_items_select_own_permanent'
  ]::name[],
  'bag items expose explicit owner-scoped permanent-account policies'
);

select ok(
  (
    select bool_and(
      coalesce(pg_get_expr(polqual, polrelid), '')
        like '%SELECT auth.uid() AS uid%'
      or coalesce(pg_get_expr(polwithcheck, polrelid), '')
        like '%SELECT auth.uid() AS uid%'
    )
    from pg_policy
    where polrelid = 'public.bag_items'::regclass
  ),
  'bag owner checks cache the authenticated user once per statement'
);

select ok(
  (
    select bool_and(
      coalesce(pg_get_expr(polqual, polrelid), '')
        like '%SELECT auth.jwt() AS jwt%'
      or coalesce(pg_get_expr(polwithcheck, polrelid), '')
        like '%SELECT auth.jwt() AS jwt%'
    )
    from pg_policy
    where polrelid = 'public.bag_items'::regclass
  ),
  'bag policies cache the permanent-account JWT check'
);

select has_index(
  'public',
  'bag_items',
  'bag_items_profile_saved_idx',
  'bag pagination is indexed by profile and immutable save cursor'
);

select has_index(
  'public',
  'bag_items',
  'bag_items_stable_unique_idx',
  'one stable product tuple is enforced per profile'
);

select has_index(
  'public',
  'bag_items',
  'bag_items_source_recommendation_idx',
  'recommendation provenance cleanup is indexed'
);

select has_index(
  'public',
  'bag_items',
  'bag_items_source_live_session_idx',
  'live-session provenance cleanup is indexed'
);

select ok(
  (
    select indexdef like
      '%(profile_id, catalog_shop_ref, catalog_product_ref, COALESCE(catalog_variant_ref, ''''::text))%'
    from pg_indexes
    where schemaname = 'public'
      and tablename = 'bag_items'
      and indexname = 'bag_items_stable_unique_idx'
  ),
  'stable-reference uniqueness treats a missing variant consistently'
);

select ok(
  exists (
    select 1
    from pg_constraint
    where conrelid = 'public.bag_items'::regclass
      and conname = 'bag_items_owner_profile_fk'
      and confrelid = 'public.profiles'::regclass
  ),
  'bag profile lineage is same-owner constrained'
);

select ok(
  (
    select confdeltype = 'n'
    from pg_constraint
    where conrelid = 'public.bag_items'::regclass
      and conname = 'bag_items_source_recommendation_fk'
  )
  and (
    select confdeltype = 'n'
    from pg_constraint
    where conrelid = 'public.bag_items'::regclass
      and conname = 'bag_items_source_live_session_fk'
  ),
  'retention purge nulls provenance without deleting a saved item'
);

select has_function(
  'private',
  'enforce_bag_item_contract',
  array[]::text[],
  'bag contract trigger helper exists'
);

select has_trigger(
  'public',
  'bag_items',
  'bag_items_enforce_contract',
  'bag writes are contract guarded'
);

select ok(
  not has_function_privilege(
    'authenticated',
    'private.enforce_bag_item_contract()'::regprocedure,
    'EXECUTE'
  )
  and not has_function_privilege(
    'anon',
    'private.enforce_bag_item_contract()'::regprocedure,
    'EXECUTE'
  )
  and not has_function_privilege(
    'service_role',
    'private.enforce_bag_item_contract()'::regprocedure,
    'EXECUTE'
  ),
  'the bag guard is trigger-only'
);

select ok(
  (
    select prosecdef
      and coalesce('search_path=""' = any(proconfig), false)
    from pg_proc
    where oid = 'private.enforce_bag_item_contract()'::regprocedure
  ),
  'the auth-aware bag guard is a fixed-search-path security definer'
);

insert into auth.users (id, email, is_anonymous)
values (
  '33333333-3333-4333-8333-333333333333',
  'anonymous-bag@magic-mirror.test',
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
    'a3300000-0000-4000-8000-000000000001',
    '11111111-1111-4111-8111-111111111111',
    'active',
    'complete',
    'Bag owner',
    34,
    now(),
    'woman',
    165,
    'regular',
    now()
  ),
  (
    'b3300000-0000-4000-8000-000000000001',
    '22222222-2222-4222-8222-222222222222',
    'active',
    'complete',
    'Other bag owner',
    35,
    now(),
    'woman',
    168,
    'regular',
    now()
  ),
  (
    'c3300000-0000-4000-8000-000000000001',
    '33333333-3333-4333-8333-333333333333',
    'draft',
    'welcome',
    null,
    null,
    null,
    null,
    null,
    null,
    null
  );

insert into public.consent_records (
  id,
  owner_id,
  profile_id,
  purpose,
  decision,
  policy_version,
  copy_sha256,
  captured_at
) values (
  'a3310000-0000-4000-8000-000000000001',
  '11111111-1111-4111-8111-111111111111',
  'a3300000-0000-4000-8000-000000000001',
  'live_camera',
  'granted',
  'bag-v1',
  decode(repeat('41', 32), 'hex'),
  now()
);

insert into public.live_sessions (
  id,
  owner_id,
  profile_id,
  catalog_product_ref,
  catalog_shop_ref,
  catalog_variant_ref,
  camera_consent_record_id
) values (
  'a3320000-0000-4000-8000-000000000001',
  '11111111-1111-4111-8111-111111111111',
  'a3300000-0000-4000-8000-000000000001',
  'shopify://product/live-one',
  'shopify://shop/one',
  'shopify://variant/live-one',
  'a3310000-0000-4000-8000-000000000001'
);

set local role authenticated;
select set_config(
  'request.jwt.claims',
  '{"sub":"11111111-1111-4111-8111-111111111111","role":"authenticated","is_anonymous":false}',
  true
);

select lives_ok(
  $$
    insert into public.bag_items (
      id,
      owner_id,
      profile_id,
      source,
      catalog_product_ref,
      catalog_shop_ref
    ) values (
      'a3330000-0000-4000-8000-000000000001',
      '11111111-1111-4111-8111-111111111111',
      'a3300000-0000-4000-8000-000000000001',
      'product_detail',
      'shopify://product/one',
      'shopify://shop/one'
    )
  $$,
  'a permanent owner can save a stable product reference'
);

select lives_ok(
  $$
    insert into public.bag_items (
      owner_id,
      profile_id,
      source,
      catalog_product_ref,
      catalog_shop_ref
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a3300000-0000-4000-8000-000000000001',
      'product_detail',
      'shopify://product/one',
      'shopify://shop/one'
    )
    on conflict do nothing
  $$,
  'duplicate save uses conflict-ignore idempotency'
);

select is(
  (
    select count(*)
    from public.bag_items
    where profile_id = 'a3300000-0000-4000-8000-000000000001'
      and catalog_product_ref = 'shopify://product/one'
  ),
  1::bigint,
  'duplicate add leaves exactly one bag row'
);

select throws_like(
  $$
    insert into public.bag_items (
      owner_id,
      profile_id,
      source,
      catalog_product_ref,
      catalog_shop_ref
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a3300000-0000-4000-8000-000000000001',
      'recommendation',
      'shopify://product/missing',
      'shopify://shop/one'
    )
  $$,
  'recommendation bag items require recommendation provenance',
  'recommendation saves require explicit source lineage'
);

select throws_like(
  $$
    insert into public.bag_items (
      owner_id,
      profile_id,
      source,
      catalog_product_ref,
      catalog_shop_ref,
      catalog_variant_ref,
      source_live_session_id
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a3300000-0000-4000-8000-000000000001',
      'live_session',
      'shopify://product/wrong',
      'shopify://shop/one',
      'shopify://variant/live-one',
      'a3320000-0000-4000-8000-000000000001'
    )
  $$,
  'live-session provenance must match the owned stable product reference',
  'live-session source cannot be attached to a different product'
);

select lives_ok(
  $$
    insert into public.bag_items (
      id,
      owner_id,
      profile_id,
      source,
      catalog_product_ref,
      catalog_shop_ref,
      catalog_variant_ref,
      source_live_session_id
    ) values (
      'a3330000-0000-4000-8000-000000000002',
      '11111111-1111-4111-8111-111111111111',
      'a3300000-0000-4000-8000-000000000001',
      'live_session',
      'shopify://product/live-one',
      'shopify://shop/one',
      'shopify://variant/live-one',
      'a3320000-0000-4000-8000-000000000001'
    )
  $$,
  'matching live-session provenance is accepted'
);

select throws_like(
  $$
    update public.bag_items
    set catalog_product_ref = 'shopify://product/changed'
    where id = 'a3330000-0000-4000-8000-000000000001'
  $$,
  '%permission denied for table bag_items%',
  'customers cannot mutate a saved stable reference'
);

select set_config(
  'request.jwt.claims',
  '{"sub":"22222222-2222-4222-8222-222222222222","role":"authenticated","is_anonymous":false}',
  true
);

select is(
  (select count(*) from public.bag_items),
  0::bigint,
  'another customer cannot read bag rows'
);

select lives_ok(
  $$
    delete from public.bag_items
    where id = 'a3330000-0000-4000-8000-000000000001'
  $$,
  'a cross-owner delete safely affects no visible rows'
);

set local role postgres;

select is(
  (
    select count(*)
    from public.bag_items
    where id = 'a3330000-0000-4000-8000-000000000001'
  ),
  1::bigint,
  'the cross-owner delete leaves the bag row intact'
);

set local role authenticated;
select set_config(
  'request.jwt.claims',
  '{"sub":"11111111-1111-4111-8111-111111111111","role":"authenticated","is_anonymous":true}',
  true
);

select is(
  (select count(*) from public.bag_items),
  0::bigint,
  'an anonymous identity cannot read permanent-account bag rows'
);

select throws_like(
  $$
    insert into public.bag_items (
      owner_id,
      profile_id,
      source,
      catalog_product_ref,
      catalog_shop_ref
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a3300000-0000-4000-8000-000000000001',
      'product_detail',
      'shopify://product/anonymous',
      'shopify://shop/one'
    )
  $$,
  '%new row violates row-level security policy for table "bag_items"%',
  'anonymous JWTs cannot save into a permanent account bag'
);

set local role postgres;

delete from public.live_sessions
where id = 'a3320000-0000-4000-8000-000000000001';

select is(
  (
    select source_live_session_id
    from public.bag_items
    where id = 'a3330000-0000-4000-8000-000000000002'
  ),
  null::uuid,
  'retention cleanup removes live lineage without deleting the bag item'
);

select is(
  (
    select source
    from public.bag_items
    where id = 'a3330000-0000-4000-8000-000000000002'
  ),
  'live_session'::text,
  'retention cleanup preserves the original save source'
);

select throws_like(
  $$
    insert into public.bag_items (
      owner_id,
      profile_id,
      source,
      catalog_product_ref,
      catalog_shop_ref
    ) values (
      '33333333-3333-4333-8333-333333333333',
      'c3300000-0000-4000-8000-000000000001',
      'product_detail',
      'shopify://product/anonymous',
      'shopify://shop/one'
    )
  $$,
  'bag items require a permanent account',
  'the database rejects anonymous-owner bag records even for service writes'
);

select * from finish();
rollback;
