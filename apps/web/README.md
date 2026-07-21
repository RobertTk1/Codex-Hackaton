# Magic Mirror web application

This package owns the browser application shell. Product routes and screens are added only by their engineering tickets.

## Commands

```bash
bun run dev
bun run typecheck
bun run build
```

## Dependency justification

- `react` and `react-dom`: approved component and media-session state model; Vite does not provide a UI runtime; maintained runtime dependencies.
- `react-router-dom`: stable browser history and future callback/resume route ownership; hand-written History API routing would duplicate established behavior; maintained runtime dependency.
- `vite` and `@vitejs/plugin-react`: approved development/build pipeline and React transform; Bun alone does not provide the selected browser bundler/plugin behavior; development-only tooling.
- `tailwindcss` and `@tailwindcss/vite`: approved utility styling compiler and direct Vite integration; browser CSS has no equivalent token-aware build step; development-only tooling.
- `@types/react` and `@types/react-dom`: strict TypeScript declarations for the React runtime packages; TypeScript does not bundle them; development-only declarations.
