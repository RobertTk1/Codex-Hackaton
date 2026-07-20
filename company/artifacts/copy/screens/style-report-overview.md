# Style Report — Overview

Status: Approved  
Screen ID: `1c2d940e-9782-4d23-866a-9e676af44138`  
Screen slug: `style-report-overview`  
State: `success`  
Audience: Affirming style identity, strongest patterns, prioritized opportunities, report navigation, and next styling action.

## Job and primary action

- **User job:** Affirming style identity, strongest patterns, prioritized opportunities, report navigation, and next styling action.
- **Primary action:** Explore my report

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

### SEC-002 — Style identity summary

```json
{
  "headline": "{{style_identity_name}}",
  "body": "The colors, shapes, and details you return to create a style that feels distinctly yours."
}
```

### SEC-003 — Key findings

```json
{
  "eyebrow": "YOUR STYLE REPORT",
  "headline": "See what makes your style yours.",
  "supporting_copy": "Meet the patterns behind your strongest looks—and where to take them next.",
  "labels": {
    "identity": "Your style identity",
    "strengths": "What’s already working",
    "priorities": "Try these first",
    "source": "Based on"
  },
  "helper_text": {
    "inference": "Something feel off? You can change it."
  }
}
```

### SEC-004 — What to do next

```json
{
  "eyebrow": "YOUR STYLE REPORT",
  "headline": "See what makes your style yours.",
  "supporting_copy": "Meet the patterns behind your strongest looks—and where to take them next.",
  "labels": {
    "identity": "Your style identity",
    "strengths": "What’s already working",
    "priorities": "Try these first",
    "source": "Based on"
  },
  "helper_text": {
    "inference": "Something feel off? You can change it."
  }
}
```

### SEC-005 — Feedback and next action

```json
{
  "primary_cta": "Explore my report",
  "secondary_cta": "Change a result"
}
```

## Complete implementation object

```json
{
  "eyebrow": "YOUR STYLE REPORT",
  "headline": "See what makes your style yours.",
  "supporting_copy": "Meet the patterns behind your strongest looks—and where to take them next.",
  "primary_cta": "Explore my report",
  "secondary_cta": "See my picks",
  "tertiary_cta": null,
  "navigation": {
    "overview": "Overview",
    "colors": "Colors",
    "body_style": "Body style",
    "recommendations": "Recommendations"
  },
  "labels": {
    "identity": "Your style identity",
    "strengths": "What’s already working",
    "priorities": "Try these first",
    "source": "Based on"
  },
  "helper_text": {
    "inference": "Something feel off? You can change it."
  },
  "validation": {},
  "status_messages": {},
  "consent": {},
  "metadata": {
    "dynamic_tokens": [
      "style_identity_name",
      "strength_one",
      "priority_one"
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
      "section_name": "Style identity summary",
      "copy": {
        "headline": "{{style_identity_name}}",
        "body": "The colors, shapes, and details you return to create a style that feels distinctly yours."
      }
    },
    {
      "section_id": "SEC-003",
      "section_name": "Key findings",
      "copy": {
        "eyebrow": "YOUR STYLE REPORT",
        "headline": "See what makes your style yours.",
        "supporting_copy": "Meet the patterns behind your strongest looks—and where to take them next.",
        "labels": {
          "identity": "Your style identity",
          "strengths": "What’s already working",
          "priorities": "Try these first",
          "source": "Based on"
        },
        "helper_text": {
          "inference": "Something feel off? You can change it."
        }
      }
    },
    {
      "section_id": "SEC-004",
      "section_name": "What to do next",
      "copy": {
        "eyebrow": "YOUR STYLE REPORT",
        "headline": "See what makes your style yours.",
        "supporting_copy": "Meet the patterns behind your strongest looks—and where to take them next.",
        "labels": {
          "identity": "Your style identity",
          "strengths": "What’s already working",
          "priorities": "Try these first",
          "source": "Based on"
        },
        "helper_text": {
          "inference": "Something feel off? You can change it."
        }
      }
    },
    {
      "section_id": "SEC-005",
      "section_name": "Feedback and next action",
      "copy": {
        "primary_cta": "Explore my report",
        "secondary_cta": "Change a result"
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
