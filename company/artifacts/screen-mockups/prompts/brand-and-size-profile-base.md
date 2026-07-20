# Brand and Size Profile — Base ImageGen Brief

Screen ID: `9ad25480-da71-430f-816a-6f394bed7f15`  
Screen slug: `brand-and-size-profile-base`  
State: `base`  
Surface: `product`  
Family: `onboarding`  
Route/context: `/style-report/brands-and-sizes`  
User job: Favorite-brand selection and category-specific known-size entry.  
Primary action: `Add my photos`

## Authoritative references

- Approved desktop wireframe: `company/artifacts/ui-ux-design/wireframes/png/brand-and-size-profile-base/base/desktop-screen.png`
- Approved mobile wireframe: `company/artifacts/ui-ux-design/wireframes/png/brand-and-size-profile-base/base/mobile-screen.png`
- Exact copy: `company/artifacts/copy/copy-manifest.json#brand-and-size-profile-base/base`
- Shared direction: `company/artifacts/screen-mockups/design-direction.md`
- Application continuity reference: `company/artifacts/screen-mockups/screens/personal-profile-base/base/personal-profile-base-desktop.png`
- Live-styling continuity reference when applicable: `company/artifacts/screen-mockups/screens/live-styling-ready/base/live-styling-ready-desktop.png`

## Fixed section order

1. Onboarding progress — Show position and safe-exit behavior.
2. Brand selection — Choose known brands using a scannable selection structure.
3. Category sizes — Capture category-specific sizes and unknown values.
4. Step actions — Continue or return to the preceding step.

## Approved exact copy

```json
{
  "eyebrow": "STEP 2 OF 4",
  "headline": "What fits you best?",
  "supporting_copy": "Choose a few favorite brands and the sizes you reach for.",
  "primary_cta": "Add my photos",
  "secondary_cta": "Back",
  "tertiary_cta": "Save and exit",
  "navigation": {},
  "labels": {
    "brands": "Favorite brands",
    "brand_search": "Search or add a brand",
    "category": "Garment category",
    "size": "Usual size",
    "unknown": "I’m not sure"
  },
  "helper_text": {
    "sizing": "Add another entry when your size changes by brand or item."
  },
  "validation": {
    "brand": "Choose or add a brand.",
    "size": "Choose a size or select “I’m not sure.”"
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

Canonical output: `company/artifacts/screen-mockups/screens/brand-and-size-profile-base/base/brand-and-size-profile-base-desktop.png`

## Mobile prompt

Create one flat, straight-on mobile frontend raster comp for this exact screen/state. Use the approved mobile wireframe as its own structural reference; do not shrink desktop. Recompose navigation, content order, image crops, and actions for a narrow viewport while preserving the same job and priority. Use large touch targets and legible text. Do not add a phone frame, browser chrome, annotations, alternate screens, or new product behavior.

Canonical output: `company/artifacts/screen-mockups/screens/brand-and-size-profile-base/base/brand-and-size-profile-base-mobile.png`

## Output and QA rules

- One screen/state/viewport per final PNG.
- Generated lettering is approximate; the copy manifest is authoritative.
- Use supplied production logo/icon references rather than redrawing the mark from text.
- The named state must be unmistakable.
- Preserve structure before decoration and implementation clarity before cinematic effect.
