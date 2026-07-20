# Account Connection — Base ImageGen Brief

Screen ID: `782fdff8-e9b9-4828-aaa2-33b089ffd011`  
Screen slug: `account-connection-base`  
State: `base`  
Surface: `product`  
Family: `onboarding`  
Route/context: `/style-report/account`  
User job: Unified Google and email magic-link step that creates or logs into a permanent account and connects anonymous progress before report generation.  
Primary action: `Continue with Google`

## Authoritative references

- Approved desktop wireframe: `company/artifacts/ui-ux-design/wireframes/png/account-connection-base/base/desktop-screen.png`
- Approved mobile wireframe: `company/artifacts/ui-ux-design/wireframes/png/account-connection-base/base/mobile-screen.png`
- Exact copy: `company/artifacts/copy/copy-manifest.json#account-connection-base/base`
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
  "eyebrow": "ONE LAST STEP",
  "headline": "Your report is almost ready.",
  "supporting_copy": "Save your progress to see your results and come back anytime.",
  "primary_cta": "Continue with Google",
  "secondary_cta": "Send me a sign-in link",
  "tertiary_cta": null,
  "navigation": {},
  "labels": {
    "email": "Email address"
  },
  "helper_text": {
    "account": "Already have an account? Use the same email to sign in.",
    "progress": "Everything you’ve added is saved when you continue."
  },
  "validation": {
    "email": "Enter your email address."
  },
  "status_messages": {},
  "consent": {
    "account": "By continuing, you agree to create or sign in to your Magic Mirror account."
  }
}
```

## Art direction

Use calm, progressive onboarding with a narrow task column, clear progress, realistic form/upload/card controls, and one obvious Acid action. Editorial imagery may orient the step but must not obstruct inputs. Preserve completed work and recovery guidance visually when the state requires it.

Show the ordinary usable base state with the primary task immediately clear.

Use the approved Acid Dispatch / Editorial Edge system: White and Cloud canvases, Ink structure, Acid only for the primary action or active signal, Pale/Deep supporting fields, Instrument Serif for short editorial moments, Space Grotesk for product clarity, 999 px buttons, 24 px cards, visible focus treatment, restrained shadows, and realistic fashion imagery only where the wireframe provides media or product content.

## Desktop prompt

Create one flat, straight-on desktop frontend raster comp for this exact screen/state. Use the approved desktop wireframe as the strict composition reference. Preserve the current job, section order, control placement, navigation, primary-action priority, and named state. Use realistic production-sized controls and readable density. Do not add a browser/device frame, annotations, alternate screens, proof, metrics, retailer logos, new features, purple/blue AI gradients, glassmorphism, or generic dashboard cards.

Canonical output: `company/artifacts/screen-mockups/screens/account-connection-base/base/account-connection-base-desktop.png`

## Mobile prompt

Create one flat, straight-on mobile frontend raster comp for this exact screen/state. Use the approved mobile wireframe as its own structural reference; do not shrink desktop. Recompose navigation, content order, image crops, and actions for a narrow viewport while preserving the same job and priority. Use large touch targets and legible text. Do not add a phone frame, browser chrome, annotations, alternate screens, or new product behavior.

Canonical output: `company/artifacts/screen-mockups/screens/account-connection-base/base/account-connection-base-mobile.png`

## Output and QA rules

- One screen/state/viewport per final PNG.
- Generated lettering is approximate; the copy manifest is authoritative.
- Use supplied production logo/icon references rather than redrawing the mark from text.
- The named state must be unmistakable.
- Preserve structure before decoration and implementation clarity before cinematic effect.
