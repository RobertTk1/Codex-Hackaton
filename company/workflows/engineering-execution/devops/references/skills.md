# DevOps Skill and Tool Routing

Read a selected skill's full `SKILL.md` before execution.

Availability and exact installed/source paths are authoritative in `../../references/skills-registry.md`.

| Need | Route |
| --- | --- |
| DigitalOcean App Platform API/spec/deployment | official `doctl` and DigitalOcean documentation; create a project-specific skill only if repeated automation warrants it |
| Deployment configuration review | `setup-deploy`, adapted to the workflow files rather than CLAUDE.md |
| Controlled merge/deploy sequencing | `land-and-deploy`, adapted to the QA-approved immutable-candidate gate |
| Post-deploy observation | `canary` |
| Production Browser smoke | `browser:control-in-app-browser` |
| Security/secrets/config review | `cso` |
| Performance regression | `benchmark` |
| Supabase migration/database review | `supabase:supabase` and `supabase:supabase-postgres-best-practices` |
| Release documentation | `document-release` |

Existing generic deploy skills do not natively encode Magic Mirror's DigitalOcean two-app topology, pinned image promotion, separate Supabase projects, or zero-test-data production rule. Treat this DevOps contract as authoritative and do not execute a generic skill's merge or live-deploy step when it conflicts.

No task may claim a DigitalOcean-specific skill or automation ran unless it actually exists and returned verifiable app/deployment data.
