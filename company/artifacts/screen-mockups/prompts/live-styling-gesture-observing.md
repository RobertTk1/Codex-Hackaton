# Live Styling — Gesture Observing ImageGen Brief

Screen ID: `a66498d1-8567-5492-b8da-9e2b12d376e9`  
Screen slug: `live-styling-gesture-observing`  
State: `observing`  
Surface: `product`  
Family: `live-styling`  
Route/context: `/style/live/session/:session-id`  
User job: Active hand-gesture observation with camera-framing guidance.  
Primary action: `Pause`

## Authoritative references

- Approved desktop wireframe: `company/artifacts/ui-ux-design/wireframes/png/live-styling-gesture-observing/observing/desktop-screen.png`
- Approved mobile wireframe: `company/artifacts/ui-ux-design/wireframes/png/live-styling-gesture-observing/observing/mobile-screen.png`
- Exact copy: `company/artifacts/copy/copy-manifest.json#live-styling-gesture-observing/observing`
- Shared direction: `company/artifacts/screen-mockups/design-direction.md`
- Application continuity reference: `company/artifacts/screen-mockups/screens/personal-profile-base/base/personal-profile-base-desktop.png`
- Live-styling continuity reference when applicable: `company/artifacts/screen-mockups/screens/live-styling-ready/base/live-styling-ready-desktop.png`

## Fixed section order

1. Session navigation — Provide exit, report, and bag access.
2. Live session workspace — Show the camera context, active item, controls, and the named state.
3. Recommended item rail — Preserve item alternatives and selection context.
4. Safety and alternatives — Expose direct controls, recovery, and the visualization limitation.

## Approved exact copy

```json
{
  "eyebrow": null,
  "headline": "Hand controls are on.",
  "supporting_copy": "Keep your hands in frame.",
  "primary_cta": "Pause",
  "secondary_cta": "Use buttons",
  "tertiary_cta": null,
  "navigation": {},
  "labels": {
    "camera": "Hands in frame",
    "status": "Ready"
  },
  "helper_text": {},
  "validation": {},
  "status_messages": {
    "observing": "Ready for your gesture…"
  },
  "consent": {}
}
```

## Art direction

Use a large, realistic live-mirror camera workspace with the current garment clearly visible, a restrained recommended-item rail, and distance-readable controls. Preserve shared chrome across live states so the named state—not a redesigned interface—is the visual change. Acid marks the primary action or active voice/gesture signal; Ink and Cloud keep the camera workspace grounded.

Show hand controls active with hands-in-frame guidance and a visible pause action.

Use the approved Acid Dispatch / Editorial Edge system: White and Cloud canvases, Ink structure, Acid only for the primary action or active signal, Pale/Deep supporting fields, Instrument Serif for short editorial moments, Space Grotesk for product clarity, 999 px buttons, 24 px cards, visible focus treatment, restrained shadows, and realistic fashion imagery only where the wireframe provides media or product content.

## Desktop prompt

Create one flat, straight-on desktop frontend raster comp for this exact screen/state. Use the approved desktop wireframe as the strict composition reference. Preserve the current job, section order, control placement, navigation, primary-action priority, and named state. Use realistic production-sized controls and readable density. Do not add a browser/device frame, annotations, alternate screens, proof, metrics, retailer logos, new features, purple/blue AI gradients, glassmorphism, or generic dashboard cards.

Canonical output: `company/artifacts/screen-mockups/screens/live-styling-gesture-observing/observing/live-styling-gesture-observing-desktop.png`

## Mobile prompt

Create one flat, straight-on mobile frontend raster comp for this exact screen/state. Use the approved mobile wireframe as its own structural reference; do not shrink desktop. Recompose navigation, content order, image crops, and actions for a narrow viewport while preserving the same job and priority. Use large touch targets and legible text. Do not add a phone frame, browser chrome, annotations, alternate screens, or new product behavior.

Canonical output: `company/artifacts/screen-mockups/screens/live-styling-gesture-observing/observing/live-styling-gesture-observing-mobile.png`

## Output and QA rules

- One screen/state/viewport per final PNG.
- Generated lettering is approximate; the copy manifest is authoritative.
- Use supplied production logo/icon references rather than redrawing the mark from text.
- The named state must be unmistakable.
- Preserve structure before decoration and implementation clarity before cinematic effect.
