# Style Report — Feedback and Recalibration ImageGen Brief

Screen ID: `4d345373-f991-5f0d-8ac7-5885e4a456f8`  
Screen slug: `style-report-feedback-and-recalibration`  
State: `feedback`  
Surface: `product`  
Family: `report`  
Route/context: `/report/feedback`  
User job: Correction and recalibration state shared by report findings.  
Primary action: `Update my report`

## Authoritative references

- Approved desktop wireframe: `company/artifacts/ui-ux-design/wireframes/png/style-report-feedback-and-recalibration/feedback/desktop-screen.png`
- Approved mobile wireframe: `company/artifacts/ui-ux-design/wireframes/png/style-report-feedback-and-recalibration/feedback/mobile-screen.png`
- Exact copy: `company/artifacts/copy/copy-manifest.json#style-report-feedback-and-recalibration/feedback`
- Shared direction: `company/artifacts/screen-mockups/design-direction.md`
- Application continuity reference: `company/artifacts/screen-mockups/screens/personal-profile-base/base/personal-profile-base-desktop.png`
- Live-styling continuity reference when applicable: `company/artifacts/screen-mockups/screens/live-styling-ready/base/live-styling-ready-desktop.png`

## Fixed section order

1. Report navigation — Preserve report context.
2. Feedback form — Capture correction, disagreement, or recalibration request.
3. Confirmation and next step — Submit or return without losing the report.

## Approved exact copy

```json
{
  "eyebrow": null,
  "headline": "Make this feel more like you.",
  "supporting_copy": "Tell us what missed the mark, and we’ll adjust your report.",
  "primary_cta": "Update my report",
  "secondary_cta": null,
  "tertiary_cta": "Cancel",
  "navigation": {},
  "labels": {
    "finding": "Your result",
    "feedback_type": "What feels off?",
    "correction": "What would you change?",
    "context": "Anything else? (optional)"
  },
  "helper_text": {
    "effect": "We’ll use your feedback to improve your report and picks."
  },
  "validation": {
    "required": "Choose what feels off and tell us what you’d change."
  },
  "status_messages": {},
  "consent": {}
}
```

## Art direction

Use an editorial personal-report system: strong Instrument Serif moments, Space Grotesk data clarity, thoughtful color chips, silhouette or outfit imagery, and believable report modules. Avoid generic analytics dashboards. Make findings feel useful, personal, and visually connected to clothing.

Show the current result in context with a focused correction form and one clear update action.

Use the approved Acid Dispatch / Editorial Edge system: White and Cloud canvases, Ink structure, Acid only for the primary action or active signal, Pale/Deep supporting fields, Instrument Serif for short editorial moments, Space Grotesk for product clarity, 999 px buttons, 24 px cards, visible focus treatment, restrained shadows, and realistic fashion imagery only where the wireframe provides media or product content.

## Desktop prompt

Create one flat, straight-on desktop frontend raster comp for this exact screen/state. Use the approved desktop wireframe as the strict composition reference. Preserve the current job, section order, control placement, navigation, primary-action priority, and named state. Use realistic production-sized controls and readable density. Do not add a browser/device frame, annotations, alternate screens, proof, metrics, retailer logos, new features, purple/blue AI gradients, glassmorphism, or generic dashboard cards.

Canonical output: `company/artifacts/screen-mockups/screens/style-report-feedback-and-recalibration/feedback/style-report-feedback-and-recalibration-desktop.png`

## Mobile prompt

Create one flat, straight-on mobile frontend raster comp for this exact screen/state. Use the approved mobile wireframe as its own structural reference; do not shrink desktop. Recompose navigation, content order, image crops, and actions for a narrow viewport while preserving the same job and priority. Use large touch targets and legible text. Do not add a phone frame, browser chrome, annotations, alternate screens, or new product behavior.

Canonical output: `company/artifacts/screen-mockups/screens/style-report-feedback-and-recalibration/feedback/style-report-feedback-and-recalibration-mobile.png`

## Output and QA rules

- One screen/state/viewport per final PNG.
- Generated lettering is approximate; the copy manifest is authoritative.
- Use supplied production logo/icon references rather than redrawing the mark from text.
- The named state must be unmistakable.
- Preserve structure before decoration and implementation clarity before cinematic effect.
