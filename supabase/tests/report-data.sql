begin;

create extension if not exists pgtap with schema extensions;
select no_plan();

select has_table('public', 'style_reports', 'style report table exists');
select has_table('public', 'report_sections', 'typed report section table exists');

select columns_are(
  'public',
  'style_reports',
  array[
    'id', 'owner_id', 'profile_id', 'report_run_id',
    'derived_from_report_id', 'version', 'title', 'summary',
    'confidence_note', 'method_version', 'provider_name', 'provider_model',
    'created_at'
  ],
  'style reports retain only immutable normalized report metadata'
);

select columns_are(
  'public',
  'report_sections',
  array[
    'id', 'owner_id', 'profile_id', 'report_id', 'section_type',
    'position', 'content', 'created_at'
  ],
  'report sections retain only owned typed content'
);

select is(
  (
    select count(*)
    from information_schema.columns
    where table_schema = 'public'
      and table_name in ('style_reports', 'report_sections')
      and column_name ~ '(prompt|response|transcript|payload|photo|image|url)'
  ),
  0::bigint,
  'published reports cannot retain raw provider bodies, prompts, transcripts, or media'
);

select has_index('public', 'style_reports', 'style_reports_owner_version_idx', 'owner report versions are unique');
select has_index('public', 'style_reports', 'style_reports_derived_idx', 'prior report lineage is indexed');
select has_index('public', 'style_reports', 'style_reports_run_idx', 'one report per run is enforced');
select has_index('public', 'style_reports', 'style_reports_owner_profile_run_idx', 'same-owner report-run lineage has one covering index');
select has_index('public', 'report_sections', 'report_sections_report_position_idx', 'canonical report positions are unique');
select has_index('public', 'report_sections', 'report_sections_owner_profile_report_idx', 'same-owner section lineage has one covering index');

select ok(
  exists (
    select 1
    from pg_constraint
    where conrelid = 'public.style_reports'::regclass
      and conname = 'style_reports_owner_profile_run_fk'
      and confrelid = 'public.report_runs'::regclass
      and condeferrable
      and not condeferred
  ),
  'report lineage uses one same-owner profile/run foreign key'
);

select ok(
  exists (
    select 1
    from pg_constraint
    where conrelid = 'public.report_sections'::regclass
      and conname = 'report_sections_owner_profile_report_fk'
      and confrelid = 'public.style_reports'::regclass
      and condeferrable
      and not condeferred
  ),
  'section lineage uses one same-owner profile/report foreign key'
);

select is(
  (select relrowsecurity from pg_class where oid = 'public.style_reports'::regclass),
  true,
  'style reports have row-level security enabled'
);

select is(
  (select relrowsecurity from pg_class where oid = 'public.report_sections'::regclass),
  true,
  'report sections have row-level security enabled'
);

select ok(
  not has_table_privilege('anon', 'public.style_reports', 'SELECT')
  and not has_table_privilege('anon', 'public.report_sections', 'SELECT'),
  'bare anonymous requests cannot reach report data'
);

select ok(
  has_table_privilege('authenticated', 'public.style_reports', 'SELECT')
  and not has_table_privilege('authenticated', 'public.style_reports', 'INSERT')
  and not has_table_privilege('authenticated', 'public.style_reports', 'UPDATE')
  and not has_table_privilege('authenticated', 'public.style_reports', 'DELETE')
  and has_table_privilege('authenticated', 'public.report_sections', 'SELECT')
  and not has_table_privilege('authenticated', 'public.report_sections', 'INSERT')
  and not has_table_privilege('authenticated', 'public.report_sections', 'UPDATE')
  and not has_table_privilege('authenticated', 'public.report_sections', 'DELETE'),
  'customers receive owner-scoped read-only access to published reports'
);

select ok(
  has_table_privilege('service_role', 'public.style_reports', 'SELECT')
  and has_table_privilege('service_role', 'public.style_reports', 'INSERT')
  and has_table_privilege('service_role', 'public.style_reports', 'UPDATE')
  and has_table_privilege('service_role', 'public.style_reports', 'DELETE')
  and not has_table_privilege('service_role', 'public.style_reports', 'TRUNCATE')
  and has_table_privilege('service_role', 'public.report_sections', 'SELECT')
  and has_table_privilege('service_role', 'public.report_sections', 'INSERT')
  and has_table_privilege('service_role', 'public.report_sections', 'UPDATE')
  and has_table_privilege('service_role', 'public.report_sections', 'DELETE')
  and not has_table_privilege('service_role', 'public.report_sections', 'TRUNCATE'),
  'service writes remain bounded DML without table-destructive authority'
);

select results_eq(
  $$select policyname from pg_policies where schemaname='public' and tablename='style_reports' order by policyname$$,
  array['style_reports_select_own']::name[],
  'style reports expose only owner-scoped reads'
);

select results_eq(
  $$select policyname from pg_policies where schemaname='public' and tablename='report_sections' order by policyname$$,
  array['report_sections_select_own']::name[],
  'report sections expose only owner-scoped reads'
);

select has_function(
  'private', 'valid_report_section_content', array['text', 'jsonb'],
  'exact section-content validator exists'
);
select has_function(
  'private', 'enforce_style_report_insert_contract', array[]::text[],
  'report version and run guard exists'
);
select has_function(
  'private', 'enforce_style_report_publication', array[]::text[],
  'deferred publication-completeness guard exists'
);

select ok(
  (
    select not prosecdef and coalesce('search_path=""' = any(proconfig), false)
    from pg_proc
    where oid = 'private.valid_report_section_content(text,jsonb)'::regprocedure
  ) and (
    select not prosecdef and coalesce('search_path=""' = any(proconfig), false)
    from pg_proc
    where oid = 'private.enforce_style_report_insert_contract()'::regprocedure
  ) and (
    select not prosecdef and coalesce('search_path=""' = any(proconfig), false)
    from pg_proc
    where oid = 'private.enforce_style_report_publication()'::regprocedure
  ),
  'report helpers are security invoker with empty search paths'
);

select ok(
  not has_function_privilege('authenticated', 'private.valid_report_section_content(text,jsonb)'::regprocedure, 'EXECUTE')
  and has_function_privilege('service_role', 'private.valid_report_section_content(text,jsonb)'::regprocedure, 'EXECUTE')
  and not has_function_privilege('service_role', 'private.enforce_style_report_insert_contract()'::regprocedure, 'EXECUTE')
  and not has_function_privilege('service_role', 'private.enforce_style_report_publication()'::regprocedure, 'EXECUTE'),
  'only the pure content validator is callable by the server writer'
);

select has_trigger('public', 'style_reports', 'style_reports_enforce_insert_contract', 'report inserts enforce owner-level versioning');
select has_trigger('public', 'style_reports', 'style_reports_prevent_mutation', 'published reports reject mutation');
select has_trigger('public', 'style_reports', 'style_reports_enforce_publication', 'report publication completeness is deferred');
select has_trigger('public', 'report_sections', 'report_sections_prevent_mutation', 'published sections reject mutation');
select has_trigger('public', 'report_sections', 'report_sections_enforce_publication', 'section publication completeness is deferred');

create temporary table report_test_content (
  section_type text primary key,
  position smallint not null,
  content jsonb not null
) on commit drop;

insert into report_test_content (section_type, position, content) values
  (
    'overview',
    1,
    '{
      "style_identity":"Polished contrast",
      "summary":"Strong structure and vivid color create a confident through-line.",
      "strengths":[{"label":"Color confidence","explanation":"Saturated color supports the customer''s visible style signals."}],
      "priorities":[{"label":"Repeat structure","explanation":"Use defined silhouettes to make outfit decisions easier."}]
    }'::jsonb
  ),
  (
    'color',
    2,
    '{
      "palette_name":"Electric warmth",
      "summary":"Warm brights and deep anchors create useful contrast.",
      "best_colors":[
        {"name":"Hot pink","hex":"#FF2D8D","reason":"Echoes an established favorite."},
        {"name":"Tangerine","hex":"#FF6A21","reason":"Adds vivid warmth."},
        {"name":"Inky navy","hex":"#10152F","reason":"Creates a deep neutral anchor."},
        {"name":"Cream","hex":"#FFF3D7","reason":"Softens the brightest combinations."}
      ],
      "approach_with_care":[]
    }'::jsonb
  ),
  (
    'body_style',
    3,
    '{
      "kibbe_informed_family":"Balanced definition",
      "summary":"Defined waists and intentional vertical lines support the observed proportions.",
      "shape_guidance":[{"label":"Defined waist","explanation":"Try pieces that acknowledge the waist without restricting movement."}],
      "proportion_guidance":[{"label":"Long line","explanation":"Repeat a color or shape vertically to create continuity."}],
      "disclosure":"This is interpretive styling guidance, not an objective, medical, or value judgment."
    }'::jsonb
  );

grant select on table report_test_content to service_role;

insert into public.profiles (
  id, owner_id, status, current_step, revision, name, age,
  adult_confirmed_at, gender, height_cm, fit_preference, submitted_at
) values
  (
    'a2600000-0000-4000-8000-000000000001',
    '11111111-1111-4111-8111-111111111111',
    'submitted', 'complete', 1, 'Report one', 34,
    now(), 'woman', 165, 'regular', now()
  ),
  (
    'a2600000-0000-4000-8000-000000000002',
    '11111111-1111-4111-8111-111111111111',
    'submitted', 'complete', 1, 'Report two', 34,
    now(), 'woman', 165, 'regular', now()
  ),
  (
    'b2600000-0000-4000-8000-000000000001',
    '22222222-2222-4222-8222-222222222222',
    'submitted', 'complete', 1, 'Other owner report', 35,
    now(), 'woman', 167, 'relaxed', now()
  );

insert into public.report_runs (
  id, owner_id, profile_id, profile_revision, idempotency_key
) values
  (
    'a2610000-0000-4000-8000-000000000001',
    '11111111-1111-4111-8111-111111111111',
    'a2600000-0000-4000-8000-000000000001',
    1, 'report:a2600000-0000-4000-8000-000000000001:1:1:first'
  ),
  (
    'a2610000-0000-4000-8000-000000000002',
    '11111111-1111-4111-8111-111111111111',
    'a2600000-0000-4000-8000-000000000002',
    1, 'report:a2600000-0000-4000-8000-000000000002:1:1:second'
  ),
  (
    'b2610000-0000-4000-8000-000000000001',
    '22222222-2222-4222-8222-222222222222',
    'b2600000-0000-4000-8000-000000000001',
    1, 'report:b2600000-0000-4000-8000-000000000001:1:1:first'
  );

update public.report_runs
set status='processing', stage='finalizing', attempt_count=1, started_at=now();

set local role service_role;

insert into public.style_reports (
  id, owner_id, profile_id, report_run_id, version, title, summary,
  confidence_note, method_version, provider_name, provider_model
) values (
  'a2620000-0000-4000-8000-000000000001',
  '11111111-1111-4111-8111-111111111111',
  'a2600000-0000-4000-8000-000000000001',
  'a2610000-0000-4000-8000-000000000001',
  1,
  'Your style report',
  'A confident point of view grounded in your favorite looks.',
  'These findings are interpretive styling guidance, not objective measurements.',
  'report-v1',
  'openai',
  'approved-text-model'
);

insert into public.report_sections (
  owner_id, profile_id, report_id, section_type, position, content
)
select
  '11111111-1111-4111-8111-111111111111'::uuid,
  'a2600000-0000-4000-8000-000000000001'::uuid,
  'a2620000-0000-4000-8000-000000000001'::uuid,
  section_type,
  position,
  content
from report_test_content;

update public.report_runs
set status='succeeded', completed_at=now()
where id='a2610000-0000-4000-8000-000000000001';

select lives_ok(
  $$set constraints all immediate$$,
  'one report with exactly overview, color, and body-style sections publishes atomically'
);
set constraints all deferred;

select throws_like(
  $$
    update public.report_sections
    set content = jsonb_set(content, '{summary}', '"changed"'::jsonb)
    where report_id='a2620000-0000-4000-8000-000000000001'
      and section_type='overview'
  $$,
  'published report sections are immutable',
  'published section content cannot be updated'
);

select throws_like(
  $$
    update public.style_reports
    set summary='A silently revised summary.'
    where id='a2620000-0000-4000-8000-000000000001'
  $$,
  'published style reports are immutable',
  'published report metadata cannot be silently revised'
);

select throws_like(
  $$
    insert into public.report_sections (
      owner_id, profile_id, report_id, section_type, position, content
    )
    select
      '11111111-1111-4111-8111-111111111111'::uuid,
      'a2600000-0000-4000-8000-000000000001'::uuid,
      'a2620000-0000-4000-8000-000000000001'::uuid,
      'overview', 2, content
    from report_test_content where section_type='overview'
  $$,
  '%report_sections_canonical_order_check%',
  'section type cannot be persisted outside its canonical position'
);

select throws_like(
  $$
    insert into public.report_sections (
      owner_id, profile_id, report_id, section_type, position, content
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2600000-0000-4000-8000-000000000001',
      'a2620000-0000-4000-8000-000000000001',
      'color',
      2,
      '{"palette_name":"Too short","summary":"Invalid","best_colors":[],"approach_with_care":[],"raw_provider_output":"forbidden"}'::jsonb
    )
  $$,
  '%report_sections_content_check%',
  'unknown section keys and incomplete arrays fail closed'
);

savepoint incomplete_report;

insert into public.style_reports (
  id, owner_id, profile_id, report_run_id, derived_from_report_id,
  version, title, summary, confidence_note, method_version,
  provider_name, provider_model
) values (
  'a2620000-0000-4000-8000-000000000002',
  '11111111-1111-4111-8111-111111111111',
  'a2600000-0000-4000-8000-000000000002',
  'a2610000-0000-4000-8000-000000000002',
  'a2620000-0000-4000-8000-000000000001',
  2, 'Second style report', 'A second immutable report.',
  'Interpretive styling guidance only.', 'report-v1', 'openai', 'approved-text-model'
);

insert into public.report_sections (
  owner_id, profile_id, report_id, section_type, position, content
)
select
  '11111111-1111-4111-8111-111111111111'::uuid,
  'a2600000-0000-4000-8000-000000000002'::uuid,
  'a2620000-0000-4000-8000-000000000002'::uuid,
  section_type,
  position,
  content
from report_test_content
where section_type <> 'body_style';

update public.report_runs
set status='succeeded', completed_at=now()
where id='a2610000-0000-4000-8000-000000000002';

select throws_like(
  $$set constraints all immediate$$,
  'published style report requires exactly one valid section of each type',
  'a report cannot publish with a missing required section'
);

rollback to savepoint incomplete_report;
set constraints all deferred;

select throws_like(
  $$
    insert into public.style_reports (
      owner_id, profile_id, report_run_id, derived_from_report_id,
      version, title, summary, confidence_note, method_version,
      provider_name, provider_model
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2600000-0000-4000-8000-000000000002',
      'a2610000-0000-4000-8000-000000000002',
      'a2620000-0000-4000-8000-000000000001',
      3, 'Skipped version', 'Invalid owner version gap.',
      'Interpretive guidance.', 'report-v1', 'openai', 'approved-text-model'
    )
  $$,
  'owner report version and lineage must advance exactly once',
  'owner report versions cannot skip a number'
);

select throws_like(
  $$
    insert into public.style_reports (
      owner_id, profile_id, report_run_id,
      version, title, summary, confidence_note, method_version,
      provider_name, provider_model
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2600000-0000-4000-8000-000000000002',
      'a2610000-0000-4000-8000-000000000002',
      2, 'Missing lineage', 'Invalid missing prior report.',
      'Interpretive guidance.', 'report-v1', 'openai', 'approved-text-model'
    )
  $$,
  'owner report version and lineage must advance exactly once',
  'next owner report must identify the exact previous version'
);

insert into public.style_reports (
  id, owner_id, profile_id, report_run_id, derived_from_report_id,
  version, title, summary, confidence_note, method_version,
  provider_name, provider_model
) values (
  'a2620000-0000-4000-8000-000000000002',
  '11111111-1111-4111-8111-111111111111',
  'a2600000-0000-4000-8000-000000000002',
  'a2610000-0000-4000-8000-000000000002',
  'a2620000-0000-4000-8000-000000000001',
  2, 'Second style report', 'A second immutable report.',
  'Interpretive styling guidance only.', 'report-v1', 'openai', 'approved-text-model'
);

insert into public.report_sections (
  owner_id, profile_id, report_id, section_type, position, content
)
select
  '11111111-1111-4111-8111-111111111111'::uuid,
  'a2600000-0000-4000-8000-000000000002'::uuid,
  'a2620000-0000-4000-8000-000000000002'::uuid,
  section_type,
  position,
  content
from report_test_content;

update public.report_runs
set status='succeeded', completed_at=now()
where id='a2610000-0000-4000-8000-000000000002';

insert into public.style_reports (
  id, owner_id, profile_id, report_run_id,
  version, title, summary, confidence_note, method_version,
  provider_name, provider_model
) values (
  'b2620000-0000-4000-8000-000000000001',
  '22222222-2222-4222-8222-222222222222',
  'b2600000-0000-4000-8000-000000000001',
  'b2610000-0000-4000-8000-000000000001',
  1, 'Other owner report', 'A separate owner-level sequence.',
  'Interpretive styling guidance only.', 'report-v1', 'openai', 'approved-text-model'
);

insert into public.report_sections (
  owner_id, profile_id, report_id, section_type, position, content
)
select
  '22222222-2222-4222-8222-222222222222'::uuid,
  'b2600000-0000-4000-8000-000000000001'::uuid,
  'b2620000-0000-4000-8000-000000000001'::uuid,
  section_type,
  position,
  content
from report_test_content;

update public.report_runs
set status='succeeded', completed_at=now()
where id='b2610000-0000-4000-8000-000000000001';

select lives_ok(
  $$set constraints all immediate$$,
  'owner report versions advance independently and complete documents remain valid'
);
set constraints all deferred;

select results_eq(
  $$select version, derived_from_report_id from public.style_reports where owner_id='11111111-1111-4111-8111-111111111111' order by version$$,
  $$values (1, null::uuid), (2, 'a2620000-0000-4000-8000-000000000001'::uuid)$$,
  'owner report versions and prior-report lineage increase deterministically'
);

reset role;
select set_config('request.jwt.claim.sub', '11111111-1111-4111-8111-111111111111', true);
set local role authenticated;

select is(
  (select count(*) from public.style_reports),
  2::bigint,
  'owner A sees only their two immutable report versions'
);

select is(
  (select count(*) from public.report_sections),
  6::bigint,
  'owner A sees only their six typed report sections'
);

select throws_like(
  $$update public.style_reports set title='Customer edit'$$,
  '%permission denied for table style_reports%',
  'customers cannot edit report records directly'
);

reset role;
select set_config('request.jwt.claim.sub', '22222222-2222-4222-8222-222222222222', true);
set local role authenticated;

select results_eq(
  $$select id from public.style_reports order by id$$,
  array['b2620000-0000-4000-8000-000000000001'::uuid],
  'cross-owner report history is hidden by RLS'
);

select is(
  (select count(*) from public.report_sections),
  3::bigint,
  'cross-owner report sections are hidden by RLS'
);

reset role;

select * from finish();
rollback;
