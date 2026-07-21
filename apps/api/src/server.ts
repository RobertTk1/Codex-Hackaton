import { loadServerEnvironment, type ServerEnvironment } from "./env";

export const HEALTH_PAYLOAD = {
  service: "magic-mirror-api",
  status: "ok",
} as const;

function requestContext(
  request: Request,
  config: ServerEnvironment,
): { headers: Headers; requestId: string } {
  const requestId = crypto.randomUUID();
  const headers = new Headers({
    "X-Request-Id": requestId,
  });
  const origin = request.headers.get("Origin");

  if (origin !== null && config.CORS_ALLOWED_ORIGINS.includes(origin)) {
    headers.set("Access-Control-Allow-Origin", origin);
    headers.set("Vary", "Origin");
  }

  return { headers, requestId };
}

export function startApiServer(config: ServerEnvironment): Bun.Server<undefined> {
  return Bun.serve({
    hostname: config.HOST,
    port: config.PORT,
    fetch(request) {
      const url = new URL(request.url);
      const { headers, requestId } = requestContext(request, config);

      if (
        request.method === "GET" &&
        (url.pathname === "/health" || url.pathname === "/healthz")
      ) {
        return Response.json(HEALTH_PAYLOAD, { headers, status: 200 });
      }

      return Response.json(
        {
          code: "NOT_FOUND",
          details: null,
          error: "Route not found.",
          requestId,
        },
        { headers, status: 404 },
      );
    },
  });
}

if (import.meta.main) {
  try {
    const config = loadServerEnvironment(Bun.env);
    const server = startApiServer(config);

    console.info(
      JSON.stringify({
        event: "api_started",
        hostname: server.hostname,
        port: server.port,
      }),
    );
  } catch (error) {
    const message = error instanceof Error ? error.message : "Unknown startup error.";

    console.error(`API startup failed: ${message}`);
    process.exit(1);
  }
}
