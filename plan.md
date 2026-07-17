# Magic Mirror — Living Plan

## How to Use This Plan

This file is the source of truth for roadmap, sequencing, status, and next actions. Update it in the same change whenever scope, decisions, or task status changes. Each phase must produce a clear user outcome, and each task must be checkable. The detailed PRD has not yet been added; refine this plan after Robert provides it rather than guessing requirements.

## Product Goal

Deliver the V1 golden path: a user uploads or captures a photo, selects one garment, and receives a near-real-time rendered image or video of themselves wearing it.

## Scope Guardrail

Stylist recommendations, voice input, multi-garment outfits, deep stylist reasoning, and brand polish are V2+. Do not pull them into V1 unless the plan records an explicit scope decision.

## Delivery Strategy

Move at hackathon speed while keeping the golden path runnable. Use a dedicated branch and worktree for each concurrent task or experiment, integrate small working changes frequently, and prune merged worktrees and branches. PRs and squash merges are optional. Time-box experiments, define their cheapest success signal, and keep them off the critical path unless they reduce a launch-critical risk.

## Roadmap

### Phase 0 — Define and De-risk

**User outcome:** The planned experience is feasible, measurable, and safe enough to build.

- [ ] Add and decompose the full PRD.
- [ ] Define the golden-path Given/When/Then scenario and acceptance criteria.
- [ ] Evaluate generation providers using latency, output quality, reliability, integration effort, and cost.
- [ ] Decide photo retention and deletion behavior before storing real user photos.
- [ ] Confirm the minimum garment catalog and required source assets.
- [ ] Define the submission deadline, demo cutoff, and experiment time budget.

### Phase 1 — Project Foundation

**User outcome:** A user can open a functioning application shell ready for the try-on flow.

- [ ] Scaffold the Next.js monorepo application and required scripts.
- [ ] Configure Tailwind, strict TypeScript, Zod, Vitest, and Playwright.
- [ ] Configure local Supabase and document environment variables.
- [ ] Add the minimum schema, migrations, storage buckets, and row-level security.

### Phase 2 — Golden Path

**User outcome:** A user can submit one photo and one garment and receive a visible try-on result.

- [ ] Implement photo upload/capture with validation and consent messaging.
- [ ] Implement single-garment selection.
- [ ] Implement the typed generation-provider boundary with timeout and normalized errors.
- [ ] Persist try-on session state and generated-asset references.
- [ ] Show explicit loading, slow, success, and failure states.

### Phase 3 — Demo Readiness

**User outcome:** The complete try-on journey works reliably in the hosted demo.

- [ ] Pass the Playwright happy-path scenario.
- [ ] Measure end-to-end render latency and address demo-breaking bottlenecks.
- [ ] Verify cross-user isolation and photo deletion behavior.
- [ ] Deploy to Vercel and run a production smoke test.
- [ ] Document known limitations and demo recovery steps.

## Next

1. Receive and add the full PRD.
2. Convert it into phased requirements with user outcomes and acceptance criteria.
3. Resolve generation-provider and photo-retention decisions before implementation depends on them.

## Decisions

- 2026-07-17: Use a monorepo structure.
- 2026-07-17: Maintain a living plan with user outcomes and explicit next actions.
- 2026-07-17: V1 remains limited to the single-photo, single-garment try-on golden path.
- 2026-07-17: Use short-lived branches and dedicated worktrees for concurrent tasks; PRs and squash merges are optional, and merged work is pruned.
- 2026-07-17: Encourage time-boxed experiments while protecting a functioning golden path as the primary deliverable.
- 2026-07-17: Require every feature handoff and optional PR to document what changed, why, and the expected outcome.
- 2026-07-17: After verification, commit and push completed feature-branch work without separate approval; keep its open PR description and progress comments current.

## Roadmap Backlog (V2+)

- Stylist and shopping recommendations.
- Voice input.
- Multi-garment outfits.
- Deep stylist reasoning.
- Brand and visual-identity investment.
