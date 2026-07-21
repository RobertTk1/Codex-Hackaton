# Health, Worker, Logs, and Alerts

## Health Semantics

- `/healthz` proves the API process/event loop responds. It does not call Supabase or paid providers.
- `/readyz` performs one bounded Supabase connectivity/configuration check and proves the API can safely receive traffic.
- App Platform readiness health checks stop traffic to unhealthy instances.
- Liveness checks may restart stuck services/workers and must not depend on an optional external provider that could cause a restart loop.
- Provider availability belongs in feature preflights and normalized metrics, not core readiness.

## Worker Verification

Verify the worker component is running the expected digest/command, reports a current heartbeat, can see the production queue without consuming synthetic work, and has no crash/restart loop. Do not create a test job in production.

## Logs

Review build, deploy, runtime, and crash logs for the release window. Fail on unexplained startup errors, missing configuration, repeated restarts, unhandled exceptions, authorization failures caused by configuration, migration failures, or sensitive-data logging.

Logs must include environment, component, release, request/job identifier, result, duration, provider/error category, and safe correlation fields while excluding tokens, emails, profile attributes, prompts/model bodies, transcripts, signed URLs, storage paths, and media bytes.

## Alerts

Verify alert destinations by configuration and a safe approved test mechanism. At minimum cover failed/live deployment, restart/crash, CPU, and memory. Record who receives alerts and the first response/rollback owner.

## Retention

App Platform build/deploy logs and runtime behavior have different retention characteristics. Configure external forwarding when the approved operational needs exceed native availability; do not assume dashboard logs are a durable audit archive.
