# Account Access — Unauthenticated ImageGen Brief

Screen ID: `ee82967b-e205-401b-a90b-6a94d36470f7`  
Screen slug: `account-access-unauthenticated`  
State: `unauthenticated`  
Surface: `product`  
Family: `onboarding`  
Route/context: `/login`  
User job: Unified Google and email magic-link access that signs up or logs in and provides a route back to anonymous report onboarding.  
Primary action: `Continue with Google`

## Authoritative references

- Approved desktop wireframe: `company/artifacts/ui-ux-design/wireframes/png/account-access-unauthenticated/unauthenticated/desktop-screen.png`
- Approved mobile wireframe: `company/artifacts/ui-ux-design/wireframes/png/account-access-unauthenticated/unauthenticated/mobile-screen.png`
- Exact copy: `company/artifacts/copy/copy-manifest.json#account-access-unauthenticated/unauthenticated`
- Shared direction: `company/artifacts/screen-mockups/design-direction.md`
- Application continuity reference: `company/artifacts/screen-mockups/screens/personal-profile-base/base/personal-profile-base-desktop.png`
- Live-styling continuity reference when applicable: `company/artifacts/screen-mockups/screens/live-styling-ready/base/live-styling-ready-desktop.png`

## Fixed section order

1. Navigation — Provide a route back to the public entry.
2. Unified account access — Support Google and email magic-link access in one module.
3. Support and privacy — Provide help and policy routes.

## Approved exact copy

```json
{
  "eyebrow": null,
  "headline": "Sign in to Magic Mirror",
  "supporting_copy": null,
  "primary_cta": "Continue with Google",
  "secondary_cta": "Send me a sign-in link",
  "tertiary_cta": null,
  "navigation": {},
  "labels": {
    "email": "Email address"
  },
  "helper_text": {
    "email": "No password needed."
  },
  "validation": {
    "email": "Enter your email address."
  },
  "status_messages": {},
  "consent": {}
}
```

## Art direction

Use calm, progressive onboarding with a narrow task column, clear progress, realistic form/upload/card controls, and one obvious Acid action. Editorial imagery may orient the step but must not obstruct inputs. Preserve completed work and recovery guidance visually when the state requires it.

Show a welcoming signed-out state with Google and email access unmistakable and no unnecessary product explanation.

Use the approved Acid Dispatch / Editorial Edge system: White and Cloud canvases, Ink structure, Acid only for the primary action or active signal, Pale/Deep supporting fields, Instrument Serif for short editorial moments, Space Grotesk for product clarity, 999 px buttons, 24 px cards, visible focus treatment, restrained shadows, and realistic fashion imagery only where the wireframe provides media or product content.

## Desktop prompt

Create one flat, straight-on desktop frontend raster comp for this exact screen/state. Use the approved desktop wireframe as the strict composition reference. Preserve the current job, section order, control placement, navigation, primary-action priority, and named state. Use realistic production-sized controls and readable density. Do not add a browser/device frame, annotations, alternate screens, proof, metrics, retailer logos, new features, purple/blue AI gradients, glassmorphism, or generic dashboard cards.

Canonical output: `company/artifacts/screen-mockups/screens/account-access-unauthenticated/unauthenticated/account-access-unauthenticated-desktop.png`

## Mobile prompt

Create one flat, straight-on mobile frontend raster comp for this exact screen/state. Use the approved mobile wireframe as its own structural reference; do not shrink desktop. Recompose navigation, content order, image crops, and actions for a narrow viewport while preserving the same job and priority. Use large touch targets and legible text. Do not add a phone frame, browser chrome, annotations, alternate screens, or new product behavior.

Canonical output: `company/artifacts/screen-mockups/screens/account-access-unauthenticated/unauthenticated/account-access-unauthenticated-mobile.png`

## Output and QA rules

- One screen/state/viewport per final PNG.
- Generated lettering is approximate; the copy manifest is authoritative.
- Use supplied production logo/icon references rather than redrawing the mark from text.
- The named state must be unmistakable.
- Preserve structure before decoration and implementation clarity before cinematic effect.
