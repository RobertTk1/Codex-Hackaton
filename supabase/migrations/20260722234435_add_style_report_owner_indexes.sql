begin;

set local lock_timeout = '5s';
set local statement_timeout = '30s';

create index style_reports_owner_profile_run_idx
on public.style_reports (owner_id, profile_id, report_run_id);

create index report_sections_owner_profile_report_idx
on public.report_sections (owner_id, profile_id, report_id);

commit;
