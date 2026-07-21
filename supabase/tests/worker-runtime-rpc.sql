begin;

create extension if not exists pgtap with schema extensions;
select plan(22);

select has_function(
  'public',
  'worker_claim_processing_job',
  array['text', 'text', 'integer'],
  'worker claim bridge exists in the exposed API schema'
);
select has_function(
  'public',
  'worker_heartbeat_processing_job',
  array['uuid', 'text', 'integer'],
  'worker heartbeat boundary exists'
);
select has_function(
  'public',
  'worker_complete_processing_job',
  array['uuid', 'text'],
  'worker completion boundary exists'
);
select has_function(
  'public',
  'worker_release_processing_job',
  array['uuid', 'text', 'text', 'jsonb', 'integer'],
  'worker release boundary exists'
);

select is_empty(
  $$
    select procedure.oid
    from pg_proc as procedure
    where procedure.oid in (
      'public.worker_claim_processing_job(text,text,integer)'::regprocedure,
      'public.worker_heartbeat_processing_job(uuid,text,integer)'::regprocedure,
      'public.worker_complete_processing_job(uuid,text)'::regprocedure,
      'public.worker_release_processing_job(uuid,text,text,jsonb,integer)'::regprocedure
    )
      and procedure.prosecdef
  $$,
  'worker Data API boundaries use caller privileges rather than bypassing grants'
);

select is_empty(
  $$
    select procedure.oid
    from pg_proc as procedure
    where procedure.oid in (
      'public.worker_claim_processing_job(text,text,integer)'::regprocedure,
      'public.worker_heartbeat_processing_job(uuid,text,integer)'::regprocedure,
      'public.worker_complete_processing_job(uuid,text)'::regprocedure,
      'public.worker_release_processing_job(uuid,text,text,jsonb,integer)'::regprocedure
    )
      and not coalesce('search_path=""' = any(procedure.proconfig), false)
  $$,
  'every worker boundary fixes an empty search path'
);

select is_empty(
  $$
    select 1
    from pg_proc as procedure
    cross join lateral aclexplode(
      coalesce(procedure.proacl, acldefault('f', procedure.proowner))
    ) as privilege
    where procedure.oid in (
      'public.worker_claim_processing_job(text,text,integer)'::regprocedure,
      'public.worker_heartbeat_processing_job(uuid,text,integer)'::regprocedure,
      'public.worker_complete_processing_job(uuid,text)'::regprocedure,
      'public.worker_release_processing_job(uuid,text,text,jsonb,integer)'::regprocedure
    )
      and privilege.grantee = 0
      and privilege.privilege_type = 'EXECUTE'
  $$,
  'PUBLIC cannot execute any worker boundary'
);

select ok(
  not has_function_privilege(
    'anon',
    'public.worker_claim_processing_job(text,text,integer)'::regprocedure,
    'EXECUTE'
  )
  and not has_function_privilege(
    'anon',
    'public.worker_heartbeat_processing_job(uuid,text,integer)'::regprocedure,
    'EXECUTE'
  )
  and not has_function_privilege(
    'anon',
    'public.worker_complete_processing_job(uuid,text)'::regprocedure,
    'EXECUTE'
  )
  and not has_function_privilege(
    'anon',
    'public.worker_release_processing_job(uuid,text,text,jsonb,integer)'::regprocedure,
    'EXECUTE'
  ),
  'anon cannot execute worker boundaries'
);

select ok(
  not has_function_privilege(
    'authenticated',
    'public.worker_claim_processing_job(text,text,integer)'::regprocedure,
    'EXECUTE'
  )
  and not has_function_privilege(
    'authenticated',
    'public.worker_heartbeat_processing_job(uuid,text,integer)'::regprocedure,
    'EXECUTE'
  )
  and not has_function_privilege(
    'authenticated',
    'public.worker_complete_processing_job(uuid,text)'::regprocedure,
    'EXECUTE'
  )
  and not has_function_privilege(
    'authenticated',
    'public.worker_release_processing_job(uuid,text,text,jsonb,integer)'::regprocedure,
    'EXECUTE'
  ),
  'authenticated customers cannot execute worker boundaries'
);

select ok(
  has_function_privilege(
    'service_role',
    'public.worker_claim_processing_job(text,text,integer)'::regprocedure,
    'EXECUTE'
  )
  and has_function_privilege(
    'service_role',
    'public.worker_heartbeat_processing_job(uuid,text,integer)'::regprocedure,
    'EXECUTE'
  )
  and has_function_privilege(
    'service_role',
    'public.worker_complete_processing_job(uuid,text)'::regprocedure,
    'EXECUTE'
  )
  and has_function_privilege(
    'service_role',
    'public.worker_release_processing_job(uuid,text,text,jsonb,integer)'::regprocedure,
    'EXECUTE'
  ),
  'service_role can execute every worker boundary'
);

insert into private.processing_jobs (
  id,
  owner_id,
  profile_id,
  kind,
  subject_id,
  status,
  priority,
  idempotency_key,
  attempt_count,
  max_attempts,
  available_at,
  leased_at,
  lease_expires_at,
  worker_id
)
values
  (
    '46000000-0000-4000-8000-000000000001',
    '11111111-1111-4111-8111-111111111111',
    '46000000-0000-4000-8000-000000000011',
    'photo_extraction',
    '46000000-0000-4000-8000-000000000021',
    'leased',
    0,
    'worker-runtime:active',
    1,
    3,
    statement_timestamp() - interval '10 minutes',
    statement_timestamp() - interval '1 minute',
    statement_timestamp() + interval '5 minutes',
    'active-worker'
  ),
  (
    '46000000-0000-4000-8000-000000000002',
    '11111111-1111-4111-8111-111111111111',
    '46000000-0000-4000-8000-000000000011',
    'photo_extraction',
    '46000000-0000-4000-8000-000000000022',
    'leased',
    1,
    'worker-runtime:expired',
    1,
    3,
    statement_timestamp() - interval '10 minutes',
    statement_timestamp() - interval '2 minutes',
    statement_timestamp() - interval '1 minute',
    'expired-worker'
  ),
  (
    '46000000-0000-4000-8000-000000000003',
    '11111111-1111-4111-8111-111111111111',
    '46000000-0000-4000-8000-000000000011',
    'photo_extraction',
    '46000000-0000-4000-8000-000000000023',
    'queued',
    2,
    'worker-runtime:queued',
    0,
    3,
    statement_timestamp() - interval '1 minute',
    null,
    null,
    null
  );

set local role service_role;

select results_eq(
  $$
    select id
    from public.worker_claim_processing_job(
      'photo_extraction',
      'replacement-worker',
      120
    )
  $$,
  $$values ('46000000-0000-4000-8000-000000000002'::uuid)$$,
  'the public bridge reclaims the expired lease before queued work'
);

select results_eq(
  $$
    select worker_id
    from private.processing_jobs
    where id = '46000000-0000-4000-8000-000000000001'
  $$,
  $$values ('active-worker'::text)$$,
  'an active lease remains owned by its current worker'
);

select is(
  (
    select count(*)::integer
    from public.worker_heartbeat_processing_job(
      '46000000-0000-4000-8000-000000000002',
      'replacement-worker',
      180
    )
  ),
  1,
  'the current worker renews its active lease'
);

select is_empty(
  $$
    select id
    from public.worker_heartbeat_processing_job(
      '46000000-0000-4000-8000-000000000002',
      'wrong-worker',
      180
    )
  $$,
  'a different worker cannot heartbeat the lease'
);

select results_eq(
  $$
    select status
    from public.worker_release_processing_job(
      '46000000-0000-4000-8000-000000000002',
      'replacement-worker',
      'WORKER_SHUTDOWN',
      '{
        "job_kind": "photo_extraction",
        "operation_stage": "decode",
        "retryable": true,
        "customer_message_key": "processing_interrupted_retrying"
      }'::jsonb,
      30
    )
  $$,
  $$values ('retry_wait'::text)$$,
  'shutdown releases an eligible lease into bounded retry wait'
);

select ok(
  (
    select last_error_code = 'WORKER_SHUTDOWN'
      and last_error_details = '{
        "job_kind": "photo_extraction",
        "operation_stage": "decode",
        "retryable": true,
        "customer_message_key": "processing_interrupted_retrying"
      }'::jsonb
      and worker_id is null
      and lease_expires_at is null
      and completed_at is null
    from private.processing_jobs
    where id = '46000000-0000-4000-8000-000000000002'
  ),
  'released work stores only the approved safe failure shape'
);

select results_eq(
  $$
    select id
    from public.worker_claim_processing_job(
      'photo_extraction',
      'completion-worker',
      120
    )
  $$,
  $$values ('46000000-0000-4000-8000-000000000003'::uuid)$$,
  'the worker next claims one due queued job'
);

select results_eq(
  $$
    select status
    from public.worker_complete_processing_job(
      '46000000-0000-4000-8000-000000000003',
      'completion-worker'
    )
  $$,
  $$values ('succeeded'::text)$$,
  'the current worker completes its active job'
);

select ok(
  (
    select completed_at is not null
      and worker_id is null
      and leased_at is null
      and lease_expires_at is null
      and last_error_code is null
      and last_error_details is null
    from private.processing_jobs
    where id = '46000000-0000-4000-8000-000000000003'
  ),
  'completion clears lease and error fields atomically'
);

select is_empty(
  $$
    select id
    from public.worker_claim_processing_job(
      'photo_extraction',
      'idle-worker',
      120
    )
  $$,
  'active and delayed retry leases are not claimable'
);

select is_empty(
  $$
    select id
    from public.worker_release_processing_job(
      '46000000-0000-4000-8000-000000000001',
      'wrong-worker',
      'WORKER_SHUTDOWN',
      '{
        "job_kind": "photo_extraction",
        "operation_stage": "decode",
        "retryable": true,
        "customer_message_key": "processing_interrupted_retrying"
      }'::jsonb,
      5
    )
  $$,
  'a different worker cannot release an active lease'
);

select throws_like(
  $$
    select *
    from public.worker_heartbeat_processing_job(
      '46000000-0000-4000-8000-000000000001',
      'active-worker',
      0
    )
  $$,
  '%invalid processing lease duration%',
  'heartbeat rejects an unbounded lease duration'
);

reset role;
select * from finish();
rollback;
