# Personal Profile — Validation Error

Status: Approved  
Screen ID: `4df9db19-8f5b-53dd-a000-18e33ad9a6e3`  
Screen slug: `personal-profile-validation-error`  
State: `error`  
Audience: Field-specific validation that preserves valid personal-profile entries and optional-field choices.

## Job and primary action

- **User job:** Field-specific validation that preserves valid personal-profile entries and optional-field choices.
- **Primary action:** Continue

## Recommended exact copy in wireframe order

### SEC-001 — Onboarding progress

```json
{
  "eyebrow": null,
  "headline": "Check a few details.",
  "supporting_copy": null,
  "labels": {
    "saved": "Saved",
    "error": "Check this",
    "optional": "Weight (optional)"
  },
  "helper_text": {}
}
```

### SEC-002 — Personal profile form

```json
{
  "eyebrow": null,
  "headline": "Check a few details.",
  "supporting_copy": null,
  "labels": {
    "saved": "Saved",
    "error": "Check this",
    "optional": "Weight (optional)"
  },
  "helper_text": {}
}
```

### SEC-003 — Step support

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
  "headline": "Check a few details.",
  "supporting_copy": null,
  "primary_cta": "Continue",
  "secondary_cta": "Save and exit",
  "tertiary_cta": null,
  "navigation": {},
  "labels": {
    "saved": "Saved",
    "error": "Check this",
    "optional": "Weight (optional)"
  },
  "helper_text": {},
  "validation": {
    "adult": "Confirm that you’re 18 or older.",
    "age": "Enter your age.",
    "height": "Enter your height.",
    "gender": "Tell us your gender or self-describe so we can shape styling and shopping recommendations."
  },
  "status_messages": {
    "preserved": "Your other answers are saved."
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
        "headline": "Check a few details.",
        "supporting_copy": null,
        "labels": {
          "saved": "Saved",
          "error": "Check this",
          "optional": "Weight (optional)"
        },
        "helper_text": {}
      }
    },
    {
      "section_id": "SEC-002",
      "section_name": "Personal profile form",
      "copy": {
        "eyebrow": null,
        "headline": "Check a few details.",
        "supporting_copy": null,
        "labels": {
          "saved": "Saved",
          "error": "Check this",
          "optional": "Weight (optional)"
        },
        "helper_text": {}
      }
    },
    {
      "section_id": "SEC-003",
      "section_name": "Step support",
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
