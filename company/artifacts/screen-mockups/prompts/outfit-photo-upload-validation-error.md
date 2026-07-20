# Outfit Photo Upload — Validation Error ImageGen Brief

Screen ID: `acea6cc0-08ca-4691-806e-2faae3ce2b0f`  
Screen slug: `outfit-photo-upload-validation-error`  
State: `error`  
Surface: `product`  
Family: `onboarding`  
Route/context: `/style-report/photos`  
User job: Local image rejection state that preserves successful uploads and explains replacement.  
Primary action: `Replace photo`

## Authoritative references

- Approved desktop wireframe: `company/artifacts/ui-ux-design/wireframes/png/outfit-photo-upload-validation-error/error/desktop-screen.png`
- Approved mobile wireframe: `company/artifacts/ui-ux-design/wireframes/png/outfit-photo-upload-validation-error/error/mobile-screen.png`
- Exact copy: `company/artifacts/copy/copy-manifest.json#outfit-photo-upload-validation-error/error`
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
  "eyebrow": null,
  "headline": "Let’s swap this one.",
  "supporting_copy": "Choose a different photo to keep going. Your other photos are ready.",
  "primary_cta": "Replace photo",
  "secondary_cta": "Remove",
  "tertiary_cta": "Add another",
  "navigation": {},
  "labels": {
    "rejected": "Try another photo",
    "preserved": "Other photos ready"
  },
  "helper_text": {},
  "validation": {
    "format": "Choose a JPG, PNG, or HEIC image.",
    "duplicate": "You already added this photo.",
    "full_body": "Choose a photo that shows your full outfit.",
    "unreadable": "We couldn’t open this image. Try another one."
  },
  "status_messages": {
    "preserved": "Your other photos are ready."
  },
  "consent": {}
}
```

## Art direction

Use calm, progressive onboarding with a narrow task column, clear progress, realistic form/upload/card controls, and one obvious Acid action. Editorial imagery may orient the step but must not obstruct inputs. Preserve completed work and recovery guidance visually when the state requires it.

Show a localized error with preserved valid work, a calm error treatment, and one obvious correction path.

Use the approved Acid Dispatch / Editorial Edge system: White and Cloud canvases, Ink structure, Acid only for the primary action or active signal, Pale/Deep supporting fields, Instrument Serif for short editorial moments, Space Grotesk for product clarity, 999 px buttons, 24 px cards, visible focus treatment, restrained shadows, and realistic fashion imagery only where the wireframe provides media or product content.

## Desktop prompt

Create one flat, straight-on desktop frontend raster comp for this exact screen/state. Use the approved desktop wireframe as the strict composition reference. Preserve the current job, section order, control placement, navigation, primary-action priority, and named state. Use realistic production-sized controls and readable density. Do not add a browser/device frame, annotations, alternate screens, proof, metrics, retailer logos, new features, purple/blue AI gradients, glassmorphism, or generic dashboard cards.

Canonical output: `company/artifacts/screen-mockups/screens/outfit-photo-upload-validation-error/error/outfit-photo-upload-validation-error-desktop.png`

## Mobile prompt

Create one flat, straight-on mobile frontend raster comp for this exact screen/state. Use the approved mobile wireframe as its own structural reference; do not shrink desktop. Recompose navigation, content order, image crops, and actions for a narrow viewport while preserving the same job and priority. Use large touch targets and legible text. Do not add a phone frame, browser chrome, annotations, alternate screens, or new product behavior.

Canonical output: `company/artifacts/screen-mockups/screens/outfit-photo-upload-validation-error/error/outfit-photo-upload-validation-error-mobile.png`

## Output and QA rules

- One screen/state/viewport per final PNG.
- Generated lettering is approximate; the copy manifest is authoritative.
- Use supplied production logo/icon references rather than redrawing the mark from text.
- The named state must be unmistakable.
- Preserve structure before decoration and implementation clarity before cinematic effect.
