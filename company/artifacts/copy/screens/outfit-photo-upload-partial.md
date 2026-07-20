# Outfit Photo Upload — Partial

Status: Approved  
Screen ID: `7628f30f-b601-49ab-93eb-2cc367ab1b2e`  
Screen slug: `outfit-photo-upload-partial`  
State: `partial`  
Audience: Grid of uploaded and validating images with count progress, replacement, removal, and continue behavior.

## Job and primary action

- **User job:** Grid of uploaded and validating images with count progress, replacement, removal, and continue behavior.
- **Primary action:** Refine my taste

## Recommended exact copy in wireframe order

### SEC-001 — Onboarding progress

```json
{
  "eyebrow": "STEP 3 OF 4",
  "headline": "Your style is taking shape.",
  "supporting_copy": "Add at least 8 photos, then follow your first instinct through a few more looks.",
  "labels": {
    "ready": "Ready",
    "checking": "Checking",
    "replace": "Replace",
    "remove": "Remove"
  },
  "helper_text": {
    "minimum": "You can continue once 8 photos are ready."
  }
}
```

### SEC-002 — Photo guidance

```json
{
  "eyebrow": "STEP 3 OF 4",
  "headline": "Your style is taking shape.",
  "supporting_copy": "Add at least 8 photos, then follow your first instinct through a few more looks.",
  "labels": {
    "ready": "Ready",
    "checking": "Checking",
    "replace": "Replace",
    "remove": "Remove"
  },
  "helper_text": {
    "minimum": "You can continue once 8 photos are ready."
  }
}
```

### SEC-003 — Upload workspace

```json
{
  "eyebrow": "STEP 3 OF 4",
  "headline": "Your style is taking shape.",
  "supporting_copy": "Add at least 8 photos, then follow your first instinct through a few more looks.",
  "labels": {
    "ready": "Ready",
    "checking": "Checking",
    "replace": "Replace",
    "remove": "Remove"
  },
  "helper_text": {
    "minimum": "You can continue once 8 photos are ready."
  }
}
```

### SEC-004 — Step actions

```json
{
  "primary_cta": "Refine my taste",
  "secondary_cta": "Add more photos",
  "tertiary_cta": "Save and exit"
}
```

## Complete implementation object

```json
{
  "eyebrow": "STEP 3 OF 4",
  "headline": "Your style is taking shape.",
  "supporting_copy": "Add at least 8 photos, then follow your first instinct through a few more looks.",
  "primary_cta": "Refine my taste",
  "secondary_cta": "Add more photos",
  "tertiary_cta": "Save and exit",
  "navigation": {},
  "labels": {
    "ready": "Ready",
    "checking": "Checking",
    "replace": "Replace",
    "remove": "Remove"
  },
  "helper_text": {
    "minimum": "You can continue once 8 photos are ready."
  },
  "validation": {},
  "status_messages": {
    "uploading": "Uploading…",
    "validating": "Checking photo…",
    "ready": "Ready"
  },
  "consent": {},
  "metadata": {},
  "accessibility": {},
  "sections": [
    {
      "section_id": "SEC-001",
      "section_name": "Onboarding progress",
      "copy": {
        "eyebrow": "STEP 3 OF 4",
        "headline": "Your style is taking shape.",
        "supporting_copy": "Add at least 8 photos, then follow your first instinct through a few more looks.",
        "labels": {
          "ready": "Ready",
          "checking": "Checking",
          "replace": "Replace",
          "remove": "Remove"
        },
        "helper_text": {
          "minimum": "You can continue once 8 photos are ready."
        }
      }
    },
    {
      "section_id": "SEC-002",
      "section_name": "Photo guidance",
      "copy": {
        "eyebrow": "STEP 3 OF 4",
        "headline": "Your style is taking shape.",
        "supporting_copy": "Add at least 8 photos, then follow your first instinct through a few more looks.",
        "labels": {
          "ready": "Ready",
          "checking": "Checking",
          "replace": "Replace",
          "remove": "Remove"
        },
        "helper_text": {
          "minimum": "You can continue once 8 photos are ready."
        }
      }
    },
    {
      "section_id": "SEC-003",
      "section_name": "Upload workspace",
      "copy": {
        "eyebrow": "STEP 3 OF 4",
        "headline": "Your style is taking shape.",
        "supporting_copy": "Add at least 8 photos, then follow your first instinct through a few more looks.",
        "labels": {
          "ready": "Ready",
          "checking": "Checking",
          "replace": "Replace",
          "remove": "Remove"
        },
        "helper_text": {
          "minimum": "You can continue once 8 photos are ready."
        }
      }
    },
    {
      "section_id": "SEC-004",
      "section_name": "Step actions",
      "copy": {
        "primary_cta": "Refine my taste",
        "secondary_cta": "Add more photos",
        "tertiary_cta": "Save and exit"
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
