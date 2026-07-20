# UX Notes

Status: Approved by Talisha White on 2026-07-19.

## Inventory audit

The approved 27-record inventory described the main pages but omitted several visibly distinct states promised by its own stories and scenarios. This rerun preserves every existing screen ID and adds 21 state records, for 48 total screen/state records.

Added coverage:

- Personal-profile field validation
- Account-connection interruption/failure
- Report feedback and recalibration
- Returning-user resume/recovery
- Camera denial
- Live-session connecting, changing, slow, failure, and ended states
- Separate voice listening, interpreting, confirming, acting, and failure states
- Gesture observing, interpreting, accepted, ignored/unavailable, and consequential-action confirmation states
- Product and bag unavailability

## Wireframe contract

- The wireframes are intentionally anonymous: LOGO, generic headings and controls, lorem ipsum, and gray media placeholders.
- Product-specific meaning lives in the section plan, manifest, IA, and flow documents—not in the wireframe canvas.
- Every screen/state is decomposed into ordered Relume-style sections before assembly.
- Every section and assembled screen is rendered at 1440px desktop and 390px mobile widths.
- Human-readable screen slugs and states appear in folders. Stable screen IDs remain in HTML data attributes, screens.json, the section plan, and the manifest, but never render visibly inside a wireframe.
- Placeholder body copy appears only inside sections that structurally call for it; no validator-only lorem ipsum is appended after the final section.

## Interaction notes

- Swipe right = Love, left = Hate, down = Maybe, with visible buttons, keyboard equivalents, and undo.
- Google and email magic link form one signup/login step while anonymous progress remains owned and recoverable.
- Voice, gesture, and direct controls are equivalent routes for essential live-session actions.
- Consequential gesture actions require confirmation.
- Retailer handoff is explicit and preserves the in-product report and bag for return.
