begin;

set local lock_timeout = '5s';
set local statement_timeout = '30s';

drop policy recommendations_select_own_permanent
on public.recommendations;

create policy recommendations_select_own_permanent
on public.recommendations for select
to authenticated
using (
  (select auth.uid()) is not null
  and owner_id = (select auth.uid())
  and coalesce(
    ((select auth.jwt()) ->> 'is_anonymous')::boolean,
    true
  ) is false
);

commit;
