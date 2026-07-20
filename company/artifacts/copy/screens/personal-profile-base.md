# Personal Profile — Base

Status: Approved  
Screen ID: `61df36bb-6d7c-41a3-bf06-9c2c99824e51`  
Screen slug: `personal-profile-base`  
State: `base`  
Audience: First onboarding step for name, adult confirmation, gender, age, height, and optional weight with disclosed gender consent.

## Job and primary action

- **User job:** First onboarding step for name, adult confirmation, gender, age, height, and optional weight with disclosed gender consent.
- **Primary action:** Choose my brands

## Recommended exact copy in wireframe order

### SEC-001 — Onboarding progress

```json
{
  "eyebrow": "STEP 1 OF 4",
  "headline": "A little about you.",
  "supporting_copy": "This helps us make your style report more personal.",
  "labels": {
    "name": "Name",
    "adult": "I confirm I’m 18 or older",
    "age": "Age",
    "height": "Height",
    "weight": "Weight (optional)",
    "gender": "Gender"
  },
  "helper_text": {
    "name": "The name you’d like us to use.",
    "weight": "Skip this if you’d rather not say.",
    "gender": "We use your gender only to shape styling and shopping recommendations. You can self-describe."
  }
}
```

### SEC-002 — Personal profile form

```json
{
  "eyebrow": "STEP 1 OF 4",
  "headline": "A little about you.",
  "supporting_copy": "This helps us make your style report more personal.",
  "labels": {
    "name": "Name",
    "adult": "I confirm I’m 18 or older",
    "age": "Age",
    "height": "Height",
    "weight": "Weight (optional)",
    "gender": "Gender"
  },
  "helper_text": {
    "name": "The name you’d like us to use.",
    "weight": "Skip this if you’d rather not say.",
    "gender": "We use your gender only to shape styling and shopping recommendations. You can self-describe."
  }
}
```

### SEC-003 — Step support

```json
{
  "helper_text": {
    "name": "The name you’d like us to use.",
    "weight": "Skip this if you’d rather not say.",
    "gender": "We use your gender only to shape styling and shopping recommendations. You can self-describe."
  },
  "consent": {
    "gender": "Your gender is used only to personalize styling and shopping recommendations."
  },
  "metadata": {}
}
```

## Complete implementation object

```json
{
  "eyebrow": "STEP 1 OF 4",
  "headline": "A little about you.",
  "supporting_copy": "This helps us make your style report more personal.",
  "primary_cta": "Choose my brands",
  "secondary_cta": "Save and exit",
  "tertiary_cta": null,
  "navigation": {},
  "labels": {
    "name": "Name",
    "adult": "I confirm I’m 18 or older",
    "age": "Age",
    "height": "Height",
    "weight": "Weight (optional)",
    "gender": "Gender"
  },
  "helper_text": {
    "name": "The name you’d like us to use.",
    "weight": "Skip this if you’d rather not say.",
    "gender": "We use your gender only to shape styling and shopping recommendations. You can self-describe."
  },
  "validation": {
    "adult": "Confirm that you’re 18 or older to continue.",
    "age": "Enter your age.",
    "height": "Enter your height."
  },
  "status_messages": {},
  "consent": {
    "gender": "Your gender is used only to personalize styling and shopping recommendations."
  },
  "metadata": {},
  "accessibility": {},
  "sections": [
    {
      "section_id": "SEC-001",
      "section_name": "Onboarding progress",
      "copy": {
        "eyebrow": "STEP 1 OF 4",
        "headline": "A little about you.",
        "supporting_copy": "This helps us make your style report more personal.",
        "labels": {
          "name": "Name",
          "adult": "I confirm I’m 18 or older",
          "age": "Age",
          "height": "Height",
          "weight": "Weight (optional)",
          "gender": "Gender"
        },
        "helper_text": {
          "name": "The name you’d like us to use.",
          "weight": "Skip this if you’d rather not say.",
          "gender": "We use your gender only to shape styling and shopping recommendations. You can self-describe."
        }
      }
    },
    {
      "section_id": "SEC-002",
      "section_name": "Personal profile form",
      "copy": {
        "eyebrow": "STEP 1 OF 4",
        "headline": "A little about you.",
        "supporting_copy": "This helps us make your style report more personal.",
        "labels": {
          "name": "Name",
          "adult": "I confirm I’m 18 or older",
          "age": "Age",
          "height": "Height",
          "weight": "Weight (optional)",
          "gender": "Gender"
        },
        "helper_text": {
          "name": "The name you’d like us to use.",
          "weight": "Skip this if you’d rather not say.",
          "gender": "We use your gender only to shape styling and shopping recommendations. You can self-describe."
        }
      }
    },
    {
      "section_id": "SEC-003",
      "section_name": "Step support",
      "copy": {
        "helper_text": {
          "name": "The name you’d like us to use.",
          "weight": "Skip this if you’d rather not say.",
          "gender": "We use your gender only to shape styling and shopping recommendations. You can self-describe."
        },
        "consent": {
    "gender": "Your gender is used only to personalize styling and shopping recommendations."
  },
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
