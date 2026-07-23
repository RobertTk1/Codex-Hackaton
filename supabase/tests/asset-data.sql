begin;

create extension if not exists pgtap with schema extensions;
select no_plan();

select has_table('public', 'generated_assets', 'generated asset table exists');
select has_table('public', 'generated_asset_sources', 'generated asset source table exists');

select columns_are(
  'public',
  'generated_assets',
  array[
    'id', 'owner_id', 'profile_id', 'kind', 'status',
    'generation_consent_record_id', 'storage_path', 'media_type',
    'byte_size', 'width_px', 'height_px', 'sha256', 'provider_name',
    'provider_model', 'rejection_code', 'expires_at', 'created_at',
    'updated_at'
  ],
  'generated assets retain only normalized private-object metadata'
);

select columns_are(
  'public',
  'generated_asset_sources',
  array[
    'id', 'owner_id', 'profile_id', 'asset_id', 'source_photo_id',
    'source_garment_id', 'catalog_product_ref', 'catalog_shop_ref',
    'catalog_image_transmitted', 'created_at'
  ],
  'asset lineage retains exact source families and stable catalog refs only'
);

select is(
  (
    select count(*)
    from information_schema.columns
    where table_schema = 'public'
      and table_name in ('generated_assets', 'generated_asset_sources')
      and column_name in (
        'prompt', 'response', 'provider_payload', 'price', 'inventory',
        'retailer_url', 'catalog_image_url', 'email', 'customer_name'
      )
  ),
  0::bigint,
  'generated asset records exclude provider payloads and live product facts'
);

select has_index('public', 'generated_assets', 'generated_assets_owner_id_key', 'asset rows expose the same-owner key');
select has_index('public', 'generated_assets', 'generated_assets_owner_profile_id_key', 'asset rows expose the same-owner profile key');
select has_index('public', 'generated_assets', 'generated_assets_profile_kind_idx', 'profile asset reads are indexed');
select has_index('public', 'generated_assets', 'generated_assets_expiry_idx', 'accepted asset cleanup is indexed');
select has_index('public', 'generated_assets', 'generated_assets_consent_idx', 'likeness consent lineage is indexed');
select has_index('public', 'generated_asset_sources', 'generated_asset_sources_asset_idx', 'asset source traversal is indexed');
select has_index('public', 'generated_asset_sources', 'generated_asset_sources_owner_asset_idx', 'same-owner asset lineage is indexed');
select has_index('public', 'generated_asset_sources', 'generated_asset_sources_owner_photo_idx', 'same-owner photo lineage is indexed');
select has_index('public', 'generated_asset_sources', 'generated_asset_sources_owner_garment_idx', 'same-owner garment lineage is indexed');

select ok(
  exists (
    select 1
    from pg_constraint
    where conrelid = 'public.generated_assets'::regclass
      and conname = 'generated_assets_owner_profile_fk'
      and confrelid = 'public.profiles'::regclass
      and condeferrable
      and not condeferred
  ),
  'assets use one same-owner profile foreign key'
);

select ok(
  exists (
    select 1
    from pg_constraint
    where conrelid = 'public.generated_assets'::regclass
      and conname = 'generated_assets_owner_consent_fk'
      and confrelid = 'public.consent_records'::regclass
      and condeferrable
      and not condeferred
  ),
  'likeness consent uses a same-owner foreign key'
);

select ok(
  exists (
    select 1
    from pg_constraint
    where conrelid = 'public.generated_asset_sources'::regclass
      and conname = 'generated_asset_sources_owner_asset_fk'
      and confrelid = 'public.generated_assets'::regclass
      and condeferrable
      and not condeferred
  ),
  'source rows use the same-owner profile and asset key'
);

select is(
  (select relrowsecurity from pg_class where oid = 'public.generated_assets'::regclass),
  true,
  'generated assets have row-level security enabled'
);

select is(
  (select relrowsecurity from pg_class where oid = 'public.generated_asset_sources'::regclass),
  true,
  'generated asset sources have row-level security enabled'
);

select ok(
  not has_table_privilege('anon', 'public.generated_assets', 'SELECT')
  and not has_table_privilege('anon', 'public.generated_asset_sources', 'SELECT'),
  'bare anonymous requests cannot reach generated asset metadata'
);

select ok(
  has_table_privilege('authenticated', 'public.generated_assets', 'SELECT')
  and not has_table_privilege('authenticated', 'public.generated_assets', 'INSERT')
  and not has_table_privilege('authenticated', 'public.generated_assets', 'UPDATE')
  and not has_table_privilege('authenticated', 'public.generated_assets', 'DELETE')
  and has_table_privilege('authenticated', 'public.generated_asset_sources', 'SELECT')
  and not has_table_privilege('authenticated', 'public.generated_asset_sources', 'INSERT')
  and not has_table_privilege('authenticated', 'public.generated_asset_sources', 'UPDATE')
  and not has_table_privilege('authenticated', 'public.generated_asset_sources', 'DELETE'),
  'customers receive owner-scoped read-only asset metadata access'
);

select ok(
  has_table_privilege('service_role', 'public.generated_assets', 'SELECT')
  and has_table_privilege('service_role', 'public.generated_assets', 'INSERT')
  and has_table_privilege('service_role', 'public.generated_assets', 'UPDATE')
  and has_table_privilege('service_role', 'public.generated_assets', 'DELETE')
  and not has_table_privilege('service_role', 'public.generated_assets', 'TRUNCATE')
  and has_table_privilege('service_role', 'public.generated_asset_sources', 'SELECT')
  and has_table_privilege('service_role', 'public.generated_asset_sources', 'INSERT')
  and has_table_privilege('service_role', 'public.generated_asset_sources', 'UPDATE')
  and has_table_privilege('service_role', 'public.generated_asset_sources', 'DELETE')
  and not has_table_privilege('service_role', 'public.generated_asset_sources', 'TRUNCATE'),
  'service writes remain bounded DML without table-destructive authority'
);

select results_eq(
  $$select policyname from pg_policies where schemaname='public' and tablename='generated_assets' order by policyname$$,
  array['generated_assets_select_own_unexpired']::name[],
  'assets expose only one owner-and-expiry read policy'
);

select results_eq(
  $$select policyname from pg_policies where schemaname='public' and tablename='generated_asset_sources' order by policyname$$,
  array['generated_asset_sources_select_own_unexpired']::name[],
  'source lineage exposes only one live-parent owner policy'
);

select has_function(
  'private', 'enforce_generated_asset_contract', array[]::text[],
  'asset lifecycle and consent guard exists'
);
select has_function(
  'private', 'enforce_generated_asset_source_contract', array[]::text[],
  'source ownership and immutability guard exists'
);
select has_function(
  'private', 'enforce_generated_asset_source_completeness', array[]::text[],
  'deferred source and retention guard exists'
);

select ok(
  (
    select not prosecdef and coalesce('search_path=""' = any(proconfig), false)
    from pg_proc
    where oid = 'private.enforce_generated_asset_contract()'::regprocedure
  ) and (
    select not prosecdef and coalesce('search_path=""' = any(proconfig), false)
    from pg_proc
    where oid = 'private.enforce_generated_asset_source_contract()'::regprocedure
  ) and (
    select not prosecdef and coalesce('search_path=""' = any(proconfig), false)
    from pg_proc
    where oid = 'private.enforce_generated_asset_source_completeness()'::regprocedure
  ),
  'asset helpers are security invoker with empty search paths'
);

select ok(
  not has_function_privilege('authenticated', 'private.enforce_generated_asset_contract()'::regprocedure, 'EXECUTE')
  and not has_function_privilege('service_role', 'private.enforce_generated_asset_contract()'::regprocedure, 'EXECUTE')
  and not has_function_privilege('authenticated', 'private.enforce_generated_asset_source_contract()'::regprocedure, 'EXECUTE')
  and not has_function_privilege('service_role', 'private.enforce_generated_asset_source_completeness()'::regprocedure, 'EXECUTE'),
  'trigger helpers have no direct caller surface'
);

select has_trigger('public', 'generated_assets', 'generated_assets_enforce_contract', 'asset lifecycle is trigger-enforced');
select has_trigger('public', 'generated_assets', 'generated_assets_enforce_source_completeness', 'asset source completeness is deferred');
select has_trigger('public', 'generated_assets', 'generated_assets_set_updated_at', 'asset updates receive server timestamps');
select has_trigger('public', 'generated_asset_sources', 'generated_asset_sources_enforce_contract', 'asset source lineage is trigger-enforced');
select has_trigger('public', 'generated_asset_sources', 'generated_asset_sources_enforce_completeness', 'source changes recheck asset completeness');

insert into public.profiles (
  id, owner_id, status, current_step, revision, name, age,
  adult_confirmed_at, gender, height_cm, fit_preference, submitted_at
) values
  (
    'a2800000-0000-4000-8000-000000000001',
    '11111111-1111-4111-8111-111111111111',
    'draft', 'photos', 1, 'Asset owner', 34,
    now(), 'woman', 165, 'regular', null
  ),
  (
    'b2800000-0000-4000-8000-000000000001',
    '22222222-2222-4222-8222-222222222222',
    'draft', 'photos', 1, 'Other owner', 35,
    now(), 'woman', 168, 'regular', null
  );

insert into public.consent_records (
  id, owner_id, profile_id, purpose, decision, policy_version,
  copy_sha256, captured_at
) values
  (
    'a2810000-0000-4000-8000-000000000001',
    '11111111-1111-4111-8111-111111111111',
    'a2800000-0000-4000-8000-000000000001',
    'generated_likeness_preview', 'granted', 'likeness-v1',
    decode(repeat('11', 32), 'hex'), now() - interval '1 minute'
  ),
  (
    'a2810000-0000-4000-8000-000000000002',
    '11111111-1111-4111-8111-111111111111',
    'a2800000-0000-4000-8000-000000000001',
    'photo_analysis', 'granted', 'photo-v1',
    decode(repeat('22', 32), 'hex'), now() - interval '1 minute'
  ),
  (
    'b2810000-0000-4000-8000-000000000001',
    '22222222-2222-4222-8222-222222222222',
    'b2800000-0000-4000-8000-000000000001',
    'generated_likeness_preview', 'granted', 'likeness-v1',
    decode(repeat('33', 32), 'hex'), now() - interval '1 minute'
  );

insert into public.photos (
  id, owner_id, profile_id, storage_path, position, media_type,
  byte_size, width_px, height_px, sha256, expires_at
) values
  (
    'a2820000-0000-4000-8000-000000000001',
    '11111111-1111-4111-8111-111111111111',
    'a2800000-0000-4000-8000-000000000001',
    '11111111-1111-4111-8111-111111111111/a2800000-0000-4000-8000-000000000001/a2820000-0000-4000-8000-000000000001/original',
    1, 'image/jpeg', 1024, 1200, 1600,
    decode(repeat('44', 32), 'hex'), now() + interval '6 days'
  ),
  (
    'b2820000-0000-4000-8000-000000000001',
    '22222222-2222-4222-8222-222222222222',
    'b2800000-0000-4000-8000-000000000001',
    '22222222-2222-4222-8222-222222222222/b2800000-0000-4000-8000-000000000001/b2820000-0000-4000-8000-000000000001/original',
    1, 'image/jpeg', 1024, 1200, 1600,
    decode(repeat('55', 32), 'hex'), now() + interval '6 days'
  );

update public.photos
set status = 'accepted', accepted_at = now()
where id in (
  'a2820000-0000-4000-8000-000000000001',
  'b2820000-0000-4000-8000-000000000001'
);

update public.photos
set status = 'processing'
where id in (
  'a2820000-0000-4000-8000-000000000001',
  'b2820000-0000-4000-8000-000000000001'
);

insert into public.extracted_garments (
  id, owner_id, profile_id, source_photo_id, source_kind, category,
  colors, materials, patterns, silhouette, fit, confidence,
  review_status, provider_name, provider_model, expires_at
) values (
  'a2830000-0000-4000-8000-000000000001',
  '11111111-1111-4111-8111-111111111111',
  'a2800000-0000-4000-8000-000000000001',
  'a2820000-0000-4000-8000-000000000001',
  'wardrobe_extraction', 'dress', array['pink'], array['cotton'],
  array['solid'], 'column', 'regular', 0.900, 'confirmed',
  'wardrobe', 'approved-model', now() + interval '5 days'
);

set local role service_role;

insert into public.generated_assets (
  id, owner_id, profile_id, kind, provider_name, provider_model, expires_at
) values (
  'a2840000-0000-4000-8000-000000000001',
  '11111111-1111-4111-8111-111111111111',
  'a2800000-0000-4000-8000-000000000001',
  'garment_cutout', 'wardrobe', 'approved-model', now() + interval '4 days'
);

insert into public.generated_asset_sources (
  owner_id, profile_id, asset_id, source_photo_id
) values (
  '11111111-1111-4111-8111-111111111111',
  'a2800000-0000-4000-8000-000000000001',
  'a2840000-0000-4000-8000-000000000001',
  'a2820000-0000-4000-8000-000000000001'
);

insert into public.generated_asset_sources (
  owner_id, profile_id, asset_id, source_garment_id
) values (
  '11111111-1111-4111-8111-111111111111',
  'a2800000-0000-4000-8000-000000000001',
  'a2840000-0000-4000-8000-000000000001',
  'a2830000-0000-4000-8000-000000000001'
);

insert into public.generated_assets (
  id, owner_id, profile_id, kind, generation_consent_record_id,
  provider_name, provider_model, expires_at, created_at
) values (
  'a2840000-0000-4000-8000-000000000002',
  '11111111-1111-4111-8111-111111111111',
  'a2800000-0000-4000-8000-000000000001',
  'wardrobe_preview', 'a2810000-0000-4000-8000-000000000001',
  'openai', 'approved-image-model', now() + interval '4 days',
  now() - interval '2 days'
);

insert into public.generated_asset_sources (
  owner_id, profile_id, asset_id, source_photo_id
) values (
  '11111111-1111-4111-8111-111111111111',
  'a2800000-0000-4000-8000-000000000001',
  'a2840000-0000-4000-8000-000000000002',
  'a2820000-0000-4000-8000-000000000001'
);

insert into public.generated_asset_sources (
  owner_id, profile_id, asset_id, catalog_product_ref,
  catalog_shop_ref, catalog_image_transmitted
) values (
  '11111111-1111-4111-8111-111111111111',
  'a2800000-0000-4000-8000-000000000001',
  'a2840000-0000-4000-8000-000000000002',
  'gid://shopify/Product/100', 'gid://shopify/Shop/200', true
);

select lives_ok(
  $$set constraints all immediate$$,
  'cutout and likeness assets persist with direct photo lineage and source-bounded expiry'
);
set constraints all deferred;

select lives_ok(
  $$update public.generated_assets
    set status='accepted',
        storage_path='11111111-1111-4111-8111-111111111111/a2800000-0000-4000-8000-000000000001/a2840000-0000-4000-8000-000000000002/preview.webp',
        media_type='image/webp', byte_size=4096,
        width_px=1024, height_px=1536,
        sha256=decode(repeat('66', 32), 'hex')
    where id='a2840000-0000-4000-8000-000000000002'$$,
  'a generated preview becomes accepted only with complete object evidence'
);

select throws_like(
  $$insert into public.generated_assets (
      owner_id, profile_id, kind, generation_consent_record_id,
      provider_name, provider_model, expires_at
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2800000-0000-4000-8000-000000000001',
      'wardrobe_preview', 'a2810000-0000-4000-8000-000000000002',
      'openai', 'approved-image-model', now() + interval '1 day'
    )$$,
  '%likeness assets require exact owned granted generation consent%',
  'a non-likeness consent cannot authorize a preview'
);

select throws_like(
  $$insert into public.generated_assets (
      owner_id, profile_id, kind, generation_consent_record_id,
      provider_name, provider_model, expires_at
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2800000-0000-4000-8000-000000000001',
      'wardrobe_preview', 'b2810000-0000-4000-8000-000000000001',
      'openai', 'approved-image-model', now() + interval '1 day'
    )$$,
  '%likeness assets require exact owned granted generation consent%',
  'another owner consent cannot authorize a preview'
);

select throws_like(
  $$insert into public.generated_assets (
      owner_id, profile_id, kind, generation_consent_record_id,
      provider_name, provider_model, expires_at
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2800000-0000-4000-8000-000000000001',
      'wardrobe_preview', 'a2810000-0000-4000-8000-000000000001',
      'openai', 'approved-image-model', now() + interval '31 days'
    )$$,
  '%generated_assets_preview_expiry_check%',
  'likeness preview retention cannot exceed its 30-day class limit'
);

reset role;
insert into public.consent_records (
  owner_id, profile_id, purpose, decision, policy_version,
  copy_sha256, captured_at
) values (
  '11111111-1111-4111-8111-111111111111',
  'a2800000-0000-4000-8000-000000000001',
  'generated_likeness_preview', 'revoked', 'likeness-v1',
  decode(repeat('77', 32), 'hex'), now()
);
set local role service_role;

select throws_like(
  $$insert into public.generated_assets (
      owner_id, profile_id, kind, generation_consent_record_id,
      provider_name, provider_model, expires_at
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2800000-0000-4000-8000-000000000001',
      'tryon_still', 'a2810000-0000-4000-8000-000000000001',
      'decart', 'approved-model', now() + interval '1 day'
    )$$,
  '%likeness asset creation requires the current granted generation consent%',
  'revocation prevents new likeness asset creation with an older grant'
);

select throws_like(
  $$insert into public.generated_assets (
      id, owner_id, profile_id, kind, provider_name, provider_model, expires_at
    ) values (
      'a2840000-0000-4000-8000-000000000003',
      '11111111-1111-4111-8111-111111111111',
      'a2800000-0000-4000-8000-000000000001',
      'garment_cutout', 'wardrobe', 'approved-model', now() + interval '4 days'
    );
    insert into public.generated_asset_sources (
      owner_id, profile_id, asset_id, catalog_product_ref, catalog_shop_ref
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2800000-0000-4000-8000-000000000001',
      'a2840000-0000-4000-8000-000000000003',
      'gid://shopify/Product/101', 'gid://shopify/Shop/200'
    );
    set constraints all immediate$$,
  '%generated asset requires at least one direct customer-photo source%',
  'catalog-only lineage cannot satisfy the customer-photo source requirement'
);

select throws_like(
  $$insert into public.generated_assets (
      id, owner_id, profile_id, kind, provider_name, provider_model, expires_at
    ) values (
      'a2840000-0000-4000-8000-000000000004',
      '11111111-1111-4111-8111-111111111111',
      'a2800000-0000-4000-8000-000000000001',
      'garment_cutout', 'wardrobe', 'approved-model', now() + interval '6 days'
    );
    insert into public.generated_asset_sources (
      owner_id, profile_id, asset_id, source_photo_id
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2800000-0000-4000-8000-000000000001',
      'a2840000-0000-4000-8000-000000000004',
      'a2820000-0000-4000-8000-000000000001'
    );
    insert into public.generated_asset_sources (
      owner_id, profile_id, asset_id, source_garment_id
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2800000-0000-4000-8000-000000000001',
      'a2840000-0000-4000-8000-000000000004',
      'a2830000-0000-4000-8000-000000000001'
    );
    set constraints all immediate$$,
  '%generated asset expiry cannot outlive its customer source evidence%',
  'a derived asset cannot outlive its shortest source deadline'
);

select throws_like(
  $$update public.generated_assets
    set status='accepted'
    where id='a2840000-0000-4000-8000-000000000001'$$,
  '%generated_assets_state_check%',
  'accepted assets require complete object metadata'
);

select lives_ok(
  $$update public.generated_assets
    set status='rejected', rejection_code='QUALITY_REJECTED'
    where id='a2840000-0000-4000-8000-000000000001'$$,
  'rejected assets persist a safe reason without customer-readable object metadata'
);

select is(
  (
    select count(*)
    from public.generated_assets
    where id='a2840000-0000-4000-8000-000000000001'
      and status='rejected'
      and storage_path is null
      and media_type is null
      and byte_size is null
      and sha256 is null
      and rejection_code='QUALITY_REJECTED'
  ),
  1::bigint,
  'rejected asset state has no readable object evidence'
);

select throws_like(
  $$update public.generated_assets
    set status='processing', rejection_code=null
    where id='a2840000-0000-4000-8000-000000000001'$$,
  '%terminal generated asset evidence is immutable%',
  'terminal generated asset state cannot reopen'
);

select throws_like(
  $$update public.generated_asset_sources
    set catalog_image_transmitted=false
    where asset_id='a2840000-0000-4000-8000-000000000002'
      and catalog_product_ref is not null$$,
  '%generated asset source evidence is immutable%',
  'asset source evidence cannot be rewritten'
);

reset role;
select set_config('request.jwt.claim.sub', '11111111-1111-4111-8111-111111111111', true);
set local role authenticated;

select is(
  (select count(*) from public.generated_assets),
  2::bigint,
  'owner sees both current generated asset records'
);

select is(
  (select count(*) from public.generated_asset_sources),
  4::bigint,
  'owner sees all source rows for their current generated assets'
);

select throws_like(
  $$update public.generated_assets set expires_at=now() where id='a2840000-0000-4000-8000-000000000002'$$,
  '%permission denied for table generated_assets%',
  'customers cannot mutate asset metadata directly'
);

reset role;
select set_config('request.jwt.claim.sub', '22222222-2222-4222-8222-222222222222', true);
set local role authenticated;

select is((select count(*) from public.generated_assets), 0::bigint, 'another owner sees no generated assets');
select is((select count(*) from public.generated_asset_sources), 0::bigint, 'another owner sees no source lineage');

reset role;
set local role service_role;

select lives_ok(
  $$update public.generated_assets
    set expires_at=created_at + interval '1 day'
    where id='a2840000-0000-4000-8000-000000000002'$$,
  'retention may shorten an accepted preview deadline without rewriting evidence'
);

reset role;
select set_config('request.jwt.claim.sub', '11111111-1111-4111-8111-111111111111', true);
set local role authenticated;

select is(
  (select count(*) from public.generated_assets where id='a2840000-0000-4000-8000-000000000002'),
  0::bigint,
  'expired generated asset metadata fails closed immediately'
);

select is(
  (select count(*) from public.generated_asset_sources where asset_id='a2840000-0000-4000-8000-000000000002'),
  0::bigint,
  'expired asset source lineage fails closed with its parent'
);

reset role;

select * from finish();
rollback;
