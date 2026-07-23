begin;

create extension if not exists pgtap with schema extensions;
select no_plan();

select has_function(
  'private',
  'publish_style_report',
  array[
    'uuid', 'text', 'text', 'text', 'text', 'text', 'text', 'jsonb', 'jsonb'
  ],
  'atomic report publication function exists'
);

select ok(
  (
    select not prosecdef and coalesce('search_path=""' = any(proconfig), false)
    from pg_proc
    where oid = 'private.publish_style_report(uuid,text,text,text,text,text,text,jsonb,jsonb)'::regprocedure
  ),
  'publication is security invoker with an empty search path'
);

select ok(
  has_function_privilege(
    'service_role',
    'private.publish_style_report(uuid,text,text,text,text,text,text,jsonb,jsonb)'::regprocedure,
    'EXECUTE'
  )
  and not has_function_privilege(
    'authenticated',
    'private.publish_style_report(uuid,text,text,text,text,text,text,jsonb,jsonb)'::regprocedure,
    'EXECUTE'
  )
  and not has_function_privilege(
    'anon',
    'private.publish_style_report(uuid,text,text,text,text,text,text,jsonb,jsonb)'::regprocedure,
    'EXECUTE'
  ),
  'only the server role can invoke report publication'
);

create temporary table publish_test_payload (
  sections jsonb not null,
  recommendations jsonb not null
) on commit drop;

insert into publish_test_payload (sections, recommendations) values (
  '[
    {
      "section_type":"overview",
      "position":1,
      "content":{
        "style_identity":"Polished contrast",
        "summary":"Strong structure and vivid color create a confident through-line.",
        "strengths":[{"label":"Color confidence","explanation":"Saturated color supports the customer''s visible style signals."}],
        "priorities":[{"label":"Repeat structure","explanation":"Use defined silhouettes to make outfit decisions easier."}]
      }
    },
    {
      "section_type":"color",
      "position":2,
      "content":{
        "palette_name":"Electric warmth",
        "summary":"Warm brights and deep anchors create useful contrast.",
        "best_colors":[
          {"name":"Hot pink","hex":"#FF2D8D","reason":"Echoes an established favorite."},
          {"name":"Tangerine","hex":"#FF6A21","reason":"Adds vivid warmth."},
          {"name":"Inky navy","hex":"#10152F","reason":"Creates a deep neutral anchor."},
          {"name":"Cream","hex":"#FFF3D7","reason":"Softens the brightest combinations."}
        ],
        "approach_with_care":[]
      }
    },
    {
      "section_type":"body_style",
      "position":3,
      "content":{
        "kibbe_informed_family":"Balanced definition",
        "summary":"Defined waists and intentional vertical lines support the observed proportions.",
        "shape_guidance":[{"label":"Defined waist","explanation":"Try pieces that acknowledge the waist without restricting movement."}],
        "proportion_guidance":[{"label":"Long line","explanation":"Repeat a color or shape vertically to create continuity."}],
        "disclosure":"This is interpretive styling guidance, not an objective, medical, or value judgment."
      }
    }
  ]'::jsonb,
  '[
    {
      "position":1,
      "category":"dress",
      "title":"A strong column of color",
      "rationale":"A defined waist and uninterrupted color line reflect the strongest signals in the report.",
      "styling_note":"Keep the accessories graphic and minimal.",
      "catalog_product_ref":"gid://shopify/Product/eng029-1",
      "catalog_shop_ref":"gid://shopify/Shop/eng029",
      "catalog_variant_ref":"gid://shopify/ProductVariant/eng029-1",
      "outfit_group_key":"event-color",
      "outfit_group_title":"Event color story",
      "outfit_item_position":1
    },
    {
      "position":2,
      "category":"jacket",
      "title":"A structured finishing layer",
      "rationale":"Clean structure repeats the customer''s preference for polished definition.",
      "styling_note":"Wear it open to preserve the vertical line.",
      "catalog_product_ref":"gid://shopify/Product/eng029-2",
      "catalog_shop_ref":"gid://shopify/Shop/eng029",
      "catalog_variant_ref":null,
      "outfit_group_key":"event-color",
      "outfit_group_title":"Event color story",
      "outfit_item_position":2
    }
  ]'::jsonb
);

grant select on table publish_test_payload to service_role;

insert into public.profiles (
  id, owner_id, status, current_step, revision, name, age,
  adult_confirmed_at, gender, height_cm, fit_preference, submitted_at
) values
  (
    'a2900000-0000-4000-8000-000000000001',
    '11111111-1111-4111-8111-111111111111',
    'active', 'complete', 1, 'Prior active', 34,
    now(), 'woman', 165, 'regular', now()
  ),
  (
    'a2900000-0000-4000-8000-000000000002',
    '11111111-1111-4111-8111-111111111111',
    'submitted', 'complete', 1, 'Ready report', 34,
    now(), 'woman', 165, 'regular', now()
  ),
  (
    'a2900000-0000-4000-8000-000000000003',
    '11111111-1111-4111-8111-111111111111',
    'submitted', 'complete', 1, 'Invalid report', 34,
    now(), 'woman', 165, 'regular', now()
  );

insert into public.report_runs (
  id, owner_id, profile_id, profile_revision, idempotency_key
) values
  (
    'a2910000-0000-4000-8000-000000000001',
    '11111111-1111-4111-8111-111111111111',
    'a2900000-0000-4000-8000-000000000002',
    1, 'report-publish:a2910000-0000-4000-8000-000000000001'
  ),
  (
    'a2910000-0000-4000-8000-000000000002',
    '11111111-1111-4111-8111-111111111111',
    'a2900000-0000-4000-8000-000000000003',
    1, 'report-publish:a2910000-0000-4000-8000-000000000002'
  );

update public.report_runs
set
  status = 'processing',
  stage = 'finalizing',
  attempt_count = 1,
  started_at = now();

set local role service_role;

select results_eq(
  $$
    select profile_id, version
    from private.publish_style_report(
      'a2910000-0000-4000-8000-000000000001',
      'Your style report',
      'A confident point of view grounded in your favorite looks.',
      'These findings are interpretive styling guidance, not objective measurements.',
      'report-v1',
      'openai',
      'approved-text-model',
      (select sections from publish_test_payload),
      (select recommendations from publish_test_payload)
    )
  $$,
  $$values ('a2900000-0000-4000-8000-000000000002'::uuid, 1)$$,
  'complete valid output publishes one owner-level report version'
);

select is(
  (select count(*) from public.style_reports where report_run_id='a2910000-0000-4000-8000-000000000001'),
  1::bigint,
  'publication creates exactly one immutable report'
);

select is(
  (
    select count(*)
    from public.report_sections as section
    join public.style_reports as report on report.id=section.report_id
    where report.report_run_id='a2910000-0000-4000-8000-000000000001'
  ),
  3::bigint,
  'publication creates all three canonical report sections'
);

select is(
  (
    select count(*)
    from public.recommendations as recommendation
    join public.style_reports as report on report.id=recommendation.report_id
    where report.report_run_id='a2910000-0000-4000-8000-000000000001'
  ),
  2::bigint,
  'publication creates every normalized recommendation'
);

select results_eq(
  $$select status from public.profiles where id in ('a2900000-0000-4000-8000-000000000001','a2900000-0000-4000-8000-000000000002') order by id$$,
  $$values ('archived'::text), ('active'::text)$$,
  'publication archives the prior active profile and activates the submitted profile'
);

select results_eq(
  $$select status, stage from public.report_runs where id='a2910000-0000-4000-8000-000000000001'$$,
  $$values ('succeeded'::text, 'finalizing'::text)$$,
  'publication succeeds the exact finalizing report run'
);

select is(
  (
    select count(*)
    from private.processing_jobs
    where kind='report_notification'
      and subject_id=(
        select id from public.style_reports
        where report_run_id='a2910000-0000-4000-8000-000000000001'
      )
      and status='queued'
  ),
  1::bigint,
  'publication enqueues one report notification without delivering it'
);

select results_eq(
  $$
    select report_id
    from private.publish_style_report(
      'a2910000-0000-4000-8000-000000000001',
      'Ignored replay title',
      'Ignored replay summary.',
      'Ignored replay disclosure.',
      'ignored-version',
      'ignored-provider',
      'ignored-model',
      (select sections from publish_test_payload),
      (select recommendations from publish_test_payload)
    )
  $$,
  $$select id from public.style_reports where report_run_id='a2910000-0000-4000-8000-000000000001'$$,
  'replaying a succeeded run returns the original publication'
);

select ok(
  (select count(*)=1 from public.style_reports where report_run_id='a2910000-0000-4000-8000-000000000001')
  and (select count(*)=1 from private.processing_jobs where kind='report_notification' and profile_id='a2900000-0000-4000-8000-000000000002'),
  'publication replay duplicates neither the report nor notification job'
);

select throws_like(
  $publish$
    select *
    from private.publish_style_report(
      'a2910000-0000-4000-8000-000000000002',
      'Incomplete style report',
      'This output must not persist.',
      'Interpretive guidance only.',
      'report-v1',
      'openai',
      'approved-text-model',
      (select sections - 2 from publish_test_payload),
      (select recommendations from publish_test_payload)
    )
  $publish$,
  'report publication requires exactly three normalized sections',
  'missing required section rejects the publication call'
);

select ok(
  not exists (select 1 from public.style_reports where report_run_id='a2910000-0000-4000-8000-000000000002')
  and not exists (select 1 from public.report_sections where profile_id='a2900000-0000-4000-8000-000000000003')
  and not exists (select 1 from public.recommendations where profile_id='a2900000-0000-4000-8000-000000000003')
  and not exists (select 1 from private.processing_jobs where profile_id='a2900000-0000-4000-8000-000000000003')
  and (select status='processing' from public.report_runs where id='a2910000-0000-4000-8000-000000000002')
  and (select status='submitted' from public.profiles where id='a2900000-0000-4000-8000-000000000003'),
  'missing-section failure rolls back every publication write and lifecycle transition'
);

select throws_like(
  $publish$
    select *
    from private.publish_style_report(
      'a2910000-0000-4000-8000-000000000002',
      'Unexpected section shape',
      'This output must not persist.',
      'Interpretive guidance only.',
      'report-v1',
      'openai',
      'approved-text-model',
      (select jsonb_set(sections, '{0,raw_provider_output}', 'true'::jsonb) from publish_test_payload),
      (select recommendations from publish_test_payload)
    )
  $publish$,
  'report publication requires exactly three normalized sections',
  'unknown provider-output keys fail closed before persistence'
);

select throws_like(
  $publish$
    select *
    from private.publish_style_report(
      'a2910000-0000-4000-8000-000000000002',
      'Missing recommendation report',
      'This output must not persist.',
      'Interpretive guidance only.',
      'report-v1',
      'openai',
      'approved-text-model',
      (select sections from publish_test_payload),
      '[]'::jsonb
    )
  $publish$,
  'report publication requires one to twenty-four normalized recommendations',
  'a report cannot publish without at least one recommendation'
);

reset role;
select * from finish();
rollback;
