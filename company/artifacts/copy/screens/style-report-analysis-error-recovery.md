# Style Report Analysis — Error Recovery

Status: Approved  
Screen ID: `6c9017a7-ec72-46df-bba8-79dcc691a817`  
Screen slug: `style-report-analysis-error-recovery`  
State: `recovery`  
Audience: Normalized analysis failure with preserved-input summary, retry, support, and replacement guidance when required.

## Job and primary action

- **User job:** Normalized analysis failure with preserved-input summary, retry, support, and replacement guidance when required.
- **Primary action:** Try again

## Recommended exact copy in wireframe order

### SEC-001 — Analysis status header

```json
{
  "headline": "We hit a snag.",
  "supporting_copy": "Your answers and photos are safe. Try again when you’re ready.",
  "status_messages": {
    "error": "Your report couldn’t be finished.",
    "preserved": "Everything you added is saved."
  },
  "validation": {}
}
```

### SEC-002 — Analysis state

```json
{
  "headline": "We hit a snag.",
  "supporting_copy": "Your answers and photos are safe. Try again when you’re ready.",
  "status_messages": {
    "error": "Your report couldn’t be finished.",
    "preserved": "Everything you added is saved."
  },
  "validation": {}
}
```

### SEC-003 — Preservation and notification

```json
{
  "helper_text": {},
  "consent": {},
  "metadata": {}
}
```

## Complete implementation object

```json
{
  "eyebrow": null,
  "headline": "We hit a snag.",
  "supporting_copy": "Your answers and photos are safe. Try again when you’re ready.",
  "primary_cta": "Try again",
  "secondary_cta": "Get help",
  "tertiary_cta": "Come back later",
  "navigation": {},
  "labels": {},
  "helper_text": {},
  "validation": {},
  "status_messages": {
    "error": "Your report couldn’t be finished.",
    "preserved": "Everything you added is saved."
  },
  "consent": {},
  "metadata": {},
  "accessibility": {},
  "sections": [
    {
      "section_id": "SEC-001",
      "section_name": "Analysis status header",
      "copy": {
        "headline": "We hit a snag.",
        "supporting_copy": "Your answers and photos are safe. Try again when you’re ready.",
        "status_messages": {
          "error": "Your report couldn’t be finished.",
          "preserved": "Everything you added is saved."
        },
        "validation": {}
      }
    },
    {
      "section_id": "SEC-002",
      "section_name": "Analysis state",
      "copy": {
        "headline": "We hit a snag.",
        "supporting_copy": "Your answers and photos are safe. Try again when you’re ready.",
        "status_messages": {
          "error": "Your report couldn’t be finished.",
          "preserved": "Everything you added is saved."
        },
        "validation": {}
      }
    },
    {
      "section_id": "SEC-003",
      "section_name": "Preservation and notification",
      "copy": {
        "helper_text": {},
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
