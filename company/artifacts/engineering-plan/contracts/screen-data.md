# Screen and Data Operations Contract

- **Status:** Approved after cross-contract review
- **Implementation inventory:** 44 screen/state surfaces (landing + 8 approved conversational pre-report states + 35 canonical post-entry states)
- **Archived reference inventory:** 12 form-first pre-report canonical records retained only for traceability
- **Authority:** `operationId` values in [api.md](api.md); stored names/states in [data.md](data.md)

This contract maps every approved action to its reads, writes, permissions, and observable recovery behavior. It is not a copy or visual specification. The adopted chat-first package replaces canonical pre-report screens 2–11 and 28–29 as presentation while writing the same validated profile contract.

## Shared screen rules

- Route entry calls `resolveResume` whenever current persisted state could supersede a bookmarked route.
- Protected screens require the identity class shown below and render no customer data before authorization succeeds.
- Loading keeps the last valid state visible and marks only the changing region busy.
- Empty, unavailable, denied, slow, and failed are distinct states.
- Every error uses [errors.md](errors.md), preserves already-committed work, and exposes the named retry/alternative/safe exit.
- Direct, keyboard, swipe, voice, and gesture variants of one action use the same operation and state contract.
- Catalog facts are live projections; stored recommendations/bag items never supply cached price, availability, image, seller, or retailer URL.
- `C` means client-only/browser-managed behavior; `S` means Supabase Auth/Storage direct boundary; every other named operation is `/api/v1`.

## Public entry

| Screen/state | Reads | Writes | Permission | Loading/empty/error/recovery | Actions → operations |
|---|---|---|---|---|---|
| `landing-page-base` (`76a5f0c7-aa78-4eaf-ae0f-4b577024f5c6`) | `getPublicConfiguration`; existing Auth session | anonymous profile only after start | public | configuration skeleton; generic service recovery; authenticated visitor may be routed by `resolveResume` | Get report → `S signInAnonymously` if needed → `createOrResumeProfile`; Log in → `C /account` then Google/magic-link Auth |

## Approved conversational pre-report implementation

| Screen/state | Reads | Writes | Permission | Loading/empty/error/recovery | Actions → operations |
|---|---|---|---|---|---|
| `conversation-welcome` (`29c00d17-3c1d-4231-8b85-4f359a82b5f7`) | `getPublicConfiguration`, `resolveResume` when session exists | new/resumed draft; profile-processing consent when customer starts | public → anonymous | pending anonymous session; auth failure offers retry; no session starts no draft; consent line remains adjacent to start action | Begin → `S signInAnonymously` → `createOrResumeProfile` → `recordConsent(profile_processing)`; Already have account → `prepareAnonymousTransfer` only when a draft exists, then Google/magic link |
| `conversation-personal-details` (`6d5f5ef1-a4a2-41d3-aa89-dc3722ae8df0`) | `getProfileSnapshot`, current profile-processing consent | accepted name, adult confirmation, gender, age, height, optional weight; revision | anonymous/permanent owner, draft with granted profile-processing consent | assistant sending/streaming; clarification is not error; revision conflict reloads snapshot; invalid answer stays on same question; ineligible adult answer stores nothing and ends the path safely; no unpersisted styling-goal answer is solicited | Send answer → `submitConversationTurn`; edit prior factual answer → `replaceProfileAnswer`; Save/exit → `C navigate` after committed turn |
| `conversation-brand-sizing` (`66d528db-21de-4e52-9ecd-3c388cede1e3`) | profile + ordered favorite brands + sizes | separate favorite-brand choices and category-size status/list; revision | owner, draft | narrow clarification for missing brand/category/status; unknown/not-applicable never invents a label; duplicate edits existing tuple; provider parsing failure falls back to direct structured choice | Natural answer → `submitConversationTurn(favorite_brands|brand_sizes)`; edit brand list → `putFavoriteBrands`; add/edit/remove category sizes → `putBrandSizes`; Save/exit → `C` |
| `conversation-photo-collection` (`0dfa9f00-c27f-489e-bc14-53eb49f55b8f`) | `listPhotos`, consent status, upload limits | consent event, immutable objects, verified photo rows/jobs/order | owner, draft; photo-analysis/extraction consent | per-file selecting/uploading/validating; empty prompt; local invalid file never uploads; server rejection moves only that item to review | Choose/take photos → `C file/camera` → `createPhotoUploadSlot` → `S uploadToSignedUrl` → `completePhotoUpload`; reorder → `reorderPhotos`; remove → `deletePhoto`; continue → validation + `getExtractionSummary` |
| `conversation-photo-review` (`0903cde1-37cb-49c1-8146-ecd07dd54c70`) | `listPhotos`, `getExtractionSummary` | retry/delete/atomic replacement/reorder; optional garment review; revision | owner, draft | shows ready/rejected/partial independently; minimum/expiry disclosure; retry preserves siblings; direct-signal fallback permits continue | Retry failed extraction → `retryPhotoExtraction`; replace → `createPhotoUploadSlot(replacesPhotoId)` → signed upload → `completePhotoUpload` atomic swap; reorder → `reorderPhotos`; remove → `deletePhoto`; undo remove is available only before delete commit, otherwise re-upload; review garment → `reviewExtractedGarment`; Keep going → `ensureTasteCandidates` |
| `conversation-taste-calibration` (`fd161337-14fc-4476-9cec-9d004248c1c7`) | `getTasteCalibration`; live media for current candidate | Love/Hate/Maybe or undo; revision | owner, draft | one current candidate; loading/fallback/recoverable error; preserves reactions if later candidates fail; buttons/keyboard always available | Swipe right/Love, left/Hate, down/Maybe or button → `putTasteReaction`; Undo → `undoTasteReaction`; Retry/fallback → `ensureTasteCandidates`/`getTasteCalibration` |
| `conversation-account-access` (`27d64888-57dc-4ecd-a4b2-7bbaecc5ef0f`) | profile completion summary, current auth state | account-connection consent, transfer preparation/consumption and permanent ownership | anonymous owner → permanent | generic sent state; auth error offers other method; existing account preserves both states; wrong-browser magic link returns original-browser recovery | Begin connection → `recordConsent`; Google → `prepareAnonymousTransfer` → `S signInWithOAuth/linkIdentity` → `consumeAnonymousTransfer`; email → prepare → `S signInWithOtp/verifyOtp` → consume; resend → `S signInWithOtp`; leave before auth → `cancelAnonymousTransfer`; alternate method → same flow |
| `conversation-profile-review` (`a97cdab0-56b4-4922-8244-a9b95c1d7381`) | `getProfileSnapshot` including completion blockers | report run/job; optional notice intent | permanent owner; all required consents, 8–12 photos, 12 reactions | submit disables duplicate action; validation routes to exact conversational step; accepted handoff goes to processing | Edit answer → `replaceProfileAnswer`/`putBrandSizes`/photo/taste operation; Create report → `submitProfileForReport`; Save/exit → `C /style-home` |

## Report processing and report

| Screen/state | Reads | Writes | Permission | Loading/empty/error/recovery | Actions → operations |
|---|---|---|---|---|---|
| `style-report-analysis-processing` (`ecb422c1-0285-4592-9407-97a1f82bf96e`) | `getReportRun` every >=2s | notification intent only | permanent owner of run | stage-specific progress <90s; meaningful extended-stage treatment at 90–119s; route survives reload/leave | Notify me → `requestReportNotification`; completion → `getCurrentReport` then report route |
| `style-report-analysis-slow` (`762423ae-d732-4325-bed9-b91b42370ca9`) | same active run | notification intent | permanent owner | appears at >=120s, keeps polling; not a failure | Email when ready → `requestReportNotification`; Leave safely → `C /style-home` then `resolveResume` |
| `style-report-analysis-error-recovery` (`6c9017a7-ec72-46df-bba8-79dcc691a817`) | failed run safe stage/error | next bounded run sequence | permanent owner | distinguishes retryable/exhausted; inputs preserved | Try again → `retryReportRun`; Get help → `C` support URL with request ID only |
| `style-report-overview` (`1c2d940e-9782-4d23-866a-9e676af44138`) | `getCurrentReport`, overview section, recommendation count | none | permanent owner | report skeleton; no report routes Style Home recovery; previews optional | Explore report → report section routes/`getReportSection`; Selected items → `listBag` |
| `style-report-color` (`b16feadb-5618-46fc-b03f-be77d1de7b4f`) | `getReportSection(color)`, optional `listRecommendations` filter | feedback only | permanent owner | section not found returns overview; catalog outage leaves section intact | Save palette → `C` accessible local export; Give feedback → feedback state; matching items → `listRecommendations`/`searchCatalog` |
| `style-report-body-style` (`3acb5ce5-518b-4cf3-beba-ce38439031e2`) | `getReportSection(body_style)` | feedback only | permanent owner | interpretive disclosure always present; section failure returns overview | See what to wear → `listRecommendations`; Does not feel right → feedback state |
| `style-report-recommendations` (`ec0e2f41-d712-48b1-83fe-c535b1438a12`) | `listRecommendations` with current Shopify facts | optional bag later | permanent owner | per-item preview absent is normal; product unavailable has explicit state; catalog error keeps rationale | Shop recommendation → `getProduct`/detail drawer; Save guidance → `C` local export |
| `style-report-feedback-and-recalibration` (`4d345373-f991-5f0d-8ac7-5885e4a456f8`) | current report/section and existing open feedback summary | append feedback or create derived draft | permanent owner | validation keeps note; recalibration explains preserved report; conflict resumes existing draft | Submit correction → `submitReportFeedback`; Request recalibration → confirm then `startRecalibration`; Cancel → `C` prior report route |

## Style Home and recovery

| Screen/state | Reads | Writes | Permission | Loading/empty/error/recovery | Actions → operations |
|---|---|---|---|---|---|
| `style-home-base` (`d677a738-5703-4b02-b7ca-667c31ac7555`) | `getStyleHome` with report, suggested outfit groups, saved-item previews/count, recoverable work, and live eligibility | none | permanent | independently renders each module; partial catalog failure does not blank home; unavailable products keep styling rationale | Start live → camera-permission state then `createLiveSession`; View report → `getCurrentReport`; Browse picks/outfits → recommendations/catalog; open saved item → `getProduct`; account settings → utility account route |
| `style-home-resume-or-recover` (`dd9e7858-c66f-5351-a51c-dd63a8b11d7a`) | `resolveResume`, active run/draft/report summary | operation-specific retry only | permanent | explicit incomplete/failed/ready branches; never invents completed work | Resume → resolved destination; Try again → run/photo/candidate retry matching subject; View report → `getCurrentReport` |

The utility account route has no bespoke approved mockup. It may expose Google/email account identity status, sign out, confirmed `requestAccountDeletion`, and an Edit style profile action. Edit style profile confirms `startRecalibration` and resumes the existing conversational screens against the derived draft; it never mutates the frozen active profile/report in place and cannot add password or profile fields outside approved scope.

## Live setup, base session, and product selection

| Screen/state | Reads | Writes | Permission | Loading/empty/error/recovery | Actions → operations |
|---|---|---|---|---|---|
| `live-styling-camera-permission` (`5e8e9f80-901b-4fb1-932c-f1bec76da0c9`) | selected current product via `getProduct`, consent versions | browser camera permission + camera consent; session only after grant | permanent; supported device | purpose shown before native prompt; denial routes denied state; product unavailable routes unavailable state; microphone is not requested here | Allow camera → `C getUserMedia` → `recordConsent(live_camera)` → `createLiveSession`; Not now → `C` recommendations/Style Home |
| `live-styling-camera-denied` (`40fd9de9-e880-5bfc-9b65-6cd20fb67ec6`) | current product/permission status | consent only after a later grant | permanent | explains browser setting without blaming; direct product path remains | Try again → `C getUserMedia` then create flow; Return → `C` recommendations |
| `live-styling-connecting` (`54dc6ff8-3d1b-5989-b8d2-0ad2a89aeaa5`) | `LiveSessionBootstrap`, current product | credentials and connecting transition | permanent owner of session | independent Decart/Gemini connection status; timeout goes slow/error; no fake preview | connect → `mintRealtimeCredentials` + provider clients; first frame → `transitionLiveSession(ready)`; Cancel → `endLiveSession` |
| `live-styling-ready` (`5b6baf59-f2d4-4c52-aaa7-b4910435c892`) | session snapshot, live current product/result set, bag membership | action-specific selection/bag/session aggregate | permanent owner | live output plus direct controls; provider channel failures degrade independently | Voice → microphone state; gestures → guide; choose item → `proposeLiveAction(select_item)`; add bag → proposal/confirmation; all product changes update Decart client state after accepted decision |
| `live-styling-changing-item` (`dded5401-afec-5473-908c-600462fb42ec`) | current + pending item/sequence | accepted selection and aggregate latency | permanent owner | old valid frame remains until new result; stale result ignored; timeout → slow | Cancel change → `C` cancel pending before commit or new inverse proposal after commit; success → `transitionLiveSession` aggregate |
| `live-styling-slow` (`ae357eac-806d-5768-be5f-89d98443000e`) | session/provider connection state | optional new selection | permanent owner | slow is time-based; current product/static state remains | Keep waiting → `C`; Choose another → `proposeLiveAction(select_item)` |
| `live-styling-error-recovery` (`1716ecc3-8b94-5ef0-9b0c-2ead1ab289ca`) | safe session/provider error and product | reconnect transition or terminal state | permanent owner | provider-specific safe recovery; report/product preserved | Try again → `transitionLiveSession(reconnecting)` → `mintRealtimeCredentials`; Return → `endLiveSession` then recommendations |
| `live-styling-ended` (`6904e26b-6abb-5437-9ca5-dad6b2f8de4a`) | terminal session summary and `listBag` | new session only | permanent owner | no live media retained; failure vs normal end copy differs | Review selections → `listBag`; Start another → camera/session flow with current consent recheck |
| `recommended-product-detail-drawer` (`a7d262bf-0e4a-423f-9d51-fed5b2594b14`) | `getProduct`, bag membership | bag item or live session | permanent | detail skeleton; current unavailable state; no stale checkout | Add bag → `addBagItem`; Try item → camera/session flow; Continue retailer → `prepareRetailerHandoff` |
| `recommended-product-unavailable` (`7dc86399-4d75-56ec-a7a7-975b78b7992f`) | current failed product ref and alternatives | none | permanent | explains changed availability; never shows stale offer | Alternatives → `getAlternatives`; Close → `C` prior surface |

## Voice states

| Screen/state | Reads | Writes | Permission | Loading/empty/error/recovery | Actions → operations |
|---|---|---|---|---|---|
| `live-styling-microphone-permission` (`e72fcc42-581c-44fa-b466-c3ac642e54df`) | live session, consent versions | browser permission + microphone consent; optional visual consent; Gemini context mode/credential | permanent owner/live ready | denial leaves direct controls; visual-context consent is separate and only needed for sampled video | Allow → `C getUserMedia(audio)` → `recordConsent(live_microphone)` → optional `recordConsent(gemini_visual_context)` → `mintRealtimeCredentials(gemini + consent/context fields)`; Direct → `C` ready |
| `live-styling-voice-listening` (`87b489bf-c543-4911-a09d-48b57be4a80a`) | live session + Gemini connection | no transcript; proposals only | permanent + microphone consent | live listening indicator; connection failure state; interruption supported | Cancel voice/Direct → `C` stop listening; function call → `proposeLiveAction` |
| `live-styling-voice-interpreting` (`b6b1be00-af2d-5976-9648-61bfbd14a836`) | current session/result refs and function proposal | none until decision | permanent | bounded interpretation; unknown/stale proposal rejects safely | Cancel → `C` discard; parsed proposal → `proposeLiveAction` |
| `live-styling-voice-confirmation` (`8183dd09-dfd2-5ba9-ba70-c8034de399cf`) | `LiveActionDecision(confirm)` | confirmed action only | permanent | displays exact interpreted consequence; token expiry returns listening | Confirm → `confirmLiveAction`; Edit → new voice/direct proposal; Cancel → `C` discard token |
| `live-styling-voice-acting` (`fb5d25f2-f5c4-5d26-a3e6-0335bbd9df72`) | accepted action/current sequence | action-specific effect | permanent | awaited action region only; stale/failed routes failure | Accepted non-consequential → provider/local update; durable/consequential → `confirmLiveAction`; Cancel → only before commit, otherwise inverse action |
| `live-styling-voice-failure` (`c8945f7b-bc1b-5d12-ba8b-39dc97cba22a`) | safe Gemini/action error | reconnection only | permanent | Decart/direct controls remain | Voice again → re-mint/reconnect or resume listening; Direct → `C` ready |

## Gesture states

| Screen/state | Reads | Writes | Permission | Loading/empty/error/recovery | Actions → operations |
|---|---|---|---|---|---|
| `live-styling-hand-gesture-guide` (`83f2ff2a-7951-42b5-b715-5fbe97ffb568`) | approved device vocabulary/threshold config and session | none | permanent + live camera; capability pass | reduced motion/keyboard alternatives; unsupported device offers voice/direct | Start → `C` local recognizer observing; Practice → `C` no command; Voice → microphone state; Direct → ready |
| `live-styling-gesture-observing` (`a66498d1-8567-5492-b8da-9e2b12d376e9`) | current sequence, local confidence config | no raw frames; proposal when threshold met | permanent + camera | quiet observing, no repeated low-confidence errors | Pause/Direct → `C`; recognized gesture → local proposal then `proposeLiveAction` |
| `live-styling-gesture-interpreting` (`96d21855-d455-5843-a97e-a0fb78bec909`) | proposed gesture/current refs | none until decision | permanent | bounded debounce; stale/duplicate ignored | Cancel → `C`; valid → `proposeLiveAction` |
| `live-styling-gesture-accepted` (`a861bac2-1c68-51c8-af40-7ea3cad52809`) | accepted non-consequential action/result | selection only when action says execute | permanent | visible acceptance with brief undo; no purchase implication | Undo → `proposeLiveAction(undo_last_selection)`; Continue → `C` observing |
| `live-styling-gesture-ignored-or-unavailable` (`096e3398-1e3a-5c6e-b473-e714ca54ff43`) | local capability/confidence reason | none | permanent | low confidence is ignored, not failure; provider-independent | Try again → `C` observing; Voice → microphone state; Direct → ready |
| `live-styling-gesture-confirmation` (`d40738f4-6d72-51fe-8c9b-8308a5e7f97d`) | confirmation decision/token | confirmed action only | permanent | exact consequence; token expiry returns observing | Confirm → `confirmLiveAction`; Cancel → `C` discard |

## Bag and retailer handoff

| Screen/state | Reads | Writes | Permission | Loading/empty/error/recovery | Actions → operations |
|---|---|---|---|---|---|---|
| `magic-mirror-bag-base` (`1eb0f961-b299-4ab3-b90d-12692f254494`) | `listBag` with live facts grouped by retailer | remove item; handoff event only after confirm | permanent | empty directs to picks/style; per-item unavailable; provider outage preserves refs | Continue retailer → `prepareRetailerHandoff`; Remove → `removeBagItem`; Keep styling → Style Home/live/recommendations |
| `bag-item-unavailable` (`d894b82b-ac4b-564a-9d74-bce7184b05be`) | unavailable bag item stable ref + alternatives | optional remove | permanent | current facts explicitly unavailable | Alternatives → `getAlternatives`; Remove → `removeBagItem`; Keep styling → `C` Style Home/live |
| `retailer-handoff-confirmation` (`49c5dc8e-da7f-433d-bba0-5011bb755948`) | `prepareRetailerHandoff` current seller/price/availability/destination hostname | outbound event after confirmation | permanent | refreshes before showing; material state change requires new confirmation; checkout ownership disclosed | Continue → `confirmRetailerHandoff` then `C window.open(destinationUrl)`; Stay → `C` prior Magic Mirror state |

## Archived form-first pre-report traceability

These records remain in `screens.json` and v1 comps as reference, but implementation must not create parallel routes/components for them. Their jobs/actions are satisfied by the approved conversational states and operations below.

| Archived canonical record | Replaced by | Action compatibility |
|---|---|---|
| `account-access-unauthenticated` (`ee82967b-e205-401b-a90b-6a94d36470f7`) | landing + `conversation-welcome`/`conversation-account-access` | Google/magic link → Supabase Auth + transfer operations; new report → anonymous start |
| `personal-profile-base` (`61df36bb-6d7c-41a3-bf06-9c2c99824e51`) | `conversation-personal-details` | Continue → accepted `submitConversationTurn` sequence |
| `brand-and-size-profile-base` (`9ad25480-da71-430f-816a-6f394bed7f15`) | `conversation-brand-sizing` | Add/continue → `putBrandSizes` + next conversational turn |
| `outfit-photo-upload-empty` (`bfc87225-7f0e-45c1-90f7-6623d96e9dad`) | `conversation-photo-collection` | Choose → signed slot + Storage upload + complete |
| `outfit-photo-upload-partial` (`7628f30f-b601-49ab-93eb-2cc367ab1b2e`) | collection/review | Add → signed upload protocol; reorder → `reorderPhotos`; continue → extraction summary/candidates |
| `outfit-photo-upload-validation-error` (`acea6cc0-08ca-4691-806e-2faae3ce2b0f`) | `conversation-photo-review` | Replace/remove/reorder → upload/delete/order operations |
| `taste-calibration-base` (`e6f13ec8-a8d0-405c-932b-3befeb7de4f6`) | `conversation-taste-calibration` | Love/Hate/Maybe/Undo → same reaction operations |
| `taste-calibration-recovery` (`37d792e1-4d6c-494f-b53d-1dc4a498c294`) | `conversation-taste-calibration` recovery substate | Try again → ensure/get candidates without resetting reactions |
| `account-connection-base` (`782fdff8-e9b9-4828-aaa2-33b089ffd011`) | `conversation-account-access` | Google/magic link → same transfer/Auth contract |
| `account-connection-magic-link-sent` (`e74afd3b-7709-40af-bedc-15cc9d2a6f1e`) | account-access sent/recovery substate | Open email `C`; resend Supabase; Google alternate |
| `personal-profile-validation-error` (`4df9db19-8f5b-53dd-a000-18e33ad9a6e3`) | personal-details clarification/error substate | Correct/continue → same turn/replace operation |
| `account-connection-error-recovery` (`eef632ce-8d4a-5035-aa15-b5efdd09b2a2`) | account-access recovery substate | Retry/other method → same Auth/transfer contract |

## Coverage totals

- 48/48 canonical screen/state records are covered: 36 remain canonical implementation surfaces and 12 are explicitly archived/replaced.
- 8/8 approved conversational v2 states are implementation surfaces.
- Every listed primary action is either mapped to an exact API `operationId`, a named Supabase Auth/Storage boundary, or an explicit client-only action with no durable claim.
- Every persisted read/write names a record from the approved data contract; no screen requires a new table, cached catalog payload, chat transcript, or live-media record.
