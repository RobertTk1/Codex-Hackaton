# Magic Mirror Bag — Base Interaction Specification

Status: Prepared for generated-mockup review  
Screen ID: `1eb0f961-b299-4ab3-b90d-12692f254494`  
Screen slug: `magic-mirror-bag-base`  
State: `base`  
Route/context: `/bag`  
Viewports: desktop and mobile

## Sources

- Screen contract: `company/artifacts/prd/screens.json#magic-mirror-bag-base`
- Wireframes: `company/artifacts/ui-ux-design/wireframe-manifest.json#magic-mirror-bag-base/base`
- Exact copy: `company/artifacts/copy/copy-manifest.json#magic-mirror-bag-base/base`
- Visual system: `company/artifacts/screen-mockups/design-direction.md`
- Prompt: `company/artifacts/screen-mockups/prompts/magic-mirror-bag-base.md`

The copy manifest is authoritative. Generated text and imagery are visual references only.

## User job

Selected products grouped by retailer with availability, external-checkout boundaries, and removal controls.

## Component hierarchy

1. App navigation
2. Retailer-grouped selections
3. Checkout boundary
4. Bag actions

## Controls and behavior

| Control | Trigger | Behavior |
| --- | --- | --- |
| Shop at retailer | Click/tap; Enter or Space when focused | Show or confirm the retailer handoff, then open the retailer destination in a new tab. |
| Keep styling | Click/tap; Enter or Space when focused | Perform the approved “Keep styling” action for magic-mirror-bag-base and preserve unrelated customer work. |

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
