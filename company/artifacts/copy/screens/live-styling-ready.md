# Live Styling — Ready

Status: Approved  
Screen ID: `5b6baf59-f2d4-4c52-aaa7-b4910435c892`  
Screen slug: `live-styling-ready`  
State: `base`  
Audience: Live camera view with active garment visualization, product identity, voice status, hand-gesture status, direct alternatives, and bag controls.

## Job and primary action

- **User job:** Live camera view with active garment visualization, product identity, voice status, hand-gesture status, direct alternatives, and bag controls.
- **Primary action:** Add to bag

## Recommended exact copy in wireframe order

### SEC-001 — Session navigation

```json
{
  "navigation": {
    "report": "Report",
    "bag": "Bag",
    "exit": "End session"
  }
}
```

### SEC-002 — Live session workspace

```json
{
  "eyebrow": null,
  "headline": "Try it on.",
  "supporting_copy": null,
  "labels": {
    "current": "Trying now",
    "voice": "Voice",
    "gestures": "Hand controls",
    "direct": "Controls"
  },
  "helper_text": {
    "limitation": "Styling preview only. Fit may vary."
  }
}
```

### SEC-003 — Recommended item rail

```json
{
  "eyebrow": null,
  "headline": "Try it on.",
  "supporting_copy": null,
  "labels": {
    "current": "Trying now",
    "voice": "Voice",
    "gestures": "Hand controls",
    "direct": "Controls"
  },
  "helper_text": {
    "limitation": "Styling preview only. Fit may vary."
  }
}
```

### SEC-004 — Safety and alternatives

```json
{
  "helper_text": {
    "limitation": "Styling preview only. Fit may vary."
  },
  "consent": {},
  "metadata": {}
}
```

## Complete implementation object

```json
{
  "eyebrow": null,
  "headline": "Try it on.",
  "supporting_copy": null,
  "primary_cta": "Add to bag",
  "secondary_cta": "Next look",
  "tertiary_cta": "End session",
  "navigation": {
    "report": "Report",
    "bag": "Bag",
    "exit": "End session"
  },
  "labels": {
    "current": "Trying now",
    "voice": "Voice",
    "gestures": "Hand controls",
    "direct": "Controls"
  },
  "helper_text": {
    "limitation": "Styling preview only. Fit may vary."
  },
  "validation": {},
  "status_messages": {},
  "consent": {},
  "metadata": {},
  "accessibility": {
    "camera": "Live styling view",
    "current_item": "Current item"
  },
  "sections": [
    {
      "section_id": "SEC-001",
      "section_name": "Session navigation",
      "copy": {
        "navigation": {
          "report": "Report",
          "bag": "Bag",
          "exit": "End session"
        }
      }
    },
    {
      "section_id": "SEC-002",
      "section_name": "Live session workspace",
      "copy": {
        "eyebrow": null,
        "headline": "Try it on.",
        "supporting_copy": null,
        "labels": {
          "current": "Trying now",
          "voice": "Voice",
          "gestures": "Hand controls",
          "direct": "Controls"
        },
        "helper_text": {
          "limitation": "Styling preview only. Fit may vary."
        }
      }
    },
    {
      "section_id": "SEC-003",
      "section_name": "Recommended item rail",
      "copy": {
        "eyebrow": null,
        "headline": "Try it on.",
        "supporting_copy": null,
        "labels": {
          "current": "Trying now",
          "voice": "Voice",
          "gestures": "Hand controls",
          "direct": "Controls"
        },
        "helper_text": {
          "limitation": "Styling preview only. Fit may vary."
        }
      }
    },
    {
      "section_id": "SEC-004",
      "section_name": "Safety and alternatives",
      "copy": {
        "helper_text": {
          "limitation": "Styling preview only. Fit may vary."
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
