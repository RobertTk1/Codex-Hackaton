# Client/Server API Contract

- **Status:** Approved after cross-contract review
- **Version:** `2026-07-20.2`
- **Base path:** `/api/v1`
- **Wire format:** UTF-8 JSON unless an operation explicitly returns no body
- **Machine-readable companions:** [OpenAPI 3.1 operations](openapi.yaml), [exact success schemas](schemas.yaml), and [validated operation examples](examples.yaml)

This contract defines the browser-to-Magic-Mirror API. Supabase Auth and the initial private photo upload are the only approved browser-to-managed-service boundaries; all provider calls and all privileged database/storage work remain server-side. The [data contract](data.md) remains authoritative for stored names, constraints, and lifecycle rules.

## Protocol rules

### Authentication

Protected requests send `Authorization: Bearer <Supabase access token>`. The API validates the token and derives `owner_id`; no request body or path can choose an owner. `public` operations require no session. `owned` operations accept anonymous or permanent Supabase users. `permanent` operations reject anonymous users. Exact identity and transfer behavior is in [auth.md](auth.md).

### Headers

| Header | Required | Rule |
|---|---|---|
| `Authorization` | Protected operations | Supabase bearer access token; never logged |
| `Content-Type: application/json` | JSON mutation | Required |
| `X-Request-Id` | Optional | Client UUID; server generates one when absent and always returns it |
| `Idempotency-Key` | Named create/action operations | Client UUID, 36 characters; same owner + operation + validated-body fingerprint returns the same durable result; ephemeral upload/realtime/handoff tokens are safely re-minted and never persisted |
| `If-Match-Revision` | Draft profile mutations | Positive integer equal to current `profiles.revision`; mismatch returns `409 REVISION_CONFLICT` |

Responses include `X-Request-Id`. Successful writes that change a draft profile include `revision`; a `204` draft mutation returns the new value in `X-Profile-Revision`. Secrets, signed URLs/tokens, provider bodies, prompts, transcripts, and raw media never enter errors or logs.

### Time and pagination

Times are RFC 3339 UTC strings. Lists use keyset pagination with `limit` from 1–50 and opaque `cursor`; responses return `nextCursor` or `null`. Offset pagination is not used. Report status polling is no faster than every two seconds. Ordinary API calls have a 15-second server deadline; Shopify refresh has an 8-second provider deadline; realtime token minting has a 10-second deadline. Durable worker work is never held open by an HTTP request.

### Success and error envelopes

Single-resource success responses use the named resource directly. Collection responses use `{ "items": [], "nextCursor": null }`. Accepted durable work returns `202` with its subject resource and `pollAfterMs`.

All failures use the exact top-level shape from [errors.md](errors.md):

```json
{
  "error": "Customer-safe summary",
  "code": "STABLE_MACHINE_CODE",
  "details": {},
  "requestId": "opaque-request-id"
}
```

### Common identifiers and references

All Magic Mirror IDs are UUIDs. A catalog reference is the validated tuple below; it contains stable opaque identifiers only, never cached title, price, image, inventory, or checkout URL.

```json
{
  "productRef": "gid://shopify/p/opaque",
  "shopRef": "opaque-shop-reference",
  "variantRef": "gid://shopify/ProductVariant/opaque-or-null"
}
```

## Operation catalog

The `operationId` is the implementation and screen-mapping authority. Inputs listed as `path`, `query`, or `body` are exhaustive; every object rejects unknown keys.

### Public entry and session

| operationId | Method and path | Auth | Exact input | Success | Writes | Named errors |
|---|---|---|---|---|---|---|
| `getPublicConfiguration` | `GET /configuration` | public | none | `200 PublicConfiguration` with enabled auth methods, upload limits, provider-feature availability, consent versions, and support URL | none | `SERVICE_UNAVAILABLE` |
| `resolveResume` | `GET /resume` | owned | none | `200 ResumeDecision` with `destination`, `profileId`, `profileStatus`, `currentStep`, `reportRunId?`, `liveSessionId?` | none | `ACCOUNT_DELETION_IN_PROGRESS` |
| `createOrResumeProfile` | `POST /profiles/resume` | owned | idempotency; body `{ "entry": "landing" | "login" | "new_report" }` | `200 ProfileSnapshot` or `201 ProfileSnapshot` | `profiles` only when no resumable draft exists | `PROFILE_LIMIT_REACHED`, `ACCOUNT_DELETION_IN_PROGRESS` |
| `getStyleHome` | `GET /style-home` | permanent | none | `200 StyleHomeSnapshot` with current report summary, current recommendations, suggested outfit groups, up to six saved-item previews plus bag count, recoverable work, and direct live eligibility | none; Shopify facts may be refreshed synchronously | `NO_ACTIVE_PROFILE`, `CATALOG_TEMPORARILY_UNAVAILABLE` |

`ResumeDecision.destination` is one of `/onboarding`, `/analysis/{runId}`, `/report`, `/style-home`, `/live/{sessionId}`, or `/`. It is derived from persisted state, not a client-supplied redirect.

### Conversational onboarding and profile

The server persists validated facts, not chat transcripts. The browser renders the conversational history and reconstructs a concise factual summary from `ProfileSnapshot` after reload.

| operationId | Method and path | Auth | Exact input | Success | Writes | Named errors |
|---|---|---|---|---|---|---|
| `getProfileSnapshot` | `GET /profiles/{profileId}` | owned | path `profileId` | `200 ProfileSnapshot` | none | `PROFILE_NOT_FOUND`, `PROFILE_EXPIRED` |
| `submitConversationTurn` | `POST /profiles/{profileId}/conversation/turns` | owned | revision; body `ConversationTurnInput` | `200 ConversationTurnResult` | accepted profile field or favorite-brand/size rows, `current_step`, `revision`, activity deadline extension | `ANSWER_NEEDS_CLARIFICATION`, `PROFILE_FIELD_INVALID`, `BRAND_SIZE_INVALID`, `ADULT_ELIGIBILITY_REQUIRED`, `CONSENT_REQUIRED`, `REVISION_CONFLICT`, `PROFILE_NOT_EDITABLE` |
| `replaceProfileAnswer` | `PUT /profiles/{profileId}/answers/{field}` | owned | revision; path field from the personal-field union; body `{ "turnId": uuid, "text": "replacement answer", "locale": "BCP-47", "reason": "customer_edit" }` | `200 ConversationTurnResult` with invalidated downstream facts | profile change, revision; dependent candidates/run only as allowed by data transactions | same as above plus `DEPENDENT_WORK_ALREADY_PUBLISHED` |
| `putFavoriteBrands` | `PUT /profiles/{profileId}/favorite-brands` | owned | revision; body `{ "items": FavoriteBrandInput[1..20] }` | `200 ProfileSnapshot` | replaces ordered `favorite_brands`; removes size rows only for brands explicitly removed; revision | `FAVORITE_BRAND_INVALID`, `DUPLICATE_FAVORITE_BRAND`, `REVISION_CONFLICT` |
| `putBrandSizes` | `PUT /profiles/{profileId}/brand-sizes` | owned | revision; body `{ "items": BrandSizeInput[0..20] }` | `200 ProfileSnapshot` | replaces ordered `brand_sizes` transactionally; uniqueness is brand + garment type; revision | `BRAND_SIZE_INVALID`, `FAVORITE_BRAND_REQUIRED`, `DUPLICATE_BRAND_GARMENT_TYPE`, `REVISION_CONFLICT` |
| `recordConsent` | `POST /profiles/{profileId}/consents` | owned | idempotency; body `ConsentInput` | `201 ConsentReceipt` | append-only `consent_records`; revocation may enqueue purge | `CONSENT_VERSION_INVALID`, `CONSENT_REQUIRED`, `PROFILE_NOT_FOUND` |
| `submitProfileForReport` | `POST /profiles/{profileId}/report-runs` | permanent | revision + idempotency; body `{ "profileRevision": integer, "notifyWhenReady": boolean }` | `202 ReportRunSnapshot`, `pollAfterMs: 2000`; replay returns `200/202` same run | freezes profile, creates `report_runs` + `processing_jobs`; optional notification intent | `PROFILE_INCOMPLETE`, `PHOTO_MINIMUM_NOT_MET`, `TASTE_MINIMUM_NOT_MET`, `CONSENT_REQUIRED`, `REPORT_ALREADY_SUCCEEDED`, `REVISION_CONFLICT` |

`ConversationTurnInput` is:

```json
{
  "turnId": "uuid",
  "targetField": "name | adult_confirmation | gender | age | height | weight | fit_preference | favorite_brands | brand_sizes",
  "text": "customer answer, 1-500 characters",
  "locale": "BCP-47 tag"
}
```

The accepted facts are exactly `name`, adult confirmation, `gender`, `age`, `height_cm`, optional `weight_kg`, overall `fit_preference` (`fitted`, `regular`, `relaxed`, or `varies`), ordered favorite brands, and brand/garment-type size entries with `known`, `unknown`, or `not_applicable` status. The agent asks explicitly, “How do you like your clothes to fit overall—fitted, regular, relaxed, or does it depend on the garment?” Customer language such as “loose” normalizes to `relaxed`; ambiguity returns clarification without mutation. Profile-processing consent is required before the first personal fact is persisted. A negative adult confirmation or age below 18 returns `422 ADULT_ELIGIBILITY_REQUIRED` without storing the disallowed answer; because eligibility precedes photos, the normal path retains no photo data for an unsupported person. The same guard rejects a later edit to an ineligible age without mutating the existing draft. A broad styling-goal question is not part of the approved FEAT-004 persistence contract and therefore must not solicit a factual answer that appears saved; conversational framing may explain the report outcome without collecting an extra field. Height and weight responses include the normalized metric value plus the customer-facing interpretation; ambiguity returns `422 ANSWER_NEEDS_CLARIFICATION` without mutation. `ProfileSnapshot` includes fit preference, ordered favorite brands and garment-type sizes, photo summaries, reaction progress, consent decisions, completion blockers, and `revision`; it excludes email, auth tokens, storage paths, upload/download tokens, and raw provider output.

### Photo upload, validation, and extraction

Uploads use a two-boundary protocol so media bytes do not traverse the API service:

1. `createPhotoUploadSlot` reserves an opaque object path and position, optionally binds the slot to one existing photo being replaced, creates a Supabase signed upload token with upsert disabled, and signs a separate application completion token. Neither token is stored.
2. The browser calls Supabase Storage `uploadToSignedUrl` for that exact private `customer-photos` path. The token grants no other path or Storage action.
3. `completePhotoUpload` verifies the completion token and exact object, then reads/decodes/hashes it, creates the `photos` metadata row, and enqueues extraction for accepted files. For a replacement, one database transaction locks the old row, inserts the new row at the same position under the deferred unique constraint, deletes the old row, and increments the profile revision once; the now-orphaned old object is deleted after commit and remains unreadable if cleanup must retry.
4. An uncompleted object is unreadable to customers and is deleted only after the provider's two-hour upload-token lifetime plus a bounded reconciliation grace period.

| operationId | Method and path | Auth | Exact input | Success | Writes | Named errors |
|---|---|---|---|---|---|---|
| `createPhotoUploadSlot` | `POST /profiles/{profileId}/photo-upload-slots` | owned | revision + idempotency; body `{ "position": 1..12, "declaredMediaType": JPEG|PNG|WebP|HEIC|HEIF, "declaredByteSize": 1..15728640, "replacesPhotoId": uuid|null }`; replacement ID must be the owned current photo at `position` | `201 PhotoUploadSlot` with `photoId`, bucket, exact path, Supabase `uploadToken`, application `completionToken`, `expiresAt`; tokens are sensitive and one-path only | no row/cache; server creates signed upload token and application token bound to replacement identity/revision | `PHOTO_LIMIT_REACHED`, `PHOTO_REPLACEMENT_STALE`, `UPLOAD_DECLARATION_INVALID`, `REVISION_CONFLICT` |
| `completePhotoUpload` | `POST /profiles/{profileId}/photos/{photoId}/complete` | owned | revision + idempotency; body `{ "completionToken": signed opaque token }` | `202 AcceptedPhoto` with `photo`, `revision`, `pollAfterMs: 2000` | verified `photos`; accepted add or atomic same-position replacement + extraction job; revision/activity; old replacement object cleanup after commit | `UPLOAD_NOT_FOUND`, `UPLOAD_SLOT_EXPIRED`, `UPLOAD_TOKEN_INVALID`, `PHOTO_REPLACEMENT_STALE`, `PHOTO_TYPE_UNSUPPORTED`, `PHOTO_TOO_LARGE`, `PHOTO_DIMENSIONS_INVALID`, `PHOTO_DECODE_FAILED`, `DUPLICATE_PHOTO`, `PHOTO_REJECTED`, `REVISION_CONFLICT` |
| `listPhotos` | `GET /profiles/{profileId}/photos` | owned | none | `200 { items: PhotoSnapshot[0..12] }` | none | `PROFILE_NOT_FOUND`, `PROFILE_EXPIRED` |
| `deletePhoto` | `DELETE /profiles/{profileId}/photos/{photoId}` | owned | revision; body absent | `204` | deletes exact object first, then row/cascades; compacts positions; revision | `PHOTO_NOT_FOUND`, `PROFILE_NOT_EDITABLE`, `PHOTO_DELETE_FAILED`, `REVISION_CONFLICT` |
| `reorderPhotos` | `PUT /profiles/{profileId}/photos/order` | owned | revision; body `{ "orderedPhotoIds": uuid[0..12] }` | `200 { "items": PhotoSnapshot[], "revision": integer }` | locks exact current set, defers position uniqueness, assigns 1..N, revision | `PHOTO_ORDER_INVALID`, `PHOTO_NOT_FOUND`, `PROFILE_NOT_EDITABLE`, `REVISION_CONFLICT` |
| `retryPhotoExtraction` | `POST /profiles/{profileId}/photos/{photoId}/extraction-retries` | owned | idempotency | `202 PhotoSnapshot` | conditional photo transition + new bounded job if eligible | `PHOTO_NOT_RETRYABLE`, `EXTRACTION_ATTEMPTS_EXHAUSTED`, `PHOTO_EXPIRED` |
| `getExtractionSummary` | `GET /profiles/{profileId}/extraction-summary` | owned | none | `200 ExtractionSummary` with per-photo state, accepted garment counts, confidence disclosure, review requirement, and fallback availability | none | `PROFILE_NOT_FOUND` |
| `reviewExtractedGarment` | `PATCH /profiles/{profileId}/garments/{garmentId}` | owned | revision; body `{ "reviewStatus": "confirmed" | "rejected" }` | `200 ExtractionSummary` | `extracted_garments.review_status`, revision | `GARMENT_NOT_FOUND`, `GARMENT_REVIEW_NOT_REQUIRED`, `REVISION_CONFLICT` |

`PhotoSnapshot` never exposes `storage_path` or either upload token. It contains `id`, `position`, `status`, safe rejection code/message key, dimensions, byte size, expiry, extraction summary, and an on-demand owned display URL that expires no later than the row. The API may return that URL only after relational ownership and expiry checks.

### Taste calibration

| operationId | Method and path | Auth | Exact input | Success | Writes | Named errors |
|---|---|---|---|---|---|---|
| `ensureTasteCandidates` | `POST /profiles/{profileId}/taste-candidates` | owned | revision + idempotency; body `{ "allowCuratedFallback": true }` | `202 TasteCalibrationSnapshot` while generating, otherwise `200` | candidate job and eventually 12–20 candidates | `STYLE_EVIDENCE_INSUFFICIENT`, `CANDIDATE_GENERATION_FAILED`, `REVISION_CONFLICT` |
| `getTasteCalibration` | `GET /profiles/{profileId}/taste-calibration` | owned | query `afterPosition?` | `200 TasteCalibrationSnapshot` | none; live Shopify media may be resolved for catalog-sourced candidates | `CANDIDATES_NOT_READY`, `CATALOG_TEMPORARILY_UNAVAILABLE` |
| `putTasteReaction` | `PUT /profiles/{profileId}/taste-reactions/{candidateId}` | owned | revision + idempotency; body `{ "reaction": "love" | "hate" | "maybe" }` | `200 TasteCalibrationSnapshot` | insert/update reaction, clears `undone_at`, revision | `CANDIDATE_NOT_FOUND`, `CANDIDATE_UNAVAILABLE`, `REVISION_CONFLICT` |
| `undoTasteReaction` | `POST /profiles/{profileId}/taste-reactions/{candidateId}/undo` | owned | revision + idempotency | `200 TasteCalibrationSnapshot` | sets `undone_at`, revision | `REACTION_NOT_FOUND`, `REACTION_ALREADY_UNDONE`, `REVISION_CONFLICT` |

The server preserves completed reactions when candidate loading later fails. It returns a balanced curated fallback promptly rather than blocking onboarding; it never substitutes a static set while claiming it was personalized.

### Account transfer

| operationId | Method and path | Auth | Exact input | Success | Writes | Named errors |
|---|---|---|---|---|---|---|
| `prepareAnonymousTransfer` | `POST /auth/transfers` | owned anonymous | revision + idempotency; body `{ "profileId": uuid, "method": "google" | "magic_link" }` | `201 TransferPreparation`; also sets a Secure, HttpOnly, SameSite=Lax transfer cookie | hashed `anonymous_transfers` row | `ANONYMOUS_ACCOUNT_REQUIRED`, `TRANSFER_ALREADY_PREPARED`, `REVISION_CONFLICT` |
| `consumeAnonymousTransfer` | `POST /auth/transfers/consume` | permanent | body `{ "profileId": uuid, "confirmation": "preserve_as_new_draft" | "activate_if_no_existing_profile" }`; plaintext token comes only from cookie | `200 TransferResult` and clears cookie | transactionally transfers/copies approved rows, consumes token | `TRANSFER_TOKEN_MISSING`, `TRANSFER_EXPIRED`, `TRANSFER_REPLAYED`, `TRANSFER_SOURCE_CHANGED`, `TRANSFER_CONFLICT_REQUIRES_CONFIRMATION`, `TRANSFER_TARGET_INVALID` |
| `cancelAnonymousTransfer` | `DELETE /auth/transfers/current` | owned | none | `204`, clears cookie | prepared row -> cancelled | `TRANSFER_NOT_FOUND` |

Google OAuth and magic-link dispatch/callback use Supabase directly as specified in [auth.md](auth.md). The API never receives a Google token or email magic-link token. If the link is opened outside the original PKCE browser, authentication may succeed but draft transfer cannot; the customer is told to return to the original browser, and the anonymous draft remains intact until expiry.

### Report, feedback, and recommendations

| operationId | Method and path | Auth | Exact input | Success | Writes | Named errors |
|---|---|---|---|---|---|---|
| `getReportRun` | `GET /report-runs/{runId}` | permanent | path | `200 ReportRunSnapshot`; `Retry-After: 2` while active | none | `REPORT_RUN_NOT_FOUND` |
| `retryReportRun` | `POST /report-runs/{runId}/retries` | permanent | idempotency | `202` new `ReportRunSnapshot` | next bounded run sequence + job | `REPORT_NOT_RETRYABLE`, `REPORT_ATTEMPTS_EXHAUSTED`, `REPORT_ALREADY_SUCCEEDED` |
| `requestReportNotification` | `PUT /report-runs/{runId}/notification` | permanent | idempotency; body `{ "enabled": true }` | `200 { "enabled": true }` | notification job/delivery if not already sent | `REPORT_RUN_NOT_FOUND`, `EMAIL_NOT_AVAILABLE` |
| `getCurrentReport` | `GET /reports/current` | permanent | none | `200 ReportDocument` | none; recommendation product facts refreshed separately | `REPORT_NOT_FOUND` |
| `getReportSection` | `GET /reports/{reportId}/sections/{sectionType}` | permanent | `sectionType=overview|color|body_style` | `200 ReportSection` | none | `REPORT_NOT_FOUND`, `REPORT_SECTION_NOT_FOUND` |
| `listRecommendations` | `GET /reports/{reportId}/recommendations` | permanent | cursor, limit | `200 RecommendationCollection` with current catalog facts or per-item unavailable state; optional report-local outfit group key/title/item position compose suggested outfits without treating retailer facts as report evidence | none | `REPORT_NOT_FOUND`, `CATALOG_TEMPORARILY_UNAVAILABLE` |
| `submitReportFeedback` | `POST /reports/{reportId}/feedback` | permanent | idempotency; body `{ "sectionType": section|null, "kind": allowed value, "note": string|null }` | `201 ReportFeedbackReceipt` | append `report_feedback` | `FEEDBACK_INVALID`, `REPORT_NOT_FOUND` |
| `startRecalibration` | `POST /reports/{reportId}/recalibrations` | permanent | idempotency; body `{ "confirmed": true }` | `201 ProfileSnapshot` for derived draft | derived draft profile; no silent report mutation | `RECALIBRATION_CONFIRMATION_REQUIRED`, `DRAFT_ALREADY_EXISTS`, `REPORT_NOT_FOUND` |

Editing fit preference, favorite brands, brand/garment-type sizes, or other profile evidence after a report uses `startRecalibration` first. The resulting derived draft is edited through the same conversational/profile operations and the published report remains intact until a new report succeeds; post-report editing never mutates frozen evidence in place.

The `Save palette` and `Save guidance` screen actions are local exports: the browser downloads an accessible text/JSON or printable document from the already-loaded report section. They do not claim server persistence and have no API operation. Generated preview absence or rejection never removes the recommendation.

`ReportRunSnapshot` includes `elapsedMs`, current stage, and safe stage label. Before 90 seconds the processing projection uses the normal stage treatment; from 90 through 119 seconds it keeps the meaningful stage visible and adds an extended-progress explanation without offering false precision; at 120 seconds it projects the approved slow state and its notification/safe-exit actions.

### Catalog, product detail, bag, and retailer handoff

| operationId | Method and path | Auth | Exact input | Success | Writes | Named errors |
|---|---|---|---|---|---|---|
| `searchCatalog` | `POST /catalog/search` | permanent | body `CatalogSearchInput` | `200 CatalogSearchResult` with current normalized facts | none | `CATALOG_QUERY_INVALID`, `CATALOG_TEMPORARILY_UNAVAILABLE`, `CATALOG_RATE_LIMITED` |
| `getProduct` | `POST /catalog/product` | permanent | body catalog reference + selected options | `200 ProductSnapshot` | none | `CATALOG_REFERENCE_INVALID`, `PRODUCT_NOT_FOUND`, `PRODUCT_UNAVAILABLE`, `VARIANT_UNAVAILABLE`, `CATALOG_TEMPORARILY_UNAVAILABLE`, `CATALOG_RATE_LIMITED`, `CATALOG_RESPONSE_INVALID` |
| `getAlternatives` | `POST /catalog/alternatives` | permanent | body catalog reference + optional style constraints | `200 CatalogSearchResult` | none | `CATALOG_REFERENCE_INVALID`, `CATALOG_QUERY_INVALID`, `CATALOG_TEMPORARILY_UNAVAILABLE`, `CATALOG_RATE_LIMITED`, `CATALOG_RESPONSE_INVALID` |
| `listBag` | `GET /bag` | permanent | cursor, limit | `200 BagCollection`; each item contains live current facts or unavailable state | none | `CATALOG_TEMPORARILY_UNAVAILABLE` only when no stored item can be rendered meaningfully |
| `addBagItem` | `POST /bag/items` | permanent | idempotency; body catalog reference + `source` + matching source ID | `200/201 BagItemSnapshot` | `bag_items`, deduplicated by stable tuple | `PRODUCT_UNAVAILABLE`, `BAG_SOURCE_INVALID`, `CATALOG_REFERENCE_INVALID` |
| `removeBagItem` | `DELETE /bag/items/{bagItemId}` | permanent | none | `204` | deletes owned row | `BAG_ITEM_NOT_FOUND` |
| `prepareRetailerHandoff` | `POST /retailer-handoffs/prepare` | permanent | body catalog reference | `200 HandoffPreview` with current retailer, price/availability disclosure, ephemeral `handoffToken`, and destination hostname—not raw URL persistence | none | `PRODUCT_UNAVAILABLE`, `RETAILER_LINK_UNAVAILABLE`, catalog errors |
| `confirmRetailerHandoff` | `POST /retailer-handoffs/confirm` | permanent | idempotency; body `{ "handoffToken": signed opaque token }` | `200 { "destinationUrl": "validated current HTTPS URL", "expiresAt": timestamp }` | `outbound_events` | `HANDOFF_TOKEN_EXPIRED`, `HANDOFF_STATE_CHANGED`, `RETAILER_LINK_UNAVAILABLE` |

`CatalogSearchInput` contains `query` (1–500), optional bounded filters (`category`, `color`, `size`, `priceMinorMax`, `country` fixed to `US`), and up to eight style-signal strings. The server translates it to Shopify's UCP `search_catalog`; `getProduct` uses `get_product`. Catalog images may be displayed from the live response but are not copied to Magic Mirror storage. Product-image transmission to OpenAI/Decart follows the explicit risk/consent gate in [integrations.md](integrations.md).

### Live styling and shared actions

Browser camera/microphone permission is client-side. A server session is created after camera permission and camera consent only. Microphone and optional visual-context consent are recorded later, only if the customer enables Gemini voice.

| operationId | Method and path | Auth | Exact input | Success | Writes | Named errors |
|---|---|---|---|---|---|---|
| `createLiveSession` | `POST /live-sessions` | permanent | idempotency; body catalog reference, optional recommendation ID, `cameraConsentRecordId` | `201 LiveSessionBootstrap` | `live_sessions` in `created`, camera consent only | `CONSENT_REQUIRED`, `PRODUCT_UNAVAILABLE`, `LIVE_SESSION_LIMIT_REACHED`, `REALTIME_UNSUPPORTED` |
| `mintRealtimeCredentials` | `POST /live-sessions/{sessionId}/credentials` | permanent | idempotency; body `RealtimeCredentialInput`: requested providers plus Gemini consent/context fields only when `gemini` is requested | `200 RealtimeCredentialBundle` with scoped ephemeral credentials and expiries | Decart may move `created/reconnecting -> connecting`; Gemini atomically records microphone/context consent; no credential/provider ID persistence | `LIVE_SESSION_NOT_FOUND`, `LIVE_SESSION_TERMINAL`, `REALTIME_PROVIDER_UNAVAILABLE`, `CONSENT_REQUIRED` |
| `transitionLiveSession` | `PATCH /live-sessions/{sessionId}` | permanent | body `LiveSessionTransitionInput` | `200 LiveSessionSnapshot` | allowed `live_sessions` state/aggregate timing only | `LIVE_TRANSITION_INVALID`, `LIVE_SESSION_TERMINAL` |
| `proposeLiveAction` | `POST /live-sessions/{sessionId}/actions` | permanent | idempotency; body `LiveActionProposal` | `200 LiveActionDecision` (`execute`, `confirm`, `reject`) | no action transcript; may return signed confirmation token | `LIVE_ACTION_INVALID`, `LIVE_ACTION_STALE`, `LIVE_ACTION_DUPLICATE`, `LIVE_ACTION_NOT_AVAILABLE` |
| `confirmLiveAction` | `POST /live-sessions/{sessionId}/actions/confirm` | permanent | idempotency; body signed token | `200 LiveActionResult` | only action-specific durable effect (bag item, selected refs, outbound event) | `LIVE_CONFIRMATION_EXPIRED`, `LIVE_ACTION_STALE`, `PRODUCT_UNAVAILABLE` |
| `endLiveSession` | `POST /live-sessions/{sessionId}/end` | permanent | idempotency; body `{ "reason": "customer" | "provider_failure" | "timeout" }` | `200 LiveSessionSnapshot` | `ended` or `failed`, aggregate timings | `LIVE_SESSION_TERMINAL` |

`RealtimeCredentialInput` is a discriminated union. `{ "providers": ["decart"] }` contains no microphone or Gemini fields. A request containing `gemini` also requires `microphoneConsentRecordId`, `geminiContextMode`, and `geminiVisualConsentRecordId`; the visual ID must be null for `structured_state` and a current granted consent for `sampled_video`. Requesting both providers uses the Gemini-bearing shape. The shared live action union and confirmation rules are exact in [events-and-states.md](events-and-states.md). `Cancel`, `pause gestures`, `keep waiting`, and changing input mode are local connection/UI controls unless they end the session or reverse a persisted bag/selection mutation.

### Account deletion

| operationId | Method and path | Auth | Exact input | Success | Writes | Named errors |
|---|---|---|---|---|---|---|
| `requestAccountDeletion` | `POST /account/deletion` | permanent | idempotency; body `{ "confirmed": true }` | `202 { "status": "requested" }` followed by client global sign-out | private deletion request, access block, purge job | `DELETION_CONFIRMATION_REQUIRED`, `ACCOUNT_DELETION_IN_PROGRESS` |

No operation restores a deletion request. Once committed, every customer table and private bucket policy fails closed while purge proceeds.

## Client-only and managed-service operations

These actions are deliberately not Magic Mirror API endpoints:

| Action | Boundary | Required behavior |
|---|---|---|
| Start anonymous session | `supabase.auth.signInAnonymously()` | Then call `createOrResumeProfile`; never use a shared guest identity |
| Google authentication | `supabase.auth.signInWithOAuth({ provider: "google" })` or `linkIdentity` only when the identity can remain on the same user | Prepare transfer first when switching owners; exact callback allowlist |
| Email magic link | `supabase.auth.signInWithOtp()` + PKCE token-hash verification/callback | Generic success response, no email enumeration; prepare transfer first |
| Upload bytes | Supabase Storage `uploadToSignedUrl(path, uploadToken, file)` | Use only the path/token pair returned by `createPhotoUploadSlot`; complete with the separate application token |
| Browser media permission | `navigator.mediaDevices.getUserMedia()` | Explain purpose before native prompt; record consent separately; denial is recoverable |
| Open email app | OS/browser mail handler | No server state change; resend uses Supabase Auth with rate limit |
| Save palette/guidance | Browser download/print/share | Uses loaded report data; no invented persistence |
| Get help | Approved support URL/mail handler from public configuration | No customer data in URL |
| Navigation, cancel transient action, keep waiting | Browser router/local state | Must not claim a durable mutation |

## Compatibility

Breaking request/response changes require a new `/api/v2` or a documented additive compatibility window. New optional response fields are additive. Enum values are append-only within this API version. Clients ignore unknown additive response fields but reject unknown request fields locally. Database and API contract versions ship together; rollback must remain compatible with additive schema changes.
