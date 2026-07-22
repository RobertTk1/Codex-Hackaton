begin;

create extension if not exists pgtap with schema extensions;
select no_plan();

select has_table('public', 'photo_style_signals', 'photo style signal table exists');
select has_table('public', 'extracted_garments', 'extracted garment table exists');

select columns_are(
  'public',
  'photo_style_signals',
  array[
    'id',
    'owner_id',
    'profile_id',
    'photo_id',
    'dominant_colors',
    'categories',
    'silhouettes',
    'aesthetic_tags',
    'confidence',
    'provider_name',
    'provider_model',
    'expires_at',
    'created_at'
  ],
  'photo signals retain only bounded normalized analysis evidence'
);

select columns_are(
  'public',
  'extracted_garments',
  array[
    'id',
    'owner_id',
    'profile_id',
    'source_photo_id',
    'source_kind',
    'category',
    'colors',
    'materials',
    'patterns',
    'silhouette',
    'fit',
    'confidence',
    'duplicate_group_id',
    'review_status',
    'provider_name',
    'provider_model',
    'expires_at',
    'created_at',
    'updated_at'
  ],
  'garments retain only bounded normalized per-item evidence and review state'
);

select is(
  (
    select count(*)
    from information_schema.columns
    where table_schema = 'public'
      and table_name in ('photo_style_signals', 'extracted_garments')
      and data_type in ('json', 'jsonb')
  ),
  0::bigint,
  'extraction evidence tables have no provider-payload column'
);

select ok(
  exists (
    select 1
    from pg_constraint as constraint_record
    where constraint_record.conrelid = 'public.photo_style_signals'::regclass
      and constraint_record.conname = 'photo_style_signals_owner_profile_fk'
      and constraint_record.confrelid = 'public.profiles'::regclass
      and constraint_record.condeferrable
      and not constraint_record.condeferred
      and constraint_record.confupdtype = 'c'
      and constraint_record.confdeltype = 'c'
  ),
  'photo signal ownership cascades through the same-owner profile key'
);

select ok(
  exists (
    select 1
    from pg_constraint as constraint_record
    where constraint_record.conrelid = 'public.photo_style_signals'::regclass
      and constraint_record.conname = 'photo_style_signals_owner_photo_fk'
      and constraint_record.confrelid = 'public.photos'::regclass
      and constraint_record.condeferrable
      and not constraint_record.condeferred
      and constraint_record.confupdtype = 'c'
      and constraint_record.confdeltype = 'c'
  ),
  'photo signal ownership cascades through the same-owner source-photo key'
);

select ok(
  exists (
    select 1
    from pg_constraint as constraint_record
    where constraint_record.conrelid = 'public.extracted_garments'::regclass
      and constraint_record.conname = 'extracted_garments_owner_profile_fk'
      and constraint_record.confrelid = 'public.profiles'::regclass
      and constraint_record.condeferrable
      and not constraint_record.condeferred
      and constraint_record.confupdtype = 'c'
      and constraint_record.confdeltype = 'c'
  ),
  'garment ownership cascades through the same-owner profile key'
);

select ok(
  exists (
    select 1
    from pg_constraint as constraint_record
    where constraint_record.conrelid = 'public.extracted_garments'::regclass
      and constraint_record.conname = 'extracted_garments_owner_photo_fk'
      and constraint_record.confrelid = 'public.photos'::regclass
      and constraint_record.condeferrable
      and not constraint_record.condeferred
      and constraint_record.confupdtype = 'c'
      and constraint_record.confdeltype = 'c'
  ),
  'garment ownership cascades through the same-owner source-photo key'
);

select has_index('public', 'photo_style_signals', 'photo_style_signals_owner_id_key', 'photo signals expose the same-owner composite key');
select has_index('public', 'photo_style_signals', 'photo_style_signals_photo_idx', 'one direct signal record is allowed per photo');
select has_index('public', 'photo_style_signals', 'photo_style_signals_owner_profile_idx', 'photo signal owner/profile lineage is indexed');
select has_index('public', 'photo_style_signals', 'photo_style_signals_expiry_idx', 'photo signal cleanup leads with expiry');
select has_index('public', 'extracted_garments', 'extracted_garments_owner_id_key', 'garments expose the same-owner composite key');
select has_index('public', 'extracted_garments', 'extracted_garments_owner_profile_idx', 'garment owner/profile lineage is indexed');
select has_index('public', 'extracted_garments', 'extracted_garments_photo_idx', 'per-photo extraction and review reads are indexed');
select has_index('public', 'extracted_garments', 'extracted_garments_profile_idx', 'profile candidate seeding is indexed');
select has_index('public', 'extracted_garments', 'extracted_garments_expiry_idx', 'garment cleanup leads with expiry');

select is(
  (select relation.relrowsecurity from pg_class as relation where relation.oid = 'public.photo_style_signals'::regclass),
  true,
  'photo style signals have row-level security enabled'
);

select is(
  (select relation.relrowsecurity from pg_class as relation where relation.oid = 'public.extracted_garments'::regclass),
  true,
  'extracted garments have row-level security enabled'
);

select ok(
  not has_table_privilege('anon', 'public.photo_style_signals', 'SELECT')
  and not has_table_privilege('anon', 'public.photo_style_signals', 'INSERT')
  and not has_table_privilege('anon', 'public.extracted_garments', 'SELECT')
  and not has_table_privilege('anon', 'public.extracted_garments', 'INSERT'),
  'bare anonymous requests have no extraction evidence privileges'
);

select ok(
  has_table_privilege('authenticated', 'public.photo_style_signals', 'SELECT')
  and not has_table_privilege('authenticated', 'public.photo_style_signals', 'INSERT')
  and not has_table_privilege('authenticated', 'public.photo_style_signals', 'UPDATE')
  and not has_table_privilege('authenticated', 'public.photo_style_signals', 'DELETE')
  and has_table_privilege('authenticated', 'public.extracted_garments', 'SELECT')
  and not has_table_privilege('authenticated', 'public.extracted_garments', 'INSERT')
  and not has_table_privilege('authenticated', 'public.extracted_garments', 'UPDATE')
  and not has_table_privilege('authenticated', 'public.extracted_garments', 'DELETE'),
  'authenticated customers receive read-only extraction evidence access'
);

select ok(
  has_table_privilege('service_role', 'public.photo_style_signals', 'SELECT')
  and has_table_privilege('service_role', 'public.photo_style_signals', 'INSERT')
  and has_table_privilege('service_role', 'public.photo_style_signals', 'UPDATE')
  and has_table_privilege('service_role', 'public.photo_style_signals', 'DELETE')
  and not has_table_privilege('service_role', 'public.photo_style_signals', 'TRUNCATE')
  and has_table_privilege('service_role', 'public.extracted_garments', 'SELECT')
  and has_table_privilege('service_role', 'public.extracted_garments', 'INSERT')
  and has_table_privilege('service_role', 'public.extracted_garments', 'UPDATE')
  and has_table_privilege('service_role', 'public.extracted_garments', 'DELETE')
  and not has_table_privilege('service_role', 'public.extracted_garments', 'TRUNCATE'),
  'service role receives bounded extraction DML without table-destructive authority'
);

select results_eq(
  $$
    select policyname
    from pg_policies
    where schemaname = 'public' and tablename = 'photo_style_signals'
    order by policyname
  $$,
  array['photo_style_signals_select_own_unexpired']::name[],
  'photo signals expose only owner-scoped unexpired reads'
);

select results_eq(
  $$
    select policyname
    from pg_policies
    where schemaname = 'public' and tablename = 'extracted_garments'
    order by policyname
  $$,
  array['extracted_garments_select_own_unexpired']::name[],
  'garments expose only owner-scoped unexpired reads'
);

select has_function('private', 'extraction_text_array_is_valid', array['text[]', 'integer', 'integer'], 'bounded extraction-array validator exists');
select has_function('private', 'enforce_photo_style_signal_contract', array[]::text[], 'photo signal contract trigger helper exists');
select has_function('private', 'enforce_extracted_garment_contract', array[]::text[], 'garment contract trigger helper exists');

select ok(
  (
    select not procedure.prosecdef
      and coalesce('search_path=""' = any(procedure.proconfig), false)
    from pg_proc as procedure
    where procedure.oid = 'private.enforce_photo_style_signal_contract()'::regprocedure
  )
  and (
    select not procedure.prosecdef
      and coalesce('search_path=""' = any(procedure.proconfig), false)
    from pg_proc as procedure
    where procedure.oid = 'private.enforce_extracted_garment_contract()'::regprocedure
  ),
  'extraction contract helpers are security invoker with empty search paths'
);

select ok(
  not has_function_privilege('authenticated', 'private.extraction_text_array_is_valid(text[], integer, integer)'::regprocedure, 'EXECUTE')
  and not has_function_privilege('anon', 'private.extraction_text_array_is_valid(text[], integer, integer)'::regprocedure, 'EXECUTE')
  and has_function_privilege('service_role', 'private.extraction_text_array_is_valid(text[], integer, integer)'::regprocedure, 'EXECUTE'),
  'only the writing service role can directly execute the array validator'
);

select has_trigger('public', 'photo_style_signals', 'photo_style_signals_enforce_contract', 'photo signals are guarded by their contract trigger');
select has_trigger('public', 'extracted_garments', 'extracted_garments_enforce_contract', 'garments are guarded by their contract trigger');
select has_trigger('public', 'extracted_garments', 'extracted_garments_set_updated_at', 'garment review changes maintain their timestamp');

insert into public.profiles (id, owner_id, current_step)
values
  ('a2200000-0000-4000-8000-000000000001', '11111111-1111-4111-8111-111111111111', 'photos'),
  ('a2200000-0000-4000-8000-000000000002', '11111111-1111-4111-8111-111111111111', 'photos'),
  ('b2200000-0000-4000-8000-000000000001', '22222222-2222-4222-8222-222222222222', 'photos');

insert into public.photos (
  id, owner_id, profile_id, storage_path, position, media_type,
  byte_size, width_px, height_px, sha256, expires_at, created_at
) values
  (
    'a2210000-0000-4000-8000-000000000001',
    '11111111-1111-4111-8111-111111111111',
    'a2200000-0000-4000-8000-000000000001',
    'customer-photos/a/partial/original.jpg', 1, 'image/jpeg',
    1200, 1200, 1800, decode(repeat('21', 32), 'hex'),
    now() + interval '6 days', now() - interval '1 day'
  ),
  (
    'a2210000-0000-4000-8000-000000000002',
    '11111111-1111-4111-8111-111111111111',
    'a2200000-0000-4000-8000-000000000001',
    'customer-photos/a/failed/original.jpg', 2, 'image/jpeg',
    1200, 1200, 1800, decode(repeat('22', 32), 'hex'),
    now() + interval '6 days', now() - interval '1 day'
  ),
  (
    'a2210000-0000-4000-8000-000000000003',
    '11111111-1111-4111-8111-111111111111',
    'a2200000-0000-4000-8000-000000000001',
    'customer-photos/a/bounded/original.jpg', 3, 'image/jpeg',
    1200, 1200, 1800, decode(repeat('23', 32), 'hex'),
    now() + interval '6 days', now() - interval '1 day'
  ),
  (
    'a2210000-0000-4000-8000-000000000004',
    '11111111-1111-4111-8111-111111111111',
    'a2200000-0000-4000-8000-000000000002',
    'customer-photos/a/other-profile/original.jpg', 1, 'image/jpeg',
    1200, 1200, 1800, decode(repeat('24', 32), 'hex'),
    now() + interval '6 days', now() - interval '1 day'
  ),
  (
    'b2210000-0000-4000-8000-000000000001',
    '22222222-2222-4222-8222-222222222222',
    'b2200000-0000-4000-8000-000000000001',
    'customer-photos/b/complete/original.jpg', 1, 'image/jpeg',
    1200, 1200, 1800, decode(repeat('25', 32), 'hex'),
    now() + interval '6 days', now() - interval '1 day'
  );

update public.photos
set status = 'accepted', accepted_at = now()
where id in (
  'a2210000-0000-4000-8000-000000000001',
  'a2210000-0000-4000-8000-000000000002',
  'a2210000-0000-4000-8000-000000000003',
  'a2210000-0000-4000-8000-000000000004',
  'b2210000-0000-4000-8000-000000000001'
);

update public.photos
set status = 'processing'
where id in (
  'a2210000-0000-4000-8000-000000000001',
  'a2210000-0000-4000-8000-000000000002',
  'a2210000-0000-4000-8000-000000000003',
  'a2210000-0000-4000-8000-000000000004',
  'b2210000-0000-4000-8000-000000000001'
);

insert into public.photo_style_signals (
  id, owner_id, profile_id, photo_id, dominant_colors, categories,
  silhouettes, aesthetic_tags, confidence, provider_name, provider_model,
  expires_at
) values (
  'a2220000-0000-4000-8000-000000000001',
  '11111111-1111-4111-8111-111111111111',
  'a2200000-0000-4000-8000-000000000001',
  'a2210000-0000-4000-8000-000000000001',
  array['coral', 'cream'], array['dress'], array['column'], array['editorial'],
  0.870, 'openai', 'style-signal-v1', now() + interval '5 days'
);

insert into public.extracted_garments (
  id, owner_id, profile_id, source_photo_id, source_kind, category,
  colors, materials, patterns, silhouette, fit, confidence,
  duplicate_group_id, review_status, provider_name, provider_model, expires_at
) values (
  'a2230000-0000-4000-8000-000000000001',
  '11111111-1111-4111-8111-111111111111',
  'a2200000-0000-4000-8000-000000000001',
  'a2210000-0000-4000-8000-000000000001',
  'wardrobe_extraction', 'dress', array['coral'], array['silk'], array['solid'],
  'column', 'fitted', 0.910, null, 'pending', 'wardrobe', 'wardrobe-v1',
  now() + interval '5 days'
);

update public.photos
set status = 'partial', rejection_code = 'GARMENT_SIBLING_FAILED'
where id = 'a2210000-0000-4000-8000-000000000001';

update public.photos
set status = 'failed', rejection_code = 'WARDROBE_EXTRACTION_FAILED'
where id = 'a2210000-0000-4000-8000-000000000002';

insert into public.photo_style_signals (
  id, owner_id, profile_id, photo_id, dominant_colors, categories,
  silhouettes, aesthetic_tags, confidence, provider_name, provider_model,
  expires_at, created_at
) values (
  'a2220000-0000-4000-8000-000000000002',
  '11111111-1111-4111-8111-111111111111',
  'a2200000-0000-4000-8000-000000000001',
  'a2210000-0000-4000-8000-000000000002',
  array['black'], array['outerwear'], array['structured'], array['classic'],
  0.640, 'openai', 'style-signal-v1', now() + interval '5 days',
  now() - interval '1 day'
);

select is(
  (select count(*) from public.extracted_garments where source_photo_id = 'a2210000-0000-4000-8000-000000000001'),
  1::bigint,
  'a successful garment persists when a sibling extraction leaves its source photo partial'
);

select is(
  (
    select status || ':' || rejection_code
    from public.photos
    where id = 'a2210000-0000-4000-8000-000000000001'
  ),
  'partial:GARMENT_SIBLING_FAILED'::text,
  'partial failure remains explicit on the source photo beside successful normalized garments'
);

select is(
  (
    select count(*)
    from public.photo_style_signals as signal
    join public.photos as photo on photo.id = signal.photo_id
    where photo.status = 'failed'
  ),
  1::bigint,
  'direct photo signals preserve a bounded fallback when wardrobe extraction fails'
);

select throws_like(
  $$
    insert into public.photo_style_signals (raw_provider_payload)
    values ('{}'::jsonb)
  $$,
  '%column "raw_provider_payload" of relation "photo_style_signals" does not exist%',
  'raw provider payloads cannot be written to photo signal evidence'
);

select throws_ok(
  $$
    insert into public.photo_style_signals (
      owner_id, profile_id, photo_id, confidence, provider_name, provider_model, expires_at
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2200000-0000-4000-8000-000000000001',
      'a2210000-0000-4000-8000-000000000003',
      0.8, 'openai', 'style-signal-v1', now() + interval '6 days 1 second'
    )
  $$,
  '23514',
  'photo style signal deadline cannot exceed its source photo',
  'photo signal expiry cannot exceed source expiry'
);

select throws_ok(
  $$
    insert into public.extracted_garments (
      owner_id, profile_id, source_photo_id, source_kind, category,
      confidence, provider_name, provider_model, expires_at
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2200000-0000-4000-8000-000000000001',
      'a2210000-0000-4000-8000-000000000003',
      'wardrobe_extraction', 'top', 0.8, 'wardrobe', 'wardrobe-v1',
      now() + interval '6 days 1 second'
    )
  $$,
  '23514',
  'extracted garment deadline cannot exceed its source photo',
  'garment expiry cannot exceed source expiry'
);

select throws_ok(
  $$
    insert into public.photo_style_signals (
      owner_id, profile_id, photo_id, confidence, provider_name, provider_model, expires_at
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2200000-0000-4000-8000-000000000002',
      'a2210000-0000-4000-8000-000000000003',
      0.8, 'openai', 'style-signal-v1', now() + interval '5 days'
    )
  $$,
  '23514',
  'photo style signal must match one owned source photo and profile',
  'same-owner rows still require exact photo/profile lineage'
);

select throws_like(
  $$
    insert into public.photo_style_signals (
      owner_id, profile_id, photo_id, dominant_colors,
      confidence, provider_name, provider_model, expires_at
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2200000-0000-4000-8000-000000000001',
      'a2210000-0000-4000-8000-000000000003',
      array['  emerald  '], 0.8, 'openai', 'style-signal-v1', now() + interval '5 days'
    )
  $$,
  '%photo_style_signals_array_entries_check%',
  'photo signal labels must be trimmed and nonblank'
);

select throws_like(
  $$
    insert into public.photo_style_signals (
      owner_id, profile_id, photo_id, categories,
      confidence, provider_name, provider_model, expires_at
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2200000-0000-4000-8000-000000000001',
      'a2210000-0000-4000-8000-000000000003',
      array_fill('category'::text, array[9]), 0.8,
      'openai', 'style-signal-v1', now() + interval '5 days'
    )
  $$,
  '%photo_style_signals_array_entries_check%',
  'photo signal arrays enforce their item ceiling'
);

select throws_like(
  $$
    insert into public.extracted_garments (
      owner_id, profile_id, source_photo_id, source_kind, category, colors,
      confidence, provider_name, provider_model, expires_at
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2200000-0000-4000-8000-000000000001',
      'a2210000-0000-4000-8000-000000000003',
      'wardrobe_extraction', 'top', array[''], 0.8,
      'wardrobe', 'wardrobe-v1', now() + interval '5 days'
    )
  $$,
  '%extracted_garments_array_entries_check%',
  'garment arrays reject blank normalized labels'
);

select throws_like(
  $$
    insert into public.extracted_garments (
      owner_id, profile_id, source_photo_id, source_kind, category,
      confidence, provider_name, provider_model, expires_at
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2200000-0000-4000-8000-000000000001',
      'a2210000-0000-4000-8000-000000000003',
      'wardrobe_extraction', 'top', 1.001,
      'wardrobe', 'wardrobe-v1', now() + interval '5 days'
    )
  $$,
  '%extracted_garments_confidence_check%',
  'garment confidence stays within zero and one'
);

insert into public.extracted_garments (
  owner_id, profile_id, source_photo_id, source_kind, category,
  confidence, review_status, provider_name, provider_model, expires_at
)
select
  '11111111-1111-4111-8111-111111111111',
  'a2200000-0000-4000-8000-000000000001',
  'a2210000-0000-4000-8000-000000000003',
  'wardrobe_extraction',
  'item-' || item_number,
  0.800,
  'not_required',
  'wardrobe',
  'wardrobe-v1',
  now() + interval '5 days'
from generate_series(1, 20) as item_number;

select throws_ok(
  $$
    insert into public.extracted_garments (
      owner_id, profile_id, source_photo_id, source_kind, category,
      confidence, provider_name, provider_model, expires_at
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2200000-0000-4000-8000-000000000001',
      'a2210000-0000-4000-8000-000000000003',
      'wardrobe_extraction', 'twenty-first-item', 0.8,
      'wardrobe', 'wardrobe-v1', now() + interval '5 days'
    )
  $$,
  '23514',
  'a source photo can retain at most twenty extracted garments',
  'a photo cannot retain an unbounded number of garment rows'
);

update public.extracted_garments
set review_status = 'confirmed'
where id = 'a2230000-0000-4000-8000-000000000001';

select is(
  (select review_status from public.extracted_garments where id = 'a2230000-0000-4000-8000-000000000001'),
  'confirmed'::text,
  'a pending garment may record one confirmed customer review'
);

select throws_ok(
  $$
    update public.extracted_garments
    set review_status = 'rejected'
    where id = 'a2230000-0000-4000-8000-000000000001'
  $$,
  '23514',
  'invalid extracted garment review transition',
  'terminal garment review evidence cannot be rewritten'
);

select throws_ok(
  $$
    update public.extracted_garments
    set category = 'rewritten-provider-output'
    where id = 'a2230000-0000-4000-8000-000000000001'
  $$,
  '23514',
  'extracted garment analysis evidence is immutable',
  'normalized garment analysis cannot be silently rewritten'
);

select throws_ok(
  $$
    update public.extracted_garments
    set expires_at = expires_at + interval '1 hour'
    where id = 'a2230000-0000-4000-8000-000000000001'
  $$,
  '23514',
  'extracted garment deadline cannot be extended directly',
  'derived garment retention can only be shortened'
);

insert into public.photo_style_signals (
  id, owner_id, profile_id, photo_id, dominant_colors, categories,
  confidence, provider_name, provider_model, expires_at
) values (
  'b2220000-0000-4000-8000-000000000001',
  '22222222-2222-4222-8222-222222222222',
  'b2200000-0000-4000-8000-000000000001',
  'b2210000-0000-4000-8000-000000000001',
  array['navy'], array['trousers'], 0.8, 'openai', 'style-signal-v1',
  now() + interval '5 days'
);

insert into public.extracted_garments (
  id, owner_id, profile_id, source_photo_id, source_kind, category,
  confidence, provider_name, provider_model, expires_at
) values (
  'b2230000-0000-4000-8000-000000000001',
  '22222222-2222-4222-8222-222222222222',
  'b2200000-0000-4000-8000-000000000001',
  'b2210000-0000-4000-8000-000000000001',
  'wardrobe_extraction', 'trousers', 0.8, 'wardrobe', 'wardrobe-v1',
  now() + interval '5 days'
);

update public.photo_style_signals
set expires_at = now() - interval '1 hour'
where id = 'a2220000-0000-4000-8000-000000000002';

set local role authenticated;
set local request.jwt.claim.sub = '11111111-1111-4111-8111-111111111111';

select is((select count(*) from public.photo_style_signals), 1::bigint, 'owner A sees only its unexpired direct signal');
select is((select count(*) from public.extracted_garments), 21::bigint, 'owner A sees only its own unexpired garment rows');
select is(
  (
    (select count(*) from public.photo_style_signals where owner_id = '22222222-2222-4222-8222-222222222222')
    + (select count(*) from public.extracted_garments where owner_id = '22222222-2222-4222-8222-222222222222')
  ),
  0::bigint,
  'owner A reads no owner B extraction evidence'
);

select throws_like(
  $$
    insert into public.photo_style_signals (
      owner_id, profile_id, photo_id, confidence, provider_name, provider_model, expires_at
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2200000-0000-4000-8000-000000000001',
      'a2210000-0000-4000-8000-000000000003',
      0.8, 'openai', 'style-signal-v1', now() + interval '5 days'
    )
  $$,
  '%permission denied for table photo_style_signals%',
  'customers cannot directly write extraction evidence'
);

reset role;

insert into auth.users (id, email, is_anonymous)
values
  ('c2200000-0000-4000-8000-000000000001', null, true),
  ('d2200000-0000-4000-8000-000000000001', 'target-extraction@magic-mirror.test', false);

insert into public.profiles (id, owner_id, current_step)
values (
  'c2210000-0000-4000-8000-000000000001',
  'c2200000-0000-4000-8000-000000000001',
  'photos'
);

insert into public.photos (
  id, owner_id, profile_id, storage_path, position, media_type,
  byte_size, width_px, height_px, sha256, expires_at
) values (
  'c2220000-0000-4000-8000-000000000001',
  'c2200000-0000-4000-8000-000000000001',
  'c2210000-0000-4000-8000-000000000001',
  'customer-photos/c/transfer/original.jpg', 1, 'image/jpeg',
  1200, 1200, 1800, decode(repeat('26', 32), 'hex'), now() + interval '6 days'
);

update public.photos
set status = 'accepted', accepted_at = now()
where id = 'c2220000-0000-4000-8000-000000000001';

update public.photos
set status = 'processing'
where id = 'c2220000-0000-4000-8000-000000000001';

insert into public.photo_style_signals (
  id, owner_id, profile_id, photo_id, confidence, provider_name, provider_model, expires_at
) values (
  'c2230000-0000-4000-8000-000000000001',
  'c2200000-0000-4000-8000-000000000001',
  'c2210000-0000-4000-8000-000000000001',
  'c2220000-0000-4000-8000-000000000001',
  0.8, 'openai', 'style-signal-v1', now() + interval '5 days'
);

insert into public.extracted_garments (
  id, owner_id, profile_id, source_photo_id, source_kind, category,
  confidence, provider_name, provider_model, expires_at
) values (
  'c2240000-0000-4000-8000-000000000001',
  'c2200000-0000-4000-8000-000000000001',
  'c2210000-0000-4000-8000-000000000001',
  'c2220000-0000-4000-8000-000000000001',
  'wardrobe_extraction', 'dress', 0.8, 'wardrobe', 'wardrobe-v1',
  now() + interval '5 days'
);

insert into private.anonymous_transfers (
  source_owner_id,
  source_profile_id,
  source_profile_revision,
  token_sha256,
  expires_at
) values (
  'c2200000-0000-4000-8000-000000000001',
  'c2210000-0000-4000-8000-000000000001',
  1,
  decode(repeat('27', 32), 'hex'),
  now() + interval '10 minutes'
);

select lives_ok(
  $$
    select *
    from private.consume_anonymous_transfer(
      decode(repeat('27', 32), 'hex'),
      'd2200000-0000-4000-8000-000000000001'
    )
  $$,
  'anonymous transfer moves a populated extraction graph without renaming its evidence'
);

select is(
  (
    (select count(*) from public.photos where owner_id = 'd2200000-0000-4000-8000-000000000001' and id = 'c2220000-0000-4000-8000-000000000001')
    + (select count(*) from public.photo_style_signals where owner_id = 'd2200000-0000-4000-8000-000000000001' and id = 'c2230000-0000-4000-8000-000000000001')
    + (select count(*) from public.extracted_garments where owner_id = 'd2200000-0000-4000-8000-000000000001' and id = 'c2240000-0000-4000-8000-000000000001')
  ),
  3::bigint,
  'photo, direct signal, and garment ownership cascade together to the permanent account'
);

set local role authenticated;
set local request.jwt.claim.sub = 'c2200000-0000-4000-8000-000000000001';

select is(
  (select count(*) from public.photo_style_signals where id = 'c2230000-0000-4000-8000-000000000001')
  + (select count(*) from public.extracted_garments where id = 'c2240000-0000-4000-8000-000000000001'),
  0::bigint,
  'source anonymous identity loses all transferred extraction evidence reads'
);

set local request.jwt.claim.sub = 'd2200000-0000-4000-8000-000000000001';

select is(
  (select count(*) from public.photo_style_signals where id = 'c2230000-0000-4000-8000-000000000001')
  + (select count(*) from public.extracted_garments where id = 'c2240000-0000-4000-8000-000000000001'),
  2::bigint,
  'target permanent identity can read both transferred extraction records'
);

reset role;

select * from finish();
rollback;
