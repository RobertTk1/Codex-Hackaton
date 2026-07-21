# Developer Requirements

## Required Before the Developer Goal Starts

- Approved `company/artifacts/engineering-plan/engineering-plan.json`.
- Resolved implementation readiness at `company/artifacts/engineering-plan/implementation-readiness.json`.
- Approved PRD, build plan, user stories, BDD scenarios, and active screen inventory referenced by the plan.
- Approved system architecture, data contract, application/API contracts, security rules, and provider boundaries.
- Approved copy, active screen mockups, interaction specifications, design tokens, logos, icons, and brand assets for UI tickets.
- Git repository with an identifiable integration target and a safe place for ticket branches/worktrees.
- An identified `magic-mirror-dev` App Platform app, isolated persistent Supabase development branch or development project, dev-only variables, and deployment ownership once the first deployable baseline exists.
- Required toolchain and package manager.
- Required secret names documented in `.env.example`; real values available only when the selected ticket requires a live check.

## Required for a Selected Ticket

- `passes` is `false`.
- Status is `not-started`, a reconciled `in-progress`, or `blocked` with a resolved blocker.
- Every `dependsOn` ticket is `completed` and has `passes: true`.
- Every `readinessPrerequisites` item is `ready` or `not-required`.
- Every file in the ticket's architecture, contracts, and design resources exists.
- The ticket names concrete acceptance criteria, pass conditions, commands, and manual checks.
- No other worker owns the ticket or an overlapping write scope.
- If the dev deployment gate is active, no other deployment writer owns `magic-mirror-dev`.

## Missing Requirements

Do not guess or broaden authority.

1. Record the missing item and why the ticket needs it.
2. Decide whether another eligible ticket can proceed safely.
3. If not, mark the ticket `blocked`, keep `passes: false`, name the owner/action needed, update progress, and stop.
4. Never add fake keys, dummy providers, false test results, or placeholder success.

## Stack Contract

- Frontend: TypeScript, React, Vite, Tailwind CSS, Bun.
- UI: shared shadcn/ui components built on the project's chosen Base UI primitives; use Base UI directly only when the shared layer lacks the required behavior.
- Icons: Lucide.
- API: TypeScript with Zod at every external boundary.
- Data/auth/private storage: Supabase Postgres, Auth, and private Storage.
- Production hosting: DigitalOcean.
- Provider choices remain those approved by the engineering plan and contracts.
