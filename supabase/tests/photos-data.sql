begin;

create extension if not exists pgtap with schema extensions;
select no_plan();

select has_table('public', 'photos', 'photos table exists');

select columns_are(
  'public',
  'photos',
  array[
    'id',
    'owner_id',
    'profile_id',
    'storage_path',
    'status',
    'position',
    'media_type',
    'byte_size',
    'width_px',
    'height_px',
    'sha256',
    'rejection_code',
    'accepted_at',
    'expires_at',
    'created_at',
    'updated_at'
  ],
  'photos expose only verified object metadata and lifecycle evidence'
);

select ok(
  exists (
    select 1
    from pg_constraint as constraint_record
    where constraint_record.conrelid = 'public.photos'::regclass
      and constraint_record.conname = 'photos_owner_profile_fk'
      and constraint_record.confrelid = 'public.profiles'::regclass
      and constraint_record.condeferrable
      and not constraint_record.condeferred
      and constraint_record.confupdtype = 'c'
      and constraint_record.confdeltype = 'c'
  ),
  'photo ownership uses a deferrable same-owner profile foreign key with transfer and deletion cascades'
);

select has_index('public', 'photos', 'photos_owner_id_key', 'photos expose the same-owner composite key');
select has_index('public', 'photos', 'photos_storage_path_key', 'private object paths are globally unique');

select ok(
  exists (
    select 1
    from pg_constraint as constraint_record
    where constraint_record.conrelid = 'public.photos'::regclass
      and constraint_record.conname = 'photos_profile_position_key'
      and constraint_record.condeferrable
      and not constraint_record.condeferred
  ),
  'photo positions are unique per profile and transactionally reorderable'
);

select has_index('public', 'photos', 'photos_profile_sha_idx', 'photo hashes are unique per profile');
select has_index('public', 'photos', 'photos_owner_profile_idx', 'photo owner/profile foreign-key access is indexed');
select has_index('public', 'photos', 'photos_profile_status_idx', 'photo status reads preserve deterministic profile order');
select has_index('public', 'photos', 'photos_expiry_idx', 'logical-expiry cleanup has its leading deadline index');

select is(
  (select relation.relrowsecurity from pg_class as relation where relation.oid = 'public.photos'::regclass),
  true,
  'photos have row-level security enabled'
);

select ok(
  not has_table_privilege('anon', 'public.photos', 'SELECT')
  and not has_table_privilege('anon', 'public.photos', 'INSERT')
  and not has_table_privilege('anon', 'public.photos', 'UPDATE')
  and not has_table_privilege('anon', 'public.photos', 'DELETE'),
  'the bare anon role has no photo metadata privileges'
);

select ok(
  has_table_privilege('authenticated', 'public.photos', 'SELECT')
  and not has_table_privilege('authenticated', 'public.photos', 'INSERT')
  and not has_table_privilege('authenticated', 'public.photos', 'UPDATE')
  and not has_table_privilege('authenticated', 'public.photos', 'DELETE'),
  'authenticated customers can read eligible metadata but cannot write it'
);

select ok(
  has_table_privilege('service_role', 'public.photos', 'SELECT')
  and has_table_privilege('service_role', 'public.photos', 'INSERT')
  and has_table_privilege('service_role', 'public.photos', 'UPDATE')
  and has_table_privilege('service_role', 'public.photos', 'DELETE')
  and not has_table_privilege('service_role', 'public.photos', 'TRUNCATE'),
  'service role receives bounded photo DML without table-destructive authority'
);

select results_eq(
  $$
    select policyname
    from pg_policies
    where schemaname = 'public' and tablename = 'photos'
    order by policyname
  $$,
  array['photos_select_own_unexpired']::name[],
  'photos expose only the owner-scoped unexpired read policy'
);

select has_function('private', 'enforce_photo_contract', array[]::text[], 'photo contract trigger helper exists');

select is(
  (
    select procedure.prosecdef
    from pg_proc as procedure
    where procedure.oid = 'private.enforce_photo_contract()'::regprocedure
  ),
  false,
  'photo contract helper is security invoker'
);

select ok(
  (
    select coalesce('search_path=""' = any(procedure.proconfig), false)
    from pg_proc as procedure
    where procedure.oid = 'private.enforce_photo_contract()'::regprocedure
  ),
  'photo contract helper fixes an empty search path'
);

select ok(
  not has_function_privilege('authenticated', 'private.enforce_photo_contract()'::regprocedure, 'EXECUTE')
  and not has_function_privilege('anon', 'private.enforce_photo_contract()'::regprocedure, 'EXECUTE')
  and not exists (
    select 1
    from aclexplode(
      coalesce(
        (select procedure.proacl from pg_proc as procedure where procedure.oid = 'private.enforce_photo_contract()'::regprocedure),
        acldefault('f', (select procedure.proowner from pg_proc as procedure where procedure.oid = 'private.enforce_photo_contract()'::regprocedure))
      )
    ) as privilege
    where privilege.grantee = 0 and privilege.privilege_type = 'EXECUTE'
  ),
  'photo contract helper is trigger-only'
);

select has_trigger('public', 'photos', 'photos_enforce_contract', 'photo rows are guarded by the contract trigger');
select has_trigger('public', 'photos', 'photos_set_updated_at', 'photo updates maintain their timestamp');

insert into public.profiles (id, owner_id, current_step)
values
  ('a2000000-0000-4000-8000-000000000001', '11111111-1111-4111-8111-111111111111', 'photos'),
  ('b2000000-0000-4000-8000-000000000001', '22222222-2222-4222-8222-222222222222', 'photos');

select throws_ok(
  $$
    insert into public.photos (
      owner_id, profile_id, storage_path, position, media_type,
      byte_size, width_px, height_px, sha256, expires_at
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2000000-0000-4000-8000-000000000001',
      'customer-photos/a/too-long/original.jpg', 1, 'image/jpeg',
      1000, 1200, 1800, decode(repeat('01', 32), 'hex'), now() + interval '7 days 1 second'
    )
  $$,
  '23514',
  'photo metadata requires a future initial deadline no later than seven days',
  'initial photo deadline cannot exceed seven days'
);

select throws_ok(
  $$
    insert into public.photos (
      owner_id, profile_id, storage_path, status, position, media_type,
      byte_size, width_px, height_px, sha256, accepted_at, expires_at
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2000000-0000-4000-8000-000000000001',
      'customer-photos/a/born-accepted/original.jpg', 'accepted', 1, 'image/jpeg',
      1000, 1200, 1800, decode(repeat('02', 32), 'hex'), now(), now() + interval '6 days'
    )
  $$,
  '23514',
  'photo metadata must begin in uploaded state',
  'photo lifecycle begins in uploaded state'
);

select throws_like(
  $$
    insert into public.photos (
      owner_id, profile_id, storage_path, position, media_type,
      byte_size, width_px, height_px, sha256, expires_at
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2000000-0000-4000-8000-000000000001',
      'customer-photos/a/bad-position/original.jpg', 13, 'image/jpeg',
      1000, 1200, 1800, decode(repeat('03', 32), 'hex'), now() + interval '6 days'
    )
  $$,
  '%photos_position_check%',
  'photo position stays within the 1-12 collection bound'
);

select throws_like(
  $$
    insert into public.photos (
      owner_id, profile_id, storage_path, position, media_type,
      byte_size, width_px, height_px, sha256, expires_at
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2000000-0000-4000-8000-000000000001',
      'customer-photos/a/bad-type/original.gif', 1, 'image/gif',
      1000, 1200, 1800, decode(repeat('04', 32), 'hex'), now() + interval '6 days'
    )
  $$,
  '%photos_media_type_check%',
  'photo media type stays inside the approved allowlist'
);

select throws_like(
  $$
    insert into public.photos (
      owner_id, profile_id, storage_path, position, media_type,
      byte_size, width_px, height_px, sha256, expires_at
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2000000-0000-4000-8000-000000000001',
      'customer-photos/a/too-large/original.jpg', 1, 'image/jpeg',
      15728641, 1200, 1800, decode(repeat('05', 32), 'hex'), now() + interval '6 days'
    )
  $$,
  '%photos_byte_size_check%',
  'photo bytes stay within the 15 MiB bound'
);

select throws_like(
  $$
    insert into public.photos (
      owner_id, profile_id, storage_path, position, media_type,
      byte_size, width_px, height_px, sha256, expires_at
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2000000-0000-4000-8000-000000000001',
      'customer-photos/a/too-small/original.jpg', 1, 'image/jpeg',
      1000, 639, 1800, decode(repeat('06', 32), 'hex'), now() + interval '6 days'
    )
  $$,
  '%photos_width_px_check%',
  'photo dimensions reject images below the quality floor'
);

select throws_like(
  $$
    insert into public.photos (
      owner_id, profile_id, storage_path, position, media_type,
      byte_size, width_px, height_px, sha256, expires_at
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2000000-0000-4000-8000-000000000001',
      'customer-photos/a/bad-hash/original.jpg', 1, 'image/jpeg',
      1000, 1200, 1800, decode('abcd', 'hex'), now() + interval '6 days'
    )
  $$,
  '%photos_sha256_check%',
  'photo hashes require an exact SHA-256 digest'
);

select throws_like(
  $$
    insert into public.photos (
      owner_id, profile_id, storage_path, position, media_type,
      byte_size, width_px, height_px, sha256, expires_at
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2000000-0000-4000-8000-000000000001',
      '   ', 1, 'image/jpeg',
      1000, 1200, 1800, decode(repeat('07', 32), 'hex'), now() + interval '6 days'
    )
  $$,
  '%photos_storage_path_check%',
  'photo object paths reject blank or untrimmed values'
);

select throws_like(
  $$
    insert into public.photos (
      owner_id, profile_id, storage_path, position, media_type,
      byte_size, width_px, height_px, sha256, expires_at
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'b2000000-0000-4000-8000-000000000001',
      'customer-photos/a/cross-owner/original.jpg', 1, 'image/jpeg',
      1000, 1200, 1800, decode(repeat('08', 32), 'hex'), now() + interval '6 days'
    )
  $$,
  '%photos_owner_profile_fk%',
  'photo metadata cannot attach to a profile owned by another identity'
);

select lives_ok(
  $$
    insert into public.photos (
      id, owner_id, profile_id, storage_path, position, media_type,
      byte_size, width_px, height_px, sha256, expires_at, created_at
    )
    select
      ('a2100000-0000-4000-8000-' || lpad(series::text, 12, '0'))::uuid,
      '11111111-1111-4111-8111-111111111111'::uuid,
      'a2000000-0000-4000-8000-000000000001'::uuid,
      'customer-photos/a/profile/photo-' || series || '/original.jpg',
      series,
      'image/jpeg',
      1000 + series,
      1200,
      1800,
      decode(lpad(to_hex(series), 64, '0'), 'hex'),
      now() + interval '6 days',
      now() - interval '1 day'
    from generate_series(1, 8) as series
  $$,
  'eight distinct uploaded photo rows can be created independently'
);

select lives_ok(
  $$
    update public.photos
    set status = 'accepted', accepted_at = now()
    where profile_id = 'a2000000-0000-4000-8000-000000000001'
  $$,
  'eight independently verified photos can become accepted'
);

select results_eq(
  $$
    select position::integer
    from public.photos
    where profile_id = 'a2000000-0000-4000-8000-000000000001'
    order by position
  $$,
  array[1, 2, 3, 4, 5, 6, 7, 8]::integer[],
  'eight distinct accepted rows have deterministic order'
);

select is(
  (
    select count(*)
    from public.photos
    where profile_id = 'a2000000-0000-4000-8000-000000000001'
      and status = 'accepted'
      and accepted_at is not null
  ),
  8::bigint,
  'all eight accepted rows satisfy the accepted-state contract'
);

select throws_like(
  $$
    insert into public.photos (
      owner_id, profile_id, storage_path, position, media_type,
      byte_size, width_px, height_px, sha256, expires_at
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2000000-0000-4000-8000-000000000001',
      'customer-photos/a/duplicate/original.jpg', 9, 'image/jpeg',
      1000, 1200, 1800, decode(lpad(to_hex(1), 64, '0'), 'hex'), now() + interval '6 days'
    )
  $$,
  '%photos_profile_sha_idx%',
  'duplicate hash in one profile is rejected'
);

select lives_ok(
  $$
    insert into public.photos (
      id, owner_id, profile_id, storage_path, position, media_type,
      byte_size, width_px, height_px, sha256, expires_at, created_at
    ) values (
      'b2100000-0000-4000-8000-000000000001',
      '22222222-2222-4222-8222-222222222222',
      'b2000000-0000-4000-8000-000000000001',
      'customer-photos/b/profile/photo-1/original.jpg', 1, 'image/jpeg',
      1000, 1200, 1800, decode(lpad(to_hex(1), 64, '0'), 'hex'),
      now() + interval '6 days', now() - interval '1 day'
    )
  $$,
  'the same image digest remains valid in another owner profile'
);

select throws_like(
  $$
    insert into public.photos (
      owner_id, profile_id, storage_path, position, media_type,
      byte_size, width_px, height_px, sha256, expires_at
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2000000-0000-4000-8000-000000000001',
      'customer-photos/a/duplicate-position/original.jpg', 8, 'image/jpeg',
      1000, 1200, 1800, decode(repeat('ff', 32), 'hex'), now() + interval '6 days'
    )
  $$,
  '%photos_profile_position_key%',
  'duplicate position in one profile is rejected'
);

select lives_ok(
  $$
    set constraints photos_profile_position_key deferred;
    update public.photos set position = 12 where id = 'a2100000-0000-4000-8000-000000000001';
    update public.photos set position = 1 where id = 'a2100000-0000-4000-8000-000000000008';
    update public.photos set position = 8 where id = 'a2100000-0000-4000-8000-000000000001';
    set constraints photos_profile_position_key immediate;
  $$,
  'deferring the position key permits an atomic reorder without a temporary duplicate'
);

select results_eq(
  $$
    select id::text, position::integer
    from public.photos
    where id in (
      'a2100000-0000-4000-8000-000000000001',
      'a2100000-0000-4000-8000-000000000008'
    )
    order by position
  $$,
  $$
    values
      ('a2100000-0000-4000-8000-000000000008'::text, 1),
      ('a2100000-0000-4000-8000-000000000001'::text, 8)
  $$,
  'atomic reorder persists the requested positions'
);

select throws_ok(
  $$
    update public.photos
    set storage_path = 'customer-photos/a/rewritten/original.jpg'
    where id = 'a2100000-0000-4000-8000-000000000002'
  $$,
  '23514',
  'verified photo identity and object metadata are immutable',
  'verified object path cannot be rewritten'
);

select throws_ok(
  $$
    update public.photos
    set expires_at = expires_at + interval '1 second'
    where id = 'a2100000-0000-4000-8000-000000000002'
  $$,
  '23514',
  'photo deadline cannot be extended outside a named retention transaction',
  'direct writes cannot extend a photo deadline'
);

select throws_ok(
  $$
    update public.photos
    set status = 'complete'
    where id = 'a2100000-0000-4000-8000-000000000002'
  $$,
  '23514',
  'invalid photo state transition',
  'photo state cannot skip directly from accepted to complete'
);

select lives_ok(
  $$
    update public.photos
    set expires_at = now() - interval '1 hour'
    where id = 'a2100000-0000-4000-8000-000000000003'
  $$,
  'a server retention action may shorten a still-current photo deadline'
);

set local role authenticated;
set local request.jwt.claim.sub = '11111111-1111-4111-8111-111111111111';

select is(
  (select count(*) from public.photos),
  7::bigint,
  'owner A reads only its seven unexpired photo rows'
);

select is_empty(
  $$select id from public.photos where id = 'a2100000-0000-4000-8000-000000000003'$$,
  'expired photo metadata fails the readable predicate immediately'
);

select is_empty(
  $$select id from public.photos where owner_id = '22222222-2222-4222-8222-222222222222'$$,
  'owner A cannot read owner B photo metadata'
);

select throws_like(
  $$
    insert into public.photos (
      owner_id, profile_id, storage_path, position, media_type,
      byte_size, width_px, height_px, sha256, expires_at
    ) values (
      '11111111-1111-4111-8111-111111111111',
      'a2000000-0000-4000-8000-000000000001',
      'customer-photos/a/customer-write/original.jpg', 9, 'image/jpeg',
      1000, 1200, 1800, decode(repeat('ee', 32), 'hex'), now() + interval '6 days'
    )
  $$,
  '%permission denied for table photos%',
  'authenticated customers cannot create server-verified metadata'
);

select throws_like(
  $$update public.photos set position = 9 where id = 'a2100000-0000-4000-8000-000000000002'$$,
  '%permission denied for table photos%',
  'authenticated customers cannot reorder metadata directly'
);

select throws_like(
  $$delete from public.photos where id = 'a2100000-0000-4000-8000-000000000002'$$,
  '%permission denied for table photos%',
  'authenticated customers cannot delete metadata directly'
);

reset role;
set local role authenticated;
set local request.jwt.claim.sub = '22222222-2222-4222-8222-222222222222';

select results_eq(
  $$select id::text from public.photos$$,
  array['b2100000-0000-4000-8000-000000000001']::text[],
  'owner B reads only its own unexpired photo row'
);

reset role;
set local role anon;

select throws_like(
  $$select count(*) from public.photos$$,
  '%permission denied for table photos%',
  'bare publishable-key access cannot read photo metadata'
);

reset role;

select lives_ok(
  $$
    update public.photos set status = 'processing'
    where id = 'a2100000-0000-4000-8000-000000000002';
    update public.photos set status = 'partial', rejection_code = 'garment_partial'
    where id = 'a2100000-0000-4000-8000-000000000002';
    update public.photos set status = 'processing', rejection_code = null
    where id = 'a2100000-0000-4000-8000-000000000002';
    update public.photos set status = 'complete'
    where id = 'a2100000-0000-4000-8000-000000000002';
  $$,
  'photo processing supports the approved bounded partial-retry lifecycle'
);

select throws_ok(
  $$
    update public.photos set status = 'processing'
    where id = 'a2100000-0000-4000-8000-000000000003'
  $$,
  '23514',
  'expired photo metadata cannot be processed or reordered',
  'expired photo metadata cannot be revived through processing'
);

select lives_ok(
  $$delete from public.profiles where id = 'b2000000-0000-4000-8000-000000000001'$$,
  'profile deletion cascades its photo metadata'
);

select is_empty(
  $$select id from public.photos where id = 'b2100000-0000-4000-8000-000000000001'$$,
  'profile deletion leaves no orphan photo metadata'
);

select * from finish();
rollback;
