# Magic Mirror Audience Definition Report

**Research date:** July 17, 2026

**Geography:** United States first

**Product boundary:** Hackathon V1 supports one user photo, one garment, and one near-real-time visualization. It does not promise physical fit and does not include a persistent closet, multi-garment outfits, voice, or deep stylist reasoning.

## Decision Summary

### Primary Beachhead

**U.S. online apparel shoppers actively deciding whether to buy one garment for a near-term, personally important occasion.**

The qualifying behavior is more important than age, gender, income, or fashion expertise. The shopper:

- has one identifiable garment under active consideration;
- expects to decide within seven days, often sooner;
- feels retailer imagery, reviews, or size information does not provide enough visual confidence;
- can provide or capture one current full-body photo;
- wants a fast second opinion—buy, skip, save, or share—not a complete wardrobe system; and
- understands that visualization cannot guarantee size, fabric behavior, comfort, or physical fit.

Examples of triggering occasions include a wedding, interview, date, trip, celebration, presentation, or another purchase whose social or financial consequence makes uncertainty feel urgent. These examples are **hypotheses to rank in interviews**, not proven demand categories.

The segment scores **80/100** on the required attractiveness model. Overall selection confidence is **Medium**: the underlying visualization problem is well evidenced, but the occasion trigger, willingness to upload, decision impact, and repeat rate have not been observed in Magic Mirror users.

### Secondary or Expansion Segment

**Social-first frequent fashion shoppers who regularly use creators, reviews, or communities to evaluate apparel.**

This segment scores **69/100**. It is highly reachable and may use the product more frequently, but its urgency is less consistent and it already has abundant free inspiration and try-on alternatives. Expand here only after the beachhead demonstrates that Magic Mirror changes decisions rather than merely generating shareable novelty.

**Creators and stylists are a later distribution and influence layer, not the V1 end customer.** They can demonstrate the flow and provide trusted second opinions after the consumer experience works, but professional content, client management, and monetization workflows would expand product scope.

### Segments to Defer

- **Shoppers underrepresented by retailer models as a standalone acquisition segment:** keep them as a mandatory research and quality cohort across the beachhead. The pain is credible, but targeting people by body, age, skin tone, or other identity traits before provider performance is proven would overpromise and turn representation into demographic shorthand.
- **General digital-wardrobe optimizers:** defer because full-closet cataloging conflicts with V1 and users describe setup as burdensome.
- **Professional creators and stylists as paying users:** defer until the basic decision output is trusted and shareable.
- **Retailers and brands:** defer because retailer integrations, enterprise proof, procurement, and return/conversion measurement require a different product and buying motion.
- **Novelty-only AI image users:** avoid as a primary audience; they may generate usage without validating purchase-decision value or retention.

### Confidence and Key Assumptions

| Conclusion or assumption | Confidence | Why |
|---|---|---|
| Online apparel shoppers experience a visualization and representation gap | High | Google/Ipsos found 42% did not feel represented by model images and 59% had received an item that looked different than expected. ([Google](https://blog.google/products-and-platforms/products/shopping/ai-virtual-try-on-google-shopping/)) |
| One active purchase is a better V1 entry point than a full closet | Medium-high | It maps directly to the product boundary, while community evidence identifies closet setup and portability friction. ([Reddit](https://www.reddit.com/r/capsulewardrobe/comments/1onp0dk/do_yall_use_digital_closet_apps/)) |
| A near-term occasion creates enough urgency to drive activation | Low | Strategically plausible and common in styling products, but no Magic Mirror interviews or behavior data exist. |
| The shopper will upload a real photo to an unknown product | Low | Privacy and representation risks are documented; Magic Mirror has not tested consent, trust, or deletion messaging. |
| The shopper will pay after receiving value | Low | Competitor prices provide anchors, not Magic Mirror willingness-to-pay evidence. |
| Social-first shoppers are a reachable expansion audience | Medium | Pew found product-review behavior is common among TikTok users, especially younger users, but this is not apparel-specific or proof of acquisition efficiency. ([Pew Research Center](https://www.pewresearch.org/short-reads/2024/11/21/a-majority-of-us-tiktok-users-are-there-for-reviews-and-recommendations/)) |
| Representation-seeking shoppers can be served reliably | Low | Pain is strong, but identity, body, skin-tone, and garment fidelity must pass provider benchmarks first. |

## Evidence Base

### Inputs Reviewed

- [Magic Mirror market research evidence base](../market_research/market_research.md)
- [Magic Mirror market research executive report](../market_research/market_research_report.md)
- [Magic Mirror company profile](../../company.md)
- [Magic Mirror living plan](../../plan.md)
- U.S. Census, BEA/FRED, Google/Ipsos, Pew Research Center, NRF/Happy Returns, FTC, state privacy authorities, peer-reviewed research, official competitor product/pricing pages, and traceable community discussions cited in the market research.

No customer interviews, CRM records, product analytics, sales conversations, paid-channel data, or Magic Mirror prototype sessions were available.

### Strongest Signals

1. **The evaluation problem is observable.** Representation and expectation mismatch appear in a direct survey of U.S. online clothing shoppers. ([Google/Ipsos](https://blog.google/products-and-platforms/products/shopping/ai-virtual-try-on-google-shopping/))
2. **The product interaction is legible.** Google and Walmart have already normalized own-photo apparel try-on, reducing the need to explain the mechanic. ([Google](https://blog.google/products-and-platforms/products/shopping/studio-quality-digital-try-on/); [Walmart](https://corporate.walmart.com/news/2022/09/15/walmart-levels-up-virtual-try-on-for-apparel-with-be-your-own-model-experience))
3. **Decision support already happens socially.** Product recommendations are a stated reason for using TikTok among 62% of U.S. adult users and 74% of users ages 18–29. This supports creator/community discovery but does not justify an age-restricted ICP. ([Pew](https://www.pewresearch.org/short-reads/2024/11/21/a-majority-of-us-tiktok-users-are-there-for-reviews-and-recommendations/))
4. **A no-closet flow removes documented friction.** Community discussions call digital-closet adoption “a lot of upfront work” and a “big commitment.” ([Reddit discussion one](https://www.reddit.com/r/capsulewardrobe/comments/1onp0dk/do_yall_use_digital_closet_apps/); [discussion two](https://www.reddit.com/r/capsulewardrobe/comments/1lfvsre/recommendations_for_digital_closet_app_can_i_back/))
5. **Willingness to pay is constrained.** Consumer alternatives offer free tiers and common paid tiers around $5–$10 per month. ([Acloset](https://apps.apple.com/us/app/acloset-ai-fashion-assistant/id1542311809); [AI Closet](https://www.aicloset.io/); [Sty AI](https://styai.app/))
6. **A render must earn trust.** Controlled research found that a weak AR try-on can underperform imagery of physically similar models, while technical research documents identity and garment-detail limitations. ([Journal of Retailing and Consumer Services](https://www.sciencedirect.com/science/article/pii/S0969698918311834); [Google Research](https://research.google/pubs/mm-vto-multi-garment-virtual-try-on-and-editing/))

### Evidence Gaps

- Which real purchase occasions produce the most urgent and frequent need.
- How recently the beachhead experienced an uncertain apparel decision.
- Whether the beachhead will upload a current full-body photo and under what deletion promise.
- Which input method—photo plus screenshot, garment upload, URL, or share sheet—is most natural.
- Whether the output changes buy/skip/save/share behavior rather than only increasing curiosity.
- What quality threshold is required across body shapes, skin tones, ages, garment silhouettes, logos, and text.
- How long users will wait before abandoning a render.
- Whether the same shopper has another relevant decision within 30 days.
- Whether the user will pay, accept credits, or only use a free affiliate-supported product.
- Which acquisition channels produce activated decisions at a sustainable cost.
- Whether a trusted friend or creator meaningfully increases activation and trust.

## Segmentation Method

The report uses observable B2C dimensions that change need, product scope, or reachability:

1. **Situation:** active purchase, ongoing browsing, wardrobe management, professional advice, or retailer operations.
2. **Trigger and urgency:** a decision within days versus an indefinite desire to improve style.
3. **Behavior:** one-item evaluation, frequent social discovery, closet cataloging, advising others, or managing retail conversion.
4. **Current method:** model/review search, friend or creator opinion, buy-and-return, digital closet, or retailer tooling.
5. **Desired outcome:** decide on one item, find inspiration, improve representation, manage a wardrobe, monetize advice, or change retail economics.
6. **Buying motion:** individual consumer, influenced consumer, professional subscription, or enterprise procurement.

Age, gender, race, income, body shape, and skin tone are not defining segmentation variables here. Some materially affect model representation and product quality, so they belong in recruitment and provider testing. The earlier “ages 18–44” shorthand is replaced by a behavioral ICP; only adults should participate in initial validation to avoid introducing parental-consent complexity before photo policy is settled.

## Candidate Segment Overview

| Segment | Observable definition | Problem and trigger | Buyer/user | Current alternative | Reachable where | Evidence | Confidence |
|---|---|---|---|---|---|---|---|
| Near-term occasion item deciders | One garment under active consideration; decision expected within seven days; wants visual confidence | Personally important purchase creates an immediate “buy or skip?” decision | Consumer is buyer, decision-maker, and user | Retailer imagery, reviews, similar creators, friend, fitting room, buy-and-return | Search/product pages, occasion communities, creator demonstrations, trusted shares | Visualization gap is direct; occasion intensity is inferred | Medium |
| Social-first frequent fashion evaluators | Regularly uses creators, reviews, or communities when considering apparel | Frequent discovery creates repeated but variably urgent uncertainty | Consumer buyer/user; creators and peers influence | TikTok/Instagram/Pinterest content, Google, retailer VTO, comments, friends | Short-form video, creators, social search, fashion communities | Pew supports product-recommendation behavior; apparel conversion unknown | Medium |
| Representation-seeking shoppers | Routinely cannot map retailer models onto their body, age, skin tone, or presentation | Item imagery feels irrelevant or misleading during consideration | Consumer buyer/user; similar-looking reviewers may influence | Search for similar models/reviewers, physical try-on, buy-and-return | Inclusive fashion communities, retailer reviews, trusted creators | Google/Ipsos supports pain; reach and provider performance uncertain | Medium-low |
| Digital-wardrobe optimizers | Wants to catalog owned clothes and plan repeated outfits | Persistent organization and wardrobe-use problem | Consumer buyer/user | Acloset, Indyx, spreadsheets, photo albums, memory | Closet/capsule communities and app stores | Recurring need and competitor demand exist; setup friction is clear | Medium |
| Creator or stylist decision partners | Repeatedly advises others and could use visual output in content/client work | Needs faster, credible ways to show an item on a follower/client | Professional buyer/user; audience or client influences | Manual mockups, video, styling boards, affiliate content | Creator networks, stylist communities, direct outreach | Human styling has paid value; V1 professional need is untested | Low |
| Apparel retailers or brands | Operates meaningful online apparel volume and measures conversion/returns | Persistent economic uncertainty and returns; requires proof and integration | Executive/e-commerce buyer; product/engineering champions; shopper user | Google, Veesual, internal imagery/tools, return operations | Industry networks and outbound sales | Buyer pain exists; Magic Mirror lacks B2B proof and product fit | Medium-low |

## Segment Attractiveness Scorecard

Scores use the required model: `Σ(criterion score × criterion weight) ÷ 5 = score out of 100`. Each criterion is scored 1–5. Parentheses show evidence confidence: **H** high, **M** medium, **L** low. Confidence does not change the attractiveness score.

| Segment | Problem intensity 20 | Urgency 15 | Frequency 10 | Willingness to pay 15 | Reachability 15 | Product fit 15 | Adoption 10 | Score / 100 | Overall evidence confidence |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| Near-term occasion item deciders | 5 (M) | 5 (L) | 2 (L) | 2 (L) | 4 (M) | 5 (M) | 4 (M) | **80** | Medium |
| Social-first frequent fashion evaluators | 3 (M) | 3 (L) | 5 (M) | 2 (L) | 5 (H) | 3 (M) | 4 (M) | **69** | Medium |
| Representation-seeking shoppers | 5 (H) | 3 (L) | 4 (M) | 2 (L) | 3 (L) | 3 (L) | 3 (M) | **67** | Medium-low |
| Creator or stylist decision partners | 3 (L) | 3 (L) | 5 (M) | 3 (L) | 4 (M) | 2 (H) | 3 (M) | **64** | Low |
| Apparel retailers or brands | 5 (M) | 3 (M) | 5 (H) | 4 (L) | 2 (L) | 1 (H) | 1 (H) | **62** | Medium-low |
| Digital-wardrobe optimizers | 3 (M) | 2 (M) | 5 (M) | 3 (M) | 3 (M) | 2 (H) | 2 (H) | **56** | Medium |

### Score Evidence and Uncertainty

- **Near-term occasion item deciders:** the score is driven by high trigger clarity and exact V1 fit. The visualization pain is sourced, but occasion urgency, low frequency, reachability, and willingness to pay remain assumptions. The one-photo flow keeps adoption friction lower than a closet app.
- **Social-first evaluators:** Pew supports strong channel reach and product-recommendation behavior. Frequency is plausible, while apparel-specific urgency, conversion, and paid value are unknown. Free creator and platform alternatives weaken differentiation.
- **Representation-seeking shoppers:** Google/Ipsos provides the strongest direct pain evidence. Product fit and adoption confidence remain low because serving the segment requires demonstrated fidelity across identity and body representation, not merely inclusive messaging.
- **Creators/stylists:** repeated advisory work raises possible frequency, and Indyx shows human styling can command payment. V1 lacks client, workflow, batch, attribution, and professional-output features, so product fit is low with high confidence.
- **Retailers/brands:** NRF supports persistent economic returns pressure, and B2B competitors show budget can exist. Magic Mirror has no conversion/return proof, integration, security review, catalog feed, procurement path, or enterprise support, making current fit and adoption low. ([NRF](https://nrf.com/media-center/press-releases/consumers-expected-to-return-nearly-850-billion-in-merchandise-in-2025); [Veesual](https://www.veesual.ai/vto/blog/virtual-try-on-styling-fitting))
- **Digital-wardrobe optimizers:** competitor pricing and community behavior support a recurring problem and some paid value, but closet setup directly violates the V1 boundary and creates documented adoption friction.

### Sensitivity Check

The primary segment leads the base score by 11 points, but the ranking is not fully robust because its decisive criteria are unvalidated.

| Scenario | Changed assumptions | Result |
|---|---|---:|
| Beachhead pessimistic | Urgency 4, willingness to pay 1, reachability 3, product fit 4 | **68** |
| Social-first optimistic | Problem intensity 4, urgency 4, willingness to pay 3, product fit 4 | **82** |
| Representation segment optimistic | Reachability 4, product fit 5, adoption 4 after a strong provider benchmark | **78** |

Under a combined pessimistic beachhead case and optimistic social-first case, the ranking flips. The decisive question is whether a near-term occasion produces meaningfully higher upload and decision-completion rates than general fashion browsing. Representation-seeking shoppers can also become a stronger audience only if quality testing proves Magic Mirror serves them reliably.

The cheapest discriminating test is a message-and-concierge experiment that recruits the same traffic into either “decide on one important item” or “try on anything you discover,” then compares qualified-start, real-photo upload, completed-decision, and stated usefulness rates.

## Recommended Targeting Strategy

### Why This Beachhead

1. **It maps exactly to V1.** One person, one item, one decision requires no speculative feature.
2. **The trigger is measurable.** The team can require a real item and decision date rather than relying on interest in AI fashion.
3. **The value is observable.** The user can record buy, skip, save, or share before and after the result.
4. **It minimizes setup.** No account history or wardrobe catalog is necessary for first value.
5. **It exposes the launch-critical risks quickly.** Real decisions reveal whether fidelity, latency, privacy, and honesty are good enough.
6. **It supports a clean expansion path.** Successful item decisions can later create taste memory, repeat use, creator sharing, and attributable purchases.

### Anti-ICP and Disqualifiers

For the hackathon and first validation cohort, defer or disqualify someone who:

- wants a guarantee of size, comfort, fabric behavior, or physical fit;
- has no specific garment or purchase decision;
- is using the tool only for fantasy transformation or image entertainment;
- needs multi-garment outfit assembly, a closet audit, voice styling, or professional consultation;
- cannot provide a compatible, consented source photo and garment image;
- is unwilling to accept the stated photo handling and deletion policy;
- needs a garment category the selected provider cannot render reliably;
- is under 18 during initial research, until consent and photo policy explicitly address minors; or
- requires an enterprise integration, catalog feed, analytics, or contractual service level.

Disqualification should protect trust and evidence quality, not judge the shopper’s body, style, budget, or fashion knowledge.

### Expansion Sequence

1. **Beachhead:** near-term occasion item deciders.
2. **Behavioral expansion:** social-first frequent evaluators who repeatedly consider items and share outcomes.
3. **Trust/distribution expansion:** creators, friends, and stylists as opinion partners after shareable results prove useful.
4. **Retention expansion:** cross-retailer decision memory and lightweight taste learning after repeat decisions are observed; do not require a full closet.
5. **Professional/B2B exploration:** creator tools and retailer pilots only after consumer decision impact and provider economics are measurable.

Representation-seeking shoppers must be included throughout research and quality testing. They are not postponed as people; only an unproven representation marketing claim is postponed.

## Ideal Customer Profile

### Qualifying Characteristics

The V1 ICP is behavioral and situational:

- U.S.-based adult online apparel shopper for initial validation.
- Has one garment under serious consideration from any compatible retailer or image source.
- Expects to decide within seven days.
- Feels uncertain after viewing available product imagery, reviews, or model photos.
- Has a personally meaningful reason to reduce uncertainty.
- Can upload or capture a current full-body photo and consents to clearly stated processing.
- Wants visual purchase support, not a physical fit guarantee.
- Willing to record the decision outcome and what appeared inaccurate.

Helpful but not required qualifiers:

- Shops across multiple retailers.
- Already seeks second opinions from friends, creators, reviews, or communities.
- Has previously returned or skipped an item because imagery did not translate to their appearance.
- Is willing to revisit after the real-world outcome to assess whether the visualization helped.

### Problem, Context, and Trigger

**Problem:** “I can see the garment, but I cannot confidently picture it on me well enough to decide.”

**Context:** The shopper is between discovery and checkout. Retailer models, reviews, or similar-person imagery are insufficient, while visiting a fitting room or buying multiple options costs time and effort.

**Trigger:** A specific item becomes decision-worthy and the cost of choosing poorly feels higher because of timing, social consequence, price, limited availability, or prior disappointment.

### Desired Outcome

Make a defensible buy, skip, save, or share decision faster, with a personally relevant visualization and honest awareness of what remains unknown.

Success is not “the image looked impressive.” Success is “the shopper made a more confident decision without being misled about physical fit.”

### Current Alternatives

- Search product reviews and customer photos.
- Find a creator or model with a similar appearance.
- Ask a friend, partner, stylist, or online community.
- Use Google Shopping or retailer-native try-on.
- Visit a physical store or fitting room.
- Order multiple options and return rejects.
- Skip the purchase because uncertainty is too high.

### Buying Roles and Process

| Role | V1 actor | Role in the decision | Evidence/confidence |
|---|---|---|---|
| Economic buyer | The shopper if a paid offer is tested | Pays for credits/subscription or chooses a free affiliate-supported flow | Low; Magic Mirror willingness to pay is untested |
| Decision-maker | The shopper | Decides whether to use Magic Mirror and whether to buy the garment | High; direct B2C workflow |
| User | The shopper | Supplies photo/item, receives result, records decision | High; product definition |
| Champion | A shopper who found the result useful | Returns, shares a result, or introduces a friend | Low; no advocacy data exists |
| Influencer | Trusted friend, creator, reviewer, partner, or community | Shapes whether the shopper trusts the item or result | Medium; social recommendation and status-quo evidence |
| Blocker | No formal human blocker in V1 | Privacy concern, poor fidelity, slow output, unsupported garment, or fit overclaim can stop adoption | High for risk existence; thresholds untested |
| Revenue partner | Retailer or affiliate network | May pay an attributed commission after checkout | Low; economics and access are assumptions |

Likely V1 process:

1. Discover one garment.
2. Feel unresolved uncertainty.
3. Encounter Magic Mirror directly or through a trusted share/demo.
4. Review consent, photo handling, and limitations.
5. Submit photo and garment.
6. Wait through clear generation states.
7. Assess visual fidelity and decision guidance.
8. Buy, skip, save, or share.
9. Optionally report the later real-world outcome.

### Budget and Willingness to Pay

- **Observed category anchors:** free tiers are common; Acloset, AI Closet, and Sty AI show common consumer tiers from roughly $4 to $10 per month, with broader premium tiers above that.
- **Magic Mirror evidence:** none. No one has paid, attempted checkout, or completed a pricing conversation.
- **Initial hypothesis:** first value should be testable without a subscription commitment. A $5.99 monthly reference point or a transparent credit pack can be exposed only after a successful decision, without charging in the first smoke test.
- **Decision rule:** do not select a business model from competitor pricing alone. Compare real paywall intent, affiliate attribution, generation cost, and repeat frequency.

### Evaluation Criteria and Proof Required

The beachhead will judge:

1. **Identity fidelity:** “Does this still look like me?”
2. **Garment fidelity:** “Did it preserve the item’s silhouette, color, texture, logos, and defining details?”
3. **Representation integrity:** “Did it preserve skin tone and approximate body proportions without beautifying or distorting me?”
4. **Decision usefulness:** “Did this help me buy, skip, save, or ask someone?”
5. **Latency and reliability:** “Did the result arrive while the decision still mattered?”
6. **Honesty:** “Does the product distinguish appearance visualization from fit prediction?”
7. **Privacy control:** “What was stored, who processed it, and can I delete it?”
8. **Cross-retailer convenience:** “Can I use the item I actually found without rebuilding a closet?”

Proof required before strong marketing claims:

- benchmark results across a representation-diverse test set;
- supported garment categories and visible limitations;
- p50/p95 latency and failure-rate evidence;
- a documented retention/deletion policy and provider data path;
- real user decisions and qualitative accuracy feedback;
- repeat-use and paid-intent evidence; and
- measured purchase/return outcomes before claiming conversion or return impact.

### Objections, Anxieties, and Switching Costs

| Objection or anxiety | Evidence status | Product response required |
|---|---|---|
| “It may invent a better-looking but inaccurate version of me.” | Technical and community trust risk | Preserve identity; show supported conditions; collect “what looks wrong?” feedback |
| “This cannot tell me if the size will fit.” | Known product boundary | Say so before and after generation; never use fit-guarantee language |
| “I do not know what happens to my photo.” | Documented privacy risk | Plain-language consent, minimal retention, deletion control, provider disclosure |
| “Google or the retailer already does this for free.” | High-confidence competitive fact | Lead with cross-retailer decision support and honesty; prove value beyond rendering |
| “I do not want to upload my whole closet.” | Traceable community friction | Require one photo and one garment only |
| “I may only need this once.” | High-risk assumption | Avoid forced subscription; test repeat triggers and credits/free economics |
| “A friend’s opinion is more trustworthy.” | Status-quo behavior | Make results easy to share; complement trusted people rather than replace them |

Switching cost into Magic Mirror should be intentionally low: one current decision, no data migration, no closet setup. Switching away is also low, so retention must come from better decisions and accumulated preference evidence—not lock-in.

### Activation and Retention Conditions

**Activated user:** completes a real-photo and real-garment session, receives a result, and records buy/skip/save/share plus a usefulness/fidelity response.

Activation requires:

- compatible inputs and supported garment category;
- consent and sufficient privacy trust;
- a result within the accepted wait threshold;
- recognizable identity and garment;
- clear next action and uncertainty boundary.

Retention requires:

- another real apparel decision within a reasonable interval;
- confidence that prior feedback improves the next experience;
- lightweight access to prior decisions without full closet setup;
- continued privacy control;
- more value than free search/retailer try-on; and
- optional trusted sharing or real-world outcome feedback.

## Buyer and User Personas

These are behavioral archetypes, not fictional biographies.

### Persona 1 — High-Intent Item Decider

| Field | Detail | Evidence | Confidence |
|---|---|---|---|
| Role in purchase and use | Economic buyer, decision-maker, and user | Direct B2C flow | High |
| Job to be done | Decide whether one garment is worth buying for a near-term important use | Product/market synthesis | Medium |
| Pain and trigger | Retailer imagery does not translate to the shopper; decision deadline raises stakes | Google/Ipsos supports pain; urgency untested | Medium-low |
| Desired outcome | A fast buy/skip/save/share decision with fewer visual unknowns | Inferred from job | Medium |
| Current workaround | Reviews, similar creators/models, friend, fitting room, buy-and-return | Market research | Medium-high |
| Decision criteria | Identity and garment fidelity, speed, honesty, privacy, no closet setup | Technical/privacy evidence and product boundary | Medium-high |
| Objections and anxieties | Fake-looking result, fit overclaim, photo retention, free alternatives, one-time need | Competitor and risk evidence | High for existence; low for prevalence |
| Trusted sources | Friends, creators, customer reviews, retailer imagery, communities | Pew and status-quo evidence | Medium |

### Persona 2 — Social-First Frequent Evaluator

| Field | Detail | Evidence | Confidence |
|---|---|---|---|
| Role in purchase and use | Consumer buyer/user; may also share results and influence peers | Expansion hypothesis | Medium-low |
| Job to be done | Rapidly evaluate items discovered through creators or social feeds without leaving the decision unresolved | Inference from social product-recommendation behavior | Medium-low |
| Pain and trigger | High discovery volume creates repeated uncertainty, but many items are low stakes | Pew supports channel behavior, not apparel intensity | Medium |
| Desired outcome | Quick visual triage and a shareable second opinion | Inference | Low |
| Current workaround | Creator content, comments, screenshots, polls, Google, retailer pages | Market workflow | Medium |
| Decision criteria | Speed, mobile convenience, shareability, novelty, credible result | Inference; not directly observed | Low |
| Objections and anxieties | Free substitutes, upload friction, inconsistent quality, subscription fatigue | Competitive evidence | Medium |
| Trusted sources | Creators, friends, communities, visible customer examples | Pew and status-quo evidence | Medium |

### Persona 3 — Trusted Opinion Partner

| Field | Detail | Evidence | Confidence |
|---|---|---|---|
| Role in purchase and use | Influencer, not initial economic buyer; may be a friend, creator, or stylist | Status-quo and social evidence | Medium |
| Job to be done | Help the shopper judge an item quickly using a personally relevant visual | Inference | Low |
| Pain and trigger | Existing product images do not show the shopper, and verbal advice lacks visualization | Inference | Low |
| Desired outcome | Give a credible second opinion without recreating the outfit manually | Inference | Low |
| Current workaround | Messages, screenshots, comments, mood boards, live calls, manual mockups | Market research | Medium |
| Decision criteria | Result credibility, context, easy sharing, no requirement to create an account | Inference | Low |
| Objections and anxieties | Misleading the shopper, unnatural image, hidden affiliate bias, privacy | Risk synthesis | Medium-low |
| Trusted sources | Their own judgment, retailer details, reviews, prior knowledge of the shopper | Role logic; not directly researched | Low |

## Jobs, Pains, and Desired Gains

| Job | Pain or friction | Desired gain | Evidence status |
|---|---|---|---|
| Visualize one item personally | Retailer models do not represent the shopper or delivered item differs from expectation | Personally relevant appearance evidence | Direct Google/Ipsos survey |
| Decide before a deadline | Uncertainty persists while event timing or inventory creates pressure | Faster buy/skip/save/share decision | Trigger hypothesis; requires interviews |
| Get a second opinion | Friend/creator advice is available but fragmented and not visualized on the shopper | Shareable result that improves the conversation | Status quo observed; product effect untested |
| Avoid unnecessary setup | Closet apps require cataloging and create portability concerns | First value from one photo and one garment | Traceable community anecdotes |
| Protect self-image and privacy | Generative errors may distort identity; photo processing is sensitive | Honest representation and deletion control | Technical and regulatory evidence |
| Learn across later decisions | Free tools treat each item as a disconnected render | Optional preference memory that improves future decisions | Strategic inference; outside V1 |

## Customer Language

Use traceable language as research prompts, not as claims of prevalence:

- “A lot of upfront work” and “soooo much time” describe digital-closet setup. ([Reddit](https://www.reddit.com/r/capsulewardrobe/comments/1onp0dk/do_yall_use_digital_closet_apps/))
- “Big commitment” captures concern about investing in an app that may close or trap wardrobe data. ([Reddit](https://www.reddit.com/r/capsulewardrobe/comments/1lfvsre/recommendations_for_digital_closet_app_can_i_back/))
- The Google/Ipsos finding that shoppers did not feel represented by model images is useful interview language to explore, but it is survey reporting rather than a verbatim customer quote. ([Google](https://blog.google/products-and-platforms/products/shopping/ai-virtual-try-on-google-shopping/))

Interview for the beachhead’s own language around:

- the moment uncertainty became frustrating;
- what made the item or occasion matter;
- how they currently ask for reassurance;
- what would make a generated image feel dishonest;
- what they expect “try-on” and “fit” to mean; and
- the exact privacy explanation needed before upload.

## Messaging Framework

### Core Problem Statement

“You found the item, but the product page still cannot show whether it looks right on you—and the decision cannot wait forever.”

This is a messaging hypothesis. Test it against a broader “virtual try-on” headline before adopting it.

### Value Proposition

**See one garment on your photo, then make a clearer buy, skip, save, or share decision—without uploading your whole closet.**

Required qualifier: the result visualizes possible appearance; it does not guarantee size, comfort, fabric behavior, or physical fit.

### Messaging Pillars

1. **One real decision:** Start with the item the shopper is deciding on now.
2. **Personal visual context:** Use the shopper’s photo rather than a generic model.
3. **Decision over novelty:** End with buy, skip, save, or share—not an image-generation dead end.
4. **Honest uncertainty:** State what the output can and cannot show.
5. **Low setup and privacy control:** One photo and one garment, with clear handling and deletion.

### Reasons to Believe

These are proof requirements, not current claims:

- A successful live demonstration on supported garment categories.
- Side-by-side examples showing identity and garment preservation across a diverse test cohort.
- Measured latency, failure rate, and recovery behavior.
- Plain-language retention/deletion policy and provider disclosure.
- User feedback showing the result changed or clarified a real decision.
- Transparent examples of failure and unsupported conditions.

### Objection Responses

| Objection | Response |
|---|---|
| “Is this a fit or size predictor?” | No. It is a personal appearance visualization and decision aid; sizing and physical fit remain separate. |
| “Why not use Google or the retailer?” | Use them when they solve the need. Magic Mirror must earn preference through cross-retailer decision support, honest limitations, and useful memory—not claim uniqueness from rendering alone. |
| “Will you keep my photo?” | Do not answer with a promise until the retention decision is finalized. The launch response must state exactly what is stored, for how long, by whom, and how deletion works. |
| “What if it looks fake or changes me?” | Limit launch categories, show fidelity expectations, and provide a visible failure/report path. Never frame distortion as a style judgment. |
| “Why would I pay for one decision?” | Pricing is unvalidated. Let users experience a successful decision before testing credits or subscription intent. |
| “I trust my friend more.” | Magic Mirror should make that conversation easier with a shareable personal visual, not replace trusted judgment. |

### Language to Use and Avoid

| Use | Avoid |
|---|---|
| “See how this item could look on you” | “See exactly how it fits” |
| “Decide: buy, skip, save, or share” | “Guaranteed confidence” |
| “One photo, one item” | “Upload your entire closet” |
| “Appearance visualization” | “Perfect fit predictor” |
| “Supported garment categories” | “Works with everything” |
| “You control deletion” only after implemented | Vague “100% private” claims |
| “What looks wrong?” feedback | “More flattering,” “fix your body,” or body-judgment language |
| “Decision companion” | Generic “AI stylist” as the V1 promise |
| “May help reduce uncertainty” | “Eliminates returns” |

## Channel Strategy

### Discovery

1. **Short-form creator demonstrations:** TikTok is the best evidenced discovery hypothesis because product reviews/recommendations are already a common use behavior. Demonstrate a real decision and limitation, not only a dramatic transformation. ([Pew](https://www.pewresearch.org/short-reads/2024/11/21/a-majority-of-us-tiktok-users-are-there-for-reviews-and-recommendations/))
2. **Trusted one-to-one sharing:** A shopper sending a result to a friend creates context-rich acquisition. Build only after the result is safe to share and source-photo exposure is understood.
3. **Intent capture near product evaluation:** Search, garment URL/share-sheet input, browser extension, or retailer-page entry could reach the decision moment. For V1, test a landing page and manual garment upload before building integrations.
4. **Occasion-specific communities:** Wedding, interview, travel, and style communities are research/recruitment channels first. Do not assume scalable acquisition until response and activation are measured.

Instagram and Pinterest are plausible discovery channels but lack direct evidence in the current research sufficient to prioritize them over TikTok and intent capture.

### Evaluation and Trust

- Representation-diverse, consented examples with no beauty-filter framing.
- Clear supported categories and known failure modes.
- Visible “visualization, not fit guarantee” explanation.
- Plain-language photo handling and deletion details.
- Before/after decision stories that include buy **and** skip outcomes.
- Trusted creator or customer demonstrations that disclose affiliate relationships.
- An easy way to report identity, garment, or body distortion.

### Purchase

- Keep checkout outside Magic Mirror and return the user to the original retailer when they choose “buy.”
- Test pricing only after a successful decision, not before first value.
- Compare a non-charging $5.99/month reference with a credit option and a free/affiliate path.
- Measure paywall intent and attributed purchase separately; neither proves retention.

### Retention and Advocacy

- Re-engage only around a new decision, saved item, or requested real-world follow-up—not generic daily styling notifications.
- Let the user state whether the result helped after the item arrives.
- Use prior “what looked wrong” feedback to improve future sessions before building a complete closet.
- Make useful results shareable with explicit user control over the visible photo.
- Ask for advocacy only after a completed decision, not after a visually impressive render.
- Email, push, and SMS preferences are unresearched; test opt-in rather than assuming a channel.

## Customer Journey

| Stage | Customer question | Friction | Proof needed | Message | Channel | Intervention |
|---|---|---|---|---|---|---|
| Awareness | “Is there a faster way to judge this item on me?” | The shopper may not recognize visualization uncertainty as a solvable problem | A relatable one-item decision demonstration | “See the item on your photo before you decide” | Creator demo, search/landing page, trusted share | Show one honest real-decision story |
| Problem recognition | “Why am I still unsure after reading the product page?” | Free status quo feels familiar and sufficient | Evidence that model mismatch is common without exaggerating | “The product page shows the garment—not necessarily you” | Product-evaluation context, community content | Prompt with a specific undecided item |
| Consideration | “Why Magic Mirror instead of Google, reviews, or my friend?” | Free competitors and low switching cost | Cross-retailer input, decision output, shareability, privacy clarity | “One item, one decision, no closet setup” | Landing page and comparison explanation | Show supported inputs, limitations, and output action |
| Evaluation | “Will it preserve me, the garment, and my photo?” | Identity distortion, fit confusion, privacy anxiety | Diverse examples, fidelity benchmark, deletion policy, no-fit disclaimer | “Personal visualization with honest limits” | Product onboarding and trust page | Consent preview, example gallery, category eligibility check |
| Purchase | “Is this useful enough to pay for?” | Value is episodic and free alternatives exist | Successful first decision and transparent price | “Pay only after you have seen the decision value” | In-product offer after success | Non-charging price/credit test before billing |
| Activation | “Can I get a useful answer before my decision deadline?” | Upload friction, provider latency, failures | Clear progress, slow/failure states, recognizable result | “Upload one photo and one item” | Product | Validate inputs, disclose timing, generate, capture decision |
| Retention | “Will this help with my next item?” | Occasion frequency may be low; no durable advantage yet | Prior feedback improves the next session | “Bring the next item you are unsure about” | Opt-in follow-up, saved decision | Store only consented decision data; request real-world outcome |
| Advocacy | “Is this safe and useful to share?” | Personal photo exposure and fear of endorsing an inaccurate result | User-controlled share, visible limitations, trustworthy outcome | “Ask someone you trust with your result” | Private share link, creator/customer story | Preview exactly what is shared; capture referral and usefulness |

## Validation Plan

Run validation in this order so the team does not build retention or pricing around an untrusted render.

| Priority | Risky assumption | Cheapest test | Support signal | Invalidation or rethink signal | Time box |
|---:|---|---|---|---|---|
| 1 | Near-term item decisions are common and painful enough | Interview 10 U.S. adult online apparel shoppers using their most recent uncertain item; require a real item and decision date | At least 6/10 had a relevant decision in the past 60 days; at least 5 can name a near-term trigger and agree to prototype testing | Fewer than 4 have a concrete recent decision or urgency is consistently low | 1 day |
| 2 | Decision-companion messaging outperforms generic try-on | Randomized landing-page or moderated concept test: “Should I buy this?” vs. “Virtual try-on” | Focused message produces at least 25% higher qualified-start rate and clearer expected outcome | Generic try-on wins or users expect full fit prediction from both | 1 day |
| 3 | Users will upload a real photo under the proposed policy | Concierge test after showing exact processing/deletion language | At least 5/10 consent to a real-photo test; refusals are understood and addressable | Fewer than 3/10 consent or policy explanation creates unresolved fear | 1 day, after policy draft |
| 4 | A provider can meet representation and fidelity needs | Blind benchmark across 20 consented or synthetic people × 10 garments; score identity, body/skin tone, garment, latency, failure, cost | At least 80% of supported-category outputs pass predefined fidelity thresholds; no systematic subgroup failure | No provider/category combination passes or subgroup errors are material | 1–2 days |
| 5 | The output changes a real decision | Run 20–30 concierge sessions; record confidence and buy/skip/save/share before and after | At least 60% rate the result decision-useful and at least 30% change or clarify the action without increased false fit confidence | Users call it entertaining but not decision-useful, or fit misunderstanding rises | 2 days |
| 6 | The occasion beachhead beats social-first browsing | Recruit matched traffic to occasion-focused and general-discovery concepts | Occasion cohort has higher real-item submission and completed-decision rates | Social-first cohort materially outperforms and reports repeat use | 2 days |
| 7 | A repeat decision exists without a full closet | Invite activated users back only when they have another uncertain item | At least 20% complete a second real-item session within 30 days | Repeat use is negligible or only novelty-driven | 30 days |
| 8 | There is monetization intent after value | Show non-charging $5.99/month, credits, and free/affiliate choices after a successful session | Meaningful option selection and at least five follow-up pricing conversations; define paid threshold after baseline | Users reject all paid options or generation economics cannot work with free use | After activation evidence |
| 9 | Trusted sharing helps acquisition | Allow private result sharing with explicit preview and consent | At least 20% of useful-result users share; referred users submit real items at a measurable rate | Sharing is avoided because of privacy or result credibility | After safe share flow |

### Interview Recruitment Quotas

Recruit by behavior first, then ensure the cohort tests representation:

- all participants are adults for the initial study;
- all shop for apparel online and can show a recent uncertain item;
- at least half have a decision tied to a near-term occasion;
- include varied ages, skin tones, body shapes, gender presentations, and fashion confidence;
- include both frequent and occasional online apparel shoppers; and
- include people who do and do not currently use creators, friends, or communities for advice.

These are research quotas, not a demographic ICP.

### Immediate Next Validation Step

Run the ten-person decision interview and message comparison before expanding the V1. Recruit participants with the screener: **“In the last 60 days, did you consider buying an apparel item online but feel unsure how it would look on you? What was the item, what was the decision deadline, and what did you do?”**

The owner should revisit the beachhead choice if fewer than six participants describe the problem, fewer than five accept a real-photo test after seeing the policy, or general social browsing activates materially better than occasion messaging.

## Sources and Traceability

Primary internal evidence:

- [Full market evidence](../market_research/market_research.md)
- [Executive market recommendation](../market_research/market_research_report.md)
- [Company scope and constraints](../../company.md)
- [Living plan and recorded decisions](../../plan.md)

Key external sources:

- [Google/Ipsos online clothing shopper evidence](https://blog.google/products-and-platforms/products/shopping/ai-virtual-try-on-google-shopping/)
- [Google own-photo virtual try-on scale](https://blog.google/products-and-platforms/products/shopping/studio-quality-digital-try-on/)
- [Pew product-review and recommendation behavior](https://www.pewresearch.org/short-reads/2024/11/21/a-majority-of-us-tiktok-users-are-there-for-reviews-and-recommendations/)
- [NRF 2025 returns evidence](https://nrf.com/media-center/press-releases/consumers-expected-to-return-nearly-850-billion-in-merchandise-in-2025)
- [FTC biometric-information risk statement](https://www.ftc.gov/news-events/news/press-releases/2023/05/ftc-warns-about-misuses-biometric-information-harm-consumers)
- [Peer-reviewed disconfirming virtual try-on evidence](https://www.sciencedirect.com/science/article/pii/S0969698918311834)
- [Google Research identity-preservation challenge](https://research.google/pubs/mm-vto-multi-garment-virtual-try-on-and-editing/)
- [Acloset pricing](https://apps.apple.com/us/app/acloset-ai-fashion-assistant/id1542311809), [AI Closet pricing](https://www.aicloset.io/), and [Sty AI pricing](https://styai.app/)
- [Digital-closet setup discussion](https://www.reddit.com/r/capsulewardrobe/comments/1onp0dk/do_yall_use_digital_closet_apps/) and [portability discussion](https://www.reddit.com/r/capsulewardrobe/comments/1lfvsre/recommendations_for_digital_closet_app_can_i_back/)

Source limitations carry forward from the market research: competitor pricing can change; Google and NRF have commercial interests in the category; community discussions are self-selected anecdotes; Pew’s product-recommendation data are not apparel-specific; and no external source substitutes for Magic Mirror interviews, provider tests, behavioral analytics, or legal review.
