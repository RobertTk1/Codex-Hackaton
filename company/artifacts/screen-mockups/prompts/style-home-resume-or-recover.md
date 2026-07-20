# Style Home — Resume or Recover ImageGen Brief

Screen ID: `dd9e7858-c66f-5351-a51c-dd63a8b11d7a`  
Screen slug: `style-home-resume-or-recover`  
State: `recovery`  
Surface: `product`  
Family: `report`  
Route/context: `/style`  
User job: Returning-customer home when incomplete or failed work needs a specific resume or recovery action.  
Primary action: `Keep going`

## Authoritative references

- Approved desktop wireframe: `company/artifacts/ui-ux-design/wireframes/png/style-home-resume-or-recover/recovery/desktop-screen.png`
- Approved mobile wireframe: `company/artifacts/ui-ux-design/wireframes/png/style-home-resume-or-recover/recovery/mobile-screen.png`
- Exact copy: `company/artifacts/copy/copy-manifest.json#style-home-resume-or-recover/recovery`
- Shared direction: `company/artifacts/screen-mockups/design-direction.md`
- Application continuity reference: `company/artifacts/screen-mockups/screens/personal-profile-base/base/personal-profile-base-desktop.png`
- Live-styling continuity reference when applicable: `company/artifacts/screen-mockups/screens/live-styling-ready/base/live-styling-ready-desktop.png`

## Fixed section order

1. App navigation — Orient returning users and expose core destinations.
2. Current status — Show the current report or recovery priority.
3. Report highlights — Summarize useful findings.
4. Recommended items — Preview personalized products and refinements.
5. Saved and recent activity — Expose bag, sessions, and account continuity.

## Approved exact copy

```json
{
  "eyebrow": null,
  "headline": "Right where you left it.",
  "supporting_copy": "Your style report is waiting.",
  "primary_cta": "Keep going",
  "secondary_cta": "Try again",
  "tertiary_cta": "View my report",
  "navigation": {},
  "labels": {
    "incomplete": "Continue",
    "paused": "Try again",
    "ready": "Ready"
  },
  "helper_text": {},
  "validation": {},
  "status_messages": {
    "saved": "Your progress is saved."
  },
  "consent": {}
}
```

## Art direction

Use an editorial personal-report system: strong Instrument Serif moments, Space Grotesk data clarity, thoughtful color chips, silhouette or outfit imagery, and believable report modules. Avoid generic analytics dashboards. Make findings feel useful, personal, and visually connected to clothing.

Show preserved progress and a clear retry or alternate route; avoid alarmist visuals.

Use the approved Acid Dispatch / Editorial Edge system: White and Cloud canvases, Ink structure, Acid only for the primary action or active signal, Pale/Deep supporting fields, Instrument Serif for short editorial moments, Space Grotesk for product clarity, 999 px buttons, 24 px cards, visible focus treatment, restrained shadows, and realistic fashion imagery only where the wireframe provides media or product content.

## Desktop prompt

Create one flat, straight-on desktop frontend raster comp for this exact screen/state. Use the approved desktop wireframe as the strict composition reference. Preserve the current job, section order, control placement, navigation, primary-action priority, and named state. Use realistic production-sized controls and readable density. Do not add a browser/device frame, annotations, alternate screens, proof, metrics, retailer logos, new features, purple/blue AI gradients, glassmorphism, or generic dashboard cards.

Canonical output: `company/artifacts/screen-mockups/screens/style-home-resume-or-recover/recovery/style-home-resume-or-recover-desktop.png`

## Mobile prompt

Create one flat, straight-on mobile frontend raster comp for this exact screen/state. Use the approved mobile wireframe as its own structural reference; do not shrink desktop. Recompose navigation, content order, image crops, and actions for a narrow viewport while preserving the same job and priority. Use large touch targets and legible text. Do not add a phone frame, browser chrome, annotations, alternate screens, or new product behavior.

Canonical output: `company/artifacts/screen-mockups/screens/style-home-resume-or-recover/recovery/style-home-resume-or-recover-mobile.png`

## Output and QA rules

- One screen/state/viewport per final PNG.
- Generated lettering is approximate; the copy manifest is authoritative.
- Use supplied production logo/icon references rather than redrawing the mark from text.
- The named state must be unmistakable.
- Preserve structure before decoration and implementation clarity before cinematic effect.
