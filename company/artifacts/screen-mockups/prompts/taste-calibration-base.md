# Taste Calibration — Base ImageGen Brief

Screen ID: `e6f13ec8-a8d0-405c-932b-3befeb7de4f6`  
Screen slug: `taste-calibration-base`  
State: `base`  
Surface: `product`  
Family: `onboarding`  
Route/context: `/style-report/taste`  
User job: Tinder-like look or garment card: right/Love, left/Hate, and down/Maybe, with matching buttons, keyboard controls, undo, and progress.  
Primary action: `Love`

## Authoritative references

- Approved desktop wireframe: `company/artifacts/ui-ux-design/wireframes/png/taste-calibration-base/base/desktop-screen.png`
- Approved mobile wireframe: `company/artifacts/ui-ux-design/wireframes/png/taste-calibration-base/base/mobile-screen.png`
- Exact copy: `company/artifacts/copy/copy-manifest.json#taste-calibration-base/base`
- Shared direction: `company/artifacts/screen-mockups/design-direction.md`
- Application continuity reference: `company/artifacts/screen-mockups/screens/personal-profile-base/base/personal-profile-base-desktop.png`
- Live-styling continuity reference when applicable: `company/artifacts/screen-mockups/screens/live-styling-ready/base/live-styling-ready-desktop.png`

## Fixed section order

1. Onboarding progress — Show calibration progress and exit behavior.
2. Taste decision workspace — Support swipe, button, keyboard, and undo interactions.
3. Interaction guidance — Explain Love, Hate, Maybe, and accessible equivalents.
4. Step actions — Continue after sufficient signal or retry preserved progress.

## Approved exact copy

```json
{
  "eyebrow": "STEP 4 OF 4",
  "headline": "Trust your first reaction.",
  "supporting_copy": "Swipe right for Love, left for Hate, or down for Maybe.",
  "primary_cta": "Love",
  "secondary_cta": "Hate",
  "tertiary_cta": "Maybe",
  "navigation": {},
  "labels": {
    "progress": "Your picks",
    "undo": "Undo"
  },
  "helper_text": {
    "gestures": "Right for Love. Left for Hate. Down for Maybe.",
    "keyboard": "Use the right, left, or down arrow keys."
  },
  "validation": {},
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

Canonical output: `company/artifacts/screen-mockups/screens/taste-calibration-base/base/taste-calibration-base-desktop.png`

## Mobile prompt

Create one flat, straight-on mobile frontend raster comp for this exact screen/state. Use the approved mobile wireframe as its own structural reference; do not shrink desktop. Recompose navigation, content order, image crops, and actions for a narrow viewport while preserving the same job and priority. Use large touch targets and legible text. Do not add a phone frame, browser chrome, annotations, alternate screens, or new product behavior.

Canonical output: `company/artifacts/screen-mockups/screens/taste-calibration-base/base/taste-calibration-base-mobile.png`

## Output and QA rules

- One screen/state/viewport per final PNG.
- Generated lettering is approximate; the copy manifest is authoritative.
- Use supplied production logo/icon references rather than redrawing the mark from text.
- The named state must be unmistakable.
- Preserve structure before decoration and implementation clarity before cinematic effect.
