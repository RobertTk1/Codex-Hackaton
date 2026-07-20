# Magic Mirror Engineering Readiness — Founder Input Form

Fill this file directly, save it, and tell Codex when it is ready for review. This is the single founder-input document for the engineering plan.

## How to fill this out

- Complete only fields beginning with **Founder answer** or **Founder confirmation**.
- Check an option with `[x]` or replace `TBD` with your answer.
- You may write `Unknown` or `Need help` when you want Codex to recommend or walk through setup.
- **Never paste API keys, OAuth secrets, passwords, access tokens, or service-role keys into this file.** Confirm only that access exists and name the secure location, such as `DigitalOcean encrypted environment variables`.
- Fields labeled **Codex fills later** are technical outputs from architecture, contracts, spikes, or ticket planning. Leave them alone.
- Recommended hackathon defaults are provided where a fast reversible choice is appropriate. Accept them with `[x]` or edit them.

---

## 1. OpenAI Build Week requirements — already filled from Devpost

**Hackathon:** OpenAI Build Week  
**Devpost:** https://openai.devpost.com  
**Status:** Submissions open  
**Submission deadline:** Tuesday, July 21, 2026 at 5:00 PM Pacific / 8:00 PM Eastern  
**Judging begins:** Wednesday, July 22, 2026  
**Winners announced:** On or around Wednesday, August 12, 2026  

### Required submission deliverables

- Working, non-trivial project built using Codex and GPT-5.6.
- One category.
- Project description explaining what was built and how it works.
- Public YouTube demo video under three minutes.
- Demo narration must cover what was built, how Codex was used, and how GPT-5.6 was used.
- Public or private code-repository URL.
- If private, share repository access with `testing@devpost.com` and `build-week-event@openai.com` before the deadline.
- README with setup instructions, sample data when needed, and clear run instructions.
- README/submission must explain where Codex accelerated the workflow, important decisions, and how Codex/GPT-5.6 were used.
- `/feedback` Codex Session ID from the task where most core functionality was built.
- Every team member must accept their Devpost invitation before the deadline.
- Submission must be submitted, not left as a draft.

### Judging criteria

1. Technological Implementation
2. Design
3. Potential Impact
4. Quality of the Idea

### Submission choices

**Recommended track:** Apps for Your Life

**Founder answer — track:**  
- [ x] Accept `Apps for Your Life`
- [ ] Use another track: `TBD`

**Founder answer — submitter type:**  
- [ ] Individual
- [ x] Team of Individuals
- [ ] Organization

**Founder answer — country of residence:** `TBD`

**Founder answer — team members whose invitations must be accepted:** `TBD`

The connected Devpost account currently has two OpenAI Build Week drafts. Neither is clearly named Magic Mirror, so Codex will not edit either until you identify the right one:

- Project `1345164`, name `-`, slug `project-kou46x39cg5t`, state `submission_draft`
- Project `1343745`, name `Untitled`, state `submission_pre_draft`


**Founder answer — Magic Mirror Devpost project:**  
- [ ] Use project `1345164`
- [ ] Use project `1343745`
- [x ] Create/use another project: `TBD`

**Founder answer — repository visibility at submission:**  
- [ x] Public with an open-source license
- [ ] Private and shared with both judging addresses before the deadline

**Founder answer — internal freeze:**  
- [ x] Accept recommended feature/code freeze: Tuesday, July 21 at 1:00 PM Pacific / 4:00 PM Eastern
- [ ] Use another feature/code freeze: `TBD`

**Founder answer — demo and submission freeze:**  
- [x ] Accept recommended demo/submission freeze: Tuesday, July 21 at 3:00 PM Pacific / 6:00 PM Eastern
- [ ] Use another demo/submission freeze: `TBD`

**Founder answer — `/feedback` session ID:** `Fill after the primary build task exists; do not invent it`

---

## 2. DigitalOcean production and hosting

**Resolved founder decision:** DigitalOcean is the production/hosting platform.

**Recommended hackathon setup:** One DigitalOcean App Platform application containing a Vite web component and a TypeScript API service, with Supabase remaining the managed database/auth/storage provider.

**Founder confirmation:**  
- [ x] Accept DigitalOcean App Platform as the deployment product
- [ ] Use another DigitalOcean product: `TBD`

**Founder answer — DigitalOcean account/team name:** `General Intelligence Agency`

**Founder answer — who has deployment access:** `Talisha`

**Founder answer — preferred DigitalOcean region, if any:** `No preference`

**Founder answer — production or demo domain:** `use magicmirror as prefix to digital ocean provided domain`

**Founder answer — may Codex/engineering create a DigitalOcean App Platform app during the deployment ticket?**  
- [x ] Yes
- [ ] No
- [ ] Need to discuss

**Founder answer — secure secret location:**  
- [ x] DigitalOcean encrypted environment variables
- [ ] Another secure store: `TBD`

**Founder answer — API runtime constraint:**  
- [ ] Bun is required for local tooling and production API runtime
- [ ] Bun is required for package/build tooling; production may use a compatible TypeScript runtime chosen by engineering
- [x ] Need Codex recommendation

**Codex fills later — DigitalOcean app/component architecture:** `Pending architecture step`

**Codex fills later — health checks, scaling, deploy command, and rollback:** `Pending architecture/contracts`

---

## 3. External accounts and access

For each service, record only status and secure location—never the credential value.

### Supabase

**Founder answer — project status:**  
- [ ] Existing project ready
- [x ] Create a new project
- [ ] Need setup help

**Founder answer — project name or non-secret project reference:** `magic-mirror`

**Founder answer — project region:** `Americas`

**Founder answer — founder and engineering access confirmed:** `Yes`

**Founder answer — secure secret location:** `DigitalOcean encrypted environment variables `

Required application names later: `VITE_SUPABASE_URL`, `VITE_SUPABASE_PUBLISHABLE_KEY`, `SUPABASE_SERVICE_ROLE_KEY`.

### Google OAuth for Supabase Auth

**Founder answer — Google Cloud/Auth project:** `Need setup`

**Founder answer — OAuth client configured for local and DigitalOcean callback URLs:** `No`

**Founder answer — secure client-secret location:** `Supabase Auth provider settings`

Required secure names later: `GOOGLE_OAUTH_CLIENT_ID`, `GOOGLE_OAUTH_CLIENT_SECRET`.

### Email delivery

**Recommended hackathon default:** Resend for Supabase custom SMTP and report-ready email.

**Founder confirmation:**  
- [x ] Accept Resend
- [ ] Use another provider: `TBD`
- [ ] Need setup help

**Founder answer — verified sender/domain:** `thecrownlist.com`

**Founder answer — secure secret location:** `DigitalOcean encrypted environment variables`

Normalized application secret name later: `EMAIL_DELIVERY_API_KEY`.

### OpenAI API

**Founder answer — API project and billing ready:** `Credential and model visibility confirmed; founder directs planning to assume credits will be added before OpenAI-dependent implementation`

**Founder answer — required model/image access confirmed:** `Yes`

**Founder answer — secure secret location:** `DigitalOcean encrypted environment variables`

Required secret name: `OPENAI_API_KEY`.

### Google AI / Gemini Live

**Founder answer — Google AI project and billing ready:** `Yes`

**Founder answer — Gemini Live access confirmed:** `Yes`

**Founder answer — secure secret location:** `DigitalOcean encrypted environment variables / TBD`

Required secret name: `GEMINI_API_KEY`.

### Decart Lucy VTON

**Founder answer — account and billing ready:** `Yes`

**Founder answer — realtime Lucy VTON access confirmed:** `Yes`

**Founder answer — secure secret location:** `DigitalOcean encrypted environment variables`

Required secret name: `DECART_API_KEY`.

### Shopify Global Catalog

**Founder answer — hosted UCP agent-profile URL:** `TBD`

**Founder answer — Global Catalog request tested successfully:** `Need setup`

**Founder answer — higher-rate authenticated Catalog API access available, if any:** `Unknown`

The default Global Catalog MCP path is currently documented as keyless; do not add an API-key requirement unless the chosen access path actually needs one.

---

## 4. Privacy, consent, and data lifecycle

You may accept the recommended hackathon policy or replace individual durations.

### Recommended hackathon lifecycle

- Anonymous incomplete accounts and their assets: delete after 7 days.
- Original favorite-look photos for connected accounts: delete 30 days after report generation or sooner on customer deletion.
- Derived crops, garment cutouts, and extraction artifacts: same or shorter lifetime than their source photo; cascade-delete with the source/account.
- AI-generated customer-likeness previews: delete after 30 days or sooner on customer deletion; keep the text recommendation and current product reference.
- Structured profile, taste reactions, report, and saved product references: retain until the customer deletes the account or explicitly resets the profile.
- Live camera/video media: do not persist by default.
- Voice transcripts: do not persist by default beyond the active session; keep only redacted operational events.
- Provider/backup copies: require provider-compatible deletion and document the maximum residual backup period.

**Founder confirmation:**  
- [ x] Accept the recommended hackathon lifecycle
- [ ] Use these changes: `TBD`
- [ ] Need a policy recommendation/review before deciding

**Founder answer — customer deletion behavior:**  
- [x ] One account-deletion action removes owned profile, photos, derived assets, generated previews, reports, taste history, live-session records, and bag references, subject to documented provider/backup delay
- [ ] Use another behavior: `TBD`

### Purpose-specific consent

**Founder confirmation:**  
- [x ] Approve separate, versioned consent for profile/gender use; photo analysis; garment extraction; AI-generated likeness previews; camera; microphone; and optional Gemini visual context
- [ ] Request changes: `TBD`

**Founder confirmation — Gemini context:**  
- [ ] Prefer structured session state; sampled camera/screen frames may be enabled only if the spike proves material value and the customer grants separate consent
- [ x] Allow sampled camera/screen frames by default after camera/microphone consent
- [ ] Structured state only; do not send visual frames to Gemini

---

## 5. Product and policy decisions needed by technical contracts

### Anonymous progress connecting to an existing account

**Recommended rule:** Never overwrite an existing report, taste history, or bag silently. After login, preserve anonymous answers/uploads as a new draft profile input set, merge non-conflicting bag references, show the customer the existing report plus the new draft, and require confirmation before generating a new report version.

**Founder confirmation:**  
- [x ] Accept recommended merge behavior
- [ ] Use another rule: `TBD`

### Taste calibration completion

**Recommended hackathon rule:** Require 12 reactions, allow up to 20, balance categories/colors/silhouettes/representation, preserve completed reactions, and switch to a balanced curated fallback when dynamic sourcing cannot return the next card promptly.

**Founder confirmation:**  
- [x ] Accept recommended rule
- [ ] Minimum reactions: `TBD`
- [ ] Maximum reactions: `TBD`
- [ ] Other sourcing/balance/fallback changes: `TBD`

### Wardrobe extraction review

**Recommended rule:** Engineering may make customer review required only if the extraction spike shows that unreviewed errors materially degrade taste candidates or the report. Otherwise show a lightweight optional correction entry.

**Founder confirmation:**  
- [ ] Accept spike-gated review rule
- [ ] Always require customer review
- [ x] Never add a customer review step for the hackathon

### Color and Kibbe-informed report governance

**Founder answer:**  
- [ x] Founder accepts the approved interpretive/non-diagnostic language for the hackathon without an external reviewer
- [ ] Styling expert review required; reviewer: `TBD`
- [ ] Legal/policy review required; reviewer: `TBD`

### Generated wardrobe-preview quality

**Recommended rule:** Publish a preview only when likeness remains recognizable, the garment category/color/pattern remain materially faithful, there are no harmful body/face artifacts, the image is clearly labeled as a generated visualization, and it finishes within the approved report latency budget. Any failed criterion uses the complete text-and-current-product-link fallback.

**Founder confirmation:**  
- [ x] Accept recommended quality/fallback rule and delegate measurable thresholds to the spike
- [ ] Request changes: `TBD`

### Shopify product-image reuse

**Current safe default:** Do not send Shopify Global Catalog product images to OpenAI or Decart without affirmative permission or merchant authorization.

**Founder confirmation:**  
- [ ] Keep the safe fallback: text/current product links for report previews and user-owned/approved garment images for Decart
- [ ] I will provide documented permission/authorization location: `TBD`
- [x] Founder accepts the unverified product-image rights risk for this hackathon and understands this is not merchant/provider permission

### Live hand gestures

**Recommended rule:** Approve the shared action contract now and delegate exact gestures/confidence thresholds to the measured dual-realtime spike. Direct and voice controls remain available; consequential actions require confirmation.

**Founder confirmation:**  
- [ x] Accept spike-selected gesture vocabulary within these guardrails
- [ ] Required gestures/actions: `TBD`

### Retail attribution and affiliate behavior

**Founder answer:**  
- [ x] No affiliate program for the hackathon; record only a non-sensitive outbound click event and name the destination retailer
- [ ] Affiliate links are in scope; provider/program and disclosure: `TBD`
- [ ] Do not record outbound events

---

## 6. Demo device and support matrix

**Recommended primary demo device:** MacBook using current Chrome, landscape camera, headphones available for realtime voice testing.

**Founder confirmation:**  
- [ x] Accept recommended primary demo device
- [ ] Use this device/browser instead: `TBD`

**Recommended secondary validation:** Current Safari on iPhone plus keyboard-only and reduced-motion desktop checks for the report-led golden path. Live Decart/Gemini/gesture support may be narrower if the spike documents the limitation.

**Founder confirmation:**  
- [x ] Accept recommended secondary validation
- [ ] Use this support matrix instead: `TBD`

---

## 7. Consented test data

Do not place private test photos directly in this planning file. Record only where the approved dataset will live and who may use it.

**Founder answer — dataset owner:** `Talisha White`

**Founder answer — secure storage location:** `/Users/talishawhite/Documents/Magic Mirror Test Data/` (private local folder outside Git)

**Founder answer — permission/consent record location:** `/Users/talishawhite/Documents/Magic Mirror Test Data/consent/authorization.md`

**Founder answer — available participant/photo sets:** `One founder-owned set containing eight favorite-look photos`

**Founder answer — representation dimensions covered:** `One real participant baseline only; authorized synthetic fixtures will broaden contract, failure, and representation checks without being presented as real-user evidence`

**Founder answer — product/garment references available for Decart:** `Create during the Decart spike from current catalog cases under the recorded founder risk acceptance; keep any private derivative assets outside Git`

**Founder answer — generated-preview evaluation cases available:** `The eight consented photos form the real baseline; representative synthetic cases will be created during the preview-quality spike`

**Founder answer — may synthetic fixtures be used for non-visual contract and failure tests?** `Yes`

---

## 8. Final founder confirmation

**Founder name:** `Talisha White`  
**Date completed:** `7/20/26`  

- [x ] I confirm this file contains no credential values or private customer/test images.
- [ x] I approve the checked decisions as inputs to the Magic Mirror engineering plan.
- [ x] I understand that architecture comes next; implementation begins only after the final engineering plan is approved and required access is ready.

**Anything else Codex should know before architecture:**  
`TBD`
