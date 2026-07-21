# Rollback and Recovery

## Before Every Production Deploy

Record:

- Current live deployment ID and component digests.
- DigitalOcean rollback eligibility and validation result.
- Current app spec and relevant non-secret configuration diff.
- Database migration version, compatibility window, and recovery/backup reference.
- Operator and exact rollback command/API route.

DigitalOcean can roll back to recent successful deployments when region/database/configuration constraints permit. Validate the chosen target rather than assuming it is available.

## Rollback Trigger

Rollback for site/API unavailability, failed readiness, worker crash loop, auth/configuration breakage, secret exposure, cross-owner risk, severe latency/resource regression, failed mandatory production smoke, or any critical/high post-release failure.

## Execution

1. Pause further automatic production deployments.
2. Roll back to the recorded successful deployment.
3. Wait for rollback deployment to become live.
4. Rerun health, worker, log, domain/TLS, and non-mutating smoke checks.
5. Record rollback deployment ID and user impact.
6. Mark the release `rolled_back`, not passed.
7. Route product/config repairs through the appropriate Developer/QA/release gates.

## Database Boundary

App Platform rollback restores code, configuration, and app spec, but not Supabase data. Prefer backward-compatible migrations so old code remains safe. Database restore or corrective migration is a separate high-risk task requiring exact targets, backup evidence, and explicit engineering/release authority.
