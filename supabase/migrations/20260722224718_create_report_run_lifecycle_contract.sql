begin;

set local lock_timeout = '5s';
set local statement_timeout = '30s';

create table public.report_runs (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null,
  profile_id uuid not null,
  profile_revision integer not null,
  status text not null default 'queued',
  stage text not null default 'queued',
  run_sequence smallint not null default 1,
  idempotency_key text not null,
  attempt_count smallint not null default 0,
  started_at timestamptz,
  completed_at timestamptz,
  last_error_code text,
  last_error_details jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint report_runs_owner_profile_fk
    foreign key (owner_id, profile_id)
    references public.profiles(owner_id, id)
    on update cascade
    on delete cascade
    deferrable initially immediate,
  constraint report_runs_owner_id_key unique (owner_id, id),
  constraint report_runs_owner_profile_id_key
    unique (owner_id, profile_id, id),
  constraint report_runs_profile_revision_check check (profile_revision >= 1),
  constraint report_runs_status_check check (
    status in ('queued', 'processing', 'succeeded', 'failed', 'cancelled')
  ),
  constraint report_runs_stage_check check (
    stage in (
      'queued',
      'profile_analysis',
      'catalog_matching',
      'report_writing',
      'preview_generation',
      'finalizing'
    )
  ),
  constraint report_runs_run_sequence_check check (run_sequence between 1 and 3),
  constraint report_runs_idempotency_key_check check (
    idempotency_key = btrim(idempotency_key)
    and char_length(idempotency_key) between 1 and 512
  ),
  constraint report_runs_attempt_count_check check (attempt_count between 0 and 2),
  constraint report_runs_started_at_check check (
    started_at is null or started_at >= created_at
  ),
  constraint report_runs_completed_at_check check (
    completed_at is null
    or completed_at >= coalesce(started_at, created_at)
  ),
  constraint report_runs_last_error_code_check check (
    last_error_code is null
    or last_error_code in (
      'REPORT_GENERATION_FAILED',
      'REPORT_GENERATION_TIMEOUT',
      'REPORT_OUTPUT_INVALID',
      'REPORT_NOT_RETRYABLE'
    )
  ),
  constraint report_runs_last_error_details_check check (
    last_error_details is null
    or (
      jsonb_typeof(last_error_details) = 'object'
      and last_error_details ?& array[
        'retryable',
        'stage',
        'customer_message_key'
      ]
      and (
        last_error_details - array[
          'retryable',
          'stage',
          'customer_message_key'
        ]::text[]
      ) = '{}'::jsonb
      and jsonb_typeof(last_error_details -> 'retryable') = 'boolean'
      and jsonb_typeof(last_error_details -> 'stage') = 'string'
      and (last_error_details ->> 'stage') in (
        'queued',
        'profile_analysis',
        'catalog_matching',
        'report_writing',
        'preview_generation',
        'finalizing'
      )
      and jsonb_typeof(last_error_details -> 'customer_message_key') = 'string'
      and (last_error_details ->> 'customer_message_key') =
        btrim(last_error_details ->> 'customer_message_key')
      and char_length(last_error_details ->> 'customer_message_key') between 1 and 120
      and (last_error_details ->> 'customer_message_key') ~
        '^[a-z][a-z0-9]*(_[a-z0-9]+)*$'
    )
  ),
  constraint report_runs_row_state_check check (
    (
      status = 'queued'
      and stage = 'queued'
      and attempt_count = 0
      and started_at is null
      and completed_at is null
      and last_error_code is null
      and last_error_details is null
    )
    or (
      status = 'processing'
      and stage <> 'queued'
      and attempt_count between 1 and 2
      and started_at is not null
      and completed_at is null
      and last_error_code is null
      and last_error_details is null
    )
    or (
      status = 'succeeded'
      and stage = 'finalizing'
      and attempt_count between 1 and 2
      and started_at is not null
      and completed_at is not null
      and last_error_code is null
      and last_error_details is null
    )
    or (
      status = 'failed'
      and stage <> 'queued'
      and attempt_count between 1 and 2
      and started_at is not null
      and completed_at is not null
      and last_error_code is not null
      and last_error_details is not null
      and (last_error_details ->> 'stage') = stage
    )
    or (
      status = 'cancelled'
      and completed_at is not null
      and last_error_code = 'REPORT_NOT_RETRYABLE'
      and (
        (
          stage = 'queued'
          and attempt_count = 0
          and started_at is null
        )
        or (
          stage <> 'queued'
          and attempt_count between 1 and 2
          and started_at is not null
        )
      )
      and (
        last_error_details is null
        or (
          (last_error_details ->> 'retryable')::boolean = false
          and (last_error_details ->> 'stage') = stage
        )
      )
    )
  )
);

create unique index report_runs_idempotency_idx
on public.report_runs (idempotency_key);

create unique index report_runs_sequence_idx
on public.report_runs (profile_id, profile_revision, run_sequence);

create unique index report_runs_one_live_idx
on public.report_runs (profile_id, profile_revision)
where status in ('queued', 'processing', 'succeeded');

create index report_runs_profile_status_idx
on public.report_runs (profile_id, status, created_at desc, id desc);

create function private.enforce_report_run_contract()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $function$
declare
  parent_status text;
  parent_revision integer;
  latest_sequence smallint;
  latest_status text;
  latest_error_details jsonb;
  report_exists boolean;
begin
  if tg_op = 'UPDATE' and new.owner_id is distinct from old.owner_id then
    if current_user <> 'postgres' then
      raise exception using
        errcode = '23514',
        message = 'report run owner is immutable outside the transfer transaction';
    end if;

    if row(
      new.id,
      new.profile_id,
      new.profile_revision,
      new.status,
      new.stage,
      new.run_sequence,
      new.idempotency_key,
      new.attempt_count,
      new.started_at,
      new.completed_at,
      new.last_error_code,
      new.last_error_details,
      new.created_at
    ) is distinct from row(
      old.id,
      old.profile_id,
      old.profile_revision,
      old.status,
      old.stage,
      old.run_sequence,
      old.idempotency_key,
      old.attempt_count,
      old.started_at,
      old.completed_at,
      old.last_error_code,
      old.last_error_details,
      old.created_at
    ) then
      raise exception using
        errcode = '23514',
        message = 'report run owner transfer cannot change lifecycle evidence';
    end if;

    return new;
  end if;

  select profile.status, profile.revision
  into parent_status, parent_revision
  from public.profiles as profile
  where profile.id = new.profile_id
    and profile.owner_id = new.owner_id
  for update;

  if parent_status is null then
    raise exception using
      errcode = '23514',
      message = 'report run must belong to one owned profile';
  end if;

  if new.profile_revision <> parent_revision then
    raise exception using
      errcode = '23514',
      message = 'report run revision must match frozen profile evidence';
  end if;

  if tg_op = 'INSERT' then
    if parent_status <> 'submitted' then
      raise exception using
        errcode = '23514',
        message = 'report run requires a submitted profile';
    end if;

    select
      run.run_sequence,
      run.status,
      run.last_error_details
    into latest_sequence, latest_status, latest_error_details
    from public.report_runs as run
    where run.profile_id = new.profile_id
      and run.profile_revision = new.profile_revision
    order by run.run_sequence desc
    limit 1;

    if latest_sequence is null then
      if new.run_sequence <> 1 then
        raise exception using
          errcode = '23514',
          message = 'first report run must use sequence one';
      end if;
    else
      if new.run_sequence <> latest_sequence + 1 then
        raise exception using
          errcode = '23514',
          message = 'report retry sequence must advance exactly once';
      end if;

      if latest_status not in ('failed', 'cancelled') then
        raise exception using
          errcode = '23514',
          message = 'report retry requires a terminal unsuccessful run';
      end if;

      if latest_status = 'failed'
        and coalesce((latest_error_details ->> 'retryable')::boolean, false) = false
      then
        raise exception using
          errcode = '23514',
          message = 'non-retryable report failure cannot create another sequence';
      end if;
    end if;

    return new;
  end if;

  if row(
    new.id,
    new.owner_id,
    new.profile_id,
    new.profile_revision,
    new.run_sequence,
    new.idempotency_key,
    new.created_at
  ) is distinct from row(
    old.id,
    old.owner_id,
    old.profile_id,
    old.profile_revision,
    old.run_sequence,
    old.idempotency_key,
    old.created_at
  ) then
    raise exception using
      errcode = '23514',
      message = 'report run identity and sequence are immutable';
  end if;

  select max(run.run_sequence)
  into latest_sequence
  from public.report_runs as run
  where run.profile_id = old.profile_id
    and run.profile_revision = old.profile_revision;

  if old.run_sequence <> latest_sequence then
    raise exception using
      errcode = '23514',
      message = 'stale report sequence cannot change lifecycle state';
  end if;

  if old.status in ('succeeded', 'failed', 'cancelled') then
    raise exception using
      errcode = '23514',
      message = 'terminal report run state is immutable';
  end if;

  if old.status = 'queued' then
    if new.status not in ('processing', 'cancelled') then
      raise exception using
        errcode = '23514',
        message = 'queued report run can only start processing or cancel';
    end if;

    if new.status = 'processing' and new.attempt_count <> 1 then
      raise exception using
        errcode = '23514',
        message = 'first report processing attempt must be one';
    end if;
  elsif old.status = 'processing' then
    if new.status not in ('processing', 'succeeded', 'failed', 'cancelled') then
      raise exception using
        errcode = '23514',
        message = 'processing report run has an invalid next state';
    end if;

    if new.attempt_count < old.attempt_count
      or new.attempt_count > old.attempt_count + 1
    then
      raise exception using
        errcode = '23514',
        message = 'report attempt count must stay stable or advance once';
    end if;

    if new.status <> 'processing' and new.attempt_count <> old.attempt_count then
      raise exception using
        errcode = '23514',
        message = 'terminal report transition cannot invent another attempt';
    end if;
  end if;

  if pg_catalog.array_position(
    array[
      'queued',
      'profile_analysis',
      'catalog_matching',
      'report_writing',
      'preview_generation',
      'finalizing'
    ]::text[],
    new.stage
  ) < pg_catalog.array_position(
    array[
      'queued',
      'profile_analysis',
      'catalog_matching',
      'report_writing',
      'preview_generation',
      'finalizing'
    ]::text[],
    old.stage
  ) then
    raise exception using
      errcode = '23514',
      message = 'report stage cannot move backward';
  end if;

  if old.started_at is not null and new.started_at is distinct from old.started_at then
    raise exception using
      errcode = '23514',
      message = 'report start time is immutable once set';
  end if;

  if new.status = 'succeeded' then
    if to_regclass('public.style_reports') is null then
      raise exception using
        errcode = '23514',
        message = 'report success requires the report publish contract';
    end if;

    execute
      'select exists (select 1 from public.style_reports where report_run_id = $1)'
    into report_exists
    using new.id;

    if not report_exists then
      raise exception using
        errcode = '23514',
        message = 'report success requires one published report';
    end if;
  end if;

  return new;
end;
$function$;

comment on function private.enforce_report_run_contract() is
  'Enforces frozen profile lineage, bounded explicit retries, monotonic stages, terminal states, and publish-before-success.';

revoke execute on function private.enforce_report_run_contract()
  from public, anon, authenticated, service_role;

create trigger report_runs_enforce_contract
before insert or update on public.report_runs
for each row execute function private.enforce_report_run_contract();

create trigger report_runs_set_updated_at
before update on public.report_runs
for each row execute function private.set_updated_at();

alter table public.report_runs enable row level security;

revoke all privileges on table public.report_runs
  from public, anon, authenticated, service_role;

grant select on table public.report_runs to authenticated;
grant select, insert, update, delete on table public.report_runs to service_role;

create policy report_runs_select_own
on public.report_runs for select
to authenticated
using (
  (select auth.uid()) is not null
  and owner_id = (select auth.uid())
);

comment on table public.report_runs is
  'Bounded customer-visible report lifecycle state for one frozen submitted profile revision; provider responses and report content are never stored here.';

commit;
