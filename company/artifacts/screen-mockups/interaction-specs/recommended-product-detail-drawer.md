# Recommended Product — Detail Drawer Interaction Specification

Status: Prepared for generated-mockup review  
Screen ID: `a7d262bf-0e4a-423f-9d51-fed5b2594b14`  
Screen slug: `recommended-product-detail-drawer`  
State: `base`  
Route/context: `product-detail-drawer`  
Viewports: desktop and mobile

## Sources

- Screen contract: `company/artifacts/prd/screens.json#recommended-product-detail-drawer`
- Wireframes: `company/artifacts/ui-ux-design/wireframe-manifest.json#recommended-product-detail-drawer/base`
- Exact copy: `company/artifacts/copy/copy-manifest.json#recommended-product-detail-drawer/base`
- Visual system: `company/artifacts/screen-mockups/design-direction.md`
- Prompt: `company/artifacts/screen-mockups/prompts/recommended-product-detail-drawer.md`

The copy manifest is authoritative. Generated text and imagery are visual references only.

## User job

Product detail, report rationale, size context, retailer provenance, known price and availability, and session-preserving actions.

## Component hierarchy

1. Context navigation
2. Preserved styling context
3. Product detail drawer
4. Selection actions

## Controls and behavior

| Control | Trigger | Behavior |
| --- | --- | --- |
| Add to bag | Click/tap; Enter or Space when focused | Add the current product selection to the Magic Mirror bag and confirm the result. |
| Try it on | Click/tap; Enter or Space when focused | Perform the approved “Try it on” action for recommended-product-detail-drawer and preserve unrelated customer work. |
| Shop at retailer | Click/tap; Enter or Space when focused | Show or confirm the retailer handoff, then open the retailer destination in a new tab. |

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
