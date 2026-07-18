# Magic Mirror V1 Product Requirements Document

**Status:** Extracted draft for hackathon execution

**Source:** `Magic Mirror Product Strategy.docx` (Draft v0.1), reconciled with the repository’s approved V1 scope

**Owner:** Magic Mirror team

**Last updated:** 2026-07-18

## 1. Product Outcome

Help an online apparel shopper answer **“Should I buy this?”** by showing a useful visualization of one selected garment on their own photo. V1 succeeds when a new user can provide one photo, choose one garment, receive a recognizable try-on result, and understand whether the result succeeded or failed without assistance.

The source strategy describes a broader personal-stylist MVP. For this hackathon, that broader loop is deliberately reduced to the smallest technical and user-value proof. The PRD preserves the strategy’s privacy, identity, garment-fidelity, uncertainty, and measurement requirements while moving adjacent experiences to the roadmap.

## 2. Target User and Job

**Validation beachhead:** A U.S. adult online apparel shopper deciding on one garment for a near-term, personally important occasion. Demographics are representation and quality-testing dimensions, not targeting requirements.

**Job to be done:** When I am uncertain about buying a garment online, help me visualize it on myself so I can shortlist or reject it with greater confidence.

## 3. Golden-Path Scenario

**Given** a user has a suitable personal photo and Magic Mirror offers at least one supported garment,

**When** the user provides the photo, selects one garment, and requests a try-on,

**Then** Magic Mirror returns a mobile-viewable visualization that preserves the user’s recognizable identity and the garment’s defining appearance—or presents a clear, recoverable failure state.

## 4. V1 Scope

### 4.1 Photo input

- Accept one image from local upload or device camera capture.
- Validate file type, size, and required image properties before submission.
- Explain that the image is sensitive, how it will be processed, and how long it will be retained before the user consents.
- Provide simple guidance for a usable photo; do not require a perfect full-body image unless provider testing proves it necessary.
- Allow the user to replace the photo before generation and delete it afterward.

### 4.2 Garment selection

- Present a narrow curated demo catalog with structured metadata and clean source images.
- Allow selection of exactly one supported garment per try-on session.
- Preserve the garment ID, source image, category, dominant color, and display name throughout the session.
- Do not require retailer URL extraction for the golden path.

### 4.3 Try-on generation

- Submit the validated photo and selected garment through one typed provider adapter.
- Enforce a timeout and normalize provider responses and errors.
- Preserve recognizable facial identity, skin tone, approximate body proportions, garment category, dominant color, and defining design details.
- Associate every generated asset with its session and input garment.
- Permit one-click retry after a failed or unacceptable result.
- Display that the output is a visualization, not a guarantee of physical fit or size.

### 4.4 User-visible state

- Show explicit ready, uploading, generating, slow, success, and failed states.
- A provider failure must never leave the user waiting indefinitely or erase the current selection.
- Failure messages must explain what happened in plain language and offer retry or safe restart.
- On success, show the generated result and selected garment together for visual comparison.

### 4.5 Session and asset handling

- Store session status, user ownership, garment reference, source-photo reference, generated-asset reference, provider status, and latency.
- Store images in private object storage, never as database blobs.
- Use signed or otherwise access-controlled asset URLs.
- Prevent access to another user’s photo, session, or result.
- Support deletion according to the retention policy chosen before real-user testing.

## 5. Acceptance Criteria

V1 is complete only when:

1. A mobile user can upload or capture a supported photo.
2. The user can select one garment from the curated catalog.
3. Invalid inputs are rejected before a provider call with actionable feedback.
4. A valid request produces a result or a normalized failure within the configured timeout.
5. Successful results preserve identity and garment appearance at the agreed provider-benchmark threshold.
6. Loading, slow, failure, retry, and success states are observable and testable.
7. The UI clearly states that output is visualization, not guaranteed fit.
8. Raw photo bytes never appear in logs.
9. Cross-user access checks fail closed.
10. Source and generated images can be deleted under the documented retention policy.
11. The Playwright golden-path scenario passes in the deployed Vercel environment.

## 6. Quality Guardrails

A result is unacceptable when it materially changes race or skin tone, recognizable facial identity, major body features, the garment category, or defining garment appearance; introduces anatomical implausibility; or creates unrequested sexualized, unsafe, or demeaning imagery. Failed quality checks must be counted during provider evaluation, not hidden by reporting only successful samples.

The evaluation set must use consented or synthetic images and represent varied skin tones, body shapes, ages, and gender presentations. Do not market reliable performance to a group until the benchmark supports that claim.

## 7. Initial Performance and Reliability Targets

- Application shell: usable within 3 seconds on a typical mobile connection.
- Static try-on: target completion within 30 seconds for most successful requests; measure p50 and p95 before committing to a final target.
- Every provider call: explicit timeout, retry path, normalized error, and recorded latency.
- A failed generation must not destroy the user’s current session.
- Accessibility: keyboard-operable controls, screen-reader labels, sufficient contrast, and useful alternative text for generated results.

## 8. Success Measures

### Demo gate

- Golden-path completion rate.
- Successful generation rate.
- p50 and p95 generation latency.
- Identity-preservation pass rate.
- Garment-preservation pass rate.
- Recovery rate after generation failure.

### User-value signals

- Percentage of users saying the result helped them shortlist or reject the garment.
- User-rated realism and purchase-decision usefulness.
- Regeneration rate and stated regeneration reason.
- Percentage of users who would use Magic Mirror for another uncertain purchase.

Generating an image alone is not a successful styling decision; the result must help the user make or advance a decision.

## 9. Explicit Non-goals

The following source-strategy capabilities are V2+ or separate experiments, not V1 dependencies:

- Eight-to-twelve-image style onboarding or a persistent style profile.
- Personalized outfit recommendations or multi-garment looks.
- Product URL scraping and universal retailer ingestion.
- Natural-language or voice stylist interaction.
- Digital closet, outfit history, capsule wardrobes, and purchase imports.
- Save/share acquisition loops, affiliate commerce, or direct checkout.
- Live video try-on, exact size prediction, garment physics, and fit guarantees.
- Retailer integrations, physical mirrors, kiosks, and multi-surface native apps.

These may be demonstrated only as isolated, time-boxed experiments after the functioning golden path is protected.

## 10. Dependencies and Risks

1. **Generation provider — critical risk.** Provider selection is blocked on a benchmark of identity fidelity, garment fidelity, latency, reliability, cost, safety controls, commercial rights, and replaceability.
2. **Photo policy — launch blocker.** Retention, deletion timing, consent language, and whether provider-side retention can be disabled must be decided before real-user uploads.
3. **Input constraints.** Provider requirements may force stricter pose, framing, garment-image, or category guidance than currently assumed.
4. **Quality detection.** Automated rejection may not be credible within hackathon time; the demo may require conservative provider thresholds plus a user-visible retry path.
5. **Scope pressure.** The source strategy’s styling, commerce, and closet features are valuable but would dilute the technical proof if pulled into V1.

## 11. Required Decisions Before Build Lock

- Which static try-on provider wins the benchmark?
- Which single garment category and minimum catalog will the demo support?
- What photo framing and file constraints does the selected provider require?
- What are the source-photo and generated-asset retention periods?
- Is authentication required for the judged demo, or can an anonymous isolated session satisfy the user outcome safely?
- What are the submission deadline, feature cutoff, and fallback demo path?
- What measurable identity- and garment-preservation thresholds constitute a pass?

## 12. Delivery Sequence

1. Benchmark providers with a small representative evaluation matrix.
2. Decide photo retention, deletion, and consent behavior.
3. Lock one garment category, catalog inputs, and provider-compatible photo guidance.
4. Scaffold the strict Next.js application and Supabase resources.
5. Build the photo → garment → generation vertical slice with visible states.
6. Add persistence and access isolation only as required by the golden path.
7. Protect the deployed flow with one Playwright scenario and run the demo-readiness benchmark.

## 13. Traceability to the Source Strategy

The extracted V1 directly retains the source document’s **Purchase Evaluation** job, **Static Try-On** recommendation, identity and representation guardrails, privacy controls, provider-adapter requirement, 30-second initial latency target, and “visualization—not fit guarantee” principle. Style learning, complete outfit creation, conversational refinement, sharing, commerce, and closets remain part of the product thesis but are sequenced after the hackathon proof.
