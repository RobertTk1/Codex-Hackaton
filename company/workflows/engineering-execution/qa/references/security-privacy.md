# Security and Privacy QA

## Required Boundaries

For applicable journeys verify:

- Anonymous sessions cannot read or mutate another anonymous or authenticated user's data.
- Account connection preserves only the initiating customer's approved anonymous data.
- Two authenticated accounts remain isolated across profiles, photos, reports, generated images, recommendations, bags, and sessions.
- Direct object identifiers, stale links, storage URLs, and altered requests do not bypass ownership checks.
- Google and magic-link authentication reject invalid, expired, replayed, or unapproved redirects safely.
- Upload validation rejects unsupported, oversized, malformed, and unauthorized assets without partial false success.
- Private assets remain private and signed access expires as designed.
- Consent, retention, deletion, and derived-asset rules match the approved contracts.
- Logs, screenshots, reports, analytics, and error messages do not expose secrets, tokens, raw credentials, or unnecessary personal/sensitive data.
- Server errors do not disclose stack traces, internal queries, provider secrets, or infrastructure details to customers.

## Positive and Negative Coverage

Test both allowed and denied behavior. A security control is not proven by a happy-path owner request. Use two isolated QA accounts and explicitly attempt cross-owner access at every sensitive resource boundary.

## Safe Testing

- Use QA-owned data and approved environments.
- Do not perform broad scanning, denial-of-service, credential attacks, or destructive testing.
- Stop and escalate immediately if unrelated customer data becomes visible.
- Preserve minimal redacted evidence needed to reproduce the issue.

Any cross-owner data exposure, authentication bypass, secret exposure, or unauthorized sensitive action is a critical release blocker.
