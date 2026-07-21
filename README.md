# Magic Mirror

Magic Mirror is organized as a private Bun monorepo. Install the pinned workspace from the repository root:

```bash
bun install --frozen-lockfile
bun run check
```

Deployable applications live under `apps/`; shared packages live under `packages/`. Literal workspace entries must point to an existing package, while the approved `apps/*` and `packages/*` bootstrap globs may be empty until their owning engineering tickets scaffold them.

## Root development dependencies

- `typescript`: strict static checking for all workspace TypeScript; Bun executes TypeScript but does not replace compile-time validation; pinned, development-only compiler.
- `@types/bun`: Bun runtime and test-runner declarations required by root TypeScript checks; no equivalent declarations are built into TypeScript; development-only types package.
