# Flow 01 — First Style Report

Related scenarios: SC-001, SC-003, SC-004, SC-005, SC-006, SC-007, SC-008, SC-013

## Happy path

1. Customer understands the report promise, time, input requirements, and image use on the landing page.
2. Customer selects **Get your style report**; Magic Mirror creates an anonymous authenticated identity.
3. Customer provides personal context, preferred style-presentation context, height, and optional weight.
4. Customer records favorite brands and known category-specific sizes.
5. Customer consents to photo analysis and uploads 8–12 favorite full-body looks.
6. Customer refines taste with right/Love, left/Hate, and down/Maybe swipes or equivalent controls.
7. Customer connects progress using Google or an email magic link; an existing email logs in instead of creating a duplicate.
8. Magic Mirror analyzes the preserved inputs and returns the report in a target of one to two minutes.
9. Customer lands on the report overview with clear paths into color, body style, recommendations, and live styling.

## Recovery branches

- Invalid profile fields stay local to their inputs and retain valid answers.
- Rejected photos do not remove successful uploads; the customer can replace only the failed image.
- A failed taste card can be retried without losing previous choices.
- A delayed magic link can be resent or replaced with Google access; anonymous progress remains attached.
- After 120 seconds, the analysis screen becomes a truthful slow state with safe exit and notification.
- A provider failure shows normalized recovery and states which inputs were preserved.

## Completion signal

The customer can open a complete, account-owned style report without repeating any valid onboarding input.
