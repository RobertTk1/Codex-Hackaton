# Live Styling — Voice Confirmation

Status: Approved  
Screen ID: `8183dd09-dfd2-5ba9-ba70-c8034de399cf`  
Screen slug: `live-styling-voice-confirmation`  
State: `confirming`  
Audience: Interpreted voice request shown for confirmation before action.

## Job and primary action

- **User job:** Interpreted voice request shown for confirmation before action.
- **Primary action:** Yes, show me

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
  "headline": "How does this sound?",
  "supporting_copy": "“{{interpreted_request}}”",
  "labels": {
    "transcript": "You said",
    "interpretation": "We’ll show"
  },
  "helper_text": {}
}
```

### SEC-003 — Recommended item rail

```json
{
  "eyebrow": null,
  "headline": "How does this sound?",
  "supporting_copy": "“{{interpreted_request}}”",
  "labels": {
    "transcript": "You said",
    "interpretation": "We’ll show"
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
      "voice_transcript",
      "interpreted_request"
    ]
  }
}
```

## Complete implementation object

```json
{
  "eyebrow": null,
  "headline": "How does this sound?",
  "supporting_copy": "“{{interpreted_request}}”",
  "primary_cta": "Yes, show me",
  "secondary_cta": "Change it",
  "tertiary_cta": "Cancel",
  "navigation": {},
  "labels": {
    "transcript": "You said",
    "interpretation": "We’ll show"
  },
  "helper_text": {},
  "validation": {},
  "status_messages": {},
  "consent": {},
  "metadata": {
    "dynamic_tokens": [
      "voice_transcript",
      "interpreted_request"
    ]
  },
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
        "headline": "How does this sound?",
        "supporting_copy": "“{{interpreted_request}}”",
        "labels": {
          "transcript": "You said",
          "interpretation": "We’ll show"
        },
        "helper_text": {}
      }
    },
    {
      "section_id": "SEC-003",
      "section_name": "Recommended item rail",
      "copy": {
        "eyebrow": null,
        "headline": "How does this sound?",
        "supporting_copy": "“{{interpreted_request}}”",
        "labels": {
          "transcript": "You said",
          "interpretation": "We’ll show"
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
            "voice_transcript",
            "interpreted_request"
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
