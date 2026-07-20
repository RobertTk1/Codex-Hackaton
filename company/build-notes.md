# Magic Mirror — Build Notes

Status: Engineering-plan input  
Last updated: 2026-07-19  
Purpose: Preserve founder-requested implementation context for the amended build plan and the future engineering plan. These are product and integration notes, not completed implementation or proof that a provider meets production requirements.

## Preferred service roles

| Product responsibility | Preferred service or reference | Intended role |
| --- | --- | --- |
| Core stylist agent and chat onboarding | OpenAI Responses API, with the Agents SDK considered if its managed loop, sessions, tracing, or guardrails materially reduce implementation work | Interpret user messages and images, ask adaptive follow-up questions, produce validated structured profile data, call product-search and application tools, and generate the style-report narrative. Do not hardcode a model until engineering planning checks current capability, latency, and cost. |
| Generated and edited still images | OpenAI image generation through the Image API or the Responses API image-generation tool | Create or edit still imagery, including garment cutouts and approved style-report wardrobe previews. Report previews may compose the customer’s likeness with real catalog products only if product-image reuse is permitted; otherwise the report falls back to text and linked product recommendations. |
| Live conversational voice and session awareness | Google Gemini Live API | Run the low-latency styling assistant with bidirectional audio, text, video-frame input, native audio output, and tool calls. Evaluate raw video/screen context against lower-cost structured session state; use short-lived client credentials and never expose a permanent credential. |
| Live virtual try-on video | Decart Lucy VTON realtime | Transform the live camera stream using a selected garment reference image plus a specific garment prompt. Use server-created short-lived Decart client tokens rather than a permanent browser key. |
| Cross-retailer product discovery | Shopify Global Catalog MCP / Catalog API with UCP catalog tools | Search Shopify’s global structured catalog across merchants, cluster equivalent products and seller offers, resolve current variants and checkout links, and preserve the retailer-handoff boundary rather than building Magic Mirror checkout. Use Storefront Catalog MCP only when a request is intentionally scoped to one merchant. |
| Favorite-look garment extraction and wardrobe UX reference | [`tandpfun/wardrobe`](https://github.com/tandpfun/wardrobe) | Core pre-report pipeline step immediately after the 8–12-photo upload: detect, cut out, and deduplicate garments that seed the style profile and dynamic taste candidates. The repository is the intended implementation input but must pass the readiness spike before code reuse; the fallback is direct favorite-look/style-signal analysis so report delivery does not block. |

## Founder-constrained application stack

- Frontend: TypeScript with Vite, Tailwind, and Bun.
- API layer: TypeScript.
- Data, authentication, and private asset storage: Supabase.
- These are founder constraints for the engineering plan, not open framework or platform choices. Engineering planning still owns the minimal application boundaries, secure environment setup, and evidence that the chosen stack supports the approved product behavior.

## Proposed application flow

1. The customer starts anonymously and answers the chat-first onboarding questions. Required values are saved as structured profile state after validation.
2. The customer uploads 8–12 favorite-look photos. The original photos pass file, safety, quality, ownership, and privacy checks before analysis.
3. After photo-quality review, the Wardrobe-inspired extraction step identifies visible garments, likely category, color, material, pattern, and fit signals. Duplicate sightings are grouped rather than creating a separate item for every photograph.
4. Extraction runs before taste calibration and seeds the initial style profile and candidate-look generation. Per-image work may run concurrently, but taste calibration does not begin until enough usable extraction/style evidence or the approved fallback exists.
5. The extraction spike decides whether a customer review is required. If required, add a lightweight chat turn where the customer can approve, merge duplicates, rename, correct, remove, or retry items. If extraction partially fails, preserve successful items and continue with direct favorite-look/style-signal analysis for failed images.
6. When a garment is worn by a person or obscured by another layer, OpenAI image editing may reconstruct a clean standalone garment cutout. The UI must present this as a generated reconstruction, not a literal product photograph.
7. The style report uses the customer’s answers, favorite-look analysis, extracted garment signals, and taste reactions. Its recommendations may include OpenAI-generated wardrobe preview images that compose the customer’s likeness with real Shopify Global Catalog products and link to the current retailer pages, but only after product-image reuse rights and likeness-safety quality are approved. The failure or policy fallback is text and linked product recommendations with no generated preview.
8. From the report or Style Home, the stylist agent translates the customer’s request into a multimodal Global Catalog query. It can combine the customer’s words with an approved look or garment reference, search across Shopify merchants, rank clustered products and seller offers using profile constraints, then fetch current variant, availability, seller, and checkout-link details.
9. The customer opens live styling. Decart renders the selected garment on the camera stream while Gemini Live handles voice, optional video/screen context, tool calls, and conversational state. The spike must compare raw video-frame context with structured session state such as selected item, visible results, report signals, and current action. Voice, gesture, and direct controls all call the same application actions.
10. Selecting a product saves its normalized product/variant reference and sends the customer to the retailer for checkout.

## Provider-specific build notes

### OpenAI

- Use the Responses API when Magic Mirror should own the agent loop, application branching, tool execution, and validated data writes. Consider the Agents SDK only if its managed loop, sessions, tracing, guardrails, or resumable flows provide concrete value; do not introduce both abstractions without a demonstrated need.
- Treat model responses as untrusted external data. Structured profile answers, extracted garment attributes, search intent, and tool arguments must be parsed through Zod before use.
- Keep deterministic application state outside the model transcript. The transcript is a user-facing interaction history, not the source of truth for profile completeness, account ownership, product identity, or try-on session status.
- Use the Image API for isolated generation/edit tasks. Use the Responses image-generation tool where the customer or agent needs multi-turn visual refinement with image context.
- Do not lock a specific OpenAI model name in the engineering plan until implementation begins; verify the current supported models, tool compatibility, latency, organization verification requirements, and cost at that time.

Official references: [Agents and Responses API](https://developers.openai.com/api/docs/guides/agents) and [image generation](https://developers.openai.com/api/docs/guides/image-generation).

### Google Gemini Live API

- Gemini Live is the preferred live voice provider. OpenAI remains preferred for the text agent, report generation, and approved still-image generation/editing.
- Gemini Live supports bidirectional audio, text, video-frame input, native audio output, and function calling over a persistent connection. Current official guidance documents video as image frames at up to 1 FPS rather than a full-rate video stream.
- Compare two context modes in the dual-realtime spike: raw camera/screen frames and structured session state containing the selected item, visible results, report signals, pending confirmation, and current live-session status. Use the least sensitive and least resource-intensive mode that preserves useful voice behavior.
- For client-to-server use, issue short-lived Gemini credentials from a trusted server. Never ship a permanent Google API key in the browser.
- Account for session limits and resumption. Current official guidance documents short default audio-video session limits without context compression and periodic connection resets; the demo must prove resumption or a bounded session design.
- Gemini function calls must converge on the same typed application commands used by gesture and direct controls. Confirm add-to-bag, retailer handoff, and session end before action.

Official references: [Live API overview](https://ai.google.dev/gemini-api/docs/live-api), [capabilities](https://ai.google.dev/gemini-api/docs/live-api/capabilities), [ephemeral tokens](https://ai.google.dev/gemini-api/docs/live-api/ephemeral-tokens), [session management](https://ai.google.dev/gemini-api/docs/live-api/session-management), and [tool use](https://ai.google.dev/gemini-api/docs/live-api/tools).

### Decart realtime virtual try-on

- Use the official JavaScript SDK and the `lucy-vton-latest` realtime alias during initial integration, then pin a tested model version for the demo if alias drift would create risk.
- Provide both a clean garment reference and a specific 20–30-word `Substitute` or `Add` prompt when possible. Decart recommends isolated garments on plain backgrounds at 512×512 or larger.
- Decart recommends one garment per prompt. Multi-garment outfit switching therefore needs either sequential state changes or explicit provider testing; do not assume a full layered look will behave reliably.
- `set()` replaces the entire Decart state. Every update must resend every field that should remain active.
- Create a short-lived Decart client token on the server for each live session. The documented token TTL is 10 minutes, while an already-connected WebRTC session can continue after token expiry.
- Normalize connection, permission, timeout, slow-stream, model, and disconnect errors into explicit application states. The user must always retain direct controls and a recoverable non-video path.

Official reference: [Decart realtime virtual try-on](https://docs.platform.decart.ai/models/realtime/virtual-try-on).

### Shopify product search and retailer handoff

- Use **Global Catalog MCP** for Magic Mirror’s default cross-retailer discovery. Shopify documents one global endpoint, `https://catalog.shopify.com/api/ucp/mcp`, that searches eligible products across Shopify merchants. Use the per-store endpoint only when the customer or agent intentionally limits a request to one retailer.
- Global Catalog MCP and Storefront Catalog MCP expose the same UCP tools—`search_catalog`, `lookup_catalog`, and `get_product`—but differ in scope. The global search clusters equivalent listings by Universal Product ID (UPID) and can return offers from multiple merchants.
- Product discovery is a two-step flow: search or lookup first, then call `get_product` after selection to refresh option combinations, availability, price, sellers, and checkout links.
- Global `search_catalog` supports natural-language text, image similarity, and multimodal text-plus-image queries. This is especially relevant to Magic Mirror: an approved favorite-look crop or user-owned garment can provide visual context while the style profile contributes intent such as category, color, fit, occasion, size, price, and shipping destination.
- Use Global Catalog filters for sale readiness, shipping destination, condition, price, shops, and Shopify taxonomy where supported. Consider a Saved Catalog configuration to constrain Magic Mirror to apparel/accessories and the demo geography without losing cross-merchant discovery.
- Base Global Catalog MCP access requires a hosted UCP agent profile on every request. Current Shopify documentation lists keyless access for the MCP endpoint; an authenticated API key and Dev Dashboard relationship may be needed for higher rate limits or Catalog API capabilities. Keep those two access paths distinct in the engineering plan.
- Pass only disclosed buyer context needed for relevance or localization. Shop-linked personalized search is a separate capability and should not be assumed available for the hackathon flow without checking its current access status.
- Do **not** cache Catalog search results or product images. Shopify requires results to stay fresh and product images to be rendered in real time with the related listing rather than downloaded to Magic Mirror servers. Save stable product/variant/UPID references and user actions, then refresh live catalog data before display or retailer handoff.
- Do not assume a Shopify Catalog image can be sent to Decart or OpenAI image generation. Either use would move the image outside its related product listing under the current Catalog usage guidance. Confirm a permitted image path or merchant authorization for both generated report previews and Decart; otherwise use text/linked recommendations in the report and user-owned/approved garment cutouts for live try-on.
- Keep checkout on the retailer side for the approved Magic Mirror scope. Global `get_product` supplies seller checkout links; UCP cart and checkout capabilities can remain outside the hackathon unless the product boundary changes.
- The Spring ’26 reference apps demonstrate the intended model: **All Set** makes contextual apparel recommendations from products across millions of merchants, while **Sourced** turns an uploaded image into visually similar cross-catalog product matches. Those are closer architectural references for Magic Mirror than a single-store storefront agent.

Official references: [Shopify Catalog interfaces](https://shopify.dev/docs/agents/catalog), [Global Catalog MCP](https://shopify.dev/docs/agents/catalog/global-catalog), [Spring ’26 developer announcement](https://www.shopify.com/news/spring-26-edition-dev), and [five Catalog API/UCP example apps](https://www.shopify.com/news/spring-26-edition-design).

### Wardrobe-inspired extraction

The core integration point begins immediately after favorite-look photo quality review and before taste calibration. The repository demonstrates a compatible sequence: detect garments, generate clean cutouts, deduplicate items, review/regenerate results, and approve them into a wardrobe library. The spike must decide whether customer confirmation is required before taste calibration and prove a non-blocking fallback for full or partial extraction failure.

Use or adapt:

- garment detection across multi-item outfit photographs;
- source-photo-to-item traceability;
- clean cutout generation;
- duplicate grouping and comparison;
- drag/drop/paste upload affordances;
- review, correction, regeneration, and approval states; and
- the visual wardrobe grid/editor as UI inspiration.

Do not automatically adopt:

- its local `data/` storage model;
- its complete application shell or branding;
- a requirement for a separate model-reference photo;
- its modeled editorial-preview flow, because Decart owns live try-on here; or
- its model defaults without a fresh OpenAI capability and cost check.

Before reusing code, identify the smallest useful MIT-licensed modules, preserve required license notices, and replace local persistence with Magic Mirror’s authenticated Supabase/storage boundaries.

## Concurrent realtime systems

Live styling combines two independent low-latency systems:

- Decart WebRTC carries the camera input and transformed try-on video.
- Gemini Live carries assistant audio, text/transcript events, optional video/screen frames, and tool calls.
- Gesture recognition observes the camera stream or derived frames and proposes supported actions.

The engineering plan must explicitly cover browser permissions, connection ordering, reconnect and Gemini session-resumption behavior, bandwidth and CPU limits, audio echo, video-frame sampling, mobile backgrounding, session cleanup, and one shared typed action state. A Decart outfit change should not be triggered independently by voice, gesture, and buttons; each input method dispatches the same application command, which then updates Decart and the visible session state once.

## Data and trust boundaries

- User photos are sensitive. Never log raw bytes or place permanent provider keys in the client.
- Decide original-photo, derived-crop, garment-cutout, AI-generated customer-likeness preview, report, transcript, and live-session retention separately. They may need different lifetimes and deletion controls.
- Keep originals and generated reconstructions distinguishable in metadata and UI.
- Record source photo IDs and confidence/evidence for every extracted garment. A user must be able to correct or delete an item without redoing the entire photo set.
- Do not infer protected or sensitive traits from photographs. Only extract styling-relevant visible garment and presentation signals needed for the disclosed experience.
- Confirm provider data-use, storage, regional processing, deletion, and abuse-monitoring terms before sending real customer photos.

## Required discovery spikes before the engineering plan is finalized

### 1. Favorite-look extraction

**Hypothesis:** The Wardrobe approach can reliably turn 8–12 real outfit photos into a useful, deduplicated garment set quickly enough to seed taste calibration and the report.  
**Cheapest signal:** Run several representative 8–12-photo sets containing repeated, layered, partially occluded, light, and dark garments; measure repository reliability, per-image and total latency, item recall, duplicate rate, cutout usefulness, partial-failure behavior, and corrections required.  
**Decision:** Adopt the narrow extraction/review pattern with or without a required customer review, or use the fallback: direct favorite-look/style-signal analysis to seed candidates and the report while preserving successful extraction results.

### 2. Decart try-on quality and latency

**Hypothesis:** Lucy VTON can sustain a demo-quality live stream with the user and garment variety Magic Mirror needs.  
**Cheapest signal:** Test tops, bottoms, dresses, layers, loose garments, dark garments, movement, partial occlusion, multiple body shapes, skin tones, and both portrait/landscape cameras. Record time to connect, time to first transformed frame, switch latency, visible failure rate, and recovery behavior.  
**Decision:** Confirm Decart for the live demo, narrow supported garment categories, or prepare a fallback.

### 3. Gemini + Decart + gesture realtime session

**Hypothesis:** One target demo device can sustain Decart video, Gemini Live voice with useful session context, and gesture recognition without unacceptable latency, resource use, echo, or instability.  
**Cheapest signal:** Start all three capabilities, perform three voice-driven and three gesture-driven outfit changes, reconnect one failed stream without losing the others, and record CPU, bandwidth, echo, Gemini/Decart session behavior, and end-to-end action latency. Run once with Gemini consuming sampled video/screen frames and once with structured session state only; choose the cheaper, safer mode that still understands the selected item and visible results.

### 4. AI-generated report wardrobe previews

**Hypothesis:** OpenAI image generation can create useful, respectful customer-likeness wardrobe previews from real matched products without misleading identity drift or blocking the report.  
**Cheapest signal:** Use consented representation-diverse customer images and permitted product references to measure likeness preservation, garment recognizability, harmful artifacts, latency, failure rate, and reviewer acceptance against an approved quality bar.  
**Decision:** Enable generated previews for supported cases, narrow their use, or use the required text-and-linked-product fallback. Do not run the spike with Shopify images until reuse permission is confirmed.

### 5. Shopify retailer coverage

**Hypothesis:** Shopify Global Catalog can supply useful cross-retailer apparel recommendations, current offers, and reliable seller handoffs without Magic Mirror maintaining separate store integrations.  
**Cheapest signal:** Use the global endpoint to run text, image, and multimodal searches for representative style-profile requests; measure relevance, size/color coverage, merchant diversity, duplicate clustering, availability freshness, seller/checkout-link integrity, latency, and rate behavior. Confirm that the no-cache/image-use rules fit the proposed UI and Decart boundary.  
**Decision:** Use Global Catalog MCP directly, create a constrained Saved Catalog, combine global and intentionally scoped Storefront Catalog calls, or add another source only for demonstrated coverage gaps.

## Inputs for the future engineering and build plans

The engineering plan should convert these notes into typed provider boundaries, BDD scenarios, data schemas, privacy decisions, environment variables, failure states, observability, latency budgets, and time-boxed implementation tasks. Provider preference does not waive the repository rule that every external call needs validation, timeout/recovery behavior, and a real visible failure state.
