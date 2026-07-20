# Chat-First Onboarding Shared Interaction Contract

Status: Approved for pre-report implementation by Talisha White on 2026-07-19

## Turn model

- The assistant asks one question, then yields. It never shows the next question before the current answer is accepted.
- Simple facts and preferences use natural-language messages through the persistent composer—not fields, radio cards, or mini forms.
- The parser accepts common phrasing and units. If an answer is ambiguous, the assistant asks one narrow clarification instead of rejecting the whole turn.
- When the customer supplies multiple valid facts in one message, save them and skip redundant follow-ups.
- A concise confirmation carries context forward only when it reduces ambiguity; do not summarize after every answer.

## Thread behavior

- The sent customer message appears optimistically and the composer clears immediately.
- The assistant’s next turn streams in, then focus returns to the composer.
- The viewport scrolls just enough to keep the new question and composer visible together.
- Selecting an earlier customer message exposes `Edit answer`; editing resumes from that turn and preserves later answers unless a true dependency changed.
- `Save and exit` never interrupts the active turn with a dashboard.

## Contextual UI rule

Only photo upload/review, visual taste choice, account access, and final confirmation may render rich components. A component pauses the dialogue, accepts the response, collapses to a short transcript result, and then the next question appears.

## Responsive and accessible behavior

- Desktop uses a centered 680–760 px thread; mobile uses the full viewport with 20–24 px gutters. Neither uses a sidebar.
- The composer remains keyboard reachable and has a visible label, send button, and 44 px minimum targets.
- Enter sends; Shift+Enter creates a new line when multiline text is supported.
- Suggestion chips are optional shortcuts and never the only response path.
- Errors stay within the relevant turn, state what remained saved, and preserve the composer value when retrying.
- Swipe, pointer, color, and voice never stand alone; labeled buttons and keyboard equivalents remain available.
- Reduced motion uses opacity changes without card flight or fake typing animation.
