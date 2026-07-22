begin;

create extension if not exists pgtap with schema extensions;
select plan(49);

select has_table(
  'private',
  'anonymous_transfers',
  'anonymous transfer records live in the private schema'
);

select columns_are(
  'private',
  'anonymous_transfers',
  array[
    'id',
    'source_owner_id',
    'source_profile_id',
    'source_profile_revision',
    'target_owner_id',
    'token_sha256',
    'status',
    'expires_at',
    'consumed_at',
    'created_at'
  ],
  'transfer records expose only hashed-token and lifecycle evidence'
);

select is(
  (
    select table_record.relrowsecurity
    from pg_class as table_record
    where table_record.oid = 'private.anonymous_transfers'::regclass
  ),
  true,
  'transfer records have row level security enabled'
);

select is_empty(
  $$
    select policyname
    from pg_policies
    where schemaname = 'private'
      and tablename = 'anonymous_transfers'
  $$,
  'no customer-facing policy exposes transfer records'
);

select ok(
  has_table_privilege('service_role', 'private.anonymous_transfers', 'SELECT')
  and has_table_privilege('service_role', 'private.anonymous_transfers', 'INSERT')
  and has_table_privilege('service_role', 'private.anonymous_transfers', 'UPDATE')
  and has_table_privilege('service_role', 'private.anonymous_transfers', 'DELETE')
  and not has_table_privilege('service_role', 'private.anonymous_transfers', 'TRUNCATE'),
  'service role has the bounded transfer-record privileges it needs'
);

select ok(
  not has_schema_privilege('anon', 'private', 'USAGE')
  and not has_schema_privilege('authenticated', 'private', 'USAGE')
  and not has_table_privilege('anon', 'private.anonymous_transfers', 'SELECT')
  and not has_table_privilege('authenticated', 'private.anonymous_transfers', 'SELECT'),
  'customer roles cannot enter the private transfer boundary'
);

select has_index(
  'private',
  'anonymous_transfers',
  'anonymous_transfers_token_sha256_idx',
  'token hashes are unique'
);

select has_index(
  'private',
  'anonymous_transfers',
  'anonymous_transfers_expiry_idx',
  'prepared-transfer expiry cleanup is indexed'
);

select ok(
  (
    select count(*) = 3
    from pg_constraint as constraint_record
    where constraint_record.conrelid = 'private.anonymous_transfers'::regclass
      and constraint_record.contype = 'f'
  ),
  'transfer records constrain both account owners and the source profile'
);

select has_function(
  'private',
  'consume_anonymous_transfer',
  array['bytea', 'uuid'],
  'atomic transfer function exists with the approved inputs'
);

select ok(
  (
    select procedure.prosecdef
    from pg_proc as procedure
    where procedure.oid = 'private.consume_anonymous_transfer(bytea, uuid)'::regprocedure
  ),
  'atomic transfer function is security definer'
);

select ok(
  (
    select coalesce('search_path=""' = any(procedure.proconfig), false)
    from pg_proc as procedure
    where procedure.oid = 'private.consume_anonymous_transfer(bytea, uuid)'::regprocedure
  ),
  'atomic transfer function pins an empty search path'
);

select ok(
  has_function_privilege(
    'service_role',
    'private.consume_anonymous_transfer(bytea, uuid)',
    'EXECUTE'
  )
  and not has_function_privilege(
    'anon',
    'private.consume_anonymous_transfer(bytea, uuid)',
    'EXECUTE'
  )
  and not has_function_privilege(
    'authenticated',
    'private.consume_anonymous_transfer(bytea, uuid)',
    'EXECUTE'
  ),
  'only service role can execute the transfer function'
);

select has_trigger(
  'private',
  'anonymous_transfers',
  'anonymous_transfers_enforce_contract',
  'transfer preparation and lifecycle are guarded by a trigger'
);

insert into auth.users (id, email, is_anonymous)
values
  ('91000000-0000-4000-8000-000000000001', null, true),
  ('92000000-0000-4000-8000-000000000001', 'target@transfer.test', false),
  ('93000000-0000-4000-8000-000000000001', 'other@transfer.test', false),
  ('94000000-0000-4000-8000-000000000001', null, true),
  ('95000000-0000-4000-8000-000000000001', null, true);

insert into public.profiles (
  id,
  owner_id,
  status,
  current_step,
  revision,
  name,
  age,
  adult_confirmed_at,
  gender,
  height_cm,
  fit_preference,
  submitted_at
) values
  (
    '91100000-0000-4000-8000-000000000001',
    '91000000-0000-4000-8000-000000000001',
    'draft',
    'account',
    3,
    'Anonymous draft',
    null,
    null,
    null,
    null,
    null,
    null
  ),
  (
    '92100000-0000-4000-8000-000000000001',
    '92000000-0000-4000-8000-000000000001',
    'active',
    'complete',
    7,
    'Existing report',
    36,
    now() - interval '30 days',
    'woman',
    168,
    'regular',
    now() - interval '30 days'
  ),
  (
    '94100000-0000-4000-8000-000000000001',
    '94000000-0000-4000-8000-000000000001',
    'draft',
    'photos',
    1,
    null,
    null,
    null,
    null,
    null,
    null,
    null
  ),
  (
    '95100000-0000-4000-8000-000000000001',
    '95000000-0000-4000-8000-000000000001',
    'draft',
    'brand_sizing',
    2,
    null,
    null,
    null,
    null,
    null,
    null,
    null
  );

insert into public.favorite_brands (
  id, owner_id, profile_id, brand_name, brand_key, preference_order
) values
  (
    '91200000-0000-4000-8000-000000000001',
    '91000000-0000-4000-8000-000000000001',
    '91100000-0000-4000-8000-000000000001',
    'Zara',
    'zara',
    1
  ),
  (
    '92200000-0000-4000-8000-000000000001',
    '92000000-0000-4000-8000-000000000001',
    '92100000-0000-4000-8000-000000000001',
    'COS',
    'cos',
    1
  );

insert into public.brand_sizes (
  id,
  owner_id,
  profile_id,
  brand_name,
  brand_key,
  garment_type,
  size_status,
  size_label,
  preference_order
) values
  (
    '91300000-0000-4000-8000-000000000001',
    '91000000-0000-4000-8000-000000000001',
    '91100000-0000-4000-8000-000000000001',
    'Zara',
    'zara',
    'jeans',
    'known',
    'L',
    1
  ),
  (
    '92300000-0000-4000-8000-000000000001',
    '92000000-0000-4000-8000-000000000001',
    '92100000-0000-4000-8000-000000000001',
    'COS',
    'cos',
    'tops',
    'known',
    'M',
    1
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
    '91400000-0000-4000-8000-000000000001',
    '91000000-0000-4000-8000-000000000001',
    '91100000-0000-4000-8000-000000000001',
    'account_connection',
    'granted',
    'transfer-v1',
    decode(repeat('ab', 32), 'hex'),
    '2026-07-22 12:00:00+00'::timestamptz
  ),
  (
    '92400000-0000-4000-8000-000000000001',
    '92000000-0000-4000-8000-000000000001',
    '92100000-0000-4000-8000-000000000001',
    'profile_processing',
    'granted',
    'existing-v1',
    decode(repeat('cd', 32), 'hex'),
    now() - interval '30 days'
  );

insert into public.photos (
  id,
  owner_id,
  profile_id,
  storage_path,
  position,
  media_type,
  byte_size,
  width_px,
  height_px,
  sha256,
  expires_at
) values (
  '91600000-0000-4000-8000-000000000001',
  '91000000-0000-4000-8000-000000000001',
  '91100000-0000-4000-8000-000000000001',
  'customer-photos/91000000-0000-4000-8000-000000000001/91100000-0000-4000-8000-000000000001/91600000-0000-4000-8000-000000000001/original.jpg',
  1,
  'image/jpeg',
  2048,
  1200,
  1800,
  decode(repeat('ef', 32), 'hex'),
  now() + interval '6 days'
);

select throws_ok(
  $$
    insert into private.anonymous_transfers (
      source_owner_id,
      source_profile_id,
      source_profile_revision,
      token_sha256,
      expires_at
    ) values (
      '92000000-0000-4000-8000-000000000001',
      '92100000-0000-4000-8000-000000000001',
      7,
      decode(repeat('01', 32), 'hex'),
      now() + interval '10 minutes'
    )
  $$,
  '23514',
  'anonymous transfer source must be an owned root draft at the recorded revision',
  'a permanent active profile cannot prepare an anonymous transfer'
);

select lives_ok(
  $$
    insert into private.anonymous_transfers (
      id,
      source_owner_id,
      source_profile_id,
      source_profile_revision,
      token_sha256,
      expires_at
    ) values (
      '91500000-0000-4000-8000-000000000001',
      '91000000-0000-4000-8000-000000000001',
      '91100000-0000-4000-8000-000000000001',
      3,
      decode(repeat('11', 32), 'hex'),
      now() + interval '10 minutes'
    )
  $$,
  'a hashed transfer token can be prepared for an anonymous root draft'
);

select is(
  (
    select octet_length(transfer.token_sha256)
    from private.anonymous_transfers as transfer
    where transfer.id = '91500000-0000-4000-8000-000000000001'
  ),
  32,
  'prepared transfer stores only the 32-byte token digest'
);

set local role service_role;

select results_eq(
  $$
    select
      result_profile_id::text,
      result_target_owner_id::text,
      result_status,
      result_already_consumed
    from private.consume_anonymous_transfer(
      decode(repeat('11', 32), 'hex'),
      '92000000-0000-4000-8000-000000000001'
    )
  $$,
  $$
    values (
      '91100000-0000-4000-8000-000000000001'::text,
      '92000000-0000-4000-8000-000000000001'::text,
      'consumed'::text,
      false
    )
  $$,
  'valid token atomically consumes into the permanent account'
);

reset role;

select is(
  (
    select owner_id
    from public.profiles
    where id = '91100000-0000-4000-8000-000000000001'
  ),
  '92000000-0000-4000-8000-000000000001'::uuid,
  'profile root moves to the target owner'
);

select is(
  (
    select owner_id
    from public.favorite_brands
    where id = '91200000-0000-4000-8000-000000000001'
  ),
  '92000000-0000-4000-8000-000000000001'::uuid,
  'favorite-brand ownership cascades with the profile'
);

select is(
  (
    select owner_id
    from public.brand_sizes
    where id = '91300000-0000-4000-8000-000000000001'
  ),
  '92000000-0000-4000-8000-000000000001'::uuid,
  'garment-size ownership cascades with the profile'
);

select is(
  (
    select owner_id
    from public.consent_records
    where id = '91400000-0000-4000-8000-000000000001'
  ),
  '92000000-0000-4000-8000-000000000001'::uuid,
  'consent-event ownership cascades without changing evidence'
);

select is(
  (
    select owner_id
    from public.photos
    where id = '91600000-0000-4000-8000-000000000001'
  ),
  '92000000-0000-4000-8000-000000000001'::uuid,
  'photo ownership cascades while its immutable object path stays in place'
);

select results_eq(
  $$
    select name, revision, status
    from public.profiles
    where id = '92100000-0000-4000-8000-000000000001'
  $$,
  $$values ('Existing report'::text, 7, 'active'::text)$$,
  'existing target active profile remains unchanged'
);

select results_eq(
  $$
    select status, derived_from_profile_id
    from public.profiles
    where id = '91100000-0000-4000-8000-000000000001'
  $$,
  $$values ('draft'::text, null::uuid)$$,
  'incoming profile remains a separate root draft'
);

select results_eq(
  $$
    select status
    from public.profiles
    where owner_id = '92000000-0000-4000-8000-000000000001'
    order by status
  $$,
  array['active', 'draft']::text[],
  'target account owns its active report alongside the transferred draft'
);

select results_eq(
  $$
    select brand_name, garment_type, size_label
    from public.brand_sizes
    where profile_id = '92100000-0000-4000-8000-000000000001'
  $$,
  $$values ('COS'::text, 'tops'::text, 'M'::text)$$,
  'existing target sizing evidence remains unchanged'
);

set local role authenticated;
set local request.jwt.claim.sub = '91000000-0000-4000-8000-000000000001';

select is_empty(
  $$select id from public.profiles$$,
  'prior anonymous identity can no longer read the transferred profile'
);

select is_empty(
  $$select id from public.photos$$,
  'prior anonymous identity can no longer read transferred photo metadata'
);

reset role;
set local role authenticated;
set local request.jwt.claim.sub = '92000000-0000-4000-8000-000000000001';

select results_eq(
  $$select count(*) from public.profiles$$,
  array[2::bigint],
  'target account can read both existing and transferred profiles'
);

select results_eq(
  $$select brand_key from public.favorite_brands order by brand_key$$,
  array['cos', 'zara']::text[],
  'target account can read both existing and transferred profile evidence'
);

select results_eq(
  $$select storage_path from public.photos$$,
  array['customer-photos/91000000-0000-4000-8000-000000000001/91100000-0000-4000-8000-000000000001/91600000-0000-4000-8000-000000000001/original.jpg']::text[],
  'target account reads transferred photo metadata without renaming the object path'
);

reset role;
set local role service_role;

select results_eq(
  $$
    select result_status, result_already_consumed
    from private.consume_anonymous_transfer(
      decode(repeat('11', 32), 'hex'),
      '92000000-0000-4000-8000-000000000001'
    )
  $$,
  $$values ('consumed'::text, true)$$,
  'same-target retry returns the consumed result idempotently'
);

reset role;

select is(
  (
    select count(*)
    from public.profiles
    where id = '91100000-0000-4000-8000-000000000001'
      and owner_id = '92000000-0000-4000-8000-000000000001'
  ),
  1::bigint,
  'idempotent retry does not duplicate the profile graph'
);

set local role service_role;

select throws_ok(
  $$
    select *
    from private.consume_anonymous_transfer(
      decode(repeat('11', 32), 'hex'),
      '93000000-0000-4000-8000-000000000001'
    )
  $$,
  '42501',
  'anonymous transfer token has already been consumed',
  'another target cannot replay a consumed token'
);

reset role;

select lives_ok(
  $$
    insert into private.anonymous_transfers (
      id,
      source_owner_id,
      source_profile_id,
      source_profile_revision,
      token_sha256,
      created_at,
      expires_at
    ) values (
      '94500000-0000-4000-8000-000000000001',
      '94000000-0000-4000-8000-000000000001',
      '94100000-0000-4000-8000-000000000001',
      1,
      decode(repeat('22', 32), 'hex'),
      now() - interval '10 minutes',
      now() - interval '1 minute'
    )
  $$,
  'an unconsumed token can reach its bounded expiry time'
);

set local role service_role;

select results_eq(
  $$
    select result_status, result_target_owner_id
    from private.consume_anonymous_transfer(
      decode(repeat('22', 32), 'hex'),
      '92000000-0000-4000-8000-000000000001'
    )
  $$,
  $$values ('expired'::text, null::uuid)$$,
  'expired token returns an explicit terminal result'
);

reset role;

select is(
  (
    select owner_id
    from public.profiles
    where id = '94100000-0000-4000-8000-000000000001'
  ),
  '94000000-0000-4000-8000-000000000001'::uuid,
  'expired token changes no profile owner'
);

select results_eq(
  $$
    select status, target_owner_id, consumed_at
    from private.anonymous_transfers
    where id = '94500000-0000-4000-8000-000000000001'
  $$,
  $$values ('expired'::text, null::uuid, null::timestamptz)$$,
  'expired transfer persists a terminal non-consumed state'
);

insert into private.anonymous_transfers (
  id,
  source_owner_id,
  source_profile_id,
  source_profile_revision,
  token_sha256,
  expires_at
) values (
  '95500000-0000-4000-8000-000000000001',
  '95000000-0000-4000-8000-000000000001',
  '95100000-0000-4000-8000-000000000001',
  2,
  decode(repeat('33', 32), 'hex'),
  now() + interval '10 minutes'
);

update public.profiles
set revision = 3
where id = '95100000-0000-4000-8000-000000000001';

set local role service_role;

select throws_ok(
  $$
    select *
    from private.consume_anonymous_transfer(
      decode(repeat('33', 32), 'hex'),
      '92000000-0000-4000-8000-000000000001'
    )
  $$,
  '40001',
  'anonymous transfer source draft no longer matches the prepared revision',
  'stale profile revision cannot consume a prepared token'
);

reset role;

select is(
  (
    select owner_id
    from public.profiles
    where id = '95100000-0000-4000-8000-000000000001'
  ),
  '95000000-0000-4000-8000-000000000001'::uuid,
  'stale token leaves source ownership unchanged'
);

select throws_ok(
  $$
    update private.anonymous_transfers
    set token_sha256 = decode(repeat('44', 32), 'hex')
    where id = '95500000-0000-4000-8000-000000000001'
  $$,
  '23514',
  'anonymous transfer identity and expiry evidence are immutable',
  'prepared token identity cannot be rewritten'
);

select throws_ok(
  $$
    update private.anonymous_transfers
    set status = 'cancelled', target_owner_id = null, consumed_at = null
    where id = '91500000-0000-4000-8000-000000000001'
  $$,
  '23514',
  'terminal anonymous transfer state is immutable',
  'consumed transfer state cannot be changed'
);

select ok(
  (
    select consumed_at <= expires_at
    from private.anonymous_transfers
    where id = '91500000-0000-4000-8000-000000000001'
  ),
  'consumption timestamp remains inside the approved token lifetime'
);

select throws_ok(
  $$
    insert into private.anonymous_transfers (
      source_owner_id,
      source_profile_id,
      source_profile_revision,
      token_sha256,
      created_at,
      expires_at
    ) values (
      '94000000-0000-4000-8000-000000000001',
      '94100000-0000-4000-8000-000000000001',
      1,
      decode(repeat('55', 32), 'hex'),
      now(),
      now() + interval '16 minutes'
    )
  $$,
  '23514',
  null,
  'transfer lifetime cannot exceed 15 minutes'
);

set local role authenticated;
set local request.jwt.claim.sub = '92000000-0000-4000-8000-000000000001';

select throws_ok(
  $$select count(*) from private.anonymous_transfers$$,
  '42501',
  null,
  'authenticated customer cannot read transfer metadata'
);

select throws_ok(
  $$
    select *
    from private.consume_anonymous_transfer(
      decode(repeat('11', 32), 'hex'),
      '92000000-0000-4000-8000-000000000001'
    )
  $$,
  '42501',
  null,
  'authenticated customer cannot execute the privileged transfer function'
);

reset role;

select is(
  (
    select count(*)
    from private.anonymous_transfers
    where status = 'consumed'
  ),
  1::bigint,
  'only the valid token reached consumed state'
);

select results_eq(
  $$
    select policy_version, encode(copy_sha256, 'hex'), captured_at
    from public.consent_records
    where id = '91400000-0000-4000-8000-000000000001'
  $$,
  $$
    values (
      'transfer-v1'::text,
      repeat('ab', 32)::text,
      '2026-07-22 12:00:00+00'::timestamptz
    )
  $$,
  'transferred consent-event evidence remains stable'
);

select * from finish();
rollback;
