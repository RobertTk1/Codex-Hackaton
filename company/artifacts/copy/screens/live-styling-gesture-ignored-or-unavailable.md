# Live Styling — Gesture Ignored or Unavailable

Status: Approved  
Screen ID: `096e3398-1e3a-5c6e-b473-e714ca54ff43`  
Screen slug: `live-styling-gesture-ignored-or-unavailable`  
State: `recovery`  
Audience: Ignored, unrecognized, or unavailable gesture state with positioning and alternative-control recovery.

## Job and primary action

- **User job:** Ignored, unrecognized, or unavailable gesture state with positioning and alternative-control recovery.
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
  "headline": "Let’s try that again.",
  "supporting_copy": "Keep your hands in frame and make one clear gesture.",
  "labels": {},
  "helper_text": {
    "safety": "Nothing changed."
  }
}
```

### SEC-003 — Recommended item rail

```json
{
  "eyebrow": null,
  "headline": "Let’s try that again.",
  "supporting_copy": "Keep your hands in frame and make one clear gesture.",
  "labels": {},
  "helper_text": {
    "safety": "Nothing changed."
  }
}
```

### SEC-004 — Safety and alternatives

```json
{
  "helper_text": {
    "safety": "Nothing changed."
  },
  "consent": {},
  "metadata": {}
}
```

## Complete implementation object

```json
{
  "eyebrow": null,
  "headline": "Let’s try that again.",
  "supporting_copy": "Keep your hands in frame and make one clear gesture.",
  "primary_cta": "Try again",
  "secondary_cta": "Use voice",
  "tertiary_cta": "Use buttons",
  "navigation": {},
  "labels": {},
  "helper_text": {
    "safety": "Nothing changed."
  },
  "validation": {},
  "status_messages": {
    "ignored": "No gesture detected.",
    "unavailable": "Hand controls can’t see you clearly."
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
        "headline": "Let’s try that again.",
        "supporting_copy": "Keep your hands in frame and make one clear gesture.",
        "labels": {},
        "helper_text": {
          "safety": "Nothing changed."
        }
      }
    },
    {
      "section_id": "SEC-003",
      "section_name": "Recommended item rail",
      "copy": {
        "eyebrow": null,
        "headline": "Let’s try that again.",
        "supporting_copy": "Keep your hands in frame and make one clear gesture.",
        "labels": {},
        "helper_text": {
          "safety": "Nothing changed."
        }
      }
    },
    {
      "section_id": "SEC-004",
      "section_name": "Safety and alternatives",
      "copy": {
        "helper_text": {
          "safety": "Nothing changed."
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
