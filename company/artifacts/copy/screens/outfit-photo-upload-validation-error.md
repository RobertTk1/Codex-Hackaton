# Outfit Photo Upload — Validation Error

Status: Approved  
Screen ID: `acea6cc0-08ca-4691-806e-2faae3ce2b0f`  
Screen slug: `outfit-photo-upload-validation-error`  
State: `error`  
Audience: Local image rejection state that preserves successful uploads and explains replacement.

## Job and primary action

- **User job:** Local image rejection state that preserves successful uploads and explains replacement.
- **Primary action:** Replace photo

## Recommended exact copy in wireframe order

### SEC-001 — Onboarding progress

```json
{
  "eyebrow": null,
  "headline": "Let’s swap this one.",
  "supporting_copy": "Choose a different photo to keep going. Your other photos are ready.",
  "labels": {
    "rejected": "Try another photo",
    "preserved": "Other photos ready"
  },
  "helper_text": {}
}
```

### SEC-002 — Photo guidance

```json
{
  "eyebrow": null,
  "headline": "Let’s swap this one.",
  "supporting_copy": "Choose a different photo to keep going. Your other photos are ready.",
  "labels": {
    "rejected": "Try another photo",
    "preserved": "Other photos ready"
  },
  "helper_text": {}
}
```

### SEC-003 — Upload workspace

```json
{
  "eyebrow": null,
  "headline": "Let’s swap this one.",
  "supporting_copy": "Choose a different photo to keep going. Your other photos are ready.",
  "labels": {
    "rejected": "Try another photo",
    "preserved": "Other photos ready"
  },
  "helper_text": {}
}
```

### SEC-004 — Step actions

```json
{
  "primary_cta": "Replace photo",
  "secondary_cta": "Remove",
  "tertiary_cta": "Add another"
}
```

## Complete implementation object

```json
{
  "eyebrow": null,
  "headline": "Let’s swap this one.",
  "supporting_copy": "Choose a different photo to keep going. Your other photos are ready.",
  "primary_cta": "Replace photo",
  "secondary_cta": "Remove",
  "tertiary_cta": "Add another",
  "navigation": {},
  "labels": {
    "rejected": "Try another photo",
    "preserved": "Other photos ready"
  },
  "helper_text": {},
  "validation": {
    "format": "Choose a JPG, PNG, or HEIC image.",
    "duplicate": "You already added this photo.",
    "full_body": "Choose a photo that shows your full outfit.",
    "unreadable": "We couldn’t open this image. Try another one."
  },
  "status_messages": {
    "preserved": "Your other photos are ready."
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
        "headline": "Let’s swap this one.",
        "supporting_copy": "Choose a different photo to keep going. Your other photos are ready.",
        "labels": {
          "rejected": "Try another photo",
          "preserved": "Other photos ready"
        },
        "helper_text": {}
      }
    },
    {
      "section_id": "SEC-002",
      "section_name": "Photo guidance",
      "copy": {
        "eyebrow": null,
        "headline": "Let’s swap this one.",
        "supporting_copy": "Choose a different photo to keep going. Your other photos are ready.",
        "labels": {
          "rejected": "Try another photo",
          "preserved": "Other photos ready"
        },
        "helper_text": {}
      }
    },
    {
      "section_id": "SEC-003",
      "section_name": "Upload workspace",
      "copy": {
        "eyebrow": null,
        "headline": "Let’s swap this one.",
        "supporting_copy": "Choose a different photo to keep going. Your other photos are ready.",
        "labels": {
          "rejected": "Try another photo",
          "preserved": "Other photos ready"
        },
        "helper_text": {}
      }
    },
    {
      "section_id": "SEC-004",
      "section_name": "Step actions",
      "copy": {
        "primary_cta": "Replace photo",
        "secondary_cta": "Remove",
        "tertiary_cta": "Add another"
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
