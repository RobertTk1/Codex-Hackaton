# QA Evidence and Severity

## Evidence Package

Store each attempt under:

```text
company/artifacts/qa/runs/<case-id>/<attempt-id>/
  report.md
  screenshots/
  diagnostics/           # redacted console/network/log/measurement exports when needed
```

The report must contain:

- Case ID, title, kind, source IDs, and mapped acceptance criteria.
- Candidate commit/build, environment URL/profile, Browser, viewport/device, fixture/run IDs, and timestamp.
- Preconditions and exact reproduction steps.
- Expected and observed result for every step.
- Evidence paths and any necessary redactions.
- Console/runtime and relevant network/provider summary.
- Pass/fail result, severity when failed, and exact rationale.
- Retest/regression requirements.

## Severity

| Severity | Meaning | Release effect |
| --- | --- | --- |
| `critical` | data exposure/loss, auth bypass, unsafe action, complete outage, or severe security/privacy breach | always blocks |
| `high` | mandatory journey cannot complete; false success or silent failure; no safe recovery; core accessibility barrier | always blocks |
| `medium` | meaningful requirement failure with a reasonable workaround outside the core path | blocks unless a recorded exception satisfies release-gate rules |
| `low` | minor visual/content/polish issue with no material task or trust impact | track; does not automatically block |

Severity is based on customer/release impact, not estimated implementation effort.

## Result Rules

- One unmet expected result means the case fails.
- A flaky or non-reproducible run is not a pass; classify it as blocked or failed with evidence and repeat requirements.
- Missing required evidence is incomplete, not passed.
- An expected negative request may produce a controlled error in diagnostics; the case passes only if the product handles it truthfully and safely.
- Do not average step results into a case percentage.
