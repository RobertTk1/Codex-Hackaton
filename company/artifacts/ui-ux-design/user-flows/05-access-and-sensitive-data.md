# Flow 05 — Account Continuity and Sensitive Data

Related scenarios: SC-006, SC-013

- Starting onboarding creates an anonymous authenticated identity before personal answers or photos are stored.
- Every profile field, upload, and taste choice is written under that identity.
- Google or email magic-link authentication connects the anonymous identity to one permanent account atomically.
- Existing email access logs the customer in and connects eligible anonymous progress; it does not create a duplicate account.
- Photos require explicit analysis consent and remain private to their owning identity.
- Interfaces make no automatic deletion-time promise. Storage lifecycle is a production-policy decision, not a countdown or completion UI.
- Public, anonymous, and permanent-account routes never reveal another customer's report, photos, session, or bag.

Completion signal: the customer moves from anonymous onboarding to permanent access without data loss, duplication, or cross-account exposure.
