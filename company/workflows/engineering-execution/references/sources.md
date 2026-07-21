# Source Hierarchy and Progressive Disclosure

Status: final for runtime execution.

## Read Every Turn

- `GOAL.md`
- `tasks.json`
- Tail of `progress.txt`

During Developer, query rather than read `ticket-index.json`. Do not load the complete index or engineering plan to choose work. Run `bun company/workflows/engineering-execution/scripts/ticket-index.mjs check`, use `next` to select, and use `get <ticket-id>` to print only the selected full ticket.

## Authoritative Product and Planning Sources

| Purpose | Path | Authority |
| --- | --- | --- |
| Company framing, audience, journey, boundaries | `company/company.md` | Canonical product context |
| Roadmap, sequencing, decisions, Next | `company/plan.md` | Living roadmap |
| Providers, stack, realtime, Shopify, Wardrobe, trust context | `company/build-notes.md` | Engineering integration context |
| Product contract | `company/artifacts/prd/prd.md` | Approved product scope |
| Stories and acceptance criteria | `company/artifacts/prd/user-stories.json` | Product traceability |
| Observable scenarios | `company/artifacts/prd/scenarios.feature` | BDD authority |
| Screen/state inventory | `company/artifacts/prd/screens.json` | Screen identity and required states |
| Approved build sequence and conflict resolutions | `company/artifacts/build-plan/build-plan.md` | Build-plan authority |
| Detailed engineering tickets | `company/artifacts/engineering-plan/engineering-plan.json` | Authoritative mutable Developer queue |
| Compact engineering selection state | `company/workflows/engineering-execution/ticket-index.json` | Derived cache; never product authority |
| Implementation prerequisites and deferred live checks | `company/artifacts/engineering-plan/implementation-readiness.json` | Readiness authority |
| Architecture | `company/artifacts/engineering-plan/architecture/` | Approved technical direction |
| API, data, auth, state, error, screen-data, and provider contracts | `company/artifacts/engineering-plan/contracts/` | Approved implementation contracts |
| Environment variable names only | `.env.example` | Public configuration-name contract; contains no secret values |

## Approved UX, Copy, Mockups, and Interaction Sources

| Purpose | Path | Runtime rule |
| --- | --- | --- |
| Information architecture, navigation, flows, and structural notes | `company/artifacts/ui-ux-design/` | Structural and responsive authority |
| Exact customer-facing language | `company/artifacts/copy/copy-manifest.json` | Copy authority for canonical screens |
| Product voice | `company/voice.md` | Tone, claims, error, consent, and retailer-language authority |
| Shared canonical visual direction | `company/artifacts/screen-mockups/design-direction.md` | Visual-system authority for canonical screens |
| Canonical interaction specs | `company/artifacts/screen-mockups/interaction-specs/` | Behavior and state authority for active canonical screens |
| Canonical responsive raster mockups | `company/artifacts/screen-mockups/screens/` | Visual comparison inputs named by active tickets |
| Canonical mockup manifest | `company/artifacts/screen-mockups/mockup-manifest.json` | Package registry and historical status |
| Approved chat-first pre-report direction and copy | `company/artifacts/screen-mockups-v2/conversational-onboarding/design-direction.md` and `copy-manifest.json` | Required pre-report presentation/copy |
| Approved chat-first interaction specs | `company/artifacts/screen-mockups-v2/conversational-onboarding/interaction-specs/` | Required pre-report behavior |
| Approved chat-first responsive raster mockups | `company/artifacts/screen-mockups-v2/conversational-onboarding/screens/` | Required pre-report visual comparison inputs |
| Approved chat-first package manifest | `company/artifacts/screen-mockups-v2/conversational-onboarding/mockup-manifest.json` | Eight-screen adopted package registry |

The approved engineering plan's `screenCoverage` object and each selected UI ticket's `resources.design` array determine the active implementation target. Do not recursively implement everything under `screen-mockups/`. The 11 form-based pre-report compositions identified in `screenCoverage.archivedReferenceScreens` are design history only: they are not routes, components, test cases, or similarity targets. The eight conversational-v2 screens replace them. The remaining 37 canonical screens use the canonical interaction-spec and raster paths named by their tickets.

For v2 tickets, also read the v2 shared interaction contract and v2 copy manifest even when a screen-specific interaction file is concise. For canonical tickets, the canonical copy manifest remains authoritative over generated lettering.

## Approved Brand and Design-System Sources

| Purpose | Path | Runtime rule |
| --- | --- | --- |
| Logo usage, variants, and minimum sizes | `company/brand/README.md` | Human-readable logo policy |
| Complete brand direction and typography | `company/brand/brandbook-packet/DESIGN.md` | Brand-system authority |
| Application design-token source | `company/brand/brandbook-packet/tokens/brand-tokens.json` | Authoritative application tokens |
| Derived token CSS | `company/brand/brandbook-packet/tokens/brand-tokens.css` | Generated/derived CSS input |
| Production logo/icon/favicon registry | `company/brand/exports/manifest.json` | Machine-readable asset authority |
| Production logo/icon/favicon files | `company/brand/exports/` | Use these files directly; do not redraw marks |
| Licensed local fonts | `company/brand/brandbook-packet/assets/fonts/` | Instrument Serif and Space Grotesk sources plus licenses |

`company/brand/brand-colors.json` supports the brand export package but does not replace `brand-tokens.json` as the application token authority. ImageGen masters and generated mockup lettering are references, not production logos.

## Stage Authorities

| Stage | Required stage spec | Detailed queue |
| --- | --- | --- |
| Developer | `developer/TASK.md` | Approved `engineering-plan.json`; select through `ticket-index.json` |
| Product QA | `qa/TASK.md` | `company/artifacts/qa/qa-cases.json` generated after the engineering gate |
| DevOps | `devops/TASK.md` | `company/artifacts/devops/release-tasks.json` generated after `PASS FOR DEVOPS` |

## Final Source Priority

1. A newer explicit product decision recorded in `company/plan.md`, the approved build plan, or the approved engineering plan.
2. The approved PRD/build/engineering contract for the selected work.
3. The selected work item's acceptance, pass, and verification contract.
4. The approved UX/copy/interaction/brand artifact for presentation behavior.
5. Current official provider/platform documentation for external capability details.
6. Existing implementation where it does not contradict an approved contract.

Do not resolve a material contradiction silently. Record both sources and block only the affected work until an explicit product decision amends the appropriate authority.

## Runtime Overrides Already Resolved

- The report-led PRD supersedes the older single-photo/single-garment product description while repository engineering and safety rules remain in force.
- Developer and QA use `magic-mirror-dev` plus an isolated development Supabase environment. They never use production Supabase data, Storage, or credentials.
- Developer may create/test deployment assets and deploy to `magic-mirror-dev`; only DevOps mutates `magic-mirror-prod` after QA says `PASS FOR DEVOPS`.
- OpenAI planning is approved, but every OpenAI-dependent ticket must prove a real paid request before it can pass while quota remains unresolved.

## Execution Branch Contract

- Protected base: `main`; never implement directly on it.
- Loop integration: `codex/engineering-execution`.
- Engineering ticket: `codex/<ticket-id-lowercase>-<short-slug>` from the current integration branch, in a dedicated worktree.
- QA evidence: `codex/qa-<candidate-short-sha>` from the frozen candidate; no unreviewed product edits.
- QA repair: `codex/fix-<bug-id>-<short-slug>` through Developer and QA.
- Release record/config: `codex/release-<release-id>` from the QA-approved commit.

Production deploys immutable QA-approved image digests, not a moving branch. Only the root execution agent updates shared plan/index/progress state when explicitly authorized parallel workers exist.

## Generated Runtime Sources

- QA queue/report: `company/artifacts/qa/qa-cases.json`, `runs/`, `defects/`, and `qa-final-report.md`.
- Release queue/environment/reports: `company/artifacts/devops/release-tasks.json`, `environments.json`, `evidence/`, and `releases/`.
- Deployment specs: `deploy/digitalocean/dev.yaml` and `deploy/digitalocean/prod.yaml`.
- Development and release evidence paths are created only by the work item that owns them.
