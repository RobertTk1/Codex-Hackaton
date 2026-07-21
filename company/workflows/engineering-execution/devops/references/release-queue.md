# Release Queue and Selection

## Authority

The detailed DevOps authority is `company/artifacts/devops/release-tasks.json`. Workflow `tasks.json` stores only the DevOps stage summary and pointer.

## Minimum Task Shape

```json
{
  "id": "REL-001",
  "title": "Validate production App Platform specification",
  "kind": "preflight",
  "depends_on": [],
  "environment": "production",
  "candidate_revision": "<git-sha>",
  "mutates_production": false,
  "acceptance_criteria": [],
  "verification": [],
  "rollback": null,
  "status": "pending",
  "passes": false,
  "evidence": [],
  "notes": ""
}
```

Allowed statuses: `pending`, `in_progress`, `blocked`, `failed`, `passed`, `rolled_back`, `invalidated`.

## Required Queue Order

1. Verify QA handoff and candidate identity.
2. Validate environment isolation, DigitalOcean identity/access, and authority to adopt or provision `magic-mirror-prod`.
3. Validate checked-in dev/prod App Platform specs and drift.
4. Adopt the existing production app or provision `magic-mirror-prod` in a dedicated serialized task; record app ID, project, region, cost/config summary, domains, and empty initial state without deploying an unapproved application revision.
5. Verify pinned candidate images and software/dependency/security checks.
6. Validate secrets/configuration by name, scope, and redacted presence.
7. Verify backup/recovery and production migration compatibility.
8. Verify zero test data before deployment.
9. Execute production migration plus pinned-image deployment as one guarded release operation.
10. Verify deployment, health, worker, domain/TLS, logs, and alerts.
11. Execute non-mutating production smoke.
12. Run post-deploy observation/canary.
13. Verify zero test data again.
14. Generate release record and production-completion decision.

## State Rules

- Mark a task `in_progress` before any external mutation.
- Keep `passes: false` until every criterion and evidence requirement passes.
- Candidate, app-spec, secret-name, migration, or image drift invalidates affected passing tasks.
- A failed production deployment stays failed even if the prior release remains healthy.
- A successful rollback is `rolled_back`, not passed; create a new release candidate after repair and QA.
- Record discovered work in this queue unless it changes product scope; scope changes remain blocked until an explicit product decision updates an authoritative source.
- Apply the bounded retry and production-mutation rules in `requirements.md`; do not silently rerun a failed production action.
