# Magic Mirror web application

This package owns the browser application shell and ticket-scoped product routes and screens.

## Commands

```bash
bun run dev
bun run typecheck
bun run build
```

## Production container

The web image builds without application configuration and serves the static bundle as user `101` on port `8080`. At startup it requires `VITE_API_BASE_URL`, `VITE_SUPABASE_URL`, and `VITE_SUPABASE_PUBLISHABLE_KEY`, then atomically writes those public values to `runtime-config.js`. Server-only variables are neither accepted as Docker build arguments nor written to browser assets.

```bash
docker build -f apps/web/Dockerfile -t magic-mirror-web:test .
docker run --rm -p 8080:8080 \
  -e VITE_API_BASE_URL=http://localhost:3000 \
  -e VITE_SUPABASE_URL=https://example.supabase.co \
  -e VITE_SUPABASE_PUBLISHABLE_KEY=example-public-key \
  magic-mirror-web:test
```

## Dependency justification

- `react` and `react-dom`: approved component and media-session state model; Vite does not provide a UI runtime; maintained runtime dependencies.
- `react-router-dom`: stable browser history and future callback/resume route ownership; hand-written History API routing would duplicate established behavior; maintained runtime dependency.
- `lucide-react`: consistent accessible navigation, process, and disclosure icons required by the approved screen; the browser platform has no equivalent coherent icon set; small tree-shaken maintained runtime dependency.
- `vite` and `@vitejs/plugin-react`: approved development/build pipeline and React transform; Bun alone does not provide the selected browser bundler/plugin behavior; development-only tooling.
- `tailwindcss` and `@tailwindcss/vite`: approved utility styling compiler and direct Vite integration; browser CSS has no equivalent token-aware build step; development-only tooling.
- `@types/react` and `@types/react-dom`: strict TypeScript declarations for the React runtime packages; TypeScript does not bundle them; development-only declarations.

The production image adds no application dependency. It uses pinned Bun and NGINX Unprivileged Alpine images: Bun performs the existing Vite build, while NGINX provides a small nonroot static runtime and health endpoint.
