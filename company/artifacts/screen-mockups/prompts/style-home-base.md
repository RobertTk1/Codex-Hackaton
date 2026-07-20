# Style Home — Base ImageGen Brief

Screen ID: `d677a738-5703-4b02-b7ca-667c31ac7555`  
Screen slug: `style-home-base`  
State: `base`  
Surface: `product`  
Family: `report`  
Route/context: `/style`  
User job: Returning-customer home with report highlights, selected recommendations, live styling entry, bag, and account access.  
Primary action: `Start styling`

## Authoritative references

- Approved desktop wireframe: `company/artifacts/ui-ux-design/wireframes/png/style-home-base/base/desktop-screen.png`
- Approved mobile wireframe: `company/artifacts/ui-ux-design/wireframes/png/style-home-base/base/mobile-screen.png`
- Exact copy: `company/artifacts/copy/copy-manifest.json#style-home-base/base`
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
  "headline": "What are you in the mood to wear, {{preferred_name}}?",
  "supporting_copy": null,
  "primary_cta": "Start styling",
  "secondary_cta": "View my report",
  "tertiary_cta": "Browse my picks",
  "navigation": {
    "home": "Style home",
    "report": "My report",
    "picks": "My picks",
    "bag": "Bag",
    "profile": "Profile"
  },
  "labels": {
    "report": "Report highlights",
    "next": "Recommended next step",
    "picks": "Selected for you",
    "recent": "Recent activity"
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

Canonical output: `company/artifacts/screen-mockups/screens/style-home-base/base/style-home-base-desktop.png`

## Mobile prompt

Create one flat, straight-on mobile frontend raster comp for this exact screen/state. Use the approved mobile wireframe as its own structural reference; do not shrink desktop. Recompose navigation, content order, image crops, and actions for a narrow viewport while preserving the same job and priority. Use large touch targets and legible text. Do not add a phone frame, browser chrome, annotations, alternate screens, or new product behavior.

Canonical output: `company/artifacts/screen-mockups/screens/style-home-base/base/style-home-base-mobile.png`

## Output and QA rules

- One screen/state/viewport per final PNG.
- Generated lettering is approximate; the copy manifest is authoritative.
- Use supplied production logo/icon references rather than redrawing the mark from text.
- The named state must be unmistakable.
- Preserve structure before decoration and implementation clarity before cinematic effect.
