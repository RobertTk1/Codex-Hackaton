# Critical Runtime Flows

The diagrams below fix system responsibilities and recovery behavior. Exact HTTP payloads, database enums, and timeout constants belong to later contract steps.

## Anonymous start and profile persistence

```mermaid
sequenceDiagram
  actor Customer
  participant Web
  participant Auth as Supabase Auth
  participant API
  participant DB as Postgres

  Customer->>Web: Start style report
  Web->>Auth: Create anonymous session
  Auth-->>Web: User JWT
  Web->>API: Create or resume profile
  API->>Auth: Verify JWT
  API->>DB: Upsert owned draft
  DB-->>API: Profile + current step
  API-->>Web: Validated progress
  loop One conversational answer at a time
    Customer->>Web: Answer
    Web->>API: Save typed answer + profile revision
    API->>DB: Validate ownership and persist
    DB-->>Web: New revision + next required field
  end
```

The visual transcript is not durable authority. Each accepted answer writes the same profile contract used by the archived form presentation. A lost browser can resume from persisted progress after session recovery.

## Photo upload, garment extraction, and taste calibration

```mermaid
sequenceDiagram
  actor Customer
  participant Web
  participant Storage as Private Storage
  participant API
  participant DB as Postgres
  participant Worker
  participant OpenAI

  Customer->>Web: Select 8-12 photos
  Web->>Web: Local type/size preview checks
  Web->>Storage: Upload to owned private paths
  Storage-->>Web: Object references
  Web->>API: Complete upload batch
  API->>DB: Verify owner and create photo rows
  API->>DB: Enqueue one extraction job per photo
  API-->>Web: Batch accepted + status URL
  Worker->>DB: Atomically lease due extraction job
  Worker->>Storage: Read short-lived owned object
  Worker->>OpenAI: Detect garments / create cutout
  OpenAI-->>Worker: Untrusted structured result / image
  Worker->>Worker: Zod parse and quality checks
  Worker->>Storage: Store accepted derived asset
  Worker->>DB: Persist signals or normalized failure
  Web->>API: Poll batch status
  API-->>Web: Success, partial success, or retryable failure
  Web->>API: Request taste candidates
  API->>DB: Combine extracted garments + profile signals
  API-->>Web: Balanced candidates or curated fallback
```

Each photo fails independently. Partial extraction never discards successful photos and never blocks the report when the minimum direct photo/style signals remain usable. The customer sees failed photos and may retry or continue with an explicit lower-confidence disclosure. If the Wardrobe-inspired spike fails its quality/latency bar, the worker records coarse direct style signals and taste calibration uses the balanced curated fallback.

## Anonymous-to-permanent account connection

```mermaid
sequenceDiagram
  actor Customer
  participant Web
  participant API
  participant Auth as Supabase Auth
  participant DB as Postgres

  Web->>API: Prepare account transfer
  API->>DB: Store hashed one-use transfer token, owner, expiry, profile revision
  API-->>Web: Opaque transfer token
  alt Google or magic link creates/links the same anonymous identity
    Web->>Auth: Connect identity
    Auth-->>Web: Permanent session
    Web->>API: Finalize transfer
    API->>DB: Verify token + ownership; mark connected
  else Email already belongs to another account
    Web->>Auth: Authenticate existing account
    Auth-->>Web: Existing-account session
    Web->>API: Claim anonymous draft with token
    API->>DB: Transactionally copy/merge draft into existing owner
  end
  DB-->>API: Claimed profile + conflicts
  API-->>Web: Resume latest safe step
```

The opaque token is short-lived, single-use, stored only as a hash, and bound to the anonymous owner and profile revision. An existing permanent profile is never silently overwritten. Conflicting drafts remain explicit and the source anonymous draft becomes inaccessible after a successful transaction.

## Durable report generation and previews

```mermaid
sequenceDiagram
  actor Customer
  participant Web
  participant API
  participant DB as Postgres
  participant Worker
  participant OpenAI
  participant Shopify
  participant Storage
  participant Resend

  Customer->>Web: Generate my report
  Web->>API: Submit completed profile revision
  API->>DB: Create idempotent report run + job
  API-->>Web: Processing state + run ID
  Worker->>DB: Lease report job
  Worker->>OpenAI: Structured report request
  OpenAI-->>Worker: Untrusted report output
  Worker->>Worker: Full Zod parse and safety/quality checks
  Worker->>Shopify: Find/refresh matching live products
  Shopify-->>Worker: Current product references and facts
  Worker->>DB: Commit immutable report version + stable refs
  opt Catalog image use is allowed and preview quality passes
    Worker->>OpenAI: Generate customer-likeness preview
    OpenAI-->>Worker: Preview image
    Worker->>Storage: Store derived preview privately
    Worker->>DB: Attach accepted asset lineage
  end
  Worker->>Resend: Send non-sensitive report-ready notice
  Web->>API: Poll/refresh run
  API-->>Web: Completed report or normalized state
```

Submitting the same profile revision returns the same active or completed run. The browser shows normal processing, slow, retryable failure, and terminal failure states; it does not hold the request open for two minutes. Preview failure degrades to text plus live product cards. Invalid report output does not partially publish. Retries reuse the idempotency key and never duplicate a completed report or email event.

## Live try-on, voice, and gesture

```mermaid
sequenceDiagram
  actor Customer
  participant Web
  participant API
  participant Decart
  participant Gemini

  Customer->>Web: Start live styling
  Web->>API: Create owned live session
  API-->>Web: Session + short-lived Decart/Gemini credentials
  par Independent realtime connections
    Web->>Decart: WebRTC camera + selected garment
    Decart-->>Web: Transformed video
  and
    Web->>Gemini: Live audio + structured session state
    Gemini-->>Web: Typed function-call proposal
  and Local gesture recognition
    Web->>Web: Camera frame to local recognizer
    Web->>Web: Typed gesture proposal
  end
  Web->>Web: Normalize proposal as LiveAction
  alt Consequential action
    Web->>Customer: Confirm action
    Customer->>Web: Confirm
  end
  Web->>Web: Reject duplicate/stale sequence
  Web->>Decart: Apply selected item/change
  Web->>API: Persist selection or bag event
```

Direct buttons, Gemini function calls, and recognized gestures share one dispatcher. Gesture detection proposes rather than directly executes actions. Decart and Gemini reconnect independently; loss of either leaves direct controls and persisted selections available. The dual-realtime spike determines whether structured state is sufficient for Gemini or whether consented video/screen frames materially improve the experience within device, bandwidth, echo, and latency limits.

## Retailer handoff

```mermaid
sequenceDiagram
  actor Customer
  participant Web
  participant API
  participant Shopify
  participant DB as Postgres
  participant Retailer

  Customer->>Web: Open retailer
  Web->>API: Refresh stable product/variant reference
  API->>Shopify: Get current offer
  Shopify-->>API: Current availability, seller, price, URL
  API-->>Web: Validated handoff details
  Web->>Customer: Confirm external retailer boundary
  Customer->>Web: Continue
  Web->>API: Record non-sensitive outbound event
  Web->>Retailer: Open current product URL
```

If refresh fails or the offer is unavailable, Magic Mirror does not open a stale link silently; it offers another recommendation or a retry. Checkout remains entirely with the retailer.

## Durable processing state

```mermaid
stateDiagram-v2
  [*] --> queued
  queued --> leased: worker claim
  leased --> succeeded: validated result committed
  leased --> retry_wait: retryable provider/runtime failure
  retry_wait --> queued: available_at reached
  leased --> failed: non-retryable or attempts exhausted
  leased --> queued: lease expired before commit
  queued --> cancelled: source deleted or superseded
  retry_wait --> cancelled: source deleted or superseded
  succeeded --> [*]
  failed --> [*]
  cancelled --> [*]
```

Workers heartbeat long tasks and commit the output and terminal job state transactionally when practical. A stale lease is recoverable; the user-visible subject record remains the source for current status.
