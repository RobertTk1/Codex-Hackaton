# Testing and Ticket Verification

## Tests Travel with the Ticket

- Add the smallest useful test that proves the new behavior: pure unit, integration, component, or browser test.
- Cover the happy path and the failure/recovery behavior introduced by the ticket.
- Data/security tickets include negative authorization and constraint cases.
- Provider tickets include typed fixture tests plus the bounded live/sandbox check required by the plan.
- UI tickets include interaction, keyboard, responsive, console/network, and adjusted visual-similarity checks.

Do not defer ticket-level correctness to the later QA goal.

## Required Verification Order

1. Run the focused test while implementing.
2. Run every ticket `verification.commands` command exactly as written.
3. Perform every ticket `manualChecks` item.
4. Run relevant typecheck and lint checks.
5. For a running UI/API path, inspect browser console, network failures, and visible recovery.
6. Run the narrow regression surface affected by shared code.
7. Record commands, results, screenshots/traces, and artifact paths in ticket notes.
8. After integration, deploy to `magic-mirror-dev` and complete `development-deployment.md`.

## UI Gate

In addition to the ticket commands:

- Design-system/primitives check passes.
- All named interaction states exist.
- Required assets pass `asset-production.md`.
- Motion review passes `motion.md`.
- Accessibility and keyboard checks pass.
- Adjusted mockup similarity is at least 90% under `ui-implementation.md`.

## Result State

Set `status: "completed"` and `passes: true` only when every gate passes.

If verification fails:

- Keep `passes: false`.
- Use `in-progress` for a safe retry owned by the current branch/session lineage.
- Use `blocked` when new authority, access, input, or an external prerequisite is required.
- Record the failed check, expected/observed behavior, evidence, suspected cause, retry count, and exact next action.

After three failed retries, mark blocked for manual review rather than repeating the same approach indefinitely. Another independent eligible ticket may proceed in a later session.

## Complete Developer Gate

Before handing off to QA:

- Every required ticket is `completed` with `passes: true`.
- Engineering-plan validation passes.
- Full typecheck, lint, unit/integration, build, and developer E2E commands pass from a clean checkout.
- No uncommitted product change or active ticket worker remains.
- The final integrated revision is the healthy dev deployment and its app/deployment evidence is recorded.
