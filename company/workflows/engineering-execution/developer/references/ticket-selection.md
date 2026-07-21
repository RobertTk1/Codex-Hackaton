# Ticket Selection and Claiming

## Source of Truth

The full `tickets` array in `company/artifacts/engineering-plan/engineering-plan.json` is authoritative. Use the generated `../../ticket-index.json` and `../../scripts/ticket-index.mjs` for selection so the full plan does not enter turn context. The index is derived and never a second mutable authority.

Before selection:

```bash
bun company/workflows/engineering-execution/scripts/ticket-index.mjs check
bun company/workflows/engineering-execution/scripts/ticket-index.mjs next
```

After choosing an ID, print only that full ticket:

```bash
bun company/workflows/engineering-execution/scripts/ticket-index.mjs get <ticket-id>
```

## Reconcile Before Selecting

1. Find any `in-progress` tickets.
2. Confirm whether an active parent/worker owns each one.
3. Resume the ticket if its previous session ended with retryable work.
4. Mark it `blocked` with evidence if it cannot continue.
5. Never claim a second copy of an already-owned ticket.

## Eligibility

A ticket is eligible only when:

- `passes === false`.
- It is not actively owned.
- Its status permits work.
- Every dependency has `status === "completed"` and `passes === true`.
- All readiness prerequisites pass.
- Its resource files and required environment are available.

## Ordering

Unless the plan explicitly defines a stronger order:

1. Resume a safe, retryable `in-progress` ticket.
2. Resume a previously blocked ticket whose blocker is resolved.
3. Prefer `must`, then `should`, then `could`.
4. Preserve engineering-plan array order, using ticket ID as the final tie-breaker.

Do not reorder solely to pick a more interesting UI ticket.

## Claim

Before implementation, the root agent:

- Creates or reuses an isolated worktree for `codex/<ticket-id-lowercase>-<short-slug>` based on `codex/engineering-execution`.
- Sets the ticket to `status: "in-progress"` through `ticket-index.mjs set` so the derived index is regenerated.
- Keeps `passes: false`.
- Adds bounded ownership metadata to notes or the active execution summary: session, agent, branch/worktree, and start time.
- Saves valid JSON before delegating or editing code.

## Discovered Work

Add newly discovered engineering work only when required to satisfy an approved ticket or repair a proven defect. New work must name its source, dependency, acceptance criteria, verification, and priority. Scope-changing work stays blocked until an explicit product decision updates an authoritative planning source.
