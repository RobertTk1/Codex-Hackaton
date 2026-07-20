# Architecture Review

- **Decision:** Passed
- **Founder review:** “architecture looks clean” — Talisha White, 2026-07-20
- **Reviewed package:** `company/artifacts/engineering-plan/architecture/`
- **Next checkpoint:** `data-contract`

## Review method

The seven architecture files were checked against the founder-approved build plan, PRD v1.1.0, 23 user stories, 15 BDD scenarios, 48 canonical screen/state records, adopted eight-state conversational onboarding package, explicit exclusions, repository constraints, and 24-item ready implementation-prerequisite record.

Review checks included exact artifact presence, Markdown/Mermaid fence balance, local-link resolution, planning JSON validity, feature/route coverage, sensitive-data boundaries, provider failure behavior, repository/stack alignment, and current-versus-later scope separation.

## Scope and feature coverage

| Approved scope | Architecture coverage | Result |
|---|---|---|
| FEAT-001 landing/start | Public route shell, anonymous identity start, static web topology | Pass |
| FEAT-002 account access/resume | Auth module, Google/magic-link routes, persisted resume state | Pass |
| FEAT-003 trust/accessibility/recovery | Accessibility module, normalized errors, consent, RLS, degraded-mode rules | Pass |
| FEAT-004 profile and brand/category sizes | Conversational onboarding writing a validated profile; `profiles` and `brand_sizes` | Pass |
| FEAT-005 favorite-look photos | Private upload lifecycle, media validation, independent photo states | Pass |
| FEAT-006 Love/Hate/Maybe calibration | Extracted-signal candidate generation, reactions/undo, balanced fallback | Pass |
| FEAT-007 anonymous account connection | Hashed one-use transfer and transactional existing-account merge | Pass |
| FEAT-008 analysis lifecycle | Durable report run/job, slow/error states, idempotency and retry | Pass |
| FEAT-009 report and generated previews | Versioned structured report, recommendations, private derived previews, text/link fallback | Pass |
| FEAT-010 Style Home/catalog | Style Home route, live Shopify refresh, stable references, direct live entry | Pass |
| FEAT-011 recoverable live styling | Owned session, Decart short-lived access, independent reconnect and fallback | Pass |
| FEAT-012 Gemini voice | Gemini Live boundary, optional visual context, typed function proposals | Pass |
| FEAT-013 gestures | Local proposal recognizer, shared `LiveAction`, confirmation and alternatives | Pass |
| FEAT-014 product detail | URL-addressable detail state and current offer refresh | Pass |
| FEAT-015 bag | Account-owned stable product references with live refresh | Pass |
| FEAT-016 retailer handoff | Explicit retailer boundary, current URL verification, non-sensitive outbound event | Pass |

The build plan already maps every approved story and scenario to these 16 features. The route-family inventory covers every canonical screen slug, including slow, unavailable, denied, confirmation, failure, and recovery states. The approved conversational v2 remains the pre-report implementation direction; form-based v1 is not selected for implementation.

## Architecture concern review

| Concern | Evidence | Result |
|---|---|---|
| Minimal repository shape | `apps/web`, `apps/api`, one shared contract package, Supabase migrations/seed | Pass |
| Founder-constrained stack | TypeScript, Vite, React, Tailwind, Bun, Supabase, DigitalOcean | Pass |
| Direct data flow | Route → Zod → capability → Supabase/provider; no ORM, broker, repository/service framework | Pass |
| Typed external boundaries | Zod at browser/API, storage, model, provider, and catalog boundaries | Pass |
| Durable long-running work | Postgres job leases, idempotency, bounded attempts, visible lifecycle | Pass |
| Anonymous ownership | Real anonymous identity, immutable owner, explicit permanent-account claim | Pass |
| Private media | Private buckets, opaque paths, short signed reads, lineage, deletion jobs | Pass |
| Catalog freshness | Stable references only; live current facts; no cached Shopify payload/image authority | Pass |
| Realtime separation | Decart and Gemini connect/recover independently; gestures remain local proposals | Pass |
| Shared action safety | Direct, voice, and gesture converge on one sequenced union; consequential actions confirm | Pass |
| Provider degradation | Report inputs preserved; preview, catalog, voice, gesture, and realtime fallbacks are explicit | Pass |
| Observability | Allowlisted structured metadata; sensitive contents, URLs, tokens, and media excluded | Pass |
| Deployment/recovery | One App Platform app, static/API/worker components, health checks, rollback and migration rules | Pass |
| Accessibility | Keyboard/reduced-motion/focus/announcements and direct alternatives are component responsibilities | Pass |

## Security and privacy review

- Every protected operation derives ownership from verified identity; RLS and storage policies remain mandatory before access.
- Original photos, body/profile information, live media, and derived likeness images are classified as restricted.
- Purpose-specific consent separates analysis, extraction, generated previews, live media, and optional Gemini visual context.
- Seven-day anonymous cleanup, 30-day original/preview retention, no default live-media/transcript persistence, and account deletion are architected as durable jobs.
- Upload, prompt-injection, IDOR, transfer replay, SSRF/URL, realtime-token, accidental-action, logging, and orphaned-asset threats have named controls and verification paths.
- Permanent provider/admin credentials remain server-only; the browser receives only user sessions or scoped short-lived provider access.
- The unresolved Shopify product-image permission question remains visibly characterized as founder-accepted hackathon risk, not authorization; text/current-link and user-owned/permitted garment fallbacks remain required.

Result: no unmitigated architecture-level security or privacy failure was found. Exact policies, columns, schemas, and tests must be fixed in the data/application contract steps.

## Exclusion and scope-discipline review

The architecture does not add Magic Mirror checkout, payment, fulfillment, returns, price/inventory ownership, medical or attractiveness judgments, minors, a social network, creator marketplace, retailer analytics, required human styling, a complete digital closet, guaranteed fit, or multi-garment live layering.

No 24-hour deletion promise, catalog-image permission claim, generalized model router, workflow platform, analytics SDK, message broker, ORM, or global state framework was introduced.

## Source conflict disposition

The approved build plan says the report-led journey supersedes the older single-photo roadmap, while the active repository guideline defines the one-photo/one-garment try-on as the hackathon V1 golden path. The architecture does not pretend these are identical:

1. it keeps the narrow try-on as the first independently runnable integrated slice required by the repository;
2. it keeps the founder-approved report and recommendations as the first coherent product release and stages it on the same boundaries;
3. it does not make later live voice, gesture, bag, or retailer capabilities block the report release.

This is accepted as an explicit sequencing reconciliation, not an unresolved architectural contradiction. Future ticket sequencing must preserve both descriptions and identify which milestone each ticket serves.

## Readiness reconciliation

All 24 engineering-plan readiness requirements are `ready`. Architecture preserves the non-secret access evidence and the following mandatory implementation-time checks:

- OpenAI-dependent tickets must demonstrate a successful paid request; the last verified paid call returned `insufficient_quota` and founder approval only defers funding.
- The Decart feasibility and Gemini/Decart/gesture concurrency spikes run early, in parallel with initial product work.
- Wardrobe-inspired extraction must meet reliability/latency/partial-failure evidence or use the approved direct-style-signal fallback.
- Generated-preview quality and product-image transmission remain measured/risk-labeled behaviors with complete non-image fallback.
- Final DigitalOcean origins must be added to Supabase Auth, Google OAuth, and CORS allowlists.

## Review decision

**Pass.** No architecture repair is required. The package is sufficiently complete and internally consistent to begin the exact data-contract step. Architecture approval does not authorize implementation.
