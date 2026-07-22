begin;

create extension if not exists pgtap with schema extensions;
select plan(53);

select has_table('public', 'favorite_brands', 'favorite brands table exists');

select columns_are(
  'public',
  'favorite_brands',
  array[
    'id',
    'owner_id',
    'profile_id',
    'brand_name',
    'brand_key',
    'preference_order',
    'created_at',
    'updated_at'
  ],
  'favorite brands expose only the approved columns'
);

select has_table('public', 'brand_sizes', 'brand sizes table exists');

select columns_are(
  'public',
  'brand_sizes',
  array[
    'id',
    'owner_id',
    'profile_id',
    'brand_name',
    'brand_key',
    'garment_type',
    'size_status',
    'size_label',
    'preference_order',
    'created_at',
    'updated_at'
  ],
  'brand sizes expose only the approved columns'
);

select has_fk(
  'public',
  'favorite_brands',
  'favorite brands have an owned profile foreign key'
);

select ok(
  exists (
    select 1
    from pg_constraint as constraint_record
    where constraint_record.conrelid = 'public.brand_sizes'::regclass
      and constraint_record.conname = 'brand_sizes_owner_profile_fk'
      and constraint_record.confrelid = 'public.profiles'::regclass
  ),
  'brand sizes have an owned profile foreign key'
);

select ok(
  exists (
    select 1
    from pg_constraint as constraint_record
    where constraint_record.conrelid = 'public.brand_sizes'::regclass
      and constraint_record.conname = 'brand_sizes_favorite_brand_fk'
      and constraint_record.confrelid = 'public.favorite_brands'::regclass
  ),
  'brand sizes must reference a selected favorite brand'
);

select has_index(
  'public',
  'favorite_brands',
  'favorite_brands_owner_id_key',
  'favorite brands expose the same-owner composite key'
);

select has_index(
  'public',
  'favorite_brands',
  'favorite_brands_owner_profile_idx',
  'favorite brands cover the owned-profile foreign key'
);

select has_index(
  'public',
  'favorite_brands',
  'favorite_brands_profile_order_idx',
  'favorite brand ordering is unique per profile'
);

select has_index(
  'public',
  'favorite_brands',
  'favorite_brands_profile_key_idx',
  'favorite brand keys are unique per profile'
);

select has_index(
  'public',
  'brand_sizes',
  'brand_sizes_owner_id_key',
  'brand sizes expose the same-owner composite key'
);

select has_index(
  'public',
  'brand_sizes',
  'brand_sizes_owner_profile_idx',
  'brand sizes cover the owned-profile foreign key'
);

select has_index(
  'public',
  'brand_sizes',
  'brand_sizes_profile_order_idx',
  'brand sizes support stable profile ordering'
);

select has_index(
  'public',
  'brand_sizes',
  'brand_sizes_profile_brand_garment_type_idx',
  'brand sizes are unique by profile, brand, and garment type'
);

select ok(
  (
    select relation.relrowsecurity
    from pg_class as relation
    where relation.oid = 'public.favorite_brands'::regclass
  )
  and (
    select relation.relrowsecurity
    from pg_class as relation
    where relation.oid = 'public.brand_sizes'::regclass
  ),
  'both customer-owned brand tables have row-level security enabled'
);

select ok(
  not has_table_privilege('anon', 'public.favorite_brands', 'SELECT')
  and not has_table_privilege('anon', 'public.favorite_brands', 'INSERT')
  and not has_table_privilege('anon', 'public.brand_sizes', 'SELECT')
  and not has_table_privilege('anon', 'public.brand_sizes', 'INSERT'),
  'the bare anon role has no brand-data privileges'
);

select ok(
  has_table_privilege('authenticated', 'public.favorite_brands', 'SELECT')
  and has_table_privilege('authenticated', 'public.favorite_brands', 'INSERT')
  and has_table_privilege('authenticated', 'public.favorite_brands', 'DELETE')
  and has_table_privilege('authenticated', 'public.brand_sizes', 'SELECT')
  and has_table_privilege('authenticated', 'public.brand_sizes', 'INSERT')
  and has_table_privilege('authenticated', 'public.brand_sizes', 'DELETE'),
  'authenticated identities receive the approved brand-data operations'
);

select ok(
  has_column_privilege(
    'authenticated',
    'public.favorite_brands',
    'preference_order',
    'UPDATE'
  )
  and has_column_privilege(
    'authenticated',
    'public.brand_sizes',
    'size_label',
    'UPDATE'
  )
  and not has_column_privilege(
    'authenticated',
    'public.favorite_brands',
    'owner_id',
    'UPDATE'
  )
  and not has_column_privilege(
    'authenticated',
    'public.brand_sizes',
    'profile_id',
    'UPDATE'
  ),
  'authenticated updates cannot reassign brand evidence ownership'
);

select ok(
  has_table_privilege('service_role', 'public.favorite_brands', 'SELECT')
  and has_table_privilege('service_role', 'public.favorite_brands', 'INSERT')
  and has_table_privilege('service_role', 'public.favorite_brands', 'UPDATE')
  and has_table_privilege('service_role', 'public.favorite_brands', 'DELETE')
  and has_table_privilege('service_role', 'public.brand_sizes', 'SELECT')
  and has_table_privilege('service_role', 'public.brand_sizes', 'INSERT')
  and has_table_privilege('service_role', 'public.brand_sizes', 'UPDATE')
  and has_table_privilege('service_role', 'public.brand_sizes', 'DELETE')
  and not has_table_privilege('service_role', 'public.brand_sizes', 'TRUNCATE'),
  'service role receives bounded brand-data DML without truncate authority'
);

select results_eq(
  $$
    select policyname
    from pg_policies
    where schemaname = 'public'
      and tablename = 'favorite_brands'
    order by policyname
  $$,
  array[
    'favorite_brands_delete_own_draft',
    'favorite_brands_insert_own_draft',
    'favorite_brands_select_own',
    'favorite_brands_update_own_draft'
  ]::name[],
  'favorite brands use separate least-privilege policies per operation'
);

select results_eq(
  $$
    select policyname
    from pg_policies
    where schemaname = 'public'
      and tablename = 'brand_sizes'
    order by policyname
  $$,
  array[
    'brand_sizes_delete_own_draft',
    'brand_sizes_insert_own_draft',
    'brand_sizes_select_own',
    'brand_sizes_update_own_draft'
  ]::name[],
  'brand sizes use separate least-privilege policies per operation'
);

select has_function(
  'private',
  'enforce_draft_profile_evidence',
  array[]::text[],
  'draft-evidence contract trigger helper exists'
);

select is(
  (
    select procedure.prosecdef
    from pg_proc as procedure
    join pg_namespace as namespace on namespace.oid = procedure.pronamespace
    where namespace.nspname = 'private'
      and procedure.proname = 'enforce_draft_profile_evidence'
      and procedure.pronargs = 0
  ),
  false,
  'draft-evidence helper is security invoker'
);

select ok(
  (
    select coalesce('search_path=""' = any(procedure.proconfig), false)
    from pg_proc as procedure
    join pg_namespace as namespace on namespace.oid = procedure.pronamespace
    where namespace.nspname = 'private'
      and procedure.proname = 'enforce_draft_profile_evidence'
      and procedure.pronargs = 0
  ),
  'draft-evidence helper fixes an empty search path'
);

select ok(
  not has_function_privilege(
    'authenticated',
    'private.enforce_draft_profile_evidence()'::regprocedure,
    'EXECUTE'
  )
  and not has_function_privilege(
    'service_role',
    'private.enforce_draft_profile_evidence()'::regprocedure,
    'EXECUTE'
  ),
  'draft-evidence helper is trigger-only'
);

select results_eq(
  $$
    select trigger_name
    from information_schema.triggers
    where event_object_schema = 'public'
      and event_object_table = 'favorite_brands'
    group by trigger_name
    order by trigger_name
  $$,
  array[
    'favorite_brands_enforce_draft_profile',
    'favorite_brands_set_updated_at'
  ]::information_schema.sql_identifier[],
  'favorite brands install the contract and timestamp triggers'
);

select results_eq(
  $$
    select trigger_name
    from information_schema.triggers
    where event_object_schema = 'public'
      and event_object_table = 'brand_sizes'
    group by trigger_name
    order by trigger_name
  $$,
  array[
    'brand_sizes_enforce_draft_profile',
    'brand_sizes_set_updated_at'
  ]::information_schema.sql_identifier[],
  'brand sizes install the contract and timestamp triggers'
);

select lives_ok(
  $$
    insert into public.profiles (id, owner_id, name)
    values
      (
        'aaaaaaaa-1000-4000-8000-000000000001',
        '11111111-1111-4111-8111-111111111111',
        'Owner A brand draft'
      ),
      (
        'bbbbbbbb-1000-4000-8000-000000000001',
        '22222222-2222-4222-8222-222222222222',
        'Owner B brand draft'
      )
  $$,
  'brand tests have isolated draft-profile fixtures'
);

set local role authenticated;
set local request.jwt.claim.sub = '11111111-1111-4111-8111-111111111111';

select lives_ok(
  $$
    insert into public.favorite_brands (
      id,
      owner_id,
      profile_id,
      brand_name,
      brand_key,
      preference_order
    ) values (
      'aaaaaaaa-2000-4000-8000-000000000001',
      '11111111-1111-4111-8111-111111111111',
      'aaaaaaaa-1000-4000-8000-000000000001',
      'Zara',
      'zara',
      1
    )
  $$,
  'owner A can select Zara as a favorite brand'
);

select lives_ok(
  $$
    insert into public.brand_sizes (
      id,
      owner_id,
      profile_id,
      brand_name,
      brand_key,
      garment_type,
      size_status,
      size_label,
      preference_order
    ) values
      (
        'aaaaaaaa-3000-4000-8000-000000000001',
        '11111111-1111-4111-8111-111111111111',
        'aaaaaaaa-1000-4000-8000-000000000001',
        'Zara',
        'zara',
        'jeans',
        'known',
        'L',
        1
      ),
      (
        'aaaaaaaa-3000-4000-8000-000000000002',
        '11111111-1111-4111-8111-111111111111',
        'aaaaaaaa-1000-4000-8000-000000000001',
        'Zara',
        'zara',
        'tops',
        'known',
        'M',
        2
      )
  $$,
  'Zara jeans L and Zara tops M coexist without overwriting each other'
);

select throws_like(
  $$
    insert into public.brand_sizes (
      owner_id,
      profile_id,
      brand_name,
      brand_key,
      garment_type,
      size_status,
      size_label,
      preference_order
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'aaaaaaaa-1000-4000-8000-000000000001',
      'Zara',
      'zara',
      'jeans',
      'known',
      '26',
      3
    )
  $$,
  '%brand_sizes_profile_brand_garment_type_idx%',
  'a duplicate brand plus garment type is rejected'
);

select throws_like(
  $$
    insert into public.brand_sizes (
      owner_id,
      profile_id,
      brand_name,
      brand_key,
      garment_type,
      size_status,
      size_label,
      preference_order
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'aaaaaaaa-1000-4000-8000-000000000001',
      'Zara',
      'zara',
      'dresses',
      'known',
      null,
      3
    )
  $$,
  '%brand_sizes_size_label_check%',
  'a known size requires a label'
);

select lives_ok(
  $$
    insert into public.brand_sizes (
      id,
      owner_id,
      profile_id,
      brand_name,
      brand_key,
      garment_type,
      size_status,
      size_label,
      preference_order
    ) values (
      'aaaaaaaa-3000-4000-8000-000000000003',
      '11111111-1111-4111-8111-111111111111',
      'aaaaaaaa-1000-4000-8000-000000000001',
      'Zara',
      'zara',
      'dresses',
      'unknown',
      null,
      3
    )
  $$,
  'an unknown garment size is recorded without inventing a label'
);

select throws_like(
  $$
    insert into public.brand_sizes (
      owner_id,
      profile_id,
      brand_name,
      brand_key,
      garment_type,
      size_status,
      size_label,
      preference_order
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'aaaaaaaa-1000-4000-8000-000000000001',
      'Zara',
      'zara',
      'skirts',
      'unknown',
      'M',
      4
    )
  $$,
  '%brand_sizes_size_label_check%',
  'an unknown size rejects a contradictory label'
);

select throws_like(
  $$
    insert into public.brand_sizes (
      owner_id,
      profile_id,
      brand_name,
      brand_key,
      garment_type,
      size_status,
      size_label,
      preference_order
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'aaaaaaaa-1000-4000-8000-000000000001',
      'Zara',
      'zara',
      'socks',
      'known',
      'M',
      4
    )
  $$,
  '%brand_sizes_garment_type_check%',
  'garment types are limited to the approved contract'
);

select throws_like(
  $$
    insert into public.favorite_brands (
      owner_id,
      profile_id,
      brand_name,
      brand_key,
      preference_order
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'aaaaaaaa-1000-4000-8000-000000000001',
      'Banana Republic',
      'Banana   Republic',
      2
    )
  $$,
  '%favorite_brands_brand_key_check%',
  'brand keys must already use lowercase normalized whitespace'
);

select throws_like(
  $$
    insert into public.favorite_brands (
      owner_id,
      profile_id,
      brand_name,
      brand_key,
      preference_order
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'aaaaaaaa-1000-4000-8000-000000000001',
      'ZARA',
      'zara',
      2
    )
  $$,
  '%favorite_brands_profile_key_idx%',
  'a profile cannot select the same normalized brand twice'
);

select throws_like(
  $$
    insert into public.favorite_brands (
      owner_id,
      profile_id,
      brand_name,
      brand_key,
      preference_order
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'aaaaaaaa-1000-4000-8000-000000000001',
      'H&M',
      'h&m',
      1
    )
  $$,
  '%favorite_brands_profile_order_idx%',
  'favorite-brand order is unique within a profile'
);

select throws_like(
  $$
    insert into public.brand_sizes (
      owner_id,
      profile_id,
      brand_name,
      brand_key,
      garment_type,
      size_status,
      size_label,
      preference_order
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'aaaaaaaa-1000-4000-8000-000000000001',
      'H&M',
      'h&m',
      'tops',
      'known',
      'M',
      4
    )
  $$,
  '%brand_sizes_favorite_brand_fk%',
  'a garment size cannot exist for a brand not selected as a favorite'
);

select throws_like(
  $$
    insert into public.favorite_brands (
      owner_id,
      profile_id,
      brand_name,
      brand_key,
      preference_order
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'aaaaaaaa-1000-4000-8000-000000000001',
      'H&M',
      'h&m',
      21
    )
  $$,
  '%favorite_brands_preference_order_check%',
  'favorite-brand order is bounded to twenty entries'
);

select results_eq(
  $$
    select brand_name
    from public.favorite_brands
    order by preference_order
  $$,
  array['Zara']::text[],
  'owner A sees only its own favorite brands'
);

select is_empty(
  $$
    select id
    from public.favorite_brands
    where owner_id = '22222222-2222-4222-8222-222222222222'::uuid
  $$,
  'owner A cannot read owner B brand evidence'
);

select throws_like(
  $$
    insert into public.favorite_brands (
      owner_id,
      profile_id,
      brand_name,
      brand_key,
      preference_order
    ) values (
      '22222222-2222-4222-8222-222222222222',
      'bbbbbbbb-1000-4000-8000-000000000001',
      'COS',
      'cos',
      1
    )
  $$,
  '%profile evidence requires an owned parent profile%',
  'owner A cannot write favorite brands for owner B'
);

select lives_ok(
  $$
    update public.favorite_brands
    set brand_name = 'ZARA'
    where id = 'aaaaaaaa-2000-4000-8000-000000000001'
  $$,
  'a draft favorite brand can be corrected'
);

select ok(
  (
    select updated_at > created_at
    from public.favorite_brands
    where id = 'aaaaaaaa-2000-4000-8000-000000000001'
  ),
  'favorite-brand updates maintain updated_at'
);

select throws_like(
  $$
    update public.brand_sizes
    set owner_id = '22222222-2222-4222-8222-222222222222'
    where id = 'aaaaaaaa-3000-4000-8000-000000000001'
  $$,
  '%permission denied%',
  'customer-facing brand-size writes cannot reassign ownership'
);

reset role;

select lives_ok(
  $$
    insert into public.profiles (id, owner_id, name)
    values (
      'aaaaaaaa-1000-4000-8000-000000000002',
      '11111111-1111-4111-8111-111111111111',
      'Owner A completed evidence'
    );

    insert into public.favorite_brands (
      id,
      owner_id,
      profile_id,
      brand_name,
      brand_key,
      preference_order
    ) values (
      'aaaaaaaa-2000-4000-8000-000000000002',
      '11111111-1111-4111-8111-111111111111',
      'aaaaaaaa-1000-4000-8000-000000000002',
      'COS',
      'cos',
      1
    );

    insert into public.brand_sizes (
      id,
      owner_id,
      profile_id,
      brand_name,
      brand_key,
      garment_type,
      size_status,
      size_label,
      preference_order
    ) values (
      'aaaaaaaa-3000-4000-8000-000000000010',
      '11111111-1111-4111-8111-111111111111',
      'aaaaaaaa-1000-4000-8000-000000000002',
      'COS',
      'cos',
      'tops',
      'known',
      'M',
      1
    );

    update public.profiles
    set
      status = 'active',
      current_step = 'complete',
      revision = 2,
      name = 'Owner A completed evidence',
      age = 34,
      adult_confirmed_at = now(),
      gender = 'woman',
      height_cm = 165,
      fit_preference = 'regular',
      submitted_at = now()
    where id = 'aaaaaaaa-1000-4000-8000-000000000002'
  $$,
  'a populated brand-evidence fixture can reach the active profile state'
);

set local role service_role;

select throws_like(
  $$
    update public.brand_sizes
    set size_label = 'S'
    where id = 'aaaaaaaa-3000-4000-8000-000000000010'
  $$,
  '%profile evidence is immutable after submission%',
  'service-role writes cannot mutate submitted brand evidence'
);

reset role;
set local role authenticated;
set local request.jwt.claim.sub = '11111111-1111-4111-8111-111111111111';

select results_eq(
  $$
    delete from public.favorite_brands
    where id = 'aaaaaaaa-2000-4000-8000-000000000002'
    returning id
  $$,
  array[]::uuid[],
  'customer-facing deletion cannot remove submitted favorite brands'
);

select throws_like(
  $$
    delete from public.profiles
    where id = 'aaaaaaaa-1000-4000-8000-000000000001'
  $$,
  '%permission denied for table profiles%',
  'an owner cannot directly delete a draft profile and its brand evidence'
);

reset role;
set local role service_role;

delete from public.profiles
where id = 'aaaaaaaa-1000-4000-8000-000000000001';

select is(
  (
    select count(*)
    from public.favorite_brands
    where profile_id = 'aaaaaaaa-1000-4000-8000-000000000001'
  ) + (
    select count(*)
    from public.brand_sizes
    where profile_id = 'aaaaaaaa-1000-4000-8000-000000000001'
  ),
  0::bigint,
  'draft-profile deletion cascades all favorite-brand and garment-size evidence'
);

set local role anon;

select throws_like(
  $$select id from public.favorite_brands limit 1$$,
  '%permission denied for table favorite_brands%',
  'bare publishable-key access fails closed'
);

reset role;

select * from finish();
rollback;
