# Developer → QA → DevOps Workflow

Use this file when routing work between the Developer, QA, and DevOps goals.

## Stage Order

```text
Developer
  → engineering release gate
QA
  → QA release gate
DevOps
  → production completion gate
complete
```

Only the current stage may create or execute work. A downstream stage may be prepared with fixtures or checklists only when an approved engineering ticket explicitly requires that artifact; preparation never counts as passing the downstream gate.

## Per-Turn Router

1. Confirm the loop is `active` and the approved engineering plan remains the authority.
2. Read the current stage and its authoritative queue from `tasks.json` and `references/sources.md`.
3. Select one eligible work item using the stage specification.
4. Mark it `in_progress` in its authoritative queue.
5. Read its named references and the stage specification only.
6. Execute, verify, record evidence, synchronize state, append progress, and stop.

## Stage Transitions

Stage transitions are their own verified work item. Do not combine the final engineering ticket with opening QA, or the final QA case with production deployment.

The transition turn must:

- Verify the outgoing gate.
- Record the exact passing revision and evidence.
- Initialize or validate the next stage's queue.
- Update `current_stage`.
- Append progress and stop.

## Entry Gate

The loop is active because the engineering plan is approved. Before the first product ticket, one deterministic preflight verifies:

- every required source path in `references/sources.md` exists;
- `ticket-index.json` matches the authoritative plan and readiness files;
- the branch/worktree and development deployment boundaries resolve;
- all referenced required skills are installed and optional skills have a recorded installation source;
- the six-question sanity check in `GOAL.md` can be answered without chat history.

Run `bun company/workflows/engineering-execution/scripts/validate-loop.mjs` for this preflight and whenever source, skill, branch, or approval state changes.

No separate activation step exists.
