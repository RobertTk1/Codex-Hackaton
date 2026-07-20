# Style Report — Feedback and Recalibration

Status: Approved  
Screen ID: `4d345373-f991-5f0d-8ac7-5885e4a456f8`  
Screen slug: `style-report-feedback-and-recalibration`  
State: `feedback`  
Audience: Correction and recalibration state shared by report findings.

## Job and primary action

- **User job:** Correction and recalibration state shared by report findings.
- **Primary action:** Update my report

## Recommended exact copy in wireframe order

### SEC-001 — Report navigation

```json
{
  "navigation": {}
}
```

### SEC-002 — Feedback form

```json
{
  "eyebrow": null,
  "headline": "Make this feel more like you.",
  "supporting_copy": "Tell us what missed the mark, and we’ll adjust your report.",
  "labels": {
    "finding": "Your result",
    "feedback_type": "What feels off?",
    "correction": "What would you change?",
    "context": "Anything else? (optional)"
  },
  "helper_text": {
    "effect": "We’ll use your feedback to improve your report and picks."
  }
}
```

### SEC-003 — Confirmation and next step

```json
{
  "primary_cta": "Update my report",
  "secondary_cta": null,
  "tertiary_cta": "Cancel"
}
```

## Complete implementation object

```json
{
  "eyebrow": null,
  "headline": "Make this feel more like you.",
  "supporting_copy": "Tell us what missed the mark, and we’ll adjust your report.",
  "primary_cta": "Update my report",
  "secondary_cta": null,
  "tertiary_cta": "Cancel",
  "navigation": {},
  "labels": {
    "finding": "Your result",
    "feedback_type": "What feels off?",
    "correction": "What would you change?",
    "context": "Anything else? (optional)"
  },
  "helper_text": {
    "effect": "We’ll use your feedback to improve your report and picks."
  },
  "validation": {
    "required": "Choose what feels off and tell us what you’d change."
  },
  "status_messages": {},
  "consent": {},
  "metadata": {},
  "accessibility": {},
  "sections": [
    {
      "section_id": "SEC-001",
      "section_name": "Report navigation",
      "copy": {
        "navigation": {}
      }
    },
    {
      "section_id": "SEC-002",
      "section_name": "Feedback form",
      "copy": {
        "eyebrow": null,
        "headline": "Make this feel more like you.",
        "supporting_copy": "Tell us what missed the mark, and we’ll adjust your report.",
        "labels": {
          "finding": "Your result",
          "feedback_type": "What feels off?",
          "correction": "What would you change?",
          "context": "Anything else? (optional)"
        },
        "helper_text": {
          "effect": "We’ll use your feedback to improve your report and picks."
        }
      }
    },
    {
      "section_id": "SEC-003",
      "section_name": "Confirmation and next step",
      "copy": {
        "primary_cta": "Update my report",
        "secondary_cta": null,
        "tertiary_cta": "Cancel"
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
