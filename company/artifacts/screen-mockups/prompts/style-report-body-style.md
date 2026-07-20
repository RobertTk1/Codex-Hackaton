# Style Report — Body Style ImageGen Brief

Screen ID: `3acb5ce5-518b-4cf3-beba-ce38439031e2`  
Screen slug: `style-report-body-style`  
State: `base`  
Surface: `product`  
Family: `report`  
Route/context: `/report/body-style`  
User job: Kibbe-informed profile, visual rationale, confidence, practical implications, and recalibration path.  
Primary action: `See my silhouettes`

## Authoritative references

- Approved desktop wireframe: `company/artifacts/ui-ux-design/wireframes/png/style-report-body-style/base/desktop-screen.png`
- Approved mobile wireframe: `company/artifacts/ui-ux-design/wireframes/png/style-report-body-style/base/mobile-screen.png`
- Exact copy: `company/artifacts/copy/copy-manifest.json#style-report-body-style/base`
- Shared direction: `company/artifacts/screen-mockups/design-direction.md`
- Application continuity reference: `company/artifacts/screen-mockups/screens/personal-profile-base/base/personal-profile-base-desktop.png`
- Live-styling continuity reference when applicable: `company/artifacts/screen-mockups/screens/live-styling-ready/base/live-styling-ready-desktop.png`

## Fixed section order

1. Report navigation — Move across report modules.
2. Body-style summary — Present profile, rationale, and confidence.
3. Proportion guidance — Translate the framework into practical silhouette guidance.
4. What to wear — Organize actionable garment and outfit patterns.
5. Feedback — Allow disagreement and recalibration.

## Approved exact copy

```json
{
  "eyebrow": "YOUR STYLE LINES",
  "headline": "Shapes that work with you.",
  "supporting_copy": "Discover the silhouettes, proportions, and details that bring your style into balance.",
  "primary_cta": "See my silhouettes",
  "secondary_cta": "Update my result",
  "tertiary_cta": null,
  "navigation": {
    "overview": "Overview",
    "colors": "Colors",
    "body_style": "Body style",
    "recommendations": "Recommendations"
  },
  "labels": {
    "profile": "Your Kibbe-inspired type",
    "confidence": "Match",
    "rationale": "Why it fits",
    "implications": "Try this"
  },
  "helper_text": {
    "framework": "This is a starting point. Keep what feels right."
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

Canonical output: `company/artifacts/screen-mockups/screens/style-report-body-style/base/style-report-body-style-desktop.png`

## Mobile prompt

Create one flat, straight-on mobile frontend raster comp for this exact screen/state. Use the approved mobile wireframe as its own structural reference; do not shrink desktop. Recompose navigation, content order, image crops, and actions for a narrow viewport while preserving the same job and priority. Use large touch targets and legible text. Do not add a phone frame, browser chrome, annotations, alternate screens, or new product behavior.

Canonical output: `company/artifacts/screen-mockups/screens/style-report-body-style/base/style-report-body-style-mobile.png`

## Output and QA rules

- One screen/state/viewport per final PNG.
- Generated lettering is approximate; the copy manifest is authoritative.
- Use supplied production logo/icon references rather than redrawing the mark from text.
- The named state must be unmistakable.
- Preserve structure before decoration and implementation clarity before cinematic effect.
