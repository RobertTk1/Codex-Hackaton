begin;

create extension if not exists pgtap with schema extensions;
select no_plan();

select has_table('public', 'taste_candidates', 'taste candidate table exists');
select has_table('public', 'taste_reactions', 'taste reaction table exists');

select columns_are(
  'public',
  'taste_candidates',
  array[
    'id', 'owner_id', 'profile_id', 'source', 'extracted_garment_id',
    'source_fingerprint', 'catalog_product_ref', 'catalog_variant_ref',
    'catalog_shop_ref', 'curated_asset_key', 'category', 'color_family',
    'silhouette', 'representation_tags', 'position', 'status',
    'created_at', 'updated_at'
  ],
  'candidates retain only bounded descriptors and stable source references'
);

select columns_are(
  'public',
  'taste_reactions',
  array[
    'id', 'owner_id', 'profile_id', 'candidate_id', 'reaction',
    'undone_at', 'created_at', 'updated_at'
  ],
  'reactions retain one bounded choice and explicit undo state'
);

select is(
  (
    select count(*)
    from information_schema.columns
    where table_schema = 'public'
      and table_name in ('taste_candidates', 'taste_reactions')
      and data_type in ('json', 'jsonb')
  ),
  0::bigint,
  'taste evidence has no provider or catalog payload column'
);

select ok(
  exists (
    select 1 from pg_constraint
    where conrelid = 'public.taste_candidates'::regclass
      and conname = 'taste_candidates_owner_profile_fk'
      and confrelid = 'public.profiles'::regclass
      and condeferrable and not condeferred
      and confupdtype = 'c' and confdeltype = 'c'
  ),
  'candidate ownership cascades through a deferrable profile key'
);

select ok(
  exists (
    select 1 from pg_constraint
    where conrelid = 'public.taste_candidates'::regclass
      and conname = 'taste_candidates_extracted_garment_fk'
      and confrelid = 'public.extracted_garments'::regclass
      and condeferrable and not condeferred
      and confdeltype = 'n'
  ),
  'candidate source lineage survives garment expiry through set-null'
);

select ok(
  exists (
    select 1 from pg_constraint
    where conrelid = 'public.taste_reactions'::regclass
      and conname = 'taste_reactions_owner_profile_fk'
      and confrelid = 'public.profiles'::regclass
      and condeferrable and not condeferred
      and confupdtype = 'c' and confdeltype = 'c'
  ),
  'reaction ownership cascades through a deferrable profile key'
);

select ok(
  exists (
    select 1 from pg_constraint
    where conrelid = 'public.taste_reactions'::regclass
      and conname = 'taste_reactions_owner_profile_candidate_fk'
      and confrelid = 'public.taste_candidates'::regclass
      and condeferrable and not condeferred
      and confupdtype = 'c' and confdeltype = 'c'
  ),
  'reaction lineage requires the exact owned profile candidate'
);

select has_index('public', 'taste_candidates', 'taste_candidates_owner_id_key', 'candidates expose the same-owner key');
select has_index('public', 'taste_candidates', 'taste_candidates_owner_profile_id_key', 'candidate profile lineage is indexed');
select has_index('public', 'taste_candidates', 'taste_candidates_profile_position_idx', 'candidate order is unique per profile');
select has_index('public', 'taste_candidates', 'taste_candidates_profile_fingerprint_idx', 'extracted source fingerprints deduplicate per profile');
select has_index('public', 'taste_candidates', 'taste_candidates_extracted_garment_id_idx', 'garment lineage nulling is indexed');
select has_index('public', 'taste_reactions', 'taste_reactions_owner_id_key', 'reactions expose the same-owner key');
select has_index('public', 'taste_reactions', 'taste_reactions_candidate_idx', 'one reaction row is allowed per candidate');
select has_index('public', 'taste_reactions', 'taste_reactions_profile_active_idx', 'active reaction progress is indexed');
select has_index('public', 'taste_reactions', 'taste_reactions_owner_profile_candidate_idx', 'reaction owner/profile/candidate lineage is indexed');

select is(
  (select relrowsecurity from pg_class where oid = 'public.taste_candidates'::regclass),
  true,
  'taste candidates have row-level security enabled'
);

select is(
  (select relrowsecurity from pg_class where oid = 'public.taste_reactions'::regclass),
  true,
  'taste reactions have row-level security enabled'
);

select ok(
  not has_table_privilege('anon', 'public.taste_candidates', 'SELECT')
  and not has_table_privilege('anon', 'public.taste_reactions', 'SELECT')
  and not has_table_privilege('anon', 'public.taste_reactions', 'INSERT'),
  'bare anonymous requests have no taste evidence privileges'
);

select ok(
  has_table_privilege('authenticated', 'public.taste_candidates', 'SELECT')
  and not has_table_privilege('authenticated', 'public.taste_candidates', 'INSERT')
  and not has_table_privilege('authenticated', 'public.taste_candidates', 'UPDATE')
  and not has_table_privilege('authenticated', 'public.taste_candidates', 'DELETE')
  and has_table_privilege('authenticated', 'public.taste_reactions', 'SELECT')
  and has_table_privilege('authenticated', 'public.taste_reactions', 'INSERT')
  and has_table_privilege('authenticated', 'public.taste_reactions', 'UPDATE')
  and not has_table_privilege('authenticated', 'public.taste_reactions', 'DELETE'),
  'customers receive read-only candidates and bounded reaction mutation'
);

select ok(
  has_table_privilege('service_role', 'public.taste_candidates', 'SELECT')
  and has_table_privilege('service_role', 'public.taste_candidates', 'INSERT')
  and has_table_privilege('service_role', 'public.taste_candidates', 'UPDATE')
  and has_table_privilege('service_role', 'public.taste_candidates', 'DELETE')
  and not has_table_privilege('service_role', 'public.taste_candidates', 'TRUNCATE')
  and has_table_privilege('service_role', 'public.taste_reactions', 'SELECT')
  and has_table_privilege('service_role', 'public.taste_reactions', 'INSERT')
  and has_table_privilege('service_role', 'public.taste_reactions', 'UPDATE')
  and has_table_privilege('service_role', 'public.taste_reactions', 'DELETE')
  and not has_table_privilege('service_role', 'public.taste_reactions', 'TRUNCATE'),
  'service role receives bounded taste DML without table-destructive authority'
);

select results_eq(
  $$select policyname from pg_policies where schemaname='public' and tablename='taste_candidates' order by policyname$$,
  array['taste_candidates_select_own']::name[],
  'candidates expose only owner-scoped reads'
);

select results_eq(
  $$select policyname from pg_policies where schemaname='public' and tablename='taste_reactions' order by policyname$$,
  array[
    'taste_reactions_insert_own_draft',
    'taste_reactions_select_own',
    'taste_reactions_update_own_draft'
  ]::name[],
  'reactions expose only owner-scoped draft writes and reads'
);

select has_function('private', 'enforce_taste_candidate_contract', array[]::text[], 'candidate contract helper exists');
select has_function('private', 'enforce_taste_reaction_contract', array[]::text[], 'reaction contract helper exists');

select ok(
  (
    select not prosecdef and coalesce('search_path=""' = any(proconfig), false)
    from pg_proc where oid = 'private.enforce_taste_candidate_contract()'::regprocedure
  )
  and (
    select not prosecdef and coalesce('search_path=""' = any(proconfig), false)
    from pg_proc where oid = 'private.enforce_taste_reaction_contract()'::regprocedure
  ),
  'taste helpers are security invoker with empty search paths'
);

select ok(
  not has_function_privilege('authenticated', 'private.enforce_taste_candidate_contract()'::regprocedure, 'EXECUTE')
  and not has_function_privilege('service_role', 'private.enforce_taste_candidate_contract()'::regprocedure, 'EXECUTE')
  and not has_function_privilege('authenticated', 'private.enforce_taste_reaction_contract()'::regprocedure, 'EXECUTE')
  and not has_function_privilege('service_role', 'private.enforce_taste_reaction_contract()'::regprocedure, 'EXECUTE'),
  'table triggers cannot be invoked as standalone APIs'
);

select has_trigger('public', 'taste_candidates', 'taste_candidates_enforce_contract', 'candidate writes are contract guarded');
select has_trigger('public', 'taste_candidates', 'taste_candidates_set_updated_at', 'candidate state changes update timestamps');
select has_trigger('public', 'taste_reactions', 'taste_reactions_enforce_contract', 'reaction writes are contract guarded');
select has_trigger('public', 'taste_reactions', 'taste_reactions_set_updated_at', 'reaction changes update timestamps');

insert into public.profiles (id, owner_id, current_step)
values
  ('a2300000-0000-4000-8000-000000000001', '11111111-1111-4111-8111-111111111111', 'taste'),
  ('a2300000-0000-4000-8000-000000000002', '11111111-1111-4111-8111-111111111111', 'taste'),
  ('a2300000-0000-4000-8000-000000000003', '11111111-1111-4111-8111-111111111111', 'taste'),
  ('a2300000-0000-4000-8000-000000000004', '11111111-1111-4111-8111-111111111111', 'taste'),
  ('b2300000-0000-4000-8000-000000000001', '22222222-2222-4222-8222-222222222222', 'taste');

insert into public.photos (
  id, owner_id, profile_id, storage_path, position, media_type,
  byte_size, width_px, height_px, sha256, expires_at, created_at
) values (
  'a2310000-0000-4000-8000-000000000001',
  '11111111-1111-4111-8111-111111111111',
  'a2300000-0000-4000-8000-000000000001',
  'customer-photos/taste/source/original.jpg', 1, 'image/jpeg',
  1200, 1200, 1800, decode(repeat('51', 32), 'hex'),
  now() + interval '6 days', now() - interval '1 day'
);

update public.photos
set status='accepted', accepted_at=now()
where id='a2310000-0000-4000-8000-000000000001';
update public.photos
set status='processing'
where id='a2310000-0000-4000-8000-000000000001';

insert into public.extracted_garments (
  id, owner_id, profile_id, source_photo_id, source_kind, category,
  colors, silhouette, fit, confidence, review_status,
  provider_name, provider_model, expires_at
) values (
  'a2320000-0000-4000-8000-000000000001',
  '11111111-1111-4111-8111-111111111111',
  'a2300000-0000-4000-8000-000000000001',
  'a2310000-0000-4000-8000-000000000001',
  'wardrobe_extraction', 'dress', array['coral'], 'column', 'fitted',
  0.91, 'confirmed', 'wardrobe', 'wardrobe-v1', now() + interval '5 days'
);

insert into public.taste_candidates (
  id, owner_id, profile_id, source, extracted_garment_id,
  source_fingerprint, category, color_family, silhouette,
  representation_tags, position
) values (
  'a2330000-0000-4000-8000-000000000001',
  '11111111-1111-4111-8111-111111111111',
  'a2300000-0000-4000-8000-000000000001',
  'extracted_garment', 'a2320000-0000-4000-8000-000000000001',
  decode(repeat('61', 32), 'hex'), 'dress', 'coral', 'column',
  array['full-body', 'editorial'], 1
);

insert into public.taste_candidates (
  id, owner_id, profile_id, source, catalog_product_ref,
  catalog_variant_ref, catalog_shop_ref, category, color_family,
  silhouette, representation_tags, position
) values (
  'a2330000-0000-4000-8000-000000000002',
  '11111111-1111-4111-8111-111111111111',
  'a2300000-0000-4000-8000-000000000001',
  'shopify_catalog', 'product-001', 'variant-001', 'shop-001',
  'top', 'cream', 'structured', array['editorial'], 2
);

insert into public.taste_candidates (
  id, owner_id, profile_id, source, curated_asset_key,
  category, color_family, silhouette, representation_tags, position
) values
  (
    'a2330000-0000-4000-8000-000000000003',
    '11111111-1111-4111-8111-111111111111',
    'a2300000-0000-4000-8000-000000000001',
    'curated_fallback', 'taste/editorial-column-01',
    'trousers', 'black', 'relaxed', array['full-body'], 3
  ),
  (
    'b2330000-0000-4000-8000-000000000001',
    '22222222-2222-4222-8222-222222222222',
    'b2300000-0000-4000-8000-000000000001',
    'curated_fallback', 'taste/other-owner-01',
    'dress', 'blue', 'a-line', array['full-body'], 1
  );

select is(
  (select array_agg(position order by position) from public.taste_candidates where profile_id='a2300000-0000-4000-8000-000000000001'),
  array[1,2,3]::smallint[],
  'dynamic and fallback candidates share one deterministic order'
);

select throws_ok(
  $$
    insert into public.taste_candidates (
      owner_id, profile_id, source, source_fingerprint,
      category, color_family, silhouette, position
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2300000-0000-4000-8000-000000000001',
      'extracted_garment', decode(repeat('62',32),'hex'),
      'dress', 'pink', 'column', 4
    )
  $$,
  '23514',
  'extracted-garment candidate requires its source at creation',
  'an extracted candidate must name its source at creation'
);

select throws_ok(
  $$
    insert into public.taste_candidates (
      owner_id, profile_id, source, extracted_garment_id, source_fingerprint,
      category, color_family, silhouette, position
    ) values (
      '22222222-2222-4222-8222-222222222222',
      'b2300000-0000-4000-8000-000000000001',
      'extracted_garment', 'a2320000-0000-4000-8000-000000000001',
      decode(repeat('63',32),'hex'), 'dress', 'pink', 'column', 2
    )
  $$,
  '23514',
  'extracted-garment candidate requires a current accepted owned source',
  'cross-owner extracted source attachment is rejected'
);

select throws_like(
  $$
    insert into public.taste_candidates (
      owner_id, profile_id, source, catalog_product_ref,
      category, color_family, silhouette, position
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2300000-0000-4000-8000-000000000001',
      'shopify_catalog', 'product-without-shop',
      'dress', 'pink', 'column', 4
    )
  $$,
  '%taste_candidates_source_family_check%',
  'catalog candidates require stable product and shop references'
);

select throws_like(
  $$
    insert into public.taste_candidates (
      owner_id, profile_id, source, curated_asset_key,
      category, color_family, silhouette, position
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2300000-0000-4000-8000-000000000001',
      'curated_fallback', 'https://example.invalid/look.jpg',
      'dress', 'pink', 'column', 4
    )
  $$,
  '%taste_candidates_curated_asset_key_check%',
  'curated fallback stores an approved key rather than an arbitrary URL'
);

select throws_like(
  $$
    insert into public.taste_candidates (
      owner_id, profile_id, source, curated_asset_key,
      category, color_family, silhouette, representation_tags, position
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2300000-0000-4000-8000-000000000001',
      'curated_fallback', 'taste/too-many-tags',
      'dress', 'pink', 'column', array_fill('tag'::text,array[9]), 4
    )
  $$,
  '%taste_candidates_representation_tags_check%',
  'candidate balancing tags enforce their item ceiling'
);

select throws_like(
  $$
    insert into public.taste_candidates (
      owner_id, profile_id, source, curated_asset_key,
      category, color_family, silhouette, position
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2300000-0000-4000-8000-000000000001',
      'curated_fallback', 'taste/duplicate-position',
      'dress', 'pink', 'column', 3
    )
  $$,
  '%taste_candidates_profile_position_idx%',
  'candidate positions are unique per profile'
);

select throws_like(
  $$
    insert into public.taste_candidates (
      owner_id, profile_id, source, extracted_garment_id, source_fingerprint,
      category, color_family, silhouette, position
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2300000-0000-4000-8000-000000000001',
      'extracted_garment', 'a2320000-0000-4000-8000-000000000001',
      decode(repeat('61',32),'hex'), 'dress', 'coral', 'column', 4
    )
  $$,
  '%taste_candidates_profile_fingerprint_idx%',
  'one extracted source fingerprint cannot seed duplicate profile candidates'
);

select throws_like(
  $$insert into public.taste_candidates (raw_provider_payload) values ('{}'::jsonb)$$,
  '%column "raw_provider_payload" of relation "taste_candidates" does not exist%',
  'raw provider payloads cannot be stored as taste evidence'
);

delete from public.extracted_garments
where id='a2320000-0000-4000-8000-000000000001';

select ok(
  exists (
    select 1 from public.taste_candidates
    where id='a2330000-0000-4000-8000-000000000001'
      and extracted_garment_id is null
      and source_fingerprint=decode(repeat('61',32),'hex')
  ),
  'bounded candidate evidence survives source garment purge'
);

insert into public.taste_reactions (
  id, owner_id, profile_id, candidate_id, reaction
) values (
  'a2340000-0000-4000-8000-000000000001',
  '11111111-1111-4111-8111-111111111111',
  'a2300000-0000-4000-8000-000000000001',
  'a2330000-0000-4000-8000-000000000001',
  'love'
);

select is(
  (select count(*) from public.taste_reactions where profile_id='a2300000-0000-4000-8000-000000000001' and undone_at is null),
  1::bigint,
  'a valid Love reaction advances active progress once'
);

select throws_like(
  $$
    insert into public.taste_reactions (
      owner_id, profile_id, candidate_id, reaction
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2300000-0000-4000-8000-000000000001',
      'a2330000-0000-4000-8000-000000000001',
      'hate'
    )
  $$,
  '%taste_reactions_candidate_idx%',
  'one candidate has at most one reaction row'
);

update public.taste_reactions
set reaction='hate'
where id='a2340000-0000-4000-8000-000000000001';

select is(
  (select reaction || ':' || case when undone_at is null then 'active' else 'undone' end from public.taste_reactions where id='a2340000-0000-4000-8000-000000000001'),
  'hate:active'::text,
  'changing a reaction remains one active state'
);

update public.taste_reactions
set undone_at=now()+interval '1 day'
where id='a2340000-0000-4000-8000-000000000001';

select ok(
  exists (
    select 1 from public.taste_reactions
    where id='a2340000-0000-4000-8000-000000000001'
      and reaction='hate'
      and undone_at is not null
      and undone_at <= transaction_timestamp()
  ),
  'undo preserves the choice and records a server-controlled timestamp'
);

select is(
  (select count(*) from public.taste_reactions where profile_id='a2300000-0000-4000-8000-000000000001' and undone_at is null),
  0::bigint,
  'undone reactions no longer count toward progress'
);

update public.taste_reactions
set reaction='maybe', undone_at=null
where id='a2340000-0000-4000-8000-000000000001';

select is(
  (select reaction || ':' || case when undone_at is null then 'active' else 'undone' end from public.taste_reactions where id='a2340000-0000-4000-8000-000000000001'),
  'maybe:active'::text,
  'a new choice reactivates the same bounded reaction row'
);

update public.taste_candidates
set status='unavailable'
where id='a2330000-0000-4000-8000-000000000001';

select throws_ok(
  $$update public.taste_reactions set reaction='love' where id='a2340000-0000-4000-8000-000000000001'$$,
  '23514',
  'active taste reaction requires a ready candidate',
  'an unavailable card cannot accept a new active choice'
);

update public.taste_reactions
set undone_at=now()
where id='a2340000-0000-4000-8000-000000000001';

select ok(
  (select undone_at is not null from public.taste_reactions where id='a2340000-0000-4000-8000-000000000001'),
  'an unavailable card can still undo its previously committed choice'
);

select throws_ok(
  $$update public.taste_reactions set undone_at=null where id='a2340000-0000-4000-8000-000000000001'$$,
  '23514',
  'active taste reaction requires a ready candidate',
  'an unavailable card cannot reactivate an undone choice'
);

update public.taste_candidates
set status='ready'
where id='a2330000-0000-4000-8000-000000000001';
update public.taste_reactions
set undone_at=null
where id='a2340000-0000-4000-8000-000000000001';

insert into public.taste_candidates (
  owner_id, profile_id, source, curated_asset_key,
  category, color_family, silhouette, position
)
select
  '11111111-1111-4111-8111-111111111111',
  'a2300000-0000-4000-8000-000000000002',
  'curated_fallback', 'taste/ceiling-' || candidate_number,
  case when candidate_number % 3 = 0 then 'dress' when candidate_number % 3 = 1 then 'top' else 'trousers' end,
  case when candidate_number % 2 = 0 then 'warm' else 'cool' end,
  case when candidate_number % 2 = 0 then 'structured' else 'relaxed' end,
  candidate_number
from generate_series(1,20) as candidate_number;

insert into public.taste_reactions (
  owner_id, profile_id, candidate_id, reaction
)
select
  candidate.owner_id,
  candidate.profile_id,
  candidate.id,
  case when candidate.position % 3 = 0 then 'love' when candidate.position % 3 = 1 then 'hate' else 'maybe' end
from public.taste_candidates as candidate
where candidate.profile_id='a2300000-0000-4000-8000-000000000002';

select is(
  (select count(*) from public.taste_reactions where profile_id='a2300000-0000-4000-8000-000000000002' and undone_at is null),
  20::bigint,
  'active reaction progress reaches but never exceeds twenty'
);

select throws_ok(
  $$
    insert into public.taste_candidates (
      owner_id, profile_id, source, curated_asset_key,
      category, color_family, silhouette, position
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2300000-0000-4000-8000-000000000002',
      'curated_fallback', 'taste/ceiling-21',
      'dress', 'neutral', 'column', 20
    )
  $$,
  '23514',
  'a profile can retain at most twenty taste candidates',
  'the candidate ceiling makes a twenty-first active reaction impossible'
);

insert into public.taste_candidates (
  id, owner_id, profile_id, source, curated_asset_key,
  category, color_family, silhouette, position
) values (
  'a2330000-0000-4000-8000-000000000004',
  '11111111-1111-4111-8111-111111111111',
  'a2300000-0000-4000-8000-000000000003',
  'curated_fallback', 'taste/frozen-01', 'dress', 'pink', 'column', 1
);

insert into public.taste_reactions (
  id, owner_id, profile_id, candidate_id, reaction
) values (
  'a2340000-0000-4000-8000-000000000004',
  '11111111-1111-4111-8111-111111111111',
  'a2300000-0000-4000-8000-000000000003',
  'a2330000-0000-4000-8000-000000000004', 'love'
);

update public.profiles
set
  status='submitted', current_step='complete', revision=revision+1,
  name='Taste Evidence', age=30, adult_confirmed_at=now(),
  gender='woman', height_cm=165, fit_preference='regular', submitted_at=now()
where id='a2300000-0000-4000-8000-000000000003';

select throws_ok(
  $$update public.taste_candidates set status='unavailable' where id='a2330000-0000-4000-8000-000000000004'$$,
  '23514',
  'submitted taste candidate state is immutable',
  'candidate state freezes with the submitted profile'
);

select throws_ok(
  $$update public.taste_reactions set reaction='hate' where id='a2340000-0000-4000-8000-000000000004'$$,
  '23514',
  'taste reactions are mutable only while the profile is draft',
  'reaction state freezes with the submitted profile'
);

select set_config('request.jwt.claim.sub','11111111-1111-4111-8111-111111111111',true);
set local role authenticated;

select is(
  (select count(*) from public.taste_candidates where id='a2330000-0000-4000-8000-000000000003'),
  1::bigint,
  'customer reads an owned candidate'
);

select is(
  (select count(*) from public.taste_candidates where id='b2330000-0000-4000-8000-000000000001'),
  0::bigint,
  'customer cannot read another owner candidate'
);

select throws_like(
  $$
    insert into public.taste_candidates (
      owner_id, profile_id, source, curated_asset_key,
      category, color_family, silhouette, position
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2300000-0000-4000-8000-000000000001',
      'curated_fallback', 'taste/customer-write',
      'dress', 'pink', 'column', 4
    )
  $$,
  '%permission denied for table taste_candidates%',
  'customer cannot manufacture candidate evidence'
);

insert into public.taste_reactions (
  id, owner_id, profile_id, candidate_id, reaction
) values (
  'a2340000-0000-4000-8000-000000000003',
  '11111111-1111-4111-8111-111111111111',
  'a2300000-0000-4000-8000-000000000001',
  'a2330000-0000-4000-8000-000000000003', 'love'
);

select is(
  (select count(*) from public.taste_reactions where id='a2340000-0000-4000-8000-000000000003'),
  1::bigint,
  'customer may record one reaction on an owned ready candidate'
);

select throws_ok(
  $$
    insert into public.taste_reactions (
      owner_id, profile_id, candidate_id, reaction
    ) values (
      '22222222-2222-4222-8222-222222222222',
      'b2300000-0000-4000-8000-000000000001',
      'b2330000-0000-4000-8000-000000000001', 'hate'
    )
  $$,
  '23514',
  'taste reaction must match one owned profile and candidate',
  'customer cannot react to another owner candidate'
);

select throws_like(
  $$delete from public.taste_reactions where id='a2340000-0000-4000-8000-000000000003'$$,
  '%permission denied for table taste_reactions%',
  'undo remains an update and customer deletion is unavailable'
);

reset role;

update auth.users
set is_anonymous=true
where id='11111111-1111-4111-8111-111111111111';

insert into public.taste_candidates (
  id, owner_id, profile_id, source, curated_asset_key,
  category, color_family, silhouette, position
) values (
  'a2330000-0000-4000-8000-000000000005',
  '11111111-1111-4111-8111-111111111111',
  'a2300000-0000-4000-8000-000000000004',
  'curated_fallback', 'taste/transfer-01', 'dress', 'red', 'column', 1
);

insert into public.taste_reactions (
  id, owner_id, profile_id, candidate_id, reaction
) values (
  'a2340000-0000-4000-8000-000000000005',
  '11111111-1111-4111-8111-111111111111',
  'a2300000-0000-4000-8000-000000000004',
  'a2330000-0000-4000-8000-000000000005', 'maybe'
);

insert into private.anonymous_transfers (
  source_owner_id, source_profile_id, source_profile_revision,
  token_sha256, expires_at
) values (
  '11111111-1111-4111-8111-111111111111',
  'a2300000-0000-4000-8000-000000000004', 1,
  decode(repeat('71',32),'hex'), now()+interval '10 minutes'
);

select lives_ok(
  $$select * from private.consume_anonymous_transfer(decode(repeat('71',32),'hex'),'22222222-2222-4222-8222-222222222222')$$,
  'anonymous transfer moves populated taste evidence atomically'
);

select ok(
  exists (
    select 1
    from public.taste_candidates as candidate
    join public.taste_reactions as reaction_record
      on reaction_record.candidate_id=candidate.id
      and reaction_record.owner_id=candidate.owner_id
      and reaction_record.profile_id=candidate.profile_id
    where candidate.id='a2330000-0000-4000-8000-000000000005'
      and candidate.owner_id='22222222-2222-4222-8222-222222222222'
      and reaction_record.id='a2340000-0000-4000-8000-000000000005'
  ),
  'candidate and reaction ownership follows the transferred profile'
);

select set_config('request.jwt.claim.sub','11111111-1111-4111-8111-111111111111',true);
set local role authenticated;
select is(
  (select count(*) from public.taste_candidates where id='a2330000-0000-4000-8000-000000000005'),
  0::bigint,
  'former owner immediately loses transferred candidate access'
);
reset role;

select set_config('request.jwt.claim.sub','22222222-2222-4222-8222-222222222222',true);
set local role authenticated;
select is(
  (select count(*) from public.taste_reactions where id='a2340000-0000-4000-8000-000000000005'),
  1::bigint,
  'target owner immediately gains transferred reaction access'
);
reset role;

select * from finish();
rollback;
