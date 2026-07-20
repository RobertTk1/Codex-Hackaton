# Style Report — Body Style

Status: Approved  
Screen ID: `3acb5ce5-518b-4cf3-beba-ce38439031e2`  
Screen slug: `style-report-body-style`  
State: `base`  
Audience: Kibbe-informed profile, visual rationale, confidence, practical implications, and recalibration path.

## Job and primary action

- **User job:** Kibbe-informed profile, visual rationale, confidence, practical implications, and recalibration path.
- **Primary action:** See my silhouettes

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

### SEC-002 — Body-style summary

```json
{
  "eyebrow": "YOUR STYLE LINES",
  "headline": "Shapes that work with you.",
  "supporting_copy": "Discover the silhouettes, proportions, and details that bring your style into balance.",
  "labels": {
    "profile": "Your Kibbe-inspired type",
    "confidence": "Match",
    "rationale": "Why it fits",
    "implications": "Try this"
  },
  "helper_text": {
    "framework": "This is a starting point. Keep what feels right."
  }
}
```

### SEC-003 — Proportion guidance

```json
{
  "eyebrow": "YOUR STYLE LINES",
  "headline": "Shapes that work with you.",
  "supporting_copy": "Discover the silhouettes, proportions, and details that bring your style into balance.",
  "labels": {
    "profile": "Your Kibbe-inspired type",
    "confidence": "Match",
    "rationale": "Why it fits",
    "implications": "Try this"
  },
  "helper_text": {
    "framework": "This is a starting point. Keep what feels right."
  }
}
```

### SEC-004 — What to wear

```json
{
  "eyebrow": "YOUR STYLE LINES",
  "headline": "Shapes that work with you.",
  "supporting_copy": "Discover the silhouettes, proportions, and details that bring your style into balance.",
  "labels": {
    "profile": "Your Kibbe-inspired type",
    "confidence": "Match",
    "rationale": "Why it fits",
    "implications": "Try this"
  },
  "helper_text": {
    "framework": "This is a starting point. Keep what feels right."
  }
}
```

### SEC-005 — Feedback

```json
{
  "eyebrow": "YOUR STYLE LINES",
  "headline": "Shapes that work with you.",
  "supporting_copy": "Discover the silhouettes, proportions, and details that bring your style into balance.",
  "labels": {
    "profile": "Your Kibbe-inspired type",
    "confidence": "Match",
    "rationale": "Why it fits",
    "implications": "Try this"
  },
  "helper_text": {
    "framework": "This is a starting point. Keep what feels right."
  }
}
```

## Complete implementation object

```json
{
  "eyebrow": "YOUR STYLE LINES",
  "headline": "Shapes that work with you.",
  "supporting_copy": "Discover the silhouettes, proportions, and details that bring your style into balance.",
  "primary_cta": "See my silhouettes",
  "secondary_cta": "Update my result",
  "tertiary_cta": null,
  "navigation": {
    "overview": "Overview",
    "colors": "Colors",
    "body_style": "Body style",
    "recommendations": "Recommendations"
  },
  "labels": {
    "profile": "Your Kibbe-inspired type",
    "confidence": "Match",
    "rationale": "Why it fits",
    "implications": "Try this"
  },
  "helper_text": {
    "framework": "This is a starting point. Keep what feels right."
  },
  "validation": {},
  "status_messages": {},
  "consent": {},
  "metadata": {
    "dynamic_tokens": [
      "body_style_profile",
      "confidence_label"
    ]
  },
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
      "section_name": "Body-style summary",
      "copy": {
        "eyebrow": "YOUR STYLE LINES",
        "headline": "Shapes that work with you.",
        "supporting_copy": "Discover the silhouettes, proportions, and details that bring your style into balance.",
        "labels": {
          "profile": "Your Kibbe-inspired type",
          "confidence": "Match",
          "rationale": "Why it fits",
          "implications": "Try this"
        },
        "helper_text": {
          "framework": "This is a starting point. Keep what feels right."
        }
      }
    },
    {
      "section_id": "SEC-003",
      "section_name": "Proportion guidance",
      "copy": {
        "eyebrow": "YOUR STYLE LINES",
        "headline": "Shapes that work with you.",
        "supporting_copy": "Discover the silhouettes, proportions, and details that bring your style into balance.",
        "labels": {
          "profile": "Your Kibbe-inspired type",
          "confidence": "Match",
          "rationale": "Why it fits",
          "implications": "Try this"
        },
        "helper_text": {
          "framework": "This is a starting point. Keep what feels right."
        }
      }
    },
    {
      "section_id": "SEC-004",
      "section_name": "What to wear",
      "copy": {
        "eyebrow": "YOUR STYLE LINES",
        "headline": "Shapes that work with you.",
        "supporting_copy": "Discover the silhouettes, proportions, and details that bring your style into balance.",
        "labels": {
          "profile": "Your Kibbe-inspired type",
          "confidence": "Match",
          "rationale": "Why it fits",
          "implications": "Try this"
        },
        "helper_text": {
          "framework": "This is a starting point. Keep what feels right."
        }
      }
    },
    {
      "section_id": "SEC-005",
      "section_name": "Feedback",
      "copy": {
        "eyebrow": "YOUR STYLE LINES",
        "headline": "Shapes that work with you.",
        "supporting_copy": "Discover the silhouettes, proportions, and details that bring your style into balance.",
        "labels": {
          "profile": "Your Kibbe-inspired type",
          "confidence": "Match",
          "rationale": "Why it fits",
          "implications": "Try this"
        },
        "helper_text": {
          "framework": "This is a starting point. Keep what feels right."
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
