# Git, Ticket State, and Progress

## Isolation

- `main` is the protected base and is never a product-work checkout.
- `codex/engineering-execution` is the long-lived integration branch for this loop.
- Every engineering ticket uses `codex/<ticket-id-lowercase>-<short-slug>` created from the current integration branch and checked out in its own dedicated worktree.
- QA evidence uses `codex/qa-<candidate-short-sha>` from the frozen candidate; it must not contain unreviewed product changes.
- A release record/config change uses `codex/release-<release-id>` from the QA-approved commit. Production deploys immutable approved digests, not a moving branch tip.
- A QA repair uses `codex/fix-<bug-id>-<short-slug>` and returns through Developer and QA.
- Never let two workers edit through the same checkout or point two branches at the same mutable worktree.
- Preserve unrelated user changes.

## Commit Every Ticket Result

Commit after the ticket attempt is implemented and verified or its failure is fully documented.

- Passing ticket: commit code, tests, ticket state, and evidence summary.
- Failed/retry ticket: commit the coherent attempt and failure evidence on its ticket branch; do not merge it into the integration target as passing work.
- Blocked before any meaningful safe change: record state/evidence without creating an empty commit.
- Never commit secrets, raw sensitive fixtures, known unrelated changes, or generated local caches.

Use a Conventional Commit subject with the ticket ID, for example:

```text
feat(ticket-ENG-042): implement conversational brand sizing
```

The commit body records:

- Status and retry count.
- What changed.
- Why it was needed.
- Expected user/system outcome.
- Main files.
- Tests and verification.
- Failure issues and next action when not passing.

## Parallel Integration

Workers return their ticket branch and commit. The parent:

1. Reviews the diff and verifies scope.
2. Confirms worker checks.
3. Integrates one passing ticket at a time in dependency-safe order.
4. Reruns the relevant combined checks.
5. Deploys the integrated commit to `magic-mirror-dev` and runs the required smoke checks.
6. Sets the ticket result only after integration and dev deployment pass.
7. Leaves failed branches/deployments isolated for retry or cleanup.

## Shared State

Only the parent updates during parallel execution:

- `company/artifacts/engineering-plan/engineering-plan.json`
- `company/workflows/engineering-execution/tasks.json`
- `company/workflows/engineering-execution/progress.txt`

Ticket notes must include commit, changed files, commands/results, manual evidence, dev app/deployment ID, dev URL, deployed revision, smoke result, blockers, and next action.

## End of Session

- Synchronize ticket and workflow status.
- Append one immutable progress entry.
- Push passing or explicitly preserved ticket branches under the branch contract above.
- Stop. Do not silently claim another ticket.
