# External Integration Contract

- **Status:** Complete for application-contract review
- **Rule:** Every external response is untrusted until parsed through a provider-specific Zod schema
- **Browser secrets:** none; only scoped, short-lived Decart/Gemini credentials may reach an owned live session

This contract fixes what Magic Mirror sends, receives, persists, times out, retries, and shows when each provider fails. Provider model names are server configuration with startup validation so a provider retirement does not require changing the browser API. Changing a normalized result shape does require a contract version.

## Provider matrix

| Boundary | Purpose | Caller | Permanent credential | User-visible fallback |
|---|---|---|---|---|
| Supabase Auth/Postgres/Storage | identity, relational authority, private media | browser + API + worker | publishable key in browser; server key only API/worker | mutations stop safely; persisted state remains |
| OpenAI Responses API | conversational fact parsing, photo/style analysis, structured report | API for short parse; worker for durable work | server/worker only | deterministic field clarification, direct style signals, retryable report failure |
| OpenAI Images API | garment cutout and customer-likeness wardrobe previews | worker only | worker only | no preview; keep text and live product link |
| Shopify Global Catalog MCP/UCP | cross-retailer discovery and current product/offer facts | API + worker | keyless; public Magic Mirror UCP agent profile URL | permitted fixture for narrow demo, or unavailable/retry state |
| Decart Lucy VTON | realtime garment visualization | browser with client token | permanent key only API | static recommendation/preview and direct product actions |
| Google Gemini Live | realtime voice and optional visual/session context | browser with ephemeral token | permanent key only API | direct and gesture controls; voice reconnect/retry |
| Resend | report-ready notice; Supabase custom SMTP | worker and Supabase Auth | server/provider configuration only | report remains available; notice retries |

## Supabase

### Contract

- Project: `vhpxxmefcuewkmukissr`, region `us-east-1`.
- Browser configuration: `VITE_SUPABASE_URL`, `VITE_SUPABASE_PUBLISHABLE_KEY`.
- Server configuration: `SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY` (or the current equivalent server secret selected at implementation); never a `VITE_` name.
- Browser Auth uses anonymous, Google OAuth, and email magic link only, as defined in [auth.md](auth.md).
- Browser Storage writes only server-issued immutable slots in `customer-photos`. Private reads are authenticated or short-lived signed URLs after relational checks.
- API/worker calls use explicit schema/table names, bounded selects, and the smallest privilege. Service-role use never substitutes for an ownership check.

### Failure normalization

Auth, PostgREST, and Storage errors are mapped by stable Supabase code/status when available and by operation otherwise. Raw messages are server-log debug fields only after redaction; the browser receives `AUTH_*`, `DATA_*`, or `STORAGE_*` errors from [errors.md](errors.md). A Supabase outage prevents provider work whose result cannot be persisted.

## OpenAI text and vision

### API behavior

Use the official TypeScript SDK and the Responses API from the server/worker. Default server configuration names:

```text
OPENAI_API_KEY
OPENAI_TEXT_MODEL=gpt-5.6
OPENAI_VISION_MODEL=gpt-5.6
OPENAI_REQUEST_TIMEOUT_MS=90000
```

The implementation ticket must re-list available models and make one minimal paid request before dependent work because the current verified key has `insufficient_quota`. Model configuration is allowlisted at startup; it cannot be supplied by a customer.

Every request:

- sets `store: false`;
- uses strict JSON Schema structured output for facts, photo signals, extracted garment metadata, report sections, and action-independent catalog queries;
- sends only the minimum owned inputs needed for the named purpose;
- uses no background mode, OpenAI-hosted durable conversation, assistant/thread, vector store, remote MCP, code interpreter, or arbitrary function tool;
- includes no email, Supabase ID, storage path, signed URL after dereference, transfer token, retailer URL, or permanent credential;
- never persists a raw response or OpenAI response ID as product authority;
- treats refusal, incomplete response, schema mismatch, safety rejection, timeout, quota, and rate limit as distinct normalized outcomes.

The API downloads an owned private image server-side and supplies bounded image input bytes or a request-scoped URL that expires after the provider request. Input images may be subject to provider safety scanning; consent copy must not promise instantaneous provider erasure. Prompt text delimits customer/catalog content as untrusted data and exposes no arbitrary I/O tools.

### Normalized operations

| Adapter operation | Input | Exact accepted output | Deadline/retry | Persistence/fallback |
|---|---|---|---|---|
| `parseProfileAnswer` | target field, text <=500, locale, allowed unit context | `{ accepted, normalizedValue, displayValue, clarificationQuestion?, confidence }` | 15s; one safe retry only before a response | Store only accepted profile value; deterministic clarification fallback |
| `analyzeFavoriteLook` | one accepted photo; bounded profile context | `PhotoStyleSignal` plus 0–20 `GarmentDetection` records | 60s/photo; max two worker attempts | Store parsed signals; per-photo failure preserved |
| `generateTasteSeedDescriptors` | bounded signals/garments + profile | 12–20 bounded candidate descriptors and balance tags | 45s; max two worker attempts | Balanced curated fallback if slow/fails |
| `generateStyleReport` | frozen profile revision, sizes, bounded aggregate signals/reactions | exact overview/color/body-style sections plus recommendation intents | worker attempt below 120s product target; max two attempts per run | Atomic publish only if entire schema and policy checks pass |

The report prompt uses `gender` exactly as customer-provided styling context and never diagnoses body, health, or identity. Kibbe-informed output is explicitly interpretive. Conversation fact parsing is not a general text agent and cannot mutate anything except the named field after application validation.

## Wardrobe-inspired extraction and OpenAI images

`tandpfun/wardrobe` is an MIT-licensed design/reference implementation, not an external hosted provider and not a runtime data authority. Magic Mirror may reuse the proven two-stage idea—detect garments with Responses, then create clean cutouts with the Images API—only after the readiness spike records repository/version provenance, latency, failure behavior, and any adapted code. It does not import Wardrobe's local JSON database or filesystem contract into the product.

Default image configuration names:

```text
OPENAI_IMAGE_MODEL=gpt-image-2
OPENAI_IMAGE_QUALITY=high
OPENAI_IMAGE_TIMEOUT_MS=90000
```

| Adapter operation | Inputs | Output gate | Stored result | Fallback |
|---|---|---|---|---|
| `extractGarmentCutout` | owned source photo, exact detected garment box/description | one garment on plain background; category/color/pattern agreement; no added logo/person; decode + dimensions + safety | private `garment_cutout`, lineage, parsed metadata | keep direct photo signals and mark partial/failed; report path continues |
| `generateWardrobePreview` | consented customer photo(s), one current Shopify product image, bounded recommendation direction | likeness recognizable, garment materially faithful, no harmful artifact, one approved size/format, disclosure attached | private `wardrobe_preview`, exact consent and photo/catalog lineage | text recommendation + current product card/link |
| `generateTryOnStill` | consented customer photo + one permitted garment image | same likeness/garment gate | private `tryon_still` only when a feature ticket needs it | live/static product view |

Image output bytes are decoded, MIME/dimensions/size/hash checked, quality-reviewed by deterministic checks plus the approved spike rubric, then stored privately. A rejected generation has no readable object path. Generated images expire within 30 days and are deleted sooner on consent revocation/account deletion.

The founder accepted unresolved hackathon risk for transmitting Shopify product images to OpenAI/Decart. `catalog_image_transmitted=true` records that transmission; it does not claim merchant authorization. The application labels previews as visualizations and never claims retailer endorsement.

## Shopify Global Catalog MCP/UCP

### Transport

- Endpoint: `POST https://catalog.shopify.com/api/ucp/mcp`.
- Protocol: JSON-RPC 2.0 MCP tool calls conforming to UCP Catalog.
- Authentication: keyless.
- Every request includes `meta.ucp-agent.profile = SHOPIFY_AGENT_PROFILE_URL`, an HTTPS public URL advertising only implemented capabilities.
- Buyer context is U.S. (`address_country=US`) for the hackathon.
- Use `search_catalog` for text/image/similar-item discovery, `lookup_catalog` for known IDs, and `get_product` for current product details, option selection, availability, offers, and checkout links.

### Normalized schemas

`ShopifyCatalogProduct` accepts only bounded current facts required by the UI:

```json
{
  "productRef": "stable UCP/Shopify identifier",
  "shopRef": "stable seller/shop identifier",
  "variantRef": "stable variant identifier or null",
  "title": "1-200",
  "sellerName": "1-160",
  "description": "0-2000, escaped",
  "price": { "amountMinor": 0, "currency": "USD" },
  "availability": "available | unavailable | unknown",
  "options": [],
  "media": [{ "url": "https", "alt": "0-300" }],
  "checkoutUrl": "https or null",
  "observedAt": "timestamp"
}
```

Unknown/oversized fields are dropped before rendering or provider use. URLs must be HTTPS and originate from the validated provider response; Magic Mirror does not server-fetch arbitrary customer URLs.

### Freshness and persistence

- Search results are request state only.
- Taste candidates, recommendations, and bag rows store only stable product/shop/variant references and Magic Mirror rationale.
- Title, seller, description, price, inventory, media, option availability, and checkout URL are refreshed live before display or action and are never database authority.
- A product shown earlier may become unavailable. The UI renders the explicit unavailable screen and alternatives; it never silently opens a stale checkout link.
- `prepareRetailerHandoff` performs `get_product`; `confirmRetailerHandoff` accepts only a short-lived signed snapshot token and rejects state changes.

### Limits and recovery

Provider deadline is 8 seconds with one jittered retry for a safe transient transport/5xx failure. Do not automatically retry invalid arguments, rate limits, or unavailable products. Normalize MCP/JSON-RPC errors and schema failures; raw responses never reach the browser/log. If Global Catalog is unavailable, existing recommendation rationale and bag identity remain visible with live facts marked unavailable. The narrow demo may use an explicitly permitted garment fixture but cannot portray it as a live cross-retailer result.

## Decart Lucy VTON

### Transport and credentials

Use the official JavaScript SDK with realtime model configuration `lucy-vton-latest` (server-controlled). The API creates a Decart client token using the permanent `DECART_API_KEY`; only that client token reaches the browser. Current client-token TTL is 10 minutes; mint one per owned live session and never persist it. The browser connects its camera stream directly to Decart over the SDK/WebRTC.

### Session contract

- Required input: customer camera video, one garment reference image, and a specific 20–30 word substitute/add prompt derived from validated product facts.
- Reference images are JPEG/PNG/WebP, preferably clean/plain and at least 512×512.
- Exactly one garment change is requested at a time.
- `set()` replaces the complete Decart state; every state change resends all intended prompt/image/enhance fields so an omitted field is not accidentally cleared.
- Dynamic item change uses `set()` without reconnecting. UI state remains `changing` until a new remote frame or provider acknowledgment passes the action sequence guard.
- Live video is displayed, not recorded or persisted. Decart identifiers stored in `live_sessions` are non-secret diagnostics only.

The catalog image is fetched only from the current validated Shopify response and transmitted under the founder-accepted hackathon risk. If the source shows a person and the extraction gate is available, use the approved garment cutout; otherwise disclose degraded fidelity or do not start the live try-on.

### Failure contract

Token mint deadline is 10 seconds with one safe retry. Connection, first frame, update, and reconnect have measured ticket thresholds; no invented provider guarantee is exposed. Credential, unsupported device/category, transport, timeout, content, and provider-capacity failures normalize separately. Decart failure leaves report/product data, static previews, bag, and direct catalog actions available.

## Google Gemini Live

### Transport and credentials

Use the official `@google/genai` client and Live API client-to-server WebSocket with a server-minted ephemeral token. Permanent `GEMINI_API_KEY` remains server-side. The token is single-use for starting a session, constrained to the configured live model, response modality, tool allowlist, and context mode; use the shortest practical new-session and connection expiry. Token minting uses the current `v1alpha` ephemeral-token service.

Default server configuration names:

```text
GEMINI_LIVE_MODEL=gemini-3.1-flash-live-preview
GEMINI_CONTEXT_MODE=structured_state
GEMINI_TOKEN_TIMEOUT_MS=10000
```

The dual-realtime spike may set `GEMINI_CONTEXT_MODE=sampled_video` only when CPU, bandwidth, echo, action latency, consent, and benefit pass the approved bar. `structured_state` sends the current selected catalog references, safe display labels, visible result set identifiers, live state, bag state, and last completed action—never storage paths, report body, email, or raw customer profile.

### Media and tool contract

- Audio input and native audio output are realtime session data and are not recorded or persisted by Magic Mirror.
- Video/screen frames are sent only when `gemini_visual_context` latest consent is granted and session configuration says `sampled_video`; camera consent alone is insufficient.
- Current documented audio+video Live sessions are limited to two minutes before session management/resumption is required. The client implements provider-supported session resumption or transparently re-mints without losing Magic Mirror's persisted live-session state.
- Gemini receives only the function declarations in the shared `LiveAction` union. It proposes function calls; it never executes a database/provider mutation directly.
- The client parses each function call, supplies a tool response manually, and routes the proposal through `proposeLiveAction`.
- Consequential proposals require customer confirmation. Unknown tools/arguments, stale sequences, or out-of-context item references are rejected.

Gemini outage/reconnect never ends Decart automatically. Direct controls remain; gesture remains when local confidence is adequate. No transcript or raw Gemini payload is stored.

## Resend

Supabase Auth uses the configured custom SMTP for magic links. The Magic Mirror worker uses the Resend SDK/API only for a report-ready notice.

- Server configuration: `EMAIL_DELIVERY_API_KEY`, `EMAIL_FROM_ADDRESS` (deployed value `Magic Mirror <magicmirror@thecrownlist.com>`).
- The worker resolves the current account email from Supabase Auth at send time; it never copies it into product tables or the job payload.
- Email contains no photos, report findings, measurements, products, signed URLs, or sensitive preview. It contains a generic ready message and exact `APP_BASE_URL` destination.
- `notification_deliveries.idempotency_key` prevents duplicate notices.
- Deadline 10 seconds; durable bounded retry; provider message reference stored only on success.
- Email failure does not change the completed report and is shown only as a non-blocking notification status.

## Provider error normalization and observability

Provider adapters return either a parsed normalized result or a `ProviderFailure`:

```json
{
  "provider": "openai | shopify | decart | gemini | resend | supabase",
  "category": "authentication | quota | rate_limit | timeout | unavailable | invalid_request | content_rejected | schema_invalid | transport | unknown",
  "retryable": false,
  "operation": "bounded adapter operation",
  "providerRequestRef": "opaque ref or null"
}
```

Only provider, category, retryability, bounded operation, latency, and an opaque non-secret reference may enter operational logs. The browser receives the mapped product error. Raw body/message, prompt, output, product description/URL, media, transcript, token, and customer identifiers are excluded.

## Official references checked 2026-07-20

- [OpenAI developer quickstart and Responses image input](https://platform.openai.com/docs/quickstart/make-your-first-api-request)
- [OpenAI Responses structured-output API reference](https://platform.openai.com/docs/api-reference/responses-streaming/response/output_item/done)
- [OpenAI image streaming/output reference](https://platform.openai.com/docs/api-reference/images-streaming/image_generation/partial_image)
- [OpenAI data controls by endpoint](https://platform.openai.com/docs/models/default-usage-policies-by-endpoint)
- [Shopify Global Catalog MCP](https://shopify.dev/docs/agents/catalog/global-catalog)
- [Decart Lucy Virtual Try-On](https://docs.platform.decart.ai/models/realtime/virtual-try-on)
- [Gemini Live capabilities](https://ai.google.dev/gemini-api/docs/live-api/capabilities)
- [Gemini ephemeral tokens](https://ai.google.dev/gemini-api/docs/live-api/ephemeral-tokens)
- [Gemini Live tool use](https://ai.google.dev/gemini-api/docs/live-api/tools)
- [Resend Node.js/Bun sending guide](https://resend.com/docs/send-with-nodejs)
- [Wardrobe reference repository](https://github.com/tandpfun/wardrobe)
- [Supabase passwordless email](https://supabase.com/docs/guides/auth/auth-email-passwordless)
- [Supabase private bucket access](https://supabase.com/docs/guides/storage/buckets/fundamentals)
