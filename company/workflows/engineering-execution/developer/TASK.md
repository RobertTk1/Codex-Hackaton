# Developer Task — Read During Every Developer Session

Status: `active` — execute from the approved plan through the derived ticket index.

## Mission

Implement the approved project by executing `engineering-plan.json` ticket by ticket until every required ticket has `passes: true` and the integrated application satisfies the engineering release gate.

## Goal

Complete exactly one engineering ticket per worker session: implement it, add or update tests, validate it against its contracts and design, run every verification check, commit and integrate the result, redeploy the integrated revision to the shared development environment, verify it there, set `passes` to `true` or leave it `false` with exact notes, update the workflow task state and `progress.txt`, then stop.

A root orchestration turn may run multiple independent tickets through subagents only when current runtime instructions or the user explicitly authorize subagents. Each subagent still follows the one-ticket contract. Parallel execution is allowed only under `references/parallel-subagents.md`.

## Requirements

Before selecting work, verify the prerequisites in `FIRST_START.md` and `references/requirements.md`. At minimum:

- The engineering plan has `status: approved` for implementation.
- `company/artifacts/engineering-plan/engineering-plan.json` exists and is the ticket source of truth.
- The selected ticket's dependencies are `completed` with `passes: true`.
- The selected ticket's named product, architecture, contract, readiness, design, and verification inputs are available.
- Git and the required local toolchain are usable.

If a requirement is missing, do not guess, fabricate a result, or silently substitute scope. Record the blocker and stop or select another eligible ticket.

## Verification

A ticket passes only when:

- Its implementation steps and acceptance criteria are complete.
- Every pass condition is proven.
- Its new behavior has the smallest useful automated tests.
- Every command and manual check in `verification` passes.
- Runtime, browser console, and relevant network checks show no unresolved error.
- UI tickets pass design-system, responsive, interaction-state, accessibility, asset, motion, and ≥90% adjusted mockup-similarity checks.
- No secret, fake integration, placeholder success, or unrelated change is included.
- The integrated ticket is live and healthy on `magic-mirror-dev` with deployment evidence.
- The ticket result is committed and its evidence is recorded.

The Developer task is complete only when every required engineering ticket has `status: completed` and `passes: true`, the complete engineering verification suite passes, and the integrated application runs from a clean checkout.

## Session Modes

### Default: One Ticket

One root agent selects, implements, verifies, commits, records, and stops after one ticket.

### Parallel Ticket Batch

When subagents are explicitly authorized, the root agent may delegate multiple eligible, dependency-independent, conflict-free tickets. Each worker owns one ticket in an isolated branch/worktree. The root coordinates, reviews, integrates passing results one at a time, reruns combined verification, updates shared state, appends progress, and stops after the batch.

### Parallel Subtasks Within One Ticket

The parent may delegate bounded independent subtasks—such as codebase exploration, asset production, test writing, or browser verification—while retaining ownership of one engineering ticket. The ticket cannot pass until all outputs are integrated and verified together.

## Turn Contract

```text
START DEVELOPER SESSION
  1. Read TASK.md, workflow tasks.json, and the tail of progress.txt.
  2. If this is the first developer session, read FIRST_START.md.
  3. Validate ticket-index.json and select eligible work using references/ticket-selection.md; do not load the full plan for selection.
  4. Choose single-ticket or safe parallel mode using references/parallel-subagents.md.
  5. The parent marks selected ticket(s) in_progress; passes remains false.
  6. Each worker reads only its ticket and named references.
  7. Implement within scope using references/implementation-standards.md.
  8. For UI tickets, follow references/ui-implementation.md, asset-production.md, and motion.md.
  9. Add tests and run every check in references/testing-verification.md and the ticket.
 10. Commit the ticket result using references/git-progress.md.
 11. The parent reviews/integrates and deploys that integrated revision using references/development-deployment.md.
 12. Apply ticket result state only after dev deployment and smoke pass; synchronize tasks.json.
 13. Append one progress.txt entry with code, test, deployment, and smoke evidence.
 14. Stop. Do not begin another unplanned ticket.
END DEVELOPER SESSION
```

## Non-Negotiable Rules

- The engineering plan is the ticket authority; do not invent implementation scope.
- Use `codex/engineering-execution` as the integration branch and `codex/<ticket-id-lowercase>-<short-slug>` as the ticket branch; never implement directly on `main` or the integration checkout.
- One ticket per worker session.
- Dependencies must be completed and passing before work starts.
- Only the parent orchestrator updates shared planning and progress files during parallel work.
- Do not run parallel writers against the same checkout or overlapping files.
- Use strict TypeScript and validate all untrusted external data at its boundary.
- DRY: search before creating, reuse established components and logic, and extract shared code when real repeated use exists. Do not create speculative generic abstractions.
- Use Tailwind CSS, shadcn/ui configured with Base UI primitives where available, Base UI directly only when the shared shadcn layer does not cover the need, and Lucide for interface icons.
- Use approved design tokens and production brand assets; do not redraw logos or invent icon systems.
- UI tickets must inventory and produce required visual assets before final screen implementation.
- Add purposeful motion only when it improves feedback, orientation, hierarchy, or perceived continuity; honor reduced-motion preferences.
- No silent errors, fake success, TODO behavior, dummy integrations, or swallowed exceptions.
- No unrelated formatting, refactoring, dependency changes, or feature expansion.
- Commit every ticket result on its ticket branch, including failed attempts with useful evidence. Never commit secrets.
- Deploy every integrated passing ticket to `magic-mirror-dev`; Developer never mutates `magic-mirror-prod`.
- Set `passes: true` only after all ticket gates pass.
- Stop after the selected ticket or planned parallel batch is fully recorded.

## Progressive Disclosure Map

| File | Read it |
| --- | --- |
| `TASK.md` | every Developer session |
| `FIRST_START.md` | first Developer session or when initialization state is uncertain |
| `references/requirements.md` | before ticket selection |
| `references/ticket-selection.md` | when selecting or retrying work |
| `references/parallel-subagents.md` | before delegating any ticket or subtask |
| `references/implementation-standards.md` | for every implementation ticket |
| `references/ui-implementation.md` | for every UI ticket |
| `references/asset-production.md` | when a mockup contains photographic, illustrative, or generated imagery |
| `references/motion.md` | when UI behavior may benefit from animation or transition |
| `references/testing-verification.md` | before changing ticket result state |
| `references/git-progress.md` | before committing or updating shared state |
| `references/development-deployment.md` | after integration and before setting a ticket passing |
| `references/skills.md` | when routing the selected ticket to supporting skills |
