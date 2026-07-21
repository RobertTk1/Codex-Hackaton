import { describe, expect, test } from "bun:test";

import {
  HEALTH_PAYLOAD,
  startApiServer,
} from "../apps/api/src/server";

describe("API scaffold", () => {
  // Given a configured API, when health is requested, then it reports ready.
  test("GET /health returns the documented healthy payload", async () => {
    const server = startApiServer({
      APP_BASE_URL: "http://127.0.0.1:5173",
      CORS_ALLOWED_ORIGINS: ["http://127.0.0.1:5173"],
      HOST: "127.0.0.1",
      PORT: 0,
    });

    try {
      const response = await fetch(new URL("/health", server.url));

      expect(response.status).toBe(200);
      expect(response.headers.get("X-Request-Id")).toBeTruthy();
      expect(await response.json()).toEqual(HEALTH_PAYLOAD);
    } finally {
      await server.stop(true);
    }
  });

  // Given missing base configuration, when startup runs, then it fails visibly.
  test("startup without required base configuration fails visibly", async () => {
    const process = Bun.spawn(
      [Bun.which("bun") ?? "bun", "apps/api/src/server.ts"],
      {
        cwd: import.meta.dir + "/..",
        env: {
          APP_BASE_URL: "",
          CORS_ALLOWED_ORIGINS: "",
          PATH: Bun.env.PATH ?? "",
        },
        stderr: "pipe",
        stdout: "pipe",
      },
    );
    const [exitCode, stderr] = await Promise.all([
      process.exited,
      new Response(process.stderr).text(),
    ]);

    expect(exitCode).not.toBe(0);
    expect(stderr).toContain("API startup failed");
    expect(stderr).toContain("APP_BASE_URL");
    expect(stderr).toContain("CORS_ALLOWED_ORIGINS");
  });
});
