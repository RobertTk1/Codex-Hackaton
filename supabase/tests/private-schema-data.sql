begin;

create extension if not exists pgtap with schema extensions;
select plan(19);

select has_schema('private', 'private schema exists');

select is(
  (
    select pg_get_userbyid(namespace.nspowner)
    from pg_namespace as namespace
    where namespace.nspname = 'private'
  ),
  'postgres',
  'postgres owns the private schema'
);

select ok(
  not has_schema_privilege('anon', 'private', 'USAGE')
  and not has_schema_privilege('anon', 'private', 'CREATE'),
  'anon cannot use or create in the private schema'
);

select ok(
  not has_schema_privilege('authenticated', 'private', 'USAGE')
  and not has_schema_privilege('authenticated', 'private', 'CREATE'),
  'authenticated cannot use or create in the private schema'
);

select ok(
  has_schema_privilege('service_role', 'private', 'USAGE')
  and not has_schema_privilege('service_role', 'private', 'CREATE'),
  'service_role receives schema usage without schema creation authority'
);

select has_function(
  'private',
  'set_updated_at',
  array[]::text[],
  'updated-at helper exists'
);

select is(
  (
    select procedure.prosecdef
    from pg_proc as procedure
    join pg_namespace as namespace on namespace.oid = procedure.pronamespace
    where namespace.nspname = 'private'
      and procedure.proname = 'set_updated_at'
      and procedure.pronargs = 0
  ),
  false,
  'updated-at helper is security invoker'
);

select ok(
  (
    select coalesce('search_path=""' = any(procedure.proconfig), false)
    from pg_proc as procedure
    join pg_namespace as namespace on namespace.oid = procedure.pronamespace
    where namespace.nspname = 'private'
      and procedure.proname = 'set_updated_at'
      and procedure.pronargs = 0
  ),
  'updated-at helper fixes an empty search path'
);

select ok(
  not has_function_privilege(
    'anon',
    'private.set_updated_at()'::regprocedure,
    'EXECUTE'
  ),
  'anon cannot execute the updated-at helper'
);

select ok(
  not has_function_privilege(
    'authenticated',
    'private.set_updated_at()'::regprocedure,
    'EXECUTE'
  ),
  'authenticated cannot execute the updated-at helper'
);

select ok(
  not has_function_privilege(
    'service_role',
    'private.set_updated_at()'::regprocedure,
    'EXECUTE'
  ),
  'service_role cannot call the trigger-only helper directly'
);

select is_empty(
  $$
    select 1
    from pg_proc as procedure
    cross join lateral aclexplode(
      coalesce(
        procedure.proacl,
        acldefault('f', procedure.proowner)
      )
    ) as privilege
    where procedure.oid = 'private.set_updated_at()'::regprocedure
      and privilege.grantee = 0
      and privilege.privilege_type = 'EXECUTE'
  $$,
  'PUBLIC has no execute privilege on the updated-at helper'
);

select is_empty(
  $$
    select procedure.oid
    from pg_proc as procedure
    join pg_namespace as namespace on namespace.oid = procedure.pronamespace
    where namespace.nspname = 'private'
      and procedure.prosecdef
  $$,
  'no security-definer helper can accept an unset verified owner context'
);

select is_empty(
  $$
    select 1
    from pg_default_acl as defaults
    cross join lateral aclexplode(defaults.defaclacl) as privilege
    where defaults.defaclnamespace = 'private'::regnamespace
      and defaults.defaclobjtype = 'f'
      and privilege.grantee = 0
      and privilege.privilege_type = 'EXECUTE'
  $$,
  'new private functions do not grant execute to PUBLIC by default'
);

select is_empty(
  $$
    select 1
    from pg_default_acl as defaults
    cross join lateral aclexplode(defaults.defaclacl) as privilege
    where defaults.defaclnamespace = 'private'::regnamespace
      and defaults.defaclobjtype in ('r', 'S')
      and privilege.grantee in (
        0,
        'anon'::regrole::oid,
        'authenticated'::regrole::oid,
        'service_role'::regrole::oid
      )
  $$,
  'new private tables and sequences receive no customer or service defaults'
);

create table private.updated_at_probe (
  id integer primary key,
  updated_at timestamptz not null
);

create trigger maintain_updated_at
before update on private.updated_at_probe
for each row execute function private.set_updated_at();

insert into private.updated_at_probe (id, updated_at)
values (1, '2000-01-01T00:00:00Z');

update private.updated_at_probe
set id = id
where id = 1;

select ok(
  (
    select updated_at > '2000-01-01T00:00:00Z'::timestamptz
    from private.updated_at_probe
    where id = 1
  ),
  'updated-at helper maintains a mutable row through a trigger'
);

grant select, update on private.updated_at_probe to service_role;

set local role service_role;

update private.updated_at_probe
set updated_at = '2000-01-01T00:00:00Z'
where id = 1;

reset role;

select ok(
  (
    select updated_at > '2000-01-01T00:00:00Z'::timestamptz
    from private.updated_at_probe
    where id = 1
  ),
  'revoked direct execution does not prevent service writes from firing the trigger'
);

select is(
  (
    select count(*)::integer
    from information_schema.tables
    where table_schema = 'private'
      and table_name <> 'updated_at_probe'
  ),
  0,
  'baseline creates no customer or operational tables'
);

select is(
  current_setting('lock_timeout'),
  '0',
  'migration lock timeout does not leak into later sessions'
);

select * from finish();
rollback;
