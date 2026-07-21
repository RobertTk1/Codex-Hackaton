# Secrets and Production Configuration

## Storage

- Store DigitalOcean deployment tokens in the approved operator/CI secret store, not App Platform app variables or the repository.
- Store App Platform runtime secrets as encrypted `SECRET` variables with the narrowest `RUN_TIME`, `BUILD_TIME`, or `RUN_AND_BUILD_TIME` scope.
- Use environment-specific credentials and least privilege.
- Preserve encrypted values when resubmitting a live app spec; never replace them with blank or development values.

## Browser-Safe Variables

Only approved browser configuration may use the `VITE_` prefix, including the Supabase URL/publishable key and public API base URL. A production bundle scan must prove server/provider secrets are absent.

## Server-Only Variables

Validate the required names from architecture/contracts, including Supabase server credential, OpenAI, Gemini, Decart, email delivery, Shopify profile, application base URL, and CORS allowlist. Do not print their values.

## Environment Correctness

Verify:

- Prod variables reference only production URLs, projects, buckets, domains, and credentials.
- Dev variables reference only development/test boundaries.
- CORS is an exact origin allowlist.
- Supabase Auth redirect URLs and Google OAuth origins include the final production domain and exclude unapproved wildcard origins.
- Provider callbacks/profile URLs use HTTPS production paths.
- `NODE_ENV`/environment labels and release identifier are correct.

## Rotation and Exposure

If any secret appears in Git, a build, browser bundle, log, screenshot, or evidence artifact, stop the release, revoke/rotate it, remove the exposure safely, and rerun affected verification. Redaction alone does not repair a leaked credential.
