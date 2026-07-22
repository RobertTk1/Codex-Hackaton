begin;

set local lock_timeout = '5s';
set local statement_timeout = '30s';

revoke delete on table public.profiles from authenticated;

drop policy profiles_delete_own_draft on public.profiles;
drop policy profiles_insert_own on public.profiles;

create policy profiles_insert_own
on public.profiles for insert
to authenticated
with check (
  (select auth.uid()) is not null
  and owner_id = (select auth.uid())
  and status = 'draft'
);

commit;
