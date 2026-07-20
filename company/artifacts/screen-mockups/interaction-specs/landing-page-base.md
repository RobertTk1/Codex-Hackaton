# Landing Page — Base Interaction Specification

Status: Ready for review  
Screen ID: `76a5f0c7-aa78-4eaf-ae0f-4b577024f5c6`  
State: `base`  
Route: `/`  
Viewports: desktop and mobile

## Sources

- Approved screen contract: `company/artifacts/prd/screens.json#landing-page-base`
- Approved wireframes: `company/artifacts/ui-ux-design/wireframe-manifest.json#landing-page-base/base`
- Approved exact copy: `company/artifacts/copy/copy-manifest.json#landing-page-base/base`
- Visual system: `company/artifacts/screen-mockups/design-direction.md`
- Desktop comp: `company/artifacts/screen-mockups/screens/landing-page-base/base/landing-page-base-desktop.png`
- Mobile comp: `company/artifacts/screen-mockups/screens/landing-page-base/base/landing-page-base-mobile.png`

The copy manifest is authoritative. Generated lettering and editorial image content are visual references only.

## Component hierarchy

1. Global navigation
2. Hero and primary conversion actions
3. Style-report preview
4. Three-step process
5. Three report-content modules
6. Photo/privacy and retailer-role explanation
7. FAQ accordion
8. Closing conversion action
9. Footer navigation

## Controls and destinations

| Control | Trigger | Destination or behavior |
| --- | --- | --- |
| Magic Mirror logo | Click/tap | Return to `/`; move focus to page start when already on `/` |
| How it works | Click/tap | Smooth-scroll to the process section; update focus without trapping it |
| What’s inside | Click/tap | Smooth-scroll to the report-content section |
| Your privacy | Click/tap | Smooth-scroll to the trust section |
| Get my style report | Click/tap | Navigate to `/style-report/profile` and begin the preserved onboarding journey |
| Log in | Click/tap | Navigate to `/login` |
| FAQ row | Click/tap, Enter, or Space | Toggle one answer; update `aria-expanded` and preserve surrounding page position |
| Mobile menu | Click/tap, Enter, or Space | Open a compact navigation sheet containing the three section links, Log in, and the primary CTA |
| Footer links | Click/tap | Navigate to the named internal policy or information destination when implemented |

## Interaction states

- **Default:** White/Cloud page fields, Ink text, Acid primary actions, outlined secondary actions.
- **Hover:** Primary buttons use Acid 600; outlined actions use Pale; text links gain a visible underline or Ink change.
- **Focus:** 3 px Acid ring with an Ink edge/offset. Focus order follows visual reading order.
- **Active:** Buttons compress subtly without changing label or layout. Anchor links may show an Ink underline.
- **Disabled:** Not expected in the landing-page base state. Do not render a disabled primary CTA.
- **FAQ open:** Answer appears directly beneath its question; chevron rotates; adjacent rows reflow rather than overlap.
- **Navigation sheet open:** Background page does not scroll; Escape and the close button dismiss it; focus returns to the menu trigger.

## Responsive behavior

### Desktop

- Use a full-width navigation row with logo left and navigation/actions right.
- Keep the hero centered with its large editorial image directly below.
- Report preview and trust use approved two-column splits.
- Process steps and report modules appear as three-column groups.
- FAQ remains a centered, readable accordion.

### Mobile

- Replace desktop navigation links with a menu trigger while keeping the logo visible.
- Stack hero actions vertically and use full-width touch targets.
- Stack report-preview copy, actions, and imagery in that order.
- Present process steps as three vertical rows.
- Present report modules as three distinct vertical cards.
- Stack trust copy, actions, and imagery in that order.
- Stack closing actions and footer groups vertically.
- Maintain at least 44 px interactive targets and 16 px body text.

Suggested layout breakpoints are implementation guidance, not new product requirements: mobile below 768 px, transitional layout from 768–1023 px, and desktop at 1024 px and above.

## Motion

- Use restrained staggered entry for editorial imagery and report modules only after initial paint.
- Anchor navigation may scroll smoothly, but it must jump immediately when reduced motion is requested.
- FAQ expansion uses a short height/opacity transition; reduced-motion mode removes the transition.
- Do not use parallax on form controls, navigation, or body copy.

## Assets and treatment

- Use the supplied production wordmark/combined-lockup exports; never typeset a substitute.
- Editorial photography should preserve realistic bodies, visible garments, and inclusive styling.
- Report imagery should communicate palette, silhouettes, and outfit guidance without inventing customer data or proof.
- Implement exact palette values and typography from the brand tokens rather than sampling generated pixels.

## Accessibility

- One semantic `h1`; section headings descend in order.
- Navigation is a labeled landmark; footer uses a separate labeled navigation group.
- All decorative editorial images use empty alternative text. Informative report previews receive concise purpose-based alternative text.
- FAQ questions are buttons with programmatic expanded/collapsed state.
- Color chips require text labels; CTA meaning never relies on Acid alone.
- Maintain verified contrast pairings and visible keyboard focus.

## Generated-image discrepancies

- The generated comps approximate the exact logo lettering, body copy, FAQ questions, and supporting descriptions. Production must use supplied logo assets and the approved copy manifest.
- Photography and report-book imagery are art direction, not final licensed production assets.
- The raster dimensions are review dimensions, not implementation viewport dimensions; build responsively from the approved wireframes and this specification.

## Open implementation questions

- Which licensed or generated editorial photographs will ship in the prototype?
- Will the report preview be implemented as HTML/CSS, a reusable report image, or a combination?
- Which policy and informational routes will be included in the hackathon build footer?

These questions do not block visual-direction review and do not authorize new backend behavior.
