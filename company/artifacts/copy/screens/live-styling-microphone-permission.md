# Live Styling — Microphone Permission

Status: Approved  
Screen ID: `e72fcc42-581c-44fa-b466-c3ac642e54df`  
Screen slug: `live-styling-microphone-permission`  
State: `permission`  
Audience: Separate microphone permission explanation with direct-control alternative.

## Job and primary action

- **User job:** Separate microphone permission explanation with direct-control alternative.
- **Primary action:** Turn on microphone

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
  "headline": "Style it out loud.",
  "supporting_copy": "Ask for another color, a different shape, or something for the occasion.",
  "labels": {},
  "helper_text": {}
}
```

### SEC-003 — Recommended item rail

```json
{
  "eyebrow": null,
  "headline": "Style it out loud.",
  "supporting_copy": "Ask for another color, a different shape, or something for the occasion.",
  "labels": {},
  "helper_text": {}
}
```

### SEC-004 — Safety and alternatives

```json
{
  "helper_text": {},
  "consent": {
    "microphone": "Allow microphone access while voice control is on."
  },
  "metadata": {}
}
```

## Complete implementation object

```json
{
  "eyebrow": null,
  "headline": "Style it out loud.",
  "supporting_copy": "Ask for another color, a different shape, or something for the occasion.",
  "primary_cta": "Turn on microphone",
  "secondary_cta": "Use buttons instead",
  "tertiary_cta": "Cancel",
  "navigation": {},
  "labels": {},
  "helper_text": {},
  "validation": {},
  "status_messages": {},
  "consent": {
    "microphone": "Allow microphone access while voice control is on."
  },
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
        "headline": "Style it out loud.",
        "supporting_copy": "Ask for another color, a different shape, or something for the occasion.",
        "labels": {},
        "helper_text": {}
      }
    },
    {
      "section_id": "SEC-003",
      "section_name": "Recommended item rail",
      "copy": {
        "eyebrow": null,
        "headline": "Style it out loud.",
        "supporting_copy": "Ask for another color, a different shape, or something for the occasion.",
        "labels": {},
        "helper_text": {}
      }
    },
    {
      "section_id": "SEC-004",
      "section_name": "Safety and alternatives",
      "copy": {
        "helper_text": {},
        "consent": {
          "microphone": "Allow microphone access while voice control is on."
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
