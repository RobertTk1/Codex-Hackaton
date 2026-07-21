# QA First Start

Read this once before the first QA case and again whenever the candidate revision or QA environment changes.

## 1. Verify the Engineering Handoff

- Read `company/artifacts/engineering-plan/engineering-plan.json`.
- Confirm the engineering plan remains `approved` and every required ticket is `completed` with `passes: true`.
- Run the complete Developer verification suite from a clean checkout.
- Record the candidate Git commit, build identifier, environment URL, configuration profile, and handoff evidence.
- Confirm the candidate contains no uncommitted product changes.

If any check fails, record the engineering-to-QA gate as failed and stop.

## 2. Resolve QA Sources

Confirm these sources exist and record their versions:

- `company/artifacts/prd/user-stories.json`
- `company/artifacts/prd/scenarios.feature`
- `company/artifacts/prd/screens.json`
- `company/artifacts/ui-ux-design/user-flows/`
- the approved screen/mockup and interaction-spec package
- `company/artifacts/engineering-plan/contracts/`
- `company/artifacts/engineering-plan/architecture/security.md`
- the engineering plan's declared verification and target-device inputs

## 3. Initialize the QA Authority

Create `company/artifacts/qa/qa-cases.json` using `references/case-inventory.md`. Create only the directories required by the generated inventory:

```text
company/artifacts/qa/
  qa-cases.json
  runs/
  defects/
  qa-final-report.md       # created only by the final release-gate task
```

Do not duplicate Developer ticket state inside the QA queue.

## 4. Validate the Environment

- Confirm the app starts and the candidate URL is reachable.
- Confirm the in-app Browser can open the app and interact with it.
- Prepare deterministic accounts, consented/synthetic media, reset scripts, and provider test modes.
- Confirm sensitive fixtures cannot reach production customers.
- Confirm logs and diagnostics are accessible without exposing secrets.
- Run one Browser smoke check only to validate the harness; it does not count as a user-story pass.

## 5. Freeze the Candidate

QA case results apply only to the recorded candidate commit, immutable image digests, and deployment ID. Disable automatic integration-branch redeployment or pin the QA deployment so unrelated merges cannot replace the candidate while QA runs. Any product-code, image, configuration, migration, or deployment change invalidates affected results and must create a new candidate identifier plus an explicit regression scope.
