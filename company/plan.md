# Magic Mirror — Living Plan

## How to Use This Plan

This file is the source of truth for roadmap, sequencing, status, and next actions. Update it in the same change whenever scope, decisions, or task status changes. Each phase must produce a clear user outcome, and each task must be checkable. The approved PRD package lives under `company/artifacts/prd/`; founder-requested implementation context for future engineering planning lives in `company/build-notes.md`.

## Product Goal

Deliver the approved real report-led product in coherent increments: first anonymous style evidence, account connection, a persistent style report, and cross-retailer recommendations; then live styling, distance controls, saved selections, and transparent retailer handoff.

## Scope Guardrail

The approved PRD v1.1.0 is the product contract and supersedes the older single-photo/single-garment roadmap. The first coherent release is the Style Intelligence Golden Path: anonymous onboarding, 8–12 favorite-look photos, Wardrobe-inspired extraction or its approved fallback, dynamic Love/Hate/Maybe calibration, Google or email magic-link account connection, real analysis, a persistent report, and real cross-retailer recommendations. Live styling, voice, gestures, product detail, bag, and retailer handoff remain approved should-have phases. Magic Mirror does not own checkout, payment, fulfillment, retailer price/inventory, or guaranteed fit. Provider access, retention, privacy, quality, and engineering details remain explicit build-readiness decisions.

## Delivery Strategy

Move at hackathon speed while keeping the golden path runnable. Use a dedicated branch and worktree for each concurrent task or experiment, integrate small working changes frequently, and prune merged worktrees and branches. PRs and squash merges are optional. Time-box experiments, define their cheapest success signal, and keep them off the critical path unless they reduce a launch-critical risk.

OpenAI Build Week submissions close Tuesday, July 21, 2026 at 5:00 PM Pacific / 8:00 PM Eastern. The required submission includes a working project, one category, a project description, a public narrated YouTube demo under three minutes, the code repository and runnable README, and the primary build task's `/feedback` Codex Session ID. DigitalOcean App Platform is the fixed production/hosting product. The approved feature/code freeze is 1:00 PM Pacific / 4:00 PM Eastern, followed by the demo/submission freeze at 3:00 PM Pacific / 6:00 PM Eastern.

## Roadmap

### Phase 0 — Define and De-risk

**User outcome:** The planned experience is feasible, measurable, and safe enough to build.

- [x] Establish the base Magic Mirror company profile and operating workspace from the product strategy.
- [x] Complete U.S.-first market research and competitor analysis for the V1 purchase-decision opportunity.
- [x] Define and score candidate audiences; select the behavioral V1 beachhead and validation cohort.
- [x] Add and decompose the approved PRD.
- [x] Define user stories, screen inventory, and Given/When/Then scenarios.
- [ ] Evaluate generation providers using latency, output quality, reliability, integration effort, and cost.
- [ ] Decide photo retention and deletion behavior before storing real user photos.
- [ ] Confirm the minimum garment catalog and required source assets.
- [x] Record the official OpenAI Build Week submission deadline and required deliverables from Devpost.
- [x] Approve the internal feature/code freeze and demo/submission freeze in the engineering-readiness input form.
- [x] Record the initial preferred service roles and integration context for the future engineering and build plans.
- [ ] Spike critical Wardrobe-inspired garment extraction between photo upload and taste calibration using representative 8–12-photo sets; measure reliability, per-image latency, partial failure, review need, and the direct style-signal fallback.
- [ ] Benchmark Decart live try-on quality, category coverage, latency, and recovery across representative users and garments in parallel with Phase 1/2 rather than waiting for live-styling implementation.
- [ ] Prove that Gemini Live voice/session context, Decart realtime video, and gesture recognition can operate together on one target demo device; compare sampled video/screen context with structured session state.
- [ ] Benchmark OpenAI-generated customer-likeness wardrobe previews against the approved quality/fallback bar after Shopify product-image reuse permission is resolved.
- [ ] Validate Shopify Global Catalog text/image search quality, apparel coverage, offer clustering, retailer handoff, usage constraints, and rate behavior.

### Phase 1 — Project Foundation

**User outcome:** A user can open a functioning application shell ready for the try-on flow.

- [ ] Scaffold the founder-constrained TypeScript application using Vite, Tailwind, and Bun, with a TypeScript API layer.
- [ ] Configure strict TypeScript, validation, and the approved testing approach within that stack.
- [ ] Configure Supabase for database, authentication, and private asset storage and document required environment names without secret values.
- [ ] Add the minimum schema, migrations, storage buckets, and row-level security.

### Frontend Design Workflow

**User outcome:** The approved journey has a complete, traceable structure before visual styling or frontend implementation begins.

- [x] Approve the report-led product PRD, 23 user stories, and 15 scenarios.
- [x] Audit and expand the UX inventory to 48 explicit screen/state records.
- [x] Decompose every screen/state into ordered Relume-style sections.
- [x] Generate anonymous desktop/mobile HTML wireframes and PNG captures for every section and assembled screen.
- [x] Review and approve the UX wireframe package.
- [x] Run the copywriting step and create the reusable product `voice.md` plus screen-copy manifest.
- [x] Review and approve the voice system and all 48 screen/state copy records.
- [x] Run the product-screen-mockups step using approved wireframes, copy, company context, and brand assets.
- [x] Establish the shared Acid Dispatch / Editorial Edge screen direction and generate the responsive landing-page representative.
- [x] Approve the representative landing-page direction.
- [x] Generate all 48 screen/state records in desktop and mobile across marketing, account, onboarding, report, style-home, live-styling, voice, gesture, and commerce families.
- [x] Complete the visual audit and strict handoff validation across all 96 final raster mockups.

### Adopted Direction — Conversational Onboarding V2

**User outcome:** A visitor can build the same complete pre-report style profile through one continuous, responsive conversation instead of moving through a sequence of conventional forms.

**Hypothesis:** A persistent chat and generative-UI shell will make onboarding feel more personal and fluid while still collecting every structured answer required for the style report.

**User value:** Questions arrive one at a time, visual choices and uploads appear directly inside the conversation, previous answers remain easy to review or edit, and the user always understands what remains before their report begins.

**Time box:** One design pass in the current frontend-design session, ending with a complete desktop/mobile comparison package rather than production implementation.

**Cheapest success signal:** The founder can review the v1 and v2 packages side by side and confirm that the conversational flow is understandable without explanation, preserves all required inputs, exposes accessible alternatives to gestures, and provides clear progress and recovery states.

- [x] Preserve the approved form-based v1 package without replacement or mutation.
- [x] Research conversation design, generative UI, human-in-the-loop patterns, and adaptive onboarding.
- [x] Reject the initial v2 pass because it wrapped existing forms in chat containers and added an unnecessary sidebar.
- [x] Replace the v2 registry, dialogue, and interaction contract with one-question-per-turn chat-first behavior.
- [x] Regenerate every v2 desktop/mobile mockup with a narrow transcript, minimal progress, and no sidebar.
- [x] Audit text-first collection, contextual component restraint, smooth turn-taking, editability, accessibility, and processing handoff.
- [x] Founder adopted chat-first v2 for pre-report implementation and archived the form-based v1 pre-report comps as reference.

### Build Planning

**User outcome:** The approved product can move into engineering with a founder-readable sequence, explicit readiness gates, and complete traceability.

- [x] Create the amended build plan under `company/artifacts/build-plan/build-plan.md`.
- [x] Founder reviews and approves the amended build plan.
- [x] Resolve or assign the critical build-readiness blockers before implementation authorization, including the explicit deferred OpenAI-funding assumption and mandatory ticket-level recheck.
- [x] Complete the exact application contract package for API, auth, integrations, state/error behavior, and every canonical/v2 screen action.
- [x] Pass the cross-contract review and repair every screen/data/provider mismatch before ticketing.
- [x] Complete the checkpointed engineering-plan workflow from the founder-approved build plan.

### Phase 1 — Trustworthy Entry and Style Evidence

**User outcome:** A visitor can start anonymously, provide respectful profile and size context, upload 8–12 qualifying favorite-look photos, and complete Love/Hate/Maybe calibration without losing valid work.

- [ ] Implement the report-led entry, anonymous ownership, account access, consent, accessibility, and recovery baseline.
- [ ] Implement chat-first name, adult confirmation, gender, age, height, optional weight, explicit overall fit preference, favorite-brand, and brand/garment-type-size collection using one validated profile contract.
- [ ] Derive bounded per-garment-type fit guidance from the customer’s stated fit preference and brand/garment-type observations, retaining conflicting evidence and never presenting a universal-size guarantee.
- [ ] Implement private favorite-look photo collection with independent validation, the approved retention policy, and the critical Wardrobe extraction/fallback step.
- [ ] Implement dynamically sourced Love/Hate/Maybe calibration seeded by extracted garments and style signals, with undo, recovery, and a balanced fallback set.

### Phase 2 — Connected Report and Style Home

**User outcome:** A customer connects Google or email magic-link access, receives a real explainable report, and browses current cross-retailer recommendations matched to it.

- [ ] Connect or merge anonymous progress into a permanent account without loss or exposure.
- [ ] Implement the real analysis lifecycle with meaningful processing, slow, notification, failure, and retry states.
- [ ] Implement the explainable, correctable style report with safe OpenAI-generated wardrobe previews linked to current products when all gates pass and complete text/link fallback otherwise.
- [ ] Implement persistent Style Home and Shopify Global Catalog recommendations with current retailer provenance.

### Phase 3 — Live Styling and Distance Controls

**User outcome:** A customer can visualize a supported item live and control the session through direct, voice, or approved hand-gesture actions.

- [ ] Implement recoverable Decart live styling with deliberate camera permission and direct controls.
- [ ] Implement Gemini Live voice/session-aware refinement through the shared action/confirmation contract.
- [ ] Implement the approved gesture vocabulary with confirmation and direct/voice alternatives.

### Phase 4 — Retailer Action

**User outcome:** A customer can inspect current product details, save selections in a Magic Mirror bag, and continue knowingly to the retailer.

- [ ] Implement current product detail and unavailable-item alternatives.
- [ ] Implement the account-backed Magic Mirror bag using stable references and refreshed catalog data.
- [ ] Implement transparent retailer handoff with approved attribution and preserved return state.

### Phase 5 — Demo Readiness

**User outcome:** The approved journey works reliably on the hosted demo with known support limits and recovery paths.

- [ ] Pass all approved BDD scenarios included in the demo scope.
- [ ] Measure report, catalog, live-video, voice, and action latency against the approved quality bars.
- [ ] Verify cross-user isolation, retention/deletion, provider recovery, and accessibility evidence.
- [ ] Deploy to the approved environment and run production smoke tests.
- [ ] Document known limitations and degraded-demo recovery steps.

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

1. Claim and execute `ENG-024 — Create durable processing-job lease records` in its dedicated ticket branch/worktree.
2. Continue the dependency-safe deployable-baseline sequence through `ENG-155`; nine tickets now pass (`ENG-001` through `ENG-006`, `ENG-008`, `ENG-013`, and `ENG-014`), and `bootstrap-deferred` remains permitted only for the named baseline prerequisites.
3. Execute exactly one ticket per implementation turn; mark it passed only after all required evidence succeeds and synchronize the authoritative plan, derived index, and progress memory.

## Decisions

- 2026-07-21: Complete `ENG-014` with a non-exposed `private` schema, explicit least-privilege schema/default grants, an empty-search-path `SECURITY INVOKER` updated-at trigger helper, and 19 focused pgTAP checks; introduce no `SECURITY DEFINER` helper before its owning ticket can enforce a verified-owner contract.
- 2026-07-21: Complete `ENG-013` with closed shared Zod schemas for live sessions, Decart/Gemini credentials and consent modes, independent voice/gesture substates, and all nine direct/voice/gesture action variants; reject unknown commands, arbitrary URLs, invalid confidence/source combinations, malformed consent pairs, and invalid source lineage before application logic.
- 2026-07-21: Complete `ENG-006` with separate Zod server/browser environment contracts, strict Vite variable typing, single-name redacted startup failures, explicit server-only browser rejection, synthetic smoke fixtures, and emitted-bundle secret checks; disable dotenv loading in negative API processes so local secrets cannot mask missing configuration.
- 2026-07-21: Complete `ENG-008` with a shared `@magic-mirror/contracts` workspace containing strict UUID/request-ID, normalized-error, and keyset-pagination Zod schemas; pin the approved 118-code allowlist, reject unknown external keys and malformed discriminators, bound collection responses to 50 items, and defer development deployment to `ENG-155`.
- 2026-07-21: Complete `ENG-005` with a CLI-generated local-only Supabase/Postgres 17 harness, two data-only synthetic Auth identities, transactional pgTAP role/owner-isolation tests, explicit intentional-leak failure proof, and zero-test rejection; keep product tables for their owning migrations and make no linked or hosted-project mutation.
- 2026-07-21: Complete `ENG-004` with pinned Vitest repository/API/web projects, Playwright Chromium local-server execution, stable root and focused-file commands, migrated scaffold coverage, browser console/network assertions, and automated nonzero assertion-failure proof; keep browser binaries in developer/CI caches and deployment deferred to `ENG-155`.
- 2026-07-21: Complete `ENG-003` with a native Bun TypeScript API, Zod-validated startup configuration, documented `GET /health` response, request IDs, visible configuration failure, root commands, process-level tests, and a portable smoke; defer product routes, auth, provider calls, and deployment to their owning tickets.
- 2026-07-21: Complete `ENG-002` with a strict Vite 8/React 19/React Router 7/Tailwind 4 web scaffold, package-local browser types, root web commands, negative typecheck coverage, production-bundle verification, and live dev-server smoke; defer visual/product routes to their owning tickets and deployment to `ENG-155`.
- 2026-07-21: Complete `ENG-001` with a reproducible private Bun workspace, strict shared TypeScript configuration, frozen lockfile, workspace-failure test, and secret-safe ignore rules; record development deployment as `bootstrap-deferred` until the first deployable baseline at `ENG-155`.
- 2026-07-21: Talisha White approved the 162-ticket engineering plan for runtime execution. Future execution uses the full plan as authority and a generated compact ticket index for selection.
- 2026-07-21: Pass the formal engineering-plan final review after repairing archived-v1 screen leakage, experiment hypotheses/thresholds, Vitest command grounding, DigitalOcean validator ownership, generic ticket language, readiness/risk mappings, and dependency-change evidence; the subsequently approved 162-ticket package is authorized for controlled runtime implementation.
- 2026-07-21: Replace the rejected 36-workstream engineering package with 162 independently executable tickets covering all approved features, stories, scenarios, canonical screens, conversational-v2 screens, and OpenAPI operations; require one target, explicit implementation/test/rollback units, focused automated proof, exact UI references, and live verification for external provider boundaries before any ticket can pass.

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
- 2026-07-19: Approved the report-led frontend PRD with anonymous onboarding continuity, Google or email magic-link account connection, a one-to-two-minute report target, live styling by voice/hand/direct controls, and retailer handoff rather than in-product checkout.
- 2026-07-19: Removed the proposed automatic 24-hour photo-deletion promise from the product contract; sensitive-photo retention remains an engineering and policy decision rather than a frontend status feature.
- 2026-07-19: Require UX wireframes to be anonymous Relume-style structural artifacts using `LOGO`, generic headings and controls, lorem ipsum, and gray media placeholders; product-specific copy belongs to the later copywriting step.
- 2026-07-19: Require every explicit screen state to have stable screen/state paths, ordered independent sections, an assembled screen, and desktop/mobile HTML-derived PNG captures.
- 2026-07-19: Use unique kebab-case `screen_slug` values derived from screen names for human-readable wireframe folders; keep stable UUID `screen_id` values in structured metadata only and never print review metadata inside a wireframe canvas.
- 2026-07-19: Place lorem ipsum only in components that structurally contain body copy; never append validator-only placeholder sections or orphan paragraphs to a screen.
- 2026-07-19: Approved the complete section-first UX package with 48 screen/state records, 194 ordered sections, and 484 desktop/mobile captures.
- 2026-07-19: Use an editorial, affirming, specific, energetic, and transparent draft voice that treats style findings as interpretive guidance, preserves customer control, and states retailer and visualization boundaries directly; final voice and screen copy remain pending founder approval.
- 2026-07-19: Approved the customer-facing voice and revised 48-screen copy package; interface visuals lead, while copy advances the outcome, reassures, or helps the customer act without exposing internal product language.
- 2026-07-19: Use the responsive Landing Page — Base as the representative visual-direction gate before propagating Acid Dispatch / Editorial Edge across the remaining screen mockups.
- 2026-07-19: Approved the responsive Landing Page — Base direction and authorized uninterrupted generation of the complete desktop/mobile mockup package for review at the end.
- 2026-07-19: Completed the full ImageGen-only product-screen-mockups handoff with 48 desktop and 48 mobile raster comps, including explicit live voice/gesture state continuity and retailer-site checkout boundaries; the package is ready for founder review.
- 2026-07-19: Started conversational-onboarding v2 as an additive experiment; the later founder amendment adopted it for pre-report implementation and archived form-based v1 pre-report comps as reference.
- 2026-07-19: Completed the conversational-onboarding v2 comparison package with eight desktop/mobile ImageGen states, structured copy and interaction contracts, factual review/edit controls, and a validated handoff to existing report processing; extend for founder comparison while keeping v1 intact.
- 2026-07-19: Founder rejected the first conversational v2 visual pass because it preserved form-first interaction, placed forms inside chat containers, and used an unnecessary sidebar; redesign from conversation logic with one text question per turn and UI only for visual or secure moments.
- 2026-07-19: Rebuilt the conversational v2 from researched conversation-design principles: one text question per turn, no sidebar, and contextual UI only for photo, taste, authentication, and final-confirmation moments; all 16 rejected rasters were removed from the canonical package and replaced while v1 remained intact.
- 2026-07-19: Use OpenAI for the core agent, still-image generation/editing, and realtime voice; use Decart Lucy VTON for realtime virtual try-on; use Shopify Global Catalog MCP/Catalog API for cross-retailer discovery and seller handoff, with Storefront Catalog reserved for intentionally single-merchant requests. Evaluate `tandpfun/wardrobe` specifically as a favorite-look garment extraction, deduplication, review, and wardrobe-UI reference before committing it to the product architecture.
- 2026-07-19: The approved report-led PRD v1.1.0 supersedes the older single-photo/single-garment V1 decision and stale backlog entries; sequence the real product as Style Intelligence Golden Path, cross-retailer recommendations, live styling/distance controls, and retailer action.
- 2026-07-19: Created and founder-approved the amended build plan with seven vertical phases, 16 traceable features, 29 readiness items, and a Not Ready implementation gate pending founder decisions, access, privacy, and provider evidence.
- 2026-07-19: Authorized the checkpointed engineering-plan workflow; approval of planning does not authorize implementation.
- 2026-07-19: Adopt chat-first conversational onboarding v2 for all pre-report implementation and preserve form-based v1 pre-report comps as archived reference; FEAT-004 retains one validated profile contract.
- 2026-07-19: Fix the implementation stack as TypeScript with Vite, Tailwind, and Bun for the frontend, TypeScript for the API layer, and Supabase for database, auth, and private asset storage.
- 2026-07-19: Use Gemini Live instead of OpenAI Realtime for live voice/session awareness; retain OpenAI for the text agent, report generation, and still-image generation/editing.
- 2026-07-19: Put Wardrobe-inspired garment extraction on the release-one critical path between photo upload and dynamic taste calibration, with partial-failure preservation and a direct style-signal fallback.
- 2026-07-19: Add OpenAI-generated customer-likeness wardrobe previews linked to current Shopify products to report recommendations when consent, quality, and product-image permission pass; otherwise deliver complete text/link recommendations.
- 2026-07-19: Start Decart feasibility and Gemini/Decart/gesture concurrency spikes in parallel with the earliest product phases to surface the highest demo risks before live-styling implementation.
- 2026-07-19: Use DigitalOcean for production and hosting; the exact DigitalOcean product, account access, domain, and secure-secret configuration are captured through the engineering-readiness input form.
- 2026-07-19: OpenAI Build Week submissions close Tuesday, July 21, 2026 at 5:00 PM Pacific / 8:00 PM Eastern and require a working project, narrated public demo under three minutes, code repository and runnable README, category, project description, and primary Codex `/feedback` Session ID.
- 2026-07-20: Approve DigitalOcean App Platform, internal freeze times, the privacy/consent policy, taste and identity policies, Gemini/Decart access attestations, and the safe local/deployed secret boundary; keep engineering planning blocked on the remaining external-access, test-data, and catalog-image-rights items.
- 2026-07-20: Create the paid `magic-mirror` Supabase project in `us-east-1`, verify it is healthy, and place only its browser-safe URL and publishable key in gitignored local configuration; reserve the service-role key for server-side secret storage.
- 2026-07-20: Verify successful Magic Mirror magic-link delivery through Supabase custom SMTP and Resend.
- 2026-07-20: Treat Shopify Global Catalog as a verified keyless external boundary; publishing Magic Mirror's required UCP profile is application/deployment work, not a founder-access blocker.
- 2026-07-20: Proceed with Shopify catalog-image transmission for the hackathon under explicit founder risk acceptance while stating that official documentation does not establish merchant/provider permission; do not represent this decision as authorization.
- 2026-07-20: Use the private eight-image founder-owned set under `/Users/talishawhite/Documents/Magic Mirror Test Data/` as the real testing baseline; synthetic fixtures are authorized for broader checks but cannot substantiate real-user population claims.
- 2026-07-20: Advance engineering planning under the founder-approved assumption that OpenAI credits will be added later; retain the verified `insufficient_quota` result and require successful paid-call reverification before any OpenAI-dependent ticket executes or passes.
- 2026-07-20: Pass the application-contract review after repairing profile/brand facts, consent ordering, signed upload and atomic replacement, photo ordering/formats, durable idempotency, live action sequencing, exact response/error schemas, report timing states, Shopify reference handling, suggested outfits/saved Style Home content, post-report recalibration, and 49/49 schema-conforming operation examples; advance planning to engineering tickets without starting implementation.
- 2026-07-21: Amend onboarding and contracts so sizes are stored per brand + garment type, ask overall fit preference explicitly, and require deterministic fit-profile derivation with visible uncertainty before engineering ticket generation.

## Roadmap Backlog (V2+)

- Full digital closet and optional Wardrobe-inspired garment library.
- Multi-garment layered live outfits after provider evidence supports them.
- In-product retailer checkout, payment, fulfillment, or returns ownership.
- Social network, creator marketplace, and retailer analytics.
