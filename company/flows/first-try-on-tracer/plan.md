# First Try-On Tracer — Feature Plan

**Status:** Ready to build

**User outcome:** A user can understand and complete the basic Magic Mirror interaction on one page: upload a photo, select one hardcoded garment, request a try-on, and see the result at the bottom of the page.

## Tracer Statement

Build one simple responsive page that proves the complete interaction using local previews and a typed mock generation response. The page establishes the product flow before Supabase, authentication, camera capture, or a real generation provider is introduced.

## Page Flow

1. The user opens the page and sees a short explanation of Magic Mirror.
2. The user clicks **Upload photo** and selects an image.
3. The page validates and previews the selected photo.
4. The user chooses exactly one garment from two or three hardcoded garment cards.
5. The user clicks **Try it on**.
6. The page shows a generating state, then displays a mock result in a result section at the bottom.
7. A failed mock request shows a clear error and **Try again** action without clearing the selected photo or garment.

## Given / When / Then

**Given** the user has selected a valid photo and one available garment,

**When** they click **Try it on**,

**Then** the page shows progress and renders a result at the bottom—or a clear, recoverable failure—without losing their selections.

## Build Tasks

- [ ] Scaffold the Next.js application in `apps/web` with strict TypeScript and Tailwind.
- [ ] Add the approved brand tokens and only the minimum brand assets needed by this page.
- [ ] Build the single-page layout with upload, garment selection, action, status, and result sections.
- [ ] Add client-side photo type and size validation with an image preview.
- [ ] Add two or three hardcoded garments with stable IDs and local images.
- [ ] Require one photo and one garment before enabling **Try it on**.
- [ ] Define the Zod request and response schemas.
- [ ] Add one Next.js route handler calling a typed mock try-on adapter.
- [ ] Simulate success, delay, timeout, and failure without clearing current selections.
- [ ] Render ready, generating, slow, success, and failed states in the bottom result section.
- [ ] Add one Playwright happy-path test and one focused unit test for input validation.
- [ ] Run locally and confirm the flow at mobile and desktop widths.

## Acceptance Criteria

- The entire interaction works on one page without navigation.
- The user sees their selected photo and garment before submission.
- The action is unavailable until both valid inputs exist.
- The mock request crosses a Zod-validated route boundary.
- Progress and failure are visible; retry preserves the current inputs.
- The result appears at the bottom of the same page.
- The Playwright happy path passes.

## Explicitly Deferred

- Real generation provider and provider benchmark.
- Supabase, authentication, storage, and session persistence.
- Camera capture, retailer URL ingestion, and a dynamic catalog.
- Multiple garments, outfits, stylist recommendations, voice, save, and share.

## Dependency Justifications

- **Zod:** validates the browser-to-route boundary; TypeScript alone cannot validate runtime input.
- **Vitest:** runs fast unit tests for pure validation logic; Next.js does not include a unit-test runner.
- **Playwright:** verifies the real browser golden path; unit tests cannot prove the page interaction works end to end.

## Expected Handoff

**What:** One working single-page try-on skeleton backed by a mock adapter.

**Why:** It validates the page flow and integration boundary before committing to storage or an AI provider.

**Expected outcome:** The team can review the full user interaction and later replace the mock adapter without redesigning the page.
