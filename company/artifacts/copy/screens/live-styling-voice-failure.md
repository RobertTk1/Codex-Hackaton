# Live Styling — Voice Failure

Status: Approved  
Screen ID: `c8945f7b-bc1b-5d12-ba8b-39dc97cba22a`  
Screen slug: `live-styling-voice-failure`  
State: `recovery`  
Audience: Unrecognized or unmatched voice request with retry and direct-control recovery.

## Job and primary action

- **User job:** Unrecognized or unmatched voice request with retry and direct-control recovery.
- **Primary action:** Try again

## Recommended exact copy in wireframe order

### SEC-001 — Session navigation

```json
{
  "navigation": {}
}
```

### SEC-002 — Live session workspace

```json
{
  "eyebrow": null,
  "headline": "Could you say that again?",
  "supporting_copy": "Try a color, shape, brand, budget, or occasion.",
  "labels": {},
  "helper_text": {
    "examples": "Try “blue,” “more fitted,” or “under $100.”"
  }
}
```

### SEC-003 — Recommended item rail

```json
{
  "eyebrow": null,
  "headline": "Could you say that again?",
  "supporting_copy": "Try a color, shape, brand, budget, or occasion.",
  "labels": {},
  "helper_text": {
    "examples": "Try “blue,” “more fitted,” or “under $100.”"
  }
}
```

### SEC-004 — Safety and alternatives

```json
{
  "helper_text": {
    "examples": "Try “blue,” “more fitted,” or “under $100.”"
  },
  "consent": {},
  "metadata": {}
}
```

## Complete implementation object

```json
{
  "eyebrow": null,
  "headline": "Could you say that again?",
  "supporting_copy": "Try a color, shape, brand, budget, or occasion.",
  "primary_cta": "Try again",
  "secondary_cta": "Use buttons",
  "tertiary_cta": "Cancel",
  "navigation": {},
  "labels": {},
  "helper_text": {
    "examples": "Try “blue,” “more fitted,” or “under $100.”"
  },
  "validation": {},
  "status_messages": {
    "unrecognized": "We didn’t catch that.",
    "no_match": "We couldn’t find a matching item."
  },
  "consent": {},
  "metadata": {},
  "accessibility": {},
  "sections": [
    {
      "section_id": "SEC-001",
      "section_name": "Session navigation",
      "copy": {
        "navigation": {}
      }
    },
    {
      "section_id": "SEC-002",
      "section_name": "Live session workspace",
      "copy": {
        "eyebrow": null,
        "headline": "Could you say that again?",
        "supporting_copy": "Try a color, shape, brand, budget, or occasion.",
        "labels": {},
        "helper_text": {
          "examples": "Try “blue,” “more fitted,” or “under $100.”"
        }
      }
    },
    {
      "section_id": "SEC-003",
      "section_name": "Recommended item rail",
      "copy": {
        "eyebrow": null,
        "headline": "Could you say that again?",
        "supporting_copy": "Try a color, shape, brand, budget, or occasion.",
        "labels": {},
        "helper_text": {
          "examples": "Try “blue,” “more fitted,” or “under $100.”"
        }
      }
    },
    {
      "section_id": "SEC-004",
      "section_name": "Safety and alternatives",
      "copy": {
        "helper_text": {
          "examples": "Try “blue,” “more fitted,” or “under $100.”"
        },
        "consent": {},
        "metadata": {}
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
