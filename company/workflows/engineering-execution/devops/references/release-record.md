# Release Record and Completion

Create one release directory:

```text
company/artifacts/devops/releases/<release-id>/
  release.json
  summary.md
  app-spec-diff.md
  migration-evidence.md
  smoke-report.md
  monitoring-report.md
  rollback.md
```

Do not copy secret values or sensitive logs into the record.

## Required Release Identity

- Release ID/version and UTC timestamp.
- Git commit and QA report/candidate IDs.
- Web and API/worker image digests.
- DigitalOcean project, production app ID, deployment ID, region, and URLs.
- Production Supabase project ref and migration version, without credentials.
- App spec path/hash and reviewed live diff.

## Required Results

- QA-to-DevOps gate result.
- Build/provenance/security result.
- Secret/config-name validation result.
- Migration and zero-test-data results.
- Deployment phase and health/worker/log/alert results.
- Domain/TLS and non-mutating smoke results.
- Monitoring window result.
- Known low-severity limitations and approved medium exceptions.
- Rollback target and recovery instructions.

## Completion Gate

Mark the engineering delivery loop complete only when:

- Every release task passes for the same production deployment.
- Production is healthy and ready for real users.
- Zero prohibited test data is verified after deployment.
- No release blocker or unexplained error remains.
- The shipped revision agrees across Git, images, App Platform, QA, and release records.
- The product/operator handoff includes the production URL and operational/rollback instructions without raw credentials in documentation.

Final verdict: `PRODUCTION DEPLOYED AND VERIFIED` or `NOT RELEASED`/`ROLLED BACK`.
