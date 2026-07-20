# Live Styling — Voice Interpreting

Status: Approved  
Screen ID: `b6b1be00-af2d-5976-9648-61bfbd14a836`  
Screen slug: `live-styling-voice-interpreting`  
State: `interpreting`  
Audience: Voice request interpretation state layered over the live session.

## Job and primary action

- **User job:** Voice request interpretation state layered over the live session.
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
  "headline": "Got it—one second.",
  "supporting_copy": null,
  "labels": {
    "heard": "You said",
    "request": "Looking for"
  },
  "helper_text": {}
}
```

### SEC-003 — Recommended item rail

```json
{
  "eyebrow": null,
  "headline": "Got it—one second.",
  "supporting_copy": null,
  "labels": {
    "heard": "You said",
    "request": "Looking for"
  },
  "helper_text": {}
}
```

### SEC-004 — Safety and alternatives

```json
{
  "helper_text": {},
  "consent": {},
  "metadata": {
    "dynamic_tokens": [
      "voice_transcript"
    ]
  }
}
```

## Complete implementation object

```json
{
  "eyebrow": null,
  "headline": "Got it—one second.",
  "supporting_copy": null,
  "primary_cta": "Cancel",
  "secondary_cta": null,
  "tertiary_cta": null,
  "navigation": {},
  "labels": {
    "heard": "You said",
    "request": "Looking for"
  },
  "helper_text": {},
  "validation": {},
  "status_messages": {
    "interpreting": "Finding new options…"
  },
  "consent": {},
  "metadata": {
    "dynamic_tokens": [
      "voice_transcript"
    ]
  },
  "accessibility": {
    "live_region": "Looking for options based on your request."
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
        "headline": "Got it—one second.",
        "supporting_copy": null,
        "labels": {
          "heard": "You said",
          "request": "Looking for"
        },
        "helper_text": {}
      }
    },
    {
      "section_id": "SEC-003",
      "section_name": "Recommended item rail",
      "copy": {
        "eyebrow": null,
        "headline": "Got it—one second.",
        "supporting_copy": null,
        "labels": {
          "heard": "You said",
          "request": "Looking for"
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
        "metadata": {
          "dynamic_tokens": [
            "voice_transcript"
          ]
        }
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
