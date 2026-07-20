# Outfit Photo Upload — Empty ImageGen Brief

Screen ID: `bfc87225-7f0e-45c1-90f7-6623d96e9dad`  
Screen slug: `outfit-photo-upload-empty`  
State: `empty`  
Surface: `product`  
Family: `onboarding`  
Route/context: `/style-report/photos`  
User job: Photo guidance, analysis consent, upload entry, count rules, and image-use explanation before any image is selected.  
Primary action: `Choose photos`

## Authoritative references

- Approved desktop wireframe: `company/artifacts/ui-ux-design/wireframes/png/outfit-photo-upload-empty/empty/desktop-screen.png`
- Approved mobile wireframe: `company/artifacts/ui-ux-design/wireframes/png/outfit-photo-upload-empty/empty/mobile-screen.png`
- Exact copy: `company/artifacts/copy/copy-manifest.json#outfit-photo-upload-empty/empty`
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
  "headline": "Show us your favorite looks.",
  "supporting_copy": "Add 8–12 full-body photos of outfits you feel great in.",
  "primary_cta": "Choose photos",
  "secondary_cta": "Back",
  "tertiary_cta": "Save and exit",
  "navigation": {},
  "labels": {
    "count": "0 of 8 required photos",
    "accepted": "JPG, PNG, or HEIC"
  },
  "helper_text": {
    "quality": "Choose clear, well-lit photos that show your full outfit. One person per photo works best.",
    "range": "8 photos minimum. 12 maximum."
  },
  "validation": {
    "consent": "Agree to photo use before continuing."
  },
  "status_messages": {},
  "consent": {
    "photos": "I agree to let Magic Mirror use these photos to create my style report.",
    "isolation": "Only you can access the photos you add."
  }
}
```

## Art direction

Use calm, progressive onboarding with a narrow task column, clear progress, realistic form/upload/card controls, and one obvious Acid action. Editorial imagery may orient the step but must not obstruct inputs. Preserve completed work and recovery guidance visually when the state requires it.

Show the true empty state with guidance and the upload/action area ready for input.

Use the approved Acid Dispatch / Editorial Edge system: White and Cloud canvases, Ink structure, Acid only for the primary action or active signal, Pale/Deep supporting fields, Instrument Serif for short editorial moments, Space Grotesk for product clarity, 999 px buttons, 24 px cards, visible focus treatment, restrained shadows, and realistic fashion imagery only where the wireframe provides media or product content.

## Desktop prompt

Create one flat, straight-on desktop frontend raster comp for this exact screen/state. Use the approved desktop wireframe as the strict composition reference. Preserve the current job, section order, control placement, navigation, primary-action priority, and named state. Use realistic production-sized controls and readable density. Do not add a browser/device frame, annotations, alternate screens, proof, metrics, retailer logos, new features, purple/blue AI gradients, glassmorphism, or generic dashboard cards.

Canonical output: `company/artifacts/screen-mockups/screens/outfit-photo-upload-empty/empty/outfit-photo-upload-empty-desktop.png`

## Mobile prompt

Create one flat, straight-on mobile frontend raster comp for this exact screen/state. Use the approved mobile wireframe as its own structural reference; do not shrink desktop. Recompose navigation, content order, image crops, and actions for a narrow viewport while preserving the same job and priority. Use large touch targets and legible text. Do not add a phone frame, browser chrome, annotations, alternate screens, or new product behavior.

Canonical output: `company/artifacts/screen-mockups/screens/outfit-photo-upload-empty/empty/outfit-photo-upload-empty-mobile.png`

## Output and QA rules

- One screen/state/viewport per final PNG.
- Generated lettering is approximate; the copy manifest is authoritative.
- Use supplied production logo/icon references rather than redrawing the mark from text.
- The named state must be unmistakable.
- Preserve structure before decoration and implementation clarity before cinematic effect.
