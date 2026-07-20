# Retailer Handoff — Confirmation ImageGen Brief

Screen ID: `49c5dc8e-da7f-433d-bba0-5011bb755948`  
Screen slug: `retailer-handoff-confirmation`  
State: `base`  
Surface: `external-handoff`  
Family: `commerce`  
Route/context: `retailer-handoff-dialog`  
User job: Final confirmation that identifies retailer ownership of checkout, stock, price, fulfillment, and returns before navigation.  
Primary action: `Shop at {{retailer_name}}`

## Authoritative references

- Approved desktop wireframe: `company/artifacts/ui-ux-design/wireframes/png/retailer-handoff-confirmation/base/desktop-screen.png`
- Approved mobile wireframe: `company/artifacts/ui-ux-design/wireframes/png/retailer-handoff-confirmation/base/mobile-screen.png`
- Exact copy: `company/artifacts/copy/copy-manifest.json#retailer-handoff-confirmation/base`
- Shared direction: `company/artifacts/screen-mockups/design-direction.md`
- Application continuity reference: `company/artifacts/screen-mockups/screens/personal-profile-base/base/personal-profile-base-desktop.png`
- Live-styling continuity reference when applicable: `company/artifacts/screen-mockups/screens/live-styling-ready/base/live-styling-ready-desktop.png`

## Fixed section order

1. Preserved bag context — Keep the selected item and bag visible behind confirmation.
2. Retailer confirmation — Confirm destination ownership and the external handoff.

## Approved exact copy

```json
{
  "eyebrow": null,
  "headline": "Ready to shop at {{retailer_name}}?",
  "supporting_copy": "You’ll finish your purchase on their site. Your picks will be here when you come back.",
  "primary_cta": "Shop at {{retailer_name}}",
  "secondary_cta": "Not yet",
  "tertiary_cta": null,
  "navigation": {},
  "labels": {},
  "helper_text": {},
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

Canonical output: `company/artifacts/screen-mockups/screens/retailer-handoff-confirmation/base/retailer-handoff-confirmation-desktop.png`

## Mobile prompt

Create one flat, straight-on mobile frontend raster comp for this exact screen/state. Use the approved mobile wireframe as its own structural reference; do not shrink desktop. Recompose navigation, content order, image crops, and actions for a narrow viewport while preserving the same job and priority. Use large touch targets and legible text. Do not add a phone frame, browser chrome, annotations, alternate screens, or new product behavior.

Canonical output: `company/artifacts/screen-mockups/screens/retailer-handoff-confirmation/base/retailer-handoff-confirmation-mobile.png`

## Output and QA rules

- One screen/state/viewport per final PNG.
- Generated lettering is approximate; the copy manifest is authoritative.
- Use supplied production logo/icon references rather than redrawing the mark from text.
- The named state must be unmistakable.
- Preserve structure before decoration and implementation clarity before cinematic effect.
