# Engineering Context and Readiness Discovery

- **Status:** Completed; ready for architecture under the recorded OpenAI funding assumption
- **Date:** 2026-07-20
- **Current workflow step:** Completed; next is `architecture`
- **Implementation started:** No

## Hackathon delivery constraint

The Devpost Hackathons connector identified the registered event as **OpenAI Build Week** and confirmed that submissions close **Tuesday, July 21, 2026 at 5:00 PM Pacific / 8:00 PM Eastern**. The latest host announcement explicitly corrects an earlier Monday reference: Tuesday is the authoritative deadline.

The submission requires a working project built using Codex and GPT-5.6, one category, a project description, a public YouTube demo under three minutes with narration covering the product plus Codex/GPT-5.6 use, a code-repository URL, a README with setup/sample-data/run guidance and Codex/GPT-5.6 documentation, and the primary build task's `/feedback` session ID. Magic Mirror most naturally fits `Apps for Your Life`. Judging covers technological implementation, design, potential impact, and quality of the idea.

The connected Devpost account has two unnamed OpenAI Build Week drafts (`1345164` and `1343745`). The founder chose to create or use a different Magic Mirror entry, so neither draft will be mutated. Country, team-member invitations, and the final project reference remain submission-administration follow-ups.

The founder approved DigitalOcean App Platform for production and hosting under the `General Intelligence Agency` team, authorized app creation during deployment, requested a DigitalOcean-provided domain with a `magicmirror` prefix, and selected encrypted environment variables for deployed secrets. Exact application components and API runtime belong to the architecture step.

## Approved authority

Talisha White approved the amended build plan and authorized the checkpointed engineering-plan workflow on 2026-07-19. The approved product authority is PRD v1.1.0, 23 user stories, 15 BDD scenarios, the 48-record screen inventory, the approved UX/copy package, and chat-first v2 for pre-report implementation. Form-based v1 pre-report comps are archived reference.

## Repository baseline

- Current branch: `experiment/conversational-onboarding-v2`; the canonical checkout is not on `main`.
- The worktree contains intentional uncommitted product/design artifacts and the founder-requested deletion of tracked `AGENTS.md`; this planning step does not restore, stage, commit, merge, or discard them.
- There is no product implementation to preserve: no `package.json`, Bun lockfile, Vite config, TypeScript config, application source, test suite, Supabase config, or deployment config exists.
- A tracked `.env.example`, gitignored `.env.local`, and root `.gitignore` now define the local/deployed environment boundary without storing credential values. Browser-safe Supabase configuration is separated from the server-only service-role key and provider credentials.
- The root README is only a repository title and `.codex/environments/environment.toml` has no setup script.
- The approved monorepo convention remains available for future implementation: deployable applications under `apps/`, shared packages under `packages/`, Supabase resources under `supabase/`, and repository-wide documentation at the root.

## Resolved engineering constraints

- Frontend: TypeScript, Vite, Tailwind, and Bun.
- API layer: TypeScript.
- Database, authentication, and private asset storage: Supabase.
- Text agent, report generation, and still-image generation/editing: OpenAI.
- Live voice and optional disclosed visual/session context: Google Gemini Live.
- Realtime virtual try-on: Decart Lucy VTON.
- Cross-retailer discovery and current product/checkout links: Shopify Global Catalog.
- Pre-report garment extraction: Wardrobe-inspired extraction between validated photo upload and dynamic taste calibration, with partial-success preservation and a direct style-signal fallback.
- Release one remains report-led; Decart and Gemini/Decart/gesture feasibility run early without blocking the first report release.

## Architecture-shaping provider evidence

- Supabase anonymous sign-ins create authenticated users, support later identity linking, require RLS awareness of the `is_anonymous` claim, and leave existing-account data-conflict behavior to the application. Automatic anonymous-user cleanup is not provided. Source: [Supabase anonymous sign-ins](https://supabase.com/docs/guides/auth/auth-anonymous).
- Current Supabase platform guidance uses publishable keys in browser clients; the service-role credential remains server-only. Current platform changes also mean future migrations must grant Data API access intentionally rather than assuming every new table is automatically exposed.
- Gemini recommends short-lived ephemeral tokens for client-to-server Live API connections. Audio-plus-video sessions have a short default duration, so the planned spike must test session management and structured state versus sampled visual context. Sources: [Gemini ephemeral tokens](https://ai.google.dev/gemini-api/docs/live-api/ephemeral-tokens) and [Live API capabilities](https://ai.google.dev/gemini-api/docs/live-api/capabilities).
- Decart requires permanent credentials to stay server-side and documents ten-minute client tokens for browser realtime sessions. Source: [Decart realtime virtual try-on](https://docs.platform.decart.ai/models/realtime/virtual-try-on).
- Shopify Global Catalog is the correct cross-retailer discovery boundary and returns current multi-merchant offers and seller checkout links. A hosted agent profile is required, while product-image reuse outside the listing remains unresolved. Source: [Shopify Global Catalog](https://shopify.dev/docs/agents/catalog/global-catalog).

## Reconciled source labels

- Marked the founder-amended build plan approved for engineering planning.
- Updated the living plan from PRD v1.0.0 to v1.1.0 and recorded the current checkpointed workflow.
- Marked the adopted information architecture, chat-first interaction contract, and v2 design direction approved.
- No product behavior, visual asset, or implementation code was added in these consistency edits.

## Founder-input reconciliation

The completed founder form resolves the internal freezes, DigitalOcean product/access/secret store, Resend and sender domain, Gemini Live access, Decart Lucy VTON access, retention/deletion policy, purpose-specific consent, report-governance risk acceptance, taste-calibration policy, support matrix, gesture guardrails, retailer attribution, generated-preview quality policy, and anonymous-account merge behavior.

After explicit confirmation of the **$10 monthly** cost, the Supabase connector created `magic-mirror` (`vhpxxmefcuewkmukissr`) in the `General Intelligence Agency` organization and `us-east-1`. The project reached `ACTIVE_HEALTHY`. Its URL and active modern publishable key are stored only in gitignored `.env.local`; the service-role key remains server-only and is not recorded in tracked files.

Google sign-in is now configured through the dedicated `magic-mirror-buildweek` Google Cloud project. The external OAuth app is in production, the Supabase callback is registered, the provider and manual identity linking are enabled, and public Auth settings confirm Google, email, and anonymous sign-ins. Local Auth URLs use `http://localhost:5173`; the eventual DigitalOcean hostname remains a deployment-ticket update rather than a readiness blocker.

Magic-link delivery is configured through Supabase custom SMTP using Resend, verified domain `thecrownlist.com`, and sender `Magic Mirror <magicmirror@thecrownlist.com>`. The domain-scoped send-only credential is held by Supabase. A credential exposed in diagnostic output during setup was immediately rotated and revoked; the replacement is active. A test request returned HTTP 200, Supabase Auth logged `user_confirmation_requested` without an error, and Talisha White confirmed successful inbox delivery.

The gitignored local environment contains the required OpenAI credential, and the key can list available GPT-5.6 and OpenAI image models. A minimal Responses API request currently fails with HTTP 429 `insufficient_quota`. Talisha White explicitly directed planning to proceed on the assumption that credits will be added later. This closes the planning decision but does not falsify the failed check: OpenAI-dependent tickets must reverify a paid request before implementation and cannot pass without usable quota.

Shopify's current official Global Catalog contract is keyless. A live `search_catalog` request from the intended development environment succeeded using Shopify's documented validation profile. Hosting Magic Mirror's production UCP agent profile is therefore future application/deployment work and will be ticketed; it is no longer misclassified as missing external access.

The private test-data prerequisite is ready. Talisha White provided and explicitly authorized eight founder-owned images for Magic Mirror hackathon testing, authorized synthetic fixtures, and approved storage outside Git at `/Users/talishawhite/Documents/Magic Mirror Test Data/`. This is a one-participant real baseline; broader synthetic representation checks supplement it and cannot be used to claim population-wide performance.

The Shopify product-image rights question is resolved as an explicit founder risk acceptance for this hackathon. It is not documentary permission, must not be represented as permission, and remains a visible engineering-ticket risk rather than a readiness blocker.

## Readiness result

`implementation-readiness.json` is the authoritative machine-readable checklist. Every item is now `ready` with non-secret evidence. The founder-directed OpenAI funding assumption remains explicitly distinguished from runtime verification and becomes a mandatory precondition on every OpenAI-dependent ticket. The workflow may advance to architecture. Provider spikes, schemas, migrations, infrastructure configuration, and product code remain future engineering tickets.
