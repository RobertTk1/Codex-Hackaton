# Build Plan: Magic Mirror

- **Status:** `approved`
- **Based on:** Founder-amended approved PRD v1.1.0, 23 approved user stories, 15 approved BDD scenarios, 48-screen approved UX inventory, approved product voice and copy, founder-approved chat-first v2 pre-report direction, ready-for-review post-report visual mockups, founder provider amendments, and the canonical company profile
- **Scope:** The approved first functional product, sequenced as the must-have Style Intelligence Golden Path followed by should-have live styling, distance controls, and retailer action
- **Updated:** 2026-07-19
- **Owner:** Talisha White
- **Approval authority:** Founder only

## Outcome and Approach

Magic Mirror should first become useful without live video: an adult visitor can begin anonymously, provide structured style evidence, connect an account without losing work, receive a real report, and browse report-matched products across retailers. That is the first coherent release and the critical path.

Live virtual try-on, voice, hand gestures, bagging, and retailer handoff then extend that proven report and recommendation foundation. They are planned as real product behavior, not simulated UI, but they do not delay validation of the report-led core.

The build is organized as full-stack vertical slices. Each slice delivers an observable customer outcome across experience, state, integrations, trust, accessibility, recovery, and validation. Accessibility, sensitive-data isolation, preserved progress, and explicit slow/error states are acceptance conditions inside every affected slice; they are not cleanup phases.

Beyond the founder-constrained TypeScript/Vite/Tailwind/Bun/Supabase stack, the plan intentionally does not prescribe schemas, endpoints, source files, tickets, or estimates. Those decisions belong in the engineering plan after this product sequence is approved and the readiness blockers below have named resolutions.

## Source of Truth

| Source | Status | Authority in this plan | Use |
| --- | --- | --- | --- |
| `company/artifacts/prd/prd.md` | Approved v1.1.0 with founder amendments, 2026-07-19 | Primary product contract | Scope, user outcomes, functional behavior, non-goals, trust rules, release priorities |
| `company/artifacts/prd/user-stories.json` | Approved package; 23 stories | Primary traceability contract | Priorities, acceptance criteria, dependencies, analytics events |
| `company/artifacts/prd/scenarios.feature` | Approved package; 15 scenarios | Primary observable validation contract | End-to-end behavior and recovery paths |
| `company/artifacts/prd/screens.json` | UX and copy approved; visual mockups ready for review; 48 records | Primary screen/state inventory | Required surfaces, actions, states, viewports, and traceability joins |
| `company/artifacts/ui-ux-design/ux-notes.md` and `wireframe-manifest.json` | Founder-approved; 48 screen/state records | Approved structural experience | Information architecture, responsive structure, accessible interaction expectations |
| `company/voice.md` and `company/artifacts/copy/copy-manifest.json` | Founder-approved; 48 records | Approved customer language | Tone, claims, labels, consent/error language, retailer boundary |
| `company/artifacts/screen-mockups/mockup-manifest.json` | Form-based pre-report comps archived as reference; post-report comps ready for review | Reference and downstream visual package | Form-based v1 pre-report is non-implementation reference; post-report Acid Dispatch comps remain proposed |
| `company/artifacts/screen-mockups-v2/conversational-onboarding/` | Founder-approved for pre-report; eight responsive states | Adopted pre-report interaction | Chat-first one-question-per-turn implementation direction with the same validated profile contract |
| `company/build-notes.md` | Founder-directed engineering-plan input | Preferred provider roles and integration constraints | OpenAI, Gemini Live, Decart, Shopify Global Catalog, critical Wardrobe extraction, required spikes |
| `company/company.md` | Canonical company profile | Product framing and boundaries | Audience, journey, positioning, trust, retailer ownership |
| `company/plan.md` | Living roadmap; updated with this plan | Current status and next actions | Roadmap continuity and unresolved decisions |
| `company/brand/` | Founder-approved hackathon identity | Visual system input | Acid Dispatch palette, approved wordmark/lockup/icon, production exports |
| `company/artifacts/market_research/` and audience research | Completed research, not product authority | Supporting evidence only | Trust, representation, market framing, validation risks |

## Conflicts, Resolutions, and Assumptions

### Resolved conflicts

1. **The approved report-led PRD supersedes the older single-photo/single-garment roadmap.** The current first functional build is anonymous profile creation, 8–12 favorite-look photos, taste calibration, account connection, real report generation, and real catalog recommendations. Live styling and retailer action follow as should-have phases.
2. **The product is planned as real behavior.** Earlier frontend-definition language that said to behave as if APIs work described the mockup phase only. This build plan requires real identity, persistence, analysis, catalog discovery, try-on, voice, gesture, and handoff behavior where those phases are included.
3. **Shopify Global Catalog is the cross-retailer source.** Storefront Catalog is reserved for intentionally single-merchant searches. Magic Mirror does not own checkout, payment, shipping, returns, price, or stock.
4. **No automatic 24-hour photo-deletion promise is in scope.** Retention and deletion must be decided before real sensitive photos are stored.
5. **Wardrobe-inspired garment extraction is a committed release-one pipeline step, not a full digital closet.** It sits on the critical path between photo validation and taste calibration, seeds the style profile, preserves successful per-image results, and falls back to direct favorite-look/style-signal analysis if the repository spike fails. The spike determines whether the repository is reliable enough and whether customer review is required.
6. **The founder-constrained stack is TypeScript throughout the frontend/API, with Vite, Tailwind, Bun, and Supabase for database, auth, and private asset storage.** The engineering plan must use this stack and may resolve boundaries and setup, not substitute the platform choices.
7. **Gemini Live replaces OpenAI Realtime for live voice.** OpenAI remains preferred for the text agent, report generation, and still-image generation/editing; Gemini Live owns PH-06 voice and optional multimodal session awareness.
8. **AI-generated wardrobe previews are now part of FEAT-009.** They may appear only when consent, likeness quality, and catalog-image reuse permission pass; otherwise text and linked product recommendations complete the report.
9. **`Gender` replaces `style presentation` as the single profile and consent term.** It remains inclusive and may be self-described. Name, gender, height, optional weight, age, overall fit preference, favorite brands, and brand-plus-garment-type sizes are the required profile contract.
10. **Brand sizing is garment-type evidence, not one brand-wide size.** A customer may record Zara jeans L and Zara tops M independently. The report pipeline derives a bounded, explainable fit profile from those observations plus the customer’s stated `fitted`, `regular`, `relaxed`, or `varies` preference and never claims guaranteed fit.

### Planning boundaries and remaining assumptions

- The first coherent release ends at a persistent report plus report-matched Style Home; live styling and retailer action are subsequent increments within the approved full product definition.
- OpenAI for text/report/image work, Gemini Live for voice/session awareness, Decart Lucy VTON for live try-on, and Shopify Global Catalog for product discovery remain preferred providers only if access, policy fit, quality, latency, reliability, and cost checks pass.
- Magic Mirror serves adults only in the first release. Exact age-gate handling and unsupported-user recovery still require a product decision.
- The one-to-two-minute report window is a product target, not a measured claim, until benchmark evidence exists.
- Product imagery from Shopify Global Catalog will not be reused as an OpenAI image-generation or Decart input unless a permitted image path or merchant authorization is confirmed; generated report previews use the text-and-link fallback until then.

### Remaining source check

- No founder amendment above conflicts with an approved source that remains unoverridden. The gender terminology, v2 adoption, stack, Wardrobe sequencing, Gemini provider, generated previews, and early risk spikes are explicit founder overrides or additions.
- Shopify’s documented Catalog image-use constraints do not currently establish permission for OpenAI image-generation or Decart inputs. BR-029 remains unresolved external-policy evidence, and both features retain non-blocking fallbacks.
- Current Gemini Live guidance accepts streaming video frames but documents a maximum of 1 FPS and short default uncompressed audio-video session limits. BR-018 must determine whether structured session state is sufficient and safer for the demo.
- The existing Style Home screen already contains the direct `Start live styling` entry, so no duplicate screen was added. US-022 and approved copy now make the requirement explicit.
- If BR-026 decides that customers must review extracted garments, the approved v2 screen/copy inventory needs one additional chat review state before implementation; that screen is not invented before the spike decision.

## Build Readiness

Allowed statuses are `ready`, `user-action-required`, `decision-required`, `engineering-resolution`, and `deferred`.

| ID | Category | Readiness item | Needed by | Status | Responsible party | Evidence or exit condition |
| --- | --- | --- | --- | --- | --- | --- |
| BR-001 | Product definition | Approved founder-amended PRD, stories, scenarios, and screen inventory | Plan approval | ready | Founder | Approved v1.1.0 PRD; 23 stories; 15 scenarios; 48 screen/state records plus adopted eight-state v2 pre-report package |
| BR-002 | UX and content | Structural UX, product voice, and all screen copy | PH-01 | ready | Founder / design | UX and copy manifests are founder-approved |
| BR-003 | Visual direction | Use chat-first v2 for pre-report onboarding and retain form-based v1 pre-report comps as archived reference | PH-01 and PH-02 interface completion | ready | Founder | V2 manifests marked approved for pre-report; v1 manifest marks pre-report comps archived-reference |
| BR-004 | Delivery constraint | Meet the OpenAI Build Week deadline and set an earlier internal demo cutoff and scope-freeze rule | Before engineering sequencing | user-action-required | Founder | Official deadline is Tuesday, July 21, 2026 at 5:00 PM Pacific / 8:00 PM Eastern; internal freeze times are confirmed in `company/artifacts/engineering-plan/founder-readiness-inputs.md` and recorded in `company/plan.md` |
| BR-005 | Founder-constrained stack and Supabase access | Use TypeScript with Vite, Tailwind, and Bun for the frontend, TypeScript for the API layer, and Supabase for database, auth, and private asset storage; provision the actual Supabase project | PH-01 | user-action-required | Founder / engineering | Stack constraint is recorded as resolved; remaining evidence is project access, ownership, region, and secure secret location without secret values |
| BR-006 | Authentication | Configure Google identity and production redirect origins | PH-01 | user-action-required | Founder / engineering | OAuth application and approved origins exist; test and production login can complete |
| BR-007 | Email access and notification | Configure magic-link delivery and a sender path for report-ready notifications | PH-01 and PH-03 | user-action-required | Founder / engineering | Verified sender/domain and delivery path work in target environments |
| BR-008 | Privacy | Decide retention/deletion separately for original photos, derived crops, extracted garments, AI-generated customer-likeness previews, reports, transcripts, and live sessions | Before PH-02 stores real photos | decision-required | Founder / policy / engineering | Written lifecycle by asset class, customer deletion behavior, backup treatment, provider handling, and support procedure |
| BR-009 | Consent and policy | Approve purpose-specific consent for gender, photos, garment extraction, AI-generated likeness previews, account connection, camera, and microphone | PH-01 through PH-03 | decision-required | Founder / policy | Approved customer-facing language and versioned consent requirements use `gender` consistently and distinguish each image purpose |
| BR-010 | Test data | Assemble consented, representation-diverse favorite-look photos, extracted-garment expectations, catalog queries/products, likeness-preview cases, and expected report fixtures | PH-02 through PH-05 | user-action-required | Founder / product | Documented dataset with usage permission and no production customer data |
| BR-011 | OpenAI access | Provide project access, billing, organization requirements, and secure server-side credential handling for the text agent, report, extraction support, and image generation | PH-02 and PH-03 | user-action-required | Founder / engineering | Non-production and production access verified; permanent keys remain server-side |
| BR-012 | Style intelligence quality | Define and validate the structured analysis/report contract, safety behavior, confidence language, and correction loop | PH-03 | engineering-resolution | Engineering / product | Representative fixtures produce schema-valid, useful, non-diagnostic reports with recorded failure cases |
| BR-013 | Report review | Decide whether a styling expert, legal reviewer, or both must approve the color and Kibbe-informed methodology before release | PH-03 | decision-required | Founder | Review requirement and named reviewer recorded, or explicit risk acceptance recorded |
| BR-014 | Shopify access | Host the required UCP agent profile and verify Global Catalog access/rate path for report products and Style Home | PH-03 and PH-04 | user-action-required | Founder / engineering | Global text, image, and multimodal requests succeed under expected rate and geography constraints |
| BR-015 | Shopify usage constraints | Resolve no-cache, live-image rendering, stable-reference storage, freshness, retailer provenance, and external-image-use boundaries | PH-03 through PH-05 | engineering-resolution | Engineering / product | Catalog results can be shown, refreshed, linked, and saved by stable reference without prohibited caching or image reuse |
| BR-016 | Decart access | Provision Decart account, billing/access, and short-lived client-token capability | PH-05 | user-action-required | Founder / engineering | Target model can be reached from the intended environment without exposing a permanent key |
| BR-017 | Decart feasibility | Benchmark supported garments, representation quality, connection time, first-frame time, switching latency, and recovery early | Parallel with PH-01 and PH-02; required by PH-05 | engineering-resolution | Engineering / product | Early spike defines supported categories, demo quality bar, latency budget, and fallback before late-phase investment |
| BR-018 | Gemini + Decart + gesture realtime feasibility | Prove one target demo device can sustain Decart video, Gemini Live consuming sampled video/screen context or structured session state, and gesture recognition simultaneously | Parallel with PH-01 and PH-02; required by PH-06 | engineering-resolution | Engineering | Compare raw video-frame context with structured selected-item/visible-result state; complete voice and gesture changes plus independent reconnects while recording CPU, bandwidth, echo, session behavior, and action latency |
| BR-019 | Gesture scope | Choose supported gestures, confidence threshold, confirmation rules, and target device/browser support | PH-06 | decision-required | Founder / engineering | Small supported vocabulary and fallback behavior approved after a measured spike |
| BR-020 | Retail attribution | Decide affiliate disclosure, outbound attribution, and retailer-link tracking boundaries | PH-07 | decision-required | Founder / business / policy | Approved disclosure and event rules; no claim of retailer partnership without evidence |
| BR-021 | Analytics and observability | Define allowed event payloads, redaction, operational tracing, and provider latency/error evidence | PH-01 onward | engineering-resolution | Engineering / product | Event catalog excludes raw images, sensitive profile values, transcripts, and secrets; critical paths have usable diagnostics |
| BR-022 | Deployment | Use DigitalOcean and provide the exact product, target domain, hosting ownership, environment separation, and production access | PH-01 foundation and demo readiness | user-action-required | Founder / engineering | DigitalOcean is selected; test and production destinations exist with documented account/team access and secure-secret ownership |
| BR-023 | Accessibility and support matrix | Confirm target browsers/devices and the evidence required for WCAG 2.2 AA | PH-01 onward | engineering-resolution | Engineering / QA / product | Support matrix and keyboard, screen-reader, reduced-motion, color-label, permission, voice, and gesture test coverage are defined |
| BR-024 | Dynamic taste calibration | Decide the minimum reaction count and how extracted garments/style signals source and balance candidates dynamically | PH-02 | decision-required | Founder / product | Required count, sourcing/ranking rules, category and representation balance, slow/failure behavior, retry, and safe fallback set are approved |
| BR-025 | Photo qualification | Define accepted file types, size limits, full-body/pose guidance, safety checks, and recoverable rejection reasons | PH-02 | engineering-resolution | Engineering / product | Validation contract supports independent rejection/replacement without losing valid photos |
| BR-026 | Critical Wardrobe extraction | Validate `tandpfun/wardrobe` reliability, per-image and total latency across 8–12 photos, partial-failure behavior, deduplication usefulness, and whether customer review is required | Between FEAT-005 and FEAT-006 | engineering-resolution | Product / engineering | Spike proves the core extraction path or activates the approved fallback: preserve successful results and use direct favorite-look/style-signal analysis so taste and report continue |
| BR-027 | Google AI access | Provide project access, billing, and secure server-side credential handling for Gemini Live | Parallel risk lane and PH-06 | user-action-required | Founder / engineering | Non-production and production access verified; permanent credentials remain server-side and short-lived client access succeeds |
| BR-028 | Generated wardrobe preview quality | Define and validate likeness safety, garment recognizability, representation quality, latency, disclosure, and failure fallback for OpenAI-generated report previews | PH-03 | engineering-resolution | Product / engineering / policy | Approved quality bar passes consented representative cases; failures produce complete text-and-linked-product recommendations without a generated image |
| BR-029 | Catalog image reuse permission | Determine whether Shopify Global Catalog product images may be inputs to OpenAI image generation and Decart live try-on | PH-03 and PH-05 | engineering-resolution | Product / engineering / policy | Written permitted path or merchant authorization covers each use; otherwise previews use text/link fallback and Decart uses user-owned/approved garment cutouts |

### Build gate

- **Overall:** Not ready
- **Blocking items:** BR-004, BR-005, BR-006, BR-007, BR-008, BR-009, BR-010, BR-011, BR-014, BR-016, BR-027
- **Items engineering must resolve:** BR-012, BR-015, BR-017, BR-018, BR-021, BR-023, BR-025, BR-026, BR-028, BR-029

The product sequence is not ready for implementation authorization.

The product sequence is founder-approved, but the full build is not ready to start as an integrated implementation until the critical customer-controlled and policy items have named evidence.

### Critical blockers before implementation authorization

- BR-004: approve the internal freeze boundaries before the confirmed Tuesday, July 21 at 5:00 PM Pacific deadline.
- BR-005 through BR-009: establish environment ownership, authentication, email delivery, retention, and consent policy before collecting real sensitive data.
- BR-010, BR-011, and BR-027: provide permitted evaluation data plus OpenAI and Google AI project access before claiming real report or live voice behavior.
- BR-014 and BR-016: establish Shopify Global Catalog and Decart access before their phases are treated as deliverable.

### Engineering-owned resolutions that must be planned, not guessed

- BR-012, BR-015, BR-017, BR-018, BR-021, BR-023, BR-025, BR-026, BR-028, and BR-029 require explicit engineering-plan work, validation evidence, and visible recovery behavior.
- BR-013, BR-019, BR-020, and BR-024 require founder decisions informed by engineering or product evidence.
- BR-017 and BR-018 run as early risk spikes in parallel with PH-01/PH-02 rather than waiting for PH-05/PH-06.

## Build Phases

### PH-01 — Trustworthy Entry and Continuity

**Usable customer outcome:** A new visitor can understand the offer and begin under an isolated anonymous identity, while a returning customer can sign in and resume the correct state without exposing account information or losing valid work.

**Why now:** Identity ownership, consent, accessibility, and recovery are prerequisites for every later sensitive-data and provider flow.  
**Depends on:** Build-plan approval; resolved BR-003; BR-004 through BR-009; initial BR-021 and BR-023 definitions.  
**Unlocks:** PH-02.  
**Parallel lanes:** The landing experience, returning-account entry, and shared trust/accessibility/recovery contract can be implemented in parallel once one state-ownership contract is agreed. BR-017 and BR-018 start concurrently as early demo-risk spikes and do not wait for PH-05/PH-06.  
**Integration checkpoint:** SC-002 and the entry portion of SC-001 pass with anonymous state, login, correct routing, accessible controls, and normalized recovery.

#### FEAT-001 — Report-Led Landing and Start

**Priority:** Must-have  
**Primary source:** US-001; SC-001  
**Customer outcome:** A prospective customer understands what the report delivers, what inputs it needs, the target turnaround, the sensitive-data purpose, and the retailer boundary before starting.

**Experience and system behavior**

- Present the approved editorial report story, input preview, trust language, and a primary `Get my style report` action.
- Preserve a separate login path for returning customers.
- Begin an isolated anonymous customer state and route an already-authenticated customer to the latest valid destination.
- Record only approved, non-sensitive acquisition and start events.

**Integration points:** Anonymous identity; routing/state continuity; consent version; analytics.  
**Dependencies:** BR-002, BR-003, BR-005, BR-009, FEAT-003.

**Acceptance criteria**

1. The landing experience explains the report outcome, required inputs, one-to-two-minute target, and retailer-owned commerce boundary.
2. The primary action creates or resumes an isolated anonymous journey and opens the first incomplete step.
3. A distinct login action remains available and an authenticated customer does not restart completed work.
4. No attractiveness, guaranteed-fit, scientific-certainty, fabricated proof, or automatic deletion claim appears.
5. Desktop and mobile layouts preserve keyboard access, readable focus, and meaningful heading order.

**End-to-end validation:** Given a signed-out adult visitor on the landing page, when they start the report, then an anonymous journey is created and the first incomplete step opens; when a returning customer selects login, the unified account flow opens instead.

#### FEAT-002 — Unified Account Access and Resume Routing

**Priority:** Must-have  
**Primary source:** US-002; SC-002  
**Customer outcome:** A returning customer uses Google or an email magic link and returns to their latest valid onboarding, processing, report, or Style Home state on any supported device.

**Experience and system behavior**

- Use one signup/login entry with Google and email magic link only.
- Restore account-backed state across devices and route by latest valid status.
- Do not reveal whether an unrelated email account exists.
- Make expired links, provider failures, and expired local sessions recoverable.

**Integration points:** Google identity; magic-link delivery; account state; cross-device routing.  
**Dependencies:** BR-005 through BR-007, FEAT-003.

**Acceptance criteria**

1. Google and email magic link are the only permanent account methods.
2. A valid account resumes the correct incomplete, processing, report, or Style Home state without repeating completed work.
3. Authentication failures use non-enumerating language and preserve any locally owned anonymous progress.
4. Expired or invalid magic links offer a safe resend or method switch.
5. Successful access works across supported devices without exposing another customer’s data.

**End-to-end validation:** Given an account with a completed report, when the customer authenticates on another supported device, then the report or Style Home opens and no completed onboarding step repeats.

#### FEAT-003 — Sensitive-State, Accessibility, and Recovery Baseline

**Priority:** Must-have  
**Primary source:** US-019, US-020, US-021; SC-003, SC-004, SC-005, SC-007, SC-008, SC-010, SC-013, SC-015  
**Customer outcome:** The customer can understand consent, use non-gesture alternatives, recover from failure, and trust that only their current identity can access their sensitive work.

**Experience and system behavior**

- Apply purpose-specific consent to photos, account connection, camera, and microphone at the moment each capability is activated.
- Keep anonymous and account-backed assets owner-isolated through account connection.
- Preserve valid work after validation, provider, network, permission, and analysis failures.
- Require equivalent direct controls for swipe, voice, hand gestures, drag, and color-dependent content.
- Normalize loading, slow, failed, denied, unavailable, and recovered states without silent failures.
- Keep raw photos, sensitive profile values, transcripts, and secrets out of logs and analytics.

**Integration points:** Identity/authorization; private assets; consent records; error outcomes; accessibility behavior; analytics/observability.  
**Dependencies:** BR-005, BR-008, BR-009, BR-021, BR-023.

**Acceptance criteria**

1. Every sensitive asset is accessible only to its owning anonymous or permanent identity before and after account connection.
2. Each requested permission explains its purpose, activation point, and available alternative before the browser prompt appears.
3. A failure preserves every valid completed answer, upload, reaction, selection, and report state that can safely be retained.
4. No critical action depends only on color, hover, drag, swipe, gesture, or voice.
5. Loading, slow, failure, denial, and recovery changes are announced in understandable language and have an explicit next action.
6. Operational evidence contains no raw images, sensitive answers, full transcripts, authentication clues, or secrets.
7. The core journey meets the agreed WCAG 2.2 AA and device/browser support evidence.

**End-to-end validation:** Given one anonymous customer and one unrelated account, when failures and an account connection occur across the journey, then the first customer’s valid work remains recoverable and the unrelated account cannot access any of it.

### PH-02 — Build the Customer’s Style Evidence

**Usable customer outcome:** A customer can progressively provide the structured facts, favorite-look photos, and Love/Hate/Maybe taste signals required for a useful report without losing valid inputs.

**Why now:** The report cannot be real or useful until the minimum approved evidence is complete, validated, and owned by one anonymous identity.  
**Depends on:** PH-01; BR-008 through BR-011; BR-024 through BR-026.  
**Unlocks:** PH-03.  
**Parallel lanes:** Chat profile/sizing and photo qualification can advance in parallel against the same anonymous ownership contract. Dynamic taste-candidate work begins against fixtures while BR-026 proves extraction. BR-017 and BR-018 continue in the parallel demo-risk lane.  
**Integration checkpoint:** SC-003, SC-004, and SC-005 pass; the pre-account portion of SC-001 holds all required validated inputs, preserved extraction results or fallback style signals, and dynamic taste reactions under one anonymous identity.

#### FEAT-004 — Personal Profile and Brand-Size Context

**Priority:** Must-have  
**Primary source:** Founder amendments 2026-07-19; US-003, US-004; SC-001, SC-003  
**Customer outcome:** In the adopted chat-first conversation, the customer provides name, adult confirmation, gender, age, height, optional weight, overall fit preference, favorite brands, and the sizes they actually wear by brand and garment type.

**Experience and system behavior**

- Collect name, adult confirmation, gender, age, height, optional weight, and overall fit preference one question at a time; use `gender` consistently, allow inclusive options or self-description, and disclose its styling/shopping purpose.
- Ask explicitly: `How do you like your clothes to fit overall—fitted, regular, relaxed, or does it depend on the garment?`
- Capture favorite brands and garment-type-specific known sizes such as Zara jeans L and Zara tops M; allow numeric/alpha labels plus unknown or not-applicable values.
- Derive a bounded fit profile by garment type from stated fit preference and observed brand-size evidence, with confidence/evidence labels and no universal-size or guaranteed-fit claim.
- Validate field-level input without erasing other valid answers.
- Persist structured progress to the anonymous identity after each completed turn or section.
- Use chat-first v2 as the implementation direction while writing the same validated FEAT-004 data and completion contract formerly represented by form-based v1.

**Integration points:** Anonymous customer state; structured validation; garment-type and size taxonomy; pure fit-profile derivation; progress routing.
**Dependencies:** FEAT-003, BR-008, BR-009, BR-024, BR-025.

**Acceptance criteria**

1. The chat collects name, adult confirmation, gender, age, height, optional weight, overall fit preference, favorite brands, and garment-type-specific brand sizes; required and optional values match the amended PRD.
2. Adult confirmation blocks unsupported minor onboarding without retaining disallowed photo data.
3. Gender uses that exact term across conversation, structured state, copy, validation, and consent; inclusive options or self-description are accepted and its styling/shopping purpose is explained.
4. Brand sizes are recorded independently by brand and garment type, permit unknown/not-applicable values, and never invent a universal brand size.
5. Invalid input identifies the affected conversational answer and preserves every other valid answer.
6. Refresh, return, or supported-device continuation restores the latest owned valid state.
7. The derived fit profile is deterministic for the same inputs, preserves conflicting observations as uncertainty, and never claims guaranteed fit.
8. The adopted v2 presentation writes the same validated profile contract and completion state as the archived v1 reference plus this founder-approved fit amendment.

**End-to-end validation:** Given an anonymous adult customer who prefers a relaxed fit, when they enter valid personal details, Zara jeans L, Zara tops M, and one unknown garment-type size, then the distinct observations and fit preference resume correctly and produce the same bounded fit profile; when one field is invalid, only that field requires correction.

#### FEAT-005 — Favorite-Look Photo Collection

**Priority:** Must-have  
**Primary source:** Founder amendment 2026-07-19; US-005; SC-001, SC-004, SC-013  
**Customer outcome:** The customer can safely provide 8–12 qualifying full-body photos, preserve successful per-image garment extraction, and continue through a disclosed fallback when some extraction work fails.

**Experience and system behavior**

- Explain analysis purpose and obtain photo consent before file selection or capture.
- Validate each photo for approved file, size, safety, and quality rules without uploading rejected bytes as valid evidence.
- Show per-photo progress and rejection reasons; preserve accepted photos when another fails.
- Keep originals and derived assets private and owned by the anonymous identity.
- Permit add, replace, remove, and reorder until the minimum valid set exists.
- Run Wardrobe-inspired garment extraction after photo validation, preserve successful per-image results, and determine from BR-026 whether a customer correction/review turn is required.
- If extraction is partially or fully unusable, preserve the valid photos and successful results and seed the next step from direct favorite-look/style-signal analysis.

**Integration points:** Private upload/storage; image validation; Wardrobe-inspired extraction; consent; anonymous ownership; progress state.  
**Dependencies:** FEAT-003, FEAT-004, BR-008 through BR-011, BR-025, BR-026.

**Acceptance criteria**

1. The customer sees why 8–12 full-body favorite-look photos are needed before granting access or choosing files.
2. Continue remains unavailable until at least eight and no more than twelve valid photos are present.
3. Each photo validates independently and a rejected photo names a recoverable reason without removing accepted photos.
4. The customer can replace, remove, and reorder photos without repeating profile work.
5. Raw and derived photo access remains isolated to the owning identity and follows the approved retention policy.
6. Interrupted uploads resume or clearly identify only the items that must be retried.
7. Extraction preserves successful per-image garment results, handles partial failure without discarding valid photos, and activates the approved style-signal fallback if the repository path cannot meet the quality or latency bar.

**End-to-end validation:** Given seven accepted photos, one invalid image, and one later extraction failure, when the customer replaces only the invalid image, then eight accepted photos remain, successful garment results are preserved, the failed extraction uses the approved fallback, and taste calibration can begin without re-uploading the first seven.

#### FEAT-006 — Love, Hate, and Maybe Taste Calibration

**Priority:** Must-have  
**Primary source:** Founder amendment 2026-07-19; US-006; SC-001, SC-005  
**Customer outcome:** The customer quickly refines a profile seeded by extracted garments and style signals using dynamically sourced Love, Hate, and Maybe candidates with visible, keyboard, and undo controls.

**Experience and system behavior**

- Source and balance candidates dynamically from extracted garments and broader style signals, with simple progress and one decision at a time.
- Map right to Love, left to Hate, and down to Maybe; provide equivalent buttons and keyboard actions.
- Persist each reaction and allow undo of the latest choice.
- Retry slow or failed dynamic candidate sourcing without discarding prior reactions; offer the approved balanced fallback set when needed.
- Finish only when the founder-approved minimum reaction count and coverage are met.

**Integration points:** Extracted garment/style signals; dynamic candidate source; preference capture; anonymous state; accessibility; recovery.  
**Dependencies:** FEAT-003, FEAT-004, FEAT-005, BR-010, BR-024, BR-026.

**Acceptance criteria**

1. Right/Love, left/Hate, and down/Maybe mappings remain consistent and are explained once.
2. Visible buttons and keyboard controls provide every swipe action.
3. Each valid reaction is saved to the owning anonymous journey and progress updates accurately.
4. Undo restores the previous card and reaction state.
5. Candidate sourcing responds to the customer’s extracted garments and style signals while meeting approved category and representation balance.
6. Slow or failed candidate generation offers retry or the approved balanced fallback while preserving completed reactions.
7. Completion uses the approved minimum count and dynamic balance criteria.

**End-to-end validation:** Given extracted garment/style signals and saved reactions, when dynamic candidate sourcing fails mid-flow, then prior reactions remain and a balanced fallback set loads; when the customer undoes the latest choice, that card returns with no duplicate progress.

### PH-03 — Connect the Account and Deliver the Report

**Usable customer outcome:** A customer connects their anonymous work to Google or an email magic-link account, receives a real report with meaningful processing and recovery, understands or corrects its findings, and sees safe generated wardrobe previews when all gates pass.

**Why now:** This is the first moment Magic Mirror delivers its core promised value and converts anonymous evidence into a persistent customer asset.  
**Depends on:** PH-02; BR-007 through BR-015; BR-028 and BR-029; report portions of BR-021 and BR-023.  
**Unlocks:** PH-04.  
**Parallel lanes:** Account-merge behavior, report-generation quality, processing/notification states, report rendering, Global Catalog product matching, and generated-preview evaluation can advance in parallel against permitted fixtures and one structured report contract.  
**Integration checkpoint:** SC-001, SC-006, SC-007, SC-008, SC-009, and SC-013 pass with a contract-valid report owned by the connected account; eligible recommendations include approved generated previews linked to current products, while ineligible or failed cases remain complete through text and links.

#### FEAT-007 — Anonymous-to-Permanent Account Connection

**Priority:** Must-have  
**Primary source:** US-007; SC-001, SC-006, SC-013  
**Customer outcome:** The customer signs up or logs in with Google or email magic link after providing their evidence, and all anonymous progress becomes safely available under the correct account.

**Experience and system behavior**

- Use the same Google/magic-link step for new and existing customers.
- Transfer or merge owned anonymous profile, photos, reactions, and progress as one recoverable operation.
- Route an existing account to its correct combined state without duplicating or overwriting valid work.
- Preserve anonymous progress when authentication or linking fails.

**Integration points:** Anonymous identity; permanent identity; ownership transfer; Google; magic link; audit evidence.  
**Dependencies:** FEAT-002 through FEAT-006, BR-005 through BR-009.

**Acceptance criteria**

1. Only Google and email magic link are offered, and the customer does not choose separate signup or login modes.
2. A successful new-account connection transfers all owned valid anonymous inputs exactly once.
3. An existing account is linked or merged without duplicating, exposing, or silently overwriting progress.
4. A failed or expired authentication attempt leaves anonymous work intact and offers a safe retry or method switch.
5. After connection, only the permanent account can access the transferred sensitive assets.
6. Refresh or cross-device return routes to the correct connected state.

**End-to-end validation:** Given completed anonymous inputs and an email that belongs to an existing account, when a valid magic link completes, then the anonymous work is merged once, remains isolated to that account, and the report process can begin.

#### FEAT-008 — Real Analysis Lifecycle and Recovery

**Priority:** Must-have  
**Primary source:** US-008; SC-001, SC-007, SC-008  
**Customer outcome:** The customer sees honest progress while real style analysis runs, receives the report within the target when possible, and can leave or recover without losing valid inputs.

**Experience and system behavior**

- Start analysis only from a complete, connected, validated input set.
- Produce validated structured output from profile, favorite looks, and taste reactions.
- Show meaningful processing stages rather than fake precision.
- At 90 seconds, continue with meaningful status; at 120 seconds, show a slow state with notification and safe-exit choices while work continues.
- Normalize analysis timeout, provider, validation, and delivery failures; retain valid inputs and permit retry or support.
- Notify the customer when a safely exited report becomes ready.

**Integration points:** Style intelligence provider; background status; structured output; notification; account state; observability.  
**Dependencies:** FEAT-007, BR-007, BR-010 through BR-013, BR-021.

**Acceptance criteria**

1. Analysis never starts from an incomplete or unowned input set.
2. Processing stages reflect real lifecycle changes and are accessible to assistive technology.
3. A valid report that finishes within 120 seconds opens automatically and remains account-backed.
4. At 120 seconds, the customer can request notification or leave safely while processing continues.
5. A provider or output-validation failure preserves valid inputs and offers a bounded retry or support path.
6. Duplicate starts or refreshes do not create conflicting reports for the same submitted input version.
7. Timing and error evidence contain identifiers and durations without raw sensitive content.

**End-to-end validation:** Given a complete connected profile, when analysis exceeds 120 seconds, then the slow state offers notification and safe exit; when processing later succeeds, the report is saved and the customer can re-enter it without resubmitting inputs.

#### FEAT-009 — Explainable, Correctable Style Report with Wardrobe Previews

**Priority:** Must-have  
**Primary source:** Founder amendment 2026-07-19; US-009, US-010, US-011, US-012; SC-001, SC-009  
**Customer outcome:** The customer understands their style identity, color guidance, Kibbe-informed body-style interpretation, and practical recommendations, can preview approved real products on their likeness when safe, and can disagree or request correction.

**Experience and system behavior**

- Present strengths and priorities before opportunities or restrictions.
- Label palette colors and explain neutrals, accents, combinations, and practical use.
- Frame Kibbe-informed findings as interpretive, confidence-aware styling guidance rather than fact or diagnosis.
- Explain silhouettes, proportions, layers, fabrics, garments, and outfit ideas using evidence from the customer’s inputs.
- Distinguish customer-provided facts from model-derived suggestions.
- Capture feedback and support correction or recalibration without discarding the original report version.
- Match report recommendations to current Shopify Global Catalog products and link every real product to its current live product page.
- When consent, catalog-image reuse permission, and the likeness/garment quality bar all pass, use OpenAI image generation to create clearly disclosed wardrobe preview images of the customer with those products.
- If permission, quality, latency, or generation fails, omit the generated image and deliver the complete text recommendation and current product link without delaying the report.

**Integration points:** Structured report; accessible color content; evidence/rationale; report versioning; feedback/recalibration; Shopify Global Catalog current products; OpenAI image generation; customer-likeness derived assets.  
**Dependencies:** FEAT-008, FEAT-003, BR-008 through BR-015, BR-028, BR-029.

**Acceptance criteria**

1. The report contains all approved identity, color, body-style, and recommendation sections.
2. Every color swatch has a usable text label and practical combination guidance.
3. Kibbe-informed content states its interpretive status, rationale, confidence, and correction option without medical, diagnostic, attractiveness, or deterministic claims.
4. Recommendations connect to explicit profile, photo, or taste signals and explain what the customer can try next.
5. The customer can submit a correction or request recalibration while retaining the prior valid report.
6. Report content remains readable, navigable, and persistent across desktop/mobile and return visits.
7. Eligible recommendations show clearly disclosed, quality-approved generated wardrobe previews linked to refreshed real product pages; any permission, safety, quality, latency, or provider failure produces a complete text-and-link fallback without blocking report delivery.

**End-to-end validation:** Given a completed report, an eligible current product, and approved consent/image-use conditions, when the customer opens recommendations, then a quality-approved disclosed preview and current product link appear; if generation fails, the text-and-link recommendation remains complete, and a later inference correction preserves the original report while offering recalibration.

### PH-04 — Turn the Report into Cross-Retailer Recommendations

**Usable customer outcome:** A customer can return to a personal Style Home, see current report-matched products across Shopify merchants, understand why they fit the report, and refine or recover unavailable results.

**Why now:** Current, explainable recommendations turn the report into repeatable utility and complete the first coherent release before riskier realtime work.  
**Depends on:** PH-03; BR-014 and BR-015; catalog-related BR-010 and BR-021.  
**Unlocks:** PH-05 and PH-07.  
**Parallel lanes:** Catalog discovery/normalization, recommendation ranking, and Style Home presentation can advance against recorded fixtures while live access is verified.  
**Integration checkpoint:** SC-002 and SC-014 pass using refreshed cross-retailer results, stable saved references, explainable matches, and unavailable-item alternatives.

#### FEAT-010 — Persistent Style Home and Global Catalog Recommendations

**Priority:** Must-have  
**Primary source:** US-013, US-022; SC-002, SC-014  
**Customer outcome:** The customer has a persistent home for their report and current product recommendations matched to their style, constraints, and refinement requests.

**Experience and system behavior**

- Translate report evidence and customer intent into text, image, or multimodal Shopify Global Catalog searches.
- Rank products with an explainable report-based rationale while preserving merchant provenance.
- Let the customer refine by approved categories such as color, brand, price, occasion, and relevant size context.
- Save stable product/variant/UPID references and customer actions, then refresh current product, seller, availability, price, and checkout details before display or handoff.
- Never cache Catalog result payloads or product images contrary to usage rules.
- Recover unavailable products with alternatives and preserve the report and saved customer state.

**Integration points:** Shopify Global Catalog; report evidence; recommendation ranking; stable product references; account Style Home; current offers.  
**Dependencies:** FEAT-009, FEAT-002, BR-014, BR-015, BR-010, BR-021.

**Acceptance criteria**

1. Style Home restores the customer’s current report, suggested outfits, and recommendations without repeating onboarding and exposes a direct `Start live styling` entry beside report and outfit actions.
2. Each recommendation identifies the retailer and explains a specific connection to the report or current request.
3. Text, image, or multimodal discovery can be refined by supported customer constraints without exposing sensitive inputs unnecessarily.
4. Current product details are refreshed before display or action, while saved state retains only permitted stable references and customer choices.
5. Results and product images follow Shopify’s no-cache and related-listing requirements.
6. An unavailable product offers current alternatives without erasing the report, filters, or other selections.
7. Returning customers route to incomplete work, processing, the report, or Style Home according to current account state.

**End-to-end validation:** Given a completed report, when the customer requests an occasion-specific item and refines color and price, then current cross-retailer results show explainable matches; if one becomes unavailable, alternatives appear and the saved report remains intact.

### PH-05 — Live Virtual Try-On with Direct Control

**Usable customer outcome:** A customer can choose a recommended item, deliberately grant camera access, see a live visualization with explicit connection/change/slow/failure states, and retain a useful non-video path if live styling is unavailable.

**Why now:** Live visualization should extend a proven recommendation set and non-video fallback, not determine whether the report-led product works.  
**Depends on:** PH-04; early BR-017 evidence; BR-016, BR-023, and BR-029; a permitted garment-reference path.  
**Unlocks:** PH-06.  
**Parallel lanes:** BR-017 begins alongside PH-01/PH-02. Live-session state/recovery, garment-reference preparation, and direct-control UI can advance in parallel after that early spike defines supported categories.  
**Integration checkpoint:** SC-010 and the direct-control portions of SC-011/SC-015 pass on the target demo device with measured latency and a report/recommendation fallback.

#### FEAT-011 — Recoverable Live Styling Session

**Priority:** Should-have  
**Primary source:** US-014; SC-010, SC-011, SC-015  
**Customer outcome:** The customer can start a live visualization from a recommendation, change items with direct controls, and recover or return to recommendations when camera or provider behavior fails.

**Experience and system behavior**

- Request camera permission only after the customer starts live styling and explain the non-video alternative first.
- Create a short-lived live session without exposing permanent provider credentials.
- Show connecting, ready, changing, slow, failed, denied, disconnected, and ended states.
- Use one supported garment reference at a time unless measured evidence approves another behavior.
- Keep direct item selection, next, previous, add-to-bag, and end controls available independently of voice or gestures.
- State that the video is a visualization and does not guarantee fit, size, fabric behavior, or appearance.

**Integration points:** Camera; Decart realtime; permitted garment reference; recommendation set; shared action state; observability.  
**Dependencies:** FEAT-010, FEAT-003, BR-016, BR-017, BR-023.

**Acceptance criteria**

1. Camera permission is requested only after an explicit start action and denial preserves access to the report and recommendations.
2. A successful session reaches a ready state with a selected permitted garment reference and direct controls.
3. Item changes expose real changing/slow/failure states and never silently freeze.
4. A recoverable failure offers retry, another item, or return to recommendations without losing saved selections.
5. Permanent provider credentials never reach the client and expired short-lived access can be renewed or recovered safely.
6. The experience never claims guaranteed fit or exact physical appearance.
7. Measured connection, first-frame, switch, and recovery behavior meets the approved demo quality bar for supported categories.

**End-to-end validation:** Given a customer with recommendations, when they start live styling and deny camera access, then they return safely to recommendations; when they later allow access, a supported item reaches ready state and can be changed through direct controls.

### PH-06 — Voice and Hand Controls at a Distance

**Usable customer outcome:** A customer standing away from the device can refine and control live styling by voice or a small supported gesture vocabulary, with visible interpretation, confirmation for consequential actions, and direct-control equivalents.

**Why now:** Voice and gestures are safe and testable only after direct controls and the live-session action model are stable.  
**Depends on:** PH-05; early BR-018 evidence; BR-019, BR-023, and BR-027.  
**Unlocks:** The complete approved distance-controlled styling experience.  
**Parallel lanes:** Voice and gesture capabilities can be developed in parallel after direct controls define one shared typed action and confirmation contract.  
**Integration checkpoint:** SC-011 and SC-015 pass with independent permission/reconnect behavior, visible interpretation, confirmation, undo where allowed, and direct fallbacks.

#### FEAT-012 — Gemini Live Voice and Session-Aware Refinement

**Priority:** Should-have  
**Primary source:** Founder amendment 2026-07-19; US-015; SC-011  
**Customer outcome:** The customer can ask for a different item or control the session by voice and see what Magic Mirror heard, interpreted, confirmed, and acted on.

**Experience and system behavior**

- Request microphone permission separately and only after the customer selects voice.
- Represent listening, interpreting, confirming, acting, failure, and unavailable states.
- Give Gemini Live enough disclosed context to understand the selected item and visible results, using sampled video/screen frames only when they materially outperform structured session state.
- Convert supported requests into the same product-search, selection, navigation, save, retailer, and session actions used by direct controls.
- Confirm consequential actions before add-to-bag, retailer exit, or session end.
- Keep direct controls active when voice is denied, unclear, disconnected, or slow.

**Integration points:** Google Gemini Live; microphone; optional sampled video/screen context; structured session state; catalog refinement; live-session action contract; confirmation; observability.  
**Dependencies:** FEAT-011, FEAT-010, BR-018, BR-023, BR-027.

**Acceptance criteria**

1. Microphone permission is separate from camera permission and requested only after voice activation.
2. Listening, interpreting, confirming, acting, and failure states are visible and accessible.
3. A supported request such as “show me a different black jacket” uses the selected item and visible-result context to refine current products and change the live item through the shared action contract.
4. Add-to-bag, retailer handoff, and session-end requests require confirmation before action.
5. Unclear or failed speech preserves session state and offers retry or direct controls.
6. The approved context mode—sampled video/screen frames or structured session state—meets the spike’s usefulness, privacy, CPU, bandwidth, echo, and action-latency bar while Gemini, Decart, and gesture recognition run together.
7. Gemini and Decart can reconnect or resume independently without corrupting the other session or shared action state.

**End-to-end validation:** Given Gemini, Decart, and gesture recognition are active on the target device, when the customer asks for a different black jacket, then Gemini uses the approved video/screen or structured context mode, current products are refined, the selected item changes through the shared action contract, and direct controls remain available throughout.

#### FEAT-013 — Confirmed Hand-Gesture Control

**Priority:** Should-have  
**Primary source:** US-023; SC-015  
**Customer outcome:** The customer can use approved hand gestures for next, previous, and select actions from a distance while seeing whether a gesture was observed, accepted, ignored, or needs confirmation.

**Experience and system behavior**

- Teach only the approved small gesture vocabulary and preserve voice/direct alternatives.
- Represent observing, interpreting, accepted, ignored/unavailable, and confirming states.
- Show the recognized action before it changes the session.
- Require confirmation before consequential actions and allow undo for reversible navigation where approved.
- Pause or disable gesture observation without ending the live session.

**Integration points:** Camera-derived gesture recognition; shared live-session actions; confirmation; accessibility fallbacks.  
**Dependencies:** FEAT-011, BR-019, BR-023.

**Acceptance criteria**

1. The customer can review and practice the supported gesture vocabulary before activation.
2. Observed and interpreted gestures expose the proposed action before it is applied.
3. Next, previous, and select actions match the approved vocabulary and shared direct-control behavior.
4. Add-to-bag, retailer handoff, and session-end actions require explicit confirmation.
5. Low-confidence or unsupported gestures cause no hidden action and offer voice/direct alternatives.
6. The customer can pause gestures and continue the same live session with direct or voice controls.

**End-to-end validation:** Given gesture control is active, when the customer performs a supported next gesture and then an ambiguous gesture, then the next item changes after visible acceptance, the ambiguous input does nothing, and direct controls remain usable.

### PH-07 — Save Selections and Continue to the Retailer

**Usable customer outcome:** A customer can inspect recommendation details, organize selections in a Magic Mirror bag, understand current retailer ownership, and continue to a current retailer destination without losing their report or saved context.

**Why now:** Retailer action depends on proven current catalog references and transparent product provenance, but does not need to wait for voice or gestures.  
**Depends on:** PH-04; FEAT-011 for live-origin actions where present; BR-015 and BR-020.  
**Unlocks:** The complete approved journey from report acquisition to retailer action.  
**Parallel lanes:** Product detail and bag behavior can advance alongside PH-05 using current catalog fixtures; retailer handoff follows once current seller-link and attribution rules are proven.  
**Integration checkpoint:** SC-012 and the unavailable-product parts of SC-014 pass from both Style Home and live styling, with refreshed retailer details and preserved Magic Mirror state on return.

#### FEAT-014 — Current Product Detail and Availability

**Priority:** Should-have  
**Primary source:** US-016; SC-012, SC-014  
**Customer outcome:** The customer can inspect why a product was selected, see current retailer-owned details, and choose to try, save, or continue without confusing the product with Magic Mirror inventory.

**Experience and system behavior**

- Refresh the selected product/offer before showing current seller, options, price, availability, and destination.
- Explain recommendation rationale and retailer provenance.
- Offer add-to-bag, permitted live try-on, and retailer continuation actions.
- Replace unavailable details with current alternatives and keep the customer’s report and context.

**Integration points:** Shopify product refresh; stable references; recommendation rationale; live styling; bag; retailer provenance.  
**Dependencies:** FEAT-010, FEAT-003, BR-015.

**Acceptance criteria**

1. Product detail identifies the retailer and connects the item to a specific report signal or request.
2. Price, availability, option, seller, and checkout destination are refreshed before action and attributed to the retailer.
3. The customer can add the item to the Magic Mirror bag, try it live when permitted, or continue to the retailer.
4. An unavailable item offers refreshed alternatives without losing filters, report context, or other selections.
5. The interface does not imply Magic Mirror inventory, fit guarantee, delivery promise, or checkout ownership.

**End-to-end validation:** Given a recommended item, when its current offer becomes unavailable before detail opens, then the customer sees the unavailable state and current alternatives while their report and other selections remain unchanged.

#### FEAT-015 — Magic Mirror Bag

**Priority:** Should-have  
**Primary source:** US-017; SC-012, SC-014  
**Customer outcome:** The customer can collect and remove products, understand which retailer owns each offer, and recover when an item becomes unavailable.

**Experience and system behavior**

- Save stable selected product/offer references to the account-backed Magic Mirror bag.
- Group or label selections by retailer and distinguish the bag from retailer carts.
- Refresh current availability before display or handoff.
- Permit remove, continue styling, view alternatives, and proceed to retailer actions.
- Preserve the bag across return visits without caching prohibited live catalog data.

**Integration points:** Account state; stable catalog references; current availability refresh; retailer grouping.  
**Dependencies:** FEAT-014, FEAT-007, BR-015.

**Acceptance criteria**

1. Adding the same current product/offer does not create unintended duplicate bag entries.
2. Every item names its retailer and the bag clearly states it is not a retailer cart or Magic Mirror checkout.
3. Remove and continue-styling actions update the saved account state predictably.
4. Current price and availability refresh before display or handoff rather than relying on stored result data.
5. An unavailable item offers alternatives or removal without affecting other selections.
6. Returning customers can restore permitted saved references and current refreshed details.

**End-to-end validation:** Given products from two retailers in the bag, when one becomes unavailable, then the bag refreshes both, offers alternatives for the unavailable item, and preserves the other retailer’s selection.

#### FEAT-016 — Transparent Retailer Handoff

**Priority:** Should-have  
**Primary source:** US-018; SC-012  
**Customer outcome:** The customer knowingly leaves Magic Mirror for a current retailer destination while retaining their report and saved selections for return.

**Experience and system behavior**

- Refresh the selected seller and checkout/product destination immediately before handoff.
- Explain that the retailer controls price, inventory, payment, shipping, returns, and final purchase terms.
- Require confirmation before external navigation triggered by voice or gesture.
- Record only approved outbound attribution and preserve Magic Mirror account state.
- Support return to the same report, Style Home, bag, or live-session summary where possible.

**Integration points:** Current retailer link; outbound attribution; external navigation; saved account state; disclosure.  
**Dependencies:** FEAT-014, FEAT-015, BR-015, BR-020.

**Acceptance criteria**

1. Handoff identifies the destination retailer and clearly explains retailer-owned purchase responsibilities.
2. The destination is refreshed and valid at the moment the customer continues.
3. Voice or gesture handoff requests require explicit confirmation before leaving Magic Mirror.
4. Approved attribution does not include sensitive profile, photo, report, transcript, or authentication data.
5. Leaving and returning preserves the report and Magic Mirror bag state.
6. Magic Mirror never presents itself as the merchant, payment processor, fulfillment provider, or returns owner.

**End-to-end validation:** Given a customer with one selected product, when they confirm retailer handoff, then the current retailer destination opens with approved attribution; when they return, their report and bag remain available.

## Dependency and Parallelization Map

### Critical path

`PH-01 trustworthy identity → PH-02 profile/photos → BR-026 extraction or approved fallback → FEAT-006 dynamic taste calibration → PH-03 connected real report with safe previews/fallback → PH-04 current cross-retailer recommendations`

This path is the first coherent release. It proves the core customer value—including extracted garment signals, dynamic taste candidates, and safe generated wardrobe previews or their text-and-link fallback—without requiring camera, voice, gesture, or retailer-exit capabilities.

### Early demo-risk lane

`BR-017 Decart feasibility + BR-018 Gemini/Decart/gesture concurrency → PH-05/PH-06 go/no-go evidence`

These spikes begin alongside PH-01/PH-02. They do not change the report-led release-one sequence, but they surface the highest hackathon demo risks before late-phase implementation.

### Extension path

`PH-04 recommendations → PH-05 live direct control → PH-06 voice and gesture`

Voice and gestures depend on a stable direct-control action contract and can run in parallel with each other after PH-05 reaches a recoverable ready state.

### Retail action path

`PH-04 recommendations → FEAT-014 product detail → FEAT-015 bag → FEAT-016 handoff`

Product detail and bag work can overlap PH-05 because both depend primarily on current catalog references, not live video. FEAT-016 waits for proven retailer destinations and approved attribution/disclosure.

### Safe parallel lanes

- FEAT-001 and FEAT-002 can proceed in parallel after FEAT-003’s ownership and recovery contract is agreed.
- FEAT-004 and FEAT-005 can advance in parallel against one anonymous-progress contract. FEAT-006 presentation and fallback behavior can advance against fixtures, but integrated dynamic calibration waits for FEAT-005 and BR-026 extraction output or fallback signals.
- FEAT-007 account connection, FEAT-008 processing lifecycle, and FEAT-009 report/presentation work can advance against shared permitted fixtures, but the integrated report cannot pass until real ownership, structured output, catalog-image permission, and generated-preview quality/fallback behavior are proven.
- FEAT-010 catalog normalization and Style Home presentation can advance against permitted fixtures while Global Catalog access is validated.
- FEAT-012 voice and FEAT-013 gestures are parallel consumers of FEAT-011’s shared action and confirmation behavior.
- FEAT-014 and FEAT-015 can advance alongside live styling; FEAT-016 is the retailer-action integration checkpoint.
- BR-017 and BR-018 run concurrently with PH-01/PH-02 and join only at the PH-05/PH-06 implementation gates.

### Shared-state hotspots for the engineering plan

- Anonymous-to-permanent identity ownership and routing.
- Photo and derived-asset lifecycle.
- Wardrobe extraction provenance, partial failure, customer review decision, and direct style-signal fallback.
- Structured report version, correction, and recommendation evidence.
- Generated customer-likeness preview consent, quality, retention, product-image permission, disclosure, and text/link fallback.
- Stable product/offer references versus refreshed retailer-owned data.
- One action/confirmation model shared by direct controls, voice, and gestures.
- Sensitive-data-safe observability across provider boundaries.

These hotspots require explicit integration ownership and tests in the engineering plan; they do not justify speculative layers in this product plan.

## Coverage and Exclusions

### Story coverage

| Story | Primary feature |
| --- | --- |
| US-001 | FEAT-001 |
| US-002 | FEAT-002 |
| US-003, US-004 | FEAT-004 |
| US-005 | FEAT-005 |
| US-006 | FEAT-006 |
| US-007 | FEAT-007 |
| US-008 | FEAT-008 |
| US-009, US-010, US-011, US-012 | FEAT-009 |
| US-013, US-022 | FEAT-010 |
| US-014 | FEAT-011 |
| US-015 | FEAT-012 |
| US-016 | FEAT-014 |
| US-017 | FEAT-015 |
| US-018 | FEAT-016 |
| US-019, US-020, US-021 | FEAT-003 |
| US-023 | FEAT-013 |

All 23 approved stories have exactly one primary feature. Cross-cutting acceptance is referenced by dependent features rather than duplicated as separate scope.

### Scenario coverage

| Scenario | Covered by |
| --- | --- |
| SC-001 first-time customer receives a report | FEAT-001, FEAT-004, FEAT-005, FEAT-006, FEAT-007, FEAT-008, FEAT-009 |
| SC-002 returning customer resumes | FEAT-002, FEAT-010 |
| SC-003 invalid profile correction | FEAT-003, FEAT-004 |
| SC-004 independent photo failure | FEAT-003, FEAT-005 |
| SC-005 taste recovery | FEAT-003, FEAT-006 |
| SC-006 existing-account connection | FEAT-007 |
| SC-007 slow analysis | FEAT-003, FEAT-008 |
| SC-008 analysis failure | FEAT-003, FEAT-008 |
| SC-009 report exploration and correction | FEAT-009 |
| SC-010 camera denial/live recovery | FEAT-003, FEAT-011 |
| SC-011 voice-driven live change | FEAT-011, FEAT-012 |
| SC-012 product to bag to retailer | FEAT-014, FEAT-015, FEAT-016 |
| SC-013 sensitive isolation through account connection | FEAT-003, FEAT-005, FEAT-007 |
| SC-014 personalized recommendations and unavailable products | FEAT-010, FEAT-014, FEAT-015 |
| SC-015 gesture control with confirmation and equivalents | FEAT-003, FEAT-011, FEAT-013 |

### Screen/state coverage

The feature slices preserve the approved 48-record screen inventory. Slugs are used here for human review; stable UUIDs and the authoritative joins remain in `company/artifacts/prd/screens.json`.

| Feature | Approved screen/state slugs |
| --- | --- |
| FEAT-001 | `landing-page-base` |
| FEAT-002 | `account-access-unauthenticated`; `style-home-resume-or-recover` |
| FEAT-003 | Cross-cutting consent, accessibility, isolation, and recovery requirements embedded in every affected state below |
| FEAT-004 | Adopted v2: `conversation-welcome`; `conversation-personal-details`; `conversation-brand-sizing`. Archived reference: `personal-profile-base`; `personal-profile-validation-error`; `brand-and-size-profile-base` |
| FEAT-005 | Adopted v2: `conversation-photo-collection`; `conversation-photo-review`. Archived reference: `outfit-photo-upload-empty`; `outfit-photo-upload-partial`; `outfit-photo-upload-validation-error`. If BR-026 requires customer extraction review, amend the v2 inventory before implementation. |
| FEAT-006 | Adopted v2: `conversation-taste-calibration`. Archived reference: `taste-calibration-base`; `taste-calibration-recovery` |
| FEAT-007 | Adopted v2: `conversation-account-access`; `conversation-profile-review`. Archived reference: `account-connection-base`; `account-connection-magic-link-sent`; `account-connection-error-recovery` |
| FEAT-008 | `style-report-analysis-processing`; `style-report-analysis-slow`; `style-report-analysis-error-recovery` |
| FEAT-009 | `style-report-overview`; `style-report-color`; `style-report-body-style`; `style-report-recommendations`; `style-report-feedback-and-recalibration` |
| FEAT-010 | `style-home-base`; `style-home-resume-or-recover`; `recommended-product-unavailable` |
| FEAT-011 | `live-styling-camera-permission`; `live-styling-camera-denied`; `live-styling-connecting`; `live-styling-ready`; `live-styling-changing-item`; `live-styling-slow`; `live-styling-error-recovery`; `live-styling-ended` |
| FEAT-012 | `live-styling-microphone-permission`; `live-styling-voice-listening`; `live-styling-voice-interpreting`; `live-styling-voice-confirmation`; `live-styling-voice-acting`; `live-styling-voice-failure` |
| FEAT-013 | `live-styling-hand-gesture-guide`; `live-styling-gesture-observing`; `live-styling-gesture-interpreting`; `live-styling-gesture-accepted`; `live-styling-gesture-ignored-or-unavailable`; `live-styling-gesture-confirmation` |
| FEAT-014 | `recommended-product-detail-drawer`; `recommended-product-unavailable` |
| FEAT-015 | `magic-mirror-bag-base`; `bag-item-unavailable` |
| FEAT-016 | `retailer-handoff-confirmation` |

### Explicit exclusions from this build

- Magic Mirror checkout, payment, fulfillment, shipping, returns, or ownership of retailer price/inventory.
- Guaranteed fit, exact sizing, fabric behavior, delivery, attractiveness, or scientifically objective body classification.
- Medical, health, diagnostic, or body-value judgments.
- Onboarding or image processing for minors.
- A complete digital closet, social network, creator marketplace, or retailer analytics product. Core pre-report garment extraction is in scope; customer review remains a BR-026 decision.
- A required human stylist for every report.
- Multi-garment layered live outfits until Decart evidence supports the behavior and the founder adds it to scope.
- Automatic 24-hour photo deletion or any other unapproved retention promise.
- Reuse of Shopify Global Catalog product images for OpenAI image generation or Decart unless a permitted path or merchant authorization is confirmed.
- Form-based v1 pre-report implementation; its comps are archived reference only.

## Engineering-Plan Handoff

After founder approval of this build plan and resolution/assignment of the critical readiness blockers, the engineering plan must convert each PH/FEAT slice into an implementable full-stack sequence while preserving the IDs in this document.

- **Approved build-plan status:** `approved` by Talisha White on 2026-07-19; this approval authorizes checkpointed engineering planning, not implementation.
- **Critical readiness blockers:** BR-004, BR-005, BR-006, BR-007, BR-008, BR-009, BR-010, BR-011, BR-014, BR-016, BR-027.
- **Architecture decisions still required:** identity ownership/merge; persistence and private-asset lifecycle; Wardrobe extraction/fallback integration; dynamic candidate sourcing; structured report contract/versioning; asynchronous analysis/notification; generated-preview quality and catalog-image permission; provider boundaries; shared live-action state; observability; deployment; degraded-provider behavior.
- **Highest-risk integration boundaries:** anonymous-to-account ownership; Wardrobe reliability/latency/partial failure; OpenAI report and likeness-preview quality/timing; Shopify no-cache/image-reuse rules and current offer refresh; permitted garment imagery for OpenAI/Decart; Decart quality/latency; simultaneous Gemini, Decart, and gesture processing; gesture confidence and confirmation.
- **Founder-constrained implementation stack:** TypeScript frontend with Vite, Tailwind, and Bun; TypeScript API layer; Supabase database, auth, and private asset storage. These choices are resolved, not architecture alternatives.
- **Mandated or preferred providers from approved sources:** OpenAI for text agent, report, and still-image work; Google Gemini Live for voice and optional multimodal session awareness; Decart Lucy VTON for realtime try-on; Shopify Global Catalog for cross-retailer discovery. Each remains subject to its readiness evidence.
- **Recommended first integration milestone:** A signed-out adult completes chat-first Style Intelligence Golden Path on desktop and mobile, connects Google or magic-link access without losing anonymous work, receives a contract-valid report through real processing/recovery states, and sees current explainable Global Catalog recommendations with approved generated wardrobe previews or the complete text-and-link fallback.

The engineering plan must explicitly resolve:

1. Identity and ownership transitions from anonymous start through existing/new account connection, including cross-device resume and isolation tests.
2. The minimal relational state and private-asset lifecycle needed by profile, photos, taste, reports, recommendations, live sessions, bag, and deletion policy.
3. Typed validation at every external boundary and normalized timeout, slow, error, retry, and recovery outcomes.
4. The real style-analysis contract, structured report versioning, evidence/confidence model, correction path, safety review, and 120-second lifecycle.
5. Shopify Global Catalog search/lookup/product-refresh behavior, stable references, no-cache/image rules, provenance, unavailable offers, and retailer attribution.
6. Wardrobe extraction reliability, per-image concurrency/latency, partial failure, customer review, provenance, and direct style-signal fallback between upload and dynamic taste calibration.
7. OpenAI-generated wardrobe previews, customer-likeness safety, distinct retention/deletion, Shopify image-input permission, disclosure, current product links, and text/link fallback.
8. Decart session access, permitted garment-reference preparation, supported category limits, measured latency, and non-video fallback.
9. Gemini Live access, sampled video/screen versus structured state, session limits/resumption, and the shared command/confirmation state used by voice, gestures, and direct controls without coupling reconnect paths.
10. Purpose-specific consent, retention/deletion, sensitive-data-safe logs/analytics, and customer support recovery.
11. BDD-first validation for all 15 approved scenarios plus provider-contract, isolation, accessibility, and demo-recovery evidence.
12. Environment ownership, required secret names and secure locations, deployment, demo cutoff, and an explicit degraded-demo path for each critical provider.

The engineering plan must not silently broaden the scope, revert to form-based v1 pre-report UI, assume the Wardrobe repository passes its spike, reuse restricted catalog images, or reinterpret should-have capabilities as blockers for the first coherent report-and-recommendations release.

## Approval Decision

Talisha White approved this amended build plan on 2026-07-19 and authorized the checkpointed engineering-plan workflow. This approval confirms the first coherent release boundary, adopted chat-first v2 coverage, archived-reference treatment of form-based v1, amended readiness model, early risk-spike sequence, and phase/feature sequence. It is not authorization to begin implementation; the engineering-plan readiness gate remains controlling.
