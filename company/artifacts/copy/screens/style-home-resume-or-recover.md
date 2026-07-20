# Style Home — Resume or Recover

Status: Approved  
Screen ID: `dd9e7858-c66f-5351-a51c-dd63a8b11d7a`  
Screen slug: `style-home-resume-or-recover`  
State: `recovery`  
Audience: Returning-customer home when incomplete or failed work needs a specific resume or recovery action.

## Job and primary action

- **User job:** Returning-customer home when incomplete or failed work needs a specific resume or recovery action.
- **Primary action:** Keep going

## Recommended exact copy in wireframe order

### SEC-001 — App navigation

```json
{
  "navigation": {}
}
```

### SEC-002 — Current status

```json
{
  "headline": "Right where you left it.",
  "supporting_copy": "Your style report is waiting.",
  "status_messages": {
    "saved": "Your progress is saved."
  },
  "validation": {}
}
```

### SEC-003 — Report highlights

```json
{
  "eyebrow": null,
  "headline": "Right where you left it.",
  "supporting_copy": "Your style report is waiting.",
  "labels": {
    "incomplete": "Continue",
    "paused": "Try again",
    "ready": "Ready"
  },
  "helper_text": {}
}
```

### SEC-004 — Recommended items

```json
{
  "eyebrow": null,
  "headline": "Right where you left it.",
  "supporting_copy": "Your style report is waiting.",
  "labels": {
    "incomplete": "Continue",
    "paused": "Try again",
    "ready": "Ready"
  },
  "helper_text": {}
}
```

### SEC-005 — Saved and recent activity

```json
{
  "eyebrow": null,
  "headline": "Right where you left it.",
  "supporting_copy": "Your style report is waiting.",
  "labels": {
    "incomplete": "Continue",
    "paused": "Try again",
    "ready": "Ready"
  },
  "helper_text": {}
}
```

## Complete implementation object

```json
{
  "eyebrow": null,
  "headline": "Right where you left it.",
  "supporting_copy": "Your style report is waiting.",
  "primary_cta": "Keep going",
  "secondary_cta": "Try again",
  "tertiary_cta": "View my report",
  "navigation": {},
  "labels": {
    "incomplete": "Continue",
    "paused": "Try again",
    "ready": "Ready"
  },
  "helper_text": {},
  "validation": {},
  "status_messages": {
    "saved": "Your progress is saved."
  },
  "consent": {},
  "metadata": {},
  "accessibility": {},
  "sections": [
    {
      "section_id": "SEC-001",
      "section_name": "App navigation",
      "copy": {
        "navigation": {}
      }
    },
    {
      "section_id": "SEC-002",
      "section_name": "Current status",
      "copy": {
        "headline": "Right where you left it.",
        "supporting_copy": "Your style report is waiting.",
        "status_messages": {
          "saved": "Your progress is saved."
        },
        "validation": {}
      }
    },
    {
      "section_id": "SEC-003",
      "section_name": "Report highlights",
      "copy": {
        "eyebrow": null,
        "headline": "Right where you left it.",
        "supporting_copy": "Your style report is waiting.",
        "labels": {
          "incomplete": "Continue",
          "paused": "Try again",
          "ready": "Ready"
        },
        "helper_text": {}
      }
    },
    {
      "section_id": "SEC-004",
      "section_name": "Recommended items",
      "copy": {
        "eyebrow": null,
        "headline": "Right where you left it.",
        "supporting_copy": "Your style report is waiting.",
        "labels": {
          "incomplete": "Continue",
          "paused": "Try again",
          "ready": "Ready"
        },
        "helper_text": {}
      }
    },
    {
      "section_id": "SEC-005",
      "section_name": "Saved and recent activity",
      "copy": {
        "eyebrow": null,
        "headline": "Right where you left it.",
        "supporting_copy": "Your style report is waiting.",
        "labels": {
          "incomplete": "Continue",
          "paused": "Try again",
          "ready": "Ready"
        },
        "helper_text": {}
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
