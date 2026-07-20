# Account Connection — Magic Link Sent

Status: Approved  
Screen ID: `e74afd3b-7709-40af-bedc-15cc9d2a6f1e`  
Screen slug: `account-connection-magic-link-sent`  
State: `recovery`  
Audience: Magic-link waiting and recovery state; the link signs up or logs in and connects preserved anonymous progress after authentication.

## Job and primary action

- **User job:** Magic-link waiting and recovery state; the link signs up or logs in and connects preserved anonymous progress after authentication.
- **Primary action:** Open email

## Recommended exact copy in wireframe order

### SEC-001 — Onboarding progress

```json
{
  "eyebrow": null,
  "headline": "Check your inbox.",
  "supporting_copy": "We sent a sign-in link to {{email_address}}.",
  "labels": {},
  "helper_text": {}
}
```

### SEC-002 — Unified account connection

```json
{
  "eyebrow": null,
  "headline": "Check your inbox.",
  "supporting_copy": "We sent a sign-in link to {{email_address}}.",
  "labels": {},
  "helper_text": {}
}
```

### SEC-003 — Progress preservation

```json
{
  "helper_text": {},
  "consent": {},
  "metadata": {
    "dynamic_tokens": [
      "email_address"
    ]
  }
}
```

### SEC-004 — Support

```json
{
  "helper_text": {},
  "consent": {},
  "metadata": {
    "dynamic_tokens": [
      "email_address"
    ]
  }
}
```

## Complete implementation object

```json
{
  "eyebrow": null,
  "headline": "Check your inbox.",
  "supporting_copy": "We sent a sign-in link to {{email_address}}.",
  "primary_cta": "Open email",
  "secondary_cta": "Send another link",
  "tertiary_cta": "Use Google instead",
  "navigation": {},
  "labels": {},
  "helper_text": {},
  "validation": {},
  "status_messages": {
    "sent": "Link sent to {{email_address}}.",
    "expired": "That link expired. Send a new one to continue."
  },
  "consent": {},
  "metadata": {
    "dynamic_tokens": [
      "email_address"
    ]
  },
  "accessibility": {},
  "sections": [
    {
      "section_id": "SEC-001",
      "section_name": "Onboarding progress",
      "copy": {
        "eyebrow": null,
        "headline": "Check your inbox.",
        "supporting_copy": "We sent a sign-in link to {{email_address}}.",
        "labels": {},
        "helper_text": {}
      }
    },
    {
      "section_id": "SEC-002",
      "section_name": "Unified account connection",
      "copy": {
        "eyebrow": null,
        "headline": "Check your inbox.",
        "supporting_copy": "We sent a sign-in link to {{email_address}}.",
        "labels": {},
        "helper_text": {}
      }
    },
    {
      "section_id": "SEC-003",
      "section_name": "Progress preservation",
      "copy": {
        "helper_text": {},
        "consent": {},
        "metadata": {
          "dynamic_tokens": [
            "email_address"
          ]
        }
      }
    },
    {
      "section_id": "SEC-004",
      "section_name": "Support",
      "copy": {
        "helper_text": {},
        "consent": {},
        "metadata": {
          "dynamic_tokens": [
            "email_address"
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
