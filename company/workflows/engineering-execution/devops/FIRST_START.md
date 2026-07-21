# DevOps First Start

Read this before the first release task and whenever the candidate or environment mapping changes.

## 1. Verify the QA Handoff

- Read `company/artifacts/qa/qa-final-report.md` and `qa-cases.json`.
- Confirm the recommendation is `PASS FOR DEVOPS`.
- Record the QA-approved commit, web image digest, API/worker image digest, dev deployment ID, dev URL, migration set, and QA evidence index.
- Confirm no product commit or image changed after QA approval.

## 2. Confirm the Resolved Development/Production Boundary

The approved architecture, engineering plan, and every-turn source rules establish this sequencing:

- Developer deployment tickets provision and verify `magic-mirror-dev`, production-ready specs, image builds, and rollback mechanisms without mutating production.
- QA validates the frozen dev candidate.
- This DevOps task applies production migrations and deploys `magic-mirror-prod`.

If any selected Developer ticket still requires production mutation, treat it as source drift and reconcile the authoritative plan before execution.

## 3. Resolve Environment Isolation

Record, without secret values:

- DigitalOcean project, dev/prod app IDs, regions, starter/custom domains, integration/release sources, and registry repositories.
- Development and production Supabase environment/project refs, Storage buckets, Auth redirect origins, and migration targets.
- Dev sandbox/test and prod provider credential names.
- Alert destinations, log access, and operator/rollback ownership.

The approved architecture prohibits preview/test use of the production Supabase environment. Confirm a persistent data-less development branch or separate development project before Developer auto-deployment is activated.

## 4. Initialize Release Authority

After QA passes, create:

```text
company/artifacts/devops/
  release-tasks.json
  environments.json          # IDs/URLs/names only; no secrets
  releases/
  evidence/
```

Generate the queue using `references/release-queue.md`. Do not create a production deployment merely to initialize the queue.

## 5. Validate Tooling Safely

- Confirm `doctl`, Docker/build tooling, Bun, Git, Supabase CLI, and required CI access exist.
- Confirm DigitalOcean authentication by identity/context without printing the token.
- Validate/propose dev and prod app specs before applying them.
- Confirm the production rollback target exists before the release deployment.
- Confirm production test-data detection can run read-only.

Any missing production authority or destructive ambiguity blocks the relevant task.
