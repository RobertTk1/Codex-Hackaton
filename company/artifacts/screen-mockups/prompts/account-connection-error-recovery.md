# Account Connection — Error Recovery ImageGen Brief

Screen ID: `eef632ce-8d4a-5035-aa15-b5efdd09b2a2`  
Screen slug: `account-connection-error-recovery`  
State: `recovery`  
Surface: `product`  
Family: `onboarding`  
Route/context: `/style-report/account`  
User job: Interrupted or failed Google or magic-link connection with anonymous progress preserved.  
Primary action: `Try again`

## Authoritative references

- Approved desktop wireframe: `company/artifacts/ui-ux-design/wireframes/png/account-connection-error-recovery/recovery/desktop-screen.png`
- Approved mobile wireframe: `company/artifacts/ui-ux-design/wireframes/png/account-connection-error-recovery/recovery/mobile-screen.png`
- Exact copy: `company/artifacts/copy/copy-manifest.json#account-connection-error-recovery/recovery`
- Shared direction: `company/artifacts/screen-mockups/design-direction.md`
- Application continuity reference: `company/artifacts/screen-mockups/screens/personal-profile-base/base/personal-profile-base-desktop.png`
- Live-styling continuity reference when applicable: `company/artifacts/screen-mockups/screens/live-styling-ready/base/live-styling-ready-desktop.png`

## Fixed section order

1. Onboarding progress — Show the final onboarding gate.
2. Unified account connection — Create or resume an account without a separate signup flow.
3. Progress preservation — Explain that anonymous onboarding work remains attached through connection.
4. Support — Offer alternate method or recovery.

## Approved exact copy

```json
{
  "eyebrow": null,
  "headline": "Let’s try that again.",
  "supporting_copy": "Your progress is safe.",
  "primary_cta": "Try again",
  "secondary_cta": "Use another way",
  "tertiary_cta": "Get help",
  "navigation": {},
  "labels": {},
  "helper_text": {},
  "validation": {
    "email": "Check your email address and send a new link.",
    "google": "Google sign-in didn’t finish. Try again or use email."
  },
  "status_messages": {
    "interrupted": "Sign-in didn’t finish.",
    "preserved": "Your progress is saved."
  },
  "consent": {}
}
```

## Art direction

Use calm, progressive onboarding with a narrow task column, clear progress, realistic form/upload/card controls, and one obvious Acid action. Editorial imagery may orient the step but must not obstruct inputs. Preserve completed work and recovery guidance visually when the state requires it.

Show preserved progress and a clear retry or alternate route; avoid alarmist visuals.

Use the approved Acid Dispatch / Editorial Edge system: White and Cloud canvases, Ink structure, Acid only for the primary action or active signal, Pale/Deep supporting fields, Instrument Serif for short editorial moments, Space Grotesk for product clarity, 999 px buttons, 24 px cards, visible focus treatment, restrained shadows, and realistic fashion imagery only where the wireframe provides media or product content.

## Desktop prompt

Create one flat, straight-on desktop frontend raster comp for this exact screen/state. Use the approved desktop wireframe as the strict composition reference. Preserve the current job, section order, control placement, navigation, primary-action priority, and named state. Use realistic production-sized controls and readable density. Do not add a browser/device frame, annotations, alternate screens, proof, metrics, retailer logos, new features, purple/blue AI gradients, glassmorphism, or generic dashboard cards.

Canonical output: `company/artifacts/screen-mockups/screens/account-connection-error-recovery/recovery/account-connection-error-recovery-desktop.png`

## Mobile prompt

Create one flat, straight-on mobile frontend raster comp for this exact screen/state. Use the approved mobile wireframe as its own structural reference; do not shrink desktop. Recompose navigation, content order, image crops, and actions for a narrow viewport while preserving the same job and priority. Use large touch targets and legible text. Do not add a phone frame, browser chrome, annotations, alternate screens, or new product behavior.

Canonical output: `company/artifacts/screen-mockups/screens/account-connection-error-recovery/recovery/account-connection-error-recovery-mobile.png`

## Output and QA rules

- One screen/state/viewport per final PNG.
- Generated lettering is approximate; the copy manifest is authoritative.
- Use supplied production logo/icon references rather than redrawing the mark from text.
- The named state must be unmistakable.
- Preserve structure before decoration and implementation clarity before cinematic effect.
