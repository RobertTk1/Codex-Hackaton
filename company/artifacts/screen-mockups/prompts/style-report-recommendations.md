# Style Report — Recommendations ImageGen Brief

Screen ID: `ec0e2f41-d712-48b1-83fe-c535b1438a12`  
Screen slug: `style-report-recommendations`  
State: `base`  
Surface: `product`  
Family: `report`  
Route/context: `/report/recommendations`  
User job: Prioritized silhouettes, proportions, layers, fabrics, garments, and outfit guidance tied to report evidence.  
Primary action: `See my picks`

## Authoritative references

- Approved desktop wireframe: `company/artifacts/ui-ux-design/wireframes/png/style-report-recommendations/base/desktop-screen.png`
- Approved mobile wireframe: `company/artifacts/ui-ux-design/wireframes/png/style-report-recommendations/base/mobile-screen.png`
- Exact copy: `company/artifacts/copy/copy-manifest.json#style-report-recommendations/base`
- Shared direction: `company/artifacts/screen-mockups/design-direction.md`
- Application continuity reference: `company/artifacts/screen-mockups/screens/personal-profile-base/base/personal-profile-base-desktop.png`
- Live-styling continuity reference when applicable: `company/artifacts/screen-mockups/screens/live-styling-ready/base/live-styling-ready-desktop.png`

## Fixed section order

1. Report navigation — Move across report modules.
2. Recommendation summary — Prioritize the most material recommendations.
3. Recommendation categories — Structure silhouettes, layers, fabrics, and garments.
4. Example outfits — Connect guidance to visible outfit structures.
5. Matched products — Open personalized product sets.

## Approved exact copy

```json
{
  "eyebrow": "WHAT TO WEAR NEXT",
  "headline": "Your next looks, already styled.",
  "supporting_copy": "Explore pieces and outfit ideas chosen to work with your colors, proportions, and taste.",
  "primary_cta": "See my picks",
  "secondary_cta": "Save this guide",
  "tertiary_cta": null,
  "navigation": {
    "overview": "Overview",
    "colors": "Colors",
    "body_style": "Body style",
    "recommendations": "Recommendations"
  },
  "labels": {
    "silhouettes": "Silhouettes",
    "proportions": "Proportions",
    "layers": "Layers",
    "fabrics": "Fabrics",
    "outfits": "Example outfits",
    "reason": "Why this works for you"
  },
  "helper_text": {},
  "validation": {},
  "status_messages": {},
  "consent": {}
}
```

## Art direction

Use an editorial personal-report system: strong Instrument Serif moments, Space Grotesk data clarity, thoughtful color chips, silhouette or outfit imagery, and believable report modules. Avoid generic analytics dashboards. Make findings feel useful, personal, and visually connected to clothing.

Show the ordinary usable base state with the primary task immediately clear.

Use the approved Acid Dispatch / Editorial Edge system: White and Cloud canvases, Ink structure, Acid only for the primary action or active signal, Pale/Deep supporting fields, Instrument Serif for short editorial moments, Space Grotesk for product clarity, 999 px buttons, 24 px cards, visible focus treatment, restrained shadows, and realistic fashion imagery only where the wireframe provides media or product content.

## Desktop prompt

Create one flat, straight-on desktop frontend raster comp for this exact screen/state. Use the approved desktop wireframe as the strict composition reference. Preserve the current job, section order, control placement, navigation, primary-action priority, and named state. Use realistic production-sized controls and readable density. Do not add a browser/device frame, annotations, alternate screens, proof, metrics, retailer logos, new features, purple/blue AI gradients, glassmorphism, or generic dashboard cards.

Canonical output: `company/artifacts/screen-mockups/screens/style-report-recommendations/base/style-report-recommendations-desktop.png`

## Mobile prompt

Create one flat, straight-on mobile frontend raster comp for this exact screen/state. Use the approved mobile wireframe as its own structural reference; do not shrink desktop. Recompose navigation, content order, image crops, and actions for a narrow viewport while preserving the same job and priority. Use large touch targets and legible text. Do not add a phone frame, browser chrome, annotations, alternate screens, or new product behavior.

Canonical output: `company/artifacts/screen-mockups/screens/style-report-recommendations/base/style-report-recommendations-mobile.png`

## Output and QA rules

- One screen/state/viewport per final PNG.
- Generated lettering is approximate; the copy manifest is authoritative.
- Use supplied production logo/icon references rather than redrawing the mark from text.
- The named state must be unmistakable.
- Preserve structure before decoration and implementation clarity before cinematic effect.
