# Controlled Production Deployment

This is one atomic production-mutation task. Do not start it unless the complete preflight queue passes and enough time remains to verify or roll back safely.

## Before Mutation

- Reconfirm QA candidate commit and both image digests.
- Reconfirm target `magic-mirror-prod` app ID and production Supabase project ref.
- Validate and propose the production app spec; review the full diff and cost.
- Record current live deployment ID, code/config/spec, image digests, health, and rollback eligibility.
- Confirm production migration compatibility and recovery plan.
- Confirm alert recipient and operator availability.
- Confirm zero prohibited test data.

## Deploy

1. Run the gated production migration job/command.
2. Verify the applied migration version before traffic promotion.
3. Apply the production spec with the QA-approved web/API digests.
4. Wait for the DigitalOcean deployment to reach the live phase; do not detach and assume success.
5. Verify the live deployment reports the intended release, spec, component digests, domain, and region.
6. Run immediate health, worker, log, and non-mutating smoke checks.

## Failure

- Migration failure: do not promote new code; preserve logs and follow database recovery guidance.
- Build/deploy failure before live: leave the last live deployment serving traffic; capture deployment logs.
- Health/smoke failure after live: initiate the reviewed rollback unless a bounded investigation proves a safe configuration-only correction within the task.
- Never change product code directly in production. A code defect returns through Developer and QA.

Record all DigitalOcean command/API results using redacted output, app/deployment IDs, phase, timestamps, and evidence paths.
