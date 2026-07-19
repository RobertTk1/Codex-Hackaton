# Magic Mirror — Living Plan

## How to Use This Plan

This file is the source of truth for roadmap, sequencing, status, and next actions. Update it in the same change whenever scope, decisions, or task status changes. Each phase must produce a clear user outcome, and each task must be checkable. The detailed PRD package in `company/artifacts/prd/` was approved by Talisha White on 2026-07-19 as the foundation for UX design. Configuration gates and their exact blockers live in [Configuration To-Do](configuration-todo.md).

## Product Goal

Deliver a style-report-led product that learns a customer's taste and body-style needs, explains how to dress better, recommends relevant products, enables live visual styling controlled from a distance by voice or hand gestures, and sends selected products to retailers for checkout.

## Scope Guardrail

The first functional build is the Style Intelligence Golden Path: anonymous onboarding, profile and brand sizes, 8-12 favorite-look photos, Love/Hate/Maybe taste calibration, Google or email magic-link permanent account connection, real analysis, a report within a target of one to two minutes, and real curated recommendations. The complete frontend definition includes live styling controlled by voice or camera-recognized hand gestures, the Magic Mirror bag, and retailer handoff as real product behavior, while engineering releases may stage those capabilities behind verified provider quality and recovery criteria. Do not describe intended capabilities as pretend behavior or commit dead product stubs.

## Delivery Strategy

Move at hackathon speed while keeping the golden path runnable. Use a dedicated branch and worktree for each concurrent task or experiment, integrate small working changes frequently, and prune merged worktrees and branches. PRs and squash merges are optional. Time-box experiments, define their cheapest success signal, and keep them off the critical path unless they reduce a launch-critical risk.

Feature-level execution plans live under `company/flows/<flow-name>/plan.md` and are referenced from the relevant roadmap phase. The canonical plan owns sequencing and status; flow plans own implementation tasks and acceptance criteria.

## Roadmap

### Phase 0 — Define and De-risk

**User outcome:** The planned experience is feasible, measurable, and safe enough to build.

- [x] Establish the base Magic Mirror company profile and operating workspace from the product strategy.
- [x] Complete U.S.-first market research and competitor analysis for the V1 purchase-decision opportunity.
- [x] Define and score candidate audiences; select the behavioral V1 beachhead and validation cohort.
- [x] Extract the original product strategy into a focused single-photo V1 PRD and preserve that implementation baseline.
- [x] Build and validate the reusable frontend-definition workflow and its four global skills.
- [x] Create, decompose, and approve the full PRD package.
- [x] Define the golden-path Given/When/Then scenario and acceptance criteria.
- [x] Obtain explicit founder approval for the PRD package.
- [x] Create the complete UX package with IA, navigation, five critical flows, UX notes, and responsive grayscale wireframes for all 27 approved screens.
- [ ] Evaluate generation providers using latency, output quality, reliability, integration effort, and cost.
- [ ] Define a production storage and lifecycle policy for source photos; the current product makes no automatic-expiration promise.
- [ ] Confirm the minimum garment catalog and required source assets.
- [ ] Define the submission deadline, demo cutoff, and experiment time budget.

### Phase 1 — Project Foundation

**User outcome:** A customer can open a functioning application shell ready for the report-led journey.

**Completed flow:** [`First Try-On Tracer`](flows/first-try-on-tracer/plan.md) — one-page photo upload, hardcoded garment selection, typed mock request, and bottom-of-page result. This remains a runnable proof-of-flow while the product target advances to Style Intelligence.

**Configuration-pending flow:** [`Data Foundation`](flows/data-foundation/plan.md) — versioned sessions, asset references, private storage policies, and environment names with no live project values.

**Completed flow:** [`Style Onboarding Tracer`](flows/style-onboarding-tracer/plan.md) — report-led landing page, validated profile, one brand-size entry, and browser-session-only continuity.

**Completed flow:** [`Demo Catalog`](flows/demo-catalog/plan.md) — three local, image-backed garments for the preserved mock try-on selector.

- [x] Scaffold the Next.js application in `apps/web` with required development, lint, typecheck, unit-test, and end-to-end-test scripts.
- [x] Configure Tailwind, strict TypeScript, Zod, Vitest, and Playwright.
- [x] Document required Supabase and provider environment variables with placeholders; live values remain unconfigured.
- [x] Add the minimum versioned schema, private bucket definition, and row-level policies; applying them remains blocked on project and auth configuration.
- [x] Build the report-led landing and first two onboarding steps as a local browser-session tracer; anonymous authentication and persistent storage remain configuration-gated.

### Phase 2 — Style Intelligence Golden Path

**User outcome:** A first-time customer can teach Magic Mirror their style and receive a real personalized report and curated recommendations.

- [x] Preserve the runnable mock tracer with local photo preview, hardcoded garment selection, typed validation, and explicit request states as an implementation baseline.
- [x] Replace the mock tracer's garment color swatches with three local, image-backed demo catalog items.
- [ ] Implement the report-led landing page and resumable guided onboarding.
- [ ] Implement personal profile, favorite brands, and category-specific sizes.
- [ ] Implement secure 8-12 favorite-look photo upload with validation, consent, and per-account isolation.
- [ ] Implement right/Love, left/Hate, and down/Maybe swipes with matching buttons, keyboard controls, and undo.
- [ ] Create an anonymous authenticated identity when onboarding begins and preserve every input under it.
- [ ] Implement one Google and email magic-link account step that signs up or logs in and connects anonymous progress.
- [ ] Implement the typed analysis-provider boundary with timeout and normalized errors.
- [ ] Generate the complete structured style report and personalized catalog recommendations.
- [ ] Meet the one-to-two-minute target with processing, slow, success, failure, and recovery behavior.

### Phase 3 — Live Styling and Retailer Action

**User outcome:** A report recipient can experience recommended items, refine the session naturally, and continue to a retailer with confident selections.

- [ ] Benchmark and implement real live video try-on with camera permission and explicit fidelity limits.
- [ ] Implement voice requests with visible interpretation, confirmation, and equivalent direct controls.
- [ ] Implement camera-recognized hand gestures for next outfit, previous outfit, and visible-control selection from a practical standing distance.
- [ ] Confirm consequential gesture actions and benchmark recognition accuracy and accidental actions across the representation test set.
- [ ] Implement a Magic Mirror bag grouped by retailer.
- [ ] Refresh product availability and explain the external retailer boundary.
- [ ] Send selected products to the correct retailer-owned checkout destination.

### Phase 4 — Demo Readiness

**User outcome:** The approved release journey works reliably in the hosted demo.

- [ ] Pass the Playwright happy-path scenario.
- [ ] Measure end-to-end render latency and address demo-breaking bottlenecks.
- [ ] Verify anonymous/permanent account continuity and cross-user isolation.
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

### Parallel Track — API & MCP Access (Post-Golden Path)

**User outcome:** A trusted external agent, web client, or mobile client can submit an authorized image and garment selection, then observe a request through a stable API contract.

- [ ] Define caller identity, user-image ownership, allowed actions, quotas, and audit requirements.
- [ ] Define a versioned request plus typed asynchronous status and error responses.
- [ ] Build a small authenticated API surface after the web golden path proves the same provider boundary.
- [ ] Expose an MCP server only after the API contract and user-image permission model are proven.

## Next

1. Review the landing, profile, and brand-size tracer against the approved wireframes, then decide whether to continue into favorite-look upload or revise this first slice.
2. Create canonical screen copy, `company/voice.md`, and the copy manifest before final visual implementation.
3. Define the minimum catalog and benchmark analysis providers against usefulness, respectful language, representation quality, reliability, and the 120-second report target.
4. Benchmark live try-on, voice, and gesture-recognition providers before scheduling their engineering release.

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
- 2026-07-18: Extracted `Magic Mirror Product Strategy.docx` into `company/artifacts/product/magic-mirror-v1-prd.md`; narrowed the source document's broad stylist MVP to a single-photo, single-garment, static try-on baseline. This was later superseded as the active golden path by the approved style-report-led definition.
- 2026-07-18: Store feature execution plans under `company/flows/<flow-name>/plan.md`; begin with the single-page `first-try-on-tracer` flow and reference it from the canonical roadmap.
- 2026-07-18: Build the Supabase data foundation as a migration and environment template without applying it; real project values, authentication, retention, and provider configuration remain explicit gates.
- 2026-07-18: Add a configuration checklist that names each missing integration decision and its blocker; generated local catalog imagery is valid for the demo but does not satisfy live product sourcing or a generation-provider decision.
- 2026-07-18: Plan a post-golden-path API and MCP surface for authorized external image submissions. First prove the web flow and define caller identity, image ownership, and typed async status before exposing it.
- 2026-07-19: Build the first report-led UI tracer as a truthful local browser-session flow: landing, profile validation, and brand-size entry. Preserve the earlier try-on tracer at `/tracer`; do not represent browser-session storage as anonymous authentication or persistent account data.
- 2026-07-18: Use the approval-gated frontend-definition sequence `product-prd-spec → product-ux-design → copywriting → product-screen-mockups → engineering handoff`.
- 2026-07-18: Build low-fidelity wireframes as responsive grayscale HTML/CSS and capture deterministic PNGs; create every high-fidelity screen mockup as a built-in ImageGen raster using the approved wireframe, copy, voice, and brand references.
- 2026-07-18: Treat `company/voice.md` and `company/artifacts/copy/copy-manifest.json` as canonical for implementation copy because text rendered inside generated mockups may drift.
- 2026-07-18: Record data, authentication, permissions, async status, storage, privacy, failure, and recovery implications during frontend definition, while leaving backend architecture and implementation to the engineering workflow.
- 2026-07-18: Supersede the prior single-photo, single-garment V1 with a style-report-led product definition: profile and brand sizes, 8-12 favorite-look photos, taste calibration, permanent account connection, real analysis, a report within one to two minutes, and curated recommendations form the first functional golden path.
- 2026-07-18: Define live styling, distance controls, the Magic Mirror bag, and retailer handoff as real intended product behavior; engineering may stage releases, but frontend requirements and copy do not characterize these capabilities as pretend behavior.
- 2026-07-19: Taste calibration uses Love, Hate, and Maybe with right, left, and down swipes plus equivalent button and keyboard controls.
- 2026-07-19: Onboarding begins under an anonymous authenticated identity; one Google and email magic-link step signs up or logs in and connects all anonymous progress.
- 2026-07-19: Live styling supports both voice and camera-recognized hand gestures for distance control, with direct controls and confirmation for consequential actions.
- 2026-07-19: Remove the automatic source-photo expiration promise and related timing/status UI from the active product scope; define storage lifecycle before production.
- 2026-07-19: Talisha White approved PRD v1.0.0, its 23 user stories, 15 Given/When/Then scenarios, and 27-screen responsive inventory as the foundation for UX design.
- 2026-07-19: Completed the full `product-ux-design` package for founder review; all 27 approved screen/state records have semantic grayscale HTML and visually verified desktop/mobile captures, and copywriting remains gated on explicit UX approval.
- 2026-07-18: Complete purchase through retailer-owned destinations rather than Magic Mirror payment and fulfillment.
- 2026-07-19: Extend the isolated Tinker vibe experiment pending owner visual review. Keep its downloaded source, reference media, evidence, and prototype under locally ignored `temp/`; do not copy reference code into the product or change Magic Mirror's copy/story until the interaction feel is approved. The first time box validated an original-code desktop/mobile prototype, including the scroll-linked hero and reduced-motion-aware idle screensaver, without modifying `apps/web`.

## Roadmap Backlog

- Persistent digital closet and wardrobe ingestion.
- Multi-item outfit building across the customer's owned wardrobe and retailer catalogs.
- Creator, human-stylist, and retailer collaboration surfaces.
- In-store and physical-mirror experiences.
- Retailer analytics and embedded distribution products.
