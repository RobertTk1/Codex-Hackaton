# Style Report Analysis — Processing

Status: Approved  
Screen ID: `ecb422c1-0285-4592-9407-97a1f82bf96e`  
Screen slug: `style-report-analysis-processing`  
State: `processing`  
Audience: Meaningful real-analysis stages, time expectation, safe-exit behavior, and current photo-lifecycle reminder.

## Job and primary action

- **User job:** Meaningful real-analysis stages, time expectation, safe-exit behavior, and current photo-lifecycle reminder.
- **Primary action:** Email me when it’s ready

## Recommended exact copy in wireframe order

### SEC-001 — Analysis status header

```json
{
  "headline": "Your style report is coming together.",
  "supporting_copy": "We’re turning your favorite looks and preferences into guidance made for you.",
  "status_messages": {
    "active": "Building your report…",
    "saved": "You can come back anytime."
  },
  "validation": {}
}
```

### SEC-002 — Analysis state

```json
{
  "headline": "Your style report is coming together.",
  "supporting_copy": "We’re turning your favorite looks and preferences into guidance made for you.",
  "status_messages": {
    "active": "Building your report…",
    "saved": "You can come back anytime."
  },
  "validation": {}
}
```

### SEC-003 — Preservation and notification

```json
{
  "helper_text": {
    "timing": "This usually takes 1–2 minutes."
  },
  "consent": {},
  "metadata": {}
}
```

## Complete implementation object

```json
{
  "eyebrow": null,
  "headline": "Your style report is coming together.",
  "supporting_copy": "We’re turning your favorite looks and preferences into guidance made for you.",
  "primary_cta": "Email me when it’s ready",
  "secondary_cta": "Come back later",
  "tertiary_cta": null,
  "navigation": {},
  "labels": {
    "stage_profile": "Getting to know you",
    "stage_photos": "Finding your patterns",
    "stage_taste": "Following your taste",
    "stage_report": "Creating your guide"
  },
  "helper_text": {
    "timing": "This usually takes 1–2 minutes."
  },
  "validation": {},
  "status_messages": {
    "active": "Building your report…",
    "saved": "You can come back anytime."
  },
  "consent": {},
  "metadata": {},
  "accessibility": {},
  "sections": [
    {
      "section_id": "SEC-001",
      "section_name": "Analysis status header",
      "copy": {
        "headline": "Your style report is coming together.",
        "supporting_copy": "We’re turning your favorite looks and preferences into guidance made for you.",
        "status_messages": {
          "active": "Building your report…",
          "saved": "You can come back anytime."
        },
        "validation": {}
      }
    },
    {
      "section_id": "SEC-002",
      "section_name": "Analysis state",
      "copy": {
        "headline": "Your style report is coming together.",
        "supporting_copy": "We’re turning your favorite looks and preferences into guidance made for you.",
        "status_messages": {
          "active": "Building your report…",
          "saved": "You can come back anytime."
        },
        "validation": {}
      }
    },
    {
      "section_id": "SEC-003",
      "section_name": "Preservation and notification",
      "copy": {
        "helper_text": {
          "timing": "This usually takes 1–2 minutes."
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
