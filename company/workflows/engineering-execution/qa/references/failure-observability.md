# Failure and Observability Verification

## Definition of a Silent Failure

A silent failure occurs when required work fails, is skipped, times out, returns invalid data, or is replaced, but the customer or operator is led to believe the intended operation succeeded or receives no actionable terminal state.

## Forbidden Behaviors

- Catching an error and returning success, an empty collection, or fabricated/default data.
- Displaying generated demo content when a real required provider failed.
- Leaving an indefinite spinner or disabled control without a terminal state.
- Showing success before the durable write/provider acknowledgement succeeds.
- Returning a success status with an error payload.
- Logging the failure without informing the affected customer.
- Showing a generic error without retaining diagnostic context internally.
- Substituting cached, stale, local, or alternate-provider data without an approved and visible degraded-state contract.
- Retrying forever, duplicating an action, or losing the customer's submitted data.

## Required Failure Matrix

For every applicable API/provider/async boundary, create or map cases for:

| Condition | Customer expectation | System expectation |
| --- | --- | --- |
| success | truthful completed state | success event and durable state agree |
| validation failure | specific correction guidance | structured validation failure, no write |
| authentication/authorization failure | safe sign-in or access message | no data disclosure; failure recorded |
| timeout/slow response | bounded progress then retry/cancel/recovery | timeout classified and correlated |
| unavailable/5xx/network loss | explicit unavailable state and safe retry | failed dependency visible in diagnostics |
| malformed/partial response | no false or partial success | schema failure recorded; unsafe data rejected |
| retry | idempotent or clearly confirmed behavior | no duplicate durable action |
| recovery | retained safe progress when promised | state reconciles with UI |

## Fault Injection

- Use the narrowest controlled mechanism available: provider sandbox mode, test flag, controlled stub, network interception, or temporary QA-only dependency configuration.
- Do not alter production behavior merely to make a QA case pass.
- Record exactly what fault was injected and which boundary it represents.
- If a required boundary cannot be failed deterministically, file a testability defect. Do not infer recovery from source code.

## Loud but Safe Failure

A passing failure path has both layers:

1. **Customer layer:** clear text identifies that the action did not complete, preserves safe input/progress, offers an appropriate next action, and is announced accessibly.
2. **Diagnostic layer:** structured event includes time, operation, boundary/provider, result, reason/error category, correlation/run ID, and safe context—without secrets, tokens, raw sensitive photos, or unnecessary personal data.

## Evidence

Capture the visible error/recovery state plus relevant request/response classification, console/runtime result, and diagnostic event. Redact secrets and sensitive content. A case fails if either the customer layer or diagnostic layer is absent.
