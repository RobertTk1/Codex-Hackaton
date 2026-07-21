# Developer First Start

Read this during the first Developer session or whenever initialization status is uncertain. Preflight is the session's only work if it reveals a material blocker.

## 1. Confirm Authority

- Open `company/artifacts/engineering-plan/engineering-plan.json`.
- Confirm it is valid JSON and has `status: approved`. `ready-for-review` is not executable.
- Confirm every ticket has an ID, target, scope, dependencies, implementation steps, acceptance criteria, pass conditions, verification, resources, status, passes, and notes.
- Confirm `company/artifacts/engineering-plan/implementation-readiness.json` exists.

## 2. Confirm Product Inputs

Resolve every exact path in `../references/sources.md`, including the approved canonical/v2 mockups and interaction specs, exact copy, design tokens, fonts, logos, and ticket-specific resources.

Do not reconstruct a missing contract from memory or chat history.

## 3. Confirm Repository and Toolchain

- Resolve the repository/package root with `git rev-parse --show-toplevel`; it currently resolves to `/Users/talishawhite/Documents/openai-buildweek-hackathon`. Record the root, branch, working-tree status, and existing uncommitted changes.
- Confirm `ENG-001` owns root workspace scaffolding; later tickets place deployable applications in `apps/web` and `apps/api`, shared packages in `packages/`, and Supabase resources in `supabase/`.
- Confirm Bun, TypeScript, Vite, Tailwind, test commands, Supabase tooling, and Git are available as required by the first eligible ticket.
- Confirm `.env.example` documents required names and real secrets remain uncommitted.
- Run only the baseline checks that already exist; do not pretend missing scripts pass.

## 4. Confirm Developer State

- The overarching workflow is active.
- `ticket-index.json` passes the freshness check against the full plan and readiness file.
- The Developer controller task is `in_progress` until every required ticket passes.
- No ticket is already owned by another active worker.
- Stale `in_progress` tickets are reconciled before new work is claimed.

## 5. Initialize Through the Plan

If the application is not scaffolded, select the eligible engineering ticket that owns scaffolding. Do not create an out-of-plan setup project manually.

## 6. Resolve the Development Deployment Bootstrap

- Identify the smallest ticket sequence that creates runnable web/API health shells, production-ready containers, the dev App Platform spec, and `magic-mirror-dev`.
- Record which foundational tickets use the temporary `bootstrap-deferred` deployment state.
- Confirm a persistent Supabase development branch or separate development project and dev-only provider configuration exist before the dev app receives mutable/test traffic.
- Confirm Developer deployment tickets provision/verify dev and DevOps alone mutates production after QA.
- Close the bootstrap exception immediately after the first healthy dev deployment; all later tickets deploy individually.

## End the Session

If preflight passes, record the resolved sources, baseline commands, and clean execution starting point. If it fails, record the exact blocker. Append progress and stop; ticket implementation begins in the next session.
