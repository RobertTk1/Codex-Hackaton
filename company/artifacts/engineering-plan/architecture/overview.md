# Magic Mirror Technical Architecture

- **Status:** Draft for architecture review
- **Date:** 2026-07-20
- **Workflow step:** `architecture`
- **Implementation status:** No product code exists yet

## Purpose and scope

Magic Mirror is a browser-based virtual styling product. The approved product package describes a report-led journey: anonymous chat-first onboarding, 8–12 favorite-look photos, garment extraction, Love/Hate/Maybe calibration, Google or magic-link account connection, an explainable style report, cross-retailer recommendations, live virtual try-on, voice and gesture controls, a saved bag, and retailer handoff.

The active repository guideline defines a narrower hackathon V1 golden path: one customer photo, one garment, and one near-real-time rendered try-on. This architecture preserves both authorities without silently conflating them:

1. **First integrated slice:** keep the one-photo/one-garment try-on path runnable and independently demoable.
2. **Approved target system:** add the report-led acquisition and styling capabilities as vertical extensions on the same identity, media, job, catalog, and live-session boundaries.
3. **No speculative platform:** do not build a generalized commerce engine, workflow framework, model router, data lake, social product, or Magic Mirror checkout.

## Repository and stack baseline

The repository currently contains approved planning, PRD, UX, copy, mockups, brand assets, and environment-name documentation. It has no application package, source code, migrations, test suite, or deployment configuration.

The implementation layout will follow the repository monorepo convention:

```text
apps/
  web/                  Vite + React + TypeScript + Tailwind browser app
  api/                  Bun + TypeScript HTTP API and worker entrypoints
packages/
  contracts/            Shared Zod schemas and safe domain types
supabase/
  migrations/           Schema, constraints, RLS, and narrowly scoped functions
  seed/                 Synthetic/non-sensitive development fixtures only
```

Managed infrastructure:

- DigitalOcean App Platform: static web component, API web service, and one worker component.
- Supabase: Auth, Postgres, private Storage, and ownership enforcement through RLS.
- OpenAI: text agent, structured report generation, garment extraction support, and approved still-image generation/editing.
- Shopify Global Catalog: live cross-retailer product discovery and retailer links.
- Decart Lucy VTON: realtime virtual try-on.
- Google Gemini Live: live voice and optional consented visual/session context.
- Resend: report-ready email; Supabase custom SMTP uses the same provider for magic links.

## Architectural drivers

- User photos, derived garments, body-related profile fields, and generated likeness images are sensitive.
- Anonymous work must survive Google or magic-link account connection without cross-user exposure.
- Report work can take up to two minutes and must survive browser navigation or process restart.
- Catalog data must remain current; Magic Mirror stores stable references and rationale, not cached Shopify result payloads or product images.
- Permanent OpenAI, Gemini, Decart, Supabase admin, and Resend credentials never reach the browser.
- Direct, voice, and gesture input must converge on one typed live-action contract.
- Every provider call has a timeout, normalized error, retry rule, and visible recovery state.
- The first deployment must be understandable by one hackathon team and recoverable without enterprise infrastructure.

## Chosen architecture

### Web application

Use React with Vite and Tailwind. React is selected because the product has persistent multi-route state, media permissions, streaming video/audio, accessible gesture alternatives, and existing React-based Wardrobe reference code. Route/state modules remain feature-oriented; there is no global state library initially. Server state comes from explicit API/Supabase calls, while transient chat, camera, and interaction state stays local to its feature.

### API and worker

Use Bun's native HTTP runtime for the API and a second entrypoint from the same `apps/api` codebase for durable background work. Route handlers follow the direct pattern: authenticate, Zod-parse, execute one capability, call Supabase/provider, normalize the result. Do not introduce repository classes, an event bus, or a general workflow engine.

The worker leases rows from a small Postgres-backed `processing_jobs` table. This is justified by real two-minute analysis, extraction, preview, notification, and retention work that must survive request termination. One worker is sufficient initially; the claim operation remains atomic so a second worker can be added without redesign.

### Shared contracts

`packages/contracts` contains only schemas used by at least two real boundaries, such as browser/API payloads, provider-normalized results, report structure, errors, and live actions. External data becomes trusted only after Zod parsing.

### Persistence

Supabase Postgres is authoritative for structured state. Private Storage holds original and derived binaries by reference. The model transcript, browser state, provider responses, and Shopify listing payloads are never authoritative product state.

## Dependency justification

| Dependency | Purpose | Why platform/stack alone is insufficient | Impact |
|---|---|---|---|
| React + React DOM | Accessible component and media-session UI | Vite is a build tool, not a UI/runtime state model | Established, maintained; required by chosen frontend |
| React Router | Stable routes, callbacks, resume, and recovery navigation | Hand-written History API routing across the approved route set creates avoidable state bugs | Small, common routing dependency |
| `@supabase/supabase-js` | Auth, user-scoped database/storage access, signed URLs | Reimplementing Supabase protocols is unsafe and unnecessary | Official SDK; required boundary |
| Zod | Runtime validation for every untrusted boundary | TypeScript types disappear at runtime | Small; required by repository rules |
| OpenAI, Gemini, and Decart official SDKs | Typed provider calls and realtime connections | Raw protocol implementations add avoidable auth/streaming risk | Add only in the component that uses each provider; pin versions |
| Vitest + Playwright | Pure-logic and observable golden-path protection | Type checking cannot verify user behavior | Development-only; established tooling |

Do not add an ORM, query cache, global state manager, message broker, analytics SDK, or UI kit until a concrete implementation ticket demonstrates the need.

## System ownership

| Datum or behavior | Authority |
|---|---|
| Identity/session | Supabase Auth |
| Profile, consent, sizes, progress | Supabase Postgres |
| Photo and generated asset bytes | Supabase private Storage |
| Processing lifecycle | Postgres job/report state |
| Report findings and revisions | Postgres structured report records |
| Product price, stock, media, seller, checkout link | Live Shopify Global Catalog response |
| Saved recommendation/bag identity | Stable Shopify references in Postgres, refreshed before display/action |
| Live transformed video | Decart session; not persisted by default |
| Voice session | Gemini Live session; transcript not persisted by default |
| UI transcript and camera preview | Browser memory; never profile authority |

## Current slice versus extensions

| Boundary | First integrated slice | Approved extension |
|---|---|---|
| Entry | Anonymous session and single-photo consent | Landing, chat-first profile, brands/sizes, 8–12 photos, taste calibration |
| Generation | One photo + one garment → rendered try-on | Extraction, report, wardrobe previews, Decart live stream |
| Product source | One permitted demo garment fixture | Live Shopify Global Catalog and current seller handoff |
| Account | Anonymous ownership; permanent auth can follow | Google/magic-link connection and deterministic draft merge |
| Interaction | Direct controls | Gemini voice and local gesture proposals using shared actions |
| Persistence | One owned try-on session and assets | Versioned reports, recommendations, bag, feedback, retention jobs |

## Architecture files

- [Topology](topology.md)
- [Components](components.md)
- [Data architecture](data.md)
- [Critical flows](flows.md)
- [Security and privacy](security.md)
- [Operations and deployment](operations.md)

## Source authority

- `company/artifacts/build-plan/build-plan.md`
- `company/artifacts/prd/prd.md`
- `company/artifacts/prd/user-stories.json`
- `company/artifacts/prd/scenarios.feature`
- `company/artifacts/prd/screens.json`
- `company/artifacts/screen-mockups-v2/conversational-onboarding/`
- `company/artifacts/screen-mockups/`
- `company/build-notes.md`
- `company/artifacts/engineering-plan/implementation-readiness.json`

Provider references are linked in the concern-specific files. Architecture review owns conflict detection; later contract steps own exact request/response schemas and migration-ready field definitions.
