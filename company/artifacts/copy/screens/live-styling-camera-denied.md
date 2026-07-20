# Live Styling — Camera Denied

Status: Approved  
Screen ID: `40fd9de9-e880-5bfc-9b65-6cd20fb67ec6`  
Screen slug: `live-styling-camera-denied`  
State: `denied`  
Audience: Camera-denial recovery that preserves selected items, report access, and device guidance.

## Job and primary action

- **User job:** Camera-denial recovery that preserves selected items, report access, and device guidance.
- **Primary action:** Try again

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
  "headline": "Your camera is off.",
  "supporting_copy": "Turn it on in your browser settings to use the live mirror.",
  "labels": {},
  "helper_text": {
    "fallback": "You can still browse your picks."
  }
}
```

### SEC-003 — Recommended item rail

```json
{
  "eyebrow": null,
  "headline": "Your camera is off.",
  "supporting_copy": "Turn it on in your browser settings to use the live mirror.",
  "labels": {},
  "helper_text": {
    "fallback": "You can still browse your picks."
  }
}
```

### SEC-004 — Safety and alternatives

```json
{
  "helper_text": {
    "fallback": "You can still browse your picks."
  },
  "consent": {},
  "metadata": {}
}
```

## Complete implementation object

```json
{
  "eyebrow": null,
  "headline": "Your camera is off.",
  "supporting_copy": "Turn it on in your browser settings to use the live mirror.",
  "primary_cta": "Try again",
  "secondary_cta": "How to turn it on",
  "tertiary_cta": "Back to my picks",
  "navigation": {},
  "labels": {},
  "helper_text": {
    "fallback": "You can still browse your picks."
  },
  "validation": {},
  "status_messages": {
    "denied": "Camera access is off.",
    "preserved": "Your picks are saved."
  },
  "consent": {},
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
        "headline": "Your camera is off.",
        "supporting_copy": "Turn it on in your browser settings to use the live mirror.",
        "labels": {},
        "helper_text": {
          "fallback": "You can still browse your picks."
        }
      }
    },
    {
      "section_id": "SEC-003",
      "section_name": "Recommended item rail",
      "copy": {
        "eyebrow": null,
        "headline": "Your camera is off.",
        "supporting_copy": "Turn it on in your browser settings to use the live mirror.",
        "labels": {},
        "helper_text": {
          "fallback": "You can still browse your picks."
        }
      }
    },
    {
      "section_id": "SEC-004",
      "section_name": "Safety and alternatives",
      "copy": {
        "helper_text": {
          "fallback": "You can still browse your picks."
        },
        "consent": {},
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
