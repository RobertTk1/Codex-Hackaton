# Account Connection — Base

Status: Approved  
Screen ID: `782fdff8-e9b9-4828-aaa2-33b089ffd011`  
Screen slug: `account-connection-base`  
State: `base`  
Audience: Unified Google and email magic-link step that creates or logs into a permanent account and connects anonymous progress before report generation.

## Job and primary action

- **User job:** Unified Google and email magic-link step that creates or logs into a permanent account and connects anonymous progress before report generation.
- **Primary action:** Continue with Google

## Recommended exact copy in wireframe order

### SEC-001 — Onboarding progress

```json
{
  "eyebrow": "ONE LAST STEP",
  "headline": "Your report is almost ready.",
  "supporting_copy": "Save your progress to see your results and come back anytime.",
  "labels": {
    "email": "Email address"
  },
  "helper_text": {
    "account": "Already have an account? Use the same email to sign in.",
    "progress": "Everything you’ve added is saved when you continue."
  }
}
```

### SEC-002 — Unified account connection

```json
{
  "eyebrow": "ONE LAST STEP",
  "headline": "Your report is almost ready.",
  "supporting_copy": "Save your progress to see your results and come back anytime.",
  "labels": {
    "email": "Email address"
  },
  "helper_text": {
    "account": "Already have an account? Use the same email to sign in.",
    "progress": "Everything you’ve added is saved when you continue."
  }
}
```

### SEC-003 — Progress preservation

```json
{
  "helper_text": {
    "account": "Already have an account? Use the same email to sign in.",
    "progress": "Everything you’ve added is saved when you continue."
  },
  "consent": {
    "account": "By continuing, you agree to create or sign in to your Magic Mirror account."
  },
  "metadata": {}
}
```

### SEC-004 — Support

```json
{
  "helper_text": {
    "account": "Already have an account? Use the same email to sign in.",
    "progress": "Everything you’ve added is saved when you continue."
  },
  "consent": {
    "account": "By continuing, you agree to create or sign in to your Magic Mirror account."
  },
  "metadata": {}
}
```

## Complete implementation object

```json
{
  "eyebrow": "ONE LAST STEP",
  "headline": "Your report is almost ready.",
  "supporting_copy": "Save your progress to see your results and come back anytime.",
  "primary_cta": "Continue with Google",
  "secondary_cta": "Send me a sign-in link",
  "tertiary_cta": null,
  "navigation": {},
  "labels": {
    "email": "Email address"
  },
  "helper_text": {
    "account": "Already have an account? Use the same email to sign in.",
    "progress": "Everything you’ve added is saved when you continue."
  },
  "validation": {
    "email": "Enter your email address."
  },
  "status_messages": {},
  "consent": {
    "account": "By continuing, you agree to create or sign in to your Magic Mirror account."
  },
  "metadata": {},
  "accessibility": {},
  "sections": [
    {
      "section_id": "SEC-001",
      "section_name": "Onboarding progress",
      "copy": {
        "eyebrow": "ONE LAST STEP",
        "headline": "Your report is almost ready.",
        "supporting_copy": "Save your progress to see your results and come back anytime.",
        "labels": {
          "email": "Email address"
        },
        "helper_text": {
          "account": "Already have an account? Use the same email to sign in.",
          "progress": "Everything you’ve added is saved when you continue."
        }
      }
    },
    {
      "section_id": "SEC-002",
      "section_name": "Unified account connection",
      "copy": {
        "eyebrow": "ONE LAST STEP",
        "headline": "Your report is almost ready.",
        "supporting_copy": "Save your progress to see your results and come back anytime.",
        "labels": {
          "email": "Email address"
        },
        "helper_text": {
          "account": "Already have an account? Use the same email to sign in.",
          "progress": "Everything you’ve added is saved when you continue."
        }
      }
    },
    {
      "section_id": "SEC-003",
      "section_name": "Progress preservation",
      "copy": {
        "helper_text": {
          "account": "Already have an account? Use the same email to sign in.",
          "progress": "Everything you’ve added is saved when you continue."
        },
        "consent": {
          "account": "By continuing, you agree to create or sign in to your Magic Mirror account."
        },
        "metadata": {}
      }
    },
    {
      "section_id": "SEC-004",
      "section_name": "Support",
      "copy": {
        "helper_text": {
          "account": "Already have an account? Use the same email to sign in.",
          "progress": "Everything you’ve added is saved when you continue."
        },
        "consent": {
          "account": "By continuing, you agree to create or sign in to your Magic Mirror account."
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
