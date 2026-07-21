# Per-Ticket Development Deployment

Every passing engineering ticket must be integrated and deployed to the shared `magic-mirror-dev` DigitalOcean App Platform application before `passes: true` is recorded.

## First Deployable Baseline

The empty repository cannot deploy before the workspace, health-serving web/API shells, containers, and dev app specification exist. The exact dependency-safe bootstrap sequence is:

`ENG-001`, `ENG-002`, `ENG-003`, `ENG-004`, `ENG-005`, `ENG-006`, `ENG-008`, `ENG-013`, `ENG-014`, `ENG-024`, `ENG-039`, `ENG-043`, `ENG-046`, `ENG-152`, `ENG-153`, `ENG-154`, then `ENG-155`.

The ticket-index generator blocks every non-bootstrap ticket until `ENG-155` is completed and passing.

- Only the named prerequisite tickets may record `dev_deployment: bootstrap-deferred` while passing their local gates.
- The bootstrap deployment task must deploy the exact accumulated commits and verify every deferred ticket's relevant behavior before any ordinary feature ticket begins.
- After that task passes, the exception closes permanently and every subsequent engineering ticket follows the per-ticket deployment procedure.
- If the bootstrap dependency graph changes, update the authoritative plan and the generator's bootstrap set together, regenerate the index, and treat disagreement as a source-integrity failure.

## Preconditions

- The ticket implementation and local verification pass.
- The ticket commit is reviewed and integrated into the approved integration branch.
- No other deployment writer is active.
- The dev app ID/URL and deployment mechanism are recorded.
- Dev uses a persistent Supabase development branch or separate development project plus sandbox/test provider configuration, never the production main environment, data, or secrets.

## Procedure

1. Record the integrated commit SHA.
2. Push/trigger the approved dev deployment.
3. Wait for App Platform to report a live deployment; do not assume push equals deploy.
4. Verify the deployment reports the integrated commit/image and expected component set.
5. Run `/healthz`, `/readyz`, worker heartbeat, and ticket-specific dev smoke checks.
6. Inspect relevant build/deploy/runtime logs and browser console/network behavior.
7. Record dev app/deployment ID, URL, commit/images, commands, results, and evidence in ticket notes.

If the deployment or smoke fails, keep the engineering ticket `passes: false`. Repair under the same ticket lineage or record a blocker. Do not deploy the ticket to production.

## Parallel Tickets

The parent integrates passing worker commits one at a time in dependency-safe order. After each integration, it waits for that commit's dev deployment and smoke result before marking that ticket passing or integrating the next worker result.

## Deployment Configuration Changes

Tickets that change Dockerfiles, App Platform specs, migrations, health checks, secrets/configuration names, or runtime commands also run the applicable validator and a dev rollback rehearsal. Record only secret names/presence, never values.
