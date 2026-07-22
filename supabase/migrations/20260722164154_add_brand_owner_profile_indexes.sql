begin;

set local lock_timeout = '5s';
set local statement_timeout = '30s';

create index favorite_brands_owner_profile_idx
on public.favorite_brands (owner_id, profile_id);

create index brand_sizes_owner_profile_idx
on public.brand_sizes (owner_id, profile_id);

commit;
