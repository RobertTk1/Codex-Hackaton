# Style Home — Base

Status: Approved  
Screen ID: `d677a738-5703-4b02-b7ca-667c31ac7555`  
Screen slug: `style-home-base`  
State: `base`  
Audience: Returning-customer home with report highlights, selected recommendations, live styling entry, bag, and account access.

## Job and primary action

- **User job:** Returning-customer home with report highlights, selected recommendations, live styling entry, bag, and account access.
- **Primary action:** Start live styling

## Recommended exact copy in wireframe order

### SEC-001 — App navigation

```json
{
  "navigation": {
    "home": "Style home",
    "report": "My report",
    "picks": "My picks",
    "bag": "Bag",
    "profile": "Profile"
  }
}
```

### SEC-002 — Current status

```json
{
  "headline": "What are you in the mood to wear, {{preferred_name}}?",
  "supporting_copy": null,
  "status_messages": {},
  "validation": {}
}
```

### SEC-003 — Report highlights

```json
{
  "eyebrow": null,
  "headline": "What are you in the mood to wear, {{preferred_name}}?",
  "supporting_copy": null,
  "labels": {
    "report": "Report highlights",
    "next": "Recommended next step",
    "picks": "Selected for you",
    "recent": "Recent activity"
  },
  "helper_text": {}
}
```

### SEC-004 — Recommended items

```json
{
  "eyebrow": null,
  "headline": "What are you in the mood to wear, {{preferred_name}}?",
  "supporting_copy": null,
  "labels": {
    "report": "Report highlights",
    "next": "Recommended next step",
    "picks": "Selected for you",
    "recent": "Recent activity"
  },
  "helper_text": {}
}
```

### SEC-005 — Saved and recent activity

```json
{
  "eyebrow": null,
  "headline": "What are you in the mood to wear, {{preferred_name}}?",
  "supporting_copy": null,
  "labels": {
    "report": "Report highlights",
    "next": "Recommended next step",
    "picks": "Selected for you",
    "recent": "Recent activity"
  },
  "helper_text": {}
}
```

## Complete implementation object

```json
{
  "eyebrow": null,
  "headline": "What are you in the mood to wear, {{preferred_name}}?",
  "supporting_copy": null,
  "primary_cta": "Start live styling",
  "secondary_cta": "View my report",
  "tertiary_cta": "Browse my picks",
  "navigation": {
    "home": "Style home",
    "report": "My report",
    "picks": "My picks",
    "bag": "Bag",
    "profile": "Profile"
  },
  "labels": {
    "report": "Report highlights",
    "next": "Recommended next step",
    "picks": "Selected for you",
    "recent": "Recent activity"
  },
  "helper_text": {},
  "validation": {},
  "status_messages": {},
  "consent": {},
  "metadata": {
    "dynamic_tokens": [
      "preferred_name"
    ]
  },
  "accessibility": {},
  "sections": [
    {
      "section_id": "SEC-001",
      "section_name": "App navigation",
      "copy": {
        "navigation": {
          "home": "Style home",
          "report": "My report",
          "picks": "My picks",
          "bag": "Bag",
          "profile": "Profile"
        }
      }
    },
    {
      "section_id": "SEC-002",
      "section_name": "Current status",
      "copy": {
        "headline": "What are you in the mood to wear, {{preferred_name}}?",
        "supporting_copy": null,
        "status_messages": {},
        "validation": {}
      }
    },
    {
      "section_id": "SEC-003",
      "section_name": "Report highlights",
      "copy": {
        "eyebrow": null,
        "headline": "What are you in the mood to wear, {{preferred_name}}?",
        "supporting_copy": null,
        "labels": {
          "report": "Report highlights",
          "next": "Recommended next step",
          "picks": "Selected for you",
          "recent": "Recent activity"
        },
        "helper_text": {}
      }
    },
    {
      "section_id": "SEC-004",
      "section_name": "Recommended items",
      "copy": {
        "eyebrow": null,
        "headline": "What are you in the mood to wear, {{preferred_name}}?",
        "supporting_copy": null,
        "labels": {
          "report": "Report highlights",
          "next": "Recommended next step",
          "picks": "Selected for you",
          "recent": "Recent activity"
        },
        "helper_text": {}
      }
    },
    {
      "section_id": "SEC-005",
      "section_name": "Saved and recent activity",
      "copy": {
        "eyebrow": null,
        "headline": "What are you in the mood to wear, {{preferred_name}}?",
        "supporting_copy": null,
        "labels": {
          "report": "Report highlights",
          "next": "Recommended next step",
          "picks": "Selected for you",
          "recent": "Recent activity"
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
