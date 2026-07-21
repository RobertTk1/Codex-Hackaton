# Parallel Work and Subagents

Reference: [OpenAI Subagents documentation](https://learn.chatgpt.com/docs/agent-configuration/subagents?surface=app).

## Core Rule

One worker owns exactly one engineering ticket. A root orchestration turn may run multiple workers only when the current runtime instructions or user explicitly authorize subagents and the tickets are independently eligible and safe to execute concurrently. Otherwise use the single-ticket mode.

## When Parallel Tickets Are Allowed

All of the following must be true:

- Each ticket is independently eligible before any worker starts.
- No ticket depends directly or transitively on another ticket in the batch.
- The tickets do not write the same files or shared mutable systems.
- They do not both alter root configuration, package manifests/lockfiles, migration ordering, shared contracts, design tokens, generated clients, or the same database objects.
- Each write-capable worker has an isolated ticket branch and worktree or equivalent isolated checkout.
- The parent has enough available agent capacity and can review/integrate every result.

If safe isolation cannot be established, execute sequentially.

## Safe Subagent Uses

Prefer subagents for bounded work that keeps noisy context out of the parent:

- Read-only codebase exploration.
- Official documentation verification.
- Test-gap analysis or focused test execution.
- Browser reproduction and console/network evidence.
- Visual-asset inventory or production.
- One isolated engineering ticket.
- One disjoint subtask within the parent-owned ticket.

Be conservative with parallel write-heavy work; the official guidance warns that it increases conflicts and coordination overhead.

## Parent Responsibilities

The parent agent alone:

- Selects the batch and proves dependency/file safety.
- Updates `engineering-plan.json`, workflow `tasks.json`, and `progress.txt`.
- Assigns one bounded prompt and expected return schema per worker.
- Monitors, steers, interrupts, or stops workers when scope changes.
- Waits for all planned workers.
- Reviews diffs and evidence.
- Integrates passing branches one at a time.
- Reruns combined verification after each integration and after the full batch.
- Applies final ticket states and closes the session.

Workers must not edit shared workflow state.

## Worker Prompt Contract

Every delegated ticket prompt names:

- Ticket ID and exact outcome.
- Branch/worktree and allowed write scope.
- Required source files and stage references.
- Acceptance criteria and verification commands.
- Forbidden files or shared hotspots.
- Whether the worker may commit.
- Required result summary: status, commit, changed files, tests/checks, evidence, blockers, and integration notes.

## Multiple Subtasks for One Ticket

The parent keeps the ticket `in-progress` and may delegate independent parts. Examples:

- Explorer maps the existing code while a visual worker inventories mockup assets.
- Asset worker generates approved imagery while the implementer builds structure in an isolated branch.
- Verifier runs browser checks after implementation is available.

Do not split tightly coupled code across writers merely to create concurrency. The parent integrates all outputs and runs the ticket's full verification before changing `passes`.

## Thread and Recursion Limits

- Use only the available concurrency; do not assume unlimited workers.
- Keep `agents.max_depth = 1` unless a separately approved workflow needs recursion. The official default allows the parent to spawn direct children but prevents uncontrolled nested fan-out.
- Subagents inherit parent permissions unless a custom agent narrows them. Use read-only agents for exploration/review where possible.
- Remember that each subagent consumes its own tokens and tool work.

## Integration Failure

If a worker passes alone but fails after integration:

- Keep the affected ticket `passes: false`.
- Record the conflict and combined failing evidence.
- Revert or isolate the integration safely.
- Do not blame or silently edit another ticket's scope.
- Create a focused repair or retry under the appropriate ticket.
