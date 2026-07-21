# DevOps References

Read `../TASK.md` every release session. Read only the references named by the selected release task.

| File | Purpose |
| --- | --- |
| `requirements.md` | QA handoff and per-task prerequisites |
| `release-queue.md` | authoritative release task queue and ordering |
| `environments.md` | development/production isolation and ownership |
| `app-platform.md` | DigitalOcean App Platform component/spec rules |
| `build-and-promotion.md` | reproducible images and exact candidate promotion |
| `secrets-and-config.md` | encrypted variables and configuration validation |
| `database-and-production-data.md` | migration, backup, and zero-test-data rules |
| `health-observability.md` | readiness, liveness, worker, logs, and alerts |
| `production-deployment.md` | controlled release procedure |
| `smoke-and-monitoring.md` | non-mutating production smoke and observation |
| `rollback.md` | code/config rollback and database recovery boundary |
| `release-record.md` | completion evidence and operational handoff |
| `skills.md` | approved deployment skill routing |
| `research-basis.md` | primary DigitalOcean sources used to revise policy |

The Founder Skills DevOps instructions are a reference, not a runtime dependency. This version preserves QA gating, build verification, concrete deployment IDs/URLs, smoke testing, rollback, and handoff while replacing obsolete Convex, Resend, S3-Git, npm, arbitrary pass-rate, and client-transfer assumptions.
