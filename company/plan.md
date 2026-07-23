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

1. Execute exactly one next ticket: `ENG-029 — Create the atomic report publication function`; publish one complete report, its ordered sections, recommendations, and accepted preview links as a single fail-closed transaction.
2. Keep every subsequent passing ticket integrated and deployed to `magic-mirror-dev`; leave production untouched until the QA and DevOps stages authorize it.
3. Execute exactly one ticket per implementation turn; mark it passed only after all required evidence succeeds and synchronize the authoritative plan, derived index, and progress memory.

## Decisions

- 2026-07-22: Complete `ENG-027` with owner-scoped report recommendation records containing stable Shopify references, bounded customer-facing rationale, deterministic report and outfit order, and at most one accepted wardrobe preview. Persist no price, inventory, retailer URL, catalog image, or provider payload. A private append-only attachment tombstone permits one null-to-preview transition for matching product/shop lineage and prevents reattachment after retention clears the preview. Focused 37-assertion, aggregate 689-assertion, signed-storage, intentional-leak, 105-test application, strict check, three-build, clean-archive app/build, ticket/integration CI, rollback-only hosted, advisor, development deployment, application rollback, and restoration checks pass with zero retained fixtures; production remains untouched.
- 2026-07-22: Complete `ENG-028` with generated asset and exact source-lineage records for garment cutouts, wardrobe previews, and try-on stills. Require current granted likeness consent for new likeness work, complete accepted-object metadata, pathless rejected/failed results, direct customer-photo lineage, stable catalog refs only, immutable source evidence, source-bounded deadlines, a 30-day likeness limit, owner-only unexpired reads, and narrow server DML. Focused 55-assertion, aggregate 652-assertion, signed-storage, intentional-leak, 105-test application, strict check, three-build, clean-archive, ticket-CI, integration-CI, rollback-only hosted, advisor, development deployment, application rollback, and restoration checks pass with zero retained fixtures; production remains untouched.
- 2026-07-22: Correct the approved ticket dependency graph without changing product scope: `ENG-027` cannot prove its required one-time attachment to an owned accepted preview until `ENG-028` creates the authoritative generated-asset contract, so make `ENG-027` depend on `ENG-028` and execute the asset ticket first. `ENG-029` already depends on both and remains unchanged.
- 2026-07-22: Complete `ENG-026` with immutable owner-versioned style reports and exact overview, color, and body-style section shapes. Require canonical positions, exactly one section of each type, a succeeded finalizing run, same-owner profile/run/report lineage, deterministic prior-report versioning, normalized bounded JSON, read-only owner RLS, and no raw model/provider payload storage. A hosted advisor found the new composite ownership foreign keys lacked covering indexes; add a forward migration and focused assertions, then confirm the ticket-specific findings clear. Focused 45-assertion, aggregate 597-assertion, signed-storage, intentional-leak, 105-test application, strict check, three-build, clean-archive, ticket-CI, integration-CI, rollback-only hosted publication, advisor, development deployment, application rollback, and restoration checks pass with zero retained fixtures; production remains untouched.
- 2026-07-22: Complete `ENG-025` with durable owner-scoped report-run lifecycle rows bound to one exact submitted profile revision. Enforce one unique request key, one live/succeeded slot, explicit one-to-three user-visible sequences, zero-to-two internal attempts, monotonic meaningful stages, exact normalized safe-error JSON, terminal immutability, retryable-only failure sequencing, and fail-closed success until a published report exists. Customers receive owner-only reads while server/worker roles own writes. One local migration retry replaced an unavailable JSON key-count function with an exact required/no-extra-key expression and removed an internal helper permission dependency. Focused 45-assertion, aggregate 552-assertion, signed-storage, intentional-leak, 105-test application, strict check, three-build, clean-archive, ticket-CI, integration-CI, rollback-only hosted, advisor, development deployment, application rollback, and restoration checks pass with zero retained fixtures; production remains untouched.
- 2026-07-22: Complete `ENG-023` with ordered candidate descriptors for extracted-garment, Shopify-reference, and balanced curated-fallback sources plus one Love/Hate/Maybe reaction row per candidate. Enforce exact source families, stable refs without catalog/provider payloads, bounded balancing tags, unique positions/fingerprints, a hard 20-candidate/active-reaction ceiling, server-timestamped undo rather than deletion, ready-candidate and draft-profile mutation, submitted-profile freezing, owner-scoped RLS, source-garment purge survival, and anonymous-account transfer. One focused-test retry corrected the synthetic anonymous identity and exact cross-owner failure expectation. Focused 66-assertion, aggregate 507-assertion, signed-storage, intentional-leak, 105-test application, strict check, three-build, ticket-CI, integration-CI, transactional hosted, advisor, development deployment, application rollback, and restoration checks pass with zero retained fixtures; production remains untouched.
- 2026-07-22: Complete `ENG-022` with normalized photo-style signals and per-garment extraction evidence that preserve successful sibling results beside explicit partial source-photo failure. Enforce exact owner/profile/photo lineage, source-bounded expiry, bounded arrays and record counts, narrow review transitions, server-only writes, authenticated owner-only unexpired reads, and no JSON/raw provider payload storage. A hosted advisor caught missing owner-leading photo foreign-key indexes before closure; add and verify the corrective migration. Focused 59-assertion, aggregate 441-assertion, intentional-leak, signed-storage, ticket-CI, integration-CI, transactional hosted RLS/retention/rollback, advisor, development deployment, application rollback, and restoration checks pass with zero retained fixtures; production remains untouched.
- 2026-07-22: Complete `ENG-021` with a private `customer-photos` bucket, bounded image media/size rules, no general customer insert grant, and one exact relational read policy that requires authenticated object retrieval, current owner, accepted-or-later metadata, an exact immutable path, and an unexpired deadline. Real local and hosted signed-slot tests prove one immutable upload while denying direct authenticated inserts, overwrite, listing, cross-owner reads, and expired reads. A hosted Storage compatibility check required the legacy authenticated object-info operation in addition to the current download operation; preserve both through a forward migration and regression assertions. Ticket/integration CI, 382 aggregate database assertions, 105 application tests, database lint, hosted cleanup/advisors, rollback, current deployment restoration, root/API readiness, and worker startup all pass; production remains untouched.
- 2026-07-22: Complete `ENG-020` with ordered private photo metadata for 1–12 independently validated images, deterministic per-profile positions, duplicate-hash rejection, verified immutable object evidence, a bounded seven-day initial deadline, valid lifecycle transitions, server-only writes, and authenticated owner-only reads that fail immediately at expiry. Extend anonymous account transfer coverage so current ownership cascades without renaming immutable object paths. Focused 104-assertion, aggregate 364-assertion, intentional-leak, 105-test application, ticket-CI, integration-CI, hosted rollback-only, advisor, development migration, immutable-image deployment, application rollback, and restoration checks pass with zero retained fixtures; production remains untouched.
- 2026-07-22: Complete `ENG-019` with a private hashed-token transfer record and service-role-only atomic transaction. A 15-minute one-use token moves the current anonymous root draft graph exactly once into a permanent account; same-target retries are idempotent, another target cannot replay it, stale or expired transfers change no owner, and an existing active report remains untouched alongside the incoming draft. Zero-state, 46-assertion focused, 306-assertion aggregate, intentional-leak, 105-test application, ticket-CI, integration-CI, hosted transactional, advisor, exact AMD64 deployment, application rollback, and restoration checks pass with zero retained fixtures; production remains untouched.
- 2026-07-22: Complete `ENG-018` with one consolidated profile-graph authorization boundary. Customer profile creation is draft-only, direct profile deletion is unavailable, reads remain owner-scoped, submitted profile/brand/size evidence is frozen, and consent history remains owner-readable and append-only after submission. Clean-archive, 260-assertion pgTAP, intentional-leak, 105-test application, ticket-CI, integration-CI, hosted transactional, advisor, exact AMD64 deployment, application rollback, and restoration checks pass with zero persisted synthetic rows; production remains untouched.
- 2026-07-22: Complete `ENG-017` with purpose-specific append-only consent events for profile processing, photo analysis, garment extraction, generated likeness previews, account connection, live camera, live microphone, and Gemini visual context. Store granted/revoked decisions with a versioned policy and exact SHA-256 copy evidence; determine current consent by `(captured_at, id)` ordering; grant customer and service roles select/insert only; isolate reads and inserts by verified owner; preserve system-only anonymous-account transfer; and cascade physical profile deletion without exposing update/delete operations. Local, clean-archive, ticket-CI, integration-CI, transactional hosted, advisor, exact AMD64 deployment, rollback, and restoration checks pass with zero persisted synthetic rows; production remains untouched.
- 2026-07-22: Complete `ENG-016` with ordered favorite-brand records and separate garment-type-specific size observations, so values such as Zara jeans L and Zara tops M coexist without overwriting each other. Enforce normalized brand keys, bounded garment types and ordering, exact known/unknown/not-applicable label states, selected-brand lineage, draft-only mutation, narrow customer grants, owner isolation, and indexed foreign keys. A hosted advisor caught missing owner-leading composite-FK indexes before closure; add and verify a corrective migration, then confirm the ticket-specific advisor findings are gone. Transactional hosted proof rejects duplicate garment observations and missing known-size labels and rolls back all fixtures. Exact AMD64 images are restored after a successful application rollback drill; production remains untouched.
- 2026-07-22: Complete `ENG-015` with the approved owner-scoped profile schema, bounded draft fields, required non-draft completion data, one-active-profile enforcement, monotonic revisions, frozen submitted evidence, same-owner lineage, and operation-specific RLS. Close the isolated development branch's missing migration-prefix gap by applying the previously approved private-schema, processing-job, and worker-RPC migrations before the profile migration; transactional hosted proof, security/performance advisors, application rollback compatibility, exact AMD64 image deployment, and final health checks pass. Production remains untouched.
- 2026-07-22: Complete `ENG-012` with strict exported Zod contracts and inferred TypeScript types for US catalog search, product and alternatives inputs, source-aware bag writes, refreshed bag/product projections, and short-lived retailer handoff. Unknown fields, invalid source/availability discriminators, mismatched source IDs, unsafe retailer URLs, malformed timestamps, and out-of-bound inputs fail closed. Deploy exact revision-labeled Linux/AMD64 web and API/worker images to healthy `magic-mirror-dev` deployment `a44e8f0e-48ff-47ac-a97d-c345e382c9dc`; production remains untouched.
- 2026-07-22: Complete `ENG-011` with strict shared Zod contracts and inferred TypeScript types for durable report runs, three report section variants, garment-specific fit guidance, immutable report projections, current product facts, recommendation rationale/outfit grouping, optional generated-preview metadata, collections, and feedback. Unknown fields, unsupported discriminators/states, malformed URIs/timestamps, partial outfit groups, invalid section/color bounds, and malformed product projections fail closed. Deploy exact revision-labeled Linux/AMD64 web and API/worker images to healthy `magic-mirror-dev` deployment `89f90115-0814-45cc-bd03-2c8dfa6b132b`; production remains untouched.
- 2026-07-22: Complete `ENG-010` with strict shared Zod contracts and inferred TypeScript types for private photo upload/results, bounded extraction summaries and fallback state, catalog-aware taste candidates, and Love/Hate/Maybe calibration progress. Unknown fields, unsupported media/status/source values, malformed URIs/timestamps, oversized media, short tokens, and invalid progress bounds fail closed. Deploy exact revision-labeled Linux/AMD64 web and API/worker images to healthy `magic-mirror-dev` deployment `40f5a7ea-4daa-47ea-9ddc-b6422f2d2db3`; production remains untouched.
- 2026-07-22: Complete `ENG-009` with strict shared Zod contracts and inferred TypeScript types for chat-first profile answers, garment-level brand sizing, consent evidence, resume decisions, and anonymous-to-authenticated transfer. Unknown fields, malformed consent evidence, unsafe destinations, and invalid discriminators fail closed. Deploy exact revision-labeled Linux/AMD64 web and API/worker images to healthy `magic-mirror-dev` deployment `673a772c-12ab-4bcf-904d-ea29dbdabb6c`; production remains untouched.
- 2026-07-22: Complete `ENG-007` with versioned, secret-free Supabase Auth configuration and verification for anonymous continuity, Google, and email magic links only. The isolated development project enables those modes and allows only the exact local and `magic-mirror-dev` callbacks; the application password surface and wildcard redirects are absent. Keep the existing immutable dev images because this ticket changed hosted configuration and verification tooling rather than deployable runtime code; root and both health routes remain healthy, CI passes, and production remains untouched.
- 2026-07-21: Complete `ENG-119` with the approved report-led landing screen deployed to `magic-mirror-dev`. Treat the approved responsive screen mockups as the visual source of truth; use their layout, composition, tokens, typography, and interaction direction, and extract production imagery from those mockups rather than generating a new design direction. The live desktop/mobile page loads every image with zero console or failed-network errors, approximately 94% adjusted manual layout similarity, and stable visual CTA targets; real anonymous-draft/auth behavior remains owned by `ENG-163` and its dependencies. Production remains absent and untouched.
- 2026-07-21: Reprioritize execution to visible frontend delivery after the founder rejected continued backend-first work while `magic-mirror-dev` remained visually blank. Split the landing screen into `ENG-119` for the complete approved responsive visual shell and `ENG-163` for real anonymous-draft wiring after its API/client dependencies pass. Execute `ENG-119` now; never mark the later integration complete with fixtures or fake provider success.
- 2026-07-21: Complete `ENG-155` after founder approval of the Supabase branch charge. Keep persistent data-less Supabase development branch `hsivtshdoyazwccpxfxt` isolated from production and deploy immutable `linux/amd64` web plus API/worker DOCR images to `magic-mirror-dev` at `https://magic-mirror-dev-mmv4h.ondigitalocean.app` (deployment `9704047e-a632-4182-8fcf-d4cdc0fa26d4`). Root, health, readiness, runtime-configuration, and worker-start checks pass; an application-only rollback to the prior healthy images and restoration to the current revision pass without a database command. Production remains absent. Keep the email sender and Shopify profile explicitly non-deliverable in development until their owning tickets configure real integrations.
- 2026-07-21: Complete `ENG-154` with one every-push/PR GitHub Actions workflow using immutable Node 24 action SHAs, a frozen Bun install, pinned Oxlint, strict typecheck, an isolated local Supabase reset, the API/worker image build, the complete Vitest and pgTAP suites, schema lint, and the Playwright browser smoke. Suppress local Supabase startup output because it contains generated development credentials; actual success logs match none of seven credential/sentinel probes. Keep only the web test project serial because its existing typecheck-failure fixture temporarily mutates source that a concurrent container build copies. Preserve the real failing run as proof that a failed unit/contract gate exits nonzero and skips downstream gates. Development deployment remains deferred only until `ENG-155`.
- 2026-07-21: Complete `ENG-153` with one pinned 45.7 MB Bun production image containing only the bundled API and worker entrypoints, running as the non-root `bun` user with explicit `bun server.js` and `bun worker.js` commands. Preserve `/health` and add `/healthz` for container orchestration; keep production handler registration empty until feature tickets own real handlers while proving the bundled worker against a test-supplied handler and a real local service-role-only Supabase claim. Required configuration failures exit nonzero and name only the missing variable. Keep development deployment deferred to `ENG-155`.
- 2026-07-21: Complete `ENG-152` with a pinned 23.2 MB Bun-to-NGINX Unprivileged production image that runs as UID 101, serves `/healthz` and SPA fallbacks, and injects only the three browser-safe environment values at container startup through a strict base64-decoded runtime boundary. Keep server secrets out of build arguments, layers, metadata, and static files; restrict the Docker context to 80.38 kB; isolate build-test output directories and give Playwright synthetic public configuration so clean-checkout evidence is deterministic. Keep development deployment deferred to `ENG-155`.
- 2026-07-21: Complete `ENG-046` with one typed Bun worker loop, registered-handler-only polling, bounded database calls, active lease heartbeats, graceful signal handling, safe retry/terminal failures, and payload-free structured logs. Keep `private.processing_jobs` and its elevated atomic claim implementation unexposed; use four public, fixed-search-path, security-invoker RPC bridges callable only by `service_role` so the real Supabase Data API transport can claim and transition work without exposing the private schema or adding a database credential. Keep deployment deferred to `ENG-155`.
- 2026-07-21: Complete `ENG-043` with distinct nominal user-token and server-only Supabase clients, official request-scoped access-token forwarding that preserves RLS, API-only service-role construction, untrusted database boundary types, safe configuration failures, and a browser compilation/dependency boundary; verify the exact commit and integrated result while keeping deployment deferred to `ENG-155`.
- 2026-07-21: Complete `ENG-039` with strict bearer parsing, server-side Supabase `getUser` verification using the publishable key, Zod-validated immutable owner context, explicit anonymous/permanent identity state, shared normalized auth errors, and no request-body or user-metadata ownership path; verify both fixtures and real local anonymous tokens while keeping deployment deferred to `ENG-155`.
- 2026-07-21: Complete `ENG-024` with private/RLS-protected processing-job records, bounded discriminated error and lifecycle checks, durable idempotency and worker indexes, and a fixed-search-path service-role-only atomic claim/reclaim function using `FOR UPDATE SKIP LOCKED`; keep worker/provider execution out of this data ticket.
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
