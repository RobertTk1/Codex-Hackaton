# Magic Mirror Bag — Base ImageGen Brief

Screen ID: `1eb0f961-b299-4ab3-b90d-12692f254494`  
Screen slug: `magic-mirror-bag-base`  
State: `base`  
Surface: `product`  
Family: `commerce`  
Route/context: `/bag`  
User job: Selected products grouped by retailer with availability, external-checkout boundaries, and removal controls.  
Primary action: `Shop at retailer`

## Authoritative references

- Approved desktop wireframe: `company/artifacts/ui-ux-design/wireframes/png/magic-mirror-bag-base/base/desktop-screen.png`
- Approved mobile wireframe: `company/artifacts/ui-ux-design/wireframes/png/magic-mirror-bag-base/base/mobile-screen.png`
- Exact copy: `company/artifacts/copy/copy-manifest.json#magic-mirror-bag-base/base`
- Shared direction: `company/artifacts/screen-mockups/design-direction.md`
- Application continuity reference: `company/artifacts/screen-mockups/screens/personal-profile-base/base/personal-profile-base-desktop.png`
- Live-styling continuity reference when applicable: `company/artifacts/screen-mockups/screens/live-styling-ready/base/live-styling-ready-desktop.png`

## Fixed section order

1. App navigation — Preserve access to styling and report.
2. Retailer-grouped selections — Review item status and retailer groupings.
3. Checkout boundary — Clarify what happens on retailer handoff.
4. Bag actions — Continue styling or move to a retailer.

## Approved exact copy

```json
{
  "eyebrow": null,
  "headline": "Your picks.",
  "supporting_copy": "One more look before you shop.",
  "primary_cta": "Shop at retailer",
  "secondary_cta": "Keep styling",
  "tertiary_cta": null,
  "navigation": {
    "report": "Report",
    "style": "Live styling",
    "bag": "Bag"
  },
  "labels": {
    "retailer_group": "From {{retailer_name}}",
    "availability": "Availability",
    "remove": "Remove",
    "subtotal": "Subtotal"
  },
  "helper_text": {
    "boundary": "You’ll check out with each retailer."
  },
  "validation": {},
  "status_messages": {},
  "consent": {}
}
```

## Art direction

Use premium editorial product photography and a clear shopping-decision interface. Keep price, availability, size context, rationale, bag grouping, and retailer boundaries easy to scan. Do not add retailer logos, checkout UI, payment controls, inventory claims, or fit guarantees.

Show the ordinary usable base state with the primary task immediately clear.

Use the approved Acid Dispatch / Editorial Edge system: White and Cloud canvases, Ink structure, Acid only for the primary action or active signal, Pale/Deep supporting fields, Instrument Serif for short editorial moments, Space Grotesk for product clarity, 999 px buttons, 24 px cards, visible focus treatment, restrained shadows, and realistic fashion imagery only where the wireframe provides media or product content.

## Desktop prompt

Create one flat, straight-on desktop frontend raster comp for this exact screen/state. Use the approved desktop wireframe as the strict composition reference. Preserve the current job, section order, control placement, navigation, primary-action priority, and named state. Use realistic production-sized controls and readable density. Do not add a browser/device frame, annotations, alternate screens, proof, metrics, retailer logos, new features, purple/blue AI gradients, glassmorphism, or generic dashboard cards.

Canonical output: `company/artifacts/screen-mockups/screens/magic-mirror-bag-base/base/magic-mirror-bag-base-desktop.png`

## Mobile prompt

Create one flat, straight-on mobile frontend raster comp for this exact screen/state. Use the approved mobile wireframe as its own structural reference; do not shrink desktop. Recompose navigation, content order, image crops, and actions for a narrow viewport while preserving the same job and priority. Use large touch targets and legible text. Do not add a phone frame, browser chrome, annotations, alternate screens, or new product behavior.

Canonical output: `company/artifacts/screen-mockups/screens/magic-mirror-bag-base/base/magic-mirror-bag-base-mobile.png`

## Output and QA rules

- One screen/state/viewport per final PNG.
- Generated lettering is approximate; the copy manifest is authoritative.
- Use supplied production logo/icon references rather than redrawing the mark from text.
- The named state must be unmistakable.
- Preserve structure before decoration and implementation clarity before cinematic effect.
