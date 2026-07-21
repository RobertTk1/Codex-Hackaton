#!/usr/bin/env bash

set -euo pipefail

repository_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
positive_output="$(mktemp)"
negative_output="$(mktemp)"

cleanup() {
  rm -- "${positive_output}" "${negative_output}"
}

trap cleanup EXIT
cd "${repository_root}"

supabase test db --local \
  2>&1 | tee "${positive_output}"

if ! grep -Eq 'Files=3([ ,]|$)' "${positive_output}" \
  || ! grep -Eq 'Tests=69([ ,]|$)' "${positive_output}" \
  || ! grep -q 'Result: PASS' "${positive_output}"; then
  echo "Positive policy harness did not execute all 69 assertions." >&2
  exit 1
fi

set +e
supabase test db --local \
  supabase/test-fixtures/intentional_cross_owner_leak_test.sql \
  >"${negative_output}" 2>&1
negative_status="$?"
set -e

if [[ "${negative_status}" -eq 0 ]]; then
  echo "Intentional cross-owner leak unexpectedly passed." >&2
  cat "${negative_output}" >&2
  exit 1
fi

if ! grep -q "intentional cross-owner leak is rejected" "${negative_output}"; then
  echo "Negative policy fixture failed for an unexpected reason." >&2
  cat "${negative_output}" >&2
  exit 1
fi

echo "Supabase policy harness passed and rejected the intentional cross-owner leak."
