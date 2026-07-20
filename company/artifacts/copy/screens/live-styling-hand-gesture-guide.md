# Live Styling — Hand Gesture Guide

Status: Approved  
Screen ID: `83f2ff2a-7951-42b5-b715-5fbe97ffb568`  
Screen slug: `live-styling-hand-gesture-guide`  
State: `base`  
Audience: Distance-control guide and active interpretation overlay showing supported hand gestures, camera framing, recognition state, intended action, and consequential-action confirmation.

## Job and primary action

- **User job:** Distance-control guide and active interpretation overlay showing supported hand gestures, camera framing, recognition state, intended action, and consequential-action confirmation.
- **Primary action:** Turn on hand controls

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
  "headline": "Hands-free styling.",
  "supporting_copy": "Swipe through looks and choose items without walking back to your screen.",
  "labels": {
    "next": "Next look",
    "previous": "Previous look",
    "select": "Choose"
  },
  "helper_text": {
    "confirmation": "We’ll always ask before adding an item, opening a retailer, or ending your session.",
    "alternatives": "You can use voice or the buttons anytime."
  }
}
```

### SEC-003 — Recommended item rail

```json
{
  "eyebrow": null,
  "headline": "Hands-free styling.",
  "supporting_copy": "Swipe through looks and choose items without walking back to your screen.",
  "labels": {
    "next": "Next look",
    "previous": "Previous look",
    "select": "Choose"
  },
  "helper_text": {
    "confirmation": "We’ll always ask before adding an item, opening a retailer, or ending your session.",
    "alternatives": "You can use voice or the buttons anytime."
  }
}
```

### SEC-004 — Safety and alternatives

```json
{
  "helper_text": {
    "confirmation": "We’ll always ask before adding an item, opening a retailer, or ending your session.",
    "alternatives": "You can use voice or the buttons anytime."
  },
  "consent": {},
  "metadata": {}
}
```

## Complete implementation object

```json
{
  "eyebrow": null,
  "headline": "Hands-free styling.",
  "supporting_copy": "Swipe through looks and choose items without walking back to your screen.",
  "primary_cta": "Turn on hand controls",
  "secondary_cta": "Practice",
  "tertiary_cta": "Use voice",
  "navigation": {},
  "labels": {
    "next": "Next look",
    "previous": "Previous look",
    "select": "Choose"
  },
  "helper_text": {
    "confirmation": "We’ll always ask before adding an item, opening a retailer, or ending your session.",
    "alternatives": "You can use voice or the buttons anytime."
  },
  "validation": {},
  "status_messages": {},
  "consent": {},
  "metadata": {},
  "accessibility": {
    "guide": "Hand gestures and matching actions"
  },
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
        "headline": "Hands-free styling.",
        "supporting_copy": "Swipe through looks and choose items without walking back to your screen.",
        "labels": {
          "next": "Next look",
          "previous": "Previous look",
          "select": "Choose"
        },
        "helper_text": {
          "confirmation": "We’ll always ask before adding an item, opening a retailer, or ending your session.",
          "alternatives": "You can use voice or the buttons anytime."
        }
      }
    },
    {
      "section_id": "SEC-003",
      "section_name": "Recommended item rail",
      "copy": {
        "eyebrow": null,
        "headline": "Hands-free styling.",
        "supporting_copy": "Swipe through looks and choose items without walking back to your screen.",
        "labels": {
          "next": "Next look",
          "previous": "Previous look",
          "select": "Choose"
        },
        "helper_text": {
          "confirmation": "We’ll always ask before adding an item, opening a retailer, or ending your session.",
          "alternatives": "You can use voice or the buttons anytime."
        }
      }
    },
    {
      "section_id": "SEC-004",
      "section_name": "Safety and alternatives",
      "copy": {
        "helper_text": {
          "confirmation": "We’ll always ask before adding an item, opening a retailer, or ending your session.",
          "alternatives": "You can use voice or the buttons anytime."
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
