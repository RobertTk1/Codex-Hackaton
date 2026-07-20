# Live Styling — Gesture Interpreting

Status: Approved  
Screen ID: `96d21855-d455-5843-a97e-a0fb78bec909`  
Screen slug: `live-styling-gesture-interpreting`  
State: `interpreting`  
Audience: Recognized hand shape shown with the intended action before acting.

## Job and primary action

- **User job:** Recognized hand shape shown with the intended action before acting.
- **Primary action:** Cancel

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
  "headline": "Got it—one second.",
  "supporting_copy": "{{gesture_action}}",
  "labels": {
    "gesture": "Your gesture",
    "action": "Up next"
  },
  "helper_text": {}
}
```

### SEC-003 — Recommended item rail

```json
{
  "eyebrow": null,
  "headline": "Got it—one second.",
  "supporting_copy": "{{gesture_action}}",
  "labels": {
    "gesture": "Your gesture",
    "action": "Up next"
  },
  "helper_text": {}
}
```

### SEC-004 — Safety and alternatives

```json
{
  "helper_text": {},
  "consent": {},
  "metadata": {
    "dynamic_tokens": [
      "gesture_name",
      "gesture_action"
    ]
  }
}
```

## Complete implementation object

```json
{
  "eyebrow": null,
  "headline": "Got it—one second.",
  "supporting_copy": "{{gesture_action}}",
  "primary_cta": "Cancel",
  "secondary_cta": null,
  "tertiary_cta": null,
  "navigation": {},
  "labels": {
    "gesture": "Your gesture",
    "action": "Up next"
  },
  "helper_text": {},
  "validation": {},
  "status_messages": {
    "interpreting": "Reading your gesture…"
  },
  "consent": {},
  "metadata": {
    "dynamic_tokens": [
      "gesture_name",
      "gesture_action"
    ]
  },
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
        "headline": "Got it—one second.",
        "supporting_copy": "{{gesture_action}}",
        "labels": {
          "gesture": "Your gesture",
          "action": "Up next"
        },
        "helper_text": {}
      }
    },
    {
      "section_id": "SEC-003",
      "section_name": "Recommended item rail",
      "copy": {
        "eyebrow": null,
        "headline": "Got it—one second.",
        "supporting_copy": "{{gesture_action}}",
        "labels": {
          "gesture": "Your gesture",
          "action": "Up next"
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
        "metadata": {
          "dynamic_tokens": [
            "gesture_name",
            "gesture_action"
          ]
        }
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
