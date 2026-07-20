# Taste Calibration — Recovery

Status: Approved  
Screen ID: `37d792e1-4d6c-494f-b53d-1dc4a498c294`  
Screen slug: `taste-calibration-recovery`  
State: `recovery`  
Audience: Failed-card recovery state that preserves earlier taste choices.

## Job and primary action

- **User job:** Failed-card recovery state that preserves earlier taste choices.
- **Primary action:** Load the next look

## Recommended exact copy in wireframe order

### SEC-001 — Onboarding progress

```json
{
  "eyebrow": null,
  "headline": "Let’s try that again.",
  "supporting_copy": "Your choices are saved.",
  "labels": {
    "progress": "Your picks"
  },
  "helper_text": {}
}
```

### SEC-002 — Taste decision workspace

```json
{
  "eyebrow": null,
  "headline": "Let’s try that again.",
  "supporting_copy": "Your choices are saved.",
  "labels": {
    "progress": "Your picks"
  },
  "helper_text": {}
}
```

### SEC-003 — Interaction guidance

```json
{
  "primary_cta": "Load the next look",
  "secondary_cta": "Save and exit",
  "tertiary_cta": null
}
```

### SEC-004 — Step actions

```json
{
  "primary_cta": "Load the next look",
  "secondary_cta": "Save and exit",
  "tertiary_cta": null
}
```

## Complete implementation object

```json
{
  "eyebrow": null,
  "headline": "Let’s try that again.",
  "supporting_copy": "Your choices are saved.",
  "primary_cta": "Load the next look",
  "secondary_cta": "Save and exit",
  "tertiary_cta": null,
  "navigation": {},
  "labels": {
    "progress": "Your picks"
  },
  "helper_text": {},
  "validation": {},
  "status_messages": {
    "error": "The next look didn’t load.",
    "preserved": "Your choices are saved."
  },
  "consent": {},
  "metadata": {},
  "accessibility": {},
  "sections": [
    {
      "section_id": "SEC-001",
      "section_name": "Onboarding progress",
      "copy": {
        "eyebrow": null,
        "headline": "Let’s try that again.",
        "supporting_copy": "Your choices are saved.",
        "labels": {
          "progress": "Your picks"
        },
        "helper_text": {}
      }
    },
    {
      "section_id": "SEC-002",
      "section_name": "Taste decision workspace",
      "copy": {
        "eyebrow": null,
        "headline": "Let’s try that again.",
        "supporting_copy": "Your choices are saved.",
        "labels": {
          "progress": "Your picks"
        },
        "helper_text": {}
      }
    },
    {
      "section_id": "SEC-003",
      "section_name": "Interaction guidance",
      "copy": {
        "primary_cta": "Load the next look",
        "secondary_cta": "Save and exit",
        "tertiary_cta": null
      }
    },
    {
      "section_id": "SEC-004",
      "section_name": "Step actions",
      "copy": {
        "primary_cta": "Load the next look",
        "secondary_cta": "Save and exit",
        "tertiary_cta": null
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
