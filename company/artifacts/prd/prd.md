---
product: Magic Mirror
company: Magic Mirror
version: 0.1.0
date: 2026-07-18
status: Draft
owner: Talisha White
approval_record: Pending founder review
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

The customer enters through an editorial, education-led landing page centered on a comprehensive personal style report. A new customer completes a guided profile, records brand-specific sizing, uploads 8-12 full-body photos of favorite looks, and refines the initial taste model by swiping through looks and garments. Before results are generated, the customer supplies an email address and creates an account. Magic Mirror then delivers the style report within a target of one to two minutes.

The report explains the customer's style identity, existing strengths, highest-value opportunities, color palette, Kibbe-informed body-style profile, recommended silhouettes and proportions, and specific outfit and garment recommendations. From the report, the customer enters a live styling session containing items selected for them, grants camera and microphone access, tries products on through live video, asks for alternatives by voice, collects preferred products in a Magic Mirror bag, and continues to the appropriate retailer to complete checkout.

The current delivery phase is frontend definition. Every screen, requirement, and user-facing message describes the intended real product behavior of analysis, live try-on, voice actions, catalog results, and retailer handoffs.

Key founder decisions:

- Existing customers can log in; first-time customers are directed toward the style-report journey.
- New-account email collection happens after profile inputs and taste calibration but before report generation.
- Report generation should complete within one to two minutes.
- Uploaded source photos are deleted automatically within 24 hours.
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
- User photos and body-related data are sensitive. Consent, data minimization, transparent use, deletion, and respectful language are product requirements.

## 3. Full product vision

Magic Mirror becomes a persistent personal styling environment that understands the customer's visual taste, body-style needs, sizes across brands, preferred colors, real wardrobe behavior, and shopping intent. It can explain recommendations, show them on the customer, refine them conversationally, and connect the customer to products they can buy.

The complete loop is:

1. Learn the person through structured questions, brand-size history, outfit photos, and visual taste choices.
2. Explain the person's style through a useful, editable report rather than an opaque score.
3. Translate the report into specific looks and purchasable items.
4. Let the person experience those items in a live visual styling session.
5. Refine the session through natural voice requests.
6. Send selected items to retailers for purchase.
7. Learn from explicit feedback, saved choices, retailer visits, and future sessions.

The product must help the customer feel more capable and understood. It must not rank attractiveness, shame body characteristics, present an interpretive styling framework as medical fact, or imply that generated visualization guarantees physical fit.

## 4. First coherent frontend experience

### Experience being defined

The frontend package covers the primary journey from public landing page through retailer handoff, including authentication, onboarding, report generation, report exploration, personalized recommendations, live styling, voice interaction, bag review, privacy controls, and material recovery states.

### First functional build outcome

The first functional build proves the style-intelligence promise:

1. A visitor understands the report and begins onboarding.
2. The customer completes the personal and brand-size profile.
3. The customer uploads 8-12 qualifying outfit photos.
4. The customer completes visual taste calibration.
5. The customer creates an account with email.
6. Magic Mirror performs real analysis and returns the report within the one-to-two-minute target.
7. The customer receives real personalized recommendations selected from an available catalog.

The frontend still defines live styling, voice refinement, bag behavior, and retailer handoff as intended real capabilities so later engineering does not have to reconstruct the experience.

## 5. Goals, learning goals, and non-goals

### Customer goals

- Receive a specific, comprehensible description of personal style.
- Understand colors, proportions, silhouettes, and styling changes that are likely to help.
- See recommendations tied directly to the analysis rather than generic trends.
- Try recommended items visually and request alternatives without restarting the session.
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

An authenticated customer revisiting the report, recommendations, styling sessions, bag, or privacy controls. Their job is to continue without repeating completed onboarding.

### AI stylist

The product capability that analyzes inputs, explains findings, selects catalog items, responds to requests, and maintains continuity across the report and live session. The AI stylist must expose uncertainty and recovery rather than invent confidence.

### Product operator or reviewer

An authorized internal actor who can inspect processing failures, catalog eligibility, deletion status, and safety issues without gaining unrestricted access to customer photos. Human review is an exception path, not a hidden requirement for normal report completion.

### Retailer

An external commerce destination that owns product price, availability, cart, payment, fulfillment, returns, and final terms. Magic Mirror must make the boundary clear before handoff.

### Representation and quality dimensions

Testing must cover varied ages within the adult population, skin tones, body shapes, heights, sizes, mobility needs, gender presentations, fashion confidence, photo quality, and device capability. These are quality dimensions, not automatic audience exclusions.

## 7. End-to-end journeys

### Journey A: Discover and begin

1. The visitor lands on a public page that leads with the benefit of understanding personal style.
2. The page previews report sections, shows how inputs become recommendations, explains timing and privacy, and names the limits of visualization.
3. The visitor selects **Get your style report**.
4. If already authenticated and onboarded, the system routes them to their style home. If authenticated but incomplete, it resumes the next incomplete step. Otherwise, onboarding begins without requiring an account upfront.

### Journey B: Build the initial style profile

1. The customer provides a preferred name and confirms they are an adult.
2. The customer supplies age, height, optional weight, and style-presentation information. Each sensitive field explains why it is requested, whether it is required, and how it affects recommendations.
3. The customer selects favorite brands.
4. For each selected brand, the customer may record sizes by relevant category, such as tops, bottoms, dresses, jackets, or shoes.
5. Progress is saved locally or to a recoverable pre-account session so accidental navigation does not erase completed work.

### Journey C: Upload outfit evidence

1. The customer sees photo guidance, consent, the 8-photo minimum, 12-photo maximum, accepted formats, quality requirements, and the 24-hour deletion commitment.
2. The customer uploads full-body photos of themselves wearing favorite looks.
3. Each photo shows upload and validation status independently.
4. The customer can replace, reorder, or remove a photo before continuing.
5. The system blocks continuation until at least eight qualifying photos are available and explains any rejected image in actionable language.

### Journey D: Refine taste through swiping

1. Magic Mirror uses the initial profile and uploaded looks to prepare a sequence of relevant look and garment cards.
2. The customer swipes or uses accessible buttons to choose **More like this**, **Not for me**, or **Save**.
3. A short progress indicator communicates the remaining calibration effort.
4. The system includes a balanced range of silhouettes, colors, styling intensity, and categories rather than repeatedly testing one dimension.
5. The customer can undo the most recent choice.
6. When sufficient signal has been collected, the system explains that the profile is ready for analysis.

### Journey E: Create the account and generate the report

1. The customer supplies an email address and agrees to the account and privacy terms.
2. The system creates or connects the email-based account while preserving all pre-account progress.
3. The analysis screen explains the work being performed and displays meaningful stages without exposing internal implementation.
4. The target is to complete and display the report within 120 seconds.
5. The customer may safely leave; processing continues, and the account can resume the result.
6. If processing exceeds 120 seconds, the product shows a slow state, confirms that inputs are safe, and offers email notification plus a return link.
7. If analysis fails, the product preserves valid inputs, identifies the recoverable step, and offers retry or support. It does not silently discard the session.

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
4. The customer can select another item manually or ask by voice for a meaningful change, such as a different color, silhouette, price range, brand, or occasion.
5. The AI stylist confirms the interpreted request, updates the recommendation set, and explains the most relevant change.
6. If camera, microphone, network, catalog, or generation capability fails, the session preserves selections and provides a recovery path.

### Journey H: Select and shop

1. The customer opens product details without leaving the styling context.
2. The customer adds preferred products to a Magic Mirror bag or removes them.
3. The bag groups items by retailer and shows that price, stock, shipping, returns, and checkout are controlled by each retailer.
4. The customer selects **Continue to retailer** for an item or retailer group.
5. Magic Mirror records the outbound selection event and opens the retailer product or cart destination.
6. Returning to Magic Mirror preserves the report and bag state subject to account and catalog availability.

### Journey I: Return, manage, and delete

1. A returning customer logs in and lands on style home, not onboarding.
2. The customer can revisit the report, continue a session, update sizes, recalibrate taste, or manage data.
3. Uploaded source photos are automatically deleted no later than 24 hours after upload.
4. The customer can request earlier photo deletion and can delete the broader account/profile separately.
5. The data-controls screen distinguishes deleted source imagery from retained derived preferences, report content, saved items, and account data.

## 8. Frontend surfaces and behavior

### Public marketing

The landing page uses an editorial, evidence-oriented report narrative inspired structurally by QOVES: outcome-led hero, report preview, how-it-works sequence, personalized analysis categories, example recommendations, privacy and trust explanation, FAQ, login access, and repeated report CTA. It must use Magic Mirror's own voice, visual identity, report content, and substantiated claims.

### Product shell and navigation

- Pre-account onboarding uses a focused stepper with back, progress, save/recovery behavior, and one primary action.
- Authenticated product navigation provides Style Home, My Report, Live Styling, Saved Items/Bag, and Account & Data.
- Report navigation remains legible on desktop and collapses into a mobile section menu or sticky section control.
- Live styling prioritizes the camera view, active garment, voice state, alternative controls, and add-to-bag action.

### Required state behavior

Every material action must define base, validation, loading or processing, slow, error, recovery, success, permission, and unauthenticated behavior where applicable. No awaited AI or provider action may fail silently.

### Responsive expectations

- Landing page and report support desktop and mobile.
- Onboarding is mobile-first and remains usable on desktop.
- Swipe calibration supports touch, mouse, keyboard, and explicit buttons.
- Live styling supports mobile portrait first, with a desktop composition that preserves equivalent controls.
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

User value: provide meaningful context once without guessing how. Business value: collect the minimum inputs for personalization. Dependencies: field definitions, validation, pre-account recovery. Acceptance: valid progress survives navigation and invalid or missing inputs produce specific remediation.

### Epic C: Outfit-photo collection - must-have

User value: teach Magic Mirror from real personal style evidence. Business value: improve personalization beyond a quiz. Dependencies: upload validation, consent, secure storage, deletion enforcement. Acceptance: 8-12 validated images can be reviewed and edited; each failure is local and recoverable.

### Epic D: Taste calibration - must-have

User value: correct or deepen the inferred taste before analysis. Business value: create explicit preference signals. Dependencies: candidate looks/items and feedback capture. Acceptance: every choice is attributable, undoable, accessible without a swipe, and reflected in analysis inputs.

### Epic E: Email account conversion - must-have

User value: safely receive and revisit results. Business value: create a persistent customer relationship at the moment of demonstrated intent. Dependencies: authentication and pre-account session transfer. Acceptance: account creation preserves completed inputs and handles existing-email recovery.

### Epic F: Style analysis and report - must-have

User value: receive a useful personal explanation and action plan. Business value: deliver the core differentiated outcome. Dependencies: multimodal analysis, report generation, safety rules, catalog taxonomy, async status. Acceptance: the system targets completion within 120 seconds, exposes progress and recovery, and produces all required report sections with traceable recommendations.

### Epic G: Personalized stylist home - must-have

User value: turn report findings into concrete next actions and products. Business value: bridge activation to repeated engagement and commerce. Dependencies: report outputs and eligible catalog. Acceptance: recommendations state why they match the report and never claim unavailable stock or guaranteed fit.

### Epic H: Live styling and voice refinement - should-have for the first engineering release; required in the complete product definition

User value: experience and refine recommendations naturally. Business value: differentiate Magic Mirror from static reports and feeds. Dependencies: camera, live visualization, voice interpretation, catalog filtering, latency controls. Acceptance: the active request, garment, state, and recovery path remain visible; manual controls duplicate voice-critical actions.

### Epic I: Magic Mirror bag and retailer handoff - should-have for the first engineering release; required in the complete product definition

User value: act on confident selections. Business value: create attributable retailer intent. Dependencies: product URLs, retailer grouping, availability refresh. Acceptance: the customer understands the external boundary and can reach the correct retailer destination without losing Magic Mirror state.

### Epic J: Privacy and account controls - must-have

User value: understand and control sensitive data. Business value: establish trust and reduce privacy risk. Dependencies: deletion enforcement and account permissions. Acceptance: raw images are automatically deleted within 24 hours; earlier deletion and account deletion have visible status and confirmation.

## 10. Backend and system implications

These are user-visible capability requirements, not architecture choices.

### Identity and authentication

- Support recoverable pre-account sessions and transfer them to an email-based account.
- Prevent one customer from accessing another customer's images, profile, report, sessions, or bag.
- Route returning customers based on onboarding and analysis status.
- Support existing-email recovery without discarding current progress.

### Profile and preference data

- Store structured profile fields, sensitive-field consent, favorite brands, category-specific sizes, taste choices, feedback, and report version.
- Preserve provenance so the report can distinguish customer-provided facts, visual inferences, explicit swipe preferences, and catalog data.
- Permit customers to correct profile facts and report feedback without requiring total account recreation.

### Image ingestion and lifecycle

- Validate count, type, size, resolution, full-body visibility, duplicate status, and corrupted inputs.
- Encrypt imagery in transit and at rest and restrict access by customer and authorized processing purpose.
- Record upload and deletion timestamps without placing raw image content in logs.
- Delete source photos automatically no later than 24 hours after upload and surface deletion status to the customer.

### AI analysis and report generation

- Combine structured profile, brand sizes, outfit imagery, and taste choices into a versioned analysis request.
- Return structured report sections, confidence or uncertainty where relevant, evidence references, and actionable recommendations.
- Normalize provider or model errors into customer-visible error, code, and recovery detail.
- Enforce a 120-second user-facing target with processing, slow, completion, and failure states.
- Preserve completed inputs so a retry does not force re-upload unless source imagery is invalid or already deleted.

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
- Provide equivalent manual controls for every essential voice action.

### Retailer handoff

- Maintain canonical product and retailer destinations and capture outbound attribution where permitted.
- Show the retailer boundary before navigation.
- Do not claim that a product is reserved or added to the retailer's cart unless that retailer integration confirms it.

### Operations and observability

- Record processing duration, stage outcome, normalized failure class, deletion completion, recommendation engagement, and retailer handoff without logging raw images or unnecessarily sensitive profile fields.
- Provide authorized exception review for failed analysis and deletion jobs with least-privilege access and an audit trail.

## 11. Data and content requirements

### Customer inputs

- Preferred name and adult confirmation.
- Age or age band, height, optional weight, and style-presentation preferences.
- Favorite brands and known sizes by garment category.
- Eight to twelve consented full-body images of the customer wearing favorite looks.
- Explicit taste choices from look and garment cards.
- Email address and account/privacy consent.
- Camera and microphone streams only after separate permission.
- Report feedback, saved items, bag changes, and retailer handoff actions.

### Product outputs

- Style identity summary and descriptive attributes.
- Existing styling strengths and prioritized opportunities.
- Personalized color palette, neutrals, accents, and combinations.
- Kibbe-informed body-style profile, explanation, uncertainty, and recommended styling implications.
- Silhouette, proportion, layering, fabric, garment, and outfit guidance.
- Personalized product recommendations with rationale and retailer provenance.
- Live visualization state and voice-request confirmations.
- Bag contents grouped by retailer and external handoff destinations.

### Lifecycle and ownership

- The customer owns account access and controls deletion requests.
- Source outfit photos expire automatically within 24 hours and may be deleted earlier.
- Derived style profile, report, explicit preferences, and saved products persist with the account until the customer deletes or resets them, subject to the published policy.
- Camera and microphone data must not be retained beyond what is explicitly disclosed and necessary for the active session.
- Report copy must identify inference versus customer-provided fact and provide a correction path.

### Exact-copy needs

Copywriting must provide canonical strings for consent, field rationale, upload guidance, processing stages, two-minute expectations, slow and failure recovery, report uncertainty, Kibbe-informed framing, visualization limitations, camera/microphone permissions, retailer boundaries, and deletion confirmation.

## 12. Non-functional requirements

### Performance

- Report generation target: display a completed report within 120 seconds of a valid submission.
- At 90 seconds, continue showing a meaningful processing state rather than an indeterminate spinner alone.
- At 120 seconds, transition to the slow state while processing continues and offer email notification and safe exit.
- Frontend interactions outside AI/provider work should acknowledge input within 100 milliseconds and communicate work that lasts longer than one second.
- Live styling latency and fidelity thresholds remain open engineering benchmarks and must be measured before release claims are made.

### Reliability and recovery

- Save onboarding progress after every completed step.
- A single photo failure must not invalidate successful uploads.
- Analysis, recommendation, live visualization, voice, and retailer failures must show normalized error details and the next recoverable action.
- Re-entry from another device must restore the latest account-backed completed state.

### Accessibility

- Target WCAG 2.2 AA.
- Support keyboard navigation, visible focus, screen-reader labels, reduced motion, and text alternatives for visual report information.
- Provide buttons as alternatives to swipe gestures and manual controls as alternatives to voice.

### Privacy and security

- Restrict the product to adults for the initial release.
- Use explicit, purpose-specific consent for photo analysis, camera, microphone, and account data.
- Never log raw photos, video, audio, body measurements, or generated sensitive descriptions.
- Delete source photos automatically within 24 hours and expose deletion status.
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

- Capture step completion, upload validation outcomes, calibration completion, account conversion, report completion time, report-section engagement, feedback, recommendation selection, live-session starts, voice actions, bag additions, outbound retailer clicks, and deletion outcomes.
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
- Voice refinement success rate.
- Recommendation-to-bag rate and outbound retailer click rate.

### Trust and reliability

- Consent comprehension and privacy-control discovery.
- Automatic photo-deletion completion rate, target 100% within 24 hours.
- Analysis failure and recovery rates.
- Camera/microphone denial recovery rate.
- Support contacts related to unexpected data retention or harmful report language.

## 14. Outcome-based release phases

### Phase A: Approved frontend definition

Outcome: the intended journey can be evaluated and handed to engineering without inventing behavior. Includes PRD, IA, flows, responsive HTML wireframes, exact copy, company voice, ImageGen screen mockups, and interaction specifications. Readiness: founder approval at every workflow gate and complete screen/story/scenario traceability.

### Phase B: Style Intelligence Golden Path

Outcome: a new customer receives a real personalized style report and curated recommendations. Includes landing, guided profile, 8-12 photos, swipe calibration, email account conversion, real analysis, report, privacy controls, and initial recommendations. Excludes live video, voice control, and retailer commerce until their providers and recovery behavior meet release criteria. Validation: report completion, two-minute performance, usefulness, recommendation relevance, and photo deletion.

### Phase C: Live Styling

Outcome: a report recipient can try recommended products in a real live session. Includes camera permission, live visualization, garment switching, session recovery, and quality measurement. Readiness: representation-diverse fidelity benchmark, disclosed latency, clear failure handling, and no silent provider errors.

### Phase D: Conversational Refinement

Outcome: a customer can refine recommendations by voice without losing visual context. Includes microphone permission, request interpretation, confirmation, equivalent manual controls, and catalog updates. Readiness: action accuracy, safe confirmation, accessible alternatives, and recoverable failures.

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
- Cross-retailer bag language may imply a universal cart that retailers do not support.

### Working assumptions

- Customers upload photos of themselves, not third parties.
- The initial audience is adult and U.S.-first.
- Weight is optional unless evidence shows it materially improves a disclosed recommendation.
- Style-presentation choices should guide shopping and recommendation context without forcing a binary identity label.
- The normal report path is automated; human review is an exception.
- Retailer handoff opens a retailer-owned product or cart destination and does not promise reservation.

### Open questions

- Which analysis, recommendation, catalog, live-try-on, and voice providers meet the required quality and latency?
- Which specific photo poses or image-quality rules are needed in addition to favorite-look evidence?
- What minimum swipe count produces useful calibration without unnecessary fatigue?
- What account verification method best preserves the two-minute report flow?
- Which report sections require expert or legal review before public claims?
- How are affiliate disclosure and retailer attribution handled?
- Which items and retailers form the minimum viable catalog?

### Kill or reset criteria

- Fewer than half of qualified test users complete the photo and swipe flow after two major onboarding iterations.
- The system cannot produce a useful, respectful report within the two-minute target at an acceptable reliability rate.
- Representation testing reveals persistent harmful or materially lower-quality analysis for a group and mitigation is not available.
- Automatic source-photo deletion cannot be verified.
- Recommendations do not outperform a simple generic merchandising baseline in blinded user preference testing.
- Live styling cannot preserve identity and garment fidelity well enough to support a clothing decision.

## 16. Approval and decisions log

### Pending approval

- Approve this Draft PRD as the product and scope foundation for UX design.
- Confirm the inclusive interpretation of the founder's requested male/female input: collect style-presentation and shopping context, and request sex-related data only if a disclosed analysis dependency makes it necessary.
- Confirm that weight remains optional.
- Confirm that source photos expire within 24 hours while derived style-profile and report data persist until account deletion or reset.

### Decisions

- 2026-07-18 - Founder - The entry product is a comprehensive style report followed by personalized live styling and retailer shopping.
- 2026-07-18 - Founder - New customers provide profile data, brand sizes, 8-12 favorite-look photos, and swipe-based taste feedback.
- 2026-07-18 - Founder - Email account creation occurs after taste inputs and before report delivery.
- 2026-07-18 - Founder - Product capabilities are specified as real target behavior throughout the frontend definition.
- 2026-07-18 - Founder - Report generation should take no more than approximately one to two minutes.
- 2026-07-18 - Founder - Uploaded source photos may be deleted automatically after 24 hours.
- 2026-07-18 - Founder - Checkout is completed on retailer sites.
- 2026-07-18 - Resolution - The previous single-photo, single-garment V1 is superseded as the primary product definition by the Style Intelligence Golden Path.

### Approval record

Status: **Draft - awaiting explicit founder approval before UX design.**
