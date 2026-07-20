# Style Report — Overview ImageGen Brief

Screen ID: `1c2d940e-9782-4d23-866a-9e676af44138`  
Screen slug: `style-report-overview`  
State: `success`  
Surface: `product`  
Family: `report`  
Route/context: `/report`  
User job: Affirming style identity, strongest patterns, prioritized opportunities, report navigation, and next styling action.  
Primary action: `Explore my report`

## Authoritative references

- Approved desktop wireframe: `company/artifacts/ui-ux-design/wireframes/png/style-report-overview/success/desktop-screen.png`
- Approved mobile wireframe: `company/artifacts/ui-ux-design/wireframes/png/style-report-overview/success/mobile-screen.png`
- Exact copy: `company/artifacts/copy/copy-manifest.json#style-report-overview/success`
- Shared direction: `company/artifacts/screen-mockups/design-direction.md`
- Application continuity reference: `company/artifacts/screen-mockups/screens/personal-profile-base/base/personal-profile-base-desktop.png`
- Live-styling continuity reference when applicable: `company/artifacts/screen-mockups/screens/live-styling-ready/base/live-styling-ready-desktop.png`

## Fixed section order

1. Report navigation — Introduce the report structure.
2. Style identity summary — Lead with strengths and prioritized opportunities.
3. Key findings — Summarize the major report modules.
4. What to do next — Translate the report into a short action sequence.
5. Feedback and next action — Offer correction and styling routes.

## Approved exact copy

```json
{
  "eyebrow": "YOUR STYLE REPORT",
  "headline": "See what makes your style yours.",
  "supporting_copy": "Meet the patterns behind your strongest looks—and where to take them next.",
  "primary_cta": "Explore my report",
  "secondary_cta": "See my picks",
  "tertiary_cta": null,
  "navigation": {
    "overview": "Overview",
    "colors": "Colors",
    "body_style": "Body style",
    "recommendations": "Recommendations"
  },
  "labels": {
    "identity": "Your style identity",
    "strengths": "What’s already working",
    "priorities": "Try these first",
    "source": "Based on"
  },
  "helper_text": {
    "inference": "Something feel off? You can change it."
  },
  "validation": {},
  "status_messages": {},
  "consent": {}
}
```

## Art direction

Use an editorial personal-report system: strong Instrument Serif moments, Space Grotesk data clarity, thoughtful color chips, silhouette or outfit imagery, and believable report modules. Avoid generic analytics dashboards. Make findings feel useful, personal, and visually connected to clothing.

Show a confident completed result and an obvious next exploration action; no confetti.

Use the approved Acid Dispatch / Editorial Edge system: White and Cloud canvases, Ink structure, Acid only for the primary action or active signal, Pale/Deep supporting fields, Instrument Serif for short editorial moments, Space Grotesk for product clarity, 999 px buttons, 24 px cards, visible focus treatment, restrained shadows, and realistic fashion imagery only where the wireframe provides media or product content.

## Desktop prompt

Create one flat, straight-on desktop frontend raster comp for this exact screen/state. Use the approved desktop wireframe as the strict composition reference. Preserve the current job, section order, control placement, navigation, primary-action priority, and named state. Use realistic production-sized controls and readable density. Do not add a browser/device frame, annotations, alternate screens, proof, metrics, retailer logos, new features, purple/blue AI gradients, glassmorphism, or generic dashboard cards.

Canonical output: `company/artifacts/screen-mockups/screens/style-report-overview/success/style-report-overview-desktop.png`

## Mobile prompt

Create one flat, straight-on mobile frontend raster comp for this exact screen/state. Use the approved mobile wireframe as its own structural reference; do not shrink desktop. Recompose navigation, content order, image crops, and actions for a narrow viewport while preserving the same job and priority. Use large touch targets and legible text. Do not add a phone frame, browser chrome, annotations, alternate screens, or new product behavior.

Canonical output: `company/artifacts/screen-mockups/screens/style-report-overview/success/style-report-overview-mobile.png`

## Output and QA rules

- One screen/state/viewport per final PNG.
- Generated lettering is approximate; the copy manifest is authoritative.
- Use supplied production logo/icon references rather than redrawing the mark from text.
- The named state must be unmistakable.
- Preserve structure before decoration and implementation clarity before cinematic effect.
