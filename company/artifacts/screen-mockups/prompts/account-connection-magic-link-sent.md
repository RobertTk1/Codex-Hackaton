# Account Connection — Magic Link Sent ImageGen Brief

Screen ID: `e74afd3b-7709-40af-bedc-15cc9d2a6f1e`  
Screen slug: `account-connection-magic-link-sent`  
State: `recovery`  
Surface: `product`  
Family: `onboarding`  
Route/context: `/style-report/account`  
User job: Magic-link waiting and recovery state; the link signs up or logs in and connects preserved anonymous progress after authentication.  
Primary action: `Open email`

## Authoritative references

- Approved desktop wireframe: `company/artifacts/ui-ux-design/wireframes/png/account-connection-magic-link-sent/recovery/desktop-screen.png`
- Approved mobile wireframe: `company/artifacts/ui-ux-design/wireframes/png/account-connection-magic-link-sent/recovery/mobile-screen.png`
- Exact copy: `company/artifacts/copy/copy-manifest.json#account-connection-magic-link-sent/recovery`
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
  "headline": "Check your inbox.",
  "supporting_copy": "We sent a sign-in link to {{email_address}}.",
  "primary_cta": "Open email",
  "secondary_cta": "Send another link",
  "tertiary_cta": "Use Google instead",
  "navigation": {},
  "labels": {},
  "helper_text": {},
  "validation": {},
  "status_messages": {
    "sent": "Link sent to {{email_address}}.",
    "expired": "That link expired. Send a new one to continue."
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

Canonical output: `company/artifacts/screen-mockups/screens/account-connection-magic-link-sent/recovery/account-connection-magic-link-sent-desktop.png`

## Mobile prompt

Create one flat, straight-on mobile frontend raster comp for this exact screen/state. Use the approved mobile wireframe as its own structural reference; do not shrink desktop. Recompose navigation, content order, image crops, and actions for a narrow viewport while preserving the same job and priority. Use large touch targets and legible text. Do not add a phone frame, browser chrome, annotations, alternate screens, or new product behavior.

Canonical output: `company/artifacts/screen-mockups/screens/account-connection-magic-link-sent/recovery/account-connection-magic-link-sent-mobile.png`

## Output and QA rules

- One screen/state/viewport per final PNG.
- Generated lettering is approximate; the copy manifest is authoritative.
- Use supplied production logo/icon references rather than redrawing the mark from text.
- The named state must be unmistakable.
- Preserve structure before decoration and implementation clarity before cinematic effect.
