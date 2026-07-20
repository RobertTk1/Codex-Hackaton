# Live Styling — Changing Item

Status: Approved  
Screen ID: `dded5401-afec-5473-908c-600462fb42ec`  
Screen slug: `live-styling-changing-item`  
State: `changing`  
Audience: In-session state while a new recommended item is being applied.

## Job and primary action

- **User job:** In-session state while a new recommended item is being applied.
- **Primary action:** Cancel

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
  "headline": "Bringing up your next look…",
  "supporting_copy": "Hold your position for a moment.",
  "labels": {
    "current": "Current look",
    "next": "Up next"
  },
  "helper_text": {}
}
```

### SEC-003 — Recommended item rail

```json
{
  "eyebrow": null,
  "headline": "Bringing up your next look…",
  "supporting_copy": "Hold your position for a moment.",
  "labels": {
    "current": "Current look",
    "next": "Up next"
  },
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
  "headline": "Bringing up your next look…",
  "supporting_copy": "Hold your position for a moment.",
  "primary_cta": "Cancel",
  "secondary_cta": null,
  "tertiary_cta": null,
  "navigation": {},
  "labels": {
    "current": "Current look",
    "next": "Up next"
  },
  "helper_text": {},
  "validation": {},
  "status_messages": {
    "changing": "Changing your look…"
  },
  "consent": {},
  "metadata": {},
  "accessibility": {
    "live_region": "Bringing up the next look."
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
        "headline": "Bringing up your next look…",
        "supporting_copy": "Hold your position for a moment.",
        "labels": {
          "current": "Current look",
          "next": "Up next"
        },
        "helper_text": {}
      }
    },
    {
      "section_id": "SEC-003",
      "section_name": "Recommended item rail",
      "copy": {
        "eyebrow": null,
        "headline": "Bringing up your next look…",
        "supporting_copy": "Hold your position for a moment.",
        "labels": {
          "current": "Current look",
          "next": "Up next"
        },
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
