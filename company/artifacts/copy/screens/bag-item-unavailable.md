# Bag — Item Unavailable

Status: Approved  
Screen ID: `d894b82b-ac4b-564a-9d74-bce7184b05be`  
Screen slug: `bag-item-unavailable`  
State: `unavailable`  
Audience: Bag state that identifies an unavailable item and offers removal or alternatives.

## Job and primary action

- **User job:** Bag state that identifies an unavailable item and offers removal or alternatives.
- **Primary action:** Find something similar

## Recommended exact copy in wireframe order

### SEC-001 — App navigation

```json
{
  "navigation": {}
}
```

### SEC-002 — Retailer-grouped selections

```json
{
  "eyebrow": null,
  "headline": "One of your picks sold out.",
  "supporting_copy": "Your other picks are still here.",
  "labels": {
    "unavailable": "Sold out",
    "available": "Available",
    "preserved": "Other picks saved"
  },
  "helper_text": {}
}
```

### SEC-003 — Checkout boundary

```json
{
  "eyebrow": null,
  "headline": "One of your picks sold out.",
  "supporting_copy": "Your other picks are still here.",
  "labels": {
    "unavailable": "Sold out",
    "available": "Available",
    "preserved": "Other picks saved"
  },
  "helper_text": {}
}
```

### SEC-004 — Bag actions

```json
{
  "primary_cta": "Find something similar",
  "secondary_cta": "Remove it",
  "tertiary_cta": "Keep styling"
}
```

## Complete implementation object

```json
{
  "eyebrow": null,
  "headline": "One of your picks sold out.",
  "supporting_copy": "Your other picks are still here.",
  "primary_cta": "Find something similar",
  "secondary_cta": "Remove it",
  "tertiary_cta": "Keep styling",
  "navigation": {},
  "labels": {
    "unavailable": "Sold out",
    "available": "Available",
    "preserved": "Other picks saved"
  },
  "helper_text": {},
  "validation": {},
  "status_messages": {
    "preserved": "Your other picks are saved."
  },
  "consent": {},
  "metadata": {},
  "accessibility": {},
  "sections": [
    {
      "section_id": "SEC-001",
      "section_name": "App navigation",
      "copy": {
        "navigation": {}
      }
    },
    {
      "section_id": "SEC-002",
      "section_name": "Retailer-grouped selections",
      "copy": {
        "eyebrow": null,
        "headline": "One of your picks sold out.",
        "supporting_copy": "Your other picks are still here.",
        "labels": {
          "unavailable": "Sold out",
          "available": "Available",
          "preserved": "Other picks saved"
        },
        "helper_text": {}
      }
    },
    {
      "section_id": "SEC-003",
      "section_name": "Checkout boundary",
      "copy": {
        "eyebrow": null,
        "headline": "One of your picks sold out.",
        "supporting_copy": "Your other picks are still here.",
        "labels": {
          "unavailable": "Sold out",
          "available": "Available",
          "preserved": "Other picks saved"
        },
        "helper_text": {}
      }
    },
    {
      "section_id": "SEC-004",
      "section_name": "Bag actions",
      "copy": {
        "primary_cta": "Find something similar",
        "secondary_cta": "Remove it",
        "tertiary_cta": "Keep styling"
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
