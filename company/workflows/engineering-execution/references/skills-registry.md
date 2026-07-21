# Verified Skill Registry

Status: verified 2026-07-21. Skill availability must be rechecked at execution time because global/plugin paths can change.

## Installed and Available

| Skill ID | Current verified `SKILL.md` | Used for |
| --- | --- | --- |
| `supabase:supabase` | `/Users/talishawhite/.codex/plugins/cache/openai-curated-remote/supabase/1.0.0/skills/supabase/SKILL.md` | Supabase schema, Auth, Storage, RLS, migrations, operations |
| `supabase:supabase-postgres-best-practices` | `/Users/talishawhite/.codex/plugins/cache/openai-curated-remote/supabase/1.0.0/skills/supabase-postgres-best-practices/SKILL.md` | Postgres review and optimization |
| `frontend-design` | `/Users/talishawhite/.codex/skills/frontend-design/SKILL.md` | Production frontend implementation |
| `imagegen` | `/Users/talishawhite/.codex/skills/.system/imagegen/SKILL.md` | Raster image generation/editing |
| `imagegen-frontend-web` | `/Users/talishawhite/.codex/skills/imagegen-frontend-web/SKILL.md` | Frontend visual asset direction |
| `mayven-taste` | `/Users/talishawhite/.codex/skills/mayven-taste/SKILL.md` | Magic Mirror/Mayven product-design judgment |
| `qa` | `/Users/talishawhite/gstack/.agents/skills/gstack-qa/SKILL.md` | Systematic integrated QA |
| `qa-only` | `/Users/talishawhite/gstack/.agents/skills/gstack-qa-only/SKILL.md` | Report-only QA |
| `design-review` | `/Users/talishawhite/gstack/.agents/skills/gstack-design-review/SKILL.md` | Visual implementation review |
| `investigate` | `/Users/talishawhite/gstack/.agents/skills/gstack-investigate/SKILL.md` | Root-cause diagnosis |
| `cso` | `/Users/talishawhite/gstack/.agents/skills/gstack-cso/SKILL.md` | Security review |
| `review` | `/Users/talishawhite/gstack/.agents/skills/gstack-review/SKILL.md` | Pre-integration code review |
| `benchmark` | `/Users/talishawhite/gstack/.agents/skills/gstack-benchmark/SKILL.md` | Performance measurement |
| `browser:control-in-app-browser` | `/Users/talishawhite/.codex/plugins/cache/openai-bundled/browser/26.715.31251/skills/control-in-app-browser/SKILL.md` | Customer-facing Browser execution |
| `setup-deploy` | `/Users/talishawhite/gstack/.agents/skills/gstack-setup-deploy/SKILL.md` | Deployment configuration setup/review |
| `land-and-deploy` | `/Users/talishawhite/gstack/.agents/skills/gstack-land-and-deploy/SKILL.md` | Controlled land/deploy sequencing |
| `canary` | `/Users/talishawhite/gstack/.agents/skills/gstack-canary/SKILL.md` | Post-deploy observation |
| `document-release` | `/Users/talishawhite/gstack/.agents/skills/gstack-document-release/SKILL.md` | Release documentation |

Use the exact lowercase Browser skill ID shown above. The former `Browser:control-in-app-browser` spelling is invalid.

## Installable but Not Installed

| Skill ID | Source | Installation |
| --- | --- | --- |
| `micro-interactions` | `https://github.com/dylantarre/animation-principles`, file `skills/01-by-domain/micro-interactions/SKILL.md` | `npx skills add https://github.com/dylantarre/animation-principles --skill micro-interactions -g -y` |

The repository and named skill file were verified on 2026-07-21. Until installed and visible in the runtime skill catalog, motion review uses the written `developer/references/motion.md` contract and records `skill-not-installed`; it must not claim the skill ran.

## Validation Rule

Before invoking a skill:

1. Confirm its exact ID appears in the current runtime skill catalog.
2. Read its complete `SKILL.md`.
3. Follow its instructions only where they do not conflict with this approved workflow and selected ticket.
4. If an installed skill disappears or an installable source is unavailable, record a tooling blocker or use the written stage contract when it fully defines the required behavior.

`doctl`, Docker, Bun, Git, and Supabase CLI are tools, not skills. Their availability is verified through the selected ticket or release-task preflight.
