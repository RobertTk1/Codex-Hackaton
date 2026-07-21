# Production Smoke and Post-Deploy Monitoring

## Non-Mutating Smoke

Because production must contain no test data, verify without creating fixtures:

- HTTPS and canonical custom/starter-domain behavior.
- Landing page, static assets, routing shell, and public well-known files.
- API `/healthz` and `/readyz` semantics.
- Auth entry screens and provider redirect configuration without completing a synthetic signup.
- Unauthenticated protected routes fail safely and reveal no data.
- Worker heartbeat and zero synthetic/test queue items.
- Relevant logs contain no unexplained errors or sensitive values.
- Deployment-live, resource, and restart alert policies are configured.

Use the in-app Browser for the public production surface and supported diagnostic tools for DigitalOcean/Supabase evidence. Do not claim complete product QA from these smoke checks; QA already proved the mutable customer journeys in dev.

## Real-User Confirmation

If an identified person chooses to become the first real production customer, record that separately as real-user activation. Use that person's real account and consented data, not a test marker, and do not delete it as fixture cleanup.

## Observation Window

After immediate smoke passes, monitor the release for the approved bounded window. Capture:

- availability/readiness and deployment state;
- API error/latency changes;
- component restarts, CPU, and memory;
- worker heartbeat/backlog without inspecting customer payloads;
- provider error categories and auth failures;
- browser console/network errors on public pages.

Any release-blocking anomaly triggers rollback or a documented halt. An unchanged page screenshot alone is not monitoring evidence.
