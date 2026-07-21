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

COPY apps/web apps/web

RUN bun run build:web

FROM nginxinc/nginx-unprivileged:1.29.8-alpine3.23@sha256:0c79d56aee561a1d81c63f00eee5fb5fe29279560cdc55e91425133104c7fbe6 AS runtime

COPY --chown=101:101 --from=build /workspace/apps/web/dist/ /usr/share/nginx/html/
COPY --chown=101:101 apps/web/docker-entrypoint.d/40-runtime-config.sh /docker-entrypoint.d/40-runtime-config.sh
COPY --chown=101:101 apps/web/nginx.conf /etc/nginx/conf.d/default.conf

RUN chmod 0555 /docker-entrypoint.d/40-runtime-config.sh \
  && chmod 0444 /etc/nginx/conf.d/default.conf

USER 101:101

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD ["wget", "--quiet", "--spider", "http://127.0.0.1:8080/healthz"]

CMD ["nginx", "-g", "daemon off;"]
