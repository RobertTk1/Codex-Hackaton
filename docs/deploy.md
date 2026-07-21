# DigitalOcean deployment boundary

Magic Mirror uses one DigitalOcean App Platform app per environment. `magic-mirror-dev` is the Developer integration and QA-candidate app. `magic-mirror-prod` is reserved for the DevOps stage after the QA release gate passes. Developer tooling is intentionally hard-coded to the development app and provides no production deployment command.

## Component topology

Both app-spec templates contain exactly three components:

- `magic-mirror-web`: the pinned `magic-mirror-web` DOCR digest serving the Vite bundle through its tested unprivileged Nginx runtime;
- `magic-mirror-api`: the pinned `magic-mirror-api` DOCR digest running `bun server.js`, with `/healthz` gating rollout;
- `magic-mirror-worker`: the same pinned digest running `bun worker.js`.

The DigitalOcean-provided hostname is environment-specific because each app has a unique name. The API is routed under `/api`; the web component owns `/`. Both images are immutable, independently pinned digests. App Platform never reads a Git branch directly, so deployment does not depend on a DigitalOcean GitHub OAuth installation and cannot deploy on push.

## Secret and data isolation

The committed YAML files are templates. They contain environment-specific variable references, never credential values. DigitalOcean receives rendered development values only through an ignored `.env.digitalocean.dev.local` file and stores credential fields as encrypted `SECRET` variables. Do not commit that file or a rendered app spec.

Development must use a persistent Supabase development branch or separate development project. It must never use project `vhpxxmefcuewkmukissr`, its data, Storage objects, or credentials. Provider values may be sandbox/test credentials only. A not-yet-configured integration must use an explicitly non-deliverable development value and cannot be represented as working. Production references use the `MAGIC_MIRROR_PROD_` prefix and are never read by Developer tooling.

Required development names are documented in `.env.example`. `DIGITALOCEAN_ACCESS_TOKEN` is needed only for the formal rollback API; load it from the existing secure `doctl` context or another local secret store without printing it.

## Validate and deploy development

```bash
bun run validate:deploy
bun run deploy:dev -- apply
bun run deploy:dev -- status
```

`apply` validates both templates, renders only `dev.yaml` to a mode-0600 temporary file, asks DigitalOcean to validate it, and then creates or updates only `magic-mirror-dev`. It waits for an active deployment and verifies the web root, API `/healthz`, and API `/readyz`. Record the app ID, deployment ID, default hostname, image digest, integrated commit, and worker evidence without recording secret values.

## Development rollback rehearsal

Choose a prior `ACTIVE` development deployment and run:

```bash
bun run deploy:dev -- rollback <development-deployment-id>
```

The command validates the target through DigitalOcean's rollback API, performs the rollback, waits for the new deployment, reruns the health/readiness checks, and commits the rollback so future deployments resume. It never runs a database command: application rollback and database recovery are separate operations. After recording rollback evidence, reapply the current integrated development spec and confirm it is healthy.

## Production boundary

`deploy/digitalocean/prod.yaml` exists so environment separation and immutable production image references can be reviewed before release. Developer must not render or apply it, create `magic-mirror-prod`, alter a production deployment, or run production migrations. DevOps owns production promotion, database-forward migration decisions, smoke checks, monitoring, and rollback after QA approval.
