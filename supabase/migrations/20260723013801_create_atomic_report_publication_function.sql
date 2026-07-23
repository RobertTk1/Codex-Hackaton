begin;

set local lock_timeout = '5s';
set local statement_timeout = '30s';

create function private.publish_style_report(
  p_report_run_id uuid,
  p_title text,
  p_summary text,
  p_confidence_note text,
  p_method_version text,
  p_provider_name text,
  p_provider_model text,
  p_sections jsonb,
  p_recommendations jsonb
)
returns table (
  report_id uuid,
  owner_id uuid,
  profile_id uuid,
  version integer,
  published_at timestamptz
)
language plpgsql
security invoker
set search_path = ''
as $function$
declare
  v_run public.report_runs%rowtype;
  v_existing_report public.style_reports%rowtype;
  v_previous_report public.style_reports%rowtype;
  v_report_id uuid := gen_random_uuid();
  v_published_at timestamptz := transaction_timestamp();
  v_version integer;
begin
  if p_report_run_id is null then
    raise exception using
      errcode = '22023',
      message = 'report publication requires a report run';
  end if;

  if p_sections is null
    or jsonb_typeof(p_sections) <> 'array'
    or jsonb_array_length(p_sections) <> 3
    or exists (
      select 1
      from jsonb_array_elements(p_sections) as section(value)
      where jsonb_typeof(section.value) <> 'object'
        or not section.value ?& array['section_type', 'position', 'content']
        or section.value - array['section_type', 'position', 'content']::text[]
          <> '{}'::jsonb
    )
  then
    raise exception using
      errcode = '22023',
      message = 'report publication requires exactly three normalized sections';
  end if;

  if p_recommendations is null
    or jsonb_typeof(p_recommendations) <> 'array'
    or jsonb_array_length(p_recommendations) not between 1 and 24
    or exists (
      select 1
      from jsonb_array_elements(p_recommendations) as recommendation(value)
      where jsonb_typeof(recommendation.value) <> 'object'
        or not recommendation.value ?& array[
          'position',
          'category',
          'title',
          'rationale',
          'styling_note',
          'catalog_product_ref',
          'catalog_shop_ref',
          'catalog_variant_ref',
          'outfit_group_key',
          'outfit_group_title',
          'outfit_item_position'
        ]
        or recommendation.value - array[
          'position',
          'category',
          'title',
          'rationale',
          'styling_note',
          'catalog_product_ref',
          'catalog_shop_ref',
          'catalog_variant_ref',
          'outfit_group_key',
          'outfit_group_title',
          'outfit_item_position'
        ]::text[] <> '{}'::jsonb
    )
  then
    raise exception using
      errcode = '22023',
      message = 'report publication requires one to twenty-four normalized recommendations';
  end if;

  select run.*
  into v_run
  from public.report_runs as run
  where run.id = p_report_run_id
  for update;

  if not found then
    raise exception using
      errcode = 'P0002',
      message = 'report publication run was not found';
  end if;

  if v_run.status = 'succeeded' then
    select report.*
    into v_existing_report
    from public.style_reports as report
    where report.report_run_id = v_run.id;

    if not found then
      raise exception using
        errcode = '23514',
        message = 'succeeded report run is missing its published report';
    end if;

    return query select
      v_existing_report.id,
      v_existing_report.owner_id,
      v_existing_report.profile_id,
      v_existing_report.version,
      v_existing_report.created_at;
    return;
  end if;

  if v_run.status <> 'processing' or v_run.stage <> 'finalizing' then
    raise exception using
      errcode = '23514',
      message = 'report publication requires a processing finalizing run';
  end if;

  perform 1
  from public.profiles as owned_profile
  where owned_profile.owner_id = v_run.owner_id
  order by owned_profile.id
  for update;

  if not exists (
    select 1
    from public.profiles as profile
    where profile.id = v_run.profile_id
      and profile.owner_id = v_run.owner_id
      and profile.revision = v_run.profile_revision
      and profile.status = 'submitted'
  ) then
    raise exception using
      errcode = '23514',
      message = 'report publication requires the exact submitted profile revision';
  end if;

  select report.*
  into v_previous_report
  from public.style_reports as report
  where report.owner_id = v_run.owner_id
  order by report.version desc
  limit 1
  for update;

  if found then
    v_version := v_previous_report.version + 1;
  else
    v_version := 1;
  end if;

  insert into public.style_reports (
    id,
    owner_id,
    profile_id,
    report_run_id,
    derived_from_report_id,
    version,
    title,
    summary,
    confidence_note,
    method_version,
    provider_name,
    provider_model,
    created_at
  ) values (
    v_report_id,
    v_run.owner_id,
    v_run.profile_id,
    v_run.id,
    v_previous_report.id,
    v_version,
    p_title,
    p_summary,
    p_confidence_note,
    p_method_version,
    p_provider_name,
    p_provider_model,
    v_published_at
  );

  insert into public.report_sections (
    owner_id,
    profile_id,
    report_id,
    section_type,
    position,
    content,
    created_at
  )
  select
    v_run.owner_id,
    v_run.profile_id,
    v_report_id,
    section.section_type,
    section.position,
    section.content,
    v_published_at
  from jsonb_to_recordset(p_sections) as section(
    section_type text,
    position smallint,
    content jsonb
  );

  insert into public.recommendations (
    owner_id,
    profile_id,
    report_id,
    position,
    category,
    title,
    rationale,
    styling_note,
    catalog_product_ref,
    catalog_shop_ref,
    catalog_variant_ref,
    outfit_group_key,
    outfit_group_title,
    outfit_item_position,
    created_at
  )
  select
    v_run.owner_id,
    v_run.profile_id,
    v_report_id,
    recommendation.position,
    recommendation.category,
    recommendation.title,
    recommendation.rationale,
    recommendation.styling_note,
    recommendation.catalog_product_ref,
    recommendation.catalog_shop_ref,
    recommendation.catalog_variant_ref,
    recommendation.outfit_group_key,
    recommendation.outfit_group_title,
    recommendation.outfit_item_position,
    v_published_at
  from jsonb_to_recordset(p_recommendations) as recommendation(
    position smallint,
    category text,
    title text,
    rationale text,
    styling_note text,
    catalog_product_ref text,
    catalog_shop_ref text,
    catalog_variant_ref text,
    outfit_group_key text,
    outfit_group_title text,
    outfit_item_position smallint
  );

  update public.report_runs as run
  set
    status = 'succeeded',
    completed_at = v_published_at
  where run.id = v_run.id;

  update public.profiles as profile
  set status = 'archived'
  where profile.owner_id = v_run.owner_id
    and profile.status = 'active'
    and profile.id <> v_run.profile_id;

  update public.profiles as profile
  set status = 'active'
  where profile.owner_id = v_run.owner_id
    and profile.id = v_run.profile_id;

  insert into private.processing_jobs (
    owner_id,
    profile_id,
    kind,
    subject_id,
    idempotency_key
  ) values (
    v_run.owner_id,
    v_run.profile_id,
    'report_notification',
    v_report_id,
    'report-notification:' || v_report_id::text
  );

  set constraints
    public.style_reports_enforce_publication,
    public.report_sections_enforce_publication
    immediate;
  set constraints
    public.style_reports_enforce_publication,
    public.report_sections_enforce_publication
    deferred;

  return query select
    v_report_id,
    v_run.owner_id,
    v_run.profile_id,
    v_version,
    v_published_at;
end;
$function$;

comment on function private.publish_style_report(
  uuid, text, text, text, text, text, text, jsonb, jsonb
) is
  'Atomically publishes one complete report, activates its submitted profile, archives the prior active profile, succeeds the run, and enqueues notification delivery.';

revoke execute on function private.publish_style_report(
  uuid, text, text, text, text, text, text, jsonb, jsonb
) from public, anon, authenticated;
grant execute on function private.publish_style_report(
  uuid, text, text, text, text, text, text, jsonb, jsonb
) to service_role;

commit;
