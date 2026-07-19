# Magic Mirror — Living Plan

## How to Use This Plan

This file is the source of truth for roadmap, sequencing, status, and next actions. Update it in the same change whenever scope, decisions, or task status changes. Each phase must produce a clear user outcome, and each task must be checkable. The extracted V1 requirements live in `company/artifacts/product/magic-mirror-v1-prd.md`.

## Product Goal

Deliver the V1 golden path: a user uploads or captures a photo, selects one garment, and receives a near-real-time rendered image or video of themselves wearing it.

## Scope Guardrail

Stylist recommendations, voice input, multi-garment outfits, deep stylist reasoning, and brand polish are V2+. Do not pull them into V1 unless the plan records an explicit scope decision.

## Delivery Strategy

Move at hackathon speed while keeping the golden path runnable. Use a dedicated branch and worktree for each concurrent task or experiment, integrate small working changes frequently, and prune merged worktrees and branches. PRs and squash merges are optional. Time-box experiments, define their cheapest success signal, and keep them off the critical path unless they reduce a launch-critical risk.

Feature-level execution plans live under `company/flows/<flow-name>/plan.md` and are referenced from the relevant roadmap phase. The canonical plan owns sequencing and status; flow plans own implementation tasks and acceptance criteria.

## Roadmap

### Phase 0 — Define and De-risk

**User outcome:** The planned experience is feasible, measurable, and safe enough to build.

- [x] Establish the base Magic Mirror company profile and operating workspace from the product strategy.
- [x] Complete U.S.-first market research and competitor analysis for the V1 purchase-decision opportunity.
- [x] Define and score candidate audiences; select the behavioral V1 beachhead and validation cohort.
- [x] Extract the product strategy into a focused V1 PRD and separate roadmap scope.
- [x] Define the golden-path Given/When/Then scenario and acceptance criteria.
- [ ] Evaluate generation providers using latency, output quality, reliability, integration effort, and cost.
- [ ] Decide photo retention and deletion behavior before storing real user photos.
- [ ] Confirm the minimum garment catalog and required source assets.
- [ ] Define the submission deadline, demo cutoff, and experiment time budget.

### Phase 1 — Project Foundation

**User outcome:** A user can open a functioning application shell ready for the try-on flow.

**Completed flow:** [`First Try-On Tracer`](flows/first-try-on-tracer/plan.md) — one-page photo upload, hardcoded garment selection, typed mock request, and bottom-of-page result.

**Configuration-pending flow:** [`Data Foundation`](flows/data-foundation/plan.md) — versioned sessions, asset references, private storage policies, and environment names with no live project values.

- [x] Scaffold the Next.js application in `apps/web` with required development, lint, typecheck, unit-test, and end-to-end-test scripts.
- [x] Configure Tailwind, strict TypeScript, Zod, Vitest, and Playwright.
- [x] Document required Supabase and provider environment variables with placeholders; live values remain unconfigured.
- [x] Add the minimum versioned schema, private bucket definition, and row-level policies; applying them remains blocked on project and auth configuration.

### Phase 2 — Golden Path

**User outcome:** A user can submit one photo and one garment and receive a visible try-on result.

- [x] Implement mock-tracer photo upload and validation; real consent and retention messaging remain blocked on policy.
- [x] Implement mock-tracer single-garment selection from a hardcoded catalog.
- [ ] Implement the typed generation-provider boundary with timeout and normalized errors.
- [ ] Persist try-on session state and generated-asset references.
- [x] Show explicit mock-tracer loading, slow, success, and failure states.

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

### Parallel Experiment — Tinker Vibe Study

**User outcome:** The owner can evaluate a Tinker-like landing-page feel, including its scroll pacing and idle screensaver, before product copy, story, or the integrated Magic Mirror application changes.

- [x] Time-box the reference study to three hours and keep it off the golden-path critical path.
- [x] Store downloaded public reference bundles, media, notes, and evidence only under the locally Git-ignored `temp/tinker-vibe-study/` workspace.
- [x] Build an original-code, dependency-free fidelity prototype with the reference copy retained temporarily for spacing and pacing comparison.
- [x] Verify the five-viewport desktop hero, simplified mobile hero, masonry layout, before/after control, idle screensaver, dismissal controls, and reduced-motion fallback.
- [ ] Complete owner visual review and explicitly adopt, continue, park, or discard the direction before changing product copy or integrating any portion into `apps/web`.

## Next

1. Benchmark two to three generation providers for identity and garment fidelity, p50/p95 latency, reliability, cost, commercial rights, and provider-side retention across a representation-diverse, consented or synthetic test set.
2. Resolve photo processing, retention, deletion, and consent behavior before asking participants to upload real photos.
3. Lock one garment category, minimum demo catalog, provider-compatible photo guidance, submission deadline, and fallback demo path.
4. Interview ten U.S. adult online apparel shoppers who can show a recent uncertain item; compare “Should I buy this?” messaging with generic “virtual try-on” messaging.

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
- 2026-07-18: Extracted `Magic Mirror Product Strategy.docx` into `company/artifacts/product/magic-mirror-v1-prd.md`; narrowed the source document’s broad stylist MVP to the approved single-photo, single-garment, static try-on golden path and retained adjacent capabilities as V2+.
- 2026-07-18: Store feature execution plans under `company/flows/<flow-name>/plan.md`; begin with the single-page `first-try-on-tracer` flow and reference it from the canonical roadmap.
- 2026-07-18: Build the Supabase data foundation as a migration and environment template without applying it; real project values, authentication, retention, and provider configuration remain explicit gates.
- 2026-07-19: Extend the isolated Tinker vibe experiment pending owner visual review. Keep its downloaded source, reference media, evidence, and prototype under locally ignored `temp/`; do not copy reference code into the product or change Magic Mirror’s copy/story until the interaction feel is approved. The first time box validated an original-code desktop/mobile prototype, including the scroll-linked hero and reduced-motion-aware idle screensaver, without modifying `apps/web`.

## Roadmap Backlog (V2+)

- Stylist and shopping recommendations.
- Voice input.
- Multi-garment outfits.
- Deep stylist reasoning.
- Brand and visual-identity investment.
