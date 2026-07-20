# Data Contract Review

- **Decision:** Failed; focused repair required
- **Reviewed:** `company/artifacts/engineering-plan/contracts/data.md`
- **Return step:** `data-contract`
- **Implementation status:** Not started

## Review method

The data contract was checked field-by-field against the approved PRD/build plan, the architecture package, 24-item implementation-readiness record, Supabase's current RLS/Storage/anonymous-auth/migration behavior, and the known application queries and lifecycles.

The review covered identifiers, nullability, constraints, relationship ownership, immutable evidence, account transfer, query/index support, public grants/RLS, private functions, object lineage, retention/deletion, job concurrency, migration compatibility, and customer-visible failure/retry behavior.

## Findings requiring repair

### DR-001 — Profile freeze rule blocks required system output

The profile contract says only a draft may “accept child writes,” but report runs, reports, recommendations, generated previews, live sessions, and bag items are necessarily created after submission/activation.

**Required repair:** Narrow immutability to customer-input evidence rows—profile fields, brand sizes, photos, extracted evidence, candidates, and reactions—while explicitly allowing owned system-output children after submission. Define which output fields remain mutable, such as attaching an accepted preview to an immutable recommendation.

### DR-002 — Report retry uniqueness has no valid terminal-retry path

The contract allows only one non-cancelled run per profile revision, makes `failed` terminal, and derives one idempotency key from profile/revision. That prevents the approved analysis error/retry screen from starting a fresh bounded run after terminal failure.

**Required repair:** Permit multiple failed/cancelled run attempts while allowing at most one queued/processing/succeeded run for a profile revision. Define request-level idempotency keys, retry sequence/attempt ownership, and the rule that an existing succeeded report always wins.

### DR-003 — Extracted evidence retention conflicts with approved derived-data retention

IR-015 explicitly includes extracted garments and approves same-or-shorter derived-asset retention, while the contract retains structured extracted garments/style signals for the profile lifetime. This is a real policy mismatch, not merely an index detail.

**Required repair:** Give photo-derived signals and extracted garments explicit expiry/purge behavior no later than the source-photo deadline, and state what immutable aggregate report evidence remains after purge. Ensure candidates/reactions/report history do not cascade away unexpectedly when extraction rows expire.

### DR-004 — Generated likeness assets lack immutable consent lineage

Live sessions reference the exact consent events used, but generated wardrobe previews record only sources and a catalog-image transmission flag. Querying “latest current consent” later cannot prove which consent event authorized a specific generated likeness.

**Required repair:** Add an exact granted `generated_likeness_preview` consent-event reference to the generated asset or generation lineage, validate its owner/profile/purpose/decision, and preserve that evidence until the generated asset is deleted.

### DR-005 — Report version scope disagrees with derived-profile versioning

Corrections create a new derived profile, while report version uniqueness is scoped to `profile_id`. In practice each new profile can become report version 1, which does not provide the customer-visible version history the contract claims.

**Required repair:** Choose one authority for report sequence across a customer's derived-profile lineage—such as owner-level monotonic report version plus `derived_from_report_id`—and define the concurrency/uniqueness rule.

### DR-006 — Generic jobs reuse a report-only error schema

`private.processing_jobs.last_error_details` is declared to use the report-run error shape, whose `stage` is limited to report stages. Photo extraction, taste candidates, preview, notification, and retention failures cannot conform without lying about their stage.

**Required repair:** Define a job-safe discriminated error shape keyed by `job_kind`, or use a bounded general `operation_stage` that covers every job kind without accepting arbitrary provider payloads.

### DR-007 — Physical-retention scans lack their required leading indexes

The contract promises timed cleanup for live sessions, completed jobs, notification deliveries, and outbound events, but their indexes are primarily profile-first. Global due-item scans cannot efficiently use `(profile_id, ended_at/occurred_at)` when no profile is known.

**Required repair:** Add partial/global cleanup indexes led by `ended_at`, `completed_at`, `sent_at/updated_at`, and `occurred_at` as appropriate, with the exact terminal-status predicates used by retention workers.

### DR-008 — State consistency is described but not exact

Several records say timestamps/error fields are “state-consistent” without enumerating the invariant: photos/rejection codes, report runs, generated assets, live sessions, jobs, transfers, and notification deliveries. The contract therefore is not yet migration-exact.

**Required repair:** Add a state-invariant matrix specifying required/forbidden timestamps, error codes, object metadata, and transitions for each bounded lifecycle, and assign enforcement to named database checks versus Zod/application transactions.

### DR-009 — Owner-transfer cascade needs an executable constraint contract

The account-transfer design relies on `on update cascade` across every same-owner composite relationship, including nested report/asset lineage. The contract does not state whether these constraints are deferrable or how the single transaction avoids intermediate ownership violations and multiple cascade paths.

**Required repair:** Define the composite FK constraint mode and the exact private transfer transaction ordering. Require a migration-level transfer test covering a populated draft with photos, extraction, candidates/reactions, generated assets, and a target account with existing active state.

## Checks that passed

- All approved customer inputs and outputs have a named relational or private-object authority.
- Required profile fields use `gender` consistently and include brand-plus-category sizing.
- Anonymous users are real owned identities; bare `anon` receives no customer-data access.
- Public-table grants are explicit and independent from RLS, matching current Supabase exposure behavior.
- Every public record carries `owner_id`; RLS predicates use `auth.uid()` and do not trust user metadata.
- Storage is private, owner-prefixed, immutable, size/type bounded, and excludes sensitive filenames.
- Shopify live facts/images are not cached as database authority.
- Report section JSON is bounded and discriminated rather than raw provider output.
- Worker claim design correctly uses short `skip locked` transactions and performs provider calls after commit.
- No soft-deletion field, generalized audit system, ORM assumption, speculative vector/search store, or customer media bytes were introduced.
- Migration compatibility, explicit grants/RLS, advisor checks, generated types, and two-user isolation tests are correctly required.

## Decision

**Fail and return to `data-contract`.** The schema direction remains sound, but the nine findings above affect exact lifecycle, privacy, retry, or migration behavior and must be repaired before API/auth/integration contracts rely on it. No live database or implementation change is authorized.
