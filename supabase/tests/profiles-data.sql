begin;

create extension if not exists pgtap with schema extensions;
select plan(50);

select has_table('public', 'profiles', 'profiles table exists');

select columns_are(
  'public',
  'profiles',
  array[
    'id',
    'owner_id',
    'derived_from_profile_id',
    'status',
    'current_step',
    'revision',
    'name',
    'age',
    'adult_confirmed_at',
    'gender',
    'height_cm',
    'weight_kg',
    'fit_preference',
    'submitted_at',
    'last_activity_at',
    'created_at',
    'updated_at'
  ],
  'profiles expose only the approved profile columns'
);

select ok(
  exists (
    select 1
    from pg_constraint as constraint_record
    where constraint_record.conrelid = 'public.profiles'::regclass
      and constraint_record.conname = 'profiles_owner_fk'
      and constraint_record.confrelid = 'auth.users'::regclass
  ),
  'profile owner references the Auth identity authority'
);

select ok(
  exists (
    select 1
    from pg_constraint as constraint_record
    where constraint_record.conrelid = 'public.profiles'::regclass
      and constraint_record.conname = 'profiles_derived_from_fk'
      and constraint_record.confrelid = 'public.profiles'::regclass
  ),
  'profile lineage references profiles'
);

select has_index(
  'public',
  'profiles',
  'profiles_owner_id_key',
  'profiles expose the same-owner composite key'
);

select is(
  (
    select relation.relrowsecurity
    from pg_class as relation
    where relation.oid = 'public.profiles'::regclass
  ),
  true,
  'profiles have row-level security enabled'
);

select ok(
  not has_table_privilege('anon', 'public.profiles', 'SELECT')
  and not has_table_privilege('anon', 'public.profiles', 'INSERT')
  and not has_table_privilege('anon', 'public.profiles', 'UPDATE')
  and not has_table_privilege('anon', 'public.profiles', 'DELETE'),
  'the bare anon role has no profile privileges'
);

select ok(
  has_table_privilege('authenticated', 'public.profiles', 'SELECT')
  and has_table_privilege('authenticated', 'public.profiles', 'INSERT')
  and not has_table_privilege('authenticated', 'public.profiles', 'DELETE')
  and not has_table_privilege('authenticated', 'public.profiles', 'TRUNCATE'),
  'authenticated identities receive profile read and draft-create operations without destructive authority'
);

select ok(
  has_column_privilege(
    'authenticated',
    'public.profiles',
    'name',
    'UPDATE'
  )
  and has_column_privilege(
    'authenticated',
    'public.profiles',
    'revision',
    'UPDATE'
  )
  and not has_column_privilege(
    'authenticated',
    'public.profiles',
    'owner_id',
    'UPDATE'
  )
  and not has_column_privilege(
    'authenticated',
    'public.profiles',
    'derived_from_profile_id',
    'UPDATE'
  ),
  'authenticated updates are limited to approved mutable profile columns'
);

select ok(
  has_table_privilege('service_role', 'public.profiles', 'SELECT')
  and has_table_privilege('service_role', 'public.profiles', 'INSERT')
  and has_table_privilege('service_role', 'public.profiles', 'UPDATE')
  and has_table_privilege('service_role', 'public.profiles', 'DELETE')
  and not has_table_privilege('service_role', 'public.profiles', 'TRUNCATE'),
  'service role receives profile DML without destructive table authority'
);

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
  'profiles use separate least-privilege policies for each operation'
);

select has_index(
  'public',
  'profiles',
  'profiles_owner_status_idx',
  'profiles support owner-scoped resume queries'
);

select has_index(
  'public',
  'profiles',
  'profiles_one_active_idx',
  'profiles have the one-active-profile index'
);

select has_index(
  'public',
  'profiles',
  'profiles_anonymous_cleanup_idx',
  'profiles support bounded draft cleanup queries'
);

select has_index(
  'public',
  'profiles',
  'profiles_derived_from_profile_id_idx',
  'profile lineage has a foreign-key index'
);

select has_function(
  'private',
  'enforce_profile_contract',
  array[]::text[],
  'profile contract trigger helper exists'
);

select is(
  (
    select procedure.prosecdef
    from pg_proc as procedure
    join pg_namespace as namespace on namespace.oid = procedure.pronamespace
    where namespace.nspname = 'private'
      and procedure.proname = 'enforce_profile_contract'
      and procedure.pronargs = 0
  ),
  false,
  'profile contract helper is security invoker'
);

select ok(
  (
    select coalesce('search_path=""' = any(procedure.proconfig), false)
    from pg_proc as procedure
    join pg_namespace as namespace on namespace.oid = procedure.pronamespace
    where namespace.nspname = 'private'
      and procedure.proname = 'enforce_profile_contract'
      and procedure.pronargs = 0
  ),
  'profile contract helper fixes an empty search path'
);

select ok(
  not has_function_privilege(
    'authenticated',
    'private.enforce_profile_contract()'::regprocedure,
    'EXECUTE'
  )
  and not has_function_privilege(
    'anon',
    'private.enforce_profile_contract()'::regprocedure,
    'EXECUTE'
  )
  and not exists (
    select 1
    from aclexplode(
      coalesce(
        (
          select procedure.proacl
          from pg_proc as procedure
          where procedure.oid =
            'private.enforce_profile_contract()'::regprocedure
        ),
        acldefault('f', (
          select procedure.proowner
          from pg_proc as procedure
          where procedure.oid =
            'private.enforce_profile_contract()'::regprocedure
        ))
      )
    ) as privilege
    where privilege.grantee = 0
      and privilege.privilege_type = 'EXECUTE'
  ),
  'profile contract helper is trigger-only'
);

select throws_like(
  $$insert into public.profiles (id) values ('aaaaaaaa-0000-4000-8000-000000000099')$$,
  '%null value in column "owner_id"%',
  'profile rows require an owner'
);

select throws_like(
  $$
    insert into public.profiles (id, owner_id, name)
    values (
      'aaaaaaaa-0000-4000-8000-000000000098',
      '11111111-1111-4111-8111-111111111111',
      '   '
    )
  $$,
  '%profiles_name_check%',
  'profile names reject whitespace-only values'
);

select throws_like(
  $$
    insert into public.profiles (id, owner_id, age)
    values (
      'aaaaaaaa-0000-4000-8000-000000000097',
      '11111111-1111-4111-8111-111111111111',
      17
    )
  $$,
  '%profiles_age_check%',
  'profile age rejects values below the adult boundary'
);

select throws_like(
  $$
    insert into public.profiles (id, owner_id, age)
    values (
      'aaaaaaaa-0000-4000-8000-000000000096',
      '11111111-1111-4111-8111-111111111111',
      121
    )
  $$,
  '%profiles_age_check%',
  'profile age rejects values above the approved bound'
);

select throws_like(
  $$
    insert into public.profiles (id, owner_id, height_cm)
    values (
      'aaaaaaaa-0000-4000-8000-000000000095',
      '11111111-1111-4111-8111-111111111111',
      79.99
    )
  $$,
  '%profiles_height_cm_check%',
  'profile height rejects values below the approved bound'
);

select throws_like(
  $$
    insert into public.profiles (id, owner_id, height_cm)
    values (
      'aaaaaaaa-0000-4000-8000-000000000094',
      '11111111-1111-4111-8111-111111111111',
      250.01
    )
  $$,
  '%profiles_height_cm_check%',
  'profile height rejects values above the approved bound'
);

select throws_like(
  $$
    insert into public.profiles (id, owner_id, weight_kg)
    values (
      'aaaaaaaa-0000-4000-8000-000000000093',
      '11111111-1111-4111-8111-111111111111',
      24.99
    )
  $$,
  '%profiles_weight_kg_check%',
  'optional profile weight rejects values below the approved bound'
);

select throws_like(
  $$
    insert into public.profiles (id, owner_id, weight_kg)
    values (
      'aaaaaaaa-0000-4000-8000-000000000092',
      '11111111-1111-4111-8111-111111111111',
      400.01
    )
  $$,
  '%profiles_weight_kg_check%',
  'optional profile weight rejects values above the approved bound'
);

select throws_like(
  $$
    insert into public.profiles (id, owner_id, gender)
    values (
      'aaaaaaaa-0000-4000-8000-000000000091',
      '11111111-1111-4111-8111-111111111111',
      '   '
    )
  $$,
  '%profiles_gender_check%',
  'profile gender rejects whitespace-only values'
);

select throws_like(
  $$
    insert into public.profiles (id, owner_id, fit_preference)
    values (
      'aaaaaaaa-0000-4000-8000-000000000090',
      '11111111-1111-4111-8111-111111111111',
      'oversized'
    )
  $$,
  '%profiles_fit_preference_check%',
  'profile fit preference accepts only the approved choices'
);

select throws_like(
  $$
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
      submitted_at
    ) values (
      'aaaaaaaa-0000-4000-8000-000000000089',
      '11111111-1111-4111-8111-111111111111',
      'submitted',
      'complete',
      'Owner A',
      34,
      now(),
      'woman',
      165,
      now()
    )
  $$,
  '%profiles_submission_state_check%',
  'a non-draft profile rejects a missing fit preference'
);

select lives_ok(
  $$
    insert into public.profiles (id, owner_id, name)
    values (
      'aaaaaaaa-0000-4000-8000-000000000001',
      '11111111-1111-4111-8111-111111111111',
      'Owner A'
    )
  $$,
  'owner A can create a bounded draft profile'
);

select lives_ok(
  $$
    insert into public.profiles (id, owner_id, name)
    values (
      'bbbbbbbb-0000-4000-8000-000000000001',
      '22222222-2222-4222-8222-222222222222',
      'Owner B'
    )
  $$,
  'owner B fixture has an isolated draft profile'
);

set local role authenticated;
set local request.jwt.claim.sub = '11111111-1111-4111-8111-111111111111';

select results_eq(
  $$select name from public.profiles order by name$$,
  array['Owner A']::text[],
  'owner A sees only its own profile'
);

select is_empty(
  $$
    select id
    from public.profiles
    where owner_id = '22222222-2222-4222-8222-222222222222'::uuid
  $$,
  'owner A cannot read owner B profile'
);

select throws_like(
  $$
    insert into public.profiles (id, owner_id)
    values (
      'bbbbbbbb-0000-4000-8000-000000000002',
      '22222222-2222-4222-8222-222222222222'
    )
  $$,
  '%row-level security policy%',
  'owner A cannot create a profile for owner B'
);

select throws_like(
  $$
    update public.profiles
    set name = 'Changed without revision'
    where id = 'aaaaaaaa-0000-4000-8000-000000000001'
  $$,
  '%accepted draft mutations must advance the profile revision%',
  'accepted draft mutations require a revision advance'
);

select lives_ok(
  $$
    update public.profiles
    set name = 'Owner A revised', revision = 2
    where id = 'aaaaaaaa-0000-4000-8000-000000000001'
  $$,
  'a draft mutation can advance the revision by one'
);

select ok(
  (
    select updated_at > created_at
    from public.profiles
    where id = 'aaaaaaaa-0000-4000-8000-000000000001'
  ),
  'profile updates maintain updated_at'
);

select throws_like(
  $$
    update public.profiles
    set revision = 4
    where id = 'aaaaaaaa-0000-4000-8000-000000000001'
  $$,
  '%profile revision can advance by only one%',
  'a profile revision cannot skip forward'
);

select throws_like(
  $$
    update public.profiles
    set revision = 1
    where id = 'aaaaaaaa-0000-4000-8000-000000000001'
  $$,
  '%profile revision cannot decrease%',
  'a profile revision cannot decrease'
);

select throws_like(
  $$
    update public.profiles
    set owner_id = '22222222-2222-4222-8222-222222222222'
    where id = 'aaaaaaaa-0000-4000-8000-000000000001'
  $$,
  '%permission denied%',
  'customer-facing profile writes cannot reassign ownership'
);

select lives_ok(
  $$
    insert into public.profiles (
      id,
      owner_id,
      derived_from_profile_id,
      name
    ) values (
      'aaaaaaaa-0000-4000-8000-000000000002',
      '11111111-1111-4111-8111-111111111111',
      'aaaaaaaa-0000-4000-8000-000000000001',
      'Owner A next draft'
    )
  $$,
  'a profile can derive from another profile owned by the same identity'
);

select throws_like(
  $$
    insert into public.profiles (
      id,
      owner_id,
      derived_from_profile_id
    ) values (
      'aaaaaaaa-0000-4000-8000-000000000003',
      '11111111-1111-4111-8111-111111111111',
      'bbbbbbbb-0000-4000-8000-000000000001'
    )
  $$,
  '%derived profile must reference a profile with the same owner%',
  'profile lineage cannot cross owners'
);

reset role;

select lives_ok(
  $$
    insert into public.profiles (
      id,
      owner_id,
      status,
      current_step,
      revision,
      name,
      age,
      adult_confirmed_at,
      gender,
      height_cm,
      fit_preference,
      submitted_at
    ) values (
      'aaaaaaaa-0000-4000-8000-000000000010',
      '11111111-1111-4111-8111-111111111111',
      'active',
      'complete',
      4,
      'Owner A',
      34,
      now(),
      'woman',
      165,
      'regular',
      now()
    )
  $$,
  'a complete profile satisfies the non-draft contract'
);

select throws_like(
  $$
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
    ) values (
      'aaaaaaaa-0000-4000-8000-000000000011',
      '11111111-1111-4111-8111-111111111111',
      'active',
      'complete',
      'Owner A second active',
      34,
      now(),
      'woman',
      165,
      'regular',
      now()
    )
  $$,
  '%profiles_one_active_idx%',
  'an owner cannot have two active profiles'
);

set local role service_role;

select throws_like(
  $$
    update public.profiles
    set height_cm = 170
    where id = 'aaaaaaaa-0000-4000-8000-000000000010'
  $$,
  '%submitted profile evidence is immutable%',
  'submitted profile evidence stays frozen for server writes'
);

reset role;
set local role authenticated;
set local request.jwt.claim.sub = '11111111-1111-4111-8111-111111111111';

select throws_like(
  $$
    delete from public.profiles
    where id = 'aaaaaaaa-0000-4000-8000-000000000010'
  $$,
  '%permission denied for table profiles%',
  'customer-facing deletion cannot remove a non-draft profile'
);

select throws_like(
  $$
    delete from public.profiles
    where id = 'aaaaaaaa-0000-4000-8000-000000000001'
  $$,
  '%permission denied for table profiles%',
  'an owner cannot directly delete its own draft profile'
);

reset role;
set local role service_role;

delete from public.profiles
where id = 'aaaaaaaa-0000-4000-8000-000000000001';

select is(
  (
    select derived_from_profile_id
    from public.profiles
    where id = 'aaaaaaaa-0000-4000-8000-000000000002'
  ),
  null::uuid,
  'purging a source profile clears preserved lineage safely'
);

reset role;

set local role anon;

select throws_like(
  $$select id from public.profiles limit 1$$,
  '%permission denied for table profiles%',
  'bare publishable-key access fails closed'
);

reset role;

select * from finish();
rollback;
