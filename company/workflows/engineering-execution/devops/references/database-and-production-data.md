# Database, Migration, and Production Data

## Separate Supabase Environments

Development/QA and production must use isolated Supabase environments with distinct project refs and credentials. Use a persistent data-less development branch or a separate development project; never point `magic-mirror-dev` at the production main environment. Do not copy development rows, Auth users, Storage objects, signed URLs, job records, or synthetic media into production.

## Migration Gate

Before production deployment:

1. Verify all migrations reset and pass policy/contract tests locally.
2. Apply the migration set to dev and run the full regression/QA candidate.
3. Run Supabase database advisors and resolve applicable security/performance findings.
4. Verify exposed tables have intentional grants plus RLS; current Supabase settings may not expose new tables automatically.
5. Compare migration history with `supabase migration list` using the installed CLI's discovered syntax.
6. Classify every production migration as backward-compatible expand, data backfill, or destructive contract/cleanup.
7. Confirm the current production release can run safely after the migration.
8. Record backup/recovery readiness and migration version.
9. Run the approved bounded PRE_DEPLOY migration job or equivalent guarded command with one serialized migration writer.
10. Stop deployment if migration exits non-zero or version verification differs.

Do not combine destructive cleanup with the first release that stops using the old shape. Supabase data rollback requires its own backup/restore procedure; App Platform rollback does not undo it.

## Production Seed Policy

No general seed file runs against production. Do not use `supabase db push --include-seed` for production. Only explicitly approved idempotent reference/configuration records may be created, and each must be allowlisted as product configuration rather than test data.

Prohibited production content includes:

- Test/synthetic Auth users or magic-link addresses.
- Synthetic profiles, brand sizes, uploaded photos, extracted garments, taste responses, reports, previews, bags, handoffs, or live sessions.
- QA processing jobs, fake provider responses, demo products, seed markers, or test-only feature flags.
- Development Storage objects or consented operator fixtures used for QA unless that person is intentionally becoming a real production customer.

## Zero-Test-Data Verification

Run a read-only, redacted inventory before and after deployment using known fixture domains, run IDs, seed markers, QA bucket prefixes, and test-only flags. Record counts, not sensitive row content. Every prohibited count must be zero.

If test data is found, block completion. Create an explicit reviewed cleanup task with exact targets and recovery evidence; never run a broad destructive delete based on a loose pattern.
