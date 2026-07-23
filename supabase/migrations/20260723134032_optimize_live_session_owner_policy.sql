begin;

set local lock_timeout = '5s';
set local statement_timeout = '30s';

drop policy live_sessions_select_own_permanent
on public.live_sessions;

create policy live_sessions_select_own_permanent
on public.live_sessions for select
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
