# DevOps Task — Read During Every Release Session

Status: `ready-after-qa-gate` — do not begin until the QA final report says `PASS FOR DEVOPS`.

## Mission

Promote the exact QA-approved Magic Mirror candidate from the isolated development environment to a production DigitalOcean App Platform application that is secure, observable, recoverable, empty of test data, and ready for real customers.

## Goal

Execute the release queue one atomic task per session until the pinned production images, configuration, migrations, domain, health checks, smoke checks, monitoring, rollback evidence, and release record all pass for one identified production revision.

Developer owns deployment of every passing engineering ticket to `magic-mirror-dev`. QA validates a frozen candidate there. DevOps alone deploys to `magic-mirror-prod` after the QA release gate passes.

## Requirements

Before selecting release work, verify `FIRST_START.md` and `references/requirements.md`. At minimum:

- The QA final report says `PASS FOR DEVOPS` for one exact commit and candidate image set.
- All affected QA cases remain passing and no release blocker is open.
- The development deployment for that revision is healthy.
- DigitalOcean access, app IDs, source/image registry access, app specs, domains, and alert destinations are available.
- Production Supabase, storage, auth origins, provider credentials, and production-only configuration are mapped separately from an isolated persistent development branch or development project.
- A safe migration, data, secret, observability, and rollback plan exists.
- Release evidence/configuration is isolated on `codex/release-<release-id>` from the QA-approved commit; production still deploys the approved immutable digests rather than the branch tip.

If the QA-approved revision, image digest, environment, or production configuration cannot be proven, stop. Never deploy “the latest” and assume it is the approved release.

## Verification

The DevOps goal passes only when:

- Production runs the exact QA-approved web image digest and API/worker image digest.
- The checked-in production App Platform spec validates and matches the live non-secret configuration.
- Secrets exist only in approved secret stores and no secret appears in Git, build artifacts, browser bundles, logs, or evidence.
- Production migrations complete through the gated pre-deploy process and remain compatible with the rollback plan.
- `magic-mirror-prod` uses production Supabase and provider configuration, never development credentials or data.
- No test account, fixture row, synthetic photo, QA job, test bag, generated QA asset, or seed marker remains in production.
- App Platform reports a live deployment with passing readiness/liveness health, a running worker, configured alerts, and clean relevant logs.
- Non-mutating production smoke checks pass for HTTPS, domain, public app, API health/readiness, static assets, auth entry points, and observability.
- Any explicitly recorded real-user verification is separate from smoke testing and uses no synthetic fixture.
- The rollback target and command are validated, and database recovery limitations are explicit.
- The release record identifies URLs, app/deployment IDs, commit, image digests, migration version, timestamp, evidence, known limitations, and recovery path.

A green DigitalOcean deployment status by itself is not completion.

## Turn Contract

```text
START DEVOPS SESSION
  1. Read TASK.md, workflow tasks.json, the release queue, and the tail of progress.txt.
  2. If first release session or candidate/environment changed, read FIRST_START.md.
  3. Verify the QA-to-DevOps gate and exact frozen candidate.
  4. Select one eligible atomic release task using references/release-queue.md.
  5. Mark it in_progress; passes remains false.
  6. Read only the task's named DevOps references and source artifacts.
  7. Execute the preparation, deployment, verification, monitoring, recovery, or handoff task.
  8. Capture redacted commands, IDs, revisions, results, and evidence.
  9. Mark passes true only when every task criterion succeeds; otherwise record the blocker/failure.
 10. Update release queue and workflow summary, append progress.txt, commit safe artifacts, and stop.
END DEVOPS SESSION
```

Default rule: one release task, production deployment, rollback, or production-verification task per session. Production deployment and its immediate safety checks may remain one atomic task because stopping between traffic activation and health verification would be unsafe.

## Environment Contract

| Environment | DigitalOcean app | Deployment trigger | Data/secrets | Purpose |
| --- | --- | --- | --- | --- |
| Development | `magic-mirror-dev` | every passing engineering ticket after integration | development Supabase and sandbox/test credentials; synthetic/consented fixtures allowed | integration, ticket smoke, QA candidate |
| Production | `magic-mirror-prod` | controlled DevOps release only | production Supabase and production credentials; no test fixtures | real customers |

- Dev and prod are separate App Platform apps with separate app IDs, variables, domains, Supabase project refs/environments, storage, auth allowlists, and provider credentials where providers support separation.
- Dev may use automatic deployment from the integration branch.
- Prod must not automatically deploy arbitrary repository pushes. Deploy the QA-approved immutable image digests through the production app spec.
- A production rollback restores App Platform code/configuration but does not roll back Supabase data. Migration compatibility and database recovery are separate gates.

## Non-Negotiable Rules

- No production mutation before `PASS FOR DEVOPS`.
- Never deploy an unreviewed branch tip, mutable `latest` tag, or unverified image tag to production.
- Never point development at the production Supabase main environment or reuse development storage, OAuth origins, test credentials, or fixtures in production.
- Never commit DigitalOcean tokens, provider keys, Supabase server secrets, encrypted-value plaintext, or generated `.env` files.
- Never print secret values to logs or evidence; validate names/presence and use redacted fingerprints only when necessary.
- App specs are version-controlled and validated before application; secret values remain out of the spec.
- A failed migration stops deployment before new code receives traffic.
- Destructive schema cleanup does not ship in the same release as the compatibility change it depends on.
- Do not “fix forward” blindly when production verification fails. Stop traffic exposure where possible and use the approved rollback route.
- Do not represent rollback as database recovery. App Platform rollback restores code/config/spec, not Supabase data.
- Production smoke must not create test accounts, synthetic reports, photos, products, jobs, or bag rows.
- Required real-provider validation occurs in dev/QA. Production smoke is non-mutating unless an explicitly identified real customer performs a real action with consented data.
- Do not mark complete while deployment, health, logs, worker heartbeat, alerts, domain/TLS, or smoke evidence is missing.
- Preserve the last known-good deployment and rollback evidence.

## Progressive Disclosure Map

| File | Read it |
| --- | --- |
| `TASK.md` | every DevOps session |
| `FIRST_START.md` | first release session or changed candidate/environment |
| `references/requirements.md` | before release-queue selection |
| `references/release-queue.md` | when creating, selecting, or updating release tasks |
| `references/environments.md` | when provisioning or validating dev/prod isolation |
| `references/app-platform.md` | for DigitalOcean specs, components, jobs, domains, and deployments |
| `references/build-and-promotion.md` | when building, pinning, or promoting candidate images |
| `references/secrets-and-config.md` | for variables, credentials, CORS, Auth, and domains |
| `references/database-and-production-data.md` | for migrations, backups, seeds, and zero-test-data checks |
| `references/health-observability.md` | for health, worker, logs, alerts, and dashboards |
| `references/production-deployment.md` | for the controlled production deployment |
| `references/smoke-and-monitoring.md` | immediately after deployment and during the observation window |
| `references/rollback.md` | before production mutation and whenever verification fails |
| `references/release-record.md` | for final completion and handoff evidence |
| `references/skills.md` | when routing release support work |
| `references/research-basis.md` | only when revising DigitalOcean policy |
