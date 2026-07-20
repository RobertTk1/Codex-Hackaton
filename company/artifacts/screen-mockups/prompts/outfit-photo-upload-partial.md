# Outfit Photo Upload — Partial ImageGen Brief

Screen ID: `7628f30f-b601-49ab-93eb-2cc367ab1b2e`  
Screen slug: `outfit-photo-upload-partial`  
State: `partial`  
Surface: `product`  
Family: `onboarding`  
Route/context: `/style-report/photos`  
User job: Grid of uploaded and validating images with count progress, replacement, removal, and continue behavior.  
Primary action: `Refine my taste`

## Authoritative references

- Approved desktop wireframe: `company/artifacts/ui-ux-design/wireframes/png/outfit-photo-upload-partial/partial/desktop-screen.png`
- Approved mobile wireframe: `company/artifacts/ui-ux-design/wireframes/png/outfit-photo-upload-partial/partial/mobile-screen.png`
- Exact copy: `company/artifacts/copy/copy-manifest.json#outfit-photo-upload-partial/partial`
- Shared direction: `company/artifacts/screen-mockups/design-direction.md`
- Application continuity reference: `company/artifacts/screen-mockups/screens/personal-profile-base/base/personal-profile-base-desktop.png`
- Live-styling continuity reference when applicable: `company/artifacts/screen-mockups/screens/live-styling-ready/base/live-styling-ready-desktop.png`

## Fixed section order

1. Onboarding progress — Show position and required image count.
2. Photo guidance — Explain consent, quality, minimum, maximum, and use.
3. Upload workspace — Show per-image status, replacement, and preservation.
4. Step actions — Enable continuation only when the minimum is valid.

## Approved exact copy

```json
{
  "eyebrow": "STEP 3 OF 4",
  "headline": "Your style is taking shape.",
  "supporting_copy": "Add at least 8 photos, then follow your first instinct through a few more looks.",
  "primary_cta": "Refine my taste",
  "secondary_cta": "Add more photos",
  "tertiary_cta": "Save and exit",
  "navigation": {},
  "labels": {
    "ready": "Ready",
    "checking": "Checking",
    "replace": "Replace",
    "remove": "Remove"
  },
  "helper_text": {
    "minimum": "You can continue once 8 photos are ready."
  },
  "validation": {},
  "status_messages": {
    "uploading": "Uploading…",
    "validating": "Checking photo…",
    "ready": "Ready"
  },
  "consent": {}
}
```

## Art direction

Use calm, progressive onboarding with a narrow task column, clear progress, realistic form/upload/card controls, and one obvious Acid action. Editorial imagery may orient the step but must not obstruct inputs. Preserve completed work and recovery guidance visually when the state requires it.

Show several completed items alongside checking or incomplete items; continuation should be visibly available only when requirements are met.

Use the approved Acid Dispatch / Editorial Edge system: White and Cloud canvases, Ink structure, Acid only for the primary action or active signal, Pale/Deep supporting fields, Instrument Serif for short editorial moments, Space Grotesk for product clarity, 999 px buttons, 24 px cards, visible focus treatment, restrained shadows, and realistic fashion imagery only where the wireframe provides media or product content.

## Desktop prompt

Create one flat, straight-on desktop frontend raster comp for this exact screen/state. Use the approved desktop wireframe as the strict composition reference. Preserve the current job, section order, control placement, navigation, primary-action priority, and named state. Use realistic production-sized controls and readable density. Do not add a browser/device frame, annotations, alternate screens, proof, metrics, retailer logos, new features, purple/blue AI gradients, glassmorphism, or generic dashboard cards.

Canonical output: `company/artifacts/screen-mockups/screens/outfit-photo-upload-partial/partial/outfit-photo-upload-partial-desktop.png`

## Mobile prompt

Create one flat, straight-on mobile frontend raster comp for this exact screen/state. Use the approved mobile wireframe as its own structural reference; do not shrink desktop. Recompose navigation, content order, image crops, and actions for a narrow viewport while preserving the same job and priority. Use large touch targets and legible text. Do not add a phone frame, browser chrome, annotations, alternate screens, or new product behavior.

Canonical output: `company/artifacts/screen-mockups/screens/outfit-photo-upload-partial/partial/outfit-photo-upload-partial-mobile.png`

## Output and QA rules

- One screen/state/viewport per final PNG.
- Generated lettering is approximate; the copy manifest is authoritative.
- Use supplied production logo/icon references rather than redrawing the mark from text.
- The named state must be unmistakable.
- Preserve structure before decoration and implementation clarity before cinematic effect.
