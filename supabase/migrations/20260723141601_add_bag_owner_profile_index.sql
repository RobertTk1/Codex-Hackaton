begin;

set local lock_timeout = '5s';
set local statement_timeout = '30s';

create index bag_items_owner_profile_idx
on public.bag_items (owner_id, profile_id);

commit;
