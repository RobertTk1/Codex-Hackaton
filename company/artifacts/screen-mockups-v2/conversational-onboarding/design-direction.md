# Conversational Onboarding V2 — Chat-First Design Direction

Status: Approved for pre-report implementation by Talisha White on 2026-07-19  
Parent identity: Acid Dispatch / Editorial Edge

## Core idea

A calm private conversation with an editorial stylist. The transcript is the interface. Text carries ordinary questions and answers. Rich UI appears only when the task is genuinely visual or secure.

## Composition

### Desktop

- Quiet top bar: production Magic Mirror wordmark left; subtle `3 of 6` and `Save and exit` right.
- One centered conversation column, approximately 680–760 px wide.
- No sidebar, progress rail, dashboard, split layout, or persistent summary panel.
- Transcript begins above the fold but leaves generous space around the active turn.
- Sticky bottom composer spans the conversation width and visually anchors every text turn.

### Mobile

- Compact wordmark and tiny progress dots/label.
- Full-width conversation with comfortable 20–24 px gutters.
- Composer remains visually attached to the active question and above the software keyboard area.
- Previous turns scroll naturally; no drawers or separate profile surface during the conversation.

## Conversation language

- Assistant turns are left aligned with a small production focus icon and mostly unboxed text.
- Customer turns are concise, right aligned, and may use an Ink bubble with White text or a pale Acid answer chip.
- Completed turns fade slightly but remain selectable for editing.
- The active assistant question has the strongest typographic emphasis and ends with a clear question mark.
- The assistant asks only one question before yielding.

## Text response behavior

Use the composer for name, gender, age, height, optional weight, desired help, brands, categories, and sizes. Gender uses that exact term, may be self-described, and is preceded by the approved styling/shopping-purpose language. The placeholder echoes the shape of a natural answer—never a field label. At most three short suggestion chips may sit above the composer when they save effort.

Do not render ordinary answers as inputs, radio cards, tables, or mini forms.

## Contextual generative UI

Only four moments may expand beyond text:

1. photo upload/review;
2. visual Love / Hate / Maybe calibration;
3. Google or email magic-link access; and
4. final factual confirmation.

Each component appears inline beneath the question, takes only the width it needs, and disappears into a concise transcript confirmation after completion.

## Visual system

- White canvas, Ink text, Cloud only for the composer and contextual components.
- Acid marks the current progress dot, send action, selected taste choice, and final primary action.
- Instrument Serif is limited to the welcome and rare emotional prompts; Space Grotesk handles the conversation.
- Borders are thin; shadows nearly absent; radii modest rather than messenger-bubble-heavy.
- No human avatar. Use the production lens/focus icon sparingly.

## Motion and smoothness

- User messages appear immediately.
- New assistant turns use a short fade/slide and preserve reading position.
- Contextual components use skeleton-to-content transitions only while real data loads.
- No fake typing dots, glowing AI state, or long artificial delay.
- Reduced-motion mode uses opacity changes only.

## Prohibited

- No sidebar, summary rail, profile drawer, dashboard, or split-screen layout.
- No multi-field cards for simple facts.
- No rewrapped v1 form sections.
- No progress checklist occupying content space.
- No generic customer-support chat window, floating widget, AI gradient, orb, robot, or human stylist portrait.
- No invented findings, opt-ins, commands, partnerships, proof, or backend terminology.
