# Style Report — Color Interaction Specification

Status: Prepared for generated-mockup review  
Screen ID: `b16feadb-5618-46fc-b03f-be77d1de7b4f`  
Screen slug: `style-report-color`  
State: `base`  
Route/context: `/report/colors`  
Viewports: desktop and mobile

## Sources

- Screen contract: `company/artifacts/prd/screens.json#style-report-color`
- Wireframes: `company/artifacts/ui-ux-design/wireframe-manifest.json#style-report-color/base`
- Exact copy: `company/artifacts/copy/copy-manifest.json#style-report-color/base`
- Visual system: `company/artifacts/screen-mockups/design-direction.md`
- Prompt: `company/artifacts/screen-mockups/prompts/style-report-color.md`

The copy manifest is authoritative. Generated text and imagery are visual references only.

## User job

Personal palette, neutrals, accents, combinations, text equivalents, explanations, and feedback.

## Component hierarchy

1. Report navigation
2. Color summary
3. Labeled palette
4. Combination examples
5. Feedback and products

## Controls and behavior

| Control | Trigger | Behavior |
| --- | --- | --- |
| Find pieces in my colors | Click/tap; Enter or Space when focused | Open the matching recommendation or report module while preserving the current report context. |
| Save my palette | Click/tap; Enter or Space when focused | Persist the current customer selection and confirm completion without changing unrelated state. |
| Update my colors | Click/tap; Enter or Space when focused | Open the matching recommendation or report module while preserving the current report context. |

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
