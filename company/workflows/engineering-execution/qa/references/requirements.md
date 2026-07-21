# QA Requirements

## Engineering-to-QA Gate

All conditions must be true:

1. The engineering plan has `status: approved`.
2. Every required engineering ticket is `completed` and `passes: true`.
3. The complete Developer verification suite passes from a clean checkout.
4. The integrated application runs with no unresolved startup, type, build, migration, or configuration error.
5. The exact candidate commit and environment are recorded.
6. Required provider credentials/test modes and deterministic fixtures are available.
7. Developer handoff evidence identifies known limitations; none may contradict an approved requirement.

The gate is deterministic. A verbal exception cannot convert incomplete engineering work into a passing engineering gate; scope changes must amend the approved source first.

## Per-Case Eligibility

A QA case is eligible only when:

- Its source requirements and expected outcomes resolve.
- Its prerequisite cases have passed.
- Its required fixtures and environment state can be created and reset.
- No active repair changes the candidate files or shared test data it relies on.
- The Browser surface and any required diagnostic access are available.
- The case can be completed and evidenced in one session.

If the case is too large, decompose it by meaningful customer outcome or state while preserving at least one complete end-to-end case for the full story.

## QA Is Not a Duplicate Developer Phase

- Re-run the full Developer suite at the handoff and after candidate changes.
- Consume ticket-level tests as traceability evidence.
- Add a new automated test only when QA exposes a coverage gap worth preserving.
- Do not generate a redundant QA test solely because an engineering ticket exists.
