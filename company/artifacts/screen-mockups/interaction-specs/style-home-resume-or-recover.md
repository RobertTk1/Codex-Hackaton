# Style Home — Resume or Recover Interaction Specification

Status: Prepared for generated-mockup review  
Screen ID: `dd9e7858-c66f-5351-a51c-dd63a8b11d7a`  
Screen slug: `style-home-resume-or-recover`  
State: `recovery`  
Route/context: `/style`  
Viewports: desktop and mobile

## Sources

- Screen contract: `company/artifacts/prd/screens.json#style-home-resume-or-recover`
- Wireframes: `company/artifacts/ui-ux-design/wireframe-manifest.json#style-home-resume-or-recover/recovery`
- Exact copy: `company/artifacts/copy/copy-manifest.json#style-home-resume-or-recover/recovery`
- Visual system: `company/artifacts/screen-mockups/design-direction.md`
- Prompt: `company/artifacts/screen-mockups/prompts/style-home-resume-or-recover.md`

The copy manifest is authoritative. Generated text and imagery are visual references only.

## User job

Returning-customer home when incomplete or failed work needs a specific resume or recovery action.

## Component hierarchy

1. App navigation
2. Current status
3. Report highlights
4. Recommended items
5. Saved and recent activity

## Controls and behavior

| Control | Trigger | Behavior |
| --- | --- | --- |
| Keep going | Click/tap; Enter or Space when focused | Advance to the next PRD-defined step after validating the current state. |
| Try again | Click/tap; Enter or Space when focused | Retry the failed operation while preserving completed customer work. |
| View my report | Click/tap; Enter or Space when focused | Navigate to the report overview. |

All additional labels, links, form controls, validation, consent, and status strings follow the approved exact-copy object. Restore focus to the triggering control after closing a dialog, drawer, permission explanation, or recoverable overlay.

## Named state behavior

Show preserved progress and a clear retry or alternate route; avoid alarmist visuals.

Preserve valid work and the customer’s current product/report/live context across waiting, error, permission, and recovery states. Do not silently retry consequential actions or begin camera/microphone capture without browser permission.

## Responsive behavior

- Desktop preserves the approved wide composition, grouping, navigation, and control hierarchy.
- Mobile follows the approved narrow composition and reading order; it is not a scaled desktop image.
- Stack paired actions when the approved mobile wireframe does so.
- Maintain at least 44 px touch targets, 16 px body copy, readable labels, and uninterrupted keyboard order.
- Keep the primary action visually dominant at both viewports.

## Interaction states

- Hover and active treatments must not change labels or layout.
- Keyboard focus uses the approved Acid ring with an Ink edge/offset.
- Disabled states combine muted tokens with native disabled semantics.
- Waiting controls communicate progress and prevent duplicate submission when the action is not repeatable.
- Errors appear beside the affected control or in the approved state region and always expose a recovery action.

## Motion and reduced motion

- Use short, functional transitions for drawers, cards, progress, live-item changes, voice, and gesture feedback.
- Do not animate sensitive imagery merely for decoration.
- Reduced-motion mode removes parallax, card flight, and nonessential transforms while preserving state changes.

## Assets and accessibility

- Use production Magic Mirror logo/icon exports and exact brand tokens, never pixels sampled from generated comps.
- Use realistic, purpose-based alternative text for informative images and empty alternative text for decorative imagery.
- Do not rely on color, swipe, gesture, or voice alone; retain equivalent visible controls.
- Announce processing, errors, completed actions, and gesture/voice changes through an appropriate live region.
- Permission and consent controls remain explicit, reversible when the platform allows, and separate by capability.

## Generated-image discrepancy rule

Implementation uses the approved copy, production logo assets, responsive wireframes, and this behavior—not generated glyphs, accidental image text, or inferred controls.
