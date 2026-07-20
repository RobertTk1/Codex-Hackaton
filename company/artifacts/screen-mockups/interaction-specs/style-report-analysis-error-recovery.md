# Style Report Analysis — Error Recovery Interaction Specification

Status: Prepared for generated-mockup review  
Screen ID: `6c9017a7-ec72-46df-bba8-79dcc691a817`  
Screen slug: `style-report-analysis-error-recovery`  
State: `recovery`  
Route/context: `/style-report/processing`  
Viewports: desktop and mobile

## Sources

- Screen contract: `company/artifacts/prd/screens.json#style-report-analysis-error-recovery`
- Wireframes: `company/artifacts/ui-ux-design/wireframe-manifest.json#style-report-analysis-error-recovery/recovery`
- Exact copy: `company/artifacts/copy/copy-manifest.json#style-report-analysis-error-recovery/recovery`
- Visual system: `company/artifacts/screen-mockups/design-direction.md`
- Prompt: `company/artifacts/screen-mockups/prompts/style-report-analysis-error-recovery.md`

The copy manifest is authoritative. Generated text and imagery are visual references only.

## User job

Normalized analysis failure with preserved-input summary, retry, support, and replacement guidance when required.

## Component hierarchy

1. Analysis status header
2. Analysis state
3. Preservation and notification

## Controls and behavior

| Control | Trigger | Behavior |
| --- | --- | --- |
| Try again | Click/tap; Enter or Space when focused | Retry the failed operation while preserving completed customer work. |
| Get help | Click/tap; Enter or Space when focused | Open contextual guidance without discarding current work. |
| Come back later | Click/tap; Enter or Space when focused | Navigate to the safest available home or resume destination without discarding progress. |

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
