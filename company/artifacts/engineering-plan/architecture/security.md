# Security, Privacy, and Trust Architecture

## Trust model

The browser, customer input, uploaded files, provider responses, model output, catalog content, realtime function calls, and URLs are untrusted. Supabase Auth establishes identity; Postgres constraints and RLS establish ownership; application code establishes allowed state transitions only after Zod validation.

Anonymous users receive real Supabase identities. They are not a shared guest account. Google or magic-link connection either links that identity or performs the explicit one-use transfer flow documented in [Critical Runtime Flows](flows.md).

## Data classification

| Class | Examples | Required handling |
|---|---|---|
| Restricted | Original photos, garment cutouts, generated likeness previews, body/profile measurements, live camera/audio | Private storage or owned rows; purpose consent; least access; no raw logs; explicit retention/deletion |
| Confidential | Taste reactions, report content, recommendations, saved bag, account email | Owner-scoped rows; no public URLs; minimal provider disclosure |
| Operational | Job state, request ID, provider latency/error code, outbound event | May enter structured logs only without profile traits, content, tokens, or asset URLs |
| Public | Marketing pages, brand assets, non-personal synthetic demo content | May be served publicly after asset provenance review |

## Identity and authorization

- Every protected API request verifies the Supabase JWT and derives `owner_id` server-side; request bodies cannot choose an owner.
- Every customer-owned public table has RLS for select, insert, update, and delete before application access.
- Storage policies require the first path segment to match the authenticated user and corroborate object ownership in Postgres where needed.
- Service-role access exists only in the API/worker environment and is limited to work that user-scoped clients cannot safely perform.
- Background jobs store the subject record and owner, recheck both before reading assets, and cancel when the source is deleted or superseded.
- Anonymous transfer tokens are random, hashed at rest, short-lived, single-use, owner/revision-bound, and consumed in one transaction.

Authorization is tested negatively: one account must never read, mutate, sign, claim, or infer another account's profile, asset, report, job, live session, or bag item.

## Consent and purpose boundaries

Separate versioned consent records cover:

1. analysis of uploaded favorite-look photos;
2. creation and retention of derived garment assets;
3. generation of customer-likeness previews;
4. live camera and microphone use;
5. optional transmission of visual context to Gemini Live.

Declining optional visual context keeps structured-state voice available if the dual-realtime spike validates it. Revoking image-generation consent prevents new previews and queues existing previews for deletion without removing text recommendations. Live media is not recorded or persisted by default.

The founder-authorized hackathon test photos remain outside Git and may be used only for Magic Mirror hackathon work. Synthetic fixtures are permitted but cannot support claims about real-user quality or representation.

## Secret and token boundaries

- Permanent OpenAI, Gemini, Decart, Resend, and Supabase server credentials exist only in DigitalOcean encrypted variables or approved local ignored files.
- No permanent secret uses a `VITE_` name, enters a browser bundle, log, screenshot, test fixture, provider prompt, database row, or error response.
- Browser realtime access uses scoped short-lived credentials minted after session ownership and consent checks.
- Signed storage URLs use the shortest practical lifetime and are never persisted as product data.
- OAuth redirect origins and CORS use exact allowlists; production does not use wildcards.
- Credential rotation is documented, and validation checks confirm state without printing secret-bearing UI fields.

## Input and provider safety

### Uploads

The server verifies actual media signatures, bounded size, dimensions, decode success, allowed count, and ownership. Filenames are ignored for trust and replaced with opaque identifiers. Unsupported or suspicious files fail visibly before provider transmission. Raw bytes never enter logs or Postgres.

### Model and catalog boundaries

- Prompts treat customer text, image metadata, catalog copy, and provider output as data, never executable instructions.
- Model tools expose a small typed allowlist. The model cannot issue arbitrary HTTP requests, database queries, storage paths, or shell instructions.
- All model/provider outputs are schema-parsed and bounded before persistence or UI rendering.
- Catalog URLs are accepted only from the normalized Shopify response and validated for HTTPS before handoff; the API does not fetch arbitrary customer-supplied URLs.
- Product descriptions and image metadata are rendered as escaped content and cannot alter prompts, tools, or UI code.
- Generated-image quality checks can reject an asset without rejecting the underlying recommendation.

## Abuse controls

- Rate-limit anonymous session creation, magic-link requests, uploads, extraction, report submission, preview generation, live-token minting, and retailer refresh by identity plus coarse network signal.
- Enforce one active report run per profile revision and bounded active live sessions per account.
- Apply request-body, upload-count, result-count, prompt-size, job-attempt, and provider-cost ceilings.
- Use generic account-access responses where disclosure could enable email enumeration.
- Record security-relevant operational events without customer media or report content.

Exact limits are contract/ticket decisions informed by the provider spikes; absence of a final number is not permission for an unbounded implementation.

## Threat controls

| Threat | Architectural control | Verification |
|---|---|---|
| Cross-user object access / IDOR | JWT-derived owner, RLS, opaque IDs, ownership check before signing | Two-user negative API/storage tests |
| Anonymous draft hijack | Hashed single-use transfer token bound to owner/revision/expiry | Replay, expired, wrong-owner, existing-account conflict tests |
| Malicious or oversized upload | Signature/decode/size/count validation; opaque storage name | Invalid corpus and limit tests |
| SSRF or hostile catalog URL | No arbitrary server fetch; Shopify-normalized HTTPS links only | Reject non-Shopify-derived and non-HTTPS destinations |
| Prompt injection in customer/catalog text | Data delimiters, typed tools, no arbitrary I/O, output schema | Injection fixtures cannot trigger unapproved action |
| Provider response leakage | Normalized bounded records; raw bodies excluded from client/logs | Error and logging inspection |
| Accidental gesture/voice purchase action | Proposal model, shared action union, duplicate sequence rejection, confirmation | Distance-control BDD scenarios |
| Stolen realtime credential | Short lifetime, session/user scope, server mint, no persistence | Expiry and cross-session tests |
| Sensitive observability | Field allowlist and redaction; no raw images/transcripts/URLs | Automated log assertion + manual review |
| Orphaned derived assets | Source lineage, expiry, retryable deletion jobs | Account deletion and retention reconciliation |

## Product-image rights and likeness risk

Shopify Global Catalog documentation enables product discovery but does not by itself prove that every merchant image may be transmitted to OpenAI or Decart for derivative generation. The founder accepted this unverified risk for the hackathon; that is not documentary authorization.

Therefore:

- the spike records the exact source, provider, terms reviewed, and intended transformation;
- generated previews and Decart use share the same permission decision;
- the visible fallback is live product cards and text recommendations without transmitting product images;
- the system never claims merchant endorsement or fabricates retailer availability;
- generated previews are labeled as visualizations and linked to their real source products.

## Retention and deletion

The retention rules in [Data Architecture](data.md) are enforced by durable jobs. Customer deletion immediately revokes product access, then removes private objects and rows with retry/reconciliation. Operational evidence may retain only non-sensitive completion/failure metadata. Provider-side and backup residual windows must be documented before production use; they cannot be represented as immediate erasure when they are not.
