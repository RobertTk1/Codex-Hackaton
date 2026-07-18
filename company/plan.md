# Magic Mirror — Living Plan

## How to Use This Plan

This file is the source of truth for roadmap, sequencing, status, and next actions. Update it in the same change whenever scope, decisions, or task status changes. Each phase must produce a clear user outcome, and each task must be checkable. The detailed PRD has not yet been added; create it through the founder walkthrough and approval workflow rather than guessing requirements.

## Product Goal

Deliver the V1 golden path: a user uploads or captures a photo, selects one garment, and receives a near-real-time rendered image or video of themselves wearing it.

## Scope Guardrail

Stylist recommendations, voice input, multi-garment outfits, deep stylist reasoning, and brand polish are V2+. Do not pull them into V1 unless the plan records an explicit scope decision.

## Delivery Strategy

Move at hackathon speed while keeping the golden path runnable. Use a dedicated branch and worktree for each concurrent task or experiment, integrate small working changes frequently, and prune merged worktrees and branches. PRs and squash merges are optional. Time-box experiments, define their cheapest success signal, and keep them off the critical path unless they reduce a launch-critical risk.

## Roadmap

### Phase 0 — Define and De-risk

**User outcome:** The planned experience is feasible, measurable, and safe enough to build.

- [x] Establish the base Magic Mirror company profile and operating workspace from the product strategy.
- [x] Complete U.S.-first market research and competitor analysis for the V1 purchase-decision opportunity.
- [x] Define and score candidate audiences; select the behavioral V1 beachhead and validation cohort.
- [x] Build and validate the reusable frontend-definition workflow and its four global skills.
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

### Parallel Track — Demo Identity

**User outcome:** Contributors can apply one consistent hackathon identity across the product, demo, and submission materials without recreating or recoloring assets.

- [x] Select the Acid Dispatch palette.
- [x] Select wordmark concept 01 and icon concept 03.
- [x] Approve the combined lockup with icon 03 replacing the `o` in “Mirror.”
- [x] Generate ImageGen masters for the wordmark, combined lockup, and standalone icon.
- [x] Export exact-color PNG, SVG, PDF, favicon, and application-size variants under `company/brand/`.
- [x] Document usage, minimum sizes, color treatments, and reproducible export instructions.
- [x] Complete the reusable 19-page brandbook loop and audited PDF packet under `company/brand/`.

## Next

1. Run `$product-prd-spec` with a founder walkthrough to create and approve the Magic Mirror PRD, user stories, screen/state inventory, and Given/When/Then scenarios.
2. Interview ten U.S. adult online apparel shoppers who can show a recent uncertain item; compare “Should I buy this?” messaging with generic “virtual try-on” messaging.
3. Resolve photo processing, retention, and deletion behavior before asking interview participants to upload real photos.
4. Benchmark two to three generation providers for identity and garment fidelity, p50/p95 latency, reliability, and cost across a representation-diverse, consented or synthetic test set.

## Decisions

- 2026-07-17: Use a monorepo structure.
- 2026-07-17: Maintain a living plan with user outcomes and explicit next actions.
- 2026-07-17: V1 remains limited to the single-photo, single-garment try-on golden path.
- 2026-07-17: Use short-lived branches and dedicated worktrees for concurrent tasks; PRs and squash merges are optional, and merged work is pruned.
- 2026-07-17: Encourage time-boxed experiments while protecting a functioning golden path as the primary deliverable.
- 2026-07-17: Require every feature handoff and optional PR to document what changed, why, and the expected outcome.
- 2026-07-17: After verification, commit and push completed feature-branch work without separate approval; keep its open PR description and progress comments current.
- 2026-07-17: Keep agent communication concise; summarize material changes and rationale without repeating routine tests or formalities.
- 2026-07-17: Use `company/` as the canonical home for the plan, company profile, operating memory, workflows, automations, and artifacts; treat U.S.-first geography as a reversible assumption and keep monetization hypotheses uncommitted.
- 2026-07-17: Proceed with the V1 under conditions and position it as a cross-retailer “Should I buy this?” decision companion; generic virtual try-on, full closet onboarding, and broad AI-stylist functionality are not differentiated V1 positions.
- 2026-07-17: Treat event-driven U.S. online apparel shoppers ages 18–44 as the first validation wedge, not a committed target segment; test underrepresented ages, body shapes, and skin tones in research and provider benchmarks.
- 2026-07-17: Keep consumer subscription and affiliate monetization as unvalidated hypotheses until real activation, repeat-use, willingness-to-pay, and attributed-purchase evidence exists.
- 2026-07-17: Supersede the age-based audience shorthand with a behavioral V1 beachhead: U.S. adult online apparel shoppers deciding on one garment for a near-term, personally important occasion; the initial decision window is seven days and remains a validation assumption.
- 2026-07-17: Treat age, body shape, skin tone, gender presentation, and fashion confidence as representation and quality-testing dimensions rather than targeting requirements; do not market to an underrepresented group until provider performance supports the claim.
- 2026-07-17: Use social-first frequent fashion evaluators as the first expansion segment and creators/stylists as a later influence and distribution layer, not as V1 paying users.
- 2026-07-18: Use the Acid Dispatch palette, concept-01 editorial wordmark, and concept-03 lens/focus icon for the hackathon identity.
- 2026-07-18: Maintain three approved identity forms: standalone wordmark, combined lockup with the icon replacing the `o`, and standalone icon.
- 2026-07-18: Treat ImageGen outputs as approved visual masters, then create exact-color sizes and vector paths deterministically so production exports do not drift between variants.
- 2026-07-18: Build the brandbook as a durable, task-backed loop with page, mockup, token, PDF-render, and final-audit evidence rather than as a one-off document.
- 2026-07-18: Generate every brand application mockup with ImageGen as a raster asset; do not use HTML/CSS, SVG, canvas, or deterministic UI rendering for mockup imagery. Browser/favicon applications require separate light and dark generated images. HTML/CSS remains valid only for the brandbook page source and non-mockup token/UI specimens.
- 2026-07-18: Treat the Mayven 19-page packet as the page-by-page composition authority for the Magic Mirror brandbook: US Letter landscape, restrained title blocks, matching hierarchy/whitespace/density, and compact application pages above dominant raster mockups. Mayven branding, copy, colors, and travel imagery remain reference-only and must not be copied.
- 2026-07-18: Require standardized application mockups to be recognizable from structure alone. Twitter/X, LinkedIn, and browser/favicon use distinct platform-specific ImageGen compositions; LinkedIn cannot reuse the X phone/profile layout.
- 2026-07-18: Twitter/X application examples always pair one light-mode profile/avatar treatment with one dark-mode treatment, reversing the icon for clear contrast rather than duplicating one color treatment across both phones.
- 2026-07-18: Accepted the reusable 19-page Magic Mirror brandbook packet after PDF-derived visual QA, a Mayven-to-Magic composition audit, and complete task/evidence verification under `company/brand/brandbook-packet/`.
- 2026-07-18: Use the approval-gated frontend-definition sequence `product-prd-spec → product-ux-design → copywriting → product-screen-mockups → engineering handoff`.
- 2026-07-18: Build low-fidelity wireframes as responsive grayscale HTML/CSS and capture deterministic PNGs; create every high-fidelity screen mockup as a built-in ImageGen raster using the approved wireframe, copy, voice, and brand references.
- 2026-07-18: Treat `company/voice.md` and `company/artifacts/copy/copy-manifest.json` as canonical for implementation copy because text rendered inside generated mockups may drift.
- 2026-07-18: Record data, authentication, permissions, async status, storage, privacy, failure, and recovery implications during frontend definition, while leaving backend architecture and implementation to the engineering workflow.

## Roadmap Backlog (V2+)

- Stylist and shopping recommendations.
- Voice input.
- Multi-garment outfits.
- Deep stylist reasoning.
- Brand and visual-identity investment.
