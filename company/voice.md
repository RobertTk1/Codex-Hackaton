# Magic Mirror Voice

Status: Approved  
Updated: 2026-07-19  
Owner: Talisha White  
Next gate: Product screen mockups

## Source basis

- Approved report-led PRD, stories, scenarios, and screen inventory
- Approved section-first UX package
- Canonical company profile and living plan
- Audience and market research, including documented trust and representation concerns
- Approved Acid Dispatch / Editorial Edge brand direction
- Explicit founder decisions: chat-first v2 onboarding; name/gender/age/height/optional-weight profile language; Love/Hate/Maybe calibration; Google or magic-link account access; one-to-two-minute report target; generated wardrobe previews with fallback; voice and hand controls; retailer handoff; and no automatic 24-hour photo-deletion promise

## Audience and relationship

Write for adults who want to understand and improve their style without being judged, overwhelmed by fashion jargon, or asked to pretend they already know what works.

Magic Mirror should feel like a perceptive editorial stylist who pays attention, explains the reasoning, and leaves the customer in control. It is not a beauty judge, a body authority, a hype-driven shopping assistant, or a clinical assessment tool.

The reader should feel:

- seen without being scrutinized;
- guided without being ordered around;
- energized without being rushed;
- informed without being buried in theory; and
- safe enough to continue, correct, disagree, or leave.

## Voice traits

### Editorial, not pretentious

Use sharp headlines, confident rhythm, and a strong point of view. Prefer familiar words over insider fashion vocabulary. When a technical or fashion term matters, explain what it changes in practice.

### Affirming, not flattering

Lead with what is already working and frame recommendations as options with a purpose. Do not praise the customer’s appearance, rank bodies, or imply that style guidance fixes a flaw.

### Specific, not absolute

Explain the signal behind a recommendation and what the customer can try next. Use “suggests,” “may,” and “based on” for model-derived findings. Never turn an inference into a fact.

### Energetic, not breathless

Marketing can have edge and momentum. Product states stay short and calm. Avoid exclamation marks, trend-chasing slang, forced sass, and empty excitement.

### Transparent, not defensive

Say what is happening, what information is used, what remains safe, and who controls the next step. State limitations directly without making the product sound broken.

## Voice scales

| Scale | Default | Guidance |
| --- | ---: | --- |
| Formal ↔ Casual | 60% casual | Conversational and direct, but never chatty during consent or errors. |
| Reserved ↔ Energetic | 65% energetic | Strong editorial momentum in marketing; calmer in product states. |
| Plain ↔ Technical | 80% plain | Explain Kibbe-informed and model-derived guidance in ordinary language. |
| Practical ↔ Aspirational | 70% practical | Aspirational headlines must resolve into an action the customer can use. |
| Neutral ↔ Opinionated | 60% opinionated | Offer a clear recommendation while preserving disagreement and correction. |

## Tone by moment

### Marketing

Lead with self-understanding and practical value: a report built from the looks the customer already loves. Use concise editorial headlines and concrete mechanisms. Do not claim attractiveness, guaranteed confidence, perfect fit, scientific accuracy, or proven outcomes.

### Onboarding

Orient before asking. Explain why a field matters, mark optional inputs clearly, show progress, and use action labels that predict the next step.

### Taste calibration

Be quick, tactile, and decisive. Preserve the founder-approved choices `Love`, `Hate`, and `Maybe`. Explain the swipe directions once and keep visible button and keyboard equivalents.

### Waiting and processing

State what is happening and whether the customer can leave. Use meaningful stages, avoid fake precision, and never imply work was lost. At the two-minute threshold, acknowledge the delay and offer notification or safe exit.

### Consent and privacy

Use plain, literal language. Say what access is requested, why it is needed, when it becomes active, and what works without it. Do not make a deletion or retention promise that the product has not approved.

Use `gender` consistently rather than `style presentation`. Explain that it is used only to shape styling and shopping recommendations, allow inclusive options or self-description, and do not imply that gender determines taste or body type.

### Error and recovery

Lead with the problem in human language, then state what remains saved and the next action. Put codes and technical details after the recovery path. Never blame the customer.

### Report findings

Lead with strengths and practical implications. Distinguish customer-provided facts from image- or model-derived inferences. Present color and Kibbe-informed guidance as interpretive tools, not rules or objective judgments.

### Live styling

Keep controls short enough to understand from a distance. Confirm interpreted voice or gesture actions before consequential changes. Always preserve equivalent voice, gesture, and direct controls where required.

### Retailer handoff

Make the boundary unmistakable: Magic Mirror helps select and organize products; the retailer controls current price, stock, checkout, payment, shipping, and returns.

## Vocabulary

### Prefer

- style report
- favorite looks
- your taste
- style signals
- style identity
- color palette
- proportions and silhouettes
- Kibbe-informed style profile
- recommendation rationale
- selected items
- live styling
- visualization
- generated wardrobe preview
- continue to retailer
- based on your profile
- this suggests
- try this next
- your progress is saved

### Avoid

- fix your body
- hide flaws
- problem areas
- flattering / unflattering as universal judgments
- good body / bad body
- perfect for your body
- scientifically proven style
- definitive body type
- guaranteed fit
- true to size unless supplied by the retailer
- looks exactly like
- instant when the approved target is one to two minutes
- checkout with Magic Mirror
- our inventory or our price
- photos delete automatically after 24 hours
- AI magic
- revolutionize, game-changing, ultimate, or effortless

### Customer phrases worth preserving carefully

Research shows anxiety around “a lot of upfront work” and a “big commitment.” Use these ideas to keep onboarding progressive and explain saved progress, but do not present anecdotal phrases as broad customer proof.

## Writing rules

### Sentences and paragraphs

- Prefer active sentences under 20 words for interface copy.
- Put the customer or action before the system when possible.
- Use one idea per sentence and one decision per paragraph.
- Front-load what happened, what is safe, or what to do next.
- Let the interface lead. Copy supports the visual hierarchy; it does not narrate controls the customer can already see.
- Keep the story moving toward the next desirable moment. A line should sell the outcome, provide essential reassurance, or help the customer act—otherwise remove it.
- Never expose internal product language such as sessions, onboarding state, account connection, inference handling, recalibration, interpretation, or preserved inputs in customer-facing copy.
- Avoid exclamation marks unless the founder explicitly approves a celebratory usage.

### Headlines

- Marketing: usually 3–10 words, concrete enough to stand alone.
- Product screens: name the task or state, not the underlying feature architecture.
- Report sections: connect the finding to practical use.
- Do not use a question when a direct statement is clearer.

### CTAs

- Use verb + predictable result: `Get my style report`, `Choose photos`, `See my colors`, `Try another item`.
- Use first person when the action delivers a personal result; use direct verbs for utilities and recovery.
- Never use `Submit`, `Continue` alone when the destination can be named, `Learn more`, or `Click here`.
- Destructive, external, or consequential actions state the result explicitly.

### Labels and helper text

- Labels are nouns or short instructions; never hide required meaning in placeholders.
- Mark optional fields in the label.
- Helper text explains why an input matters or how it will be used.
- Validation names the field and the correction without erasing valid work.

### Accessibility

- Do not rely on color, swipe, gesture, or voice alone.
- Name buttons by outcome and images by purpose, not appearance alone.
- Pair every color swatch with a text label.
- Announce processing and error changes in plain language suitable for live regions.
- Keep distance-control labels short and distinct when read aloud.

## Claims and trust guardrails

- The report structure and one-to-two-minute processing target come from the approved product contract, not measured production performance. Phrase the timing as a design target until analytics prove it.
- Do not claim the report is scientifically objective, medically meaningful, or guaranteed accurate.
- Do not promise physical fit, size, comfort, fabric behavior, retailer availability, price, delivery, or return outcomes.
- Do not fabricate testimonials, logos, ratings, customer counts, conversion results, or retailer partnerships.
- Do not promise automatic photo expiration or deletion timing.
- Describe AI-generated wardrobe previews as styling visualizations, not photographs, fit evidence, or exact depictions. If a preview is unavailable, keep the recommendation and current retailer link complete.
- Distinguish retailer-owned information from Magic Mirror recommendations.
- Never expose sensitive profile values, raw-photo details, or authentication clues in error copy.

## Draft examples

These examples are proposed applications of this draft voice and are not approved copy yet.

| Moment | Draft example |
| --- | --- |
| Landing headline | Your style already has a point of view. |
| Primary CTA | Get my style report |
| Account access | Sign in to Magic Mirror |
| Photo helper | Add 8–12 full-body photos of outfits you feel great in. |
| Processing | Your style report is coming together. |
| Report inference | Your choices suggest that clean lines and deliberate contrast matter more than any single trend. |
| Camera permission | Step into the mirror. |
| Error | We hit a snag. Your answers and photos are safe. |
| Retailer handoff | Ready to shop at the retailer? |

## Before and after

| Avoid | Prefer | Why |
| --- | --- | --- |
| Discover your perfect body type | Explore your Kibbe-informed style profile | Interpretive, useful, and non-judgmental. |
| Submit | Build my report | Predicts the result. |
| Something went wrong | We couldn’t load the next look. Your choices are saved. | Names the failure and preserved work. |
| This color is bad for you | Use this color as an accent when you want more contrast. | Offers intentional use instead of a universal ban. |
| Checkout | Continue to retailer | Keeps commerce ownership accurate. |

## Channel adaptation

- Website: strongest editorial headlines, supported by concrete mechanism and trust boundaries.
- Onboarding: practical, progressive, and explicit about why information is requested.
- Report: interpretive, evidence-aware, affirming, and actionable.
- Live session: minimal, distance-readable, confirmatory, and state-aware.
- Notifications: state the completed result or required action without urgency theater.
- Support and errors: calm, accountable, and recovery-first.

## Approval history

- 2026-07-19: Founder amendment adopted chat-first v2, standardized the profile term as `gender` with disclosed styling/shopping purpose, and added generated wardrobe previews with a text-and-link fallback.
- 2026-07-19: Talisha White approved the customer-facing voice and revised 48-screen copy package for use in product screen mockups.
- 2026-07-19: Founder directed the product to use interface-led, customer-facing copy inspired by QOVES’ outcome progression and Tinker’s restraint. Removed narration of obvious controls and internal implementation/state language from the 48-screen copy manifest.

- 2026-07-19: Draft created from approved product, UX, research, and brand context. Awaiting founder review alongside the copy manifest.
