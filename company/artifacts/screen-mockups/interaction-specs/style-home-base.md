# Style Home — Base Interaction Specification

Status: Prepared for generated-mockup review  
Screen ID: `d677a738-5703-4b02-b7ca-667c31ac7555`  
Screen slug: `style-home-base`  
State: `base`  
Route/context: `/style`  
Viewports: desktop and mobile

## Sources

- Screen contract: `company/artifacts/prd/screens.json#style-home-base`
- Wireframes: `company/artifacts/ui-ux-design/wireframe-manifest.json#style-home-base/base`
- Exact copy: `company/artifacts/copy/copy-manifest.json#style-home-base/base`
- Visual system: `company/artifacts/screen-mockups/design-direction.md`
- Prompt: `company/artifacts/screen-mockups/prompts/style-home-base.md`

The copy manifest is authoritative. Generated text and imagery are visual references only.

## User job

Returning-customer home with report highlights, selected recommendations, live styling entry, bag, and account access.

## Component hierarchy

1. App navigation
2. Current status
3. Report highlights
4. Recommended items
5. Saved and recent activity

## Controls and behavior

| Control | Trigger | Behavior |
| --- | --- | --- |
| Start styling | Click/tap; Enter or Space when focused | Enter the live-styling permission or ready flow with the chosen recommendation preserved. |
| View my report | Click/tap; Enter or Space when focused | Navigate to the report overview. |
| Browse my picks | Click/tap; Enter or Space when focused | Open personalized product recommendations. |

All additional labels, links, form controls, validation, consent, and status strings follow the approved exact-copy object. Restore focus to the triggering control after closing a dialog, drawer, permission explanation, or recoverable overlay.

## Named state behavior

Show the ordinary usable base state with the primary task immediately clear.

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
