begin;

create extension if not exists pgtap with schema extensions;
select plan(46);

select has_table('public', 'consent_records', 'consent records table exists');

select columns_are(
  'public',
  'consent_records',
  array[
    'id',
    'owner_id',
    'profile_id',
    'purpose',
    'decision',
    'policy_version',
    'copy_sha256',
    'captured_at',
    'created_at'
  ],
  'consent records expose only the approved immutable event columns'
);

select ok(
  exists (
    select 1
    from pg_constraint as constraint_record
    where constraint_record.conrelid = 'public.consent_records'::regclass
      and constraint_record.conname = 'consent_records_owner_profile_fk'
      and constraint_record.confrelid = 'public.profiles'::regclass
  ),
  'consent events have an owned profile foreign key'
);

select has_index(
  'public',
  'consent_records',
  'consent_records_owner_id_key',
  'consent events expose the same-owner composite key'
);

select has_index(
  'public',
  'consent_records',
  'consent_records_owner_profile_idx',
  'consent events cover the owned-profile foreign key'
);

select has_index(
  'public',
  'consent_records',
  'consent_records_current_idx',
  'consent events support latest-decision queries'
);

select is(
  (
    select relation.relrowsecurity
    from pg_class as relation
    where relation.oid = 'public.consent_records'::regclass
  ),
  true,
  'consent records have row-level security enabled'
);

select ok(
  not has_table_privilege('anon', 'public.consent_records', 'SELECT')
  and not has_table_privilege('anon', 'public.consent_records', 'INSERT')
  and not has_table_privilege('anon', 'public.consent_records', 'UPDATE')
  and not has_table_privilege('anon', 'public.consent_records', 'DELETE'),
  'the bare anon role has no consent privileges'
);

select ok(
  has_table_privilege('authenticated', 'public.consent_records', 'SELECT')
  and has_table_privilege('authenticated', 'public.consent_records', 'INSERT')
  and not has_table_privilege('authenticated', 'public.consent_records', 'UPDATE')
  and not has_table_privilege('authenticated', 'public.consent_records', 'DELETE')
  and not has_table_privilege('authenticated', 'public.consent_records', 'TRUNCATE'),
  'authenticated identities can only read and append consent events'
);

select ok(
  has_table_privilege('service_role', 'public.consent_records', 'SELECT')
  and has_table_privilege('service_role', 'public.consent_records', 'INSERT')
  and not has_table_privilege('service_role', 'public.consent_records', 'UPDATE')
  and not has_table_privilege('service_role', 'public.consent_records', 'DELETE')
  and not has_table_privilege('service_role', 'public.consent_records', 'TRUNCATE'),
  'service role can only read and append consent events'
);

select results_eq(
  $$
    select policyname
    from pg_policies
    where schemaname = 'public'
      and tablename = 'consent_records'
    order by policyname
  $$,
  array[
    'consent_records_insert_own',
    'consent_records_select_own'
  ]::name[],
  'consent records use separate least-privilege policies per operation'
);

select has_function(
  'private',
  'enforce_consent_event_immutability',
  array[]::text[],
  'consent immutability trigger helper exists'
);

select is(
  (
    select procedure.prosecdef
    from pg_proc as procedure
    join pg_namespace as namespace on namespace.oid = procedure.pronamespace
    where namespace.nspname = 'private'
      and procedure.proname = 'enforce_consent_event_immutability'
      and procedure.pronargs = 0
  ),
  false,
  'consent immutability helper is security invoker'
);

select ok(
  (
    select coalesce('search_path=""' = any(procedure.proconfig), false)
    from pg_proc as procedure
    join pg_namespace as namespace on namespace.oid = procedure.pronamespace
    where namespace.nspname = 'private'
      and procedure.proname = 'enforce_consent_event_immutability'
      and procedure.pronargs = 0
  ),
  'consent immutability helper fixes an empty search path'
);

select ok(
  not has_function_privilege(
    'authenticated',
    'private.enforce_consent_event_immutability()'::regprocedure,
    'EXECUTE'
  )
  and not has_function_privilege(
    'anon',
    'private.enforce_consent_event_immutability()'::regprocedure,
    'EXECUTE'
  )
  and not has_function_privilege(
    'service_role',
    'private.enforce_consent_event_immutability()'::regprocedure,
    'EXECUTE'
  ),
  'consent immutability helper is trigger-only'
);

select ok(
  exists (
    select 1
    from pg_trigger
    where tgrelid = 'public.consent_records'::regclass
      and tgname = 'consent_records_enforce_immutability'
      and not tgisinternal
  ),
  'consent records install the immutability trigger'
);

select throws_like(
  $$
    insert into public.consent_records (
      owner_id, profile_id, purpose, decision, policy_version, copy_sha256
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'aaaaaaaa-1000-4000-8000-000000000001',
      'marketing', 'granted', '2026-07-22', decode(repeat('aa', 32), 'hex')
    )
  $$,
  '%consent_records_purpose_check%',
  'consent purpose rejects values outside the approved taxonomy'
);

select throws_like(
  $$
    insert into public.consent_records (
      owner_id, profile_id, purpose, decision, policy_version, copy_sha256
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'aaaaaaaa-1000-4000-8000-000000000001',
      'profile_processing', 'accepted', '2026-07-22', decode(repeat('aa', 32), 'hex')
    )
  $$,
  '%consent_records_decision_check%',
  'consent decision accepts only granted or revoked events'
);

select throws_like(
  $$
    insert into public.consent_records (
      owner_id, profile_id, purpose, decision, policy_version, copy_sha256
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'aaaaaaaa-1000-4000-8000-000000000001',
      'profile_processing', 'granted', '   ', decode(repeat('aa', 32), 'hex')
    )
  $$,
  '%consent_records_policy_version_check%',
  'consent policy version rejects blank values'
);

select throws_like(
  $$
    insert into public.consent_records (
      owner_id, profile_id, purpose, decision, policy_version, copy_sha256
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'aaaaaaaa-1000-4000-8000-000000000001',
      'profile_processing', 'granted', ' version-1 ', decode(repeat('aa', 32), 'hex')
    )
  $$,
  '%consent_records_policy_version_check%',
  'consent policy version rejects outer whitespace'
);

select throws_like(
  $$
    insert into public.consent_records (
      owner_id, profile_id, purpose, decision, policy_version, copy_sha256
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'aaaaaaaa-1000-4000-8000-000000000001',
      'profile_processing', 'granted', repeat('v', 81), decode(repeat('aa', 32), 'hex')
    )
  $$,
  '%consent_records_policy_version_check%',
  'consent policy version rejects values longer than 80 characters'
);

select throws_like(
  $$
    insert into public.consent_records (
      owner_id, profile_id, purpose, decision, policy_version, copy_sha256
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'aaaaaaaa-1000-4000-8000-000000000001',
      'profile_processing', 'granted', '2026-07-22', decode(repeat('aa', 31), 'hex')
    )
  $$,
  '%consent_records_copy_sha256_check%',
  'consent copy hash rejects values shorter than SHA-256'
);

select throws_like(
  $$
    insert into public.consent_records (
      owner_id, profile_id, purpose, decision, policy_version, copy_sha256
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'aaaaaaaa-1000-4000-8000-000000000001',
      'profile_processing', 'granted', '2026-07-22', decode(repeat('aa', 33), 'hex')
    )
  $$,
  '%consent_records_copy_sha256_check%',
  'consent copy hash rejects values longer than SHA-256'
);

select lives_ok(
  $$
    insert into public.profiles (id, owner_id, name)
    values (
      'aaaaaaaa-1000-4000-8000-000000000001',
      '11111111-1111-4111-8111-111111111111',
      'Consent owner A'
    )
  $$,
  'owner A consent profile fixture exists'
);

select lives_ok(
  $$
    insert into public.profiles (id, owner_id, name)
    values (
      'bbbbbbbb-1000-4000-8000-000000000001',
      '22222222-2222-4222-8222-222222222222',
      'Consent owner B'
    )
  $$,
  'owner B consent profile fixture exists'
);

set local role authenticated;
set local request.jwt.claim.sub = '11111111-1111-4111-8111-111111111111';

select lives_ok(
  $$
    insert into public.consent_records (
      id, owner_id, profile_id, purpose, decision, policy_version,
      copy_sha256, captured_at
    ) values (
      'aaaaaaaa-2000-4000-8000-000000000001',
      '11111111-1111-4111-8111-111111111111',
      'aaaaaaaa-1000-4000-8000-000000000001',
      'profile_processing', 'granted', '2026-07-22',
      decode(repeat('aa', 32), 'hex'), '2026-07-22T12:00:00Z'
    )
  $$,
  'owner A can append a granted consent event'
);

select lives_ok(
  $$
    insert into public.consent_records (
      id, owner_id, profile_id, purpose, decision, policy_version,
      copy_sha256, captured_at
    ) values (
      'aaaaaaaa-2000-4000-8000-000000000002',
      '11111111-1111-4111-8111-111111111111',
      'aaaaaaaa-1000-4000-8000-000000000001',
      'profile_processing', 'revoked', '2026-07-22',
      decode(repeat('bb', 32), 'hex'), '2026-07-22T12:01:00Z'
    )
  $$,
  'owner A can append a later revoked consent event'
);

select is(
  (
    select decision
    from public.consent_records
    where profile_id = 'aaaaaaaa-1000-4000-8000-000000000001'
      and purpose = 'profile_processing'
    order by captured_at desc, id desc
    limit 1
  ),
  'revoked'::text,
  'the latest consent event determines the current decision'
);

select lives_ok(
  $$
    insert into public.consent_records (
      id, owner_id, profile_id, purpose, decision, policy_version,
      copy_sha256, captured_at
    ) values (
      'aaaaaaaa-2000-4000-8000-000000000003',
      '11111111-1111-4111-8111-111111111111',
      'aaaaaaaa-1000-4000-8000-000000000001',
      'photo_analysis', 'granted', '2026-07-22',
      decode(repeat('cc', 32), 'hex'), '2026-07-22T12:02:00Z'
    )
  $$,
  'owner A can grant a separate consent purpose'
);

select is(
  (
    select decision
    from public.consent_records
    where profile_id = 'aaaaaaaa-1000-4000-8000-000000000001'
      and purpose = 'photo_analysis'
    order by captured_at desc, id desc
    limit 1
  ),
  'granted'::text,
  'a granted event is queryable as the latest purpose decision'
);

select throws_like(
  $$
    update public.consent_records
    set decision = 'granted'
    where id = 'aaaaaaaa-2000-4000-8000-000000000002'
  $$,
  '%permission denied for table consent_records%',
  'authenticated identities cannot update an existing consent event'
);

select throws_like(
  $$
    delete from public.consent_records
    where id = 'aaaaaaaa-2000-4000-8000-000000000002'
  $$,
  '%permission denied for table consent_records%',
  'authenticated identities cannot delete an existing consent event'
);

select is_empty(
  $$
    select id
    from public.consent_records
    where owner_id = '22222222-2222-4222-8222-222222222222'
  $$,
  'owner A cannot read owner B consent events'
);

select throws_like(
  $$
    insert into public.consent_records (
      owner_id, profile_id, purpose, decision, policy_version, copy_sha256
    ) values (
      '22222222-2222-4222-8222-222222222222',
      'bbbbbbbb-1000-4000-8000-000000000001',
      'profile_processing', 'granted', '2026-07-22',
      decode(repeat('dd', 32), 'hex')
    )
  $$,
  '%row-level security policy%',
  'owner A cannot append consent for owner B'
);

reset role;
set local role authenticated;
set local request.jwt.claim.sub = '22222222-2222-4222-8222-222222222222';

select lives_ok(
  $$
    insert into public.consent_records (
      id, owner_id, profile_id, purpose, decision, policy_version, copy_sha256
    ) values (
      'bbbbbbbb-2000-4000-8000-000000000001',
      '22222222-2222-4222-8222-222222222222',
      'bbbbbbbb-1000-4000-8000-000000000001',
      'profile_processing', 'granted', '2026-07-22',
      decode(repeat('ee', 32), 'hex')
    )
  $$,
  'owner B can append its own consent event'
);

select is(
  (select count(*) from public.consent_records),
  1::bigint,
  'owner B can read only its own consent event'
);

reset role;
set local role service_role;

select throws_like(
  $$
    update public.consent_records
    set decision = 'revoked'
    where id = 'bbbbbbbb-2000-4000-8000-000000000001'
  $$,
  '%permission denied for table consent_records%',
  'service role cannot update an existing consent event'
);

select throws_like(
  $$
    delete from public.consent_records
    where id = 'bbbbbbbb-2000-4000-8000-000000000001'
  $$,
  '%permission denied for table consent_records%',
  'service role cannot delete an existing consent event'
);

reset role;
set local role authenticated;
set local request.jwt.claim.sub = '22222222-2222-4222-8222-222222222222';

select throws_like(
  $$
    delete from public.profiles
    where id = 'bbbbbbbb-1000-4000-8000-000000000001'
  $$,
  '%permission denied for table profiles%',
  'an owner cannot directly delete a draft profile and its consent history'
);

reset role;
set local role service_role;

delete from public.profiles
where id = 'bbbbbbbb-1000-4000-8000-000000000001';

select is_empty(
  $$
    select id
    from public.consent_records
    where profile_id = 'bbbbbbbb-1000-4000-8000-000000000001'
  $$,
  'profile deletion leaves no consent records behind'
);

reset role;

select throws_like(
  $$
    update public.consent_records
    set decision = 'granted'
    where id = 'aaaaaaaa-2000-4000-8000-000000000002'
  $$,
  '%consent events are append-only%',
  'the database owner cannot mutate consent evidence'
);

select lives_ok(
  $$
    update public.profiles
    set owner_id = '22222222-2222-4222-8222-222222222222'
    where id = 'aaaaaaaa-1000-4000-8000-000000000001'
  $$,
  'the system transfer transaction can reassign an anonymous profile'
);

select results_eq(
  $$
    select distinct owner_id
    from public.consent_records
    where profile_id = 'aaaaaaaa-1000-4000-8000-000000000001'
  $$,
  array['22222222-2222-4222-8222-222222222222'::uuid],
  'profile transfer cascades consent-event ownership without changing evidence'
);

set local role authenticated;
set local request.jwt.claim.sub = '22222222-2222-4222-8222-222222222222';

select is(
  (
    select count(*)
    from public.consent_records
    where profile_id = 'aaaaaaaa-1000-4000-8000-000000000001'
  ),
  3::bigint,
  'the recipient can read transferred consent history'
);

reset role;
set local role authenticated;
set local request.jwt.claim.sub = '11111111-1111-4111-8111-111111111111';

select is_empty(
  $$
    select id
    from public.consent_records
    where profile_id = 'aaaaaaaa-1000-4000-8000-000000000001'
  $$,
  'the prior owner cannot read transferred consent history'
);

reset role;
set local role anon;

select throws_like(
  $$select id from public.consent_records limit 1$$,
  '%permission denied for table consent_records%',
  'bare publishable-key access fails closed'
);

reset role;

select * from finish();
rollback;
