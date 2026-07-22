begin;

set local lock_timeout = '5s';
set local statement_timeout = '30s';

insert into storage.buckets (
  id,
  name,
  public,
  file_size_limit,
  allowed_mime_types
)
values (
  'customer-photos',
  'customer-photos',
  false,
  15728640,
  array[
    'image/jpeg',
    'image/png',
    'image/webp',
    'image/heic',
    'image/heif'
  ]::text[]
);

create policy customer_photos_select_owned_unexpired
on storage.objects for select
to authenticated
using (
  storage.allow_only_operation('storage.object.get_authenticated')
  and bucket_id = 'customer-photos'
  and exists (
    select 1
    from public.photos as photo
    where photo.storage_path = storage.objects.name
      and photo.owner_id = (select auth.uid())
      and photo.status in (
        'accepted',
        'processing',
        'partial',
        'complete',
        'failed'
      )
      and photo.expires_at > transaction_timestamp()
  )
);

commit;
