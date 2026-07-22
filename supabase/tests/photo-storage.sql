begin;

create extension if not exists pgtap with schema extensions;
select no_plan();

select has_table('storage', 'buckets', 'Supabase Storage buckets are available');
select has_table('storage', 'objects', 'Supabase Storage object metadata is available');

select is(
  (select name from storage.buckets where id = 'customer-photos'),
  'customer-photos'::text,
  'customer photo bucket uses the canonical stable name'
);

select is(
  (select public from storage.buckets where id = 'customer-photos'),
  false,
  'customer photo bucket is private'
);

select is(
  (select file_size_limit from storage.buckets where id = 'customer-photos'),
  15728640::bigint,
  'customer photo bucket enforces the 15 MiB object limit'
);

select is(
  (select allowed_mime_types from storage.buckets where id = 'customer-photos'),
  array[
    'image/jpeg',
    'image/png',
    'image/webp',
    'image/heic',
    'image/heif'
  ]::text[],
  'customer photo bucket accepts only the approved image media types'
);

select results_eq(
  $$
    select policyname
    from pg_policies
    where schemaname = 'storage'
      and tablename = 'objects'
      and (
        policyname like 'customer_photos_%'
        or coalesce(qual, '') like '%customer-photos%'
        or coalesce(with_check, '') like '%customer-photos%'
      )
    order by policyname
  $$,
  array['customer_photos_select_owned_unexpired']::name[],
  'customer photos expose exactly one customer-facing Storage policy'
);

select is(
  (
    select cmd
    from pg_policies
    where schemaname = 'storage'
      and tablename = 'objects'
      and policyname = 'customer_photos_select_owned_unexpired'
  ),
  'SELECT'::text,
  'customer photo policy grants only reads'
);

select is(
  (
    select roles
    from pg_policies
    where schemaname = 'storage'
      and tablename = 'objects'
      and policyname = 'customer_photos_select_owned_unexpired'
  ),
  array['authenticated']::name[],
  'customer photo reads require an authenticated identity'
);

select ok(
  (
    select qual like '%allow_only_operation%storage.object.get_authenticated%'
    from pg_policies
    where schemaname = 'storage'
      and tablename = 'objects'
      and policyname = 'customer_photos_select_owned_unexpired'
  ),
  'the read policy permits authenticated object downloads'
);

select ok(
  (
    select qual like '%allow_only_operation%object.get_authenticated_info%'
      and qual not like '%storage.object.list%'
    from pg_policies
    where schemaname = 'storage'
      and tablename = 'objects'
      and policyname = 'customer_photos_select_owned_unexpired'
  ),
  'the read policy permits authenticated object metadata checks but not bucket listing'
);

select ok(
  (
    select qual like '%photo.storage_path = objects.name%'
      and qual like '%photo.owner_id = ( SELECT auth.uid()%'
    from pg_policies
    where schemaname = 'storage'
      and tablename = 'objects'
      and policyname = 'customer_photos_select_owned_unexpired'
  ),
  'the read policy requires an exact relational path and current owner match'
);

select ok(
  (
    select qual like '%photo.status = ANY%accepted%processing%partial%complete%failed%'
    from pg_policies
    where schemaname = 'storage'
      and tablename = 'objects'
      and policyname = 'customer_photos_select_owned_unexpired'
  ),
  'the read policy excludes unaccepted and rejected photo metadata'
);

select ok(
  (
    select qual like '%photo.expires_at > transaction_timestamp()%'
    from pg_policies
    where schemaname = 'storage'
      and tablename = 'objects'
      and policyname = 'customer_photos_select_owned_unexpired'
  ),
  'the read policy fails closed at the relational expiry deadline'
);

select is(
  storage.allow_only_operation('storage.object.get_authenticated'),
  false,
  'an unspecified Storage operation is denied'
);

select set_config('storage.operation', 'storage.object.get_authenticated', true);

select is(
  storage.allow_only_operation('storage.object.get_authenticated'),
  true,
  'the operation helper accepts only the authenticated object-read operation'
);

select set_config('storage.operation', 'object.get_authenticated_info', true);

select is(
  storage.allow_only_operation('object.get_authenticated_info'),
  true,
  'the operation helper accepts the authenticated object-info operation used by hosted Storage'
);

select set_config('storage.operation', 'storage.object.list', true);

select is(
  storage.allow_only_operation('storage.object.get_authenticated'),
  false,
  'the operation helper rejects object listing'
);

select set_config('storage.operation', '', true);

select * from finish();
rollback;
