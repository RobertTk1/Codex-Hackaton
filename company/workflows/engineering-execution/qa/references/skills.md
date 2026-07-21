# QA Skill and Tool Routing

Read each selected skill's full `SKILL.md` before acting.

Availability and exact installed/source paths are authoritative in `../../references/skills-registry.md`.

| QA need | Route |
| --- | --- |
| Customer-facing journey execution and screenshots | `browser:control-in-app-browser` — mandatory for end-to-end cases |
| Systematic integrated web QA | `qa` |
| Report-only independent QA review | `qa-only` |
| Visual consistency and implementation review | `design-review` |
| Root-cause investigation after a reproducible failure | `investigate` — diagnosis support only; repair remains a Developer task |
| Security-sensitive QA planning/review | `cso` |
| Performance regression measurement | `benchmark` |
| Supabase auth, RLS, database, or Storage verification | `supabase:supabase` and `supabase:supabase-postgres-best-practices` when applicable |

## Browser Requirement

Use the in-app Browser rather than Stagehand or a separate automation service for the required Browser case. The Browser skill governs connection and supported interaction/inspection methods at execution time. Use additional real-device evidence where the Browser cannot reproduce hardware permissions or realtime resource behavior.

## Missing Capabilities

If a QA case requires deterministic fault injection, accessibility scanning, structured log querying, screen recording, or provider sandbox control that the installed tools cannot perform, record a testability blocker and decide whether to add a small project harness or a global skill. Do not claim the capability ran when it did not.
