begin;

set local lock_timeout = '5s';
set local statement_timeout = '30s';

create function private.valid_report_section_content(
  p_section_type text,
  p_content jsonb
)
returns boolean
language plpgsql
immutable
strict
security invoker
set search_path = ''
as $function$
declare
  item jsonb;
  item_text text;
  item_count integer;
begin
  if pg_catalog.jsonb_typeof(p_content) <> 'object' then
    return false;
  end if;

  if p_section_type = 'overview' then
    if not p_content ?& array[
      'style_identity', 'summary', 'strengths', 'priorities'
    ] or (
      p_content - array[
        'style_identity', 'summary', 'strengths', 'priorities'
      ]::text[]
    ) <> '{}'::jsonb then
      return false;
    end if;

    if pg_catalog.jsonb_typeof(p_content -> 'style_identity') <> 'string'
      or pg_catalog.jsonb_typeof(p_content -> 'summary') <> 'string'
      or pg_catalog.jsonb_typeof(p_content -> 'strengths') <> 'array'
      or pg_catalog.jsonb_typeof(p_content -> 'priorities') <> 'array'
    then
      return false;
    end if;

    item_text := p_content ->> 'style_identity';
    if item_text <> pg_catalog.btrim(item_text)
      or pg_catalog.char_length(item_text) not between 1 and 120
    then
      return false;
    end if;

    item_text := p_content ->> 'summary';
    if item_text <> pg_catalog.btrim(item_text)
      or pg_catalog.char_length(item_text) not between 1 and 2000
    then
      return false;
    end if;

    foreach item_text in array array['strengths', 'priorities'] loop
      item_count := pg_catalog.jsonb_array_length(p_content -> item_text);
      if item_count not between 1 and 6 then
        return false;
      end if;

      for item in
        select element.value
        from pg_catalog.jsonb_array_elements(p_content -> item_text) as element(value)
      loop
        if pg_catalog.jsonb_typeof(item) <> 'object'
          or not item ?& array['label', 'explanation']
          or (item - array['label', 'explanation']::text[]) <> '{}'::jsonb
          or pg_catalog.jsonb_typeof(item -> 'label') <> 'string'
          or pg_catalog.jsonb_typeof(item -> 'explanation') <> 'string'
          or (item ->> 'label') <> pg_catalog.btrim(item ->> 'label')
          or pg_catalog.char_length(item ->> 'label') not between 1 and 80
          or (item ->> 'explanation') <> pg_catalog.btrim(item ->> 'explanation')
          or pg_catalog.char_length(item ->> 'explanation') not between 1 and 500
        then
          return false;
        end if;
      end loop;
    end loop;

    return true;
  end if;

  if p_section_type = 'color' then
    if not p_content ?& array[
      'palette_name', 'summary', 'best_colors', 'approach_with_care'
    ] or (
      p_content - array[
        'palette_name', 'summary', 'best_colors', 'approach_with_care'
      ]::text[]
    ) <> '{}'::jsonb then
      return false;
    end if;

    if pg_catalog.jsonb_typeof(p_content -> 'palette_name') <> 'string'
      or pg_catalog.jsonb_typeof(p_content -> 'summary') <> 'string'
      or pg_catalog.jsonb_typeof(p_content -> 'best_colors') <> 'array'
      or pg_catalog.jsonb_typeof(p_content -> 'approach_with_care') <> 'array'
    then
      return false;
    end if;

    item_text := p_content ->> 'palette_name';
    if item_text <> pg_catalog.btrim(item_text)
      or pg_catalog.char_length(item_text) not between 1 and 120
    then
      return false;
    end if;

    item_text := p_content ->> 'summary';
    if item_text <> pg_catalog.btrim(item_text)
      or pg_catalog.char_length(item_text) not between 1 and 2000
    then
      return false;
    end if;

    foreach item_text in array array['best_colors', 'approach_with_care'] loop
      item_count := pg_catalog.jsonb_array_length(p_content -> item_text);
      if (item_text = 'best_colors' and item_count not between 4 and 12)
        or (item_text = 'approach_with_care' and item_count not between 0 and 6)
      then
        return false;
      end if;

      for item in
        select element.value
        from pg_catalog.jsonb_array_elements(p_content -> item_text) as element(value)
      loop
        if pg_catalog.jsonb_typeof(item) <> 'object'
          or not item ?& array['name', 'hex', 'reason']
          or (item - array['name', 'hex', 'reason']::text[]) <> '{}'::jsonb
          or pg_catalog.jsonb_typeof(item -> 'name') <> 'string'
          or pg_catalog.jsonb_typeof(item -> 'hex') <> 'string'
          or pg_catalog.jsonb_typeof(item -> 'reason') <> 'string'
          or (item ->> 'name') <> pg_catalog.btrim(item ->> 'name')
          or pg_catalog.char_length(item ->> 'name') not between 1 and 80
          or (item ->> 'hex') !~ '^#[0-9A-Fa-f]{6}$'
          or (item ->> 'reason') <> pg_catalog.btrim(item ->> 'reason')
          or pg_catalog.char_length(item ->> 'reason') not between 1 and 500
        then
          return false;
        end if;
      end loop;
    end loop;

    return true;
  end if;

  if p_section_type = 'body_style' then
    if not p_content ?& array[
      'kibbe_informed_family', 'summary', 'shape_guidance',
      'proportion_guidance', 'disclosure'
    ] or (
      p_content - array[
        'kibbe_informed_family', 'summary', 'shape_guidance',
        'proportion_guidance', 'disclosure'
      ]::text[]
    ) <> '{}'::jsonb then
      return false;
    end if;

    if pg_catalog.jsonb_typeof(p_content -> 'kibbe_informed_family') <> 'string'
      or pg_catalog.jsonb_typeof(p_content -> 'summary') <> 'string'
      or pg_catalog.jsonb_typeof(p_content -> 'shape_guidance') <> 'array'
      or pg_catalog.jsonb_typeof(p_content -> 'proportion_guidance') <> 'array'
      or pg_catalog.jsonb_typeof(p_content -> 'disclosure') <> 'string'
    then
      return false;
    end if;

    item_text := p_content ->> 'kibbe_informed_family';
    if item_text <> pg_catalog.btrim(item_text)
      or pg_catalog.char_length(item_text) not between 1 and 120
    then
      return false;
    end if;

    item_text := p_content ->> 'summary';
    if item_text <> pg_catalog.btrim(item_text)
      or pg_catalog.char_length(item_text) not between 1 and 2000
    then
      return false;
    end if;

    item_text := p_content ->> 'disclosure';
    if item_text <> pg_catalog.btrim(item_text)
      or pg_catalog.char_length(item_text) not between 1 and 500
    then
      return false;
    end if;

    foreach item_text in array array['shape_guidance', 'proportion_guidance'] loop
      item_count := pg_catalog.jsonb_array_length(p_content -> item_text);
      if item_count not between 1 and 8 then
        return false;
      end if;

      for item in
        select element.value
        from pg_catalog.jsonb_array_elements(p_content -> item_text) as element(value)
      loop
        if pg_catalog.jsonb_typeof(item) <> 'object'
          or not item ?& array['label', 'explanation']
          or (item - array['label', 'explanation']::text[]) <> '{}'::jsonb
          or pg_catalog.jsonb_typeof(item -> 'label') <> 'string'
          or pg_catalog.jsonb_typeof(item -> 'explanation') <> 'string'
          or (item ->> 'label') <> pg_catalog.btrim(item ->> 'label')
          or pg_catalog.char_length(item ->> 'label') not between 1 and 80
          or (item ->> 'explanation') <> pg_catalog.btrim(item ->> 'explanation')
          or pg_catalog.char_length(item ->> 'explanation') not between 1 and 500
        then
          return false;
        end if;
      end loop;
    end loop;

    return true;
  end if;

  return false;
end;
$function$;

comment on function private.valid_report_section_content(text, jsonb) is
  'Validates one bounded exact report-section shape without retaining raw model output.';

revoke execute on function private.valid_report_section_content(text, jsonb)
  from public, anon, authenticated;
grant execute on function private.valid_report_section_content(text, jsonb)
  to service_role;

create table public.style_reports (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null,
  profile_id uuid not null,
  report_run_id uuid not null,
  derived_from_report_id uuid,
  version integer not null,
  title text not null,
  summary text not null,
  confidence_note text not null,
  method_version text not null,
  provider_name text not null,
  provider_model text not null,
  created_at timestamptz not null default now(),
  constraint style_reports_owner_fk
    foreign key (owner_id) references auth.users(id) on delete cascade,
  constraint style_reports_owner_profile_fk
    foreign key (owner_id, profile_id)
    references public.profiles(owner_id, id)
    on update cascade
    on delete cascade
    deferrable initially immediate,
  constraint style_reports_owner_profile_run_fk
    foreign key (owner_id, profile_id, report_run_id)
    references public.report_runs(owner_id, profile_id, id)
    on update cascade
    on delete cascade
    deferrable initially immediate,
  constraint style_reports_derived_from_fk
    foreign key (derived_from_report_id)
    references public.style_reports(id)
    on delete set null,
  constraint style_reports_owner_id_key unique (owner_id, id),
  constraint style_reports_owner_profile_id_key
    unique (owner_id, profile_id, id),
  constraint style_reports_version_check check (version >= 1),
  constraint style_reports_title_check check (
    title = btrim(title) and char_length(title) between 1 and 120
  ),
  constraint style_reports_summary_check check (
    summary = btrim(summary) and char_length(summary) between 1 and 2000
  ),
  constraint style_reports_confidence_note_check check (
    confidence_note = btrim(confidence_note)
    and char_length(confidence_note) between 1 and 500
  ),
  constraint style_reports_method_version_check check (
    method_version = btrim(method_version)
    and char_length(method_version) between 1 and 80
  ),
  constraint style_reports_provider_name_check check (
    provider_name = btrim(provider_name)
    and char_length(provider_name) between 1 and 80
  ),
  constraint style_reports_provider_model_check check (
    provider_model = btrim(provider_model)
    and char_length(provider_model) between 1 and 160
  )
);

create unique index style_reports_owner_version_idx
on public.style_reports (owner_id, version);

create index style_reports_derived_idx
on public.style_reports (derived_from_report_id)
where derived_from_report_id is not null;

create unique index style_reports_run_idx
on public.style_reports (report_run_id);

create table public.report_sections (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null,
  profile_id uuid not null,
  report_id uuid not null,
  section_type text not null,
  position smallint not null,
  content jsonb not null,
  created_at timestamptz not null default now(),
  constraint report_sections_owner_fk
    foreign key (owner_id) references auth.users(id) on delete cascade,
  constraint report_sections_owner_profile_fk
    foreign key (owner_id, profile_id)
    references public.profiles(owner_id, id)
    on update cascade
    on delete cascade
    deferrable initially immediate,
  constraint report_sections_owner_profile_report_fk
    foreign key (owner_id, profile_id, report_id)
    references public.style_reports(owner_id, profile_id, id)
    on update cascade
    on delete cascade
    deferrable initially immediate,
  constraint report_sections_report_type_key unique (report_id, section_type),
  constraint report_sections_section_type_check check (
    section_type in ('overview', 'color', 'body_style')
  ),
  constraint report_sections_position_check check (position between 1 and 3),
  constraint report_sections_canonical_order_check check (
    (section_type = 'overview' and position = 1)
    or (section_type = 'color' and position = 2)
    or (section_type = 'body_style' and position = 3)
  ),
  constraint report_sections_content_check check (
    private.valid_report_section_content(section_type, content)
  )
);

create unique index report_sections_report_position_idx
on public.report_sections (report_id, position);

create function private.enforce_style_report_insert_contract()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $function$
declare
  run_status text;
  run_stage text;
  profile_status text;
  previous_report_id uuid;
  previous_version integer;
begin
  perform 1
  from public.profiles as owned_profile
  where owned_profile.owner_id = new.owner_id
  order by owned_profile.id
  for update;

  select run.status, run.stage, profile.status
  into run_status, run_stage, profile_status
  from public.report_runs as run
  join public.profiles as profile
    on profile.owner_id = run.owner_id
   and profile.id = run.profile_id
  where run.id = new.report_run_id
    and run.owner_id = new.owner_id
    and run.profile_id = new.profile_id
  for update of run;

  if run_status is null then
    raise exception using
      errcode = '23514',
      message = 'style report must belong to one owned report run';
  end if;

  if run_status <> 'processing' or run_stage <> 'finalizing' then
    raise exception using
      errcode = '23514',
      message = 'style report publication requires a finalizing report run';
  end if;

  if profile_status <> 'submitted' then
    raise exception using
      errcode = '23514',
      message = 'style report publication requires a submitted profile';
  end if;

  select report.id, report.version
  into previous_report_id, previous_version
  from public.style_reports as report
  where report.owner_id = new.owner_id
  order by report.version desc
  limit 1;

  if previous_report_id is null then
    if new.version <> 1 or new.derived_from_report_id is not null then
      raise exception using
        errcode = '23514',
        message = 'first owner report must use version one without prior lineage';
    end if;
  elsif new.version <> previous_version + 1
    or new.derived_from_report_id is distinct from previous_report_id
  then
    raise exception using
      errcode = '23514',
      message = 'owner report version and lineage must advance exactly once';
  end if;

  return new;
end;
$function$;

comment on function private.enforce_style_report_insert_contract() is
  'Serializes report publication per owner and enforces exact run, profile, version, and prior-report lineage.';

revoke execute on function private.enforce_style_report_insert_contract()
  from public, anon, authenticated, service_role;

create function private.prevent_style_report_mutation()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $function$
begin
  if pg_catalog.pg_trigger_depth() > 1
    and old.derived_from_report_id is not null
    and new.derived_from_report_id is null
    and row(
      new.id, new.owner_id, new.profile_id, new.report_run_id, new.version,
      new.title, new.summary, new.confidence_note, new.method_version,
      new.provider_name, new.provider_model, new.created_at
    ) is not distinct from row(
      old.id, old.owner_id, old.profile_id, old.report_run_id, old.version,
      old.title, old.summary, old.confidence_note, old.method_version,
      old.provider_name, old.provider_model, old.created_at
    )
  then
    return new;
  end if;

  raise exception using
    errcode = '23514',
    message = 'published style reports are immutable';
end;
$function$;

comment on function private.prevent_style_report_mutation() is
  'Rejects report updates while permitting only the nested FK lineage nulling required by deletion.';

revoke execute on function private.prevent_style_report_mutation()
  from public, anon, authenticated, service_role;

create function private.prevent_report_section_mutation()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $function$
begin
  raise exception using
    errcode = '23514',
    message = 'published report sections are immutable';
end;
$function$;

comment on function private.prevent_report_section_mutation() is
  'Rejects every update to normalized published section content or lineage.';

revoke execute on function private.prevent_report_section_mutation()
  from public, anon, authenticated, service_role;

create function private.enforce_style_report_publication()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $function$
declare
  affected_report_id uuid;
  section_count integer;
  report_run_status text;
  report_run_stage text;
begin
  if tg_table_name = 'style_reports' then
    affected_report_id := case when tg_op = 'DELETE' then old.id else new.id end;
  else
    affected_report_id := case when tg_op = 'DELETE' then old.report_id else new.report_id end;
  end if;

  if not exists (
    select 1 from public.style_reports where id = affected_report_id
  ) then
    return null;
  end if;

  select count(*)
  into section_count
  from public.report_sections
  where report_id = affected_report_id;

  if section_count <> 3 or not exists (
    select 1
    from public.report_sections
    where report_id = affected_report_id
      and section_type = 'overview'
      and position = 1
  ) or not exists (
    select 1
    from public.report_sections
    where report_id = affected_report_id
      and section_type = 'color'
      and position = 2
  ) or not exists (
    select 1
    from public.report_sections
    where report_id = affected_report_id
      and section_type = 'body_style'
      and position = 3
  ) then
    raise exception using
      errcode = '23514',
      message = 'published style report requires exactly one valid section of each type';
  end if;

  select run.status, run.stage
  into report_run_status, report_run_stage
  from public.style_reports as report
  join public.report_runs as run on run.id = report.report_run_id
  where report.id = affected_report_id;

  if report_run_status <> 'succeeded' or report_run_stage <> 'finalizing' then
    raise exception using
      errcode = '23514',
      message = 'published style report requires one succeeded finalizing run';
  end if;

  return null;
end;
$function$;

comment on function private.enforce_style_report_publication() is
  'At transaction completion, rejects reports without the exact three-section document and a succeeded finalizing run.';

revoke execute on function private.enforce_style_report_publication()
  from public, anon, authenticated, service_role;

create trigger style_reports_enforce_insert_contract
before insert on public.style_reports
for each row execute function private.enforce_style_report_insert_contract();

create trigger style_reports_prevent_mutation
before update on public.style_reports
for each row execute function private.prevent_style_report_mutation();

create trigger report_sections_prevent_mutation
before update on public.report_sections
for each row execute function private.prevent_report_section_mutation();

create constraint trigger style_reports_enforce_publication
after insert or update on public.style_reports
deferrable initially deferred
for each row execute function private.enforce_style_report_publication();

create constraint trigger report_sections_enforce_publication
after insert or update or delete on public.report_sections
deferrable initially deferred
for each row execute function private.enforce_style_report_publication();

alter table public.style_reports enable row level security;
alter table public.report_sections enable row level security;

revoke all privileges on table public.style_reports
  from public, anon, authenticated, service_role;
revoke all privileges on table public.report_sections
  from public, anon, authenticated, service_role;

grant select on table public.style_reports to authenticated;
grant select on table public.report_sections to authenticated;
grant select, insert, update, delete on table public.style_reports to service_role;
grant select, insert, update, delete on table public.report_sections to service_role;

create policy style_reports_select_own
on public.style_reports for select
to authenticated
using (
  (select auth.uid()) is not null
  and owner_id = (select auth.uid())
);

create policy report_sections_select_own
on public.report_sections for select
to authenticated
using (
  (select auth.uid()) is not null
  and owner_id = (select auth.uid())
);

comment on table public.style_reports is
  'Immutable owner-versioned style report documents; normalized sections are stored separately and raw model output is forbidden.';

comment on table public.report_sections is
  'Exactly three immutable typed sections per published style report in canonical order.';

commit;
