# Personal Profile — Base ImageGen Brief

Screen ID: `61df36bb-6d7c-41a3-bf06-9c2c99824e51`  
Screen slug: `personal-profile-base`  
State: `base`  
Surface: `product`  
Family: `onboarding`  
Route/context: `/style-report/profile`  
User job: First onboarding step for preferred name, adult confirmation, age, height, optional weight, and style-presentation context.  
Primary action: `Choose my brands`

## Authoritative references

- Approved desktop wireframe: `company/artifacts/ui-ux-design/wireframes/png/personal-profile-base/base/desktop-screen.png`
- Approved mobile wireframe: `company/artifacts/ui-ux-design/wireframes/png/personal-profile-base/base/mobile-screen.png`
- Exact copy: `company/artifacts/copy/copy-manifest.json#personal-profile-base/base`
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
  "eyebrow": "STEP 1 OF 4",
  "headline": "A little about you.",
  "supporting_copy": "This helps us make your style report more personal.",
  "primary_cta": "Choose my brands",
  "secondary_cta": "Save and exit",
  "tertiary_cta": null,
  "navigation": {},
  "labels": {
    "name": "Preferred name",
    "adult": "I confirm I’m 18 or older",
    "age": "Age",
    "height": "Height",
    "weight": "Weight (optional)",
    "presentation": "Style presentation"
  },
  "helper_text": {
    "name": "The name you’d like us to use.",
    "weight": "Skip this if you’d rather not say.",
    "presentation": "How would you like us to shape your recommendations?"
  },
  "validation": {
    "adult": "Confirm that you’re 18 or older to continue.",
    "age": "Enter your age.",
    "height": "Enter your height."
  },
  "status_messages": {},
  "consent": {}
}
```

## Art direction

Use calm, progressive onboarding with a narrow task column, clear progress, realistic form/upload/card controls, and one obvious Acid action. Editorial imagery may orient the step but must not obstruct inputs. Preserve completed work and recovery guidance visually when the state requires it.

Show the ordinary usable base state with the primary task immediately clear.

Use the approved Acid Dispatch / Editorial Edge system: White and Cloud canvases, Ink structure, Acid only for the primary action or active signal, Pale/Deep supporting fields, Instrument Serif for short editorial moments, Space Grotesk for product clarity, 999 px buttons, 24 px cards, visible focus treatment, restrained shadows, and realistic fashion imagery only where the wireframe provides media or product content.

## Desktop prompt

Create one flat, straight-on desktop frontend raster comp for this exact screen/state. Use the approved desktop wireframe as the strict composition reference. Preserve the current job, section order, control placement, navigation, primary-action priority, and named state. Use realistic production-sized controls and readable density. Do not add a browser/device frame, annotations, alternate screens, proof, metrics, retailer logos, new features, purple/blue AI gradients, glassmorphism, or generic dashboard cards.

Canonical output: `company/artifacts/screen-mockups/screens/personal-profile-base/base/personal-profile-base-desktop.png`

## Mobile prompt

Create one flat, straight-on mobile frontend raster comp for this exact screen/state. Use the approved mobile wireframe as its own structural reference; do not shrink desktop. Recompose navigation, content order, image crops, and actions for a narrow viewport while preserving the same job and priority. Use large touch targets and legible text. Do not add a phone frame, browser chrome, annotations, alternate screens, or new product behavior.

Canonical output: `company/artifacts/screen-mockups/screens/personal-profile-base/base/personal-profile-base-mobile.png`

## Output and QA rules

- One screen/state/viewport per final PNG.
- Generated lettering is approximate; the copy manifest is authoritative.
- Use supplied production logo/icon references rather than redrawing the mark from text.
- The named state must be unmistakable.
- Preserve structure before decoration and implementation clarity before cinematic effect.
