# Data Contract Review — Repeat 2

- **Decision:** Failed; focused Storage lifecycle repair required
- **Reviewed:** `company/artifacts/engineering-plan/contracts/data.md`
- **Prior findings:** DR-001 through DR-009 passed after repair
- **Return step:** `data-contract`
- **Implementation status:** Not started

## Review method

The repaired contract was independently rechecked against every prior finding and then exercised as a migration-level authorization and retention design. The repeat review followed an anonymous customer's objects through existing-account transfer, normal expiry, delayed purge, signed delivery, and account deletion. It also rechecked the relational lifecycle, query/index, consent, job, retry, versioning, RLS, Storage, and migration contracts from the first review.

## Prior findings now passed

- DR-001: the evidence/output mutation matrix permits required system output while keeping submitted customer evidence frozen.
- DR-002: bounded report sequences, one-live-run uniqueness, request idempotency, and existing-success precedence provide a real terminal retry path.
- DR-003: photo-derived signals and extracted garments expire no later than source evidence while bounded candidate/reaction/report evidence survives.
- DR-004: every generated likeness asset retains the exact granted consent event that authorized it.
- DR-005: report versions are owner-level, monotonic, concurrency-safe, and linked across derived profiles.
- DR-006: processing-job errors are discriminated by job kind and use bounded operation stages.
- DR-007: global retention and recovery scans now have leading partial indexes matching their worker predicates.
- DR-008: bounded lifecycles have exact row-state invariants with named database versus transaction enforcement.
- DR-009: same-owner foreign keys are deferrable, the transfer transaction is ordered, and the populated migration fixture is required.

## New findings requiring repair

### DR-010 — Account transfer changes row ownership but strands immutable Storage paths

Object paths embed the owner's ID and customer Storage reads authorize only the first path segment. The anonymous-transfer transaction changes `owner_id` on the profile and all relational descendants, but it neither moves immutable objects nor changes their paths. After a transfer to an existing account, the target therefore owns the metadata but cannot read the objects, while the source identity can still satisfy the old prefix policy if its token remains usable.

**Required repair:** Make current metadata ownership—not the immutable path prefix—the authority for Storage reads. Keep browser insert constrained to its current owner prefix, but define that segment as the creation owner only. For each customer-readable bucket, `select` must match `storage.objects.name` to an unexpired accepted `photos.storage_path` or `generated_assets.storage_path` row whose current `owner_id = auth.uid()`. The transfer must not copy or rename bytes. After the row cascade, the target must read the unchanged object path and the source must fail. Server deletion and reconciliation must enumerate exact metadata paths rather than a current-owner prefix. Add transfer tests for all three buckets and both source/target identities.

### DR-011 — Expiry schedules deletion but does not revoke reads at the deadline

The contract grants owner-only row and bucket reads without an `expires_at` predicate. If the retention worker is delayed or retries an object deletion, expired photos, extracted evidence, or generated assets remain readable beyond their approved maximum. A previously minted signed URL can also outlive the record's deadline unless its TTL is capped.

**Required repair:** Fail closed at logical expiry independently of physical cleanup. Customer `select` policies for expiring rows and Storage objects must require the authoritative deadline to be in the future. Customer-readable lineage rows must require an unexpired readable parent. Signed URLs may be issued only for a currently readable row and must expire no later than that row's `expires_at`. Worker and service-role cleanup remain able to inspect and delete expired records. Add boundary tests immediately before, at, and after expiry plus a delayed-purge fixture proving bytes can remain physically present without customer access.

### DR-012 — Nullable photo expiry permits an unbounded sensitive object

`photos.expires_at` is nullable, the cleanup index excludes nulls, and no photo-state invariant requires a deadline. Every photo class in the approved retention matrix has a bounded deadline, so a null value can escape both logical and physical expiry indefinitely.

**Required repair:** Give every photo row a non-null deadline at creation, including uploaded and rejected states. The initial anonymous deadline is bounded from creation/activity under the approved rule; any report-time extension is an explicit server-only transition capped at 30 days after report generation and may never revive an already expired object. Make derived deadlines less than or equal to this non-null source deadline, remove the null-only cleanup exception, and test that no insert or state transition can produce a missing or retroactively revived deadline.

### DR-013 — Account deletion has no database-enforceable immediate access block

The deletion flow says to revoke sessions and block product actions before purge, but it preserves the Auth user and owned rows until object cleanup succeeds. Revoking refresh sessions does not by itself invalidate every already-issued access token, so an existing JWT can continue to satisfy the current RLS and Storage owner policies while deletion retries. The approved architecture requires immediate product-access revocation.

**Required repair:** Add a minimal server-owned deletion/access-block authority that is checked by every customer table and Storage read/write policy, or define an equivalent database-enforceable mechanism. The account-deletion transaction must establish the block before enqueuing purge work; blocked owners receive no product data or object access even with an unexpired prior JWT, while service-role workers retain cleanup access. Keep this separate from customer-data soft deletion, make the request idempotent, and define when the non-sensitive purge record may be removed. Add tests for an old access token, a refreshed session, direct Data API access, all three buckets, retrying purge, and completed deletion.

## Checks that passed

- The DR-001 through DR-009 repairs are internally consistent and remove the original contradictions.
- All approved customer inputs, outputs, and provider boundaries still have a named authority.
- Ownership remains based on immutable Auth subjects; no policy trusts user metadata.
- Anonymous identities remain isolated from permanent-only report, live-session, and bag operations.
- Customer media remains in private buckets and is never stored inline in Postgres.
- Report retry, versioning, immutable evidence, generated-likeness consent, and source-retention behavior are now exact.
- Job leases, bounded errors, idempotency, cleanup indexes, and no-lock provider calls are migration-ready.
- Shopify live facts remain outside database authority; only stable references and explicit transmission evidence persist.
- The schema still avoids soft-deleted customer rows, speculative repositories, generalized audit/event systems, unbounded JSON, and unnecessary search infrastructure.
- No SQL migration, live Supabase mutation, application contract, or implementation was performed.

## Decision

**Fail and return to `data-contract`.** The relational contract and all nine prior repairs are accepted, but DR-010 through DR-013 must be closed before API/auth/integration contracts can safely depend on Storage access, retention, account transfer, or deletion behavior. The next pass is a narrow authorization-and-retention repair, not a schema redesign.
