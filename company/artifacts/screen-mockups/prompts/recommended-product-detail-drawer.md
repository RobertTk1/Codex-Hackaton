# Recommended Product — Detail Drawer ImageGen Brief

Screen ID: `a7d262bf-0e4a-423f-9d51-fed5b2594b14`  
Screen slug: `recommended-product-detail-drawer`  
State: `base`  
Surface: `product`  
Family: `commerce`  
Route/context: `product-detail-drawer`  
User job: Product detail, report rationale, size context, retailer provenance, known price and availability, and session-preserving actions.  
Primary action: `Add to bag`

## Authoritative references

- Approved desktop wireframe: `company/artifacts/ui-ux-design/wireframes/png/recommended-product-detail-drawer/base/desktop-screen.png`
- Approved mobile wireframe: `company/artifacts/ui-ux-design/wireframes/png/recommended-product-detail-drawer/base/mobile-screen.png`
- Exact copy: `company/artifacts/copy/copy-manifest.json#recommended-product-detail-drawer/base`
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
  "eyebrow": "PICKED FOR YOU",
  "headline": "{{product_name}}",
  "supporting_copy": "See why it works with your style, then try it on or save it for later.",
  "primary_cta": "Add to bag",
  "secondary_cta": "Try it on",
  "tertiary_cta": "Shop at retailer",
  "navigation": {},
  "labels": {
    "retailer": "Retailer",
    "price": "Price",
    "availability": "Availability",
    "size": "Your usual size",
    "rationale": "Why it works",
    "checked": "Last checked"
  },
  "helper_text": {
    "limitation": "Check the retailer for current price, availability, and fit."
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

Canonical output: `company/artifacts/screen-mockups/screens/recommended-product-detail-drawer/base/recommended-product-detail-drawer-desktop.png`

## Mobile prompt

Create one flat, straight-on mobile frontend raster comp for this exact screen/state. Use the approved mobile wireframe as its own structural reference; do not shrink desktop. Recompose navigation, content order, image crops, and actions for a narrow viewport while preserving the same job and priority. Use large touch targets and legible text. Do not add a phone frame, browser chrome, annotations, alternate screens, or new product behavior.

Canonical output: `company/artifacts/screen-mockups/screens/recommended-product-detail-drawer/base/recommended-product-detail-drawer-mobile.png`

## Output and QA rules

- One screen/state/viewport per final PNG.
- Generated lettering is approximate; the copy manifest is authoritative.
- Use supplied production logo/icon references rather than redrawing the mark from text.
- The named state must be unmistakable.
- Preserve structure before decoration and implementation clarity before cinematic effect.
