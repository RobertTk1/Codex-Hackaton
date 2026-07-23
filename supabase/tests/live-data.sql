begin;

create extension if not exists pgtap with schema extensions;
select no_plan();

select has_table('public', 'live_sessions', 'live sessions table exists');

select columns_are(
  'public',
  'live_sessions',
  array[
    'id',
    'owner_id',
    'profile_id',
    'status',
    'selected_recommendation_id',
    'catalog_product_ref',
    'catalog_shop_ref',
    'catalog_variant_ref',
    'camera_consent_record_id',
    'microphone_consent_record_id',
    'gemini_visual_consent_record_id',
    'gemini_context_mode',
    'result_set_id',
    'last_action_sequence',
    'connection_ms',
    'first_frame_ms',
    'last_action_latency_ms',
    'last_error_code',
    'started_at',
    'ended_at',
    'created_at',
    'updated_at'
  ],
  'live sessions persist only the approved bounded session state'
);

select is(
  (
    select count(*)
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'live_sessions'
      and (
        column_name like '%audio%'
        or column_name like '%video%'
        or column_name like '%raw_frame%'
        or column_name like '%transcript%'
        or column_name like '%payload%'
        or column_name like '%credential%'
        or column_name like '%provider_session%'
      )
  ),
  0::bigint,
  'no media, transcript, provider session, credential, or payload column exists'
);

select is(
  (select relrowsecurity from pg_class where oid = 'public.live_sessions'::regclass),
  true,
  'live sessions have row-level security enabled'
);

select ok(
  not has_table_privilege('anon', 'public.live_sessions', 'SELECT')
  and not has_table_privilege('anon', 'public.live_sessions', 'INSERT')
  and not has_table_privilege('anon', 'public.live_sessions', 'UPDATE')
  and not has_table_privilege('anon', 'public.live_sessions', 'DELETE'),
  'bare anonymous requests have no live-session privileges'
);

select ok(
  has_table_privilege('authenticated', 'public.live_sessions', 'SELECT')
  and not has_table_privilege('authenticated', 'public.live_sessions', 'INSERT')
  and not has_table_privilege('authenticated', 'public.live_sessions', 'UPDATE')
  and not has_table_privilege('authenticated', 'public.live_sessions', 'DELETE'),
  'customers can read only their owned permanent-account live sessions'
);

select ok(
  has_table_privilege('service_role', 'public.live_sessions', 'SELECT')
  and has_table_privilege('service_role', 'public.live_sessions', 'INSERT')
  and has_table_privilege('service_role', 'public.live_sessions', 'UPDATE')
  and has_table_privilege('service_role', 'public.live_sessions', 'DELETE')
  and not has_table_privilege('service_role', 'public.live_sessions', 'TRUNCATE'),
  'service operations receive bounded DML without destructive table authority'
);

select results_eq(
  $$
    select policyname
    from pg_policies
    where schemaname = 'public' and tablename = 'live_sessions'
    order by policyname
  $$,
  array['live_sessions_select_own_permanent']::name[],
  'live sessions expose one owner-and-permanent-account select policy'
);

select has_index(
  'public',
  'live_sessions',
  'live_sessions_profile_created_idx',
  'recent live-session lookup is indexed'
);

select has_index(
  'public',
  'live_sessions',
  'live_sessions_profile_result_set_idx',
  'current result-set validation is indexed'
);

select has_index(
  'public',
  'live_sessions',
  'live_sessions_cleanup_idx',
  'terminal live-session cleanup is indexed by end time'
);

select has_function(
  'private',
  'enforce_live_session_contract',
  array[]::text[],
  'live-session contract trigger exists'
);

select ok(
  not has_function_privilege(
    'authenticated',
    'private.enforce_live_session_contract()'::regprocedure,
    'EXECUTE'
  )
  and not has_function_privilege(
    'anon',
    'private.enforce_live_session_contract()'::regprocedure,
    'EXECUTE'
  )
  and not has_function_privilege(
    'service_role',
    'private.enforce_live_session_contract()'::regprocedure,
    'EXECUTE'
  ),
  'the live-session guard is trigger-only'
);

select ok(
  (
    select coalesce('search_path=""' = any(proconfig), false)
    from pg_proc
    where oid = 'private.enforce_live_session_contract()'::regprocedure
  ),
  'the live-session guard fixes an empty search path'
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
    'a3200000-0000-4000-8000-000000000001',
    '11111111-1111-4111-8111-111111111111',
    'active',
    'complete',
    'Live owner',
    34,
    now(),
    'woman',
    165,
    'regular',
    now()
  ),
  (
    'b3200000-0000-4000-8000-000000000001',
    '22222222-2222-4222-8222-222222222222',
    'active',
    'complete',
    'Other live owner',
    35,
    now(),
    'woman',
    168,
    'regular',
    now()
  );

insert into public.consent_records (
  id,
  owner_id,
  profile_id,
  purpose,
  decision,
  policy_version,
  copy_sha256,
  captured_at
) values
  (
    'a3210000-0000-4000-8000-000000000001',
    '11111111-1111-4111-8111-111111111111',
    'a3200000-0000-4000-8000-000000000001',
    'live_camera',
    'granted',
    'live-v1',
    decode(repeat('31', 32), 'hex'),
    now() - interval '4 minutes'
  ),
  (
    'a3210000-0000-4000-8000-000000000002',
    '11111111-1111-4111-8111-111111111111',
    'a3200000-0000-4000-8000-000000000001',
    'live_microphone',
    'granted',
    'live-v1',
    decode(repeat('32', 32), 'hex'),
    now() - interval '3 minutes'
  ),
  (
    'a3210000-0000-4000-8000-000000000003',
    '11111111-1111-4111-8111-111111111111',
    'a3200000-0000-4000-8000-000000000001',
    'gemini_visual_context',
    'granted',
    'live-v1',
    decode(repeat('33', 32), 'hex'),
    now() - interval '2 minutes'
  ),
  (
    'b3210000-0000-4000-8000-000000000001',
    '22222222-2222-4222-8222-222222222222',
    'b3200000-0000-4000-8000-000000000001',
    'live_camera',
    'granted',
    'live-v1',
    decode(repeat('34', 32), 'hex'),
    now() - interval '1 minute'
  );

set local role service_role;

select throws_like(
  $$
    insert into public.live_sessions (
      owner_id,
      profile_id,
      catalog_product_ref,
      catalog_shop_ref,
      camera_consent_record_id
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a3200000-0000-4000-8000-000000000001',
      'shopify://product/one',
      'shopify://shop/one',
      'a3210000-0000-4000-8000-000000000002'
    )
  $$,
  'live session creation requires current granted camera consent',
  'camera consent is required at live-session creation'
);

select throws_like(
  $$
    insert into public.live_sessions (
      owner_id,
      profile_id,
      catalog_product_ref,
      catalog_shop_ref,
      camera_consent_record_id
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a3200000-0000-4000-8000-000000000001',
      'shopify://product/one',
      'shopify://shop/one',
      'b3210000-0000-4000-8000-000000000001'
    )
  $$,
  'live session creation requires current granted camera consent',
  'camera consent cannot cross owners'
);

select lives_ok(
  $$
    insert into public.live_sessions (
      id,
      owner_id,
      profile_id,
      catalog_product_ref,
      catalog_shop_ref,
      camera_consent_record_id
    ) values (
      'a3220000-0000-4000-8000-000000000001',
      '11111111-1111-4111-8111-111111111111',
      'a3200000-0000-4000-8000-000000000001',
      'shopify://product/one',
      'shopify://shop/one',
      'a3210000-0000-4000-8000-000000000001'
    )
  $$,
  'camera-only created state is accepted'
);

select throws_like(
  $$
    update public.live_sessions
    set status = 'ready', started_at = now()
    where id = 'a3220000-0000-4000-8000-000000000001'
  $$,
  'invalid live session state transition',
  'created state cannot skip connecting'
);

select lives_ok(
  $$
    update public.live_sessions
    set
      status = 'connecting',
      started_at = now(),
      connection_ms = 240,
      first_frame_ms = 510
    where id = 'a3220000-0000-4000-8000-000000000001'
  $$,
  'created session can enter connecting with aggregate timing only'
);

select throws_like(
  $$
    update public.live_sessions
    set
      catalog_product_ref = 'shopify://product/two',
      catalog_shop_ref = 'shopify://shop/two'
    where id = 'a3220000-0000-4000-8000-000000000001'
  $$,
  'live selection change requires a fresh action sequence',
  'duplicate or stale sequence cannot change the live selection'
);

select lives_ok(
  $$
    update public.live_sessions
    set
      catalog_product_ref = 'shopify://product/two',
      catalog_shop_ref = 'shopify://shop/two',
      result_set_id = 'a3230000-0000-4000-8000-000000000001',
      last_action_sequence = 4,
      last_action_latency_ms = 125
    where id = 'a3220000-0000-4000-8000-000000000001'
  $$,
  'a strictly newer sequence can advance bounded selection state'
);

select throws_like(
  $$
    update public.live_sessions
    set last_action_sequence = 3
    where id = 'a3220000-0000-4000-8000-000000000001'
  $$,
  'live action sequence cannot move backward',
  'action sequence cannot move backward'
);

select throws_like(
  $$
    update public.live_sessions
    set
      microphone_consent_record_id =
        'a3210000-0000-4000-8000-000000000002',
      gemini_context_mode = 'sampled_video'
    where id = 'a3220000-0000-4000-8000-000000000001'
  $$,
  '%live_sessions_gemini_shape_check%',
  'sampled video cannot omit visual-context consent'
);

select lives_ok(
  $$
    update public.live_sessions
    set
      microphone_consent_record_id =
        'a3210000-0000-4000-8000-000000000002',
      gemini_visual_consent_record_id =
        'a3210000-0000-4000-8000-000000000003',
      gemini_context_mode = 'sampled_video'
    where id = 'a3220000-0000-4000-8000-000000000001'
  $$,
  'sampled video records current microphone and visual consent lineage'
);

select lives_ok(
  $$
    update public.live_sessions
    set status = 'ready'
    where id = 'a3220000-0000-4000-8000-000000000001'
  $$,
  'connecting session can become ready'
);

select throws_like(
  $$
    update public.live_sessions
    set last_action_latency_ms = 600001
    where id = 'a3220000-0000-4000-8000-000000000001'
  $$,
  '%live_sessions_action_latency_ms_check%',
  'aggregate action latency is capped'
);

select lives_ok(
  $$
    update public.live_sessions
    set status = 'ended', ended_at = now()
    where id = 'a3220000-0000-4000-8000-000000000001'
  $$,
  'ready session can end cleanly'
);

select throws_like(
  $$
    update public.live_sessions
    set last_action_latency_ms = 130
    where id = 'a3220000-0000-4000-8000-000000000001'
  $$,
  'terminal live session is immutable',
  'ended session is terminal'
);

set local role postgres;

insert into public.live_sessions (
  id,
  owner_id,
  profile_id,
  catalog_product_ref,
  catalog_shop_ref,
  camera_consent_record_id
) values (
  'b3220000-0000-4000-8000-000000000001',
  '22222222-2222-4222-8222-222222222222',
  'b3200000-0000-4000-8000-000000000001',
  'shopify://product/other',
  'shopify://shop/other',
  'b3210000-0000-4000-8000-000000000001'
);

set local role authenticated;
select set_config(
  'request.jwt.claims',
  '{"sub":"11111111-1111-4111-8111-111111111111","role":"authenticated","is_anonymous":false}',
  true
);

select is(
  (select count(*) from public.live_sessions),
  1::bigint,
  'a permanent customer reads only its owned live session'
);

select throws_like(
  $$
    insert into public.live_sessions (
      owner_id,
      profile_id,
      camera_consent_record_id
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a3200000-0000-4000-8000-000000000001',
      'a3210000-0000-4000-8000-000000000001'
    )
  $$,
  '%permission denied for table live_sessions%',
  'customers cannot bypass server-owned live-session creation'
);

select set_config(
  'request.jwt.claims',
  '{"sub":"11111111-1111-4111-8111-111111111111","role":"authenticated","is_anonymous":true}',
  true
);

select is(
  (select count(*) from public.live_sessions),
  0::bigint,
  'anonymous identities cannot read permanent live sessions'
);

select * from finish();
rollback;
