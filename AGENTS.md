# Magic Mirror — Repository Guidelines

**Status:** Hackathon prototype; working title. Magic Mirror is a virtual try-on web platform. The V1 golden path is: a user uploads or captures one photo, selects one garment, and receives a near-real-time rendered image or video of themselves wearing it. Everything else—including stylist recommendations, voice input, multi-garment outfits, and deep reasoning—is roadmap, not V1.

## Zero-to-One Discipline

1. Keep a functioning golden path as the primary deliverable. Experiments are welcome when time-boxed and isolated from that path.
2. Do not create speculative abstractions in integrated code. A helper normally exists only when it has two real call sites in the same change; typed external boundaries such as the generation provider are valid exceptions.
3. Every new dependency needs a one-line justification: purpose, why the platform or existing stack is insufficient, and size/maintenance impact.
4. Keep data flow direct. A route handler, Zod parse, and Supabase call is complete; add no repository pattern, service layer, or event bus without demonstrated need.
5. Commit no dead code, placeholder implementations, or TODO stubs to the integrated product. Temporary experiment branches may contain disposable code while the experiment is active.
6. Simplicity beats sophistication now. Weigh demo speed and quality together; neither “faster” nor “more impressive” decides alone.

## Collaboration Mode

- During ideation (“what do you think?”), give a recommendation and rationale, then wait for a decision; do not start building.
- During execution, implement without re-litigating settled decisions. Challenge assumptions constructively, but the project owner makes the final call.
- Surface materially better implementations and explain why they are better, including tradeoffs and barriers. Do not flood routine work with marginal alternatives; raise options that could change user outcome, risk, delivery time, or future cost.
- Surface risks unprompted, especially render latency/UX and scope that quietly escapes the golden path.
- Keep collaboration low-overhead. Briefly summarize material changes and why they were made; handle small, reversible decisions without lengthy discussion. Do not repeat test output, routine checks, or process formalities unless they reveal a failure or affect a decision. Use full detail only for consequential, hard-to-reverse choices such as the generation provider or user-photo retention policy.

## Planning & User Outcomes

Treat `company/plan.md` as the living source of truth for roadmap, phases, decisions, and next actions. Read it before planning or implementation and update it whenever scope, sequencing, status, or decisions change. Break PRD requirements into small, checkable tasks; every phase and feature must state the user outcome it enables. Keep one clearly marked “Next” section so another session can resume without reconstructing context. Do not mark work complete until its acceptance criteria are met.

Every completed feature handoff—and every PR when one is used—must include three concise sections: **What** changed, **Why** it was needed, and **Expected outcome** for the user or system. Make these concrete enough that another contributor can evaluate whether the implementation achieved its purpose.

When verified work is complete on an active feature branch, commit and push it without waiting for a separate approval. If that branch has an open PR, update its description when scope changes and leave a concise progress comment using the same **What / Why / Expected outcome** structure. Never auto-commit secrets, known-broken work, unrelated user changes, or changes whose destination branch is uncertain.

This is a monorepo. Keep deployable applications under `apps/`, shared packages under `packages/`, Supabase resources under `supabase/`, and repository-wide documentation at the root unless the implemented toolchain establishes a stronger convention.

## Fast Experiments

Experiments are encouraged, including spontaneous collaborator ideas, but must protect the delivery path:

1. State the hypothesis, user value, time box, and cheapest success signal before starting.
2. Run uncertain work in its own branch and worktree. Prefer a thin vertical spike over production polish.
3. Do not block golden-path work unless the experiment addresses a launch-critical risk.
4. At the time-box boundary, adopt, extend, park, or discard it explicitly. Record durable conclusions in `company/plan.md`.
5. Integrate only the smallest proven portion; clean up disposable code when the experiment ends.

## Branches & Worktrees

Never work directly on `main`. Give each active task or experiment one short-lived branch and one dedicated Git worktree so contributors and agents do not edit through the same checkout. Use `feature/<name>`, `fix/<scope>-<desc>`, or `experiment/<hypothesis>`.

- Before starting, check `git status`, active worktrees, and `company/plan.md`; claim a narrowly scoped task and note shared-file risk.
- Keep each worktree focused. Coordinate before editing hotspots such as migrations, lockfiles, root configuration, `AGENTS.md`, or `company/plan.md`.
- Commit small, working checkpoints and integrate frequently. PRs and squash merges are optional; use the fastest review/integration path appropriate to the risk.
- After integration, remove the worktree and delete the merged branch. Never delete a worktree or branch containing uncommitted or unmerged work.
- Rebase or merge from the integration target before handoff when practical, and report unresolved conflicts clearly rather than guessing.

## Collaborator Voices

Store one profile per contributor in `collaborators/<name>-voice.md`. Before substantial planning or implementation, identify the contributor and read their profile. Use the known login only as a clue; if identity is uncertain, ask what name they want used rather than merging profiles. Record demonstrated preferences: communication style, decision process, priorities, working rhythm, and how they want agents to challenge or execute. Do not infer sensitive traits or invent preferences. Update a profile when its contributor explicitly states a durable preference or corrects how the agent should collaborate; keep project requirements in `company/plan.md`, not voice files.

## Dev Commands

```bash
npx create-next-app@latest --typescript --tailwind --app
npm install @supabase/supabase-js zod
npm run dev
npm run typecheck
npm run lint
npm test                    # Vitest unit tests
npm run test:e2e           # Playwright golden-path scenario
supabase start
supabase db push
```

Each environment needs `.env.local` containing the Supabase URL and anon key, a server-only service-role key if required, and the generation-provider key. Never commit secrets. Document required names with placeholders in `.env.example`.

## Data Layer

Use Supabase Postgres, not NoSQL. Users, preferences, garments, try-on sessions, and generated assets are naturally relational and require per-user row-level isolation.

Start minimally:

- `public.preferences`: `user_id` (1:1), sizes, style preferences, color preferences.
- `public.garments`: product metadata and garment asset references.
- `public.tryon_sessions`: `user_id`, `garment_id`, `source_photo_ref`, `status`, `latency_ms`.
- `public.generated_assets`: session ownership and storage-bucket references.

Store binaries in private storage buckets, never inline in Postgres. Add a table only when a real feature needs it, with a migration, row-level security policy, and matching Zod schema.

## Non-negotiable Engineering Rules

1. **No untyped external data.** Parse form input, Supabase reads, API responses, and provider responses through Zod before use.
2. **No silent errors.** Catch and surface failures as `{ error, code, details }`; a render the user is awaiting must never fail invisibly.
3. **No provider call without a timeout and real failure state.** Route all generation calls through one typed helper with timeout and normalized errors. The UI must show explicit loading, slow, and failed states.
4. **Treat user photos as sensitive.** Never log raw bytes, store without a stated retention/deletion plan, or permit cross-user access to photos or sessions.
5. **Use strict TypeScript.** No `@ts-ignore`, `@ts-expect-error`, per-file strictness overrides, or `as Foo` for external data; only Zod parsing creates trusted external types.
6. **No unbounded row or response growth.** Keep assets and session history in their own tables and storage by reference, never accumulating JSON blobs.
7. **No direct commits to `main`.** Use the branch and worktree protocol above. Add an integration branch only when concurrent work actually needs one.
8. **Use Conventional Commits.** Format subjects as `<type>(<scope>): <imperative summary>`.

## Quality — BDD First

Write each user-facing scenario in plain Given/When/Then before implementation. One scenario may begin as a test-file comment; introduce `.feature` tooling only when repeated scenarios justify it. Vitest covers valuable pure logic. Playwright protects the golden path end to end. A golden-path change is not complete without a passing happy-path scenario; experiments need only the cheapest test that validates their hypothesis. Titles describe observable outcomes, not implementation details.

## Lessons Learned Log

Every recurring bug, incident, or bad agent action becomes a permanent numbered rule here—not merely a code fix—because otherwise it tends to recur in another form. Use:

`N. **<No X / Always Y>.** <What it prevents>. Lesson: <what actually happened, YYYY-MM-DD>.`

Continue numbering from the last entry. Never delete entries, even when obvious in hindsight. Whenever the owner corrects a mistake or an incident occurs, add the rule in the same session. This list starts empty and grows only from real incidents.

1. **Keep all company operating context in `company/`.** Store `plan.md`, `company.md`, `activity.md`, `run-log.md`, `workflows/`, `automations/`, and `artifacts/` together so contributors and agents have one canonical workspace. Lesson: the initial setup split `plan.md` at the root and used `magic-mirror/` instead of the owner-requested `company/` folder, 2026-07-17.
2. **Never create application mockups with HTML/CSS, SVG, canvas, or deterministic UI rendering.** Generate browser, favicon, social, device, physical, environmental, apparel, and merchandise mockups with ImageGen as raster assets; browser/favicon families require separate light and dark images. Lesson: deterministic HTML browser and social specimens violated the owner’s required mockup workflow, 2026-07-18.
3. **Always map brandbook pages and standardized application assets to the Mayven reference packet before production.** Layout fidelity and platform recognition are acceptance criteria; a structurally valid packet or polished generic phone screen is not enough. Lesson: Magic Mirror pages drifted into a different editorial system, and the LinkedIn mockup reused the X composition instead of looking like LinkedIn, 2026-07-18.
4. **Always show paired light and dark icon treatments in Twitter/X brand mockups.** One profile uses the approved dark/primary icon on a light avatar surface; the other reverses to a light/high-contrast icon on a dark brand surface. Lesson: the corrected X mockup still repeated the same Acid-on-Ink avatar treatment on both phones, 2026-07-18.
5. **Never use zsh's special `path` variable for task loops.** Use a task-specific name such as `artifact_path` so command lookup remains intact. Lesson: a validation loop assigned to `path` and made `git` unavailable in that shell process, 2026-07-18.

## Brand & Naming

“Magic Mirror” is a working title. Do not invest in brand polish or visual identity until the golden path works.
