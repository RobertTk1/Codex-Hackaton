# QA Release Gate

The QA-to-DevOps transition is a separate QA work item. It evaluates one frozen candidate revision and produces `company/artifacts/qa/qa-final-report.md`.

## Pass Conditions

All conditions must be true:

1. Every mandatory user story has at least one complete passing end-to-end Browser case.
2. Every mandatory acceptance criterion, scenario, required screen/state, and approved recovery path is covered and passing.
3. Every applicable provider boundary has passing success and controlled-failure coverage, with no unresolved silent-failure path.
4. Auth, cross-owner isolation, privacy, upload/storage, and sensitive-log cases pass.
5. Applicable WCAG 2.2 AA, keyboard, responsive, and target-browser/device checks pass for mandatory journeys.
6. No open `critical` or `high` defect exists.
7. No unresolved `medium` defect exists unless a documented release exception is recorded under the rules below.
8. The full Developer regression suite passes on the same candidate revision.
9. The QA queue has no mandatory case in `pending`, `in_progress`, `blocked`, `failed`, or `invalidated` state.
10. The final report, evidence index, known low-severity defects, and release recommendation are complete.

There is no percentage shortcut for these conditions.

## Recorded Medium-Severity Exception

An exception may apply only to a non-security `medium` defect and must be recorded in the QA final report plus `company/plan.md`. It names the failed requirement, user impact, workaround, duration, repair owner/date, affected evidence, and decision owner. Exceptions cannot waive critical/high defects, failed mandatory journeys, cross-owner/privacy failures, or silent false-success behavior.

## Final Report

Include:

- Candidate revision and environment.
- Coverage by user story, scenario, state, risk, browser/device, and provider boundary.
- Passed, failed, blocked, invalidated, and skipped counts without using counts to conceal mandatory failures.
- Open/closed defects by severity and linked evidence.
- Accessibility, security/privacy, failure-observability, and regression summaries.
- Approved exceptions and known low-severity limitations.
- Explicit recommendation: `PASS FOR DEVOPS` or `FAIL — RETURN TO DEVELOPER`.

Only `PASS FOR DEVOPS` may open the DevOps stage.
