# QA Environment and Fixtures

## Candidate Environment

Use an environment representative of release configuration without using unrelated production customer data. Record:

- Git commit and build ID.
- Application URL and configuration profile.
- Database migration/version state.
- Provider mode: live, sandbox, controlled stub, or failure injection.
- Browser, viewport/device, network profile, and locale/time zone when relevant.

## Fixture Classes

Prepare isolated fixtures for:

- Anonymous visitor with no prior state.
- Anonymous visitor with an in-progress profile.
- New account created by Google and magic link.
- Returning account with report, suggestions, and bag state.
- A second unrelated account for ownership-isolation tests.
- Consented founder photos and approved synthetic media.
- Valid, invalid, duplicate, oversized, unsupported, partial, and unavailable data states.
- Provider success, slow, timeout, authentication failure, malformed response, partial response, and unavailable-product states.

## Reset Contract

- Every case declares its starting fixture and cleanup/reset action.
- Reset only QA-owned rows, files, sessions, and provider artifacts.
- Use unique case/run identifiers so parallel or repeated runs cannot collide.
- Do not make case order significant.
- If deterministic reset is impossible, block the case and file a testability defect rather than accepting a flaky result.

## Live Providers

Use controlled responses for deterministic negative coverage and a minimal live-provider smoke case for required integrations. Never claim a provider works from a mock alone. Never perform destructive or chargeable live actions beyond the approved test scope.
