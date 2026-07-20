# Magic Mirror Bag — Base

Status: Approved  
Screen ID: `1eb0f961-b299-4ab3-b90d-12692f254494`  
Screen slug: `magic-mirror-bag-base`  
State: `base`  
Audience: Selected products grouped by retailer with availability, external-checkout boundaries, and removal controls.

## Job and primary action

- **User job:** Selected products grouped by retailer with availability, external-checkout boundaries, and removal controls.
- **Primary action:** Shop at retailer

## Recommended exact copy in wireframe order

### SEC-001 — App navigation

```json
{
  "navigation": {
    "report": "Report",
    "style": "Live styling",
    "bag": "Bag"
  }
}
```

### SEC-002 — Retailer-grouped selections

```json
{
  "eyebrow": null,
  "headline": "Your picks.",
  "supporting_copy": "One more look before you shop.",
  "labels": {
    "retailer_group": "From {{retailer_name}}",
    "availability": "Availability",
    "remove": "Remove",
    "subtotal": "Subtotal"
  },
  "helper_text": {
    "boundary": "You’ll check out with each retailer."
  }
}
```

### SEC-003 — Checkout boundary

```json
{
  "eyebrow": null,
  "headline": "Your picks.",
  "supporting_copy": "One more look before you shop.",
  "labels": {
    "retailer_group": "From {{retailer_name}}",
    "availability": "Availability",
    "remove": "Remove",
    "subtotal": "Subtotal"
  },
  "helper_text": {
    "boundary": "You’ll check out with each retailer."
  }
}
```

### SEC-004 — Bag actions

```json
{
  "primary_cta": "Shop at retailer",
  "secondary_cta": "Keep styling",
  "tertiary_cta": null
}
```

## Complete implementation object

```json
{
  "eyebrow": null,
  "headline": "Your picks.",
  "supporting_copy": "One more look before you shop.",
  "primary_cta": "Shop at retailer",
  "secondary_cta": "Keep styling",
  "tertiary_cta": null,
  "navigation": {
    "report": "Report",
    "style": "Live styling",
    "bag": "Bag"
  },
  "labels": {
    "retailer_group": "From {{retailer_name}}",
    "availability": "Availability",
    "remove": "Remove",
    "subtotal": "Subtotal"
  },
  "helper_text": {
    "boundary": "You’ll check out with each retailer."
  },
  "validation": {},
  "status_messages": {},
  "consent": {},
  "metadata": {
    "dynamic_tokens": [
      "retailer_name"
    ]
  },
  "accessibility": {},
  "sections": [
    {
      "section_id": "SEC-001",
      "section_name": "App navigation",
      "copy": {
        "navigation": {
          "report": "Report",
          "style": "Live styling",
          "bag": "Bag"
        }
      }
    },
    {
      "section_id": "SEC-002",
      "section_name": "Retailer-grouped selections",
      "copy": {
        "eyebrow": null,
        "headline": "Your picks.",
        "supporting_copy": "One more look before you shop.",
        "labels": {
          "retailer_group": "From {{retailer_name}}",
          "availability": "Availability",
          "remove": "Remove",
          "subtotal": "Subtotal"
        },
        "helper_text": {
          "boundary": "You’ll check out with each retailer."
        }
      }
    },
    {
      "section_id": "SEC-003",
      "section_name": "Checkout boundary",
      "copy": {
        "eyebrow": null,
        "headline": "Your picks.",
        "supporting_copy": "One more look before you shop.",
        "labels": {
          "retailer_group": "From {{retailer_name}}",
          "availability": "Availability",
          "remove": "Remove",
          "subtotal": "Subtotal"
        },
        "helper_text": {
          "boundary": "You’ll check out with each retailer."
        }
      }
    },
    {
      "section_id": "SEC-004",
      "section_name": "Bag actions",
      "copy": {
        "primary_cta": "Shop at retailer",
        "secondary_cta": "Keep styling",
        "tertiary_cta": null
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
