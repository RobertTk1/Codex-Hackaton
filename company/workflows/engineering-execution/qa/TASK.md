# QA Task — Read During Every QA Session

Status: `ready-after-engineering-gate` — do not begin until the deterministic engineering release gate passes.

## Mission

Prove that the completed, integrated release candidate works from the customer's point of view, fails truthfully when something breaks, protects customer data, and is safe to hand to DevOps.

## Goal

Execute the generated QA inventory one case at a time against one frozen candidate revision until every mandatory case has `passes: true`, every discovered defect has been fixed and retested, and the QA release gate produces an explicit `pass` or `fail` recommendation.

Developer tests are entry evidence. QA does not rewrite one test for every engineering ticket. It independently verifies complete user stories, cross-feature journeys, recovery paths, provider failures, accessibility, responsive behavior, and privacy/security boundaries in the running product.

## Requirements

Before selecting a QA case, verify `FIRST_START.md` and `references/requirements.md`. At minimum:

- Every required engineering ticket is `completed` with `passes: true`.
- The complete Developer verification suite passes from a clean checkout.
- The exact candidate commit is recorded and does not change during a QA case.
- QA evidence is isolated on `codex/qa-<candidate-short-sha>` from the frozen candidate, and automatic dev replacement is disabled or pinned for the QA window.
- A representative QA environment, deterministic fixtures, and safe test accounts are ready.
- The approved PRD, user stories, scenarios, screens/states, contracts, target devices, and risk inputs are available.
- The in-app Browser is available for customer-facing end-to-end verification.

If the engineering gate fails, do not begin QA or reinterpret missing behavior as a known limitation.

## Verification

A QA case passes only when:

- Every mapped step and acceptance criterion is exercised through the running product.
- The observed result matches the approved story, scenario, contract, and relevant screen state.
- The Browser run begins from the case's declared clean state and uses controlled fixtures.
- Customer-visible state, relevant console/runtime state, and relevant network/provider outcomes contain no unexplained errors.
- Required negative and recovery behavior is tested, not inferred from the happy path.
- Errors are truthful, visible, actionable, accessible, and observable internally without exposing secrets.
- Required screenshots and diagnostic evidence are stored with the case result.
- The result is recorded as `passes: true` or `passes: false` with exact notes.

The QA task is complete only when the release gate in `references/release-gate.md` passes. A pass-rate percentage cannot override a failed mandatory journey, a silent failure, or an open release-blocking defect.

## Turn Contract

```text
START QA SESSION
  1. Read TASK.md, workflow tasks.json, the QA queue, and the tail of progress.txt.
  2. If this is the first QA session or the candidate changed, read FIRST_START.md.
  3. Confirm the engineering-to-QA gate and frozen candidate revision.
  4. Select exactly one eligible case using references/case-inventory.md.
  5. Mark the case in_progress; passes remains false.
  6. Read only the case's named source references and relevant QA references.
  7. Prepare the declared fixtures and clean browser/account state.
  8. Execute the complete case with the in-app Browser using references/browser-e2e.md.
  9. Run the case's observability, failure, accessibility, privacy, and responsive checks.
 10. Capture evidence and assign pass/fail using references/evidence-and-severity.md.
 11. If failed, create a defect and route a repair using references/defect-loop.md.
 12. Update the QA queue and workflow summary, append progress.txt, and commit the QA result.
 13. Stop. Do not begin another QA case.
END QA SESSION
```

Default rule: one QA case, defect retest, or release-gate task per session.

## No-Silent-Failure Contract

A feature does not pass merely because the page remains usable after an error.

- A failed operation must never appear successful.
- A loading state must resolve to success, an explicit recoverable error, or a time-bounded terminal state.
- The UI must tell the customer what failed in customer-facing language and what they can do next.
- The system must emit enough structured diagnostic evidence to identify the failed boundary without logging secrets or sensitive customer content.
- Empty data, cached data, generated demo data, or another provider must not silently replace a failed required response.
- A fallback passes only when the approved product contract names it, the customer can tell the experience is degraded, the original failure remains observable, and the fallback does not claim the original action succeeded.
- Expected failure responses during negative testing are not defects when they are handled truthfully; unexplained console errors, unhandled rejections, indefinite spinners, false `2xx` success, or swallowed exceptions are defects.

Use `references/failure-observability.md` for the required failure matrix and evidence.

## Non-Negotiable Rules

- QA begins after engineering completion, never as a substitute for Developer verification.
- Test customer-visible behavior through the running product; do not pass a story by reading code or trusting implementation notes.
- Use the in-app Browser for every customer-facing end-to-end case.
- Execute one complete case per session and stop after recording it.
- Never weaken an acceptance criterion because the implementation differs.
- Never treat a fallback, placeholder, fixture, cached response, or static screen as real provider success.
- Every mandatory external boundary receives success, failure, timeout, malformed-response, and recovery coverage when technically applicable.
- Every failure receives reproducible steps, expected and observed results, environment, candidate revision, evidence, severity, and affected requirements.
- A QA agent does not repair the defect in the same session; repairs return through the Developer contract and the failed case is then rerun.
- A fix is not verified by a commit or developer claim. The original case and its required regression scope must pass.
- Keep test accounts and fixtures isolated. Do not use or expose unrelated customer data.
- Accessibility requires automated checks plus manual keyboard, focus, error, status-message, zoom/reflow, and interaction review; one tool alone is not enough.
- Do not release with an open critical/high defect, a failed mandatory case, or any unresolved silent-failure path. Only the narrowly defined recorded medium-severity exception in the release gate is permitted.

## Progressive Disclosure Map

| File | Read it |
| --- | --- |
| `TASK.md` | every QA session |
| `FIRST_START.md` | first QA session, candidate change, or uncertain environment |
| `references/requirements.md` | before QA inventory initialization or case selection |
| `references/case-inventory.md` | when generating, selecting, or updating QA cases |
| `references/browser-e2e.md` | for every customer-facing journey |
| `references/environment-fixtures.md` | before preparing accounts, data, devices, or provider states |
| `references/failure-observability.md` | for every provider, API, async, recovery, or negative case |
| `references/accessibility-responsive.md` | for UI, accessibility, browser, and device cases |
| `references/security-privacy.md` | for auth, ownership, uploads, reports, logs, and sensitive data |
| `references/evidence-and-severity.md` | before setting a result or filing a defect |
| `references/defect-loop.md` | whenever a case fails or a fix is ready to retest |
| `references/release-gate.md` | after all cases resolve or when evaluating a recorded medium-severity exception |
| `references/skills.md` | when routing QA support work |
| `references/research-basis.md` | only when revising QA policy or standards |
