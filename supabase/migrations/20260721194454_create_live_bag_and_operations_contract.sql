begin;

set local lock_timeout = '5s';
set local statement_timeout = '30s';

create table private.processing_jobs (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null,
  profile_id uuid not null,
  kind text not null,
  subject_id uuid not null,
  status text not null default 'queued',
  priority smallint not null default 100,
  idempotency_key text not null,
  attempt_count smallint not null default 0,
  max_attempts smallint not null default 2,
  available_at timestamptz not null default now(),
  leased_at timestamptz,
  lease_expires_at timestamptz,
  worker_id text,
  last_error_code text,
  last_error_details jsonb,
  completed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint processing_jobs_owner_fk
    foreign key (owner_id) references auth.users(id) on delete cascade,
  constraint processing_jobs_kind_check check (
    kind in (
      'photo_extraction',
      'taste_candidates',
      'report_generation',
      'wardrobe_preview',
      'report_notification',
      'retention_purge'
    )
  ),
  constraint processing_jobs_status_check check (
    status in (
      'queued',
      'leased',
      'retry_wait',
      'succeeded',
      'failed',
      'cancelled'
    )
  ),
  constraint processing_jobs_priority_check check (
    priority between 0 and 1000
  ),
  constraint processing_jobs_idempotency_key_check check (
    char_length(btrim(idempotency_key)) between 1 and 512
  ),
  constraint processing_jobs_attempts_check check (
    0 <= attempt_count
    and attempt_count <= max_attempts
    and max_attempts <= 3
  ),
  constraint processing_jobs_worker_id_check check (
    worker_id is null
    or char_length(btrim(worker_id)) between 1 and 120
  ),
  constraint processing_jobs_error_code_check check (
    last_error_code is null
    or char_length(btrim(last_error_code)) between 1 and 80
  ),
  constraint processing_jobs_error_details_check check (
    last_error_details is null
    or (
      jsonb_typeof(last_error_details) = 'object'
      and last_error_details ?& array[
        'job_kind',
        'operation_stage',
        'retryable',
        'customer_message_key'
      ]
      and last_error_details - array[
        'job_kind',
        'operation_stage',
        'retryable',
        'customer_message_key'
      ]::text[] = '{}'::jsonb
      and jsonb_typeof(last_error_details -> 'job_kind') = 'string'
      and last_error_details ->> 'job_kind' = kind
      and jsonb_typeof(last_error_details -> 'operation_stage') = 'string'
      and jsonb_typeof(last_error_details -> 'retryable') = 'boolean'
      and jsonb_typeof(last_error_details -> 'customer_message_key') = 'string'
      and char_length(
        btrim(last_error_details ->> 'customer_message_key')
      ) between 1 and 120
      and case kind
        when 'photo_extraction' then
          last_error_details ->> 'operation_stage' in (
            'decode',
            'analysis',
            'cutout',
            'persist'
          )
        when 'taste_candidates' then
          last_error_details ->> 'operation_stage' in (
            'seed',
            'balance',
            'persist'
          )
        when 'report_generation' then
          last_error_details ->> 'operation_stage' in (
            'profile_analysis',
            'catalog_matching',
            'report_writing',
            'finalizing'
          )
        when 'wardrobe_preview' then
          last_error_details ->> 'operation_stage' in (
            'source_prepare',
            'generate',
            'quality_check',
            'persist'
          )
        when 'report_notification' then
          last_error_details ->> 'operation_stage' in (
            'resolve_recipient',
            'send'
          )
        when 'retention_purge' then
          last_error_details ->> 'operation_stage' in (
            'enumerate',
            'delete_object',
            'delete_rows',
            'reconcile'
          )
        else false
      end
    )
  ),
  constraint processing_jobs_state_check check (
    case status
      when 'queued' then
        leased_at is null
        and lease_expires_at is null
        and worker_id is null
        and last_error_code is null
        and last_error_details is null
        and completed_at is null
      when 'leased' then
        leased_at is not null
        and lease_expires_at is not null
        and lease_expires_at > leased_at
        and worker_id is not null
        and attempt_count >= 1
        and last_error_code is null
        and last_error_details is null
        and completed_at is null
      when 'retry_wait' then
        leased_at is null
        and lease_expires_at is null
        and worker_id is null
        and attempt_count >= 1
        and attempt_count < max_attempts
        and last_error_code is not null
        and last_error_details is not null
        and (last_error_details ->> 'retryable')::boolean
        and completed_at is null
      when 'succeeded' then
        leased_at is null
        and lease_expires_at is null
        and worker_id is null
        and attempt_count >= 1
        and last_error_code is null
        and last_error_details is null
        and completed_at is not null
      when 'failed' then
        leased_at is null
        and lease_expires_at is null
        and worker_id is null
        and attempt_count >= 1
        and last_error_code is not null
        and last_error_details is not null
        and (
          not (last_error_details ->> 'retryable')::boolean
          or attempt_count = max_attempts
        )
        and completed_at is not null
      when 'cancelled' then
        leased_at is null
        and lease_expires_at is null
        and worker_id is null
        and last_error_code is not null
        and last_error_details is null
        and completed_at is not null
      else false
    end
  )
);

alter table private.processing_jobs enable row level security;

revoke all privileges on table private.processing_jobs
  from public, anon, authenticated, service_role;
grant select, insert, update, delete on table private.processing_jobs
  to service_role;

create index processing_jobs_claim_idx
on private.processing_jobs (priority, available_at, created_at, id)
where status in ('queued', 'retry_wait');

create index processing_jobs_lease_idx
on private.processing_jobs (lease_expires_at, id)
where status = 'leased';

create index processing_jobs_cleanup_idx
on private.processing_jobs (completed_at, id)
where status in ('succeeded', 'failed', 'cancelled');

create unique index processing_jobs_idempotency_idx
on private.processing_jobs (idempotency_key);

create trigger processing_jobs_set_updated_at
before update on private.processing_jobs
for each row execute function private.set_updated_at();

create function private.claim_processing_job(
  p_kind text,
  p_worker_id text,
  p_lease_seconds integer default 300
)
returns setof private.processing_jobs
language plpgsql
security definer
set search_path = ''
as $function$
begin
  if p_kind is null or p_kind not in (
    'photo_extraction',
    'taste_candidates',
    'report_generation',
    'wardrobe_preview',
    'report_notification',
    'retention_purge'
  ) then
    raise exception using
      errcode = '22023',
      message = 'invalid processing job kind';
  end if;

  if p_worker_id is null
    or pg_catalog.char_length(pg_catalog.btrim(p_worker_id)) not between 1 and 120
  then
    raise exception using
      errcode = '22023',
      message = 'invalid processing worker identifier';
  end if;

  if p_lease_seconds is null or p_lease_seconds not between 1 and 3600 then
    raise exception using
      errcode = '22023',
      message = 'invalid processing lease duration';
  end if;

  return query
  with next_job as (
    select job.id
    from private.processing_jobs as job
    where job.kind = p_kind
      and job.attempt_count < job.max_attempts
      and (
        (
          job.status in ('queued', 'retry_wait')
          and job.available_at <= pg_catalog.statement_timestamp()
        )
        or (
          job.status = 'leased'
          and job.lease_expires_at <= pg_catalog.statement_timestamp()
        )
      )
    order by
      job.priority,
      job.available_at,
      job.created_at,
      job.id
    for update skip locked
    limit 1
  )
  update private.processing_jobs as job
  set
    status = 'leased',
    attempt_count = job.attempt_count + 1,
    leased_at = pg_catalog.statement_timestamp(),
    lease_expires_at = pg_catalog.statement_timestamp()
      + pg_catalog.make_interval(secs => p_lease_seconds),
    worker_id = pg_catalog.btrim(p_worker_id),
    last_error_code = null,
    last_error_details = null,
    completed_at = null,
    updated_at = pg_catalog.statement_timestamp()
  from next_job
  where job.id = next_job.id
  returning job.*;
end;
$function$;

comment on function private.claim_processing_job(text, text, integer) is
  'Atomically claims one available or expired-leased job for a bounded worker lease.';

revoke execute on function private.claim_processing_job(text, text, integer)
  from public, anon, authenticated;
grant execute on function private.claim_processing_job(text, text, integer)
  to service_role;

commit;
