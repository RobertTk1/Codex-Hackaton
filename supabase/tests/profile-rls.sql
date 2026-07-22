begin;

create extension if not exists pgtap with schema extensions;
select plan(20);

select results_eq(
  $$
    select policyname
    from pg_policies
    where schemaname = 'public'
      and tablename = 'profiles'
    order by policyname
  $$,
  array[
    'profiles_insert_own',
    'profiles_select_own',
    'profiles_update_own_draft'
  ]::name[],
  'profiles expose only customer read, draft-create, and draft-update policies'
);

select ok(
  has_table_privilege('authenticated', 'public.profiles', 'SELECT')
  and has_table_privilege('authenticated', 'public.profiles', 'INSERT')
  and has_column_privilege('authenticated', 'public.profiles', 'name', 'UPDATE')
  and not has_table_privilege('authenticated', 'public.profiles', 'DELETE')
  and not has_table_privilege('authenticated', 'public.profiles', 'TRUNCATE'),
  'authenticated profile grants match the approved draft-only exposure contract'
);

select ok(
  not has_table_privilege('anon', 'public.profiles', 'SELECT')
  and not has_table_privilege('anon', 'public.favorite_brands', 'SELECT')
  and not has_table_privilege('anon', 'public.brand_sizes', 'SELECT')
  and not has_table_privilege('anon', 'public.consent_records', 'SELECT'),
  'bare anonymous requests have no profile-graph access'
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
    'a1800000-0000-4000-8000-000000000001',
    '11111111-1111-4111-8111-111111111111',
    'draft',
    'brand_sizing',
    'Owner A draft',
    null,
    null,
    null,
    null,
    null,
    null
  ),
  (
    'a1800000-0000-4000-8000-000000000002',
    '11111111-1111-4111-8111-111111111111',
    'active',
    'complete',
    'Owner A active',
    34,
    now(),
    'woman',
    165,
    'regular',
    now()
  ),
  (
    'b1800000-0000-4000-8000-000000000001',
    '22222222-2222-4222-8222-222222222222',
    'draft',
    'brand_sizing',
    'Owner B draft',
    null,
    null,
    null,
    null,
    null,
    null
  );

insert into public.favorite_brands (
  id, owner_id, profile_id, brand_name, brand_key, preference_order
) values
  (
    'a1810000-0000-4000-8000-000000000001',
    '11111111-1111-4111-8111-111111111111',
    'a1800000-0000-4000-8000-000000000001',
    'Zara',
    'zara',
    1
  ),
  (
    'a1810000-0000-4000-8000-000000000002',
    '11111111-1111-4111-8111-111111111111',
    'a1800000-0000-4000-8000-000000000002',
    'COS',
    'cos',
    1
  ),
  (
    'b1810000-0000-4000-8000-000000000001',
    '22222222-2222-4222-8222-222222222222',
    'b1800000-0000-4000-8000-000000000001',
    'Arket',
    'arket',
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
) values
  (
    'a1820000-0000-4000-8000-000000000001',
    '11111111-1111-4111-8111-111111111111',
    'a1800000-0000-4000-8000-000000000001',
    'Zara',
    'zara',
    'jeans',
    'known',
    'L',
    1
  ),
  (
    'a1820000-0000-4000-8000-000000000002',
    '11111111-1111-4111-8111-111111111111',
    'a1800000-0000-4000-8000-000000000002',
    'COS',
    'cos',
    'tops',
    'known',
    'M',
    1
  ),
  (
    'b1820000-0000-4000-8000-000000000001',
    '22222222-2222-4222-8222-222222222222',
    'b1800000-0000-4000-8000-000000000001',
    'Arket',
    'arket',
    'outerwear',
    'known',
    'S',
    1
  );

insert into public.consent_records (
  id,
  owner_id,
  profile_id,
  purpose,
  decision,
  policy_version,
  copy_sha256
) values
  (
    'a1830000-0000-4000-8000-000000000001',
    '11111111-1111-4111-8111-111111111111',
    'a1800000-0000-4000-8000-000000000001',
    'profile_processing',
    'granted',
    '2026-07-22',
    decode(repeat('aa', 32), 'hex')
  ),
  (
    'a1830000-0000-4000-8000-000000000002',
    '11111111-1111-4111-8111-111111111111',
    'a1800000-0000-4000-8000-000000000002',
    'generated_likeness_preview',
    'granted',
    '2026-07-22',
    decode(repeat('bb', 32), 'hex')
  ),
  (
    'b1830000-0000-4000-8000-000000000001',
    '22222222-2222-4222-8222-222222222222',
    'b1800000-0000-4000-8000-000000000001',
    'profile_processing',
    'granted',
    '2026-07-22',
    decode(repeat('cc', 32), 'hex')
  );

set local role authenticated;
set local request.jwt.claim.sub = '11111111-1111-4111-8111-111111111111';

select is((select count(*) from public.profiles), 2::bigint, 'owner A reads only its profiles');
select is((select count(*) from public.favorite_brands), 2::bigint, 'owner A reads only its favorite brands');
select is((select count(*) from public.brand_sizes), 2::bigint, 'owner A reads only its garment-specific sizes');
select is((select count(*) from public.consent_records), 2::bigint, 'owner A reads only its consent history');

select is(
  (
    (select count(*) from public.profiles where owner_id = '22222222-2222-4222-8222-222222222222')
    + (select count(*) from public.favorite_brands where owner_id = '22222222-2222-4222-8222-222222222222')
    + (select count(*) from public.brand_sizes where owner_id = '22222222-2222-4222-8222-222222222222')
    + (select count(*) from public.consent_records where owner_id = '22222222-2222-4222-8222-222222222222')
  ),
  0::bigint,
  'owner A reads zero rows from owner B profile graph'
);

select lives_ok(
  $$
    insert into public.profiles (id, owner_id, name)
    values (
      'a1800000-0000-4000-8000-000000000003',
      '11111111-1111-4111-8111-111111111111',
      'Owner A new draft'
    )
  $$,
  'owner A can create its own draft profile'
);

select throws_like(
  $$
    insert into public.profiles (
      id, owner_id, status, current_step, name, age, adult_confirmed_at,
      gender, height_cm, fit_preference, submitted_at
    ) values (
      'a1800000-0000-4000-8000-000000000004',
      '11111111-1111-4111-8111-111111111111',
      'submitted', 'complete', 'Owner A bypass', 34, now(),
      'woman', 165, 'regular', now()
    )
  $$,
  '%row-level security policy%',
  'customer creation rejects a non-draft profile'
);

select throws_like(
  $$
    insert into public.profiles (owner_id, name)
    values (
      '22222222-2222-4222-8222-222222222222',
      'Cross-owner draft'
    )
  $$,
  '%row-level security policy%',
  'owner A cannot create a profile for owner B'
);

select throws_like(
  $$
    delete from public.profiles
    where id = 'a1800000-0000-4000-8000-000000000001'
  $$,
  '%permission denied for table profiles%',
  'customer-facing deletion cannot remove an owned draft profile'
);

select is_empty(
  $$
    update public.profiles
    set height_cm = 170
    where id = 'a1800000-0000-4000-8000-000000000002'
    returning id
  $$,
  'submitted profile evidence cannot be changed by its owner'
);

select throws_like(
  $$
    insert into public.favorite_brands (
      owner_id, profile_id, brand_name, brand_key, preference_order
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a1800000-0000-4000-8000-000000000002',
      'Everlane', 'everlane', 2
    )
  $$,
  '%profile evidence is immutable after submission%',
  'submitted profiles reject new favorite-brand evidence'
);

select is_empty(
  $$
    update public.favorite_brands
    set preference_order = 2
    where id = 'a1810000-0000-4000-8000-000000000002'
    returning id
  $$,
  'submitted profiles reject favorite-brand evidence updates'
);

select throws_like(
  $$
    insert into public.brand_sizes (
      owner_id, profile_id, brand_name, brand_key, garment_type,
      size_status, size_label, preference_order
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a1800000-0000-4000-8000-000000000002',
      'COS', 'cos', 'jeans', 'known', 'L', 2
    )
  $$,
  '%profile evidence is immutable after submission%',
  'submitted profiles reject new garment-size evidence'
);

select is_empty(
  $$
    update public.brand_sizes
    set size_label = 'L'
    where id = 'a1820000-0000-4000-8000-000000000002'
    returning id
  $$,
  'submitted profiles reject garment-size evidence updates'
);

select lives_ok(
  $$
    insert into public.consent_records (
      owner_id, profile_id, purpose, decision, policy_version, copy_sha256
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a1800000-0000-4000-8000-000000000002',
      'photo_analysis', 'granted', '2026-07-22',
      decode(repeat('dd', 32), 'hex')
    )
  $$,
  'an owner can append consent history after profile submission'
);

select throws_like(
  $$
    update public.consent_records
    set decision = 'revoked'
    where id = 'a1830000-0000-4000-8000-000000000002'
  $$,
  '%permission denied for table consent_records%',
  'an owner cannot mutate consent history'
);

set local request.jwt.claim.sub = '22222222-2222-4222-8222-222222222222';

select is(
  (
    (select count(*) from public.profiles where owner_id = '11111111-1111-4111-8111-111111111111')
    + (select count(*) from public.favorite_brands where owner_id = '11111111-1111-4111-8111-111111111111')
    + (select count(*) from public.brand_sizes where owner_id = '11111111-1111-4111-8111-111111111111')
    + (select count(*) from public.consent_records where owner_id = '11111111-1111-4111-8111-111111111111')
  ),
  0::bigint,
  'owner B reads zero rows from owner A profile graph'
);

select * from finish();
rollback;
