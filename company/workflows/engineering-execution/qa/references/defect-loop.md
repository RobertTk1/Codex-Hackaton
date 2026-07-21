# QA Defect and Repair Loop

## When a Case Fails

The QA session must:

1. Set the QA case to `failed`, keep `passes: false`, and attach evidence.
2. Create `company/artifacts/qa/defects/BUG-<case-id>-<sequence>.md`.
3. Record severity, affected sources, candidate revision, reproduction, expected/observed behavior, evidence, and regression risk.
4. If the failure violates an approved requirement, create or link a narrowly scoped QA-repair ticket in `engineering-plan.json` with `passes: false`.
5. Route the workflow to Developer remediation for that ticket and stop. QA must not implement the repair in the same session.

An enhancement or changed expectation is not a defect ticket; it remains blocked until an explicit product decision amends an authoritative source.

## Developer Repair

The repair ticket follows the complete Developer contract: dependency check, implementation, focused automated regression test, verification, commit, result state, and stop. It must reference the QA case and defect.

## QA Retest

After a passing repair:

- Freeze a new candidate revision.
- Rerun the original failed QA case from its documented clean state.
- Run the defect's declared regression cases or invalidate them for later selection.
- Close the defect only when the original failure and required regression scope pass.
- If it still fails, append a new attempt to the same defect unless the observed root behavior is materially different.

## Repeated Failure

After three failed repair/retest cycles, mark the defect `escalated`, preserve all attempts, and require an engineering/product decision before another repair. Escalation never converts the case to passing.
