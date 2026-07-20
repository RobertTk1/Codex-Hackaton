# Conversational Onboarding V2 Experiment

Status: Approved for pre-report implementation by Talisha White on 2026-07-19  
Type: Adopted chat-first frontend direction  
Decision: Use v2 for the pre-report journey; keep the form-based v1 comps as archived reference.

## Hypothesis

A text-led conversation with occasional contextual generative UI will make the pre-report journey feel more personal and fluid while collecting the same structured profile data as the approved form flow.

## User value

- One focused question or decision at a time.
- Visual choices, uploads, and authentication appear exactly when they are needed.
- Previous answers stay in the transcript, remain editable, and are saved.
- Progress and the next outcome remain clear throughout.
- Every gesture has a visible button and keyboard equivalent.

## Time box and success signal

This design pass ends with eight desktop/mobile comparison states, an interaction contract, and a coverage audit. The cheapest success signal is that a reviewer immediately reads the experience as a conversation—not a form placed inside chat—and can confirm that all inputs required by the approved report journey remain present.

## Experiment boundary

- The existing `company/artifacts/screen-mockups/` package is unchanged.
- The experiment ends when the user chooses **Create my style report** and hands off to the existing report-processing experience.
- APIs and account access are represented as real product behavior; no prototype or simulated language appears in the UI.
- Anonymous progress persists until Google or email magic-link access connects it to the customer account.
- No automatic photo-deletion timing is promised.

## Structured data preserved

Name, adult confirmation, gender, age, height, optional weight, favorite brands, garment categories and sizes, 8–12 full-body favorite-look photos, Love/Hate/Maybe taste choices, and Google or email magic-link account access. Gender is the single approved term, can be self-described, and includes disclosed styling/shopping consent.

## Chat-first rule

Ordinary facts and preferences are exchanged as text, one question at a time. A purpose-built inline component appears only when the task is materially visual or secure: uploading and reviewing photos, reacting to looks, connecting an account, or confirming report generation. No persistent sidebar, summary rail, settings panel, or multi-field form is part of this direction.
