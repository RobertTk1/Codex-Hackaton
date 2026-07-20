# Live Styling — Camera Permission

Status: Approved  
Screen ID: `5e8e9f80-901b-4fb1-932c-f1bec76da0c9`  
Screen slug: `live-styling-camera-permission`  
State: `permission`  
Audience: Purpose-specific camera request for live visualization and hand-gesture controls, with environment guidance, visualization limitation, and denial recovery.

## Job and primary action

- **User job:** Purpose-specific camera request for live visualization and hand-gesture controls, with environment guidance, visualization limitation, and denial recovery.
- **Primary action:** Turn on camera

## Recommended exact copy in wireframe order

### SEC-001 — Session navigation

```json
{
  "navigation": {}
}
```

### SEC-002 — Live session workspace

```json
{
  "eyebrow": null,
  "headline": "Step into the mirror.",
  "supporting_copy": "Turn on your camera to try on your picks and use hands-free controls.",
  "labels": {},
  "helper_text": {
    "limitation": "The live view is a styling preview. Fit may vary.",
    "fallback": "You can still browse your picks without the camera."
  }
}
```

### SEC-003 — Recommended item rail

```json
{
  "eyebrow": null,
  "headline": "Step into the mirror.",
  "supporting_copy": "Turn on your camera to try on your picks and use hands-free controls.",
  "labels": {},
  "helper_text": {
    "limitation": "The live view is a styling preview. Fit may vary.",
    "fallback": "You can still browse your picks without the camera."
  }
}
```

### SEC-004 — Safety and alternatives

```json
{
  "helper_text": {
    "limitation": "The live view is a styling preview. Fit may vary.",
    "fallback": "You can still browse your picks without the camera."
  },
  "consent": {
    "camera": "Allow camera access for live styling and hand controls."
  },
  "metadata": {}
}
```

## Complete implementation object

```json
{
  "eyebrow": null,
  "headline": "Step into the mirror.",
  "supporting_copy": "Turn on your camera to try on your picks and use hands-free controls.",
  "primary_cta": "Turn on camera",
  "secondary_cta": "Not now",
  "tertiary_cta": "Back to my picks",
  "navigation": {},
  "labels": {},
  "helper_text": {
    "limitation": "The live view is a styling preview. Fit may vary.",
    "fallback": "You can still browse your picks without the camera."
  },
  "validation": {},
  "status_messages": {},
  "consent": {
    "camera": "Allow camera access for live styling and hand controls."
  },
  "metadata": {},
  "accessibility": {},
  "sections": [
    {
      "section_id": "SEC-001",
      "section_name": "Session navigation",
      "copy": {
        "navigation": {}
      }
    },
    {
      "section_id": "SEC-002",
      "section_name": "Live session workspace",
      "copy": {
        "eyebrow": null,
        "headline": "Step into the mirror.",
        "supporting_copy": "Turn on your camera to try on your picks and use hands-free controls.",
        "labels": {},
        "helper_text": {
          "limitation": "The live view is a styling preview. Fit may vary.",
          "fallback": "You can still browse your picks without the camera."
        }
      }
    },
    {
      "section_id": "SEC-003",
      "section_name": "Recommended item rail",
      "copy": {
        "eyebrow": null,
        "headline": "Step into the mirror.",
        "supporting_copy": "Turn on your camera to try on your picks and use hands-free controls.",
        "labels": {},
        "helper_text": {
          "limitation": "The live view is a styling preview. Fit may vary.",
          "fallback": "You can still browse your picks without the camera."
        }
      }
    },
    {
      "section_id": "SEC-004",
      "section_name": "Safety and alternatives",
      "copy": {
        "helper_text": {
          "limitation": "The live view is a styling preview. Fit may vary.",
          "fallback": "You can still browse your picks without the camera."
        },
        "consent": {
          "camera": "Allow camera access for live styling and hand controls."
        },
        "metadata": {}
      }
    }
  ]
}
```

## Proof and claims

No testimonial, customer count, rating, fit guarantee, retailer partnership, or measured outcome claim is used. Timing and capability language is limited to the approved product contract and identified as a design target where relevant.

## Alternatives

No alternate is recommended for this state; clarity and state fidelity take priority.

## Voice notes

Clear, editorial, practical, and transparent.

## Layout constraints

Keep the headline concise, actions predictable, and state guidance readable on mobile.

## Approval and revision notes

- 2026-07-19: Initial draft created from the approved PRD, UX package, company context, and draft voice system.
- Founder approval: Approved by Talisha White on 2026-07-19.
