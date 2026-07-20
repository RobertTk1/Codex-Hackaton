# Taste Calibration — Recovery Interaction Specification

Status: Prepared for generated-mockup review  
Screen ID: `37d792e1-4d6c-494f-b53d-1dc4a498c294`  
Screen slug: `taste-calibration-recovery`  
State: `recovery`  
Route/context: `/style-report/taste`  
Viewports: desktop and mobile

## Sources

- Screen contract: `company/artifacts/prd/screens.json#taste-calibration-recovery`
- Wireframes: `company/artifacts/ui-ux-design/wireframe-manifest.json#taste-calibration-recovery/recovery`
- Exact copy: `company/artifacts/copy/copy-manifest.json#taste-calibration-recovery/recovery`
- Visual system: `company/artifacts/screen-mockups/design-direction.md`
- Prompt: `company/artifacts/screen-mockups/prompts/taste-calibration-recovery.md`

The copy manifest is authoritative. Generated text and imagery are visual references only.

## User job

Failed-card recovery state that preserves earlier taste choices.

## Component hierarchy

1. Onboarding progress
2. Taste decision workspace
3. Interaction guidance
4. Step actions

## Controls and behavior

| Control | Trigger | Behavior |
| --- | --- | --- |
| Load the next look | Click/tap; Enter or Space when focused | Retry the failed operation while preserving completed customer work. |
| Save and exit | Click/tap; Enter or Space when focused | Persist current valid work and leave to the resume destination. |

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
