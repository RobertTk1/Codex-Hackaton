# Supabase Foundation

This directory contains the schema needed once Magic Mirror moves beyond the local mock flow.

## What is ready

- `tryon_sessions` records the selected garment, source-photo reference, request status, provider metadata, and latency.
- `generated_assets` records private storage references rather than image bytes.
- `tryon-assets` is a private storage bucket limited to the image formats and 10 MB client limit used by the current page.
- Row-level policies restrict session, asset, and storage-object access to the authenticated owner.

## Configuration still required

Do not apply the migration or connect the application until a Supabase project, authentication approach, retention/deletion policy, and provider image-handling policy are chosen.

When ready:

1. Copy `apps/web/.env.example` to `apps/web/.env.local` and set real values.
2. Link the repository to the intended Supabase project.
3. Apply `migrations/20260718130000_create_tryon_foundation.sql` with `supabase db push`.
4. Confirm authenticated user IDs are used as the first folder segment for every `tryon-assets` object.

The service-role key remains server-only. Database cascade deletes do not delete object-storage bytes; implement the agreed deletion workflow before accepting real user photos.
