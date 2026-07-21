---
product: Magic Mirror
company: Magic Mirror
version: 1.1.0
date: 2026-07-19
status: Approved
owner: Talisha White
approval_record: Approved by Talisha White on 2026-07-19 for UX design
source_artifacts:
  - company/company.md
  - company/plan.md
  - company/artifacts/audience_definition/audience_definition_report.md
  - company/artifacts/market-research/
  - company/brand/
  - /Users/talishawhite/Documents/Magic Mirror Product Strategy.docx
  - https://www.qoves.com/
---

# Magic Mirror Product Requirements Document

## 1. Executive summary

Magic Mirror is an AI personal stylist that learns how a person dresses, explains how to improve their styling, and turns that understanding into personalized shopping and live virtual try-on. The primary audience is an adult who wants to dress better but lacks a clear, personalized system for choosing colors, silhouettes, brands, sizes, and complete looks.

The customer enters through an editorial, education-led landing page centered on a comprehensive personal style report. When onboarding begins, Magic Mirror creates an anonymous authenticated session so every answer and upload can be preserved before the customer has a permanent account. The customer completes a guided profile, records brand-specific sizing, uploads 8-12 full-body photos of favorite looks, and refines the initial taste model through Tinder-like cards: swipe right for **Love**, left for **Hate**, and down for **Maybe**. Before results are generated, the customer connects the anonymous session to a permanent account using Google or an email magic link. Magic Mirror then delivers the style report within a target of one to two minutes.

The report explains the customer's style identity, existing strengths, highest-value opportunities, color palette, Kibbe-informed body-style profile, recommended silhouettes and proportions, and specific outfit and garment recommendations. From the report, the customer enters a live styling session containing items selected for them, grants camera and microphone access, tries products on through live video, and controls the session from a distance using either voice or camera-recognized hand gestures. The customer collects preferred products in a Magic Mirror bag and continues to the appropriate retailer to complete checkout.

The current delivery phase is frontend definition. Every screen, requirement, and user-facing message describes the intended real product behavior of analysis, live try-on, voice actions, catalog results, and retailer handoffs.

Key founder decisions:

- Onboarding begins in an anonymous authenticated session that preserves progress until permanent account connection.
- Google and email magic link are the only permanent account methods; the same account step signs up new customers or logs in existing customers.
- The permanent account step happens after profile inputs and taste calibration but before report generation.
- Report generation should complete within one to two minutes.
- Taste calibration uses **Love**, **Hate**, and **Maybe**: right, left, and down respectively, with matching accessible controls.
- Live styling supports both voice and camera-recognized hand gestures for distance control.
- Product purchases are completed on retailer sites, not through Magic Mirror checkout.
- The first functional build centers on real onboarding, real style analysis, a real report, and real curated recommendations; downstream capabilities remain specified as real target behavior.

## 2. Product context

### Problem

People can browse nearly unlimited clothing but still struggle to answer personal questions: What actually suits me? Which colors and proportions work together on my body? Why do some outfits feel right while others do not? Which brands and sizes are likely to work? What should I buy next rather than merely admire?

Existing alternatives fragment the job across inspiration feeds, generic style quizzes, body-type articles, retailer size charts, human stylists, and virtual try-on tools. Inspiration is abundant, but a durable explanation of the individual's taste and a direct bridge from that explanation to shopping action is uncommon.

### Status quo and alternatives

- Social platforms provide inspiration but do not reliably translate it into personal rules.
- Retailers recommend products from their own catalogs and have limited incentive to explain a cross-retailer personal style.
- Generic quizzes rely heavily on self-report and often produce broad archetypes.
- Human styling can be valuable but is expensive, scheduled, and difficult to scale.
- Virtual try-on products visualize individual garments but usually begin without a deep understanding of the customer's taste.

### Why now

Multimodal analysis, image generation, voice interfaces, and retailer product data can now be combined into one continuous experience. The opportunity is not merely to render clothes on a body; it is to create a persistent style intelligence layer that improves both recommendations and try-on decisions.

### Category and positioning

Magic Mirror sits at the intersection of personal styling, visual taste learning, virtual try-on, and cross-retailer shopping assistance. Its durable promise is: understand your style, see what works, and confidently act on it.

### Evidence and constraints

- Founder vision establishes the style-report-led journey and the live styling destination.
- Company research identifies purchase confidence and personalized decision support as stronger differentiation than generic virtual try-on alone.
- The selected validation audience is behaviorally defined rather than restricted to a demographic group.
- QOVES is a structural landing-page reference for an education-heavy, report-led conversion journey; its branding, appearance claims, and scoring language are not Magic Mirror inputs.
- User photos and body-related data are sensitive. Consent, data minimization, access isolation, transparent use, and respectful language are product requirements. The product makes no automatic image-expiration promise in this version.

## 3. Full product vision

Magic Mirror becomes a persistent personal styling environment that understands the customer's visual taste, body-style needs, sizes across brands, preferred colors, real wardrobe behavior, and shopping intent. It can explain recommendations, show them on the customer, refine them conversationally, and connect the customer to products they can buy.

The complete loop is:

1. Learn the person through structured questions, brand-size history, outfit photos, and visual taste choices.
2. Explain the person's style through a useful, editable report rather than an opaque score.
3. Translate the report into specific looks and purchasable items.
4. Let the person experience those items in a live visual styling session.
5. Refine the session from a distance through natural voice requests or camera-recognized hand gestures.
6. Send selected items to retailers for purchase.
7. Learn from explicit feedback, saved choices, retailer visits, and future sessions.

The product must help the customer feel more capable and understood. It must not rank attractiveness, shame body characteristics, present an interpretive styling framework as medical fact, or imply that generated visualization guarantees physical fit.

## 4. First coherent frontend experience

### Experience being defined

The frontend package covers the primary journey from public landing page through retailer handoff, including anonymous onboarding, permanent account connection, report generation, report exploration, personalized recommendations, live styling, voice and hand-gesture interaction, bag review, and material recovery states.

### First functional build outcome

The first functional build proves the style-intelligence promise:

1. A visitor understands the report and begins onboarding.
2. The customer completes the personal and brand-size profile.
3. The customer uploads 8-12 qualifying outfit photos.
4. The customer completes visual taste calibration.
5. The customer connects the anonymous session to a permanent account with Google or an email magic link.
6. Magic Mirror performs real analysis and returns the report within the one-to-two-minute target.
7. The customer receives real personalized recommendations selected from an available catalog.

The frontend still defines live styling, voice refinement, bag behavior, and retailer handoff as intended real capabilities so later engineering does not have to reconstruct the experience.

## 5. Goals, learning goals, and non-goals

### Customer goals

- Receive a specific, comprehensible description of personal style.
- Understand colors, proportions, silhouettes, and styling changes that are likely to help.
- See recommendations tied directly to the analysis rather than generic trends.
- Try recommended items visually and request alternatives by voice, hand gesture, or direct controls without restarting the session.
- Reach the retailer with clear intent and confidence.
- Understand and control how personal images and profile data are used.

### Product goals

- Establish the style report as the primary acquisition and activation event.
- Create a durable style profile that improves subsequent recommendations.
- Connect analysis, recommendation, visualization, and shopping into one coherent system.
- Preserve trust through respectful analysis, identity fidelity, and explicit privacy behavior.

### Learning goals

- Determine whether customers will complete a relatively high-effort onboarding flow in exchange for a deep report.
- Determine which report sections users consider most accurate, useful, and actionable.
- Measure whether photo analysis plus swipe calibration produces recommendations users prefer over generic merchandising.
- Determine whether the report increases engagement with personalized recommendations and retailer handoffs.
- Establish whether one-to-two-minute report generation is technically reliable and psychologically acceptable.

### Non-goals for the first functional build

- Magic Mirror-owned payment processing or order fulfillment.
- Guaranteed garment fit, exact sizing, inventory availability, or delivery timing.
- Medical, health, attractiveness, or diagnostic assessment.
- Minor accounts or collection of children's body imagery.
- A complete digital closet, social network, creator marketplace, or retailer analytics product.
- Human stylist operations as a dependency for every report.

## 6. Actors and jobs

### Prospective customer

An adult evaluating whether the report is worth the effort and whether Magic Mirror can be trusted with personal imagery. Their job is to understand the outcome, process, data use, and expected timing before beginning.

### First-time customer

An adult completing the style-profile journey. Their job is to provide enough accurate information and imagery to receive a useful report without feeling judged, confused, or trapped.

### Returning customer

An authenticated customer revisiting the report, recommendations, styling sessions, bag, or account settings. Their job is to continue without repeating completed onboarding.

### AI stylist

The product capability that analyzes inputs, explains findings, selects catalog items, responds to requests, and maintains continuity across the report and live session. The AI stylist must expose uncertainty and recovery rather than invent confidence.

### Product operator or reviewer

An authorized internal actor who can inspect processing failures, catalog eligibility, consent records, access controls, and safety issues without gaining unrestricted access to customer photos. Human review is an exception path, not a hidden requirement for normal report completion.

### Retailer

An external commerce destination that owns product price, availability, cart, payment, fulfillment, returns, and final terms. Magic Mirror must make the boundary clear before handoff.

### Representation and quality dimensions

Testing must cover varied ages within the adult population, skin tones, body shapes, heights, sizes, mobility needs, genders, fashion confidence, photo quality, and device capability. These are quality dimensions, not automatic audience exclusions.

## 7. End-to-end journeys

### Journey A: Discover and begin

1. The visitor lands on a public page that leads with the benefit of understanding personal style.
2. The page previews report sections, shows how inputs become recommendations, explains timing and privacy, and names the limits of visualization.
3. The visitor selects **Get your style report**.
4. If already authenticated and onboarded, the system routes them to their style home. If authenticated but incomplete, it resumes the next incomplete step. Otherwise, Magic Mirror creates an anonymous authenticated session and begins onboarding without requiring a permanent account upfront.

### Journey B: Build the initial style profile

1. The customer provides their name and confirms they are an adult.
2. The customer supplies gender, age, height, optional weight, and an overall fit preference: fitted, regular, relaxed, or varies by garment. Gender is the single approved term across product, copy, and consent language; the customer can choose an inclusive option or self-describe. Each sensitive field explains why it is requested, whether it is required, and how it affects styling and shopping recommendations.
3. The customer selects favorite brands.
4. For each selected brand, the customer records sizes by garment type—not one universal brand size—such as Zara jeans L, Zara tops M, or a known numeric size. A garment type may be marked unknown or not applicable.
5. Progress is saved to the anonymous authenticated session so accidental navigation does not erase completed work before permanent account connection.

### Journey C: Upload outfit evidence

1. The customer sees photo guidance, consent, the 8-photo minimum, 12-photo maximum, accepted formats, quality requirements, and how the photos will be used for analysis.
2. The customer uploads full-body photos of themselves wearing favorite looks.
3. Each photo shows upload and validation status independently.
4. The customer can replace, reorder, or remove a photo before continuing.
5. The system blocks continuation until at least eight qualifying photos are available and explains any rejected image in actionable language.

### Journey D: Extract garment signals and refine taste through swiping

1. After photo validation, Magic Mirror extracts and deduplicates visible garments from the customer’s favorite looks. Successful per-image results are preserved if another image fails.
2. Extracted garments and broader style signals seed a dynamically sourced, balanced sequence of relevant look and garment cards. If extraction cannot supply enough signal, Magic Mirror falls back to direct favorite-look/style-signal analysis so the report path is not blocked.
3. The primary interaction follows a Tinder-like model: swipe right for **Love**, swipe left for **Hate**, and swipe down for **Maybe**.
4. Visible **Love**, **Hate**, and **Maybe** buttons and keyboard controls perform the same actions for accessibility and non-touch devices.
5. A short progress indicator communicates the remaining calibration effort.
6. The system includes a balanced range of silhouettes, colors, styling intensity, categories, and representation rather than repeatedly testing one dimension.
7. The customer can undo the most recent choice.
8. If dynamic candidate sourcing is slow or fails mid-onboarding, completed reactions remain saved and the customer can retry or continue with a safe balanced fallback set.
9. When sufficient signal has been collected, the system explains that the profile is ready for analysis.

### Journey E: Connect the account and generate the report

1. The customer chooses **Continue with Google** or enters an email address to receive a magic link, and agrees to the account and privacy terms.
2. The same step creates a new permanent account or logs into an existing account; there is no separate signup versus login mode.
3. The system links the anonymous session to the permanent account and preserves its profile, uploads, taste choices, and progress.
4. The analysis screen explains the work being performed and displays meaningful stages without exposing internal implementation.
5. The target is to complete and display the report within 120 seconds.
6. The customer may safely leave; processing continues, and the account can resume the result.
7. If processing exceeds 120 seconds, the product shows a slow state, confirms that inputs are safe, and offers email notification plus a return link.
8. If analysis fails, the product preserves valid inputs, identifies the recoverable step, and offers retry or support. It does not silently discard the session.

### Journey F: Understand the style report

1. The report opens with an affirming summary of the customer's style identity and strongest patterns.
2. The overview prioritizes the most useful actions rather than presenting a single score.
3. The customer explores color, body-style, styling opportunities, and recommendations through a clear report navigation model.
4. Color guidance includes a primary palette, supporting neutrals, accent colors, combinations, and colors to use intentionally rather than declaring colors forbidden.
5. The Kibbe-informed section explains the suggested profile, visual evidence, confidence, and styling implications. The customer can disagree, provide feedback, or request recalibration.
6. Recommendations explain why each silhouette, proportion, layer, fabric, or styling move connects to observed inputs.
7. The customer can move directly from a recommendation to a personalized set of products.

### Journey G: Enter live styling

1. The customer opens the personalized stylist home and sees products selected from the style report.
2. The customer starts a live styling session and receives clear camera requirements.
3. After camera permission, the live view shows the customer and the active recommended item, along with product identity and controls.
4. The customer can control the live session directly, by voice, or through camera-recognized hand gestures designed for use when the phone or laptop is several feet away.
5. Hand gestures support moving to the next or previous outfit and selecting visible controls; the interface shows the recognized gesture before acting.
6. Voice supports meaningful requests such as a different color, silhouette, price range, brand, or occasion.
7. The AI stylist confirms interpreted voice or gesture input, updates the recommendation set, and explains the most relevant change.
8. Consequential actions such as adding to the bag or leaving for a retailer require explicit confirmation so an accidental movement cannot trigger them.
9. If camera, microphone, gesture recognition, network, catalog, or generation capability fails, the session preserves selections and provides a recovery path.

### Journey H: Select and shop

1. The customer opens product details without leaving the styling context.
2. The customer adds preferred products to a Magic Mirror bag or removes them.
3. The bag groups items by retailer and shows that price, stock, shipping, returns, and checkout are controlled by each retailer.
4. The customer selects **Continue to retailer** for an item or retailer group.
5. Magic Mirror records the outbound selection event and opens the retailer product or cart destination.
6. Returning to Magic Mirror preserves the report and bag state subject to account and catalog availability.

### Journey I: Return and continue

1. A returning customer logs in and lands on style home, not onboarding.
2. The customer can revisit the report, continue a session, update sizes, recalibrate taste, review saved items, or manage the account.

## 8. Frontend surfaces and behavior

### Public marketing

The landing page uses an editorial, evidence-oriented report narrative inspired structurally by QOVES: outcome-led hero, report preview, how-it-works sequence, personalized analysis categories, example recommendations, privacy and trust explanation, FAQ, login access, and repeated report CTA. It must use Magic Mirror's own voice, visual identity, report content, and substantiated claims.

### Product shell and navigation

- Anonymous onboarding uses a focused stepper with back, progress, save/recovery behavior, and one primary action.
- Authenticated product navigation provides Style Home, My Report, Live Styling, Saved Items/Bag, and Account.
- Report navigation remains legible on desktop and collapses into a mobile section menu or sticky section control.
- Live styling prioritizes the camera view, active garment, voice state, hand-gesture state, direct controls, and add-to-bag action.

### Required state behavior

Every material action must define base, validation, loading or processing, slow, error, recovery, success, permission, and unauthenticated behavior where applicable. No awaited AI or provider action may fail silently.

### Responsive expectations

- Landing page and report support desktop and mobile.
- Onboarding is mobile-first and remains usable on desktop.
- Taste calibration makes swiping the primary touch interaction while preserving matching Love, Hate, and Maybe buttons plus keyboard controls.
- Live styling supports mobile portrait first, with a desktop composition that preserves equivalent controls.
- Live styling keeps gesture recognition status, supported gesture guidance, and the interpreted action visible at a distance.
- No critical action depends only on hover, drag, gesture, color, or voice.

### Accessibility and respectful presentation

- Meet WCAG 2.2 AA for navigable structure, focus visibility, contrast, form labels, error identification, and alternatives to gestures and voice.
- Use neutral, specific styling language. Lead with strengths and actions rather than defects.
- Do not expose body measurements, age, or images in page titles, notifications, or analytics payloads.
- Provide text equivalents for color guidance and meaningful descriptions for report visuals.

## 9. Feature scope

### Epic A: Report-led acquisition - must-have

User value: understand what the report delivers and why the process is trustworthy. Business value: convert qualified visitors into onboarding. Dependencies: approved claims, report structure, privacy terms. Acceptance: visitors can understand the outcome, timing, inputs, data policy, and primary action without creating an account.

### Epic B: Guided style onboarding - must-have

User value: provide meaningful context once without guessing how. Business value: collect the minimum inputs for personalization. Dependencies: field definitions, validation, and anonymous-session recovery. Acceptance: valid progress survives navigation and invalid or missing inputs produce specific remediation.

### Epic C: Outfit-photo collection - must-have

User value: teach Magic Mirror from real personal style evidence. Business value: improve personalization beyond a quiz. Dependencies: upload validation, consent, secure storage, and access isolation. Acceptance: 8-12 validated images can be reviewed and edited; each failure is local and recoverable.

### Epic D: Taste calibration - must-have

User value: correct or deepen the inferred taste before analysis. Business value: create explicit preference signals. Dependencies: candidate looks/items and feedback capture. Acceptance: right/Love, left/Hate, and down/Maybe choices are attributable, undoable, available through matching non-gesture controls, and reflected in analysis inputs.

### Epic E: Anonymous-to-permanent account connection - must-have

User value: safely receive and revisit results. Business value: create a persistent customer relationship at the moment of demonstrated intent. Dependencies: anonymous authentication plus Google and email magic-link account connection. Acceptance: one account step signs up or logs in and preserves all anonymous-session inputs.

### Epic F: Style analysis and report - must-have

User value: receive a useful personal explanation and action plan. Business value: deliver the core differentiated outcome. Dependencies: multimodal analysis, report generation, safety rules, catalog taxonomy, async status. Acceptance: the system targets completion within 120 seconds, exposes progress and recovery, and produces all required report sections with traceable recommendations.

### Epic G: Personalized stylist home - must-have

User value: turn report findings into concrete next actions and products. Business value: bridge activation to repeated engagement and commerce. Dependencies: report outputs and eligible catalog. Acceptance: recommendations state why they match the report and never claim unavailable stock or guaranteed fit.

### Epic H: Distance-controlled live styling - should-have for the first engineering release; required in the complete product definition

User value: experience and refine recommendations without standing next to the device. Business value: differentiate Magic Mirror from static reports and feeds. Dependencies: camera, live visualization, voice interpretation, hand-gesture recognition, catalog filtering, and latency controls. Acceptance: the active request, recognized gesture, garment, state, and recovery path remain visible; direct controls duplicate every essential voice and hand action.

### Epic I: Magic Mirror bag and retailer handoff - should-have for the first engineering release; required in the complete product definition

User value: act on confident selections. Business value: create attributable retailer intent. Dependencies: product URLs, retailer grouping, availability refresh. Acceptance: the customer understands the external boundary and can reach the correct retailer destination without losing Magic Mirror state.

### Epic J: Trust, consent, and access isolation - must-have

User value: understand how sensitive inputs are used and know that another customer cannot access them. Business value: establish trust and reduce privacy risk. Dependencies: purpose-specific consent and account/session permissions. Acceptance: photo, camera, microphone, and account consent are explicit; every sensitive asset and session is isolated to its anonymous or permanent account owner.

## 10. Backend and system implications

These are user-visible capability requirements, not architecture choices.

### Identity and authentication

- Create an anonymous authenticated user when onboarding begins and associate every onboarding answer, upload, and taste choice with that identity.
- Support only Google and email magic link for permanent account access; the same entry point creates a new account or logs into an existing one.
- Link or upgrade the anonymous identity to the permanent account without duplicating or losing data.
- Prevent one customer from accessing another customer's images, profile, report, sessions, or bag.
- Route returning customers based on onboarding and analysis status.
- When the Google identity or email already exists, authenticate that account and connect the current anonymous progress after authorization succeeds.

### Profile and preference data

- Store structured profile fields, including gender consent, overall fit preference, favorite brands, garment-type-specific brand sizes, taste choices, feedback, and report version.
- Preserve provenance so the report can distinguish customer-provided facts, visual inferences, explicit swipe preferences, and catalog data.
- Permit customers to correct profile facts and report feedback without requiring total account recreation.

### Image ingestion and lifecycle

- Validate count, type, size, resolution, full-body visibility, duplicate status, and corrupted inputs.
- Encrypt imagery in transit and at rest and restrict access by customer and authorized processing purpose.
- Record upload and processing status without placing raw image content in logs.
- Keep storage duration and lifecycle behavior as an implementation and policy decision; do not make a user-facing automatic-expiration promise in this version.
- Treat AI-generated images of the customer as a distinct derived-asset class with separately approved retention, deletion, consent, and provider-handling rules.

### AI analysis and report generation

- Combine structured profile, garment-type brand sizes, overall fit preference, outfit imagery, extracted garment signals or their approved fallback, and taste choices into a versioned analysis request. Derive a bounded fit profile from stated preference and observed brand/garment-type sizes; preserve uncertainty and never present it as a fit guarantee.
- Return structured report sections, confidence or uncertainty where relevant, evidence references, and actionable recommendations.
- Normalize provider or model errors into customer-visible error, code, and recovery detail.
- Enforce a 120-second user-facing target with processing, slow, completion, and failure states.
- Preserve completed inputs so a retry does not force re-upload unless source imagery is invalid or unavailable.

### Catalog and recommendations

- Ingest enough current product metadata to filter by category, brand, size context, color, silhouette, price, retailer, image, availability indicator, and destination URL.
- Explain recommendation matches through report attributes without revealing internal model reasoning or unsupported claims.
- Recheck material catalog data before retailer handoff and explain when an item is no longer available.

### Live visualization

- Request and enforce camera permission only when the customer begins live styling.
- Maintain explicit connecting, ready, changing-item, slow, failed, and ended states.
- Preserve identity, skin tone, approximate body proportions, and recognizable garment attributes within defined quality thresholds.
- Never represent visualization as a physical fit guarantee.

### Voice interaction

- Request microphone permission separately from camera permission.
- Show listening, interpreting, confirming, acting, and failed states.
- Require visual confirmation for consequential actions such as adding an item or leaving for a retailer.
- Provide equivalent direct controls for every essential voice action.

### Hand-gesture interaction

- Use the already-permitted camera stream to recognize the documented live-session gestures without storing gesture video as a separate product asset.
- Show when gesture control is available, actively observing, interpreting, accepted, ignored, or unavailable.
- Support next outfit, previous outfit, and visible-control selection from a practical standing distance.
- Require confirmation for add-to-bag, retailer handoff, ending the session, or any other consequential gesture action.
- Provide equivalent direct and voice controls for every essential hand-gesture action.

### Retailer handoff

- Maintain canonical product and retailer destinations and capture outbound attribution where permitted.
- Show the retailer boundary before navigation.
- Do not claim that a product is reserved or added to the retailer's cart unless that retailer integration confirms it.

### Operations and observability

- Record processing duration, stage outcome, normalized failure class, recommendation engagement, gesture-recognition outcome, and retailer handoff without logging raw images or unnecessarily sensitive profile fields.
- Provide authorized exception review for failed analysis and account-linking jobs with least-privilege access and an audit trail.

## 11. Data and content requirements

### Customer inputs

- Name and adult confirmation.
- Gender, age or age band, height, optional weight, and overall fit preference (`fitted`, `regular`, `relaxed`, or `varies`), with approved gender consent explaining its styling and shopping purpose.
- Favorite brands and known/unknown sizes by garment type, allowing different sizes within one brand (for example Zara jeans L and Zara tops M).
- Eight to twelve consented full-body images of the customer wearing favorite looks.
- Explicit taste choices from look and garment cards.
- Google account identity or email address for a magic link, plus account/privacy consent.
- Camera and microphone streams only after separate permission.
- Camera-recognized hand-gesture actions during an active live session.
- Report feedback, saved items, bag changes, and retailer handoff actions.

### Product outputs

- Style identity summary and descriptive attributes.
- Existing styling strengths and prioritized opportunities.
- Personalized color palette, neutrals, accents, and combinations.
- Kibbe-informed body-style profile, explanation, uncertainty, and recommended styling implications.
- Silhouette, proportion, layering, fabric, garment, and outfit guidance.
- Personalized product recommendations with rationale and retailer provenance.
- AI-generated wardrobe preview images that combine the customer’s likeness with matched real products when quality, consent, and product-image reuse permission pass; otherwise text and linked product recommendations remain complete.
- Live visualization state plus voice-request and hand-gesture confirmations.
- Bag contents grouped by retailer and external handoff destinations.

### Lifecycle and ownership

- Anonymous onboarding data belongs to the current anonymous identity until it is securely connected to a permanent Google or magic-link account.
- The style profile, report, explicit preferences, saved products, and associated source inputs follow the published storage and account policy; this version makes no automatic-expiration promise.
- Camera and microphone data must not be retained beyond what is explicitly disclosed and necessary for the active session.
- Report copy must identify inference versus customer-provided fact and provide a correction path.

### Exact-copy needs

Copywriting must provide canonical strings for consent, field rationale, upload guidance, Love/Hate/Maybe calibration, anonymous progress, Google and magic-link account connection, processing stages, two-minute expectations, slow and failure recovery, report uncertainty, Kibbe-informed framing, visualization limitations, camera/microphone permissions, hand-gesture guidance, and retailer boundaries.

## 12. Non-functional requirements

### Performance

- Report generation target: display a completed report within 120 seconds of a valid submission.
- At 90 seconds, continue showing a meaningful processing state rather than an indeterminate spinner alone.
- At 120 seconds, transition to the slow state while processing continues and offer email notification and safe exit.
- Frontend interactions outside AI/provider work should acknowledge input within 100 milliseconds and communicate work that lasts longer than one second.
- Live styling latency and fidelity thresholds remain open engineering benchmarks and must be measured before release claims are made.

### Reliability and recovery

- Save onboarding progress after every completed step to the active anonymous or permanent account identity.
- A single photo failure must not invalidate successful uploads.
- Analysis, recommendation, live visualization, voice, and retailer failures must show normalized error details and the next recoverable action.
- Re-entry from another device must restore the latest account-backed completed state.

### Accessibility

- Target WCAG 2.2 AA.
- Support keyboard navigation, visible focus, screen-reader labels, reduced motion, and text alternatives for visual report information.
- Provide Love, Hate, and Maybe buttons plus keyboard controls as alternatives to swipe gestures, and direct controls as alternatives to voice and camera-recognized hand gestures.

### Privacy and security

- Restrict the product to adults for the initial release.
- Use explicit, purpose-specific consent for photo analysis, camera, microphone, and account data.
- Never log raw photos, video, audio, body measurements, or generated sensitive descriptions.
- Prevent cross-account access and require authorization for every sensitive asset and session.

### Safety and trust

- Do not score attractiveness or use shaming, diagnostic, medical, or deterministic language.
- Frame Kibbe as a styling system used to generate recommendations, not an objective body judgment.
- State that visualization is not a fit guarantee and retailer data may change.
- Let customers correct facts, disagree with an inference, and request recalibration.

### Browser and device support

- Support current major versions of Safari, Chrome, Edge, and Firefox for landing, onboarding, and report viewing.
- Define and test the live camera/voice support matrix before launch; when unsupported, explain the limitation and preserve access to the report and recommendations.

### Analytics

- Capture step completion, upload validation outcomes, calibration choice and completion, anonymous-to-permanent account connection, report completion time, report-section engagement, feedback, recommendation selection, live-session starts, voice actions, hand-gesture actions, bag additions, and outbound retailer clicks.
- Do not place sensitive profile values or image-derived labels in analytics payloads.

## 13. Success metrics

All numeric targets below are initial hypotheses until validated.

### Activation

- Visitor-to-onboarding start rate.
- Onboarding completion rate by step and device.
- Percentage of valid submissions receiving a report within 120 seconds.
- Percentage of report recipients who view at least three report sections.

### Usefulness and quality

- Customer-rated accuracy and usefulness for style identity, colors, body-style guidance, and recommendations.
- Percentage of recommendations marked relevant or saved.
- Identity and garment fidelity scores from a representation-diverse evaluation set.
- Rate of report corrections, disagreements, and recalibration requests.

### Engagement and commerce

- Report-to-stylist-home progression.
- Live styling start and completion rate.
- Voice and hand-gesture refinement success rates.
- Recommendation-to-bag rate and outbound retailer click rate.

### Trust and reliability

- Consent comprehension and account-connection success.
- Analysis failure and recovery rates.
- Camera/microphone denial recovery rate.
- Gesture-recognition accuracy, ignored-action rate, and accidental-action rate.
- Support contacts related to account continuity, data use, or harmful report language.

## 14. Outcome-based release phases

### Phase A: Approved frontend definition

Outcome: the intended journey can be evaluated and handed to engineering without inventing behavior. Includes PRD, IA, flows, responsive HTML wireframes, exact copy, company voice, ImageGen screen mockups, and interaction specifications. Readiness: founder approval at every workflow gate and complete screen/story/scenario traceability.

### Phase B: Style Intelligence Golden Path

Outcome: a new customer receives a real personalized style report and curated recommendations. Includes landing, anonymous onboarding, guided profile, 8-12 photos, Love/Hate/Maybe swipe calibration, Google or magic-link account connection, real analysis, report, and initial recommendations. Excludes live video, distance controls, and retailer commerce until their providers and recovery behavior meet release criteria. Validation: report completion, account continuity, two-minute performance, usefulness, and recommendation relevance.

### Phase C: Live Styling

Outcome: a report recipient can try recommended products in a real live session and control it from a practical standing distance. Includes camera permission, live visualization, garment switching, voice control, camera-recognized hand gestures, direct controls, session recovery, and quality measurement. Readiness: representation-diverse fidelity benchmark, disclosed latency, gesture accuracy and accidental-action safeguards, clear failure handling, and no silent provider errors.

### Phase D: Intelligent Refinement

Outcome: a customer can refine recommendations by voice or hand gesture without losing visual context. Includes microphone permission, voice interpretation, gesture interpretation, confirmation, equivalent direct controls, and catalog updates. Readiness: action accuracy, safe confirmation, accessible alternatives, distance usability, and recoverable failures.

### Phase E: Retailer Action

Outcome: a customer can collect chosen products and reach the correct retailer to buy them. Includes Magic Mirror bag, retailer grouping, availability refresh, external-boundary copy, and attributable handoff. Excludes Magic Mirror payment processing and fulfillment.

## 15. Risks, assumptions, open questions, and kill criteria

### Material risks

- Eight to twelve photos may create high onboarding abandonment despite the report's value.
- Image-derived style analysis may reproduce bias or use language customers experience as judgmental.
- Kibbe-informed classification may be unstable, contested, or falsely perceived as objective.
- The one-to-two-minute target may be difficult when multiple image analyses and report generation are combined.
- Favorite-outfit photos may reveal taste but may not provide consistent geometry for body-style analysis.
- Catalog data may be incomplete, stale, or insufficiently structured for explainable recommendations.
- Live video try-on may not yet meet identity, garment, latency, or device-support expectations.
- Voice intent may be ambiguous during high-latency visual updates.
- Hand-gesture recognition may misread ordinary movement, vary by lighting or skin tone, or fail at practical standing distances.
- Anonymous-to-permanent account linking may create duplicate records or lose progress if identity connection is not atomic and recoverable.
- Cross-retailer bag language may imply a universal cart that retailers do not support.

### Working assumptions

- Customers upload photos of themselves, not third parties.
- The initial audience is adult and U.S.-first.
- Weight is optional unless evidence shows it materially improves a disclosed recommendation.
- Gender should guide disclosed styling and shopping context without forcing a binary option; the customer can choose an inclusive option or self-describe.
- The normal report path is automated; human review is an exception.
- Onboarding begins with an anonymous authenticated identity and only Google or email magic link can create or access a permanent account.
- Retailer handoff opens a retailer-owned product or cart destination and does not promise reservation.

### Open questions

- Which analysis, recommendation, catalog, live-try-on, and voice providers meet the required quality and latency?
- Which specific photo poses or image-quality rules are needed in addition to favorite-look evidence?
- What minimum swipe count produces useful calibration without unnecessary fatigue?
- What exact live-session hand gestures are most reliable and least likely to trigger accidentally across devices and bodies?
- What storage duration and lifecycle policy is appropriate after the hackathon?
- Which report sections require expert or legal review before public claims?
- How are affiliate disclosure and retailer attribution handled?
- Which items and retailers form the minimum viable catalog?
- Are Shopify Global Catalog product images permitted inputs for OpenAI-generated report previews or Decart live try-on, and under what authorization?
- What quality bar and failure threshold permit AI-generated customer-likeness previews to appear in a report?

### Kill or reset criteria

- Fewer than half of qualified test users complete the photo and swipe flow after two major onboarding iterations.
- The system cannot produce a useful, respectful report within the two-minute target at an acceptable reliability rate.
- Representation testing reveals persistent harmful or materially lower-quality analysis for a group and mitigation is not available.
- Recommendations do not outperform a simple generic merchandising baseline in blinded user preference testing.
- Live styling cannot preserve identity and garment fidelity well enough to support a clothing decision.
- Live-session gestures cannot be made reliable across the representation test set without unacceptable accidental actions.

## 16. Approval and decisions log

### Approved scope decisions

- 2026-07-19 - Founder - Approved the PRD, user stories, scenarios, and screen inventory as the product and scope foundation for UX design.
- 2026-07-19 - Founder - Approved an inclusive profile field; the later founder amendment standardizes the customer-facing and data term as `gender`, permits inclusive options or self-description, and requires disclosed styling/shopping purpose.
- 2026-07-19 - Founder - Approved weight as an optional profile input.

### Decisions

- 2026-07-18 - Founder - The entry product is a comprehensive style report followed by personalized live styling and retailer shopping.
- 2026-07-18 - Founder - New customers provide profile data, brand sizes, 8-12 favorite-look photos, and swipe-based taste feedback.
- 2026-07-18 - Founder - Permanent account connection occurs after taste inputs and before report delivery.
- 2026-07-18 - Founder - Product capabilities are specified as real target behavior throughout the frontend definition.
- 2026-07-18 - Founder - Report generation should take no more than approximately one to two minutes.
- 2026-07-18 - Founder - Checkout is completed on retailer sites.
- 2026-07-18 - Resolution - The previous single-photo, single-garment V1 is superseded as the primary product definition by the Style Intelligence Golden Path.
- 2026-07-19 - Founder - Taste calibration uses Love, Hate, and Maybe with right, left, and down swipes plus equivalent controls.
- 2026-07-19 - Founder - Onboarding uses an anonymous authenticated session; the unified permanent-account step supports Google and email magic link only and signs up or logs in without losing progress.
- 2026-07-19 - Founder - Live styling supports both voice and camera-recognized hand gestures for distance control, with direct controls retained.
- 2026-07-19 - Founder - Removed the earlier source-photo lifecycle promise and related status interface from the active product scope.
- 2026-07-19 - Founder amendment - Adopted chat-first conversational onboarding v2 for the pre-report journey while preserving the same validated profile contract.
- 2026-07-19 - Founder amendment - Replaced `style presentation` with `gender` across profile, copy, and consent language; the approved field remains inclusive and may be self-described.
- 2026-07-19 - Founder amendment - Made Wardrobe-inspired garment extraction a core step between photo upload and dynamic taste calibration, with partial-failure preservation and a non-blocking fallback.
- 2026-07-19 - Founder amendment - Added AI-generated customer-likeness wardrobe previews to report recommendations when quality, consent, and product-image reuse permission pass, with text-and-linked-product fallback.
- 2026-07-19 - Founder amendment - Selected Gemini Live as the preferred live voice provider while retaining OpenAI for the text agent, report generation, and still-image generation/editing.

### Approval record

Status: **Approved by Talisha White on 2026-07-19 for UX design.**
