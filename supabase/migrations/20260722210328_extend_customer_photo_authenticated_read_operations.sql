begin;

set local lock_timeout = '5s';
set local statement_timeout = '30s';

alter policy customer_photos_select_owned_unexpired
on storage.objects
using (
  (
    storage.allow_only_operation('storage.object.get_authenticated')
    or storage.allow_only_operation('object.get_authenticated_info')
  )
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
