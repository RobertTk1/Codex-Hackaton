begin;

set local lock_timeout = '5s';
set local statement_timeout = '30s';

create table private.outbound_events (
  id uuid primary key,
  owner_id uuid not null,
  profile_id uuid not null,
  event_type text not null,
  catalog_product_ref text not null,
  catalog_shop_ref text not null,
  catalog_variant_ref text,
  disclosure_version text not null,
  occurred_at timestamptz not null default now(),
  constraint outbound_events_owner_profile_fk
    foreign key (owner_id, profile_id)
    references public.profiles(owner_id, id)
    on update cascade
    on delete cascade
    deferrable initially immediate,
  constraint outbound_events_type_check check (
    event_type = 'retailer_handoff'
  ),
  constraint outbound_events_catalog_product_check check (
    catalog_product_ref = btrim(catalog_product_ref)
    and char_length(catalog_product_ref) between 1 and 512
    and lower(catalog_product_ref) not like 'http://%'
    and lower(catalog_product_ref) not like 'https://%'
  ),
  constraint outbound_events_catalog_shop_check check (
    catalog_shop_ref = btrim(catalog_shop_ref)
    and char_length(catalog_shop_ref) between 1 and 512
    and lower(catalog_shop_ref) not like 'http://%'
    and lower(catalog_shop_ref) not like 'https://%'
  ),
  constraint outbound_events_catalog_variant_check check (
    catalog_variant_ref is null
    or (
      catalog_variant_ref = btrim(catalog_variant_ref)
      and char_length(catalog_variant_ref) between 1 and 512
      and lower(catalog_variant_ref) not like 'http://%'
      and lower(catalog_variant_ref) not like 'https://%'
    )
  ),
  constraint outbound_events_disclosure_version_check check (
    disclosure_version = btrim(disclosure_version)
    and char_length(disclosure_version) between 1 and 80
  )
);

comment on table private.outbound_events is
  'Privacy-bounded operational evidence for confirmed retailer handoffs. Retained for 30 days; no destination URL or customer profile traits are stored.';

comment on column private.outbound_events.id is
  'Stable confirmation identifier carried inside the validated signed handoff token. Reusing the same confirmation identifier cannot create a second event; the token itself is never stored.';

alter table private.outbound_events enable row level security;

revoke all privileges on table private.outbound_events
  from public, anon, authenticated, service_role;
grant select, insert, delete on table private.outbound_events
  to service_role;

create index outbound_events_owner_profile_idx
on private.outbound_events (owner_id, profile_id);

create index outbound_events_profile_time_idx
on private.outbound_events (profile_id, occurred_at desc, id desc);

create index outbound_events_cleanup_idx
on private.outbound_events (occurred_at, id);

create function private.enforce_outbound_event_contract()
returns trigger
language plpgsql
security definer
set search_path = ''
as $function$
declare
  owner_is_anonymous boolean;
  profile_status text;
begin
  if tg_op = 'UPDATE' then
    raise exception using
      errcode = '23514',
      message = 'outbound events are immutable after creation';
  end if;

  select user_record.is_anonymous
  into owner_is_anonymous
  from auth.users as user_record
  where user_record.id = new.owner_id;

  if owner_is_anonymous is distinct from false then
    raise exception using
      errcode = '23514',
      message = 'retailer handoff events require a permanent account';
  end if;

  select profile.status
  into profile_status
  from public.profiles as profile
  where profile.owner_id = new.owner_id
    and profile.id = new.profile_id;

  if profile_status is distinct from 'active' then
    raise exception using
      errcode = '23514',
      message = 'retailer handoff events require an active owned profile';
  end if;

  return new;
end;
$function$;

comment on function private.enforce_outbound_event_contract() is
  'Restricts immutable retailer handoff evidence to permanent owners with an active matching profile.';

revoke execute on function private.enforce_outbound_event_contract()
  from public, anon, authenticated, service_role;

create trigger outbound_events_enforce_contract
before insert or update on private.outbound_events
for each row execute function private.enforce_outbound_event_contract();

commit;
