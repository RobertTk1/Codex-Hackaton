# In-App Browser End-to-End Protocol

Use the installed `browser:control-in-app-browser` skill for every customer-facing QA case. Read its complete `SKILL.md` before browser work. Physical-device camera, microphone, gesture, and simultaneous-realtime checks supplement rather than replace the Browser case.

## Test Like a Customer

- Begin at the journey's real entry point, not a deep link that skips required behavior.
- Interact through visible controls and accessible names.
- Verify outcomes the customer can observe, not DOM implementation details.
- Complete the whole case, including account, data persistence, navigation, and cross-feature handoffs named by the story.
- Do not use hidden state changes, direct database edits, or API calls to bypass a step except for declared fixture setup.

## Browser Case Procedure

1. Record candidate revision, URL, browser surface, viewport/device, account, and fixture ID.
2. Establish the case's declared clean session and data state.
3. Capture the starting state.
4. Perform each step in order and capture evidence at meaningful state transitions.
5. Verify visible content, control state, focus, navigation, persisted data, and customer-facing errors.
6. Inspect relevant browser/runtime and network evidence using Browser capabilities available in its current documentation.
7. Verify no unexplained console error, unhandled rejection, failed required request, or indefinite pending request occurred.
8. Capture the terminal state and record actual versus expected results.

## Durable Interaction Rules

- Prefer roles, labels, and customer-visible text over CSS or DOM structure.
- Wait for user-visible state changes rather than arbitrary sleeps.
- Treat unexpected overlays, disabled controls, duplicate submissions, lost focus, and stale state as observed behavior, not test-harness noise.
- A screenshot proves appearance at an instant; it does not prove that the preceding operation succeeded. Pair visual evidence with the relevant state or request evidence.
- Each case must be repeatable from its documented precondition without relying on the previous QA case.

## Required Browser Coverage

For applicable stories, cover:

- Desktop and mobile target viewports.
- Pointer and keyboard paths.
- Refresh, back/forward, resume, and direct-return behavior.
- Loading, empty, success, validation, permission-denied, unavailable, slow, and recovery states.
- Anonymous start, account connection, returning login, and ownership continuity.
- Real provider smoke behavior when the release gate requires it.
