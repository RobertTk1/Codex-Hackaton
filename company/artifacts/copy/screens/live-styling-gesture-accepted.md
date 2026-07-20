# Live Styling — Gesture Accepted

Status: Approved  
Screen ID: `a861bac2-1c68-51c8-af40-7ea3cad52809`  
Screen slug: `live-styling-gesture-accepted`  
State: `accepted`  
Audience: Accepted non-consequential gesture with action feedback.

## Job and primary action

- **User job:** Accepted non-consequential gesture with action feedback.
- **Primary action:** Keep styling

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
  "headline": "Done.",
  "supporting_copy": null,
  "labels": {},
  "helper_text": {}
}
```

### SEC-003 — Recommended item rail

```json
{
  "eyebrow": null,
  "headline": "Done.",
  "supporting_copy": null,
  "labels": {},
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
      "gesture_action"
    ]
  }
}
```

## Complete implementation object

```json
{
  "eyebrow": null,
  "headline": "Done.",
  "supporting_copy": null,
  "primary_cta": "Keep styling",
  "secondary_cta": "Undo",
  "tertiary_cta": "Use buttons",
  "navigation": {},
  "labels": {},
  "helper_text": {},
  "validation": {},
  "status_messages": {
    "accepted": "{{gesture_action}}"
  },
  "consent": {},
  "metadata": {
    "dynamic_tokens": [
      "gesture_action"
    ]
  },
  "accessibility": {
    "live_region": "{{gesture_action}} completed."
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
        "headline": "Done.",
        "supporting_copy": null,
        "labels": {},
        "helper_text": {}
      }
    },
    {
      "section_id": "SEC-003",
      "section_name": "Recommended item rail",
      "copy": {
        "eyebrow": null,
        "headline": "Done.",
        "supporting_copy": null,
        "labels": {},
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
