# Error Contract

- **Status:** Complete for application-contract review
- **Scope:** API, worker-to-subject normalization, managed-service and provider failures

## Wire shape

Every non-2xx Magic Mirror API response is:

```json
{
  "error": "Customer-safe summary",
  "code": "STABLE_MACHINE_CODE",
  "details": {},
  "requestId": "opaque-request-id"
}
```

All four keys are required. No extra top-level keys are allowed. `error` is safe display fallback copy, 1–240 characters. `code` is an allowlisted uppercase identifier. `details` is one of the bounded shapes below and defaults to `{}`. `requestId` is an opaque server request identifier. The browser maps `code` to approved screen copy and may use `error` only when no specific copy exists.

The envelope never contains an email, name, profile traits, answer text, photo/media bytes, storage path, signed URL, provider request/response body, prompt, transcript, product description, retailer URL, secret, token, stack, SQL, table/policy name, or cross-user existence signal.

## HTTP mapping

| HTTP | Category | Retry rule |
|---:|---|---|
| 400 | malformed/unsupported request | correct client; no automatic retry |
| 401 | missing/expired/invalid session | refresh once, then account access |
| 403 | authenticated but purpose/account/state forbidden | no automatic retry; present required consent/action |
| 404 | owned resource absent or inaccessible | do not reveal cross-user existence |
| 409 | revision, idempotency, transition, transfer, or current-state conflict | reload authoritative snapshot; explicit retry after reconciliation |
| 410 | logically expired transfer/media/action | start a new bounded flow |
| 413 | request/upload declaration too large | choose a valid file/input |
| 415 | unsupported media type | replace file |
| 422 | syntactically valid but customer-correctable domain input | show field/turn recovery |
| 429 | Magic Mirror/provider rate or cost limit | use `retryAfterMs` when present; no tight loop |
| 502 | provider returned invalid/unusable result | retry only when code says retryable |
| 503 | dependency/capability unavailable | keep persisted state and offer retry/fallback |
| 504 | bounded timeout | preserve input and show slow/retry/fallback |

## Allowed `details` shapes

Exactly one shape is selected by code; unknown keys are rejected server-side.

```json
{}

{ "field": "allowed field name", "reason": "bounded message key" }

{ "fields": [{ "field": "allowed field name", "reason": "bounded message key" }] }

{ "expectedRevision": 7, "currentRevision": 8 }

{ "retryable": true, "retryAfterMs": 2000 }

{ "stage": "allowed subject stage", "retryable": true }

{ "itemId": "owned UUID", "reason": "bounded message key" }

{ "minimum": 8, "current": 6 }

{ "allowedMethods": ["google", "magic_link"] }
```

`details` never embeds another arbitrary object. Provider-specific metadata remains server-side.

## Stable codes

### Authentication, authorization, and account

| Code | HTTP | Customer behavior |
|---|---:|---|
| `AUTH_REQUIRED` | 401 | show account access |
| `AUTH_SESSION_EXPIRED` | 401 | refresh once; then account access |
| `AUTH_METHOD_UNAVAILABLE` | 503 | offer the other approved method |
| `AUTH_CALLBACK_INVALID` | 422 | restart Google/magic-link flow |
| `AUTH_RATE_LIMITED` | 429 | wait, keep entered email local only |
| `PERMANENT_ACCOUNT_REQUIRED` | 403 | connect Google or magic link |
| `ACCESS_DENIED` | 404 | safe not-found treatment |
| `CONSENT_REQUIRED` | 403 | present exact purpose consent |
| `CONSENT_VERSION_INVALID` | 409 | reload current consent copy |
| `ACCOUNT_DELETION_IN_PROGRESS` | 403 | sign out; no product access |
| `DELETION_CONFIRMATION_REQUIRED` | 422 | require explicit confirmation |

### Profile, conversation, and concurrency

| Code | HTTP | Customer behavior |
|---|---:|---|
| `PROFILE_NOT_FOUND` | 404 | resolve resume/new report |
| `PROFILE_EXPIRED` | 410 | start a new report |
| `PROFILE_NOT_EDITABLE` | 409 | show submitted/current report |
| `PROFILE_LIMIT_REACHED` | 409 | resume existing draft |
| `PROFILE_INCOMPLETE` | 422 | show exact missing fields |
| `PROFILE_FIELD_INVALID` | 422 | ask customer to correct named field |
| `ANSWER_NEEDS_CLARIFICATION` | 422 | assistant asks one narrow follow-up |
| `BRAND_SIZE_INVALID` | 422 | correct brand/category/size tuple |
| `DUPLICATE_BRAND_CATEGORY` | 409 | edit existing tuple |
| `DEPENDENT_WORK_ALREADY_PUBLISHED` | 409 | start recalibration draft |
| `REVISION_CONFLICT` | 409 | reload snapshot and reapply explicit edit |
| `IDEMPOTENCY_KEY_REQUIRED` | 400 | client defect; do not double-submit |
| `IDEMPOTENCY_KEY_REUSED` | 409 | generate new key for changed body |

### Photo and extraction

| Code | HTTP | Customer behavior |
|---|---:|---|
| `PHOTO_LIMIT_REACHED` | 422 | remove before adding beyond 12 |
| `UPLOAD_DECLARATION_INVALID` | 422 | choose valid file |
| `UPLOAD_NOT_FOUND` | 404 | retry upload |
| `UPLOAD_SLOT_EXPIRED` | 410 | request new slot |
| `PHOTO_TYPE_UNSUPPORTED` | 415 | JPEG/PNG/WebP only |
| `PHOTO_TOO_LARGE` | 413 | choose file <=15 MiB |
| `PHOTO_DIMENSIONS_INVALID` | 422 | choose image within dimension bounds |
| `PHOTO_DECODE_FAILED` | 422 | replace corrupt/unsupported image |
| `DUPLICATE_PHOTO` | 409 | keep existing or choose another |
| `PHOTO_REJECTED` | 422 | replace only rejected photo |
| `PHOTO_NOT_FOUND` | 404 | reload gallery |
| `PHOTO_EXPIRED` | 410 | upload replacement |
| `PHOTO_DELETE_FAILED` | 503 | retain row/view and retry; never pretend removed |
| `PHOTO_NOT_RETRYABLE` | 409 | continue fallback or replace |
| `EXTRACTION_ATTEMPTS_EXHAUSTED` | 409 | continue with direct-signal fallback |
| `GARMENT_NOT_FOUND` | 404 | reload extraction summary |
| `GARMENT_REVIEW_NOT_REQUIRED` | 409 | no review mutation |
| `PHOTO_MINIMUM_NOT_MET` | 422 | show `{minimum,current}` |

### Taste and report

| Code | HTTP | Customer behavior |
|---|---:|---|
| `STYLE_EVIDENCE_INSUFFICIENT` | 422 | add/fix photos or use allowed fallback |
| `CANDIDATES_NOT_READY` | 409 | poll/retry or fallback |
| `CANDIDATE_GENERATION_FAILED` | 503 | preserve reactions; retry/fallback |
| `CANDIDATE_NOT_FOUND` | 404 | reload current candidate |
| `CANDIDATE_UNAVAILABLE` | 409 | advance to next candidate |
| `REACTION_NOT_FOUND` | 404 | no undo; reload progress |
| `REACTION_ALREADY_UNDONE` | 409 | idempotently show prior state |
| `TASTE_MINIMUM_NOT_MET` | 422 | continue until 12 active reactions |
| `REPORT_RUN_NOT_FOUND` | 404 | resolve resume |
| `REPORT_NOT_FOUND` | 404 | Style Home recovery |
| `REPORT_SECTION_NOT_FOUND` | 404 | return to report overview |
| `REPORT_ALREADY_SUCCEEDED` | 409 | open current report |
| `REPORT_NOT_RETRYABLE` | 409 | preserve inputs, support/recalibration |
| `REPORT_ATTEMPTS_EXHAUSTED` | 409 | preserve inputs, support/recalibration |
| `REPORT_GENERATION_FAILED` | 502 | retry when details.retryable |
| `REPORT_GENERATION_TIMEOUT` | 504 | preserve input; retry when allowed |
| `REPORT_OUTPUT_INVALID` | 502 | never partially publish; retry/fallback |
| `EMAIL_NOT_AVAILABLE` | 409 | keep polling/return later |
| `FEEDBACK_INVALID` | 422 | correct bounded feedback |
| `RECALIBRATION_CONFIRMATION_REQUIRED` | 422 | explicit confirm |
| `DRAFT_ALREADY_EXISTS` | 409 | resume existing draft |

### Transfer

| Code | HTTP | Customer behavior |
|---|---:|---|
| `TRANSFER_ALREADY_PREPARED` | 409 | reuse current flow |
| `TRANSFER_TOKEN_MISSING` | 410 | original-browser recovery |
| `TRANSFER_EXPIRED` | 410 | restart connection from source draft |
| `TRANSFER_REPLAYED` | 409 | resolve target resume; never retry token |
| `TRANSFER_SOURCE_CHANGED` | 409 | prepare again from latest revision |
| `TRANSFER_CONFLICT_REQUIRES_CONFIRMATION` | 409 | show both states and explicit preserve-draft choice |
| `TRANSFER_TARGET_INVALID` | 403 | sign out/restart; source remains intact |
| `TRANSFER_NOT_FOUND` | 404 | no cancellation required |

### Catalog, bag, and handoff

| Code | HTTP | Customer behavior |
|---|---:|---|
| `CATALOG_QUERY_INVALID` | 422 | correct/refine query |
| `CATALOG_TEMPORARILY_UNAVAILABLE` | 503 | retain stable refs/rationale; retry |
| `CATALOG_RATE_LIMITED` | 429 | wait; no tight retry |
| `CATALOG_RESPONSE_INVALID` | 502 | do not render/use raw result |
| `CATALOG_REFERENCE_INVALID` | 422 | reload from current product result |
| `PRODUCT_NOT_FOUND` | 404 | alternatives/close |
| `PRODUCT_UNAVAILABLE` | 409 | alternatives/remove/close |
| `VARIANT_UNAVAILABLE` | 409 | choose current option |
| `BAG_SOURCE_INVALID` | 422 | client reload/source correction |
| `BAG_ITEM_NOT_FOUND` | 404 | refresh bag |
| `RETAILER_LINK_UNAVAILABLE` | 409 | stay in Magic Mirror/alternatives |
| `HANDOFF_TOKEN_EXPIRED` | 410 | prepare current handoff again |
| `HANDOFF_STATE_CHANGED` | 409 | show updated retailer facts and reconfirm |

### Live, voice, and gesture

| Code | HTTP | Customer behavior |
|---|---:|---|
| `REALTIME_UNSUPPORTED` | 422 | report/product fallback on device |
| `REALTIME_PROVIDER_UNAVAILABLE` | 503 | retry provider or use direct/static flow |
| `LIVE_SESSION_LIMIT_REACHED` | 409 | resume/end existing session |
| `LIVE_SESSION_NOT_FOUND` | 404 | return to Style Home/recommendations |
| `LIVE_SESSION_TERMINAL` | 409 | review selections/start another |
| `LIVE_TRANSITION_INVALID` | 409 | reload session snapshot |
| `LIVE_ACTION_INVALID` | 422 | ignore unsafe/unknown proposal |
| `LIVE_ACTION_STALE` | 409 | reload current item/state |
| `LIVE_ACTION_DUPLICATE` | 409 | do not execute twice |
| `LIVE_ACTION_NOT_AVAILABLE` | 409 | direct alternative/current controls |
| `LIVE_CONFIRMATION_EXPIRED` | 410 | propose and confirm again |
| `CAMERA_PERMISSION_DENIED` | 422 | browser recovery/recommendations |
| `MICROPHONE_PERMISSION_DENIED` | 422 | direct/gesture controls |
| `VOICE_CONNECTION_FAILED` | 503 | retry voice/direct controls |
| `VOICE_REQUEST_UNCLEAR` | 422 | edit/repeat request |
| `GESTURE_LOW_CONFIDENCE` | 422 | ignored state/direct or voice alternative |
| `GESTURE_UNAVAILABLE` | 422 | direct/voice alternative |

### Generic dependency/runtime

| Code | HTTP | Customer behavior |
|---|---:|---|
| `RATE_LIMITED` | 429 | wait per bounded retry detail |
| `PROVIDER_AUTHENTICATION_FAILED` | 503 | operator action; customer fallback |
| `PROVIDER_QUOTA_EXCEEDED` | 503 | operator action; preserve state |
| `PROVIDER_TIMEOUT` | 504 | retry/fallback when permitted |
| `PROVIDER_RESPONSE_INVALID` | 502 | do not expose/persist raw output |
| `SERVICE_UNAVAILABLE` | 503 | retain state and retry later |
| `INTERNAL_ERROR` | 500 | safe generic message + request ID; no silent failure |

## Worker failure projection

Worker/provider failures are stored only in the exact data-contract safe error shapes. A worker maps its `job_kind` + stage + provider category into a subject error code above. The browser reads the subject projection, never `private.processing_jobs`. Unknown provider errors become `PROVIDER_RESPONSE_INVALID` or `INTERNAL_ERROR` with `retryable=false` until deliberately classified; they are never assumed safe to retry.

## Logging and support

Server logs include request/job ID, route/capability, status, duration, attempt, provider, normalized code, and a one-way owner pseudonym only when correlation is necessary. Customer support can ask for `requestId`; no customer is asked to share tokens, signed URLs, or photos to diagnose a contract error.
