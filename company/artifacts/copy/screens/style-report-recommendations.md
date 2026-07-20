# Style Report — Recommendations

Status: Approved  
Screen ID: `ec0e2f41-d712-48b1-83fe-c535b1438a12`  
Screen slug: `style-report-recommendations`  
State: `base`  
Audience: Prioritized silhouettes, proportions, layers, fabrics, garments, and outfit guidance tied to report evidence.

## Job and primary action

- **User job:** Prioritized silhouettes, proportions, layers, fabrics, garments, and outfit guidance tied to report evidence.
- **Primary action:** See my picks

## Recommended exact copy in wireframe order

### SEC-001 — Report navigation

```json
{
  "navigation": {
    "overview": "Overview",
    "colors": "Colors",
    "body_style": "Body style",
    "recommendations": "Recommendations"
  }
}
```

### SEC-002 — Recommendation summary

```json
{
  "eyebrow": "WHAT TO WEAR NEXT",
  "headline": "Your next looks, already styled.",
  "supporting_copy": "Explore pieces and outfit ideas chosen to work with your colors, proportions, and taste.",
  "labels": {
    "silhouettes": "Silhouettes",
    "proportions": "Proportions",
    "layers": "Layers",
    "fabrics": "Fabrics",
    "outfits": "Example outfits",
    "reason": "Why this works for you",
    "preview": "Generated wardrobe preview"
  },
  "helper_text": {
    "preview": "A styling visualization, not a fit guarantee. Shop the linked real product at the retailer."
  }
}
```

### SEC-003 — Recommendation categories

```json
{
  "eyebrow": "WHAT TO WEAR NEXT",
  "headline": "Your next looks, already styled.",
  "supporting_copy": "Explore pieces and outfit ideas chosen to work with your colors, proportions, and taste.",
  "labels": {
    "silhouettes": "Silhouettes",
    "proportions": "Proportions",
    "layers": "Layers",
    "fabrics": "Fabrics",
    "outfits": "Example outfits",
    "reason": "Why this works for you",
    "preview": "Generated wardrobe preview"
  },
  "helper_text": {
    "preview": "A styling visualization, not a fit guarantee. Shop the linked real product at the retailer."
  }
}
```

### SEC-004 — Example outfits

```json
{
  "eyebrow": "WHAT TO WEAR NEXT",
  "headline": "Your next looks, already styled.",
  "supporting_copy": "Explore pieces and outfit ideas chosen to work with your colors, proportions, and taste.",
  "labels": {
    "silhouettes": "Silhouettes",
    "proportions": "Proportions",
    "layers": "Layers",
    "fabrics": "Fabrics",
    "outfits": "Example outfits",
    "reason": "Why this works for you",
    "preview": "Generated wardrobe preview"
  },
  "helper_text": {
    "preview": "A styling visualization, not a fit guarantee. Shop the linked real product at the retailer."
  }
}
```

### SEC-005 — Matched products

```json
{
  "eyebrow": "WHAT TO WEAR NEXT",
  "headline": "Your next looks, already styled.",
  "supporting_copy": "Explore pieces and outfit ideas chosen to work with your colors, proportions, and taste.",
  "labels": {
    "silhouettes": "Silhouettes",
    "proportions": "Proportions",
    "layers": "Layers",
    "fabrics": "Fabrics",
    "outfits": "Example outfits",
    "reason": "Why this works for you",
    "preview": "Generated wardrobe preview"
  },
  "helper_text": {
    "preview": "A styling visualization, not a fit guarantee. Shop the linked real product at the retailer."
  }
}
```

## Complete implementation object

```json
{
  "eyebrow": "WHAT TO WEAR NEXT",
  "headline": "Your next looks, already styled.",
  "supporting_copy": "Explore pieces and outfit ideas chosen to work with your colors, proportions, and taste.",
  "primary_cta": "See my picks",
  "secondary_cta": "Save this guide",
  "tertiary_cta": null,
  "navigation": {
    "overview": "Overview",
    "colors": "Colors",
    "body_style": "Body style",
    "recommendations": "Recommendations"
  },
  "labels": {
    "silhouettes": "Silhouettes",
    "proportions": "Proportions",
    "layers": "Layers",
    "fabrics": "Fabrics",
    "outfits": "Example outfits",
    "reason": "Why this works for you",
    "preview": "Generated wardrobe preview"
  },
  "helper_text": {
    "preview": "A styling visualization, not a fit guarantee. Shop the linked real product at the retailer."
  },
  "validation": {},
  "status_messages": {
    "preview_unavailable": "Your recommendation and product link are ready without a generated preview."
  },
  "consent": {},
  "metadata": {},
  "accessibility": {},
  "sections": [
    {
      "section_id": "SEC-001",
      "section_name": "Report navigation",
      "copy": {
        "navigation": {
          "overview": "Overview",
          "colors": "Colors",
          "body_style": "Body style",
          "recommendations": "Recommendations"
        }
      }
    },
    {
      "section_id": "SEC-002",
      "section_name": "Recommendation summary",
      "copy": {
        "eyebrow": "WHAT TO WEAR NEXT",
        "headline": "Your next looks, already styled.",
        "supporting_copy": "Explore pieces and outfit ideas chosen to work with your colors, proportions, and taste.",
        "labels": {
          "silhouettes": "Silhouettes",
          "proportions": "Proportions",
          "layers": "Layers",
          "fabrics": "Fabrics",
          "outfits": "Example outfits",
          "reason": "Why this works for you",
    "preview": "Generated wardrobe preview"
        },
        "helper_text": {
    "preview": "A styling visualization, not a fit guarantee. Shop the linked real product at the retailer."
  }
      }
    },
    {
      "section_id": "SEC-003",
      "section_name": "Recommendation categories",
      "copy": {
        "eyebrow": "WHAT TO WEAR NEXT",
        "headline": "Your next looks, already styled.",
        "supporting_copy": "Explore pieces and outfit ideas chosen to work with your colors, proportions, and taste.",
        "labels": {
          "silhouettes": "Silhouettes",
          "proportions": "Proportions",
          "layers": "Layers",
          "fabrics": "Fabrics",
          "outfits": "Example outfits",
          "reason": "Why this works for you",
    "preview": "Generated wardrobe preview"
        },
        "helper_text": {
    "preview": "A styling visualization, not a fit guarantee. Shop the linked real product at the retailer."
  }
      }
    },
    {
      "section_id": "SEC-004",
      "section_name": "Example outfits",
      "copy": {
        "eyebrow": "WHAT TO WEAR NEXT",
        "headline": "Your next looks, already styled.",
        "supporting_copy": "Explore pieces and outfit ideas chosen to work with your colors, proportions, and taste.",
        "labels": {
          "silhouettes": "Silhouettes",
          "proportions": "Proportions",
          "layers": "Layers",
          "fabrics": "Fabrics",
          "outfits": "Example outfits",
          "reason": "Why this works for you",
    "preview": "Generated wardrobe preview"
        },
        "helper_text": {
    "preview": "A styling visualization, not a fit guarantee. Shop the linked real product at the retailer."
  }
      }
    },
    {
      "section_id": "SEC-005",
      "section_name": "Matched products",
      "copy": {
        "eyebrow": "WHAT TO WEAR NEXT",
        "headline": "Your next looks, already styled.",
        "supporting_copy": "Explore pieces and outfit ideas chosen to work with your colors, proportions, and taste.",
        "labels": {
          "silhouettes": "Silhouettes",
          "proportions": "Proportions",
          "layers": "Layers",
          "fabrics": "Fabrics",
          "outfits": "Example outfits",
          "reason": "Why this works for you",
    "preview": "Generated wardrobe preview"
        },
        "helper_text": {
    "preview": "A styling visualization, not a fit guarantee. Shop the linked real product at the retailer."
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
