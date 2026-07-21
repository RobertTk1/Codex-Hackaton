# Developer Skill Routing

Use a skill only when the selected ticket matches it. Read that skill's full `SKILL.md` before acting and follow its progressive references.

Availability and exact installed/source paths are authoritative in `../../references/skills-registry.md`.

## Installed Skills to Route

| Ticket need | Skill |
| --- | --- |
| Supabase schema, Auth, Storage, RLS, migrations, or operations | `supabase:supabase` and, when relevant, `supabase:supabase-postgres-best-practices` |
| Production-grade frontend implementation | `frontend-design` |
| Frontend visual asset generation/direction | `imagegen` and `imagegen-frontend-web` |
| Magic Mirror/Mayven-aligned product design judgment | `mayven-taste` |
| Systematic browser QA or report-only browser QA | `qa` or `qa-only` |
| Visual implementation review | `design-review` |
| Systematic root-cause debugging | `investigate` |
| Security-sensitive review | `cso` |
| Pre-integration code review | `review` |
| Performance regression or target measurement | `benchmark` |
| Deployment setup and final land/deploy workflow | defer to the DevOps task and its approved deployment skills |

## Legacy Builder Capabilities to Recreate or Replace

The original MVP Builder referenced capabilities that are not automatically assumed installed here:

- Design-system validator.
- Screen-similarity checker with adjusted production-asset masks.
- Automated ticket manual-check/browser verification.
- Vite/runtime console and network debugger.
- Project initializer adapted to Bun/Vite/Tailwind/Supabase.

Use `../../references/skills-registry.md` to determine whether each capability is satisfied by an installed skill/tool, a written contract, or a verified installable source. Do not reference a nonexistent skill as if it ran.

## Motion Skill Candidate

`micro-interactions` is verified installable from `https://github.com/dylantarre/animation-principles` but is not currently installed. Installation and the exact source path are recorded in `../../references/skills-registry.md`.
