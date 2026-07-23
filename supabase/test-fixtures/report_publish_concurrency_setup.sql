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

insert into public.profiles (
  id, owner_id, status, current_step, revision, name, age,
  adult_confirmed_at, gender, height_cm, fit_preference, submitted_at
) values
  (
    'c2900000-0000-4000-8000-000000000001',
    '11111111-1111-4111-8111-111111111111',
    'active', 'complete', 1, 'Concurrent prior', 34,
    now(), 'woman', 165, 'regular', now()
  ),
  (
    'c2900000-0000-4000-8000-000000000002',
    '11111111-1111-4111-8111-111111111111',
    'submitted', 'complete', 1, 'Concurrent candidate', 34,
    now(), 'woman', 165, 'regular', now()
  );

insert into public.report_runs (
  id, owner_id, profile_id, profile_revision, idempotency_key
) values (
  'c2910000-0000-4000-8000-000000000001',
  '11111111-1111-4111-8111-111111111111',
  'c2900000-0000-4000-8000-000000000002',
  1,
  'report-publish-concurrency:c2910000-0000-4000-8000-000000000001'
);

update public.report_runs
set
  status='processing',
  stage='finalizing',
  attempt_count=1,
  started_at=now()
where id='c2910000-0000-4000-8000-000000000001';

create function private.test_delay_eng029_publish()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $function$
begin
  if new.report_run_id='c2910000-0000-4000-8000-000000000001'::uuid then
    perform pg_catalog.pg_sleep(1);
  end if;
  return new;
end;
$function$;

create trigger report_publish_eng029_delay
before insert on public.style_reports
for each row execute function private.test_delay_eng029_publish();

create function private.test_call_eng029_publish()
returns uuid
language sql
security invoker
set search_path = ''
as $function$
  select report_id
  from private.publish_style_report(
    'c2910000-0000-4000-8000-000000000001',
    'Concurrent style report',
    'A complete report published by two overlapping callers.',
    'These findings are interpretive styling guidance, not objective measurements.',
    'report-v1',
    'openai',
    'approved-text-model',
    '[
      {
        "section_type":"overview",
        "position":1,
        "content":{
          "style_identity":"Polished contrast",
          "summary":"Strong structure and vivid color create a confident through-line.",
          "strengths":[{"label":"Color confidence","explanation":"Saturated color supports the customer''s visible style signals."}],
          "priorities":[{"label":"Repeat structure","explanation":"Use defined silhouettes to make outfit decisions easier."}]
        }
      },
      {
        "section_type":"color",
        "position":2,
        "content":{
          "palette_name":"Electric warmth",
          "summary":"Warm brights and deep anchors create useful contrast.",
          "best_colors":[
            {"name":"Hot pink","hex":"#FF2D8D","reason":"Echoes an established favorite."},
            {"name":"Tangerine","hex":"#FF6A21","reason":"Adds vivid warmth."},
            {"name":"Inky navy","hex":"#10152F","reason":"Creates a deep neutral anchor."},
            {"name":"Cream","hex":"#FFF3D7","reason":"Softens the brightest combinations."}
          ],
          "approach_with_care":[]
        }
      },
      {
        "section_type":"body_style",
        "position":3,
        "content":{
          "kibbe_informed_family":"Balanced definition",
          "summary":"Defined waists and intentional vertical lines support the observed proportions.",
          "shape_guidance":[{"label":"Defined waist","explanation":"Try pieces that acknowledge the waist without restricting movement."}],
          "proportion_guidance":[{"label":"Long line","explanation":"Repeat a color or shape vertically to create continuity."}],
          "disclosure":"This is interpretive styling guidance, not an objective, medical, or value judgment."
        }
      }
    ]'::jsonb,
    '[
      {
        "position":1,
        "category":"dress",
        "title":"A strong column of color",
        "rationale":"A defined waist and uninterrupted color line reflect the strongest signals in the report.",
        "styling_note":"Keep the accessories graphic and minimal.",
        "catalog_product_ref":"gid://shopify/Product/eng029-concurrent",
        "catalog_shop_ref":"gid://shopify/Shop/eng029",
        "catalog_variant_ref":null,
        "outfit_group_key":null,
        "outfit_group_title":null,
        "outfit_item_position":null
      }
    ]'::jsonb
  );
$function$;

revoke execute on function private.test_call_eng029_publish()
  from public, anon, authenticated;
grant execute on function private.test_call_eng029_publish()
  to service_role;

commit;
