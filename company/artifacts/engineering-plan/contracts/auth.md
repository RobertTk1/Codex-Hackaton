# Authentication and Authorization Contract

- **Status:** Approved after cross-contract review
- **Identity provider:** Supabase Auth
- **Supported customer methods:** anonymous, Google OAuth, email magic link
- **Prohibited customer methods:** password, SMS, shared guest account

This contract makes anonymous progress, signup/login, ownership, and account transfer deterministic. It uses current Supabase JavaScript methods that support anonymous users, OAuth/PKCE, passwordless email, and identity linking. It does not treat a browser session as authorization; Postgres RLS and server ownership checks remain mandatory.

## Identity states

| State | Supabase identity | Allowed product work |
|---|---|---|
| `public` | none | Landing and public configuration only |
| `anonymous` | unique Auth user with `is_anonymous=true` | Onboarding, photos, extraction, taste calibration, consent, profile review |
| `permanent` | Google or email identity | All owned work, report submission/read, Style Home, live styling, bag, handoff, deletion |
| `deletion_blocked` | token may still be cryptographically valid | No customer read/write/sign operation; only client sign-out |

Every protected API request verifies the current JWT, derives `auth.uid()`, rejects a deletion-blocked subject, and scopes all reads/writes by current relational ownership. Email is not copied into product tables and is not an authorization key.

## Browser session rules

- Create the Supabase browser client with PKCE flow, session persistence, and automatic refresh.
- Access tokens are sent only to the exact Magic Mirror API origin and Supabase endpoints. They never enter URLs, logs, analytics, screenshots, provider prompts, or database rows.
- The browser does not store provider access/refresh tokens from Google because Magic Mirror requests no Google API scope beyond sign-in.
- `onAuthStateChange` refreshes the application session and re-runs `resolveResume`; it does not mutate product ownership by itself.
- A global sign-out clears the browser session. Account deletion uses global sign-out after the access block commits.
- Expired access tokens yield `401 AUTH_SESSION_EXPIRED`; the client attempts one Supabase session refresh, then returns to account access while preserving any already-persisted anonymous work.

## Anonymous start

1. `Get your style report` calls `supabase.auth.signInAnonymously()` only when no valid session exists.
2. The browser calls `createOrResumeProfile` with `entry=landing`.
3. The server creates at most one resumable draft under the unique anonymous owner or returns the existing draft.
4. After the customer grants `profile_processing` consent, every accepted answer is immediately persisted through the profile operations. Favorite brands and brand/category size status are child records; the chat transcript is not persistence.
5. Anonymous sessions cannot submit a report, use Style Home, start live styling, save a bag item, or hand off to a retailer until account connection completes.

Rate limits apply to anonymous creation by identity plus coarse network signal. CAPTCHA may be added only if abuse is observed; it is not a hidden launch prerequisite.

## Returning account access

The landing `Log in` action presents only:

- `Continue with Google`
- an email field and `Email me a magic link`

Both are unified sign-up/sign-in methods. Customer copy never asks whether the account already exists, and responses do not reveal that fact.

After authentication, the browser calls `resolveResume`. Resolution order is:

1. incomplete report run;
2. resumable draft;
3. current active report / Style Home;
4. landing when no product state exists.

An account menu may expose `Style Home`, `View report`, `Start live styling`, and `Delete account`. No password UI is created.

## Google flow

### No anonymous product state

Call `supabase.auth.signInWithOAuth({ provider: "google", options: { redirectTo } })`. The exact `redirectTo` must be in Supabase and Google allowlists. The callback processes the PKCE result, then calls `resolveResume`.

### Anonymous product state

Before redirect, call `prepareAnonymousTransfer(method=google)` and set the returned Secure, HttpOnly, SameSite=Lax cookie. Then start Google OAuth.

If Supabase can safely link the Google identity to the same anonymous Auth user through the enabled manual-linking flow, use `linkIdentity({ provider: "google" })` and verify after callback that `sub` is unchanged. If the provider returns or requires a different permanent owner, consume the explicit transfer after the callback. The implementation must not assume linking succeeded merely because Google authentication succeeded.

## Magic-link flow

1. Validate the email syntactically in the browser but do not persist or log it.
2. When anonymous product state exists, call `prepareAnonymousTransfer(method=magic_link)` first.
3. Call `supabase.auth.signInWithOtp({ email, options: { emailRedirectTo, shouldCreateUser: true } })`.
4. Always show the same customer-facing sent state when Supabase accepts the request, regardless of whether the address already had an account.
5. The email template sends the approved token-hash link to the exact Magic Mirror callback. The callback calls `verifyOtp({ token_hash, type: "email" })` when the current template/PKCE flow requires it.
6. After a permanent session exists, call `consumeAnonymousTransfer` and then `resolveResume`.

Magic links are single use and provider-expiring. Resend is rate-limited through Supabase Auth. `Resend magic link` repeats step 3 and never creates a second transfer for the same still-valid source revision.

PKCE state is browser-bound. If a link opens on another browser/device, authentication may not complete the transfer because neither the verifier nor transfer cookie is available. The recovery state says to open the link in the original browser or return there and use Google; it never destroys or exposes the anonymous draft.

## Anonymous-to-permanent transfer

### Preparation

`prepareAnonymousTransfer` is allowed only for an anonymous owner with a draft profile. It creates 32 random bytes, stores only `sha256(token)`, binds the row to `source_owner_id`, `source_profile_id`, exact `source_profile_revision`, method, and a maximum 15-minute `expires_at`, and sends the plaintext only in a Secure, HttpOnly, SameSite=Lax cookie scoped to `/api/v1/auth/transfers`.

The cookie never enters JavaScript, URLs, local/session storage, provider state, or logs. A second preparation for the same source revision returns the still-valid preparation rather than creating unbounded rows.

### Consumption

Consumption requires a permanent target JWT and the transfer cookie. The server hashes the cookie value and calls the single data-contract transfer transaction. That transaction locks source, target, and transfer rows; checks prepared status, future expiry, exact source revision, current ownership, no deletion block, and target identity; then applies the founder-approved conflict rules:

- If the target has no active profile or draft, transfer the anonymous draft and its allowed owned children.
- If the target has an existing report/taste history/bag, preserve them. Copy the anonymous work as a new derived draft and show both states.
- Never overwrite an existing report, report history, taste history, or bag silently.
- Bag rows are not part of anonymous onboarding and therefore are not transferred.
- A new report version requires an explicit confirmation later through recalibration/profile review.

The transaction consumes the token exactly once. Success clears the cookie and makes the source draft inaccessible from the old owner. Replay, expiry, changed source revision, wrong owner, or deletion block fails without partial copy.

## Authorization matrix

`owner` always means the current JWT subject matches relational `owner_id`, including after a completed transfer.

| Resource/capability | Public | Anonymous owner | Permanent owner | Service/worker |
|---|---:|---:|---:|---:|
| Public configuration/landing | read | read | read | read |
| Profile, favorite brands, and brand sizes | no | own draft read/write | own draft read/write; active read | narrow privileged transactions |
| Consent records | no | own select/append | own select/append | validate purpose/revoke effects |
| Original photo object | no | upload only with one-path signed token; own unexpired read | same | sign/verify/delete exact object |
| Photo metadata | no | own unexpired read; delete via API | same | create/transition/delete |
| Signals/garments/candidates | no | own unexpired/bounded read | own read | create/transition |
| Taste reactions | no | own draft insert/update | own draft insert/update | read report evidence |
| Report run/report | no | no submission/read | own submit/read/retry | create/process/publish |
| Recommendation/catalog | no | taste candidate only | own report + live current catalog | refresh/normalize |
| Live session | no | no | own aggregate read; mutations via API | create/transition/token mint |
| Bag/handoff | no | no | own | validate refs/event |
| Private operational tables | no | no | no table access | least-privilege server/worker only |
| Account deletion | no | cancel anonymous draft through retention only | request own deletion | purge/reconcile |

RLS exists on every exposed customer table even when the API also checks ownership. Direct browser write grants are limited to the exact data-contract matrix; the API is required for server-only state transitions.

## Storage authorization

All three buckets are private. Customer roles receive no general Storage insert/update/delete grant. After application ownership/revision checks, the server creates a one-path Supabase signed upload token with upsert disabled plus a separate application completion token. Ordinary reads authorize against current, unexpired relational metadata rather than the path's creation-owner segment, so completed account transfers do not require object copy/rename. `derived-assets` and `generated-previews` are server/worker write-only.

Authenticated downloads and API-created signed URLs require:

- current owner match;
- no account-deletion block;
- current row and source relationship;
- `expires_at > now()`;
- signed URL TTL no later than logical expiry.

Object deletion is server-side and exact-path only. No recursive customer delete, move, copy, listing across a profile prefix, public URL, or permanent signed URL is allowed.

## Consent authorization

Browser permission and product consent are separate. The latest append-only decision for each purpose is evaluated at action time.

| Purpose | Required before |
|---|---|
| `profile_processing` | persisting body/profile facts and report analysis |
| `photo_analysis` | accepting uploaded favorite-look photos for analysis |
| `garment_extraction` | extraction/cutout job |
| `generated_likeness_preview` | OpenAI wardrobe preview or still try-on generation |
| `account_connection` | anonymous transfer/account connection |
| `live_camera` | live session creation after browser camera grant |
| `live_microphone` | Gemini voice connection after browser microphone grant |
| `gemini_visual_context` | sending any camera/screen frame to Gemini |

Revocation prevents new processing immediately. It queues the relevant derived assets for deletion and never claims already-transmitted provider data was synchronously erased.

## Account deletion and session revocation

`requestAccountDeletion` commits the private access-block row before returning. All customer table policies, Storage reads, signed URLs, transfer consumption, token minting, and worker source loads consult the block. The browser then performs global sign-out. The purge worker deletes exact private objects, relational rows, and finally the Auth user; retry does not re-enable access. Non-sensitive deletion enforcement survives until prior JWT lifetime plus skew and the documented cleanup period have elapsed.

## Required negative tests

1. Anonymous user A cannot read, mutate, sign, transfer, or infer user B's profile/photo/candidate.
2. Permanent user A cannot access B's report, recommendation, live session, bag, or deletion state by UUID.
3. Expired/replayed/wrong-owner/changed-revision transfer tokens make no partial changes.
4. Existing target history is preserved and requires explicit derived-draft confirmation.
5. Old anonymous JWT loses access immediately after transfer.
6. A deletion-blocked but otherwise valid JWT cannot access any row/object or mint credentials.
7. Signed URLs fail by logical deadline and cannot be produced for expired/deleted rows.
8. Cross-device magic-link recovery preserves the source draft without leaking account existence.
