# Retailer Handoff — Confirmation

Status: Approved  
Screen ID: `49c5dc8e-da7f-433d-bba0-5011bb755948`  
Screen slug: `retailer-handoff-confirmation`  
State: `base`  
Audience: Final confirmation that identifies retailer ownership of checkout, stock, price, fulfillment, and returns before navigation.

## Job and primary action

- **User job:** Final confirmation that identifies retailer ownership of checkout, stock, price, fulfillment, and returns before navigation.
- **Primary action:** Shop at {{retailer_name}}

## Recommended exact copy in wireframe order

### SEC-001 — Preserved bag context

```json
{
  "eyebrow": null,
  "headline": "Ready to shop at {{retailer_name}}?",
  "supporting_copy": "You’ll finish your purchase on their site. Your picks will be here when you come back.",
  "labels": {},
  "helper_text": {}
}
```

### SEC-002 — Retailer confirmation

```json
{
  "eyebrow": null,
  "headline": "Ready to shop at {{retailer_name}}?",
  "supporting_copy": "You’ll finish your purchase on their site. Your picks will be here when you come back.",
  "labels": {},
  "helper_text": {}
}
```

## Complete implementation object

```json
{
  "eyebrow": null,
  "headline": "Ready to shop at {{retailer_name}}?",
  "supporting_copy": "You’ll finish your purchase on their site. Your picks will be here when you come back.",
  "primary_cta": "Shop at {{retailer_name}}",
  "secondary_cta": "Not yet",
  "tertiary_cta": null,
  "navigation": {},
  "labels": {},
  "helper_text": {},
  "validation": {},
  "status_messages": {},
  "consent": {},
  "metadata": {
    "dynamic_tokens": [
      "retailer_name"
    ]
  },
  "accessibility": {
    "external": "Opens {{retailer_name}} in a new tab"
  },
  "sections": [
    {
      "section_id": "SEC-001",
      "section_name": "Preserved bag context",
      "copy": {
        "eyebrow": null,
        "headline": "Ready to shop at {{retailer_name}}?",
        "supporting_copy": "You’ll finish your purchase on their site. Your picks will be here when you come back.",
        "labels": {},
        "helper_text": {}
      }
    },
    {
      "section_id": "SEC-002",
      "section_name": "Retailer confirmation",
      "copy": {
        "eyebrow": null,
        "headline": "Ready to shop at {{retailer_name}}?",
        "supporting_copy": "You’ll finish your purchase on their site. Your picks will be here when you come back.",
        "labels": {},
        "helper_text": {}
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
