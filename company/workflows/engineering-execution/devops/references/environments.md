# Development and Production Environments

## Separate Boundaries

Maintain two DigitalOcean App Platform apps:

- `magic-mirror-dev`: integration branch, automatic deployment permitted, persistent Supabase development branch or separate development project, sandbox/test providers, synthetic or explicitly consented fixtures.
- `magic-mirror-prod`: controlled release, immutable image digests, production Supabase, production providers, real customer data only.

Use separate app IDs, domains, Supabase environment/project refs, Storage, Auth allowlists, service-role credentials, provider keys when supported, email modes/from addresses, CORS origins, and logging/alert labels.

## App Platform Components

Each app follows the approved topology:

- `web`: web container serving the built Vite app.
- `api`: Bun TypeScript HTTP service.
- `worker`: the same API image digest using the worker command.
- bounded pre/post-deploy jobs only when the approved release process requires them.

Do not use App Platform container filesystems for persistent user data. Supabase owns durable data and private assets.

## Development Deployment

Every passing engineering ticket is integrated and deployed to dev under `developer/references/development-deployment.md`. Dev deployment failure keeps that ticket non-passing.

## Production Boundary

- `deploy_on_push` is disabled for production components or otherwise guarded so ordinary pushes cannot release.
- The production spec names pinned image digests, not mutable tags.
- Production does not consume the integration branch directly.
- Only DevOps may apply production spec/source changes after QA approval.
- The live deployment must report the expected app ID, deployment ID, component digests, and release identifier.

## Region

Use the approved App Platform region closest to the production Supabase and intended users, then record it. Region changes are release changes and must be reviewed; do not rely on `nearest available` for a reproducible production spec.
