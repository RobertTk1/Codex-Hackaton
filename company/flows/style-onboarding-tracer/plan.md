# Style Onboarding Tracer Plan

**Status:** Implemented

## User Outcome

A visitor can understand the style-report promise, begin onboarding, complete personal context with clear validation, and add one brand with category-specific known sizes.

## Scope

- Landing page at `/` with the report promise and direct start action.
- Personal profile at `/style-report/profile` with Zod validation and adult confirmation.
- Brand and size entry at `/style-report/brands-and-sizes`.
- Browser-session-only continuity, labeled as local prototype storage.
- Existing try-on tracer retained at `/tracer`.

## Acceptance Criteria

- [x] A visitor reaches profile onboarding from the landing page.
- [x] Required profile fields show specific validation without discarding valid values.
- [x] A valid profile is available to the following local browser-session step.
- [x] A visitor can add one brand and select category-specific sizes.
- [x] No account, photo, analysis provider, or Supabase integration is implied or connected.
