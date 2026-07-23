begin;

create extension if not exists pgtap with schema extensions;
select plan(26);

select has_table(
  'private',
  'notification_deliveries',
  'notification deliveries table exists in the private schema'
);

select columns_are(
  'private',
  'notification_deliveries',
  array[
    'id',
    'owner_id',
    'profile_id',
    'report_id',
    'kind',
    'status',
    'idempotency_key',
    'provider_message_ref',
    'attempt_count',
    'last_error_code',
    'sent_at',
    'created_at',
    'updated_at'
  ],
  'notification deliveries expose only the approved bounded columns'
);

select is(
  (
    select relation.relrowsecurity
    from pg_class as relation
    where relation.oid = 'private.notification_deliveries'::regclass
  ),
  true,
  'notification deliveries use RLS as private-schema defense in depth'
);

select ok(
  not has_schema_privilege('anon', 'private', 'USAGE')
  and not has_table_privilege(
    'anon',
    'private.notification_deliveries',
    'SELECT'
  )
  and not has_table_privilege(
    'anon',
    'private.notification_deliveries',
    'INSERT'
  ),
  'anon cannot access notification deliveries'
);

select ok(
  not has_schema_privilege('authenticated', 'private', 'USAGE')
  and not has_table_privilege(
    'authenticated',
    'private.notification_deliveries',
    'SELECT'
  )
  and not has_table_privilege(
    'authenticated',
    'private.notification_deliveries',
    'INSERT'
  )
  and not has_table_privilege(
    'authenticated',
    'private.notification_deliveries',
    'UPDATE'
  ),
  'authenticated customers cannot access notification deliveries'
);

select ok(
  has_schema_privilege('service_role', 'private', 'USAGE')
  and has_table_privilege(
    'service_role',
    'private.notification_deliveries',
    'SELECT'
  )
  and has_table_privilege(
    'service_role',
    'private.notification_deliveries',
    'INSERT'
  )
  and has_table_privilege(
    'service_role',
    'private.notification_deliveries',
    'UPDATE'
  )
  and has_table_privilege(
    'service_role',
    'private.notification_deliveries',
    'DELETE'
  )
  and not has_table_privilege(
    'service_role',
    'private.notification_deliveries',
    'TRUNCATE'
  ),
  'service_role receives only required delivery-record DML privileges'
);

select ok(
  exists (
    select 1
    from pg_constraint as constraint_record
    where constraint_record.conrelid =
      'private.notification_deliveries'::regclass
      and constraint_record.conname = 'notification_deliveries_report_fk'
      and constraint_record.confrelid = 'public.style_reports'::regclass
  ),
  'delivery ownership is constrained by the referenced report'
);

select ok(
  exists (
    select 1
    from pg_indexes
    where schemaname = 'private'
      and tablename = 'notification_deliveries'
      and indexname = 'notification_deliveries_owner_profile_report_idx'
      and indexdef like
        '%(owner_id, profile_id, report_id)%'
  ),
  'the composite report foreign key has a covering index'
);

select ok(
  exists (
    select 1
    from pg_indexes
    where schemaname = 'private'
      and tablename = 'notification_deliveries'
      and indexname = 'notification_delivery_key_idx'
      and indexdef like 'CREATE UNIQUE INDEX%'
  ),
  'delivery idempotency key is unique'
);

select ok(
  exists (
    select 1
    from pg_indexes
    where schemaname = 'private'
      and tablename = 'notification_deliveries'
      and indexname = 'notification_deliveries_report_kind_idx'
      and indexdef like 'CREATE UNIQUE INDEX%'
  ),
  'one report and notification kind has one delivery record'
);

select ok(
  exists (
    select 1
    from pg_constraint as constraint_record
    where constraint_record.conrelid =
      'private.notification_deliveries'::regclass
      and constraint_record.conname =
        'notification_deliveries_attempt_count_check'
      and pg_get_constraintdef(constraint_record.oid) like
        '%attempt_count >= 0%attempt_count <= 3%'
  ),
  'delivery attempts are database-capped at three'
);

select ok(
  not exists (
    select 1
    from information_schema.columns
    where table_schema = 'private'
      and table_name = 'notification_deliveries'
      and (
        column_name like '%email%'
        or column_name like '%body%'
        or column_name like '%content%'
        or column_name like '%payload%'
      )
  ),
  'delivery records persist no email address, body, report content, or payload'
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
) values (
  'a3100000-0000-4000-8000-000000000001',
  '11111111-1111-4111-8111-111111111111',
  'submitted',
  'complete',
  'Notification fixture',
  34,
  now(),
  'woman',
  165,
  'regular',
  now()
);

insert into public.report_runs (
  id,
  owner_id,
  profile_id,
  profile_revision,
  idempotency_key
) values (
  'a3110000-0000-4000-8000-000000000001',
  '11111111-1111-4111-8111-111111111111',
  'a3100000-0000-4000-8000-000000000001',
  1,
  'notification-fixture:report-run'
);

alter table public.style_reports disable trigger user;

insert into public.style_reports (
  id,
  owner_id,
  profile_id,
  report_run_id,
  version,
  title,
  summary,
  confidence_note,
  method_version,
  provider_name,
  provider_model
) values (
  'a3120000-0000-4000-8000-000000000001',
  '11111111-1111-4111-8111-111111111111',
  'a3100000-0000-4000-8000-000000000001',
  'a3110000-0000-4000-8000-000000000001',
  1,
  'Notification fixture report',
  'A fixture report used only to verify notification delivery persistence.',
  'Interpretive styling guidance only.',
  'test-v1',
  'test-provider',
  'test-model'
);

alter table public.style_reports enable trigger user;

set local role service_role;

select throws_like(
  $$
    insert into private.notification_deliveries (
      owner_id,
      profile_id,
      report_id,
      kind,
      idempotency_key
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a3100000-0000-4000-8000-000000000001',
      'a3120000-0000-4000-8000-000000000001',
      'marketing',
      'report-ready:invalid-kind'
    )
  $$,
  '%notification_deliveries_kind_check%',
  'only report-ready notifications can be recorded'
);

select throws_like(
  $$
    insert into private.notification_deliveries (
      owner_id,
      profile_id,
      report_id,
      kind,
      idempotency_key
    ) values (
      '22222222-2222-4222-8222-222222222222',
      'a3100000-0000-4000-8000-000000000001',
      'a3120000-0000-4000-8000-000000000001',
      'report_ready',
      'report-ready:wrong-owner'
    )
  $$,
  '%notification_deliveries_report_fk%',
  'delivery ownership must match the referenced report'
);

select throws_like(
  $$
    insert into private.notification_deliveries (
      owner_id,
      profile_id,
      report_id,
      kind,
      idempotency_key,
      attempt_count
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a3100000-0000-4000-8000-000000000001',
      'a3120000-0000-4000-8000-000000000001',
      'report_ready',
      'report-ready:too-many-attempts',
      4
    )
  $$,
  'notification delivery must begin as an unattempted request',
  'a delivery request cannot skip directly to a later attempt'
);

select throws_like(
  $$
    insert into private.notification_deliveries (
      owner_id,
      profile_id,
      report_id,
      kind,
      status,
      idempotency_key,
      provider_message_ref,
      attempt_count,
      sent_at
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a3100000-0000-4000-8000-000000000001',
      'a3120000-0000-4000-8000-000000000001',
      'report_ready',
      'sent',
      'report-ready:precompleted',
      'message-before-request',
      1,
      now()
    )
  $$,
  'notification delivery must begin as an unattempted request',
  'a completed send cannot be inserted without a durable request'
);

select lives_ok(
  $$
    insert into private.notification_deliveries (
      id,
      owner_id,
      profile_id,
      report_id,
      kind,
      idempotency_key
    ) values (
      'a3130000-0000-4000-8000-000000000001',
      '11111111-1111-4111-8111-111111111111',
      'a3100000-0000-4000-8000-000000000001',
      'a3120000-0000-4000-8000-000000000001',
      'report_ready',
      'report-ready:a3120000-0000-4000-8000-000000000001'
    )
  $$,
  'a bounded queued delivery request is accepted'
);

select lives_ok(
  $$
    update private.notification_deliveries
    set attempt_count = 1
    where id = 'a3130000-0000-4000-8000-000000000001'
  $$,
  'claiming the first send increments the attempt once'
);

select lives_ok(
  $$
    update private.notification_deliveries
    set
      status = 'failed',
      last_error_code = 'PROVIDER_TIMEOUT'
    where id = 'a3130000-0000-4000-8000-000000000001'
  $$,
  'a bounded safe failure code can be recorded'
);

select throws_like(
  $$
    update private.notification_deliveries
    set
      status = 'queued',
      last_error_code = null
    where id = 'a3130000-0000-4000-8000-000000000001'
  $$,
  'notification delivery retry must increment attempt count',
  'a retry cannot reuse the previous attempt number'
);

select lives_ok(
  $$
    update private.notification_deliveries
    set
      status = 'queued',
      attempt_count = 2,
      last_error_code = null
    where id = 'a3130000-0000-4000-8000-000000000001'
  $$,
  'a retry advances the existing delivery record exactly once'
);

select lives_ok(
  $$
    update private.notification_deliveries
    set
      status = 'sent',
      provider_message_ref = 'resend-message-ref',
      sent_at = now()
    where id = 'a3130000-0000-4000-8000-000000000001'
  $$,
  'the retried delivery can record one successful send'
);

select throws_like(
  $$
    update private.notification_deliveries
    set
      status = 'queued',
      attempt_count = 3,
      provider_message_ref = null,
      sent_at = null
    where id = 'a3130000-0000-4000-8000-000000000001'
  $$,
  'sent notification delivery is terminal',
  'a successful delivery cannot be retried'
);

select throws_like(
  $$
    insert into private.notification_deliveries (
      owner_id,
      profile_id,
      report_id,
      kind,
      idempotency_key
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a3100000-0000-4000-8000-000000000001',
      'a3120000-0000-4000-8000-000000000001',
      'report_ready',
      'report-ready:duplicate-request'
    )
  $$,
  '%notification_deliveries_report_kind_idx%',
  'one report and channel cannot create a second delivery request'
);

select results_eq(
  $$
    select status, attempt_count, provider_message_ref, last_error_code
    from private.notification_deliveries
    where report_id = 'a3120000-0000-4000-8000-000000000001'
  $$,
  $$
    values ('sent'::text, 2::smallint, 'resend-message-ref'::text, null::text)
  $$,
  'retry and success remain on one bounded delivery record'
);

select is(
  (
    select count(*)
    from private.notification_deliveries
    where report_id = 'a3120000-0000-4000-8000-000000000001'
  ),
  1::bigint,
  'successful delivery is not duplicated'
);

select * from finish();
rollback;
