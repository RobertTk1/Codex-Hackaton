# Landing Page — Base

Status: Approved  
Screen ID: `76a5f0c7-aa78-4eaf-ae0f-4b577024f5c6`  
Screen slug: `landing-page-base`  
State: `base`  
Audience: Education-led landing page that previews the style report, process, trust terms, and primary conversion action.

## Job and primary action

- **User job:** Education-led landing page that previews the style report, process, trust terms, and primary conversion action.
- **Primary action:** Get my style report

## Recommended exact copy in wireframe order

### SEC-001 — Navigation

```json
{
  "navigation": {
    "how_it_works": "How it works",
    "report": "What’s inside",
    "trust": "Your privacy",
    "login": "Log in"
  }
}
```

### SEC-002 — Hero

```json
{
  "headline": "Your style already has a point of view.",
  "body": "Turn the looks you love into a personal guide to colors, silhouettes, and what to wear next.",
  "primary_cta": "Get my style report",
  "secondary_cta": "Log in"
}
```

### SEC-003 — Report preview

```json
{
  "eyebrow": "YOUR REPORT",
  "headline": "See what makes your style yours.",
  "body": "Discover the colors, shapes, and details you return to—and where to take them next."
}
```

### SEC-004 — How it works

```json
{
  "headline": "From favorite looks to your style report.",
  "steps": [
    "Show us what you love",
    "Follow your first instinct",
    "Meet your style"
  ]
}
```

### SEC-005 — Report contents

```json
{
  "headline": "A guide you can actually wear.",
  "cards": [
    "Your color direction",
    "Your proportions and silhouettes",
    "What to wear next"
  ]
}
```

### SEC-006 — Trust and retailer roles

```json
{
  "headline": "Your style. Your photos. Your choice.",
  "body": "Your photos create your private report. When you find something you love, you’ll shop directly with the retailer."
}
```

### SEC-007 — Frequently asked questions

```json
{
  "headline": "Good questions, answered.",
  "questions": [
    "What do I need to get started?",
    "How long does the report take?",
    "Does Magic Mirror guarantee fit?",
    "How are my photos used?"
  ]
}
```

### SEC-008 — Closing action

```json
{
  "headline": "Meet the style that’s already yours.",
  "primary_cta": "Get my style report",
  "secondary_cta": "Log in"
}
```

### SEC-009 — Footer

```json
{
  "eyebrow": "PERSONAL STYLE, MADE PRACTICAL",
  "headline": "Your style already has a point of view.",
  "supporting_copy": "Turn the looks you love into a personal guide to colors, silhouettes, and what to wear next.",
  "labels": {
    "report_preview": "YOUR REPORT",
    "colors": "Your color direction",
    "body_style": "Your proportions and silhouettes",
    "recommendations": "What to wear next"
  },
  "helper_text": {
    "timing": "Your report is usually ready in 1–2 minutes.",
    "inputs": "Start with a few details and 8–12 photos of looks you love."
  }
}
```

## Complete implementation object

```json
{
  "eyebrow": "PERSONAL STYLE, MADE PRACTICAL",
  "headline": "Your style already has a point of view.",
  "supporting_copy": "Turn the looks you love into a personal guide to colors, silhouettes, and what to wear next.",
  "primary_cta": "Get my style report",
  "secondary_cta": "Log in",
  "tertiary_cta": null,
  "navigation": {
    "how_it_works": "How it works",
    "report": "What’s inside",
    "trust": "Your privacy",
    "login": "Log in"
  },
  "labels": {
    "report_preview": "YOUR REPORT",
    "colors": "Your color direction",
    "body_style": "Your proportions and silhouettes",
    "recommendations": "What to wear next"
  },
  "helper_text": {
    "timing": "Your report is usually ready in 1–2 minutes.",
    "inputs": "Start with a few details and 8–12 photos of looks you love."
  },
  "validation": {},
  "status_messages": {},
  "consent": {
    "photos": "Your photos are used only to create and improve your personal style report."
  },
  "metadata": {
    "retailer_boundary": "Found something you love? You’ll shop and check out directly with the retailer."
  },
  "accessibility": {},
  "sections": [
    {
      "section_id": "SEC-001",
      "section_name": "Navigation",
      "copy": {
        "navigation": {
          "how_it_works": "How it works",
          "report": "What’s inside",
          "trust": "Your privacy",
          "login": "Log in"
        }
      }
    },
    {
      "section_id": "SEC-002",
      "section_name": "Hero",
      "copy": {
        "headline": "Your style already has a point of view.",
        "body": "Turn the looks you love into a personal guide to colors, silhouettes, and what to wear next.",
        "primary_cta": "Get my style report",
        "secondary_cta": "Log in"
      }
    },
    {
      "section_id": "SEC-003",
      "section_name": "Report preview",
      "copy": {
        "eyebrow": "YOUR REPORT",
        "headline": "See what makes your style yours.",
        "body": "Discover the colors, shapes, and details you return to—and where to take them next."
      }
    },
    {
      "section_id": "SEC-004",
      "section_name": "How it works",
      "copy": {
        "headline": "From favorite looks to your style report.",
        "steps": [
          "Show us what you love",
          "Follow your first instinct",
          "Meet your style"
        ]
      }
    },
    {
      "section_id": "SEC-005",
      "section_name": "Report contents",
      "copy": {
        "headline": "A guide you can actually wear.",
        "cards": [
          "Your color direction",
          "Your proportions and silhouettes",
          "What to wear next"
        ]
      }
    },
    {
      "section_id": "SEC-006",
      "section_name": "Trust and retailer roles",
      "copy": {
        "headline": "Your style. Your photos. Your choice.",
        "body": "Your photos create your private report. When you find something you love, you’ll shop directly with the retailer."
      }
    },
    {
      "section_id": "SEC-007",
      "section_name": "Frequently asked questions",
      "copy": {
        "headline": "Good questions, answered.",
        "questions": [
          "What do I need to get started?",
          "How long does the report take?",
          "Does Magic Mirror guarantee fit?",
          "How are my photos used?"
        ]
      }
    },
    {
      "section_id": "SEC-008",
      "section_name": "Closing action",
      "copy": {
        "headline": "Meet the style that’s already yours.",
        "primary_cta": "Get my style report",
        "secondary_cta": "Log in"
      }
    },
    {
      "section_id": "SEC-009",
      "section_name": "Footer",
      "copy": {
        "eyebrow": "PERSONAL STYLE, MADE PRACTICAL",
        "headline": "Your style already has a point of view.",
        "supporting_copy": "Turn the looks you love into a personal guide to colors, silhouettes, and what to wear next.",
        "labels": {
          "report_preview": "YOUR REPORT",
          "colors": "Your color direction",
          "body_style": "Your proportions and silhouettes",
          "recommendations": "What to wear next"
        },
        "helper_text": {
          "timing": "Your report is usually ready in 1–2 minutes.",
          "inputs": "Start with a few details and 8–12 photos of looks you love."
        }
      }
    }
  ]
}
```

## Proof and claims

No testimonial, customer count, rating, fit guarantee, retailer partnership, or measured outcome claim is used. Timing and capability language is limited to the approved product contract and identified as a design target where relevant.

## Alternatives

- **Headline alternative A:** Your style, decoded into something you can use.
- **Headline alternative B:** Turn your favorite looks into your personal style playbook.
- **CTA alternative:** Build my style report

## Voice notes

Editorial and specific, with the mechanism immediately visible. Avoid unsupported proof or attractiveness language.

## Layout constraints

Keep the hero headline to two desktop lines when possible; the primary CTA must remain visible above the fold.

## Approval and revision notes

- 2026-07-19: Initial draft created from the approved PRD, UX package, company context, and draft voice system.
- Founder approval: Approved by Talisha White on 2026-07-19.
