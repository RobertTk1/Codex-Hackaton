# Live Styling — Gesture Observing

Status: Approved  
Screen ID: `a66498d1-8567-5492-b8da-9e2b12d376e9`  
Screen slug: `live-styling-gesture-observing`  
State: `observing`  
Audience: Active hand-gesture observation with camera-framing guidance.

## Job and primary action

- **User job:** Active hand-gesture observation with camera-framing guidance.
- **Primary action:** Pause

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
  "headline": "Hand controls are on.",
  "supporting_copy": "Keep your hands in frame.",
  "labels": {
    "camera": "Hands in frame",
    "status": "Ready"
  },
  "helper_text": {}
}
```

### SEC-003 — Recommended item rail

```json
{
  "eyebrow": null,
  "headline": "Hand controls are on.",
  "supporting_copy": "Keep your hands in frame.",
  "labels": {
    "camera": "Hands in frame",
    "status": "Ready"
  },
  "helper_text": {}
}
```

### SEC-004 — Safety and alternatives

```json
{
  "helper_text": {},
  "consent": {},
  "metadata": {}
}
```

## Complete implementation object

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
  "consent": {},
  "metadata": {},
  "accessibility": {
    "live_region": "Hand controls are ready."
  },
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
        "headline": "Hand controls are on.",
        "supporting_copy": "Keep your hands in frame.",
        "labels": {
          "camera": "Hands in frame",
          "status": "Ready"
        },
        "helper_text": {}
      }
    },
    {
      "section_id": "SEC-003",
      "section_name": "Recommended item rail",
      "copy": {
        "eyebrow": null,
        "headline": "Hand controls are on.",
        "supporting_copy": "Keep your hands in frame.",
        "labels": {
          "camera": "Hands in frame",
          "status": "Ready"
        },
        "helper_text": {}
      }
    },
    {
      "section_id": "SEC-004",
      "section_name": "Safety and alternatives",
      "copy": {
        "helper_text": {},
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
