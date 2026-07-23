#!/usr/bin/env bash

set -euo pipefail

repository_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
first_output="$(mktemp)"
second_output="$(mktemp)"

database_url="$({ supabase status -o json 2>/dev/null || true; } | jq -er '.DB_URL')"

cleanup() {
  psql "${database_url}" \
    --no-psqlrc \
    --set ON_ERROR_STOP=1 \
    --file "${repository_root}/supabase/test-fixtures/report_publish_concurrency_cleanup.sql" \
    >/dev/null
  rm -- "${first_output}" "${second_output}"
}

trap cleanup EXIT

psql "${database_url}" \
  --no-psqlrc \
  --set ON_ERROR_STOP=1 \
  --file "${repository_root}/supabase/test-fixtures/report_publish_concurrency_setup.sql" \
  >/dev/null

psql "${database_url}" \
  --no-psqlrc \
  --quiet \
  --tuples-only \
  --no-align \
  --set ON_ERROR_STOP=1 \
  --command "set role service_role; select private.test_call_eng029_publish();" \
  >"${first_output}" &
first_pid="$!"

psql "${database_url}" \
  --no-psqlrc \
  --quiet \
  --tuples-only \
  --no-align \
  --set ON_ERROR_STOP=1 \
  --command "set role service_role; select private.test_call_eng029_publish();" \
  >"${second_output}" &
second_pid="$!"

wait "${first_pid}"
wait "${second_pid}"

first_report_id="$(tr -d '[:space:]' <"${first_output}")"
second_report_id="$(tr -d '[:space:]' <"${second_output}")"

if [[ -z "${first_report_id}" || "${first_report_id}" != "${second_report_id}" ]]; then
  echo "Concurrent publication callers did not resolve to the same report." >&2
  exit 1
fi

verification="$(psql "${database_url}" \
  --no-psqlrc \
  --quiet \
  --tuples-only \
  --no-align \
  --set ON_ERROR_STOP=1 \
  --command "
    select concat_ws('|',
      (select count(*) from public.style_reports where report_run_id='c2910000-0000-4000-8000-000000000001'),
      (select count(*) from public.recommendations where profile_id='c2900000-0000-4000-8000-000000000002'),
      (select count(*) from private.processing_jobs where kind='report_notification' and profile_id='c2900000-0000-4000-8000-000000000002'),
      (select status from public.report_runs where id='c2910000-0000-4000-8000-000000000001'),
      (select status from public.profiles where id='c2900000-0000-4000-8000-000000000001'),
      (select status from public.profiles where id='c2900000-0000-4000-8000-000000000002')
    );
  " | tr -d '[:space:]')"

if [[ "${verification}" != "1|1|1|succeeded|archived|active" ]]; then
  echo "Concurrent report publication left an invalid lifecycle state: ${verification}" >&2
  exit 1
fi

echo "Concurrent report publication produced one report, one notification, and one active profile."
