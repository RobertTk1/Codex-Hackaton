# Brand and Size Profile — Base

Status: Approved  
Screen ID: `9ad25480-da71-430f-816a-6f394bed7f15`  
Screen slug: `brand-and-size-profile-base`  
State: `base`  
Audience: Favorite-brand selection and category-specific known-size entry.

## Job and primary action

- **User job:** Favorite-brand selection and category-specific known-size entry.
- **Primary action:** Add my photos

## Recommended exact copy in wireframe order

### SEC-001 — Onboarding progress

```json
{
  "eyebrow": "STEP 2 OF 4",
  "headline": "What fits you best?",
  "supporting_copy": "Choose a few favorite brands and the sizes you reach for.",
  "labels": {
    "brands": "Favorite brands",
    "brand_search": "Search or add a brand",
    "category": "Garment category",
    "size": "Usual size",
    "unknown": "I’m not sure"
  },
  "helper_text": {
    "sizing": "Add another entry when your size changes by brand or item."
  }
}
```

### SEC-002 — Brand selection

```json
{
  "eyebrow": "STEP 2 OF 4",
  "headline": "What fits you best?",
  "supporting_copy": "Choose a few favorite brands and the sizes you reach for.",
  "labels": {
    "brands": "Favorite brands",
    "brand_search": "Search or add a brand",
    "category": "Garment category",
    "size": "Usual size",
    "unknown": "I’m not sure"
  },
  "helper_text": {
    "sizing": "Add another entry when your size changes by brand or item."
  }
}
```

### SEC-003 — Category sizes

```json
{
  "eyebrow": "STEP 2 OF 4",
  "headline": "What fits you best?",
  "supporting_copy": "Choose a few favorite brands and the sizes you reach for.",
  "labels": {
    "brands": "Favorite brands",
    "brand_search": "Search or add a brand",
    "category": "Garment category",
    "size": "Usual size",
    "unknown": "I’m not sure"
  },
  "helper_text": {
    "sizing": "Add another entry when your size changes by brand or item."
  }
}
```

### SEC-004 — Step actions

```json
{
  "primary_cta": "Add my photos",
  "secondary_cta": "Back",
  "tertiary_cta": "Save and exit"
}
```

## Complete implementation object

```json
{
  "eyebrow": "STEP 2 OF 4",
  "headline": "What fits you best?",
  "supporting_copy": "Choose a few favorite brands and the sizes you reach for.",
  "primary_cta": "Add my photos",
  "secondary_cta": "Back",
  "tertiary_cta": "Save and exit",
  "navigation": {},
  "labels": {
    "brands": "Favorite brands",
    "brand_search": "Search or add a brand",
    "category": "Garment category",
    "size": "Usual size",
    "unknown": "I’m not sure"
  },
  "helper_text": {
    "sizing": "Add another entry when your size changes by brand or item."
  },
  "validation": {
    "brand": "Choose or add a brand.",
    "size": "Choose a size or select “I’m not sure.”"
  },
  "status_messages": {},
  "consent": {},
  "metadata": {},
  "accessibility": {},
  "sections": [
    {
      "section_id": "SEC-001",
      "section_name": "Onboarding progress",
      "copy": {
        "eyebrow": "STEP 2 OF 4",
        "headline": "What fits you best?",
        "supporting_copy": "Choose a few favorite brands and the sizes you reach for.",
        "labels": {
          "brands": "Favorite brands",
          "brand_search": "Search or add a brand",
          "category": "Garment category",
          "size": "Usual size",
          "unknown": "I’m not sure"
        },
        "helper_text": {
          "sizing": "Add another entry when your size changes by brand or item."
        }
      }
    },
    {
      "section_id": "SEC-002",
      "section_name": "Brand selection",
      "copy": {
        "eyebrow": "STEP 2 OF 4",
        "headline": "What fits you best?",
        "supporting_copy": "Choose a few favorite brands and the sizes you reach for.",
        "labels": {
          "brands": "Favorite brands",
          "brand_search": "Search or add a brand",
          "category": "Garment category",
          "size": "Usual size",
          "unknown": "I’m not sure"
        },
        "helper_text": {
          "sizing": "Add another entry when your size changes by brand or item."
        }
      }
    },
    {
      "section_id": "SEC-003",
      "section_name": "Category sizes",
      "copy": {
        "eyebrow": "STEP 2 OF 4",
        "headline": "What fits you best?",
        "supporting_copy": "Choose a few favorite brands and the sizes you reach for.",
        "labels": {
          "brands": "Favorite brands",
          "brand_search": "Search or add a brand",
          "category": "Garment category",
          "size": "Usual size",
          "unknown": "I’m not sure"
        },
        "helper_text": {
          "sizing": "Add another entry when your size changes by brand or item."
        }
      }
    },
    {
      "section_id": "SEC-004",
      "section_name": "Step actions",
      "copy": {
        "primary_cta": "Add my photos",
        "secondary_cta": "Back",
        "tertiary_cta": "Save and exit"
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
