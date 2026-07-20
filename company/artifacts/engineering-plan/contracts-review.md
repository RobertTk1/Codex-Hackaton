# Application Contracts Review

- **Decision:** Passed after repair
- **Reviewed:** 2026-07-20
- **Contract version:** `2026-07-20.2`
- **Next workflow step:** `engineering-tickets`
- **Implementation status:** Not started

## Review conclusion

The application contract package now gives every approved screen action one typed browser, API, or managed-service boundary and reconciles those boundaries with the persistence contract. The review found material mismatches; they were repaired in the owning artifacts before this pass was recorded. No unresolved source conflict remains.

## Findings and repairs

| Finding | Repair verified |
|---|---|
| CR-001 — Favorite brands and category sizes were conflated. | Added ordered `favorite_brands`; every brand/category size now has exact `known`, `unknown`, or `not_applicable` status and conditional label rules. |
| CR-002 — The conversational parser could not legally write the natural brand/size turn shown by the approved screen. | Added `favorite_brands` and `brand_sizes` to the exact conversational target union while retaining structured fallback operations. |
| CR-003 — Personal facts could be stored before profile-processing consent, and stale v2 guidance still implied an unapproved styling-goal answer. | Consent now precedes facts; adult ineligibility stores nothing; implementation copy/specs collect only the approved FEAT-004 fields. Generated raster lettering remains spatial reference only. |
| CR-004 — Photo formats and ordering differed between copy, API, Storage, and provider handling. | JPEG, PNG, WebP, HEIC, and HEIF are accepted end to end; HEIC/HEIF conversion is request-scoped; one exact revision-checked reorder operation covers all relevant screens. |
| CR-005 — A broad Storage insert policy could not prove that an upload matched a server-issued slot. | Upload uses Supabase's one-path signed upload token with upsert disabled plus a separate application completion token; customers have no general Storage insert grant. |
| CR-006 — Replace-photo UI could violate the unique position constraint or destroy the old photo before validating the new one. | Replacement tokens bind the exact old photo and position; completion validates first, atomically swaps metadata under the deferred constraint, then deletes the inaccessible old object with reconciliation fallback. |
| CR-007 — Idempotency rules had no durable persistence contract. | Added bounded private idempotency records keyed by owner/operation/key and validated-body fingerprint; durable subjects replay while ephemeral tokens are re-minted and never stored. |
| CR-008 — Live session creation incorrectly implied microphone permission, and stale gesture/voice results were not rejectable from persisted state. | Camera consent gates session creation; microphone and optional Gemini visual context gate voice activation; bounded result-set/action-sequence fields reject stale work without storing raw provider sessions or video. |
| CR-009 — Errors and success bodies were prose-level/generic rather than implementation-testable. | All 49 operations now reference exact closed success schemas; error `details` are discriminated bounded shapes; operation error codes match the normalized catalog. |
| CR-010 — Report processing did not distinguish the approved 90–119 second extended state from the 120-second slow state. | The state contract preserves the meaningful stage at 90–119 seconds and exposes the separate slow/notification/safe-exit state at 120 seconds. |
| CR-011 — Shopify references and provider persistence claims did not match the current Global Catalog boundary. | Product, shop, and optional variant refs use current stable mappings; mutable seller/product facts refresh live; Decart/Gemini provider session identifiers and raw payloads are not stored. |
| CR-012 — Style Home lacked the approved direct live entry, real suggested-outfit composition, and saved-selection previews. | `StyleHomeSnapshot` now includes live eligibility, report, standalone recommendations, deterministic suggested-outfit groups, saved-item previews/count, and recoverable work. |
| CR-013 — Post-report brand/size editing conflicted with frozen report evidence. | Edit style profile starts a confirmed derived recalibration draft and reuses the conversational operations; the published report stays immutable until replacement succeeds. |
| CR-014 — Exact example payloads were missing. | Added schema-conforming request and success fixtures for all 49 operations and validated every body and explicit parameter against OpenAPI/JSON Schema. |

## Coverage evidence

| Surface | Result |
|---|---:|
| API catalog ↔ OpenAPI paths/methods | 49 / 49 exact |
| API operations present in screen/action contract | 49 / 49 |
| Exact reusable success response objects | 34 |
| Schema-conforming operation request/success examples | 49 / 49 |
| Canonical PRD screen/state records mapped | 48 / 48 |
| Approved conversational v2 states mapped | 8 / 8 |
| User stories checked | 23 / 23 |
| Acceptance scenarios checked | 15 / 15 |
| Local contract links | all resolved |
| OpenAPI/internal/external schema references | all resolved |
| Normalized error codes used but absent from catalog | 0 |
| Generic success payloads/placeholders remaining | 0 |

## Provider and security boundary check

- Supabase anonymous/permanent identity, transfer, private Storage, signed upload, expiry, deletion block, and RLS authority agree with the data contract.
- OpenAI remains the text/report/image-generation provider; photo and catalog inputs are bounded, consent/rights gated, and never persisted as raw provider bodies.
- Shopify Global Catalog remains live product authority; checkout is a disclosed retailer handoff, not a Magic Mirror order.
- Decart and Gemini credentials are short-lived and server-minted. Decart owns rendered media; Gemini owns optional live voice/context; both degrade independently and emit only normalized actions through the API.
- Wardrobe extraction is a bounded photo-derived input with partial failure and direct-signal fallback; report completion is not blocked by a failed preview or one failed extraction.

## Preserved implementation gates

This review approves planning contracts, not runtime behavior. Engineering tickets must still prove migrations/RLS, exact Zod parsing, upload/replacement cleanup, anonymous transfer, provider timeouts and normalized failures, report idempotency, dynamic catalog freshness, live stale-action rejection, accessibility, and the Playwright golden path. A failed implementation proof returns the affected contract or ticket for repair; it does not weaken these rules.

## Decision

**Pass and advance to `engineering-tickets`.** The operations, schemas, states, provider boundaries, errors, diagrams, and screen actions now agree closely enough to decompose into checkable engineering work without inventing missing product behavior during implementation.
