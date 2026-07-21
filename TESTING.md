# Testing Magic Mirror

Install the pinned workspace dependencies with `bun install`. Before the first
browser run on a machine or CI image, install the pinned Chromium build with:

```bash
bun run playwright:install
```

## Stable root commands

```bash
bun run test
bun run test:e2e
bun run check
```

Vitest has separate `repository`, `api`, and `web` projects. The root unit
command runs every project, including the smoke files for both applications.
Playwright starts the local Vite server declared in `playwright.config.ts`.

## Focus one exact file

Pass a repository-relative file after `--`:

```bash
bun run test -- apps/api/test/smoke.test.ts
bun run test -- apps/web/test/smoke.test.ts
bun run test:e2e -- apps/web/e2e/smoke.spec.ts
```

To focus a named Playwright test inside a file:

```bash
bun run test:e2e -- apps/web/e2e/smoke.spec.ts --grep "local web application"
```

## Local Supabase policy tests

Docker and the Supabase CLI are required. The harness is local-only and does
not link to or mutate a hosted project.

```bash
bun run db:start
bun run db:reset
bun run test:db
```

`db:reset` rebuilds the isolated local database and applies the data-only
synthetic Auth seed. `test:db` runs the passing pgTAP policy harness, then runs
an intentionally permissive policy fixture and succeeds only when pgTAP rejects
the resulting cross-owner leak.

## Dependency rationale

- `vitest`: provides project-aware unit/integration execution, file filters,
  watch mode, and reliable failure exit codes that TypeScript and Bun workspace
  commands do not provide; development-only with no production-bundle impact,
  mature, and pinned at the root.
- `@playwright/test`: provides observable Chromium behavior, automatic local
  server lifecycle, resilient locators, traces, and screenshots that unit tests
  cannot provide; development-only with no production-bundle impact, mature,
  and pinned at the root. Its comparatively large browser binary lives in the
  developer or CI cache rather than the repository.
