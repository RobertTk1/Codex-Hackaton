# Live Styling — Voice Listening

Status: Approved  
Screen ID: `87b489bf-c543-4911-a09d-48b57be4a80a`  
Screen slug: `live-styling-voice-listening`  
State: `listening`  
Audience: Live-session overlay showing that voice capture is active, with cancel and direct-control alternatives.

## Job and primary action

- **User job:** Live-session overlay showing that voice capture is active, with cancel and direct-control alternatives.
- **Primary action:** Stop listening

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
  "eyebrow": "LISTENING",
  "headline": "What’s next?",
  "supporting_copy": "Try “a darker color,” “something for a wedding,” or “under $100.”",
  "labels": {},
  "helper_text": {}
}
```

### SEC-003 — Recommended item rail

```json
{
  "eyebrow": "LISTENING",
  "headline": "What’s next?",
  "supporting_copy": "Try “a darker color,” “something for a wedding,” or “under $100.”",
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
  "eyebrow": "LISTENING",
  "headline": "What’s next?",
  "supporting_copy": "Try “a darker color,” “something for a wedding,” or “under $100.”",
  "primary_cta": "Stop listening",
  "secondary_cta": "Use buttons",
  "tertiary_cta": null,
  "navigation": {},
  "labels": {},
  "helper_text": {},
  "validation": {},
  "status_messages": {
    "listening": "Listening…"
  },
  "consent": {},
  "metadata": {},
  "accessibility": {
    "live_region": "Listening for your request."
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
        "eyebrow": "LISTENING",
        "headline": "What’s next?",
        "supporting_copy": "Try “a darker color,” “something for a wedding,” or “under $100.”",
        "labels": {},
        "helper_text": {}
      }
    },
    {
      "section_id": "SEC-003",
      "section_name": "Recommended item rail",
      "copy": {
        "eyebrow": "LISTENING",
        "headline": "What’s next?",
        "supporting_copy": "Try “a darker color,” “something for a wedding,” or “under $100.”",
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
