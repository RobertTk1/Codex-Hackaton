#!/bin/sh

set -eu

: "${VITE_API_BASE_URL:?Missing required browser environment variable: VITE_API_BASE_URL}"
: "${VITE_SUPABASE_URL:?Missing required browser environment variable: VITE_SUPABASE_URL}"
: "${VITE_SUPABASE_PUBLISHABLE_KEY:?Missing required browser environment variable: VITE_SUPABASE_PUBLISHABLE_KEY}"

encode_base64() {
  printf '%s' "$1" | base64 | tr -d '\n'
}

runtime_config_path="/tmp/magic-mirror-runtime-config.js"
temporary_config_path="$(mktemp /tmp/.magic-mirror-runtime-config.XXXXXX)"

cleanup() {
  rm -f "$temporary_config_path"
}

trap cleanup EXIT HUP INT TERM
umask 077

{
  printf '%s\n' 'window.__MAGIC_MIRROR_RUNTIME_CONFIG__ = Object.freeze({'
  printf '  schemaVersion: 1,\n'
  printf '  VITE_API_BASE_URL_BASE64: "%s",\n' "$(encode_base64 "$VITE_API_BASE_URL")"
  printf '  VITE_SUPABASE_URL_BASE64: "%s",\n' "$(encode_base64 "$VITE_SUPABASE_URL")"
  printf '  VITE_SUPABASE_PUBLISHABLE_KEY_BASE64: "%s"\n' "$(encode_base64 "$VITE_SUPABASE_PUBLISHABLE_KEY")"
  printf '%s\n' '});'
} > "$temporary_config_path"

chmod 0444 "$temporary_config_path"
mv -f "$temporary_config_path" "$runtime_config_path"
trap - EXIT HUP INT TERM
