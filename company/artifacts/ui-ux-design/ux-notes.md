# Magic Mirror UX Notes

Status: Ready for review
Scope: Structural and behavioral decisions for approved PRD v1.0.0

## Experience principles

1. **Lead with earned insight.** Explain the report outcome and evidence before asking for effort.
2. **Progress before account pressure.** Preserve work anonymously, then request permanent access when the value exchange is clear.
3. **Affirm before correcting.** Reports begin with strengths and observable patterns; opportunities are practical, never body-shaming or attractiveness-scored.
4. **Show the system thinking.** Analysis, voice, and gesture states reveal what is happening, what was understood, and what the customer can do next.
5. **Every remote action has a nearby equivalent.** Voice and gestures add distance control without becoming the only control path.
6. **Keep commerce boundaries explicit.** Magic Mirror curates and hands off; the retailer owns the transaction.

## Key interaction decisions

- Taste calibration should feel physical and fast: horizontal drag reveals Love/Hate direction; downward drag reveals Maybe. Buttons and keyboard commands remain present.
- Undo restores the previous card and choice; it does not reset the session.
- Photo upload exposes the 8-photo minimum and 12-photo maximum before selection and validates each image independently.
- Processing uses meaningful stages rather than a fake percentage. The normal message sets a one-to-two-minute expectation; the slow state begins only after 120 seconds.
- Report findings carry confidence and rationale. Kibbe-informed language is framed as styling guidance rather than objective fact.
- Live session controls remain visible when voice or gesture modes are enabled.
- Direct actions can change the visible product immediately; ambiguous voice and gesture actions require confirmation.

## Accessibility

- WCAG 2.2 AA structure: semantic landmarks, visible focus, labeled inputs, textual errors, sufficient grayscale contrast, and logical heading order.
- Swipe actions expose labeled buttons and keyboard shortcuts: Right/L for Love, Left/H for Hate, Down/M for Maybe, and U for Undo.
- Color findings include names, role, contrast/use guidance, and combinations—not swatches alone.
- Gesture instructions include textual descriptions; recognition status is both visual and announced.
- Camera or microphone denial never blocks access to the report or recommendations.
- Mobile touch targets are at least 44×44 CSS pixels.

## Responsive behavior

- Mobile onboarding is single-column with a sticky action area only where it does not hide errors.
- Desktop onboarding centers the task and keeps progress/context in a secondary rail.
- Dense report tables collapse into labeled cards on mobile.
- Product detail appears as a right drawer on desktop and a full-height bottom sheet on mobile.
- Live styling uses a full-width camera stage on mobile with controls beneath; desktop preserves a wide stage and a 320–360px control panel.

## Backend and implementation implications

These are interface contracts, not a backend architecture prescription:

- Anonymous authentication must exist before the first onboarding write and support atomic linking to Google or magic-link identities.
- Each upload needs independent validation and status so one failure does not invalidate the batch.
- Analysis APIs need typed stage/status responses, a timeout, normalized errors, resumable inputs, and safe notification support.
- Report output should be structured by section with evidence, confidence, recommendations, feedback, and version metadata.
- Voice and gesture recognition need explicit observing/listening, interpreted, confirmed, ignored, unavailable, and error states.
- Product price/availability must carry last-checked time and retailer ownership.
- All photo, report, session, and generated-asset reads require per-owner isolation.

## Copy placeholders

Wireframes use functional placeholder copy describing purpose, action, timing, and state. Persuasive and final interface copy belongs to the next `copywriting` stage and will be recorded in `company/voice.md` and the copy manifest.

## Approval gate

The UX package is ready for founder review only after all 27 screen records have responsive HTML and verified desktop/mobile PNG captures. Copywriting must not begin until Talisha White explicitly approves this package.
