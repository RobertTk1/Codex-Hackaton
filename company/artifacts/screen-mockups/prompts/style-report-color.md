# Style Report — Color ImageGen Brief

Screen ID: `b16feadb-5618-46fc-b03f-be77d1de7b4f`  
Screen slug: `style-report-color`  
State: `base`  
Surface: `product`  
Family: `report`  
Route/context: `/report/colors`  
User job: Personal palette, neutrals, accents, combinations, text equivalents, explanations, and feedback.  
Primary action: `Find pieces in my colors`

## Authoritative references

- Approved desktop wireframe: `company/artifacts/ui-ux-design/wireframes/png/style-report-color/base/desktop-screen.png`
- Approved mobile wireframe: `company/artifacts/ui-ux-design/wireframes/png/style-report-color/base/mobile-screen.png`
- Exact copy: `company/artifacts/copy/copy-manifest.json#style-report-color/base`
- Shared direction: `company/artifacts/screen-mockups/design-direction.md`
- Application continuity reference: `company/artifacts/screen-mockups/screens/personal-profile-base/base/personal-profile-base-desktop.png`
- Live-styling continuity reference when applicable: `company/artifacts/screen-mockups/screens/live-styling-ready/base/live-styling-ready-desktop.png`

## Fixed section order

1. Report navigation — Move across report modules.
2. Color summary — Introduce the palette and usage context.
3. Labeled palette — Pair every swatch with text and usage labels.
4. Combination examples — Show usable combinations and examples.
5. Feedback and products — Provide feedback and matched-item actions.

## Approved exact copy

```json
{
  "eyebrow": "YOUR COLORS",
  "headline": "Meet your colors.",
  "supporting_copy": "A personal palette for getting dressed, shopping smarter, and trying something new.",
  "primary_cta": "Find pieces in my colors",
  "secondary_cta": "Save my palette",
  "tertiary_cta": "Update my colors",
  "navigation": {
    "overview": "Overview",
    "colors": "Colors",
    "body_style": "Body style",
    "recommendations": "Recommendations"
  },
  "labels": {
    "primary": "Core colors",
    "neutrals": "Everyday neutrals",
    "accents": "Accent colors",
    "combinations": "Try these together"
  },
  "helper_text": {
    "accessibility": "Each color includes a name and a way to wear it.",
    "intent": "Think of this as a guide, not a rulebook."
  },
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

Canonical output: `company/artifacts/screen-mockups/screens/style-report-color/base/style-report-color-desktop.png`

## Mobile prompt

Create one flat, straight-on mobile frontend raster comp for this exact screen/state. Use the approved mobile wireframe as its own structural reference; do not shrink desktop. Recompose navigation, content order, image crops, and actions for a narrow viewport while preserving the same job and priority. Use large touch targets and legible text. Do not add a phone frame, browser chrome, annotations, alternate screens, or new product behavior.

Canonical output: `company/artifacts/screen-mockups/screens/style-report-color/base/style-report-color-mobile.png`

## Output and QA rules

- One screen/state/viewport per final PNG.
- Generated lettering is approximate; the copy manifest is authoritative.
- Use supplied production logo/icon references rather than redrawing the mark from text.
- The named state must be unmistakable.
- Preserve structure before decoration and implementation clarity before cinematic effect.
