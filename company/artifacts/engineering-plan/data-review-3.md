# Data Contract Review — Founder Closure

- **Decision:** Passed by explicit founder approval
- **Approved:** 2026-07-20
- **Reviewed contract:** `company/artifacts/engineering-plan/contracts/data.md`
- **Next step:** `application-contracts`
- **Implementation status:** Not started

## Basis for closure

The data contract completed two formal review rounds, repaired all 13 recorded findings, and passed targeted structural validation after each repair:

- DR-001 through DR-009 resolved evidence/output mutation, report retry/versioning, derived-data retention, likeness-consent lineage, job errors, cleanup indexes, exact lifecycle invariants, and executable owner transfer.
- DR-010 through DR-013 resolved transfer-safe Storage authorization, fail-closed logical expiry, mandatory photo deadlines, and database-enforced account-deletion blocking.
- The final contract contains 17 public customer-owned records, five private operational records, and three private buckets with explicit ownership, grants/RLS, lifecycle, index, retention, deletion, and migration rules.
- Current official Supabase Storage-policy, operation-aware helper, metadata-backed RLS, Auth-session/sign-out, and managed-schema guidance informed the final repair.
- Automated checks passed for required repair text, stale contradiction removal, record counts, balanced Markdown fences, local links, planning JSON, secrets, and whitespace.

After this evidence, Talisha White explicitly directed the workflow to stop additional document-only data reviews and move forward. This closes the planning checkpoint without claiming that SQL migrations or live policies have already been tested.

## Implementation gates preserved

The future data implementation tickets must still prove the contract against real local migrations before they can pass, including:

- two-user, anonymous-user, bare-key, old-token, and account-block isolation;
- anonymous-to-existing-account transfer with unchanged object paths across all three buckets;
- logical expiry and delayed physical-purge behavior for rows, objects, and signed URLs;
- non-null photo deadlines and no revival after expiry;
- account deletion with refresh-session revocation, old-JWT denial, retrying purge, exact-path cleanup, and bounded completion evidence;
- report retry/versioning, job concurrency/idempotency, cleanup indexes, and populated owner-transfer constraints;
- Supabase security/performance advisors, generated TypeScript types, and migration reset/replay.

These are engineering pass conditions, not unresolved planning decisions. Any failed implementation proof must repair the migration or contract before the affected ticket can pass.

## Decision

**Pass and advance to `application-contracts`.** The data contract is sufficiently exact for downstream API, auth, integration, state, and screen/data design. Founder approval closes the review loop while preserving all migration-level verification requirements.
