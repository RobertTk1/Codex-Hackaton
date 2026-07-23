begin;

create extension if not exists pgtap with schema extensions;
select no_plan();

select has_table('public', 'report_runs', 'report-run table exists');

select columns_are(
  'public',
  'report_runs',
  array[
    'id', 'owner_id', 'profile_id', 'profile_revision', 'status', 'stage',
    'run_sequence', 'idempotency_key', 'attempt_count', 'started_at',
    'completed_at', 'last_error_code', 'last_error_details', 'created_at',
    'updated_at'
  ],
  'report runs retain only bounded lifecycle and safe error state'
);

select is(
  (
    select count(*)
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'report_runs'
      and column_name ~ '(provider|prompt|response|transcript|payload|photo|image)'
  ),
  0::bigint,
  'report runs cannot retain provider bodies, prompts, transcripts, or media'
);

select ok(
  exists (
    select 1
    from pg_constraint
    where conrelid = 'public.report_runs'::regclass
      and conname = 'report_runs_owner_profile_fk'
      and confrelid = 'public.profiles'::regclass
      and condeferrable
      and not condeferred
      and confupdtype = 'c'
      and confdeltype = 'c'
  ),
  'report-run ownership cascades through one deferrable profile key'
);

select has_index('public', 'report_runs', 'report_runs_owner_id_key', 'report runs expose the same-owner key');
select has_index('public', 'report_runs', 'report_runs_owner_profile_id_key', 'report-run profile lineage is indexed');
select has_index('public', 'report_runs', 'report_runs_idempotency_idx', 'request replay has one unique durable run key');
select has_index('public', 'report_runs', 'report_runs_sequence_idx', 'profile revision retry order is unique');
select has_index('public', 'report_runs', 'report_runs_one_live_idx', 'one live or successful run is enforced per revision');
select has_index('public', 'report_runs', 'report_runs_profile_status_idx', 'run resume and status lookup is indexed');

select is(
  (select relrowsecurity from pg_class where oid = 'public.report_runs'::regclass),
  true,
  'report runs have row-level security enabled'
);

select ok(
  not has_table_privilege('anon', 'public.report_runs', 'SELECT')
  and not has_table_privilege('anon', 'public.report_runs', 'INSERT'),
  'bare anonymous requests have no report-run privileges'
);

select ok(
  has_table_privilege('authenticated', 'public.report_runs', 'SELECT')
  and not has_table_privilege('authenticated', 'public.report_runs', 'INSERT')
  and not has_table_privilege('authenticated', 'public.report_runs', 'UPDATE')
  and not has_table_privilege('authenticated', 'public.report_runs', 'DELETE'),
  'customers receive owner-scoped read-only report-run access'
);

select ok(
  has_table_privilege('service_role', 'public.report_runs', 'SELECT')
  and has_table_privilege('service_role', 'public.report_runs', 'INSERT')
  and has_table_privilege('service_role', 'public.report_runs', 'UPDATE')
  and has_table_privilege('service_role', 'public.report_runs', 'DELETE')
  and not has_table_privilege('service_role', 'public.report_runs', 'TRUNCATE'),
  'service role receives bounded report-run DML without table-destructive authority'
);

select results_eq(
  $$select policyname from pg_policies where schemaname='public' and tablename='report_runs' order by policyname$$,
  array['report_runs_select_own']::name[],
  'report runs expose only owner-scoped reads'
);

select has_function('private', 'enforce_report_run_contract', array[]::text[], 'report-run transition guard exists');

select ok(
  (
    select not prosecdef and coalesce('search_path=""' = any(proconfig), false)
    from pg_proc
    where oid = 'private.enforce_report_run_contract()'::regprocedure
  ),
  'report-run helpers are security invoker with empty search paths'
);

select ok(
  not has_function_privilege('authenticated', 'private.enforce_report_run_contract()'::regprocedure, 'EXECUTE')
  and not has_function_privilege('service_role', 'private.enforce_report_run_contract()'::regprocedure, 'EXECUTE'),
  'report-run trigger helpers cannot be invoked as standalone APIs'
);

select has_trigger('public', 'report_runs', 'report_runs_enforce_contract', 'report-run writes are contract guarded');
select has_trigger('public', 'report_runs', 'report_runs_set_updated_at', 'report-run state changes update timestamps');

insert into public.profiles (
  id, owner_id, status, current_step, revision, name, age,
  adult_confirmed_at, gender, height_cm, fit_preference, submitted_at
) values
  (
    'a2500000-0000-4000-8000-000000000001',
    '11111111-1111-4111-8111-111111111111',
    'submitted', 'complete', 7, 'Report owner A', 34,
    now(), 'woman', 165, 'regular', now()
  ),
  (
    'a2500000-0000-4000-8000-000000000002',
    '11111111-1111-4111-8111-111111111111',
    'submitted', 'complete', 3, 'Retry owner A', 35,
    now(), 'woman', 166, 'relaxed', now()
  ),
  (
    'b2500000-0000-4000-8000-000000000001',
    '22222222-2222-4222-8222-222222222222',
    'submitted', 'complete', 2, 'Report owner B', 36,
    now(), 'woman', 167, 'fitted', now()
  ),
  (
    'a2500000-0000-4000-8000-000000000004',
    '11111111-1111-4111-8111-111111111111',
    'draft', 'taste', 2, null, null,
    null, null, null, null, null
  );

select lives_ok(
  $$
    insert into public.report_runs (
      id, owner_id, profile_id, profile_revision, idempotency_key
    ) values (
      'a2510000-0000-4000-8000-000000000001',
      '11111111-1111-4111-8111-111111111111',
      'a2500000-0000-4000-8000-000000000001',
      7,
      'report:a2500000-0000-4000-8000-000000000001:7:1:request-001'
    )
  $$,
  'one submitted profile revision creates one queued run'
);

select is(
  (
    select count(*)
    from public.report_runs
    where idempotency_key = 'report:a2500000-0000-4000-8000-000000000001:7:1:request-001'
  ),
  1::bigint,
  'one profile revision and idempotency key produces exactly one run'
);

select throws_like(
  $$
    insert into public.report_runs (
      owner_id, profile_id, profile_revision, idempotency_key
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2500000-0000-4000-8000-000000000001',
      7,
      'report:a2500000-0000-4000-8000-000000000001:7:1:request-001'
    )
  $$,
  '%report retry sequence must advance exactly once%',
  'replaying a request cannot create a second run'
);

select throws_like(
  $$
    insert into public.report_runs (
      owner_id, profile_id, profile_revision, idempotency_key
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2500000-0000-4000-8000-000000000001',
      6,
      'wrong-revision'
    )
  $$,
  'report run revision must match frozen profile evidence',
  'a run cannot target stale profile evidence'
);

select throws_like(
  $$
    insert into public.report_runs (
      owner_id, profile_id, profile_revision, idempotency_key
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2500000-0000-4000-8000-000000000004',
      2,
      'draft-profile'
    )
  $$,
  'report run requires a submitted profile',
  'draft evidence cannot start report work'
);

select throws_like(
  $$
    insert into public.report_runs (
      owner_id, profile_id, profile_revision, run_sequence, idempotency_key
    ) values (
      '22222222-2222-4222-8222-222222222222',
      'b2500000-0000-4000-8000-000000000001',
      2,
      2,
      'sequence-gap'
    )
  $$,
  'first report run must use sequence one',
  'retry history cannot begin with a sequence gap'
);

select throws_like(
  $$
    update public.report_runs
    set status='processing', stage='profile_analysis',
        attempt_count=2, started_at=now()
    where id='a2510000-0000-4000-8000-000000000001'
  $$,
  'first report processing attempt must be one',
  'the first worker claim cannot skip attempt one'
);

select lives_ok(
  $$
    update public.report_runs
    set status='processing', stage='profile_analysis',
        attempt_count=1, started_at=now()
    where id='a2510000-0000-4000-8000-000000000001'
  $$,
  'the queued run starts one bounded processing attempt'
);

select lives_ok(
  $$
    update public.report_runs
    set stage='report_writing'
    where id='a2510000-0000-4000-8000-000000000001'
  $$,
  'monotonic stages may skip optional work without fake precision'
);

select throws_like(
  $$
    update public.report_runs
    set stage='catalog_matching'
    where id='a2510000-0000-4000-8000-000000000001'
  $$,
  'report stage cannot move backward',
  'stage transitions reject backward stale state'
);

select lives_ok(
  $$
    update public.report_runs
    set stage='finalizing', attempt_count=2
    where id='a2510000-0000-4000-8000-000000000001'
  $$,
  'one internal retry can advance the bounded attempt count'
);

select throws_like(
  $$
    update public.report_runs
    set attempt_count=3
    where id='a2510000-0000-4000-8000-000000000001'
  $$,
  '%report_runs_attempt_count_check%',
  'a report run rejects a third internal worker attempt'
);

select throws_like(
  $$
    update public.report_runs
    set status='failed', completed_at=now(),
        last_error_code='REPORT_GENERATION_FAILED',
        last_error_details=jsonb_build_object(
          'retryable', true,
          'stage', 'finalizing',
          'customer_message_key', 'analysis_temporarily_unavailable',
          'provider_response', 'must never persist'
        )
    where id='a2510000-0000-4000-8000-000000000001'
  $$,
  '%report_runs_last_error_details_check%',
  'unsafe or extra provider error data fails closed'
);

select lives_ok(
  $$
    update public.report_runs
    set status='failed', completed_at=now(),
        last_error_code='REPORT_GENERATION_FAILED',
        last_error_details=jsonb_build_object(
          'retryable', true,
          'stage', 'finalizing',
          'customer_message_key', 'analysis_temporarily_unavailable'
        )
    where id='a2510000-0000-4000-8000-000000000001'
  $$,
  'a failed run retains only normalized retry guidance'
);

select throws_like(
  $$
    update public.report_runs
    set status='processing', completed_at=null,
        last_error_code=null, last_error_details=null
    where id='a2510000-0000-4000-8000-000000000001'
  $$,
  'terminal report run state is immutable',
  'terminal failure cannot be reopened in place'
);

select lives_ok(
  $$
    insert into public.report_runs (
      id, owner_id, profile_id, profile_revision, run_sequence, idempotency_key
    ) values (
      'a2510000-0000-4000-8000-000000000002',
      '11111111-1111-4111-8111-111111111111',
      'a2500000-0000-4000-8000-000000000001',
      7,
      2,
      'report:a2500000-0000-4000-8000-000000000001:7:2:request-002'
    )
  $$,
  'a retryable terminal failure releases one next sequence'
);

select throws_like(
  $$
    update public.report_runs
    set stage='finalizing'
    where id='a2510000-0000-4000-8000-000000000001'
  $$,
  'stale report sequence cannot change lifecycle state',
  'stage transitions reject stale sequence updates'
);

select throws_like(
  $$
    insert into public.report_runs (
      owner_id, profile_id, profile_revision, run_sequence, idempotency_key
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2500000-0000-4000-8000-000000000001',
      7,
      3,
      'live-sequence-conflict'
    )
  $$,
  'report retry requires a terminal unsuccessful run',
  'one queued sequence blocks concurrent retry creation'
);

update public.report_runs
set status='processing', stage='profile_analysis', attempt_count=1, started_at=now()
where id='a2510000-0000-4000-8000-000000000002';

update public.report_runs
set status='failed', completed_at=now(),
    last_error_code='REPORT_OUTPUT_INVALID',
    last_error_details=jsonb_build_object(
      'retryable', false,
      'stage', 'profile_analysis',
      'customer_message_key', 'report_requires_support'
    )
where id='a2510000-0000-4000-8000-000000000002';

select throws_like(
  $$
    insert into public.report_runs (
      owner_id, profile_id, profile_revision, run_sequence, idempotency_key
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2500000-0000-4000-8000-000000000001',
      7,
      3,
      'non-retryable-sequence'
    )
  $$,
  'non-retryable report failure cannot create another sequence',
  'terminal failure cannot be retried outside policy'
);

set local role service_role;

insert into public.report_runs (
  id, owner_id, profile_id, profile_revision, run_sequence, idempotency_key
) values (
  'a2520000-0000-4000-8000-000000000001',
  '11111111-1111-4111-8111-111111111111',
  'a2500000-0000-4000-8000-000000000002',
  3,
  1,
  'report:a2500000-0000-4000-8000-000000000002:3:1:request-001'
);

update public.report_runs
set status='processing', stage='profile_analysis', attempt_count=1, started_at=now()
where id='a2520000-0000-4000-8000-000000000001';
update public.report_runs
set status='failed', completed_at=now(),
    last_error_code='REPORT_GENERATION_TIMEOUT',
    last_error_details='{"retryable":true,"stage":"profile_analysis","customer_message_key":"analysis_timed_out"}'::jsonb
where id='a2520000-0000-4000-8000-000000000001';

insert into public.report_runs (
  id, owner_id, profile_id, profile_revision, run_sequence, idempotency_key
) values (
  'a2520000-0000-4000-8000-000000000002',
  '11111111-1111-4111-8111-111111111111',
  'a2500000-0000-4000-8000-000000000002',
  3,
  2,
  'report:a2500000-0000-4000-8000-000000000002:3:2:request-002'
);

update public.report_runs
set status='processing', stage='catalog_matching', attempt_count=1, started_at=now()
where id='a2520000-0000-4000-8000-000000000002';
update public.report_runs
set status='failed', completed_at=now(),
    last_error_code='REPORT_GENERATION_FAILED',
    last_error_details='{"retryable":true,"stage":"catalog_matching","customer_message_key":"catalog_temporarily_unavailable"}'::jsonb
where id='a2520000-0000-4000-8000-000000000002';

insert into public.report_runs (
  id, owner_id, profile_id, profile_revision, run_sequence, idempotency_key
) values (
  'a2520000-0000-4000-8000-000000000003',
  '11111111-1111-4111-8111-111111111111',
  'a2500000-0000-4000-8000-000000000002',
  3,
  3,
  'report:a2500000-0000-4000-8000-000000000002:3:3:request-003'
);

update public.report_runs
set status='processing', stage='report_writing', attempt_count=1, started_at=now()
where id='a2520000-0000-4000-8000-000000000003';
update public.report_runs
set status='failed', completed_at=now(),
    last_error_code='REPORT_GENERATION_FAILED',
    last_error_details='{"retryable":true,"stage":"report_writing","customer_message_key":"analysis_temporarily_unavailable"}'::jsonb
where id='a2520000-0000-4000-8000-000000000003';

select throws_like(
  $$
    insert into public.report_runs (
      owner_id, profile_id, profile_revision, run_sequence, idempotency_key
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2500000-0000-4000-8000-000000000002',
      3,
      4,
      'report:a2500000-0000-4000-8000-000000000002:3:4:request-004'
    )
  $$,
  '%report_runs_run_sequence_check%',
  'three user-visible sequences exhaust the retry policy'
);

insert into public.report_runs (
  id, owner_id, profile_id, profile_revision, idempotency_key
) values (
  'b2510000-0000-4000-8000-000000000001',
  '22222222-2222-4222-8222-222222222222',
  'b2500000-0000-4000-8000-000000000001',
  2,
  'report:b2500000-0000-4000-8000-000000000001:2:1:request-001'
);

update public.report_runs
set status='processing', stage='finalizing', attempt_count=1, started_at=now()
where id='b2510000-0000-4000-8000-000000000001';

select throws_like(
  $$
    update public.report_runs
    set status='succeeded', completed_at=now()
    where id='b2510000-0000-4000-8000-000000000001'
  $$,
  'report success requires one published report',
  'success fails closed until a published report exists for the run'
);

reset role;

select set_config(
  'request.jwt.claims',
  '{"sub":"11111111-1111-4111-8111-111111111111","is_anonymous":false}',
  true
);
set local role authenticated;

select is(
  (select count(*) from public.report_runs),
  5::bigint,
  'owner A can read only their five retained run-history rows'
);

select throws_like(
  $$
    insert into public.report_runs (
      owner_id, profile_id, profile_revision, idempotency_key
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2500000-0000-4000-8000-000000000001',
      7,
      'customer-write-denied'
    )
  $$,
  '%permission denied for table report_runs%',
  'customer roles cannot create report-run state directly'
);

select throws_like(
  $$
    update public.report_runs set stage='finalizing'
  $$,
  '%permission denied for table report_runs%',
  'customer roles cannot mutate report-run lifecycle state'
);

reset role;
select set_config(
  'request.jwt.claims',
  '{"sub":"22222222-2222-4222-8222-222222222222","is_anonymous":false}',
  true
);
set local role authenticated;

select results_eq(
  $$select id from public.report_runs order by id$$,
  array['b2510000-0000-4000-8000-000000000001'::uuid],
  'cross-owner run history is hidden by RLS'
);

reset role;

select * from finish();
rollback;
