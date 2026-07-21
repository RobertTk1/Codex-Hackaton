# Shared Verification Contract

Use this file when defining or evaluating completion evidence in any stage.

## Evidence Strength

Prefer the strongest available evidence:

1. Passing deterministic command tied to the acceptance criterion.
2. Automated behavioral test at the narrowest useful boundary.
3. Running-system or deployed-system check.
4. Screenshot, video, browser trace, network trace, or inspected artifact.
5. Human review against explicit criteria.

Assertions such as “looks good,” “implemented,” or “should work” are not evidence.

## Completion Rules

- Every work item must have acceptance criteria and verification.
- Record commands/checks and their outcome, not merely that verification happened.
- Mark complete only when all required checks pass.
- Partial implementation can remain `in_progress`; it cannot be represented as passing.
- A recorded exception must name the failed criterion, user/release risk, duration, mitigation, decision owner, and authoritative artifact containing the decision.

## Failure Record

When verification fails, record:

- Failed criterion or command.
- Expected and observed behavior.
- Reproduction environment.
- Relevant log, screenshot, trace, or artifact path.
- Suspected cause, clearly labeled as inference.
- Safe next action.
- Whether human input or a new prerequisite is required.

## Common Non-Passing Conditions

- Dependency or readiness gate is unresolved.
- Required test or command was skipped.
- Runtime/browser error remains.
- Provider success is mocked where a real integration is required for that gate.
- UI omits a required state or inaccessible interaction.
- Sensitive data crosses an ownership, logging, storage, or retention boundary.
- Deployed revision differs from the approved candidate.
