begin;

set local lock_timeout = '5s';
set local statement_timeout = '30s';

-- PostgREST exposes only public and graphql_public. These invoker functions keep
-- the operational table and its privileged claim implementation in the private
-- schema while giving the server-only service role the smallest callable API.
create function public.worker_claim_processing_job(
  p_kind text,
  p_worker_id text,
  p_lease_seconds integer default 300
)
returns setof private.processing_jobs
language sql
security invoker
set search_path = ''
as $function$
  select *
  from private.claim_processing_job(p_kind, p_worker_id, p_lease_seconds);
$function$;

create function public.worker_heartbeat_processing_job(
  p_job_id uuid,
  p_worker_id text,
  p_lease_seconds integer default 300
)
returns setof private.processing_jobs
language plpgsql
security invoker
set search_path = ''
as $function$
begin
  if p_job_id is null then
    raise exception using
      errcode = '22023',
      message = 'invalid processing job identifier';
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
  update private.processing_jobs as job
  set
    lease_expires_at = pg_catalog.statement_timestamp()
      + pg_catalog.make_interval(secs => p_lease_seconds),
    updated_at = pg_catalog.statement_timestamp()
  where job.id = p_job_id
    and job.status = 'leased'
    and job.worker_id = pg_catalog.btrim(p_worker_id)
    and job.lease_expires_at > pg_catalog.statement_timestamp()
  returning job.*;
end;
$function$;

create function public.worker_complete_processing_job(
  p_job_id uuid,
  p_worker_id text
)
returns setof private.processing_jobs
language plpgsql
security invoker
set search_path = ''
as $function$
begin
  if p_job_id is null then
    raise exception using
      errcode = '22023',
      message = 'invalid processing job identifier';
  end if;

  if p_worker_id is null
    or pg_catalog.char_length(pg_catalog.btrim(p_worker_id)) not between 1 and 120
  then
    raise exception using
      errcode = '22023',
      message = 'invalid processing worker identifier';
  end if;

  return query
  update private.processing_jobs as job
  set
    status = 'succeeded',
    leased_at = null,
    lease_expires_at = null,
    worker_id = null,
    last_error_code = null,
    last_error_details = null,
    completed_at = pg_catalog.statement_timestamp(),
    updated_at = pg_catalog.statement_timestamp()
  where job.id = p_job_id
    and job.status = 'leased'
    and job.worker_id = pg_catalog.btrim(p_worker_id)
    and job.lease_expires_at > pg_catalog.statement_timestamp()
  returning job.*;
end;
$function$;

create function public.worker_release_processing_job(
  p_job_id uuid,
  p_worker_id text,
  p_error_code text,
  p_error_details jsonb,
  p_retry_delay_seconds integer default 5
)
returns setof private.processing_jobs
language plpgsql
security invoker
set search_path = ''
as $function$
declare
  retryable boolean;
begin
  if p_job_id is null then
    raise exception using
      errcode = '22023',
      message = 'invalid processing job identifier';
  end if;

  if p_worker_id is null
    or pg_catalog.char_length(pg_catalog.btrim(p_worker_id)) not between 1 and 120
  then
    raise exception using
      errcode = '22023',
      message = 'invalid processing worker identifier';
  end if;

  if p_error_code is null
    or pg_catalog.char_length(pg_catalog.btrim(p_error_code)) not between 1 and 80
  then
    raise exception using
      errcode = '22023',
      message = 'invalid processing error code';
  end if;

  if p_error_details is null
    or pg_catalog.jsonb_typeof(p_error_details) <> 'object'
    or pg_catalog.jsonb_typeof(p_error_details -> 'retryable') <> 'boolean'
  then
    raise exception using
      errcode = '22023',
      message = 'invalid processing error details';
  end if;

  if p_retry_delay_seconds is null
    or p_retry_delay_seconds not between 0 and 3600
  then
    raise exception using
      errcode = '22023',
      message = 'invalid processing retry delay';
  end if;

  retryable := (p_error_details ->> 'retryable')::boolean;

  return query
  update private.processing_jobs as job
  set
    status = case
      when retryable and job.attempt_count < job.max_attempts then 'retry_wait'
      else 'failed'
    end,
    available_at = pg_catalog.statement_timestamp()
      + pg_catalog.make_interval(secs => p_retry_delay_seconds),
    leased_at = null,
    lease_expires_at = null,
    worker_id = null,
    last_error_code = pg_catalog.btrim(p_error_code),
    last_error_details = p_error_details,
    completed_at = case
      when retryable and job.attempt_count < job.max_attempts then null
      else pg_catalog.statement_timestamp()
    end,
    updated_at = pg_catalog.statement_timestamp()
  where job.id = p_job_id
    and job.status = 'leased'
    and job.worker_id = pg_catalog.btrim(p_worker_id)
  returning job.*;
end;
$function$;

comment on function public.worker_claim_processing_job(text, text, integer) is
  'Service-role-only Data API bridge to the private atomic processing-job claim.';
comment on function public.worker_heartbeat_processing_job(uuid, text, integer) is
  'Renews one active processing-job lease only for its current worker.';
comment on function public.worker_complete_processing_job(uuid, text) is
  'Completes one active processing-job lease only for its current worker.';
comment on function public.worker_release_processing_job(uuid, text, text, jsonb, integer) is
  'Releases one current worker lease to bounded retry or terminal failure.';

revoke execute on function public.worker_claim_processing_job(text, text, integer)
  from public, anon, authenticated;
revoke execute on function public.worker_heartbeat_processing_job(uuid, text, integer)
  from public, anon, authenticated;
revoke execute on function public.worker_complete_processing_job(uuid, text)
  from public, anon, authenticated;
revoke execute on function public.worker_release_processing_job(uuid, text, text, jsonb, integer)
  from public, anon, authenticated;

grant execute on function public.worker_claim_processing_job(text, text, integer)
  to service_role;
grant execute on function public.worker_heartbeat_processing_job(uuid, text, integer)
  to service_role;
grant execute on function public.worker_complete_processing_job(uuid, text)
  to service_role;
grant execute on function public.worker_release_processing_job(uuid, text, text, jsonb, integer)
  to service_role;

commit;
