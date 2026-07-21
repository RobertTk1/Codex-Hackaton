#!/usr/bin/env bash

set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
smoke_port="${API_SMOKE_PORT:-43103}"
temporary_dir="$(mktemp -d)"
server_pid=""

cleanup() {
  if [[ -n "${server_pid}" ]] && kill -0 "${server_pid}" 2>/dev/null; then
    kill "${server_pid}"
    wait "${server_pid}" 2>/dev/null || true
  fi

  rm -r -- "${temporary_dir}"
}

trap cleanup EXIT

APP_BASE_URL="http://127.0.0.1:5173" \
CORS_ALLOWED_ORIGINS="http://127.0.0.1:5173" \
DECART_API_KEY="test-decart-key" \
EMAIL_DELIVERY_API_KEY="test-email-key" \
EMAIL_FROM_ADDRESS="test@magicmirror.example" \
GEMINI_API_KEY="test-gemini-key" \
HOST="127.0.0.1" \
OPENAI_API_KEY="test-openai-key" \
PORT="${smoke_port}" \
SHOPIFY_AGENT_PROFILE_URL="https://shopify.example/ucp" \
SUPABASE_SERVICE_ROLE_KEY="test-service-role-key" \
VITE_SUPABASE_PUBLISHABLE_KEY="test-publishable-key" \
VITE_SUPABASE_URL="https://project.supabase.co" \
bun run --cwd "${repo_dir}/apps/api" start \
  >"${temporary_dir}/server.log" \
  2>"${temporary_dir}/server.err" &
server_pid="$!"

for _ in {1..50}; do
  if curl --silent \
    --dump-header "${temporary_dir}/headers" \
    --output "${temporary_dir}/body" \
    "http://127.0.0.1:${smoke_port}/health"; then
    break
  fi

  if ! kill -0 "${server_pid}" 2>/dev/null; then
    cat "${temporary_dir}/server.err" >&2
    exit 1
  fi

  sleep 0.1
done

if [[ ! -f "${temporary_dir}/body" ]]; then
  echo "API health check did not become available." >&2
  exit 1
fi

expected_body='{"service":"magic-mirror-api","status":"ok"}'
actual_body="$(tr -d '\r\n' < "${temporary_dir}/body")"

if [[ "${actual_body}" != "${expected_body}" ]]; then
  echo "Unexpected API health response: ${actual_body}" >&2
  exit 1
fi

if ! grep -qi '^x-request-id: .' "${temporary_dir}/headers"; then
  echo "API health response is missing X-Request-Id." >&2
  exit 1
fi

echo "API health smoke passed."
