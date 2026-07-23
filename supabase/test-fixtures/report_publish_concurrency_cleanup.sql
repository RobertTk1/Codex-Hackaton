begin;

drop trigger if exists report_publish_eng029_delay on public.style_reports;
drop function if exists private.test_delay_eng029_publish();
drop function if exists private.test_call_eng029_publish();

delete from private.processing_jobs
where profile_id in (
  'c2900000-0000-4000-8000-000000000001',
  'c2900000-0000-4000-8000-000000000002'
);

delete from public.profiles
where id in (
  'c2900000-0000-4000-8000-000000000001',
  'c2900000-0000-4000-8000-000000000002'
);

commit;
