# Personal Profile — Validation Error ImageGen Brief

Screen ID: `4df9db19-8f5b-53dd-a000-18e33ad9a6e3`  
Screen slug: `personal-profile-validation-error`  
State: `error`  
Surface: `product`  
Family: `onboarding`  
Route/context: `/style-report/profile`  
User job: Field-specific validation that preserves valid personal-profile entries and optional-field choices.  
Primary action: `Continue`

## Authoritative references

- Approved desktop wireframe: `company/artifacts/ui-ux-design/wireframes/png/personal-profile-validation-error/error/desktop-screen.png`
- Approved mobile wireframe: `company/artifacts/ui-ux-design/wireframes/png/personal-profile-validation-error/error/mobile-screen.png`
- Exact copy: `company/artifacts/copy/copy-manifest.json#personal-profile-validation-error/error`
- Shared direction: `company/artifacts/screen-mockups/design-direction.md`
- Application continuity reference: `company/artifacts/screen-mockups/screens/personal-profile-base/base/personal-profile-base-desktop.png`
- Live-styling continuity reference when applicable: `company/artifacts/screen-mockups/screens/live-styling-ready/base/live-styling-ready-desktop.png`

## Fixed section order

1. Onboarding progress — Show position and safe-exit behavior.
2. Personal profile form — Collect required and optional profile fields with contextual guidance.
3. Step support — Provide continuation and help without adding marketing copy.

## Approved exact copy

```json
{
  "eyebrow": null,
  "headline": "Check a few details.",
  "supporting_copy": null,
  "primary_cta": "Continue",
  "secondary_cta": "Save and exit",
  "tertiary_cta": null,
  "navigation": {},
  "labels": {
    "saved": "Saved",
    "error": "Check this",
    "optional": "Weight (optional)"
  },
  "helper_text": {},
  "validation": {
    "adult": "Confirm that you’re 18 or older.",
    "age": "Enter your age.",
    "height": "Enter your height.",
    "presentation": "Choose how you’d like us to shape your recommendations."
  },
  "status_messages": {
    "preserved": "Your other answers are saved."
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

Canonical output: `company/artifacts/screen-mockups/screens/personal-profile-validation-error/error/personal-profile-validation-error-desktop.png`

## Mobile prompt

Create one flat, straight-on mobile frontend raster comp for this exact screen/state. Use the approved mobile wireframe as its own structural reference; do not shrink desktop. Recompose navigation, content order, image crops, and actions for a narrow viewport while preserving the same job and priority. Use large touch targets and legible text. Do not add a phone frame, browser chrome, annotations, alternate screens, or new product behavior.

Canonical output: `company/artifacts/screen-mockups/screens/personal-profile-validation-error/error/personal-profile-validation-error-mobile.png`

## Output and QA rules

- One screen/state/viewport per final PNG.
- Generated lettering is approximate; the copy manifest is authoritative.
- Use supplied production logo/icon references rather than redrawing the mark from text.
- The named state must be unmistakable.
- Preserve structure before decoration and implementation clarity before cinematic effect.
