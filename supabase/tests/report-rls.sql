begin;

create extension if not exists pgtap with schema extensions;
select no_plan();

select is(
  (
    select count(*)
    from pg_class
    where oid in (
      'public.report_runs'::regclass,
      'public.style_reports'::regclass,
      'public.report_sections'::regclass,
      'public.recommendations'::regclass,
      'public.generated_assets'::regclass,
      'public.generated_asset_sources'::regclass
    )
      and relrowsecurity
  ),
  6::bigint,
  'the complete report and generated-asset graph has row-level security enabled'
);

select ok(
  not has_table_privilege('anon', 'public.report_runs', 'SELECT')
  and not has_table_privilege('anon', 'public.style_reports', 'SELECT')
  and not has_table_privilege('anon', 'public.report_sections', 'SELECT')
  and not has_table_privilege('anon', 'public.recommendations', 'SELECT')
  and not has_table_privilege('anon', 'public.generated_assets', 'SELECT')
  and not has_table_privilege('anon', 'public.generated_asset_sources', 'SELECT'),
  'the bare anonymous role has no report or generated-asset metadata privileges'
);

select ok(
  has_table_privilege('authenticated', 'public.report_runs', 'SELECT')
  and has_table_privilege('authenticated', 'public.style_reports', 'SELECT')
  and has_table_privilege('authenticated', 'public.report_sections', 'SELECT')
  and has_table_privilege('authenticated', 'public.recommendations', 'SELECT')
  and has_table_privilege('authenticated', 'public.generated_assets', 'SELECT')
  and has_table_privilege('authenticated', 'public.generated_asset_sources', 'SELECT')
  and not has_table_privilege('authenticated', 'public.report_runs', 'INSERT')
  and not has_table_privilege('authenticated', 'public.style_reports', 'UPDATE')
  and not has_table_privilege('authenticated', 'public.report_sections', 'DELETE')
  and not has_table_privilege('authenticated', 'public.recommendations', 'INSERT')
  and not has_table_privilege('authenticated', 'public.generated_assets', 'UPDATE')
  and not has_table_privilege('authenticated', 'public.generated_asset_sources', 'DELETE'),
  'customers receive read-only metadata grants and no report or asset write authority'
);

select is(
  (
    select count(*)
    from pg_policies
    where schemaname = 'public'
      and (
        (tablename = 'report_runs' and policyname = 'report_runs_select_own')
        or (tablename = 'style_reports' and policyname = 'style_reports_select_own')
        or (tablename = 'report_sections' and policyname = 'report_sections_select_own')
        or (tablename = 'recommendations' and policyname = 'recommendations_select_own_permanent')
        or (tablename = 'generated_assets' and policyname = 'generated_assets_select_own_unexpired')
        or (tablename = 'generated_asset_sources' and policyname = 'generated_asset_sources_select_own_unexpired')
      )
  ),
  6::bigint,
  'each graph table exposes exactly its named owner-read policy'
);

select is(
  (
    select count(*)
    from pg_policies
    where schemaname = 'public'
      and tablename in ('report_runs', 'style_reports', 'report_sections', 'recommendations')
      and position('is_anonymous' in qual) > 0
      and position('auth.uid' in qual) > 0
  ),
  4::bigint,
  'every permanent report policy checks both the immutable subject and anonymous-account state'
);

select is(
  (
    select count(*)
    from pg_policies
    where schemaname = 'public'
      and tablename in ('generated_assets', 'generated_asset_sources')
      and position('transaction_timestamp' in qual) > 0
      and position('auth.uid' in qual) > 0
  ),
  2::bigint,
  'both generated-asset policies combine current ownership with logical expiry'
);

create temporary table report_rls_payload (
  sections jsonb not null,
  recommendations jsonb not null
) on commit drop;

insert into report_rls_payload (sections, recommendations) values (
  '[
    {
      "section_type":"overview",
      "position":1,
      "content":{
        "style_identity":"Polished contrast",
        "summary":"Strong structure and vivid color create a confident through-line.",
        "strengths":[{"label":"Color confidence","explanation":"Saturated color supports the visible style signals."}],
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
      "rationale":"A defined waist and uninterrupted color line reflect the strongest report signals.",
      "styling_note":"Keep accessories graphic and minimal.",
      "catalog_product_ref":"gid://shopify/Product/eng030-1",
      "catalog_shop_ref":"gid://shopify/Shop/eng030",
      "catalog_variant_ref":"gid://shopify/ProductVariant/eng030-1",
      "outfit_group_key":null,
      "outfit_group_title":null,
      "outfit_item_position":null
    }
  ]'::jsonb
);

grant select on table report_rls_payload to service_role;

insert into public.profiles (
  id, owner_id, status, current_step, revision, name, age,
  adult_confirmed_at, gender, height_cm, fit_preference, submitted_at
) values
  (
    'a3000000-0000-4000-8000-000000000001',
    '11111111-1111-4111-8111-111111111111',
    'submitted', 'complete', 1, 'RLS report owner', 34,
    now(), 'woman', 165, 'regular', now()
  ),
  (
    'a3000000-0000-4000-8000-000000000002',
    '11111111-1111-4111-8111-111111111111',
    'draft', 'photos', 1, null, null,
    null, null, null, null, null
  );

insert into public.report_runs (
  id, owner_id, profile_id, profile_revision, idempotency_key
) values (
  'a3010000-0000-4000-8000-000000000001',
  '11111111-1111-4111-8111-111111111111',
  'a3000000-0000-4000-8000-000000000001',
  1,
  'report-rls:a3010000-0000-4000-8000-000000000001'
);

update public.report_runs
set status = 'processing', stage = 'finalizing', attempt_count = 1, started_at = now();

set local role service_role;

select lives_ok(
  $$
    select *
    from private.publish_style_report(
      'a3010000-0000-4000-8000-000000000001',
      'Your style report',
      'A confident point of view grounded in your favorite looks.',
      'These findings are interpretive styling guidance, not objective measurements.',
      'report-v1',
      'openai',
      'approved-text-model',
      (select sections from report_rls_payload),
      (select recommendations from report_rls_payload)
    )
  $$,
  'one complete report graph publishes before customer policy evaluation'
);

insert into public.photos (
  id, owner_id, profile_id, storage_path, position, media_type,
  byte_size, width_px, height_px, sha256, expires_at
) values (
  'a3020000-0000-4000-8000-000000000001',
  '11111111-1111-4111-8111-111111111111',
  'a3000000-0000-4000-8000-000000000002',
  '11111111-1111-4111-8111-111111111111/eng030/source.jpg',
  1, 'image/jpeg', 2048, 1200, 1600,
  decode(repeat('30', 32), 'hex'),
  transaction_timestamp() + interval '2 days'
);

insert into public.generated_assets (
  id, owner_id, profile_id, kind, provider_name, provider_model,
  expires_at, created_at
) values
  (
    'a3030000-0000-4000-8000-000000000001',
    '11111111-1111-4111-8111-111111111111',
    'a3000000-0000-4000-8000-000000000002',
    'garment_cutout', 'fixture', 'fixture-v1',
    transaction_timestamp() + interval '1 day',
    transaction_timestamp()
  ),
  (
    'a3030000-0000-4000-8000-000000000002',
    '11111111-1111-4111-8111-111111111111',
    'a3000000-0000-4000-8000-000000000002',
    'garment_cutout', 'fixture', 'fixture-v1',
    transaction_timestamp() + interval '1 day',
    transaction_timestamp() - interval '2 days'
  );

insert into public.generated_asset_sources (
  owner_id, profile_id, asset_id, source_photo_id
) values
  (
    '11111111-1111-4111-8111-111111111111',
    'a3000000-0000-4000-8000-000000000002',
    'a3030000-0000-4000-8000-000000000001',
    'a3020000-0000-4000-8000-000000000001'
  ),
  (
    '11111111-1111-4111-8111-111111111111',
    'a3000000-0000-4000-8000-000000000002',
    'a3030000-0000-4000-8000-000000000002',
    'a3020000-0000-4000-8000-000000000001'
  );

select lives_ok(
  $$set constraints all immediate$$,
  'generated assets retain complete direct-photo lineage'
);
set constraints all deferred;

update public.generated_assets
set expires_at = created_at + interval '1 day'
where id = 'a3030000-0000-4000-8000-000000000002';

reset role;
select set_config(
  'request.jwt.claims',
  '{"sub":"11111111-1111-4111-8111-111111111111","is_anonymous":false}',
  true
);
set local role authenticated;

select results_eq(
  $$
    select
      (select count(*) from public.report_runs),
      (select count(*) from public.style_reports),
      (select count(*) from public.report_sections),
      (select count(*) from public.recommendations),
      (select count(*) from public.generated_assets),
      (select count(*) from public.generated_asset_sources)
  $$,
  $$values (1::bigint, 1::bigint, 3::bigint, 1::bigint, 1::bigint, 1::bigint)$$,
  'the permanent owner reads their published report graph and only unexpired asset lineage'
);

select is(
  (
    select count(*)
    from public.generated_assets
    where id = 'a3030000-0000-4000-8000-000000000002'
  ),
  0::bigint,
  'an expired generated asset fails closed before physical cleanup'
);

select is(
  (
    select count(*)
    from public.generated_asset_sources
    where asset_id = 'a3030000-0000-4000-8000-000000000002'
  ),
  0::bigint,
  'expired generated-asset lineage fails closed with its parent'
);

reset role;
select set_config(
  'request.jwt.claims',
  '{"sub":"11111111-1111-4111-8111-111111111111","is_anonymous":true}',
  true
);
set local role authenticated;

select results_eq(
  $$
    select
      (select count(*) from public.report_runs),
      (select count(*) from public.style_reports),
      (select count(*) from public.report_sections),
      (select count(*) from public.recommendations),
      (select count(*) from public.generated_assets),
      (select count(*) from public.generated_asset_sources)
  $$,
  $$values (0::bigint, 0::bigint, 0::bigint, 0::bigint, 1::bigint, 1::bigint)$$,
  'a still-anonymous owner cannot read permanent reports but can read current onboarding assets'
);

reset role;
select set_config(
  'request.jwt.claims',
  '{"sub":"22222222-2222-4222-8222-222222222222","is_anonymous":false}',
  true
);
set local role authenticated;

select results_eq(
  $$
    select
      (select count(*) from public.report_runs),
      (select count(*) from public.style_reports),
      (select count(*) from public.report_sections),
      (select count(*) from public.recommendations),
      (select count(*) from public.generated_assets),
      (select count(*) from public.generated_asset_sources)
  $$,
  $$values (0::bigint, 0::bigint, 0::bigint, 0::bigint, 0::bigint, 0::bigint)$$,
  'another permanent account reads no report or generated-asset metadata'
);

reset role;

select * from finish();
rollback;
