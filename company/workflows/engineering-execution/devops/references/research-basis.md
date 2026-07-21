# DigitalOcean Research Basis

Read this file when revising deployment policy, not during ordinary release tasks.

## Primary DigitalOcean Guidance Applied

- [App specification reference](https://docs.digitalocean.com/products/app-platform/reference/app-spec/): versioned YAML specs, component images/sources, health checks, encrypted variable types/scopes, deployment jobs, domains, and alerts.
- [Clone App Platform apps](https://docs.digitalocean.com/products/app-platform/how-to/clone-app/): separate app instances support development/staging and production, with environment-specific branches, databases, and encrypted variables re-entered.
- [Container image deployments](https://docs.digitalocean.com/products/app-platform/how-to/deploy-from-container-images/): production should use SHA digests rather than mutable tags for consistency.
- [App spec validation and proposal](https://docs.digitalocean.com/reference/doctl/reference/apps/spec/validate/) and [`doctl apps propose`](https://docs.digitalocean.com/reference/doctl/reference/apps/propose/): validate and review specs/costs before applying them.
- [Health and liveness checks](https://docs.digitalocean.com/products/app-platform/how-to/manage-health-checks/): readiness controls traffic and liveness may restart unhealthy services/workers.
- [Deployment jobs](https://docs.digitalocean.com/products/app-platform/how-to/manage-jobs/): bounded PRE_DEPLOY/POST_DEPLOY jobs are supported.
- [Deployment management and rollback](https://docs.digitalocean.com/products/app-platform/how-to/manage-deployments/): inspect deployment history/logs and roll back to a recent successful deployment; rollback does not restore database data.
- [Logs](https://docs.digitalocean.com/products/app-platform/how-to/view-logs/), [alerts](https://docs.digitalocean.com/products/app-platform/how-to/create-alerts/), and [log forwarding](https://docs.digitalocean.com/products/app-platform/how-to/forward-logs/): retain build/deploy/runtime/crash evidence and configure operational notifications/retention deliberately.
- [Domains](https://docs.digitalocean.com/products/app-platform/how-to/manage-domains/): verify starter/custom domains, DNS, and managed certificate behavior.
- [App Platform limits](https://docs.digitalocean.com/products/app-platform/details/limits/): container local storage is ephemeral and unsuitable for durable customer data.

## Project Adaptation

Magic Mirror uses one App Platform app per environment, each containing web, API, and worker components. Development auto-deploys integrated tickets. Production accepts only the QA-approved pinned image digests and remains free of QA fixtures.

## Supabase Guidance Applied

- [Managing environments](https://supabase.com/docs/guides/deployment/managing-environments): use migrations with isolated staging/development and production environments, and serialize remote migration deployment.
- [Supabase Branching](https://supabase.com/docs/guides/deployment/branching): persistent branches provide long-lived isolated development/QA environments with separate credentials and no production data by default.
- [Database migrations](https://supabase.com/docs/guides/deployment/database-migrations): keep remote schema changes in committed migrations, test with reset, compare migration history, and deploy without optional seed data unless explicitly intended.
- [Production checklist](https://supabase.com/docs/guides/deployment/going-into-prod): verify RLS, security, backups, and production configuration before release.
- [Supabase changelog](https://supabase.com/changelog.md): review relevant breaking changes before release, including current Data API exposure behavior.
