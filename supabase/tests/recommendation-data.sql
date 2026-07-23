begin;

create extension if not exists pgtap with schema extensions;
select no_plan();

-- Given one immutable report and stable Shopify references,
-- when recommendations are persisted,
-- then their rationale and report-local outfit order remain deterministic
-- without copying live retailer facts.

select has_table('public', 'recommendations', 'recommendation table exists');

select columns_are(
  'public',
  'recommendations',
  array[
    'id', 'owner_id', 'profile_id', 'report_id', 'position', 'category',
    'title', 'rationale', 'styling_note', 'catalog_product_ref',
    'catalog_shop_ref', 'catalog_variant_ref', 'preview_asset_id',
    'outfit_group_key', 'outfit_group_title', 'outfit_item_position',
    'created_at'
  ],
  'recommendations retain only normalized guidance and stable catalog references'
);

select is(
  (
    select count(*)
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'recommendations'
      and column_name in (
        'product_title', 'seller_name', 'price', 'inventory',
        'retailer_url', 'image_url', 'catalog_payload', 'provider_payload'
      )
  ),
  0::bigint,
  'live retailer facts and provider payloads cannot be persisted'
);

select has_index(
  'public', 'recommendations', 'recommendations_report_position_idx',
  'report recommendation order is unique'
);
select has_index(
  'public', 'recommendations', 'recommendations_outfit_position_idx',
  'outfit item order is unique within one report-local group'
);
select has_index(
  'public', 'recommendations', 'recommendations_owner_report_idx',
  'same-owner report lineage and owner reads are indexed'
);
select has_index(
  'public', 'recommendations', 'recommendations_preview_asset_idx',
  'preview retention cleanup is indexed'
);

select ok(
  exists (
    select 1
    from pg_constraint
    where conrelid = 'public.recommendations'::regclass
      and conname = 'recommendations_owner_profile_report_fk'
      and confrelid = 'public.style_reports'::regclass
      and condeferrable
      and not condeferred
  ),
  'recommendations use one immediate same-owner report foreign key'
);

select is(
  (select relrowsecurity from pg_class where oid = 'public.recommendations'::regclass),
  true,
  'recommendations have row-level security enabled'
);

select ok(
  not has_table_privilege('anon', 'public.recommendations', 'SELECT'),
  'bare anonymous requests cannot reach recommendation data'
);

select ok(
  has_table_privilege('authenticated', 'public.recommendations', 'SELECT')
  and not has_table_privilege('authenticated', 'public.recommendations', 'INSERT')
  and not has_table_privilege('authenticated', 'public.recommendations', 'UPDATE')
  and not has_table_privilege('authenticated', 'public.recommendations', 'DELETE'),
  'customers receive permanent-account owner reads only'
);

select ok(
  has_table_privilege('service_role', 'public.recommendations', 'SELECT')
  and has_table_privilege('service_role', 'public.recommendations', 'INSERT')
  and has_table_privilege('service_role', 'public.recommendations', 'UPDATE')
  and has_table_privilege('service_role', 'public.recommendations', 'DELETE')
  and not has_table_privilege('service_role', 'public.recommendations', 'TRUNCATE'),
  'service writes remain bounded DML without table-destructive authority'
);

select results_eq(
  $$select policyname from pg_policies where schemaname='public' and tablename='recommendations' order by policyname$$,
  array['recommendations_select_own_permanent']::name[],
  'recommendations expose one owner-and-permanent-account policy'
);

select has_function(
  'private', 'enforce_recommendation_contract', array[]::text[],
  'recommendation immutability and preview guard exists'
);

select ok(
  (
    select not prosecdef and coalesce('search_path=""' = any(proconfig), false)
    from pg_proc
    where oid = 'private.enforce_recommendation_contract()'::regprocedure
  ),
  'recommendation guard is security invoker with an empty search path'
);

select ok(
  not has_function_privilege(
    'authenticated', 'private.enforce_recommendation_contract()'::regprocedure, 'EXECUTE'
  ) and not has_function_privilege(
    'service_role', 'private.enforce_recommendation_contract()'::regprocedure, 'EXECUTE'
  ),
  'recommendation guard has no direct caller surface'
);

select has_trigger(
  'public', 'recommendations', 'recommendations_enforce_contract',
  'recommendation insertion and one-time preview attachment are trigger-enforced'
);

select has_table(
  'private', 'recommendation_preview_attachments',
  'one-time preview attachment survives generated-asset retention cleanup'
);

select ok(
  has_table_privilege(
    'service_role', 'private.recommendation_preview_attachments', 'SELECT'
  ) and has_table_privilege(
    'service_role', 'private.recommendation_preview_attachments', 'INSERT'
  ) and not has_table_privilege(
    'service_role', 'private.recommendation_preview_attachments', 'UPDATE'
  ) and not has_table_privilege(
    'service_role', 'private.recommendation_preview_attachments', 'DELETE'
  ),
  'preview tombstones are append-only to the service writer'
);

create temporary table recommendation_report_content (
  section_type text primary key,
  position smallint not null,
  content jsonb not null
) on commit drop;

insert into recommendation_report_content (section_type, position, content) values
  (
    'overview', 1,
    '{
      "style_identity":"Polished contrast",
      "summary":"Strong structure and vivid color create a confident through-line.",
      "strengths":[{"label":"Color confidence","explanation":"Saturated color supports the visible style signals."}],
      "priorities":[{"label":"Repeat structure","explanation":"Use defined silhouettes to simplify outfit decisions."}]
    }'::jsonb
  ),
  (
    'color', 2,
    '{
      "palette_name":"Electric warmth",
      "summary":"Warm brights and deep anchors create useful contrast.",
      "best_colors":[
        {"name":"Hot pink","hex":"#FF2D8D","reason":"Echoes an established favorite."},
        {"name":"Tangerine","hex":"#FF6A21","reason":"Adds vivid warmth."},
        {"name":"Inky navy","hex":"#10152F","reason":"Creates a deep neutral anchor."},
        {"name":"Cream","hex":"#FFF3D7","reason":"Softens bright combinations."}
      ],
      "approach_with_care":[]
    }'::jsonb
  ),
  (
    'body_style', 3,
    '{
      "kibbe_informed_family":"Balanced definition",
      "summary":"Defined waists and intentional vertical lines support the observed proportions.",
      "shape_guidance":[{"label":"Defined waist","explanation":"Try pieces that acknowledge the waist without restricting movement."}],
      "proportion_guidance":[{"label":"Long line","explanation":"Repeat a color or shape vertically to create continuity."}],
      "disclosure":"This is interpretive styling guidance, not an objective, medical, or value judgment."
    }'::jsonb
  );

grant select on table recommendation_report_content to service_role;

insert into public.profiles (
  id, owner_id, status, current_step, revision, name, age,
  adult_confirmed_at, gender, height_cm, fit_preference
) values
  (
    'a2700000-0000-4000-8000-000000000001',
    '11111111-1111-4111-8111-111111111111',
    'draft', 'photos', 1, 'Recommendation owner', 34,
    now(), 'woman', 165, 'regular'
  ),
  (
    'b2700000-0000-4000-8000-000000000001',
    '22222222-2222-4222-8222-222222222222',
    'draft', 'photos', 1, 'Other asset owner', 35,
    now(), 'woman', 168, 'regular'
  );

insert into public.consent_records (
  id, owner_id, profile_id, purpose, decision, policy_version,
  copy_sha256, captured_at
) values
  (
    'a2710000-0000-4000-8000-000000000001',
    '11111111-1111-4111-8111-111111111111',
    'a2700000-0000-4000-8000-000000000001',
    'generated_likeness_preview', 'granted', 'likeness-v1',
    decode(repeat('11', 32), 'hex'), now() - interval '1 minute'
  ),
  (
    'b2710000-0000-4000-8000-000000000001',
    '22222222-2222-4222-8222-222222222222',
    'b2700000-0000-4000-8000-000000000001',
    'generated_likeness_preview', 'granted', 'likeness-v1',
    decode(repeat('22', 32), 'hex'), now() - interval '1 minute'
  );

insert into public.photos (
  id, owner_id, profile_id, storage_path, position, media_type,
  byte_size, width_px, height_px, sha256, expires_at
) values
  (
    'a2720000-0000-4000-8000-000000000001',
    '11111111-1111-4111-8111-111111111111',
    'a2700000-0000-4000-8000-000000000001',
    '11111111-1111-4111-8111-111111111111/a2700000-0000-4000-8000-000000000001/a2720000-0000-4000-8000-000000000001/original',
    1, 'image/jpeg', 1024, 1200, 1600,
    decode(repeat('33', 32), 'hex'), now() + interval '6 days'
  ),
  (
    'b2720000-0000-4000-8000-000000000001',
    '22222222-2222-4222-8222-222222222222',
    'b2700000-0000-4000-8000-000000000001',
    '22222222-2222-4222-8222-222222222222/b2700000-0000-4000-8000-000000000001/b2720000-0000-4000-8000-000000000001/original',
    1, 'image/jpeg', 1024, 1200, 1600,
    decode(repeat('44', 32), 'hex'), now() + interval '6 days'
  );

update public.photos
set status = 'accepted', accepted_at = now();

set local role service_role;

insert into public.generated_assets (
  id, owner_id, profile_id, kind, generation_consent_record_id,
  provider_name, provider_model, expires_at
) values
  (
    'a2730000-0000-4000-8000-000000000001',
    '11111111-1111-4111-8111-111111111111',
    'a2700000-0000-4000-8000-000000000001',
    'wardrobe_preview', 'a2710000-0000-4000-8000-000000000001',
    'openai', 'approved-image-model', now() + interval '4 days'
  ),
  (
    'a2730000-0000-4000-8000-000000000002',
    '11111111-1111-4111-8111-111111111111',
    'a2700000-0000-4000-8000-000000000001',
    'wardrobe_preview', 'a2710000-0000-4000-8000-000000000001',
    'openai', 'approved-image-model', now() + interval '4 days'
  ),
  (
    'b2730000-0000-4000-8000-000000000001',
    '22222222-2222-4222-8222-222222222222',
    'b2700000-0000-4000-8000-000000000001',
    'wardrobe_preview', 'b2710000-0000-4000-8000-000000000001',
    'openai', 'approved-image-model', now() + interval '4 days'
  );

insert into public.generated_asset_sources (
  owner_id, profile_id, asset_id, source_photo_id
) values
  (
    '11111111-1111-4111-8111-111111111111',
    'a2700000-0000-4000-8000-000000000001',
    'a2730000-0000-4000-8000-000000000001',
    'a2720000-0000-4000-8000-000000000001'
  ),
  (
    '11111111-1111-4111-8111-111111111111',
    'a2700000-0000-4000-8000-000000000001',
    'a2730000-0000-4000-8000-000000000002',
    'a2720000-0000-4000-8000-000000000001'
  ),
  (
    '22222222-2222-4222-8222-222222222222',
    'b2700000-0000-4000-8000-000000000001',
    'b2730000-0000-4000-8000-000000000001',
    'b2720000-0000-4000-8000-000000000001'
  );

insert into public.generated_asset_sources (
  owner_id, profile_id, asset_id, catalog_product_ref, catalog_shop_ref
) values
  (
    '11111111-1111-4111-8111-111111111111',
    'a2700000-0000-4000-8000-000000000001',
    'a2730000-0000-4000-8000-000000000001',
    'gid://shopify/Product/100', 'gid://shopify/Shop/200'
  ),
  (
    '11111111-1111-4111-8111-111111111111',
    'a2700000-0000-4000-8000-000000000001',
    'a2730000-0000-4000-8000-000000000002',
    'gid://shopify/Product/100', 'gid://shopify/Shop/200'
  ),
  (
    '22222222-2222-4222-8222-222222222222',
    'b2700000-0000-4000-8000-000000000001',
    'b2730000-0000-4000-8000-000000000001',
    'gid://shopify/Product/100', 'gid://shopify/Shop/200'
  );

select lives_ok(
  $$set constraints all immediate$$,
  'preview fixtures retain direct customer-photo lineage'
);
set constraints all deferred;

update public.generated_assets
set
  status = 'accepted',
  storage_path = owner_id::text || '/' || profile_id::text || '/' || id::text || '/preview.webp',
  media_type = 'image/webp',
  byte_size = 4096,
  width_px = 1024,
  height_px = 1536,
  sha256 = decode(
    case id
      when 'a2730000-0000-4000-8000-000000000001'::uuid then repeat('55', 32)
      when 'a2730000-0000-4000-8000-000000000002'::uuid then repeat('66', 32)
      else repeat('77', 32)
    end,
    'hex'
  );

reset role;

update public.profiles
set
  status = 'submitted',
  current_step = 'complete',
  revision = 2,
  submitted_at = now()
where id = 'a2700000-0000-4000-8000-000000000001';

insert into public.report_runs (
  id, owner_id, profile_id, profile_revision, idempotency_key
) values (
  'a2740000-0000-4000-8000-000000000001',
  '11111111-1111-4111-8111-111111111111',
  'a2700000-0000-4000-8000-000000000001',
  2,
  'report:a2700000-0000-4000-8000-000000000001:2:1:recommendations'
);

update public.report_runs
set
  status = 'processing',
  stage = 'finalizing',
  attempt_count = 1,
  started_at = now();

set local role service_role;

insert into public.style_reports (
  id, owner_id, profile_id, report_run_id, version, title, summary,
  confidence_note, method_version, provider_name, provider_model
) values (
  'a2750000-0000-4000-8000-000000000001',
  '11111111-1111-4111-8111-111111111111',
  'a2700000-0000-4000-8000-000000000001',
  'a2740000-0000-4000-8000-000000000001',
  1, 'Your style report', 'A report with current-product recommendations.',
  'Interpretive styling guidance only.', 'report-v1',
  'openai', 'approved-text-model'
);

insert into public.report_sections (
  owner_id, profile_id, report_id, section_type, position, content
)
select
  '11111111-1111-4111-8111-111111111111'::uuid,
  'a2700000-0000-4000-8000-000000000001'::uuid,
  'a2750000-0000-4000-8000-000000000001'::uuid,
  section_type, position, content
from recommendation_report_content;

update public.report_runs
set status = 'succeeded', completed_at = now()
where id = 'a2740000-0000-4000-8000-000000000001';

select lives_ok(
  $$set constraints all immediate$$,
  'recommendation report fixture publishes as an immutable complete document'
);
set constraints all deferred;

insert into public.recommendations (
  id, owner_id, profile_id, report_id, position, category, title,
  rationale, styling_note, catalog_product_ref, catalog_shop_ref,
  catalog_variant_ref, outfit_group_key, outfit_group_title,
  outfit_item_position
) values
  (
    'a2760000-0000-4000-8000-000000000001',
    '11111111-1111-4111-8111-111111111111',
    'a2700000-0000-4000-8000-000000000001',
    'a2750000-0000-4000-8000-000000000001',
    1, 'top', 'A sharp color anchor',
    'The saturated color repeats a strong signal from the favorite looks.',
    'Wear it with a clean high-waisted line.',
    'gid://shopify/Product/100', 'gid://shopify/Shop/200',
    'gid://shopify/ProductVariant/300', 'electric-evening',
    'Electric evening', 1
  ),
  (
    'a2760000-0000-4000-8000-000000000002',
    '11111111-1111-4111-8111-111111111111',
    'a2700000-0000-4000-8000-000000000001',
    'a2750000-0000-4000-8000-000000000001',
    2, 'bottom', 'A long tailored line',
    'The shape adds continuity while preserving the customer''s preferred definition.',
    'Keep the hem long enough to maintain the line.',
    'gid://shopify/Product/101', 'gid://shopify/Shop/201',
    null, 'electric-evening', 'Electric evening', 2
  ),
  (
    'a2760000-0000-4000-8000-000000000003',
    '11111111-1111-4111-8111-111111111111',
    'a2700000-0000-4000-8000-000000000001',
    'a2750000-0000-4000-8000-000000000001',
    3, 'dress', 'One-step vivid structure',
    'A defined silhouette and saturated color combine two established preferences.',
    'Let the dress lead and keep accessories restrained.',
    'gid://shopify/Product/102', 'gid://shopify/Shop/202',
    null, null, null, null
  );

select results_eq(
  $$
    select outfit_group_key, outfit_item_position, title
    from public.recommendations
    where report_id = 'a2750000-0000-4000-8000-000000000001'
      and outfit_group_key is not null
    order by outfit_group_key, outfit_item_position
  $$,
  $$values
    ('electric-evening'::text, 1::smallint, 'A sharp color anchor'::text),
    ('electric-evening'::text, 2::smallint, 'A long tailored line'::text)
  $$,
  'report-local outfit composition has deterministic item order'
);

select throws_like(
  $$
    insert into public.recommendations (
      owner_id, profile_id, report_id, position, category, title,
      rationale, styling_note, catalog_product_ref, catalog_shop_ref,
      outfit_group_key, outfit_group_title
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2700000-0000-4000-8000-000000000001',
      'a2750000-0000-4000-8000-000000000001',
      4, 'shoe', 'Incomplete group', 'A bounded rationale.',
      'A bounded styling note.', 'Product/103', 'Shop/203',
      'electric-evening', 'Electric evening'
    )
  $$,
  '%recommendations_outfit_shape_check%',
  'partial outfit grouping cannot be persisted'
);

select throws_like(
  $$
    insert into public.recommendations (
      owner_id, profile_id, report_id, position, category, title,
      rationale, styling_note, catalog_product_ref, catalog_shop_ref,
      outfit_group_key, outfit_group_title, outfit_item_position
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2700000-0000-4000-8000-000000000001',
      'a2750000-0000-4000-8000-000000000001',
      4, 'shoe', 'Conflicting group label', 'A bounded rationale.',
      'A bounded styling note.', 'Product/103', 'Shop/203',
      'electric-evening', 'A different outfit title', 3
    )
  $$,
  'one outfit group key must use one customer-facing title',
  'one report-local outfit key cannot acquire conflicting customer labels'
);

select throws_like(
  $$
    insert into public.recommendations (
      owner_id, profile_id, report_id, position, category, title,
      rationale, styling_note, catalog_product_ref, catalog_shop_ref,
      preview_asset_id
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2700000-0000-4000-8000-000000000001',
      'a2750000-0000-4000-8000-000000000001',
      4, 'shoe', 'Premature preview', 'A bounded rationale.',
      'A bounded styling note.', 'Product/103', 'Shop/203',
      'a2730000-0000-4000-8000-000000000001'
    )
  $$,
  'recommendation preview must attach after publication',
  'preview evidence cannot bypass the one-time attachment transition'
);

select throws_like(
  $$
    update public.recommendations
    set preview_asset_id = 'b2730000-0000-4000-8000-000000000001'
    where id = 'a2760000-0000-4000-8000-000000000001'
  $$,
  'recommendation preview must be an owned accepted wardrobe preview',
  'another customer preview cannot attach to the recommendation'
);

select lives_ok(
  $$
    update public.recommendations
    set preview_asset_id = 'a2730000-0000-4000-8000-000000000001'
    where id = 'a2760000-0000-4000-8000-000000000001'
  $$,
  'one owned accepted wardrobe preview attaches from null'
);

select throws_like(
  $$
    update public.recommendations
    set preview_asset_id = 'a2730000-0000-4000-8000-000000000002'
    where id = 'a2760000-0000-4000-8000-000000000001'
  $$,
  'recommendations are immutable except for one preview attachment',
  'an attached preview cannot be replaced'
);

select throws_like(
  $$
    update public.recommendations
    set rationale = 'A silently changed rationale.'
    where id = 'a2760000-0000-4000-8000-000000000001'
  $$,
  'recommendations are immutable except for one preview attachment',
  'published recommendation guidance cannot be silently revised'
);

select lives_ok(
  $$delete from public.generated_assets where id = 'a2730000-0000-4000-8000-000000000001'$$,
  'preview retention clears its recommendation pointer without changing guidance'
);

select is(
  (
    select preview_asset_id
    from public.recommendations
    where id = 'a2760000-0000-4000-8000-000000000001'
  ),
  null::uuid,
  'deleted preview leaves the recommendation in its text-and-link fallback state'
);

select throws_like(
  $$
    update public.recommendations
    set preview_asset_id = 'a2730000-0000-4000-8000-000000000002'
    where id = 'a2760000-0000-4000-8000-000000000001'
  $$,
  'recommendation preview has already been attached',
  'retention cleanup cannot reopen the one-time preview transition'
);

-- Given an owned accepted wardrobe preview,
-- when the server attaches it to a recommendation,
-- then that one null-to-asset transition succeeds and every later mutation fails.

reset role;
select set_config(
  'request.jwt.claims',
  '{"sub":"11111111-1111-4111-8111-111111111111","is_anonymous":false}',
  true
);
set local role authenticated;

select is(
  (select count(*) from public.recommendations),
  3::bigint,
  'the permanent owner can read every recommendation in the report'
);

select throws_like(
  $$
    update public.recommendations
    set preview_asset_id = null
    where id = 'a2760000-0000-4000-8000-000000000002'
  $$,
  '%permission denied for table recommendations%',
  'customer recommendation writes fail closed before RLS evaluation'
);

reset role;
select set_config(
  'request.jwt.claims',
  '{"sub":"11111111-1111-4111-8111-111111111111","is_anonymous":true}',
  true
);
set local role authenticated;

select is(
  (select count(*) from public.recommendations),
  0::bigint,
  'a still-anonymous identity cannot read permanent report recommendations'
);

reset role;
select set_config(
  'request.jwt.claims',
  '{"sub":"22222222-2222-4222-8222-222222222222","is_anonymous":false}',
  true
);
set local role authenticated;

select is(
  (select count(*) from public.recommendations),
  0::bigint,
  'another permanent account cannot infer recommendation rows'
);

select * from finish();
rollback;
