begin;

set local lock_timeout = '5s';
set local statement_timeout = '30s';

create schema private authorization postgres;

comment on schema private is
  'Non-exposed operational data and narrowly granted database helpers.';

revoke all privileges on schema private from public, anon, authenticated;
grant usage on schema private to service_role;

revoke all privileges on all tables in schema private
  from public, anon, authenticated, service_role;
revoke all privileges on all sequences in schema private
  from public, anon, authenticated, service_role;
revoke execute on all functions in schema private
  from public, anon, authenticated, service_role;

alter default privileges for role postgres in schema private
  revoke all privileges on tables from public, anon, authenticated, service_role;
alter default privileges for role postgres in schema private
  revoke all privileges on sequences from public, anon, authenticated, service_role;
alter default privileges for role postgres in schema private
  revoke execute on functions from public, anon, authenticated, service_role;

create function private.set_updated_at()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $function$
begin
  new.updated_at = statement_timestamp();
  return new;
end;
$function$;

comment on function private.set_updated_at() is
  'Maintains mutable-row updated_at values when installed as a trigger.';

revoke execute on function private.set_updated_at()
  from public, anon, authenticated, service_role;

commit;
