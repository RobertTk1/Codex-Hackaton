# syntax=docker/dockerfile:1

FROM oven/bun:1.3.11-alpine@sha256:7ed9f74c326d1c260abe247ac423ccbf5ac92af62bb442d515d1f92f21e8ea9b AS build

WORKDIR /workspace

COPY package.json bun.lock tsconfig.json ./
COPY scripts/validate-workspaces.ts scripts/validate-workspaces.ts
COPY apps/api/package.json apps/api/package.json
COPY apps/web/package.json apps/web/package.json
COPY packages/contracts/package.json packages/contracts/package.json

RUN bun install --frozen-lockfile --ignore-scripts \
  && bun scripts/validate-workspaces.ts

COPY apps/api apps/api
COPY packages/contracts packages/contracts

RUN bun run build:api \
  && bun run build:worker

FROM oven/bun:1.3.11-alpine@sha256:7ed9f74c326d1c260abe247ac423ccbf5ac92af62bb442d515d1f92f21e8ea9b AS runtime

WORKDIR /app

ENV NODE_ENV=production

COPY --chown=bun:bun --from=build /workspace/apps/api/dist/server.js ./server.js
COPY --chown=bun:bun --from=build /workspace/apps/api/dist/worker.js ./worker.js

USER bun

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD ["bun", "-e", "const response = await fetch(`http://127.0.0.1:${process.env.PORT ?? '3000'}/healthz`); if (!response.ok) process.exit(1);"]

CMD ["bun", "server.js"]
