# State, Queue, and Derived-Index Contract

Status: final for runtime execution.

## Mutable Authorities

Do not duplicate detailed work-item state in multiple mutable queues.

| Stage | Detailed mutable authority | Derived/read-only view |
| --- | --- | --- |
| Developer | `company/artifacts/engineering-plan/engineering-plan.json` | `ticket-index.json` |
| Product QA | `company/artifacts/qa/qa-cases.json` | workflow stage summary |
| Release and deployment | `company/artifacts/devops/release-tasks.json` | workflow stage summary |

`tasks.json` records loop status, current stage, stage controllers, and queue pointers. It does not duplicate all tickets, QA cases, or release tasks.

## Native Status Vocabularies and Lossless Mapping

| Semantic state | Workflow controller | Engineering ticket | QA case | DevOps release task |
| --- | --- | --- | --- | --- |
| Waiting | `pending` | `not-started`, `passes: false` | `pending`, `passes: false` | `pending`, `passes: false` |
| Active | `in_progress` | `in-progress`, `passes: false` | `in_progress`, `passes: false` | `in_progress`, `passes: false` |
| Blocked prerequisite | `blocked` | `blocked`, `passes: false` | `blocked`, `passes: false` | `blocked`, `passes: false` |
| Failed verification | `in_progress` or `blocked` with failure notes | `in-progress` or `blocked`, `passes: false` | `failed`, `passes: false` | `failed`, `passes: false` |
| Verified success | `complete` | `completed`, `passes: true` | `passed`, `passes: true` | `passed`, `passes: true` |
| Stale after candidate/source change | n/a | return to the appropriate non-passing native state | `invalidated`, `passes: false` | `invalidated`, `passes: false` |
| Production restored after failed release | n/a | n/a | n/a | `rolled_back`, `passes: false` |

Never write a workflow-controller status into a detailed queue. Never infer `passes: true` from a completion-like word. `completed/passed` with `passes: false`, or any non-success status with `passes: true`, is invalid.

## Engineering Ticket Index

The full engineering plan remains authoritative but is too large for selection-time context. `ticket-index.json` contains only selection fields, dependency/readiness results, and source fingerprints.

Commands:

```bash
bun company/workflows/engineering-execution/scripts/ticket-index.mjs check
bun company/workflows/engineering-execution/scripts/ticket-index.mjs next
bun company/workflows/engineering-execution/scripts/ticket-index.mjs get ENG-001
bun company/workflows/engineering-execution/scripts/ticket-index.mjs set ENG-001 in-progress false --note "claimed on branch ..."
bun company/workflows/engineering-execution/scripts/ticket-index.mjs sync
```

- `check` fails if the index does not match the plan/readiness fingerprints.
- `next` returns the first eligible compact record without printing the full plan.
- `get` prints only the selected full ticket.
- `set` validates and changes the authoritative ticket state, appends the supplied note when present, and regenerates the index atomically.
- `sync` validates both inputs and regenerates the derived index after any authorized plan edit.

Do not edit ticket state and forget the index. The start and end of every Developer turn run `check`; a stale index is a reconciliation failure, not permission to select from stale data.

## State Update Order

1. Confirm stage, dependencies, readiness, branch/worktree, and ownership.
2. Apply the queue's native active status.
3. Synchronize the derived index/summary.
4. Execute and verify.
5. Record evidence in the detailed work item.
6. Apply the mapped native result status and `passes` value.
7. Synchronize the derived index and workflow summary.
8. Append one real-timestamped progress entry.

If a write fails mid-sequence, reconcile the detailed authority first and do not continue to another item.

## Discovered Work

New work must include source, rationale, affected requirement, dependency, acceptance criteria, verification, and priority. Add it to the appropriate authoritative queue. Scope-changing work remains blocked until an explicit product decision updates an authoritative product/planning source.
