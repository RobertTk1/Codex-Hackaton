# QA Case Inventory and Selection

## Authority

The detailed QA authority is `company/artifacts/qa/qa-cases.json`, generated only after the engineering-to-QA gate passes. Workflow `tasks.json` stores only the QA stage summary and pointer.

## Required Case Sources

Create traceable cases from:

- Every approved user story and acceptance criterion.
- Every Gherkin scenario, including negative and recovery scenarios.
- Every required screen and named interaction state.
- End-to-end user flows crossing multiple engineering tickets.
- Authentication, anonymous-to-account continuity, ownership, and privacy boundaries.
- External provider success/failure/timeout/malformed-response behavior.
- Accessibility, keyboard, responsive, target-browser/device, and reduced-motion requirements.
- Release risks and regressions named by the engineering plan.

One case may cover multiple sources, but every source must map to at least one case and every mandatory customer story needs a complete end-to-end case.

## Minimum Case Shape

```json
{
  "id": "QA-001",
  "title": "Customer completes first style report",
  "kind": "user-story-e2e",
  "priority": "must",
  "source_ids": ["US-001", "SC-001"],
  "depends_on": [],
  "preconditions": [],
  "steps": [],
  "expected_results": [],
  "fixture_refs": [],
  "environment": {},
  "status": "pending",
  "passes": false,
  "attempts": 0,
  "candidate_revision": null,
  "evidence": [],
  "defect_ids": [],
  "notes": ""
}
```

Allowed case statuses: `pending`, `in_progress`, `blocked`, `failed`, `passed`, `invalidated`.

## Selection Order

Select exactly one eligible item using this order:

1. Retest a release-blocking defect whose repair is ready.
2. Mandatory golden-path cases in approved journey order.
3. Mandatory negative, recovery, timeout, and provider-failure cases.
4. Auth, ownership, privacy, and sensitive-data cases.
5. Accessibility and target-device/browser cases.
6. Remaining `should` and `could` cases.
7. Final regression and release-gate tasks.

Within a tier, preserve queue order, then case ID.

## State Rules

- Mark the case `in_progress` before setup or Browser interaction.
- Keep `passes: false` until every expected result is proven.
- `status: passed` requires `passes: true` and evidence.
- A product defect produces `status: failed`, `passes: false`, and a defect ID.
- An unavailable prerequisite produces `status: blocked`, not failed.
- Any candidate change sets affected passing cases to `invalidated` until their regression requirement is rerun.
- Append discovered coverage with its source and rationale; do not bury it in prose.
