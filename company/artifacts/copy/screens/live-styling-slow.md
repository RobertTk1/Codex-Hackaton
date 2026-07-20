# Live Styling — Slow

Status: Approved  
Screen ID: `ae357eac-806d-5768-be5f-89d98443000e`  
Screen slug: `live-styling-slow`  
State: `slow`  
Audience: Explicit slow state for an awaited live visualization update.

## Job and primary action

- **User job:** Explicit slow state for an awaited live visualization update.
- **Primary action:** Keep waiting

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
  "headline": "This look needs another moment.",
  "supporting_copy": "Keep waiting or choose something else.",
  "labels": {},
  "helper_text": {}
}
```

### SEC-003 — Recommended item rail

```json
{
  "eyebrow": null,
  "headline": "This look needs another moment.",
  "supporting_copy": "Keep waiting or choose something else.",
  "labels": {},
  "helper_text": {}
}
```

### SEC-004 — Safety and alternatives

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
  "headline": "This look needs another moment.",
  "supporting_copy": "Keep waiting or choose something else.",
  "primary_cta": "Keep waiting",
  "secondary_cta": "Choose another look",
  "tertiary_cta": "Back to my picks",
  "navigation": {},
  "labels": {},
  "helper_text": {},
  "validation": {},
  "status_messages": {
    "slow": "Still working on this look…",
    "preserved": "Your picks are saved."
  },
  "consent": {},
  "metadata": {},
  "accessibility": {},
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
        "headline": "This look needs another moment.",
        "supporting_copy": "Keep waiting or choose something else.",
        "labels": {},
        "helper_text": {}
      }
    },
    {
      "section_id": "SEC-003",
      "section_name": "Recommended item rail",
      "copy": {
        "eyebrow": null,
        "headline": "This look needs another moment.",
        "supporting_copy": "Keep waiting or choose something else.",
        "labels": {},
        "helper_text": {}
      }
    },
    {
      "section_id": "SEC-004",
      "section_name": "Safety and alternatives",
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
