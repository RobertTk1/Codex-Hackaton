begin;

create extension if not exists pgtap with schema extensions;
select plan(8);

select ok(to_regrole('anon') is not null, 'anon baseline role exists');
select ok(to_regrole('authenticated') is not null, 'authenticated baseline role exists');
select ok(to_regrole('service_role') is not null, 'service_role baseline role exists');

select results_eq(
  $$
    select id
    from auth.users
    where id in (
      '11111111-1111-4111-8111-111111111111'::uuid,
      '22222222-2222-4222-8222-222222222222'::uuid
    )
    order by id
  $$,
  array[
    '11111111-1111-4111-8111-111111111111'::uuid,
    '22222222-2222-4222-8222-222222222222'::uuid
  ],
  'database reset loads both synthetic policy owners'
);

create schema policy_harness;
create table policy_harness.owner_records (
  id uuid primary key,
  owner_id uuid not null,
  label text not null
);

alter table policy_harness.owner_records enable row level security;
grant usage on schema policy_harness to authenticated;
grant select on table policy_harness.owner_records to authenticated;

create policy owner_records_select_own
on policy_harness.owner_records
for select
to authenticated
using (
  (select auth.uid()) is not null
  and owner_id = (select auth.uid())
);

insert into policy_harness.owner_records (id, owner_id, label)
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

select is(
  (
    select relrowsecurity
    from pg_class
    where oid = 'policy_harness.owner_records'::regclass
  ),
  true,
  'policy probe has row level security enabled'
);

set local role authenticated;
set local request.jwt.claim.sub = '11111111-1111-4111-8111-111111111111';

select results_eq(
  $$select label from policy_harness.owner_records order by label$$,
  array['owner-a-row']::text[],
  'owner A sees only its own row'
);

select is_empty(
  $$
    select label
    from policy_harness.owner_records
    where owner_id = '22222222-2222-4222-8222-222222222222'::uuid
  $$,
  'owner A cannot read owner B row'
);

reset role;
set local role authenticated;
set local request.jwt.claim.sub = '22222222-2222-4222-8222-222222222222';

select results_eq(
  $$select label from policy_harness.owner_records order by label$$,
  array['owner-b-row']::text[],
  'owner B sees only its own row'
);

reset role;
select * from finish();
rollback;
