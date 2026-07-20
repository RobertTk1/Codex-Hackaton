# Live Styling — Connecting

Status: Approved  
Screen ID: `54dc6ff8-3d1b-5989-b8d2-0ad2a89aeaa5`  
Screen slug: `live-styling-connecting`  
State: `connecting`  
Audience: Live visualization connection state with selected product preserved.

## Job and primary action

- **User job:** Live visualization connection state with selected product preserved.
- **Primary action:** Go back

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
  "headline": "Opening your mirror…",
  "supporting_copy": "Your first look is almost ready.",
  "labels": {
    "camera": "Camera",
    "item": "Your first look"
  },
  "helper_text": {}
}
```

### SEC-003 — Recommended item rail

```json
{
  "eyebrow": null,
  "headline": "Opening your mirror…",
  "supporting_copy": "Your first look is almost ready.",
  "labels": {
    "camera": "Camera",
    "item": "Your first look"
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
  "headline": "Opening your mirror…",
  "supporting_copy": "Your first look is almost ready.",
  "primary_cta": "Go back",
  "secondary_cta": null,
  "tertiary_cta": null,
  "navigation": {},
  "labels": {
    "camera": "Camera",
    "item": "Your first look"
  },
  "helper_text": {},
  "validation": {},
  "status_messages": {
    "connecting": "Getting ready…"
  },
  "consent": {},
  "metadata": {},
  "accessibility": {
    "live_region": "Opening the live mirror."
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
        "headline": "Opening your mirror…",
        "supporting_copy": "Your first look is almost ready.",
        "labels": {
          "camera": "Camera",
          "item": "Your first look"
        },
        "helper_text": {}
      }
    },
    {
      "section_id": "SEC-003",
      "section_name": "Recommended item rail",
      "copy": {
        "eyebrow": null,
        "headline": "Opening your mirror…",
        "supporting_copy": "Your first look is almost ready.",
        "labels": {
          "camera": "Camera",
          "item": "Your first look"
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
