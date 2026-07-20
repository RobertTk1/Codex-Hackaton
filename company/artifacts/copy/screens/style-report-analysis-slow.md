# Style Report Analysis — Slow

Status: Approved  
Screen ID: `762423ae-d732-4325-bed9-b91b42370ca9`  
Screen slug: `style-report-analysis-slow`  
State: `slow`  
Audience: Post-120-second state confirming continued processing, preserved inputs, email notification, and safe exit.

## Job and primary action

- **User job:** Post-120-second state confirming continued processing, preserved inputs, email notification, and safe exit.
- **Primary action:** Email me when it’s ready

## Recommended exact copy in wireframe order

### SEC-001 — Analysis status header

```json
{
  "headline": "Still putting the finishing touches on your report.",
  "supporting_copy": "It’s taking a little longer, but you don’t need to stay on this page.",
  "status_messages": {
    "slow": "Still building your report…",
    "saved": "Everything you added is saved."
  },
  "validation": {}
}
```

### SEC-002 — Analysis state

```json
{
  "headline": "Still putting the finishing touches on your report.",
  "supporting_copy": "It’s taking a little longer, but you don’t need to stay on this page.",
  "status_messages": {
    "slow": "Still building your report…",
    "saved": "Everything you added is saved."
  },
  "validation": {}
}
```

### SEC-003 — Preservation and notification

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
  "headline": "Still putting the finishing touches on your report.",
  "supporting_copy": "It’s taking a little longer, but you don’t need to stay on this page.",
  "primary_cta": "Email me when it’s ready",
  "secondary_cta": "Come back later",
  "tertiary_cta": null,
  "navigation": {},
  "labels": {},
  "helper_text": {},
  "validation": {},
  "status_messages": {
    "slow": "Still building your report…",
    "saved": "Everything you added is saved."
  },
  "consent": {},
  "metadata": {},
  "accessibility": {},
  "sections": [
    {
      "section_id": "SEC-001",
      "section_name": "Analysis status header",
      "copy": {
        "headline": "Still putting the finishing touches on your report.",
        "supporting_copy": "It’s taking a little longer, but you don’t need to stay on this page.",
        "status_messages": {
          "slow": "Still building your report…",
          "saved": "Everything you added is saved."
        },
        "validation": {}
      }
    },
    {
      "section_id": "SEC-002",
      "section_name": "Analysis state",
      "copy": {
        "headline": "Still putting the finishing touches on your report.",
        "supporting_copy": "It’s taking a little longer, but you don’t need to stay on this page.",
        "status_messages": {
          "slow": "Still building your report…",
          "saved": "Everything you added is saved."
        },
        "validation": {}
      }
    },
    {
      "section_id": "SEC-003",
      "section_name": "Preservation and notification",
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
