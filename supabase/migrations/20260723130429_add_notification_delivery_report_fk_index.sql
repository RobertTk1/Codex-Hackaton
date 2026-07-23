begin;

set local lock_timeout = '5s';
set local statement_timeout = '30s';

drop index private.notification_deliveries_owner_profile_idx;

create index notification_deliveries_owner_profile_report_idx
on private.notification_deliveries (owner_id, profile_id, report_id);

commit;
