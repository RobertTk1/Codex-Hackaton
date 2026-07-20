# Style Report Analysis — Slow ImageGen Brief

Screen ID: `762423ae-d732-4325-bed9-b91b42370ca9`  
Screen slug: `style-report-analysis-slow`  
State: `slow`  
Surface: `system`  
Family: `report`  
Route/context: `/style-report/processing`  
User job: Post-120-second state confirming continued processing, preserved inputs, email notification, and safe exit.  
Primary action: `Email me when it’s ready`

## Authoritative references

- Approved desktop wireframe: `company/artifacts/ui-ux-design/wireframes/png/style-report-analysis-slow/slow/desktop-screen.png`
- Approved mobile wireframe: `company/artifacts/ui-ux-design/wireframes/png/style-report-analysis-slow/slow/mobile-screen.png`
- Exact copy: `company/artifacts/copy/copy-manifest.json#style-report-analysis-slow/slow`
- Shared direction: `company/artifacts/screen-mockups/design-direction.md`
- Application continuity reference: `company/artifacts/screen-mockups/screens/personal-profile-base/base/personal-profile-base-desktop.png`
- Live-styling continuity reference when applicable: `company/artifacts/screen-mockups/screens/live-styling-ready/base/live-styling-ready-desktop.png`

## Fixed section order

1. Analysis status header — Provide global status and safe exit.
2. Analysis state — Show meaningful processing, slow, or recovery behavior.
3. Preservation and notification — Confirm saved inputs and available next actions.

## Approved exact copy

```json
{
  "eyebrow": null,
  "headline": "Still putting the finishing touches on your report.",
  "supporting_copy": "It’s taking a little longer, but you don’t need to stay on this page.",
  "primary_cta": "Email me when it’s ready",
  "secondary_cta": "Come back later",
  "tertiary_cta": null,
  "navigation": {},
  "labels": {},
  "helper_text": {},
  "validation": {},
  "status_messages": {
    "slow": "Still building your report…",
    "saved": "Everything you added is saved."
  },
  "consent": {}
}
```

## Art direction

Use an editorial personal-report system: strong Instrument Serif moments, Space Grotesk data clarity, thoughtful color chips, silhouette or outfit imagery, and believable report modules. Avoid generic analytics dashboards. Make findings feel useful, personal, and visually connected to clothing.

Show continued work beyond the normal target with waiting and alternate actions clearly separated.

Use the approved Acid Dispatch / Editorial Edge system: White and Cloud canvases, Ink structure, Acid only for the primary action or active signal, Pale/Deep supporting fields, Instrument Serif for short editorial moments, Space Grotesk for product clarity, 999 px buttons, 24 px cards, visible focus treatment, restrained shadows, and realistic fashion imagery only where the wireframe provides media or product content.

## Desktop prompt

Create one flat, straight-on desktop frontend raster comp for this exact screen/state. Use the approved desktop wireframe as the strict composition reference. Preserve the current job, section order, control placement, navigation, primary-action priority, and named state. Use realistic production-sized controls and readable density. Do not add a browser/device frame, annotations, alternate screens, proof, metrics, retailer logos, new features, purple/blue AI gradients, glassmorphism, or generic dashboard cards.

Canonical output: `company/artifacts/screen-mockups/screens/style-report-analysis-slow/slow/style-report-analysis-slow-desktop.png`

## Mobile prompt

Create one flat, straight-on mobile frontend raster comp for this exact screen/state. Use the approved mobile wireframe as its own structural reference; do not shrink desktop. Recompose navigation, content order, image crops, and actions for a narrow viewport while preserving the same job and priority. Use large touch targets and legible text. Do not add a phone frame, browser chrome, annotations, alternate screens, or new product behavior.

Canonical output: `company/artifacts/screen-mockups/screens/style-report-analysis-slow/slow/style-report-analysis-slow-mobile.png`

## Output and QA rules

- One screen/state/viewport per final PNG.
- Generated lettering is approximate; the copy manifest is authoritative.
- Use supplied production logo/icon references rather than redrawing the mark from text.
- The named state must be unmistakable.
- Preserve structure before decoration and implementation clarity before cinematic effect.
