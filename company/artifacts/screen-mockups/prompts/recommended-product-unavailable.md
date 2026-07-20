# Recommended Product — Unavailable ImageGen Brief

Screen ID: `7dc86399-4d75-56ec-a7a7-975b78b7992f`  
Screen slug: `recommended-product-unavailable`  
State: `unavailable`  
Surface: `product`  
Family: `commerce`  
Route/context: `product-detail-drawer`  
User job: Unavailable recommended-product state with alternatives and preserved context.  
Primary action: `See similar`

## Authoritative references

- Approved desktop wireframe: `company/artifacts/ui-ux-design/wireframes/png/recommended-product-unavailable/unavailable/desktop-screen.png`
- Approved mobile wireframe: `company/artifacts/ui-ux-design/wireframes/png/recommended-product-unavailable/unavailable/mobile-screen.png`
- Exact copy: `company/artifacts/copy/copy-manifest.json#recommended-product-unavailable/unavailable`
- Shared direction: `company/artifacts/screen-mockups/design-direction.md`
- Application continuity reference: `company/artifacts/screen-mockups/screens/personal-profile-base/base/personal-profile-base-desktop.png`
- Live-styling continuity reference when applicable: `company/artifacts/screen-mockups/screens/live-styling-ready/base/live-styling-ready-desktop.png`

## Fixed section order

1. Context navigation — Preserve product, report, bag, and close routes.
2. Preserved styling context — Keep the report or live session visible behind product detail.
3. Product detail drawer — Show product provenance, rationale, availability, and actions.
4. Selection actions — Add, try, find alternatives, or continue externally.

## Approved exact copy

```json
{
  "eyebrow": null,
  "headline": "This one sold out.",
  "supporting_copy": "We found similar pieces that work for the same reason.",
  "primary_cta": "See similar",
  "secondary_cta": "Close",
  "tertiary_cta": "Back to my picks",
  "navigation": {},
  "labels": {},
  "helper_text": {
    "freshness": "Availability can change."
  },
  "validation": {},
  "status_messages": {
    "unavailable": "Sold out"
  },
  "consent": {}
}
```

## Art direction

Use premium editorial product photography and a clear shopping-decision interface. Keep price, availability, size context, rationale, bag grouping, and retailer boundaries easy to scan. Do not add retailer logos, checkout UI, payment controls, inventory claims, or fit guarantees.

Show the unavailable product in context, preserve other selections, and prioritize similar alternatives.

Use the approved Acid Dispatch / Editorial Edge system: White and Cloud canvases, Ink structure, Acid only for the primary action or active signal, Pale/Deep supporting fields, Instrument Serif for short editorial moments, Space Grotesk for product clarity, 999 px buttons, 24 px cards, visible focus treatment, restrained shadows, and realistic fashion imagery only where the wireframe provides media or product content.

## Desktop prompt

Create one flat, straight-on desktop frontend raster comp for this exact screen/state. Use the approved desktop wireframe as the strict composition reference. Preserve the current job, section order, control placement, navigation, primary-action priority, and named state. Use realistic production-sized controls and readable density. Do not add a browser/device frame, annotations, alternate screens, proof, metrics, retailer logos, new features, purple/blue AI gradients, glassmorphism, or generic dashboard cards.

Canonical output: `company/artifacts/screen-mockups/screens/recommended-product-unavailable/unavailable/recommended-product-unavailable-desktop.png`

## Mobile prompt

Create one flat, straight-on mobile frontend raster comp for this exact screen/state. Use the approved mobile wireframe as its own structural reference; do not shrink desktop. Recompose navigation, content order, image crops, and actions for a narrow viewport while preserving the same job and priority. Use large touch targets and legible text. Do not add a phone frame, browser chrome, annotations, alternate screens, or new product behavior.

Canonical output: `company/artifacts/screen-mockups/screens/recommended-product-unavailable/unavailable/recommended-product-unavailable-mobile.png`

## Output and QA rules

- One screen/state/viewport per final PNG.
- Generated lettering is approximate; the copy manifest is authoritative.
- Use supplied production logo/icon references rather than redrawing the mark from text.
- The named state must be unmistakable.
- Preserve structure before decoration and implementation clarity before cinematic effect.
