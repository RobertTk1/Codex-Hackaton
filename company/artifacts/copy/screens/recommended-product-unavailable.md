# Recommended Product — Unavailable

Status: Approved  
Screen ID: `7dc86399-4d75-56ec-a7a7-975b78b7992f`  
Screen slug: `recommended-product-unavailable`  
State: `unavailable`  
Audience: Unavailable recommended-product state with alternatives and preserved context.

## Job and primary action

- **User job:** Unavailable recommended-product state with alternatives and preserved context.
- **Primary action:** See similar

## Recommended exact copy in wireframe order

### SEC-001 — Context navigation

```json
{
  "navigation": {}
}
```

### SEC-002 — Preserved styling context

```json
{
  "eyebrow": null,
  "headline": "This one sold out.",
  "supporting_copy": "We found similar pieces that work for the same reason.",
  "labels": {},
  "helper_text": {
    "freshness": "Availability can change."
  }
}
```

### SEC-003 — Product detail drawer

```json
{
  "eyebrow": null,
  "headline": "This one sold out.",
  "supporting_copy": "We found similar pieces that work for the same reason.",
  "labels": {},
  "helper_text": {
    "freshness": "Availability can change."
  }
}
```

### SEC-004 — Selection actions

```json
{
  "primary_cta": "See similar",
  "secondary_cta": "Close",
  "tertiary_cta": "Back to my picks"
}
```

## Complete implementation object

```json
{
  "eyebrow": null,
  "headline": "This one sold out.",
  "supporting_copy": "We found similar pieces that work for the same reason.",
  "primary_cta": "See similar",
  "secondary_cta": "Close",
  "tertiary_cta": "Back to my picks",
  "navigation": {},
  "labels": {},
  "helper_text": {
    "freshness": "Availability can change."
  },
  "validation": {},
  "status_messages": {
    "unavailable": "Sold out"
  },
  "consent": {},
  "metadata": {},
  "accessibility": {},
  "sections": [
    {
      "section_id": "SEC-001",
      "section_name": "Context navigation",
      "copy": {
        "navigation": {}
      }
    },
    {
      "section_id": "SEC-002",
      "section_name": "Preserved styling context",
      "copy": {
        "eyebrow": null,
        "headline": "This one sold out.",
        "supporting_copy": "We found similar pieces that work for the same reason.",
        "labels": {},
        "helper_text": {
          "freshness": "Availability can change."
        }
      }
    },
    {
      "section_id": "SEC-003",
      "section_name": "Product detail drawer",
      "copy": {
        "eyebrow": null,
        "headline": "This one sold out.",
        "supporting_copy": "We found similar pieces that work for the same reason.",
        "labels": {},
        "helper_text": {
          "freshness": "Availability can change."
        }
      }
    },
    {
      "section_id": "SEC-004",
      "section_name": "Selection actions",
      "copy": {
        "primary_cta": "See similar",
        "secondary_cta": "Close",
        "tertiary_cta": "Back to my picks"
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
