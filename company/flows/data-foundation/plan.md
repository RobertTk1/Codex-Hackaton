# Data Foundation — Feature Plan

**Status:** Implemented; configuration pending

**User outcome:** Once authentication and a real provider are configured, a user’s try-on session and generated assets can be stored privately and isolated from other users.

## What is built

- A versioned Supabase migration for `tryon_sessions` and `generated_assets`.
- Private `tryon-assets` storage with 10 MB JPEG, PNG, and WebP constraints.
- Row-level policies for authenticated users’ sessions, asset rows, and storage paths.
- An application environment template that keeps browser-safe and server-only values separate.

## Configuration gates

- Supabase project URL, anon key, and server-only service-role key.
- Authentication approach; the policies require a real authenticated `auth.uid()`.
- Photo consent, provider-side retention, and deletion behavior.
- Generation-provider choice and API key.

## Acceptance Criteria

- The migration stores references, never binary image data.
- Session, asset, and storage policies are owner-scoped.
- The application can document all required environment names without committing secrets.
- No current mock flow depends on Supabase configuration.

## Expected Handoff

**What:** A ready-to-apply Supabase foundation with no live project configuration.

**Why:** It prevents the real provider integration from inventing a data model or exposing user images later.

**Expected outcome:** After required configuration is supplied, the app can connect sessions and private assets through the existing migration rather than redesigning storage.
