begin;

create extension if not exists pgtap with schema extensions;
select plan(1);

create schema policy_harness_leak;
create table policy_harness_leak.owner_records (
  id uuid primary key,
  owner_id uuid not null,
  label text not null
);

alter table policy_harness_leak.owner_records enable row level security;
grant usage on schema policy_harness_leak to authenticated;
grant select on table policy_harness_leak.owner_records to authenticated;

-- Deliberately incorrect: this fixture must make the runner fail.
create policy owner_records_cross_owner_leak
on policy_harness_leak.owner_records
for select
to authenticated
using (true);

insert into policy_harness_leak.owner_records (id, owner_id, label)
values
  (
    'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaa1',
    '11111111-1111-4111-8111-111111111111',
    'owner-a-row'
  ),
  (
    'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbb2',
    '22222222-2222-4222-8222-222222222222',
    'owner-b-row'
  );

set local role authenticated;
set local request.jwt.claim.sub = '11111111-1111-4111-8111-111111111111';

select results_eq(
  $$select label from policy_harness_leak.owner_records order by label$$,
  array['owner-a-row']::text[],
  'intentional cross-owner leak is rejected'
);

reset role;
select * from finish();
rollback;
