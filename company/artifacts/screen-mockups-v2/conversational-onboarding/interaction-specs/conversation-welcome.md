# Chat Onboarding — Welcome Interaction Specification

Screen ID: `29c00d17-3c1d-4231-8b85-4f359a82b5f7`

The assistant delivers two brief orientation messages and asks `Ready to begin?` The consent line directly beside the suggestions explains that starting allows Magic Mirror to use the answers the customer shares to build the style report. `Yes, let’s start` records the current `profile_processing` consent, begins the anonymous conversation, and asks the preferred-name question. Free text such as `sure` or `let’s go` produces the same explicit result only while that consent line is visible. `I already have an account` jumps to the unified Google/magic-link turn and returns to the latest saved question after authentication.

Shared behavior: `shared-contract.md`.
