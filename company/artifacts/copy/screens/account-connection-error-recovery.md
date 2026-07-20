# Account Connection — Error Recovery

Status: Approved  
Screen ID: `eef632ce-8d4a-5035-aa15-b5efdd09b2a2`  
Screen slug: `account-connection-error-recovery`  
State: `recovery`  
Audience: Interrupted or failed Google or magic-link connection with anonymous progress preserved.

## Job and primary action

- **User job:** Interrupted or failed Google or magic-link connection with anonymous progress preserved.
- **Primary action:** Try again

## Recommended exact copy in wireframe order

### SEC-001 — Onboarding progress

```json
{
  "eyebrow": null,
  "headline": "Let’s try that again.",
  "supporting_copy": "Your progress is safe.",
  "labels": {},
  "helper_text": {}
}
```

### SEC-002 — Unified account connection

```json
{
  "eyebrow": null,
  "headline": "Let’s try that again.",
  "supporting_copy": "Your progress is safe.",
  "labels": {},
  "helper_text": {}
}
```

### SEC-003 — Progress preservation

```json
{
  "helper_text": {},
  "consent": {},
  "metadata": {}
}
```

### SEC-004 — Support

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
  "headline": "Let’s try that again.",
  "supporting_copy": "Your progress is safe.",
  "primary_cta": "Try again",
  "secondary_cta": "Use another way",
  "tertiary_cta": "Get help",
  "navigation": {},
  "labels": {},
  "helper_text": {},
  "validation": {
    "email": "Check your email address and send a new link.",
    "google": "Google sign-in didn’t finish. Try again or use email."
  },
  "status_messages": {
    "interrupted": "Sign-in didn’t finish.",
    "preserved": "Your progress is saved."
  },
  "consent": {},
  "metadata": {},
  "accessibility": {},
  "sections": [
    {
      "section_id": "SEC-001",
      "section_name": "Onboarding progress",
      "copy": {
        "eyebrow": null,
        "headline": "Let’s try that again.",
        "supporting_copy": "Your progress is safe.",
        "labels": {},
        "helper_text": {}
      }
    },
    {
      "section_id": "SEC-002",
      "section_name": "Unified account connection",
      "copy": {
        "eyebrow": null,
        "headline": "Let’s try that again.",
        "supporting_copy": "Your progress is safe.",
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
        "metadata": {}
      }
    },
    {
      "section_id": "SEC-004",
      "section_name": "Support",
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
