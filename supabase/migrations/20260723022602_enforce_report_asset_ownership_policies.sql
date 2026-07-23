begin;

set local lock_timeout = '5s';
set local statement_timeout = '30s';

-- Reports belong to a permanent account even though Supabase anonymous users
-- also receive the authenticated database role. Keep each policy independent
-- so no permissive-policy combination can weaken the account or owner checks.
drop policy report_runs_select_own on public.report_runs;
create policy report_runs_select_own
on public.report_runs for select
to authenticated
using (
  (select auth.uid()) is not null
  and owner_id = (select auth.uid())
  and coalesce(
    ((select auth.jwt()) ->> 'is_anonymous')::boolean,
    true
  ) is false
);

drop policy style_reports_select_own on public.style_reports;
create policy style_reports_select_own
on public.style_reports for select
to authenticated
using (
  (select auth.uid()) is not null
  and owner_id = (select auth.uid())
  and coalesce(
    ((select auth.jwt()) ->> 'is_anonymous')::boolean,
    true
  ) is false
);

drop policy report_sections_select_own on public.report_sections;
create policy report_sections_select_own
on public.report_sections for select
to authenticated
using (
  (select auth.uid()) is not null
  and owner_id = (select auth.uid())
  and coalesce(
    ((select auth.jwt()) ->> 'is_anonymous')::boolean,
    true
  ) is false
);

drop policy recommendations_select_own_permanent on public.recommendations;
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

-- Generated assets can exist during anonymous onboarding. Their boundary is
-- therefore current ownership plus logical expiry, not permanent-account state.
drop policy generated_assets_select_own_unexpired on public.generated_assets;
create policy generated_assets_select_own_unexpired
on public.generated_assets for select
to authenticated
using (
  (select auth.uid()) is not null
  and owner_id = (select auth.uid())
  and expires_at > transaction_timestamp()
);

drop policy generated_asset_sources_select_own_unexpired
on public.generated_asset_sources;
create policy generated_asset_sources_select_own_unexpired
on public.generated_asset_sources for select
to authenticated
using (
  (select auth.uid()) is not null
  and owner_id = (select auth.uid())
  and exists (
    select 1
    from public.generated_assets as asset
    where asset.id = generated_asset_sources.asset_id
      and asset.owner_id = (select auth.uid())
      and asset.expires_at > transaction_timestamp()
  )
);

commit;
