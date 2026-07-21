begin;

create extension if not exists pgtap with schema extensions;
select plan(42);

select has_table(
  'private',
  'processing_jobs',
  'processing jobs table exists in the private schema'
);

select columns_are(
  'private',
  'processing_jobs',
  array[
    'id',
    'owner_id',
    'profile_id',
    'kind',
    'subject_id',
    'status',
    'priority',
    'idempotency_key',
    'attempt_count',
    'max_attempts',
    'available_at',
    'leased_at',
    'lease_expires_at',
    'worker_id',
    'last_error_code',
    'last_error_details',
    'completed_at',
    'created_at',
    'updated_at'
  ],
  'processing jobs expose only the approved bounded columns'
);

select ok(
  exists (
    select 1
    from pg_constraint as constraint_record
    where constraint_record.conrelid = 'private.processing_jobs'::regclass
      and constraint_record.contype = 'p'
      and constraint_record.conkey = array[
        (
          select attribute.attnum
          from pg_attribute as attribute
          where attribute.attrelid = 'private.processing_jobs'::regclass
            and attribute.attname = 'id'
        )
      ]::smallint[]
  ),
  'processing job ID is the primary key'
);

select ok(
  exists (
    select 1
    from pg_constraint as constraint_record
    where constraint_record.conrelid = 'private.processing_jobs'::regclass
      and constraint_record.conname = 'processing_jobs_owner_fk'
      and constraint_record.confrelid = 'auth.users'::regclass
  ),
  'processing job owner references the Auth identity authority'
);

select is(
  (
    select relation.relrowsecurity
    from pg_class as relation
    where relation.oid = 'private.processing_jobs'::regclass
  ),
  true,
  'processing jobs use RLS as private-schema defense in depth'
);

select ok(
  not has_table_privilege('anon', 'private.processing_jobs', 'SELECT')
  and not has_table_privilege('anon', 'private.processing_jobs', 'INSERT')
  and not has_table_privilege('anon', 'private.processing_jobs', 'UPDATE')
  and not has_table_privilege('anon', 'private.processing_jobs', 'DELETE'),
  'anon has no processing-job table access'
);

select ok(
  not has_table_privilege('authenticated', 'private.processing_jobs', 'SELECT')
  and not has_table_privilege('authenticated', 'private.processing_jobs', 'INSERT')
  and not has_table_privilege('authenticated', 'private.processing_jobs', 'UPDATE')
  and not has_table_privilege('authenticated', 'private.processing_jobs', 'DELETE'),
  'authenticated has no processing-job table access'
);

select ok(
  has_table_privilege('service_role', 'private.processing_jobs', 'SELECT')
  and has_table_privilege('service_role', 'private.processing_jobs', 'INSERT')
  and has_table_privilege('service_role', 'private.processing_jobs', 'UPDATE')
  and has_table_privilege('service_role', 'private.processing_jobs', 'DELETE')
  and not has_table_privilege('service_role', 'private.processing_jobs', 'TRUNCATE'),
  'service_role receives only required processing-job DML privileges'
);

select throws_like(
  $$
    insert into private.processing_jobs (
      owner_id, profile_id, kind, subject_id, idempotency_key
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'aaaaaaaa-0000-4000-8000-000000000001',
      'unknown_job',
      'aaaaaaaa-1000-4000-8000-000000000001',
      'unknown-job:1'
    )
  $$,
  '%processing_jobs_kind_check%',
  'unknown job kinds fail closed'
);

select throws_like(
  $$
    insert into private.processing_jobs (
      owner_id,
      profile_id,
      kind,
      subject_id,
      idempotency_key,
      attempt_count,
      max_attempts
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'aaaaaaaa-0000-4000-8000-000000000001',
      'photo_extraction',
      'aaaaaaaa-1000-4000-8000-000000000002',
      'bad-attempts:1',
      3,
      2
    )
  $$,
  '%processing_jobs_attempts_check%',
  'attempt counts cannot exceed the bounded maximum'
);

select throws_like(
  $$
    insert into private.processing_jobs (
      owner_id,
      profile_id,
      kind,
      subject_id,
      status,
      idempotency_key,
      attempt_count
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'aaaaaaaa-0000-4000-8000-000000000001',
      'photo_extraction',
      'aaaaaaaa-1000-4000-8000-000000000003',
      'leased',
      'bad-lease:1',
      1
    )
  $$,
  '%processing_jobs_state_check%',
  'leased jobs require a complete bounded lease'
);

select throws_like(
  $$
    insert into private.processing_jobs (
      owner_id,
      profile_id,
      kind,
      subject_id,
      status,
      idempotency_key,
      attempt_count,
      max_attempts,
      last_error_code,
      last_error_details
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'aaaaaaaa-0000-4000-8000-000000000001',
      'photo_extraction',
      'aaaaaaaa-1000-4000-8000-000000000004',
      'retry_wait',
      'extra-error-key:1',
      1,
      2,
      'EXTRA_ERROR_KEY',
      '{
        "job_kind": "photo_extraction",
        "operation_stage": "analysis",
        "retryable": true,
        "customer_message_key": "analysis_temporarily_unavailable",
        "provider_body": "forbidden"
      }'::jsonb
    )
  $$,
  '%processing_jobs_error_details_check%',
  'job errors reject unknown provider-bearing fields'
);

select throws_like(
  $$
    insert into private.processing_jobs (
      owner_id,
      profile_id,
      kind,
      subject_id,
      status,
      idempotency_key,
      attempt_count,
      max_attempts,
      last_error_code,
      last_error_details
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'aaaaaaaa-0000-4000-8000-000000000001',
      'photo_extraction',
      'aaaaaaaa-1000-4000-8000-000000000005',
      'retry_wait',
      'wrong-error-kind:1',
      1,
      2,
      'WRONG_ERROR_KIND',
      '{
        "job_kind": "report_generation",
        "operation_stage": "report_writing",
        "retryable": true,
        "customer_message_key": "analysis_temporarily_unavailable"
      }'::jsonb
    )
  $$,
  '%processing_jobs_error_details_check%',
  'job error kind must match the durable job kind'
);

select throws_like(
  $$
    insert into private.processing_jobs (
      owner_id,
      profile_id,
      kind,
      subject_id,
      status,
      idempotency_key,
      attempt_count,
      max_attempts,
      last_error_code,
      last_error_details
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'aaaaaaaa-0000-4000-8000-000000000001',
      'wardrobe_preview',
      'aaaaaaaa-1000-4000-8000-000000000006',
      'retry_wait',
      'non-retryable-wait:1',
      1,
      2,
      'NON_RETRYABLE',
      '{
        "job_kind": "wardrobe_preview",
        "operation_stage": "generate",
        "retryable": false,
        "customer_message_key": "preview_unavailable"
      }'::jsonb
    )
  $$,
  '%processing_jobs_state_check%',
  'retry-wait jobs must carry a retryable error'
);

select lives_ok(
  $$
    insert into private.processing_jobs (
      id,
      owner_id,
      profile_id,
      kind,
      subject_id,
      status,
      idempotency_key,
      attempt_count,
      max_attempts,
      last_error_code,
      last_error_details
    ) values (
      'aaaaaaaa-2000-4000-8000-000000000001',
      '11111111-1111-4111-8111-111111111111',
      'aaaaaaaa-0000-4000-8000-000000000001',
      'wardrobe_preview',
      'aaaaaaaa-1000-4000-8000-000000000007',
      'retry_wait',
      'wardrobe-preview:subject-7:1',
      1,
      2,
      'PREVIEW_RETRY',
      '{
        "job_kind": "wardrobe_preview",
        "operation_stage": "generate",
        "retryable": true,
        "customer_message_key": "preview_temporarily_unavailable"
      }'::jsonb
    )
  $$,
  'a bounded retry-wait record is accepted'
);

insert into private.processing_jobs (
  id,
  owner_id,
  profile_id,
  kind,
  subject_id,
  priority,
  idempotency_key
)
values
  (
    'aaaaaaaa-2000-4000-8000-000000000010',
    '11111111-1111-4111-8111-111111111111',
    'aaaaaaaa-0000-4000-8000-000000000001',
    'photo_extraction',
    'aaaaaaaa-1000-4000-8000-000000000010',
    20,
    'photo-extraction:subject-10:1'
  ),
  (
    'aaaaaaaa-2000-4000-8000-000000000020',
    '11111111-1111-4111-8111-111111111111',
    'aaaaaaaa-0000-4000-8000-000000000001',
    'photo_extraction',
    'aaaaaaaa-1000-4000-8000-000000000020',
    10,
    'photo-extraction:subject-20:1'
  );

select throws_like(
  $$
    insert into private.processing_jobs (
      owner_id, profile_id, kind, subject_id, idempotency_key
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'aaaaaaaa-0000-4000-8000-000000000001',
      'photo_extraction',
      'aaaaaaaa-1000-4000-8000-000000000010',
      'photo-extraction:subject-10:1'
    )
  $$,
  '%processing_jobs_idempotency_idx%',
  'one subject and retry sequence creates only one durable job'
);

select has_function(
  'private',
  'claim_processing_job',
  array['text', 'text', 'integer'],
  'processing job claim function exists'
);

select is(
  (
    select procedure.prosecdef
    from pg_proc as procedure
    where procedure.oid =
      'private.claim_processing_job(text,text,integer)'::regprocedure
  ),
  true,
  'processing job claim uses the approved elevated transaction boundary'
);

select ok(
  (
    select coalesce('search_path=""' = any(procedure.proconfig), false)
    from pg_proc as procedure
    where procedure.oid =
      'private.claim_processing_job(text,text,integer)'::regprocedure
  ),
  'processing job claim fixes an empty search path'
);

select ok(
  pg_get_functiondef(
    'private.claim_processing_job(text,text,integer)'::regprocedure
  ) ilike '%for update skip locked%',
  'processing job claim skips rows already locked by another worker'
);

select is_empty(
  $$
    select 1
    from pg_proc as procedure
    cross join lateral aclexplode(
      coalesce(procedure.proacl, acldefault('f', procedure.proowner))
    ) as privilege
    where procedure.oid =
      'private.claim_processing_job(text,text,integer)'::regprocedure
      and privilege.grantee = 0
      and privilege.privilege_type = 'EXECUTE'
  $$,
  'PUBLIC cannot execute the processing job claim'
);

select ok(
  not has_function_privilege(
    'anon',
    'private.claim_processing_job(text,text,integer)'::regprocedure,
    'EXECUTE'
  ),
  'anon cannot execute the processing job claim'
);

select ok(
  not has_function_privilege(
    'authenticated',
    'private.claim_processing_job(text,text,integer)'::regprocedure,
    'EXECUTE'
  ),
  'authenticated cannot execute the processing job claim'
);

select ok(
  has_function_privilege(
    'service_role',
    'private.claim_processing_job(text,text,integer)'::regprocedure,
    'EXECUTE'
  ),
  'service_role can execute the processing job claim'
);

select throws_like(
  $$select * from private.claim_processing_job('unknown', 'worker-a', 300)$$,
  '%invalid processing job kind%',
  'claim rejects an unknown job kind'
);

select throws_like(
  $$select * from private.claim_processing_job('photo_extraction', '   ', 300)$$,
  '%invalid processing worker identifier%',
  'claim rejects an empty worker identifier'
);

select throws_like(
  $$select * from private.claim_processing_job('photo_extraction', 'worker-a', 0)$$,
  '%invalid processing lease duration%',
  'claim rejects an unbounded lease duration'
);

set local role service_role;

select results_eq(
  $$
    select id
    from private.claim_processing_job('photo_extraction', 'worker-a', 300)
  $$,
  array['aaaaaaaa-2000-4000-8000-000000000020'::uuid],
  'the lowest-priority-number available job is claimed first'
);

reset role;

select ok(
  (
    select status = 'leased'
      and attempt_count = 1
      and worker_id = 'worker-a'
      and leased_at is not null
      and lease_expires_at > leased_at
    from private.processing_jobs
    where id = 'aaaaaaaa-2000-4000-8000-000000000020'
  ),
  'claim atomically records the first bounded lease attempt'
);

set local role service_role;

select results_eq(
  $$
    select id
    from private.claim_processing_job('photo_extraction', 'worker-b', 300)
  $$,
  array['aaaaaaaa-2000-4000-8000-000000000010'::uuid],
  'a second claim selects a different available job'
);

reset role;

update private.processing_jobs
set
  leased_at = statement_timestamp() - interval '2 seconds',
  lease_expires_at = statement_timestamp() - interval '1 second'
where id = 'aaaaaaaa-2000-4000-8000-000000000020';

set local role service_role;

select results_eq(
  $$
    select id
    from private.claim_processing_job('photo_extraction', 'worker-c', 300)
  $$,
  array['aaaaaaaa-2000-4000-8000-000000000020'::uuid],
  'an expired lease is reclaimed atomically'
);

reset role;

select ok(
  (
    select status = 'leased'
      and attempt_count = 2
      and worker_id = 'worker-c'
      and lease_expires_at > statement_timestamp()
    from private.processing_jobs
    where id = 'aaaaaaaa-2000-4000-8000-000000000020'
  ),
  'expired reclaim increments one attempt and replaces the lease owner'
);

update private.processing_jobs
set
  leased_at = statement_timestamp() - interval '2 seconds',
  lease_expires_at = statement_timestamp() - interval '1 second'
where id = 'aaaaaaaa-2000-4000-8000-000000000020';

set local role service_role;

select is_empty(
  $$
    select id
    from private.claim_processing_job('photo_extraction', 'worker-d', 300)
  $$,
  'an attempt-exhausted expired lease cannot be reclaimed'
);

reset role;

insert into private.processing_jobs (
  id,
  owner_id,
  profile_id,
  kind,
  subject_id,
  status,
  idempotency_key,
  attempt_count,
  completed_at
)
values (
  'aaaaaaaa-2000-4000-8000-000000000030',
  '11111111-1111-4111-8111-111111111111',
  'aaaaaaaa-0000-4000-8000-000000000001',
  'taste_candidates',
  'aaaaaaaa-1000-4000-8000-000000000030',
  'succeeded',
  'taste-candidates:subject-30:1',
  1,
  statement_timestamp()
);

set local role service_role;

select is_empty(
  $$
    select id
    from private.claim_processing_job('taste_candidates', 'worker-e', 300)
  $$,
  'a terminal job cannot be claimed'
);

reset role;

insert into private.processing_jobs (
  id,
  owner_id,
  profile_id,
  kind,
  subject_id,
  status,
  idempotency_key,
  attempt_count,
  max_attempts
)
values (
  'aaaaaaaa-2000-4000-8000-000000000040',
  '11111111-1111-4111-8111-111111111111',
  'aaaaaaaa-0000-4000-8000-000000000001',
  'report_generation',
  'aaaaaaaa-1000-4000-8000-000000000040',
  'queued',
  'report-generation:subject-40:1',
  2,
  2
);

set local role service_role;

select is_empty(
  $$
    select id
    from private.claim_processing_job('report_generation', 'worker-f', 300)
  $$,
  'an attempt-exhausted queued job cannot be claimed'
);

reset role;

select has_index(
  'private',
  'processing_jobs',
  'processing_jobs_claim_idx',
  'available work has the approved claim index'
);

select has_index(
  'private',
  'processing_jobs',
  'processing_jobs_lease_idx',
  'leased work has the approved expiry index'
);

select has_index(
  'private',
  'processing_jobs',
  'processing_jobs_cleanup_idx',
  'terminal work has the approved cleanup index'
);

select ok(
  (
    select index_record.indisunique
    from pg_index as index_record
    where index_record.indexrelid =
      'private.processing_jobs_idempotency_idx'::regclass
  ),
  'the idempotency index is unique'
);

select ok(
  exists (
    select 1
    from pg_trigger as trigger_record
    where trigger_record.tgrelid = 'private.processing_jobs'::regclass
      and trigger_record.tgname = 'processing_jobs_set_updated_at'
      and not trigger_record.tgisinternal
  ),
  'processing jobs install the shared updated-at trigger'
);

update private.processing_jobs
set updated_at = '2000-01-01T00:00:00Z'
where id = 'aaaaaaaa-2000-4000-8000-000000000030';

select ok(
  (
    select updated_at > '2000-01-01T00:00:00Z'::timestamptz
    from private.processing_jobs
    where id = 'aaaaaaaa-2000-4000-8000-000000000030'
  ),
  'processing job updates maintain updated_at through the shared trigger'
);

select is_empty(
  $$
    select 1
    from pg_class as relation
    cross join lateral aclexplode(
      coalesce(relation.relacl, acldefault('r', relation.relowner))
    ) as privilege
    where relation.oid = 'private.processing_jobs'::regclass
      and privilege.grantee = 0
      and privilege.privilege_type in (
        'SELECT',
        'INSERT',
        'UPDATE',
        'DELETE',
        'TRUNCATE'
      )
  $$,
  'PUBLIC receives no processing-job table privilege'
);

select * from finish();
rollback;
