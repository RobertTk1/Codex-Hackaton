# DigitalOcean App Platform Contract

## Version-Controlled Specs

Maintain environment-specific specs at the approved repository paths, defaulting to:

```text
deploy/digitalocean/dev.yaml
deploy/digitalocean/prod.yaml
```

Specs define app/component names, region, image/source, commands, routing, health checks, jobs, domains, non-secret variables, variable names/scopes, and alerts. Secret plaintext is never committed.

Before applying a spec:

1. Validate its schema with `doctl apps spec validate`.
2. Propose it against the target app with `doctl apps propose --app <id> --spec <path>`.
3. Compare the proposed/live spec and cost impact.
4. Confirm target app ID and environment.
5. Apply only after the selected release task authorizes mutation.

An App Platform update submits a complete spec. Always download/inspect the live spec before replacing it so unrelated dashboard configuration is not erased.

## Components

- `web` uses the approved web image and health endpoint.
- `api` uses the API image, explicit run command, HTTP port, `/healthz` readiness/liveness configuration, and `/readyz` release verification.
- `worker` uses the same API image digest with the worker command, explicit instance count, liveness/heartbeat verification, and no public route.
- Jobs are bounded deployment actions, not the durable application queue.

## Source and Image Policy

- Dev may track the integration branch with automatic redeploy.
- Production uses SHA image digests from the QA-approved candidate.
- Do not use `latest` or mutable release tags in production.
- Record the digest actually reported by the live deployment.

## Domains and TLS

- Verify the DigitalOcean starter domain first.
- Add the approved custom domain and exact Supabase/Google redirect origins without wildcards.
- Verify DNS, HTTPS, certificate validity, redirect/canonical behavior, and minimum TLS policy named by the approved spec.
- DNS propagation is not proof of application health.

## Alerts and Logs

Configure at least deployment-failed and deployment-live notifications plus component CPU, memory, and restart alerts appropriate to the chosen plan. Verify build, deploy, runtime, and crash-log access. Configure external log forwarding when retention requirements exceed App Platform's native runtime-log availability.
