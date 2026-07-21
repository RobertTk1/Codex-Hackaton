import { describe, expect, test } from "vitest";
import { spawn, spawnSync, type ChildProcess } from "node:child_process";
import { createServer } from "node:net";
import { setTimeout as delay } from "node:timers/promises";
import { fileURLToPath } from "node:url";

const repositoryRoot = fileURLToPath(new URL("../../../", import.meta.url));

async function availablePort(): Promise<number> {
  const probe = createServer();

  return await new Promise((resolve, reject) => {
    probe.once("error", reject);
    probe.listen(0, "127.0.0.1", () => {
      const address = probe.address();
      if (address === null || typeof address === "string") {
        probe.close();
        reject(new Error("Unable to allocate an API smoke-test port."));
        return;
      }

      probe.close((error) => {
        if (error) reject(error);
        else resolve(address.port);
      });
    });
  });
}

async function stopProcess(child: ChildProcess): Promise<void> {
  if (child.exitCode !== null) return;

  await new Promise<void>((resolve) => {
    child.once("exit", () => resolve());
    child.kill();
  });
}

describe("API smoke", () => {
  // Given a configured API, when health is requested, then it reports ready.
  test("GET /health returns the documented healthy payload", async () => {
    const port = await availablePort();
    const child = spawn("bun", ["apps/api/src/server.ts"], {
      cwd: repositoryRoot,
      env: {
        ...process.env,
        APP_BASE_URL: "http://127.0.0.1:5173",
        CORS_ALLOWED_ORIGINS: "http://127.0.0.1:5173",
        DECART_API_KEY: "test-decart-key",
        EMAIL_DELIVERY_API_KEY: "test-email-key",
        EMAIL_FROM_ADDRESS: "test@magicmirror.example",
        GEMINI_API_KEY: "test-gemini-key",
        HOST: "127.0.0.1",
        OPENAI_API_KEY: "test-openai-key",
        PORT: String(port),
        SHOPIFY_AGENT_PROFILE_URL: "https://shopify.example/ucp",
        SUPABASE_SERVICE_ROLE_KEY: "test-service-role-key",
        VITE_SUPABASE_PUBLISHABLE_KEY: "test-publishable-key",
        VITE_SUPABASE_URL: "https://project.supabase.co",
      },
      stdio: ["ignore", "pipe", "pipe"],
    });
    let stderr = "";
    child.stderr?.setEncoding("utf8");
    child.stderr?.on("data", (chunk: string) => {
      stderr += chunk;
    });

    try {
      let response: Response | undefined;
      for (let attempt = 0; attempt < 50; attempt += 1) {
        if (child.exitCode !== null) {
          throw new Error(`API exited before health was ready: ${stderr}`);
        }

        try {
          response = await fetch(`http://127.0.0.1:${port}/health`);
          break;
        } catch {
          await delay(50);
        }
      }

      if (response === undefined) throw new Error("API health did not become ready.");

      expect(response.status).toBe(200);
      expect(response.headers.get("X-Request-Id")).toBeTruthy();
      expect(await response.json()).toEqual({
        service: "magic-mirror-api",
        status: "ok",
      });
    } finally {
      await stopProcess(child);
    }
  });

  // Given invalid base configuration, when startup runs, then it names only that variable.
  test("startup with invalid base configuration fails without exposing values", () => {
    const result = spawnSync("bun", ["apps/api/src/server.ts"], {
      cwd: repositoryRoot,
      encoding: "utf8",
      env: {
        APP_BASE_URL: "not-a-url",
        CORS_ALLOWED_ORIGINS: "http://127.0.0.1:5173",
        DECART_API_KEY: "test-decart-key",
        EMAIL_DELIVERY_API_KEY: "test-email-key",
        EMAIL_FROM_ADDRESS: "test@magicmirror.example",
        GEMINI_API_KEY: "test-gemini-key",
        HOST: "127.0.0.1",
        OPENAI_API_KEY: "test-openai-key",
        PATH: process.env.PATH ?? "",
        PORT: "3000",
        SHOPIFY_AGENT_PROFILE_URL: "https://shopify.example/ucp",
        SUPABASE_SERVICE_ROLE_KEY: "test-service-role-key",
        VITE_SUPABASE_PUBLISHABLE_KEY: "test-publishable-key",
        VITE_SUPABASE_URL: "https://project.supabase.co",
      },
    });

    expect(result.status).not.toBe(0);
    expect(result.stderr.trim()).toBe(
      "API startup failed: Invalid server environment variable: APP_BASE_URL.",
    );
    expect(result.stderr).not.toContain("not-a-url");
    expect(result.stderr).not.toContain("test-service-role-key");
  });
});
