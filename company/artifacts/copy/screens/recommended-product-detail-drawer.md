# Recommended Product — Detail Drawer

Status: Approved  
Screen ID: `a7d262bf-0e4a-423f-9d51-fed5b2594b14`  
Screen slug: `recommended-product-detail-drawer`  
State: `base`  
Audience: Product detail, report rationale, size context, retailer provenance, known price and availability, and session-preserving actions.

## Job and primary action

- **User job:** Product detail, report rationale, size context, retailer provenance, known price and availability, and session-preserving actions.
- **Primary action:** Add to bag

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
  "eyebrow": "PICKED FOR YOU",
  "headline": "{{product_name}}",
  "supporting_copy": "See why it works with your style, then try it on or save it for later.",
  "labels": {
    "retailer": "Retailer",
    "price": "Price",
    "availability": "Availability",
    "size": "Your usual size",
    "rationale": "Why it works",
    "checked": "Last checked"
  },
  "helper_text": {
    "limitation": "Check the retailer for current price, availability, and fit."
  }
}
```

### SEC-003 — Product detail drawer

```json
{
  "eyebrow": "PICKED FOR YOU",
  "headline": "{{product_name}}",
  "supporting_copy": "See why it works with your style, then try it on or save it for later.",
  "labels": {
    "retailer": "Retailer",
    "price": "Price",
    "availability": "Availability",
    "size": "Your usual size",
    "rationale": "Why it works",
    "checked": "Last checked"
  },
  "helper_text": {
    "limitation": "Check the retailer for current price, availability, and fit."
  }
}
```

### SEC-004 — Selection actions

```json
{
  "primary_cta": "Add to bag",
  "secondary_cta": "Try it on",
  "tertiary_cta": "Shop at retailer"
}
```

## Complete implementation object

```json
{
  "eyebrow": "PICKED FOR YOU",
  "headline": "{{product_name}}",
  "supporting_copy": "See why it works with your style, then try it on or save it for later.",
  "primary_cta": "Add to bag",
  "secondary_cta": "Try it on",
  "tertiary_cta": "Shop at retailer",
  "navigation": {},
  "labels": {
    "retailer": "Retailer",
    "price": "Price",
    "availability": "Availability",
    "size": "Your usual size",
    "rationale": "Why it works",
    "checked": "Last checked"
  },
  "helper_text": {
    "limitation": "Check the retailer for current price, availability, and fit."
  },
  "validation": {},
  "status_messages": {},
  "consent": {},
  "metadata": {
    "dynamic_tokens": [
      "product_name",
      "retailer_name",
      "current_price",
      "availability_status",
      "availability_checked_at"
    ]
  },
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
        "eyebrow": "PICKED FOR YOU",
        "headline": "{{product_name}}",
        "supporting_copy": "See why it works with your style, then try it on or save it for later.",
        "labels": {
          "retailer": "Retailer",
          "price": "Price",
          "availability": "Availability",
          "size": "Your usual size",
          "rationale": "Why it works",
          "checked": "Last checked"
        },
        "helper_text": {
          "limitation": "Check the retailer for current price, availability, and fit."
        }
      }
    },
    {
      "section_id": "SEC-003",
      "section_name": "Product detail drawer",
      "copy": {
        "eyebrow": "PICKED FOR YOU",
        "headline": "{{product_name}}",
        "supporting_copy": "See why it works with your style, then try it on or save it for later.",
        "labels": {
          "retailer": "Retailer",
          "price": "Price",
          "availability": "Availability",
          "size": "Your usual size",
          "rationale": "Why it works",
          "checked": "Last checked"
        },
        "helper_text": {
          "limitation": "Check the retailer for current price, availability, and fit."
        }
      }
    },
    {
      "section_id": "SEC-004",
      "section_name": "Selection actions",
      "copy": {
        "primary_cta": "Add to bag",
        "secondary_cta": "Try it on",
        "tertiary_cta": "Shop at retailer"
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
