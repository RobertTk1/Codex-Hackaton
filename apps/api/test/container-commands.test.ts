import { spawn, spawnSync, type ChildProcess } from "node:child_process";
import { createServer } from "node:net";
import { setTimeout as delay } from "node:timers/promises";

import { afterAll, beforeAll, describe, expect, test } from "vitest";
import { z } from "zod";

const IMAGE = "magic-mirror-api:test";
const OWNER_ID = "11111111-1111-4111-8111-111111111111";
const statusSchema = z.strictObject({
  ANON_KEY: z.string().min(1),
  API_URL: z.url(),
  DB_URL: z.url(),
  GRAPHQL_URL: z.url(),
  JWT_SECRET: z.string().min(1),
  PUBLISHABLE_KEY: z.string().min(1),
  REST_URL: z.url(),
  SECRET_KEY: z.string().min(1),
  SERVICE_ROLE_KEY: z.string().min(1),
});

type LocalStatus = z.infer<typeof statusSchema>;

const secretSentinels = {
  DECART_API_KEY: "container-decart-secret-sentinel",
  EMAIL_DELIVERY_API_KEY: "container-email-secret-sentinel",
  GEMINI_API_KEY: "container-gemini-secret-sentinel",
  OPENAI_API_KEY: "container-openai-secret-sentinel",
};

function docker(args: string[], options: { input?: string } = {}) {
  return spawnSync("docker", args, {
    encoding: "utf8",
    input: options.input,
  });
}

function expectCommandSucceeded(
  result: ReturnType<typeof docker>,
  label: string,
): void {
  if (result.status !== 0) {
    throw new Error(`${label} failed: ${result.stderr.trim()}`);
  }
}

function localStatus(): LocalStatus {
  const result = spawnSync("supabase", ["status", "-o", "json"], {
    encoding: "utf8",
  });
  if (result.status !== 0) throw new Error("Local Supabase is not running.");
  return statusSchema.parse(JSON.parse(result.stdout));
}

function databaseContainer(): string {
  const result = docker([
    "ps",
    "--filter",
    "label=com.supabase.cli.project=magic-mirror-local",
    "--filter",
    "name=supabase_db_",
    "--format",
    "{{.Names}}",
  ]);
  expectCommandSucceeded(result, "Supabase database discovery");
  return z
    .string()
    .regex(/^supabase_db_[a-z0-9_-]+$/)
    .parse(result.stdout.trim());
}

function databaseSql(container: string, sql: string): string {
  const result = docker(
    ["exec", "-i", container, "psql", "-U", "postgres", "-d", "postgres", "-Atq"],
    { input: sql },
  );
  expectCommandSucceeded(result, "Local fixture query");
  return result.stdout.trim();
}

function environmentArgs(
  status: LocalStatus,
  options: { includeServiceKey?: boolean } = {},
) {
  const containerUrl = status.API_URL.replace("127.0.0.1", "host.docker.internal");
  const values: Record<string, string> = {
    APP_BASE_URL: "http://127.0.0.1:5173",
    CORS_ALLOWED_ORIGINS: "http://127.0.0.1:5173",
    ...secretSentinels,
    EMAIL_FROM_ADDRESS: "container@magicmirror.example",
    HOST: "0.0.0.0",
    PORT: "3000",
    SHOPIFY_AGENT_PROFILE_URL: "https://shopify.example/ucp",
    VITE_SUPABASE_PUBLISHABLE_KEY: status.PUBLISHABLE_KEY,
    VITE_SUPABASE_URL: containerUrl,
  };
  if (options.includeServiceKey ?? true) {
    values.SUPABASE_SERVICE_ROLE_KEY = status.SERVICE_ROLE_KEY;
  }
  return Object.entries(values).flatMap(([key, value]) => [
    "--env",
    `${key}=${value}`,
  ]);
}

async function availablePort(): Promise<number> {
  const probe = createServer();
  return await new Promise((resolve, reject) => {
    probe.once("error", reject);
    probe.listen(0, "127.0.0.1", () => {
      const address = probe.address();
      if (address === null || typeof address === "string") {
        probe.close();
        reject(new Error("Unable to allocate a container test port."));
        return;
      }
      probe.close((error) => (error ? reject(error) : resolve(address.port)));
    });
  });
}

async function waitFor(
  condition: () => boolean | Promise<boolean>,
  child: ChildProcess,
  diagnostics: () => string,
  timeoutMs = 15_000,
): Promise<void> {
  const deadline = Date.now() + timeoutMs;
  while (!(await condition())) {
    if (child.exitCode !== null) {
      throw new Error(`Container exited early (${child.exitCode}): ${diagnostics()}`);
    }
    if (Date.now() >= deadline) throw new Error(`Timed out: ${diagnostics()}`);
    await delay(100);
  }
}

async function stopContainer(name: string, child: ChildProcess): Promise<void> {
  if (child.exitCode === null) docker(["stop", "--time", "3", name]);
  if (child.exitCode === null) {
    await Promise.race([
      new Promise<void>((resolve) => child.once("exit", () => resolve())),
      delay(5_000).then(() => undefined),
    ]);
  }
}

describe.sequential("production API and worker container", () => {
  let status: LocalStatus;

  beforeAll(() => {
    const image = docker(["image", "inspect", IMAGE]);
    expectCommandSucceeded(image, `Required image ${IMAGE}`);
    status = localStatus();
  });

  afterAll(() => {
    docker(["ps", "-aq", "--filter", "name=magic-mirror-eng153-"])
      .stdout.trim()
      .split("\n")
      .filter(Boolean)
      .forEach((container) => docker(["rm", "-f", container]));
  });

  test("the non-root API command becomes healthy", async () => {
    const port = await availablePort();
    const name = `magic-mirror-eng153-api-${crypto.randomUUID()}`;
    const child = spawn(
      "docker",
      [
        "run",
        "--rm",
        "--name",
        name,
        "--add-host",
        "host.docker.internal:host-gateway",
        "--publish",
        `127.0.0.1:${port}:3000`,
        ...environmentArgs(status),
        IMAGE,
      ],
      { stdio: ["ignore", "pipe", "pipe"] },
    );
    let output = "";
    child.stdout?.on("data", (chunk: Buffer) => (output += chunk.toString("utf8")));
    child.stderr?.on("data", (chunk: Buffer) => (output += chunk.toString("utf8")));

    try {
      let response: Response | undefined;
      await waitFor(
        async () => {
          try {
            response = await fetch(`http://127.0.0.1:${port}/healthz`);
            return response.ok;
          } catch {
            return false;
          }
        },
        child,
        () => output,
      );
      expect(await response?.json()).toEqual({
        service: "magic-mirror-api",
        status: "ok",
      });

      const inspection = docker(["inspect", name, "--format", "{{.Config.User}}"]);
      expectCommandSucceeded(inspection, "API container user inspection");
      expect(inspection.stdout.trim()).toBe("bun");
    } finally {
      await stopContainer(name, child);
    }
  });

  test("the bundled worker claims and completes one real local fixture job", async () => {
    const jobId = crypto.randomUUID();
    const profileId = crypto.randomUUID();
    const subjectId = crypto.randomUUID();
    const workerId = `container-fixture-${crypto.randomUUID()}`;
    const dbContainer = databaseContainer();
    const name = `magic-mirror-eng153-worker-${crypto.randomUUID()}`;
    const sql = `
      insert into private.processing_jobs (
        id, owner_id, profile_id, kind, subject_id, idempotency_key, priority
      ) values (
        '${jobId}', '${OWNER_ID}', '${profileId}', 'retention_purge', '${subjectId}',
        'container-fixture:${jobId}', 0
      );
    `;
    databaseSql(dbContainer, sql);
    const fixture =
      `import { runWorkerProcessFromEnvironment } from "file:///app/worker.js";` +
      `await runWorkerProcessFromEnvironment(Bun.env, {` +
      `handlers: { retention_purge: async () => {} },` +
      `workerId: ${JSON.stringify(workerId)},` +
      `});`;
    const child = spawn(
      "docker",
      [
        "run",
        "--rm",
        "--name",
        name,
        "--add-host",
        "host.docker.internal:host-gateway",
        ...environmentArgs(status),
        IMAGE,
        "bun",
        "-e",
        fixture,
      ],
      { stdio: ["ignore", "pipe", "pipe"] },
    );
    let output = "";
    child.stdout?.on("data", (chunk: Buffer) => (output += chunk.toString("utf8")));
    child.stderr?.on("data", (chunk: Buffer) => (output += chunk.toString("utf8")));

    try {
      await waitFor(
        () =>
          databaseSql(
            dbContainer,
            `select status from private.processing_jobs where id = '${jobId}';`,
          ) === "succeeded" && output.includes('"event":"job_completed"'),
        child,
        () => output,
      );
      expect(output).toContain('"event":"worker_started"');
      expect(output).toContain('"event":"job_completed"');
      expect(output).not.toContain(OWNER_ID);
      expect(output).not.toContain(profileId);
      expect(output).not.toContain(subjectId);
    } finally {
      await stopContainer(name, child);
      databaseSql(
        dbContainer,
        `delete from private.processing_jobs where id = '${jobId}';`,
      );
    }
  });

  test.each([
    ["API", []],
    ["worker", ["bun", "worker.js"]],
  ])(
    "the %s command rejects missing server configuration without leaking values",
    (_label, command) => {
      const result = docker([
        "run",
        "--rm",
        ...environmentArgs(status, { includeServiceKey: false }),
        IMAGE,
        ...command,
      ]);
      expect(result.status).not.toBe(0);
      expect(result.stderr).toContain(
        "Missing required server environment variable: SUPABASE_SERVICE_ROLE_KEY.",
      );
      Object.values(secretSentinels).forEach((sentinel) => {
        expect(result.stdout + result.stderr).not.toContain(sentinel);
      });
    },
  );
});
