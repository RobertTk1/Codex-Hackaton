# Account Access — Unauthenticated

Status: Approved  
Screen ID: `ee82967b-e205-401b-a90b-6a94d36470f7`  
Screen slug: `account-access-unauthenticated`  
State: `unauthenticated`  
Audience: Unified Google and email magic-link access that signs up or logs in and provides a route back to anonymous report onboarding.

## Job and primary action

- **User job:** Unified Google and email magic-link access that signs up or logs in and provides a route back to anonymous report onboarding.
- **Primary action:** Continue with Google

## Recommended exact copy in wireframe order

### SEC-001 — Navigation

```json
{
  "navigation": {}
}
```

### SEC-002 — Unified account access

```json
{
  "eyebrow": null,
  "headline": "Sign in to Magic Mirror",
  "supporting_copy": null,
  "labels": {
    "email": "Email address"
  },
  "helper_text": {
    "email": "No password needed."
  }
}
```

### SEC-003 — Support and privacy

```json
{
  "helper_text": {
    "email": "No password needed."
  },
  "consent": {},
  "metadata": {}
}
```

## Complete implementation object

```json
{
  "eyebrow": null,
  "headline": "Sign in to Magic Mirror",
  "supporting_copy": null,
  "primary_cta": "Continue with Google",
  "secondary_cta": "Send me a sign-in link",
  "tertiary_cta": null,
  "navigation": {},
  "labels": {
    "email": "Email address"
  },
  "helper_text": {
    "email": "No password needed."
  },
  "validation": {
    "email": "Enter your email address."
  },
  "status_messages": {},
  "consent": {},
  "metadata": {},
  "accessibility": {},
  "sections": [
    {
      "section_id": "SEC-001",
      "section_name": "Navigation",
      "copy": {
        "navigation": {}
      }
    },
    {
      "section_id": "SEC-002",
      "section_name": "Unified account access",
      "copy": {
        "eyebrow": null,
        "headline": "Sign in to Magic Mirror",
        "supporting_copy": null,
        "labels": {
          "email": "Email address"
        },
        "helper_text": {
          "email": "No password needed."
        }
      }
    },
    {
      "section_id": "SEC-003",
      "section_name": "Support and privacy",
      "copy": {
        "helper_text": {
          "email": "No password needed."
        },
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

- **Headline alternative:** Welcome back.

## Voice notes

Clear, editorial, practical, and transparent.

## Layout constraints

Keep the headline concise, actions predictable, and state guidance readable on mobile.

## Approval and revision notes

- 2026-07-19: Initial draft created from the approved PRD, UX package, company context, and draft voice system.
- Founder approval: Approved by Talisha White on 2026-07-19.
