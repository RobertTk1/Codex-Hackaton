# Engineering Delivery Loop — Read Every Turn

Status: `active` — the engineering plan is approved for runtime execution. No additional activation or founder-approval gate applies.

## Mission

Turn an approved engineering plan into a working, tested, and deployed product through three gated goals: Developer, QA, and DevOps.

## Goal

Deliver the approved product without reinterpreting scope: implement every required engineering ticket, verify the integrated customer journeys, deploy the passing build, and preserve enough evidence that a fresh agent or founder can determine exactly what shipped and why it is considered ready.

## Verification

Selected work is complete only when its acceptance criteria pass and its verification evidence is recorded in the authoritative task state.

Overall completion requires:

- Every required engineering ticket is `completed` with `passes: true`.
- The product-QA release gate passes the approved user journeys, recovery paths, accessibility checks, and security/isolation checks with no unresolved release blocker.
- The approved build is deployed to the target production environment and passes post-deployment smoke verification.
- Task state, evidence, progress memory, and the shipped revision agree.

## Loop Contract

```text
START OF TURN
  1. Read GOAL.md and tasks.json fully, then tail progress.txt.
  2. Run the compact-index freshness check; reconcile state before selection if it is stale.
  3. Query the compact index with `ticket-index.mjs next`; do not load the full index or engineering plan for selection.
  4. Determine the current stage from tasks.json and its source-of-truth queue.
  5. Select exactly one actionable engineering ticket, QA case, or release task whose dependencies and stage gates pass.
  6. Mark that work in progress through its authoritative state mechanism before changing the product.
  7. Read only the selected full work item, its spec_ref, and the source references explicitly named by it.
  8. Execute the work end to end without expanding its approved scope.
  9. Run every required verification and collect evidence.
 10. Apply the mapped result status only when all acceptance criteria pass; otherwise record the exact failure.
 11. Synchronize the authoritative source queue, derived index, and tasks.json summary.
 12. Append one real-timestamped progress entry and stop.
END OF TURN
```

Default rule: complete exactly one atomic work item per turn.

## Six-Question Sanity Check

1. **What is read every turn?** `GOAL.md`, `tasks.json`, and the tail of `progress.txt`; Developer queries the index through `check` and `next` rather than loading it.
2. **What is the next task?** The current stage queue plus `ticket-index.mjs next` during Developer.
3. **Where are its details?** `ticket-index.mjs get <ticket-id>` or the selected QA/release queue record and its `spec_ref`/named sources.
4. **How is completion proven?** The selected item's acceptance, pass, command, manual, deployment, and shared verification contracts.
5. **Where is evidence recorded?** The detailed authoritative work item, its evidence paths, synchronized summary/index, and one progress entry.
6. **When does the turn stop?** Immediately after the selected item or explicitly planned batch is verified, synchronized, recorded, and handed off—or after its blocker/failure is recorded.

## Hard Rules

- Do not start QA until the engineering release gate passes.
- Developer may deploy only to the isolated `magic-mirror-dev` application. Do not mutate `magic-mirror-prod` until the product-QA release gate passes and the DevOps stage owns the release.
- Do not mark work complete without verification evidence.
- Do not invent provider success, test results, credentials, approvals, or deployment state.
- Do not skip dependencies or silently change the approved product or technical contracts.
- Do not swallow errors, ship fake success, or substitute placeholder behavior for required functionality.
- Do not read unrelated specifications merely because they exist.
- Do not rewrite old progress entries.
- Do not change approved product scope during execution. Record newly required authority as a blocker or amend the authoritative plan through an explicit product decision.
- Development/QA must use an isolated Supabase development environment; it must never use the production Supabase project, data, Storage, or credentials.
- The approved engineering plan is the detailed ticket authority. `ticket-index.json` is a derived selection cache only and never overrides it.

## File Map

| File | Read it | Contains |
| --- | --- | --- |
| `GOAL.md` | every turn | mission, gates, loop contract, hard rules |
| `tasks.json` | every turn | loop status, stage controllers, contract-building work, and live execution summary |
| `ticket-index.json` | query through its script during Developer; do not load fully | compact derived engineering-ticket selection state |
| `progress.txt` | tail every turn | append-only execution memory |
| `FIRST_START.md` | only if `tasks.json` is missing | safe package initialization |
| `SUBTASKS.md` | only when selected work is not atomic | decomposition rules |
| `WORKFLOW.md` | when routing stages or selecting work | overall developer → QA → DevOps workflow |
| `developer/TASK.md` | during the developer stage | engineering-ticket execution contract |
| `developer/references/` | only when named by the selected developer work | implementation-specific supporting instructions |
| `qa/TASK.md` | during the QA stage | integrated product-QA contract |
| `qa/references/` | only when named by the selected QA work | test types, evidence, accessibility, and defect instructions |
| `devops/TASK.md` | during the DevOps stage | production release and deployment contract |
| `devops/references/` | only when named by the selected DevOps work | deployment, migration, rollback, and smoke-test instructions |
| `references/verification.md` | when defining or evaluating evidence | common verification and failure rules |
| `references/sources.md` | when locating authoritative inputs | source hierarchy and progressive-disclosure rules |
| `references/state-contract.md` | when updating status or importing work | task schema and synchronization rules |
| `references/skills-registry.md` | before invoking a supporting skill | verified skill IDs, locations, and installable sources |
| `scripts/ticket-index.mjs` | through its commands, not by reading every turn | check, select, extract, and synchronize engineering ticket state |
