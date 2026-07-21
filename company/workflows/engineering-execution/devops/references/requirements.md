# DevOps Requirements

## QA-to-DevOps Gate

All conditions must be true:

1. `company/artifacts/qa/qa-final-report.md` says `PASS FOR DEVOPS`.
2. The report identifies one commit, dev deployment ID, web image digest, and API/worker image digest.
3. Every mandatory QA case is passing for that candidate and no critical/high defect is open.
4. Any permitted medium exception is completely recorded under the QA release gate.
5. The full Developer regression suite and final dev deployment remain passing.
6. The production app, Supabase project, provider configuration, domain, alerts, and rollback ownership are resolved.

No pass-rate percentage substitutes for these conditions.

## Per-Task Eligibility

A release task is eligible only when:

- Every dependency is complete and passing.
- Its target environment and exact candidate are identified.
- Required credentials/permissions exist without exposing their values.
- Its command, verification, rollback, and evidence paths are explicit.
- It does not overlap another active production writer.
- It fits one safe atomic session or is decomposed before execution.

Production mutation tasks are serialized. Read-only preparation and review may happen earlier but cannot count as a release.

## Stop Conditions

Stop for candidate drift, failed QA gate, spec drift, missing backup/rollback path, secret exposure, unsafe migration, unknown production data ownership, test data in prod, unhealthy deployment, missing worker, broken domain/TLS, or unexplained runtime/provider errors.
