# Taste Calibration — Base

Status: Approved  
Screen ID: `e6f13ec8-a8d0-405c-932b-3befeb7de4f6`  
Screen slug: `taste-calibration-base`  
State: `base`  
Audience: Tinder-like look or garment card: right/Love, left/Hate, and down/Maybe, with matching buttons, keyboard controls, undo, and progress.

## Job and primary action

- **User job:** Tinder-like look or garment card: right/Love, left/Hate, and down/Maybe, with matching buttons, keyboard controls, undo, and progress.
- **Primary action:** Love

## Recommended exact copy in wireframe order

### SEC-001 — Onboarding progress

```json
{
  "eyebrow": "STEP 4 OF 4",
  "headline": "Trust your first reaction.",
  "supporting_copy": "Swipe right for Love, left for Hate, or down for Maybe.",
  "labels": {
    "progress": "Your picks",
    "undo": "Undo"
  },
  "helper_text": {
    "gestures": "Right for Love. Left for Hate. Down for Maybe.",
    "keyboard": "Use the right, left, or down arrow keys."
  }
}
```

### SEC-002 — Taste decision workspace

```json
{
  "eyebrow": "STEP 4 OF 4",
  "headline": "Trust your first reaction.",
  "supporting_copy": "Swipe right for Love, left for Hate, or down for Maybe.",
  "labels": {
    "progress": "Your picks",
    "undo": "Undo"
  },
  "helper_text": {
    "gestures": "Right for Love. Left for Hate. Down for Maybe.",
    "keyboard": "Use the right, left, or down arrow keys."
  }
}
```

### SEC-003 — Interaction guidance

```json
{
  "primary_cta": "Love",
  "secondary_cta": "Hate",
  "tertiary_cta": "Maybe"
}
```

### SEC-004 — Step actions

```json
{
  "primary_cta": "Love",
  "secondary_cta": "Hate",
  "tertiary_cta": "Maybe"
}
```

## Complete implementation object

```json
{
  "eyebrow": "STEP 4 OF 4",
  "headline": "Trust your first reaction.",
  "supporting_copy": "Swipe right for Love, left for Hate, or down for Maybe.",
  "primary_cta": "Love",
  "secondary_cta": "Hate",
  "tertiary_cta": "Maybe",
  "navigation": {},
  "labels": {
    "progress": "Your picks",
    "undo": "Undo"
  },
  "helper_text": {
    "gestures": "Right for Love. Left for Hate. Down for Maybe.",
    "keyboard": "Use the right, left, or down arrow keys."
  },
  "validation": {},
  "status_messages": {},
  "consent": {},
  "metadata": {},
  "accessibility": {
    "card": "Style look",
    "announcement": "Choice saved. Next look."
  },
  "sections": [
    {
      "section_id": "SEC-001",
      "section_name": "Onboarding progress",
      "copy": {
        "eyebrow": "STEP 4 OF 4",
        "headline": "Trust your first reaction.",
        "supporting_copy": "Swipe right for Love, left for Hate, or down for Maybe.",
        "labels": {
          "progress": "Your picks",
          "undo": "Undo"
        },
        "helper_text": {
          "gestures": "Right for Love. Left for Hate. Down for Maybe.",
          "keyboard": "Use the right, left, or down arrow keys."
        }
      }
    },
    {
      "section_id": "SEC-002",
      "section_name": "Taste decision workspace",
      "copy": {
        "eyebrow": "STEP 4 OF 4",
        "headline": "Trust your first reaction.",
        "supporting_copy": "Swipe right for Love, left for Hate, or down for Maybe.",
        "labels": {
          "progress": "Your picks",
          "undo": "Undo"
        },
        "helper_text": {
          "gestures": "Right for Love. Left for Hate. Down for Maybe.",
          "keyboard": "Use the right, left, or down arrow keys."
        }
      }
    },
    {
      "section_id": "SEC-003",
      "section_name": "Interaction guidance",
      "copy": {
        "primary_cta": "Love",
        "secondary_cta": "Hate",
        "tertiary_cta": "Maybe"
      }
    },
    {
      "section_id": "SEC-004",
      "section_name": "Step actions",
      "copy": {
        "primary_cta": "Love",
        "secondary_cta": "Hate",
        "tertiary_cta": "Maybe"
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
