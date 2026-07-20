# Live Styling — Gesture Confirmation

Status: Approved  
Screen ID: `d40738f4-6d72-51fe-8c9b-8308a5e7f97d`  
Screen slug: `live-styling-gesture-confirmation`  
State: `confirming`  
Audience: Explicit confirmation before a gesture triggers a consequential action.

## Job and primary action

- **User job:** Explicit confirmation before a gesture triggers a consequential action.
- **Primary action:** {{gesture_action}}

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
  "headline": "Do you want to {{gesture_action}}?",
  "supporting_copy": null,
  "labels": {
    "recognized": "Your gesture",
    "action": "Next action"
  },
  "helper_text": {
    "safety": "We always confirm before adding items, opening a retailer, or ending your session."
  }
}
```

### SEC-003 — Recommended item rail

```json
{
  "eyebrow": null,
  "headline": "Do you want to {{gesture_action}}?",
  "supporting_copy": null,
  "labels": {
    "recognized": "Your gesture",
    "action": "Next action"
  },
  "helper_text": {
    "safety": "We always confirm before adding items, opening a retailer, or ending your session."
  }
}
```

### SEC-004 — Safety and alternatives

```json
{
  "helper_text": {
    "safety": "We always confirm before adding items, opening a retailer, or ending your session."
  },
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
  "headline": "Do you want to {{gesture_action}}?",
  "supporting_copy": null,
  "primary_cta": "{{gesture_action}}",
  "secondary_cta": "Cancel",
  "tertiary_cta": null,
  "navigation": {},
  "labels": {
    "recognized": "Your gesture",
    "action": "Next action"
  },
  "helper_text": {
    "safety": "We always confirm before adding items, opening a retailer, or ending your session."
  },
  "validation": {},
  "status_messages": {},
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
        "headline": "Do you want to {{gesture_action}}?",
        "supporting_copy": null,
        "labels": {
          "recognized": "Your gesture",
          "action": "Next action"
        },
        "helper_text": {
          "safety": "We always confirm before adding items, opening a retailer, or ending your session."
        }
      }
    },
    {
      "section_id": "SEC-003",
      "section_name": "Recommended item rail",
      "copy": {
        "eyebrow": null,
        "headline": "Do you want to {{gesture_action}}?",
        "supporting_copy": null,
        "labels": {
          "recognized": "Your gesture",
          "action": "Next action"
        },
        "helper_text": {
          "safety": "We always confirm before adding items, opening a retailer, or ending your session."
        }
      }
    },
    {
      "section_id": "SEC-004",
      "section_name": "Safety and alternatives",
      "copy": {
        "helper_text": {
          "safety": "We always confirm before adding items, opening a retailer, or ending your session."
        },
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
