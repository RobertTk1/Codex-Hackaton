begin;

set local lock_timeout = '5s';
set local statement_timeout = '30s';

create table public.live_sessions (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null,
  profile_id uuid not null,
  status text not null default 'created',
  selected_recommendation_id uuid,
  catalog_product_ref text,
  catalog_shop_ref text,
  catalog_variant_ref text,
  camera_consent_record_id uuid not null,
  microphone_consent_record_id uuid,
  gemini_visual_consent_record_id uuid,
  gemini_context_mode text,
  result_set_id uuid,
  last_action_sequence bigint not null default 0,
  connection_ms integer,
  first_frame_ms integer,
  last_action_latency_ms integer,
  last_error_code text,
  started_at timestamptz,
  ended_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint live_sessions_owner_fk
    foreign key (owner_id) references auth.users(id) on delete cascade,
  constraint live_sessions_owner_profile_fk
    foreign key (owner_id, profile_id)
    references public.profiles(owner_id, id)
    on update cascade
    on delete cascade
    deferrable initially immediate,
  constraint live_sessions_owner_recommendation_fk
    foreign key (owner_id, profile_id, selected_recommendation_id)
    references public.recommendations(owner_id, profile_id, id)
    on update cascade
    on delete restrict
    deferrable initially immediate,
  constraint live_sessions_owner_camera_consent_fk
    foreign key (owner_id, camera_consent_record_id)
    references public.consent_records(owner_id, id)
    on update cascade
    on delete restrict
    deferrable initially immediate,
  constraint live_sessions_owner_microphone_consent_fk
    foreign key (owner_id, microphone_consent_record_id)
    references public.consent_records(owner_id, id)
    on update cascade
    on delete restrict
    deferrable initially immediate,
  constraint live_sessions_owner_visual_consent_fk
    foreign key (owner_id, gemini_visual_consent_record_id)
    references public.consent_records(owner_id, id)
    on update cascade
    on delete restrict
    deferrable initially immediate,
  constraint live_sessions_owner_id_key unique (owner_id, id),
  constraint live_sessions_status_check check (
    status in (
      'created',
      'connecting',
      'ready',
      'reconnecting',
      'ended',
      'failed'
    )
  ),
  constraint live_sessions_catalog_shape_check check (
    (
      catalog_product_ref is null
      and catalog_shop_ref is null
      and catalog_variant_ref is null
    )
    or (
      catalog_product_ref = btrim(catalog_product_ref)
      and char_length(catalog_product_ref) between 1 and 512
      and catalog_shop_ref = btrim(catalog_shop_ref)
      and char_length(catalog_shop_ref) between 1 and 512
      and (
        catalog_variant_ref is null
        or (
          catalog_variant_ref = btrim(catalog_variant_ref)
          and char_length(catalog_variant_ref) between 1 and 512
        )
      )
    )
  ),
  constraint live_sessions_gemini_shape_check check (
    (
      microphone_consent_record_id is null
      and gemini_visual_consent_record_id is null
      and gemini_context_mode is null
    )
    or (
      microphone_consent_record_id is not null
      and gemini_context_mode = 'structured_state'
      and gemini_visual_consent_record_id is null
    )
    or (
      microphone_consent_record_id is not null
      and gemini_context_mode = 'sampled_video'
      and gemini_visual_consent_record_id is not null
    )
  ),
  constraint live_sessions_sequence_check check (
    last_action_sequence >= 0
  ),
  constraint live_sessions_connection_ms_check check (
    connection_ms is null or connection_ms between 0 and 600000
  ),
  constraint live_sessions_first_frame_ms_check check (
    first_frame_ms is null or first_frame_ms between 0 and 600000
  ),
  constraint live_sessions_action_latency_ms_check check (
    last_action_latency_ms is null
    or last_action_latency_ms between 0 and 600000
  ),
  constraint live_sessions_error_code_check check (
    last_error_code is null
    or (
      last_error_code = btrim(last_error_code)
      and char_length(last_error_code) between 1 and 80
    )
  ),
  constraint live_sessions_timestamp_order_check check (
    (started_at is null or started_at >= created_at)
    and (ended_at is null or ended_at >= created_at)
    and (
      started_at is null
      or ended_at is null
      or ended_at >= started_at
    )
  ),
  constraint live_sessions_state_check check (
    case status
      when 'created' then
        last_action_sequence = 0
        and microphone_consent_record_id is null
        and gemini_visual_consent_record_id is null
        and gemini_context_mode is null
        and started_at is null
        and ended_at is null
        and last_error_code is null
      when 'connecting' then
        started_at is not null
        and ended_at is null
        and last_error_code is null
      when 'ready' then
        started_at is not null
        and ended_at is null
        and last_error_code is null
      when 'reconnecting' then
        started_at is not null
        and ended_at is null
      when 'ended' then
        started_at is not null
        and ended_at is not null
        and last_error_code is null
      when 'failed' then
        ended_at is not null
        and last_error_code is not null
      else false
    end
  )
);

create index live_sessions_profile_created_idx
on public.live_sessions (profile_id, created_at desc, id desc);

create index live_sessions_profile_result_set_idx
on public.live_sessions (profile_id, result_set_id)
where result_set_id is not null;

create index live_sessions_cleanup_idx
on public.live_sessions (ended_at, id)
where status in ('ended', 'failed');

create index live_sessions_owner_profile_idx
on public.live_sessions (owner_id, profile_id);

create index live_sessions_owner_recommendation_idx
on public.live_sessions (owner_id, profile_id, selected_recommendation_id)
where selected_recommendation_id is not null;

create index live_sessions_owner_camera_consent_idx
on public.live_sessions (owner_id, camera_consent_record_id);

create index live_sessions_owner_microphone_consent_idx
on public.live_sessions (owner_id, microphone_consent_record_id)
where microphone_consent_record_id is not null;

create index live_sessions_owner_visual_consent_idx
on public.live_sessions (owner_id, gemini_visual_consent_record_id)
where gemini_visual_consent_record_id is not null;

create function private.enforce_live_session_contract()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $function$
declare
  profile_status text;
  selected_recommendation public.recommendations%rowtype;
  referenced_consent public.consent_records%rowtype;
  current_consent_id uuid;
begin
  if tg_op = 'INSERT' then
    if new.status <> 'created' or new.last_action_sequence <> 0 then
      raise exception using
        errcode = '23514',
        message = 'live session must begin in created state at sequence zero';
    end if;

    select profile.status
    into profile_status
    from public.profiles as profile
    where profile.owner_id = new.owner_id
      and profile.id = new.profile_id;

    if profile_status is distinct from 'active' then
      raise exception using
        errcode = '23514',
        message = 'live session requires an active owned profile';
    end if;

    select consent.*
    into referenced_consent
    from public.consent_records as consent
    where consent.id = new.camera_consent_record_id;

    select consent.id
    into current_consent_id
    from public.consent_records as consent
    where consent.owner_id = new.owner_id
      and consent.profile_id = new.profile_id
      and consent.purpose = 'live_camera'
    order by consent.captured_at desc, consent.id desc
    limit 1;

    if referenced_consent.id is null
      or referenced_consent.owner_id <> new.owner_id
      or referenced_consent.profile_id <> new.profile_id
      or referenced_consent.purpose <> 'live_camera'
      or referenced_consent.decision <> 'granted'
      or current_consent_id is distinct from new.camera_consent_record_id
    then
      raise exception using
        errcode = '23514',
        message = 'live session creation requires current granted camera consent';
    end if;
  else
    if old.status in ('ended', 'failed') then
      raise exception using
        errcode = '23514',
        message = 'terminal live session is immutable';
    end if;

    if new.id is distinct from old.id
      or new.owner_id is distinct from old.owner_id
      or new.profile_id is distinct from old.profile_id
      or new.camera_consent_record_id
        is distinct from old.camera_consent_record_id
      or new.created_at is distinct from old.created_at
    then
      raise exception using
        errcode = '23514',
        message = 'live session identity and camera consent are immutable';
    end if;

    if not (
      new.status = old.status
      or (old.status = 'created' and new.status in ('connecting', 'failed'))
      or (
        old.status = 'connecting'
        and new.status in ('ready', 'reconnecting', 'ended', 'failed')
      )
      or (
        old.status = 'ready'
        and new.status in ('reconnecting', 'ended', 'failed')
      )
      or (
        old.status = 'reconnecting'
        and new.status in ('ready', 'ended', 'failed')
      )
    ) then
      raise exception using
        errcode = '23514',
        message = 'invalid live session state transition';
    end if;

    if new.last_action_sequence < old.last_action_sequence then
      raise exception using
        errcode = '23514',
        message = 'live action sequence cannot move backward';
    end if;

    if row(
      new.selected_recommendation_id,
      new.catalog_product_ref,
      new.catalog_shop_ref,
      new.catalog_variant_ref,
      new.result_set_id
    ) is distinct from row(
      old.selected_recommendation_id,
      old.catalog_product_ref,
      old.catalog_shop_ref,
      old.catalog_variant_ref,
      old.result_set_id
    ) and new.last_action_sequence <= old.last_action_sequence then
      raise exception using
        errcode = '23514',
        message = 'live selection change requires a fresh action sequence';
    end if;
  end if;

  if new.selected_recommendation_id is not null then
    select recommendation.*
    into selected_recommendation
    from public.recommendations as recommendation
    where recommendation.id = new.selected_recommendation_id;

    if selected_recommendation.id is null
      or selected_recommendation.owner_id <> new.owner_id
      or selected_recommendation.profile_id <> new.profile_id
      or selected_recommendation.catalog_product_ref
        is distinct from new.catalog_product_ref
      or selected_recommendation.catalog_shop_ref
        is distinct from new.catalog_shop_ref
      or selected_recommendation.catalog_variant_ref
        is distinct from new.catalog_variant_ref
    then
      raise exception using
        errcode = '23514',
        message = 'selected recommendation must match the owned stable catalog reference';
    end if;
  end if;

  if tg_op = 'INSERT'
    or row(
      new.microphone_consent_record_id,
      new.gemini_visual_consent_record_id,
      new.gemini_context_mode
    ) is distinct from row(
      old.microphone_consent_record_id,
      old.gemini_visual_consent_record_id,
      old.gemini_context_mode
    )
  then
    if new.microphone_consent_record_id is not null then
      select consent.*
      into referenced_consent
      from public.consent_records as consent
      where consent.id = new.microphone_consent_record_id;

      select consent.id
      into current_consent_id
      from public.consent_records as consent
      where consent.owner_id = new.owner_id
        and consent.profile_id = new.profile_id
        and consent.purpose = 'live_microphone'
      order by consent.captured_at desc, consent.id desc
      limit 1;

      if referenced_consent.id is null
        or referenced_consent.owner_id <> new.owner_id
        or referenced_consent.profile_id <> new.profile_id
        or referenced_consent.purpose <> 'live_microphone'
        or referenced_consent.decision <> 'granted'
        or current_consent_id
          is distinct from new.microphone_consent_record_id
      then
        raise exception using
          errcode = '23514',
          message = 'Gemini enablement requires current granted microphone consent';
      end if;
    end if;

    if new.gemini_visual_consent_record_id is not null then
      select consent.*
      into referenced_consent
      from public.consent_records as consent
      where consent.id = new.gemini_visual_consent_record_id;

      select consent.id
      into current_consent_id
      from public.consent_records as consent
      where consent.owner_id = new.owner_id
        and consent.profile_id = new.profile_id
        and consent.purpose = 'gemini_visual_context'
      order by consent.captured_at desc, consent.id desc
      limit 1;

      if referenced_consent.id is null
        or referenced_consent.owner_id <> new.owner_id
        or referenced_consent.profile_id <> new.profile_id
        or referenced_consent.purpose <> 'gemini_visual_context'
        or referenced_consent.decision <> 'granted'
        or current_consent_id
          is distinct from new.gemini_visual_consent_record_id
      then
        raise exception using
          errcode = '23514',
          message = 'sampled video requires current granted visual-context consent';
      end if;
    end if;
  end if;

  return new;
end;
$function$;

comment on function private.enforce_live_session_contract() is
  'Enforces active-profile creation, purpose-specific current consent, bounded transitions, recommendation lineage, and monotonic live action state.';

revoke execute on function private.enforce_live_session_contract()
  from public, anon, authenticated, service_role;

create trigger live_sessions_enforce_contract
before insert or update on public.live_sessions
for each row execute function private.enforce_live_session_contract();

create trigger live_sessions_set_updated_at
before update on public.live_sessions
for each row execute function private.set_updated_at();

alter table public.live_sessions enable row level security;

revoke all privileges on table public.live_sessions
  from public, anon, authenticated, service_role;

grant select on table public.live_sessions to authenticated;
grant select, insert, update, delete on table public.live_sessions
  to service_role;

create policy live_sessions_select_own_permanent
on public.live_sessions for select
to authenticated
using (
  (select auth.uid()) is not null
  and owner_id = (select auth.uid())
  and coalesce(
    (select (auth.jwt() ->> 'is_anonymous')::boolean),
    true
  ) is false
);

comment on table public.live_sessions is
  'Bounded live styling state with consent lineage, stable catalog references, monotonic action sequence, and aggregate latency only.';

commit;
