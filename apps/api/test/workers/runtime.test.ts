import { spawn } from "node:child_process";
import { once } from "node:events";
import { fileURLToPath } from "node:url";

import { describe, expect, test, vi } from "vitest";

import {
  createDurableWorkerRuntime,
  type ClaimedProcessingJob,
  type ProcessingJobKind,
  type WorkerFailure,
  type WorkerJobStore,
  type WorkerLogRecord,
} from "../../src/workers/runtime";

const apiRoot = fileURLToPath(new URL("../../", import.meta.url));
const now = "2026-07-21T20:40:00.000Z";
const payloadSentinel = "private-payload-must-not-be-logged";

function claimedJob(
  overrides: Partial<ClaimedProcessingJob> = {},
): ClaimedProcessingJob {
  return {
    attempt_count: 1,
    available_at: now,
    completed_at: null,
    created_at: now,
    id: "10000000-0000-4000-8000-000000000001",
    idempotency_key: payloadSentinel,
    kind: "photo_extraction",
    last_error_code: null,
    last_error_details: null,
    lease_expires_at: "2026-07-21T20:42:00.000Z",
    leased_at: now,
    max_attempts: 2,
    owner_id: "10000000-0000-4000-8000-000000000002",
    priority: 100,
    profile_id: "10000000-0000-4000-8000-000000000003",
    status: "leased",
    subject_id: "10000000-0000-4000-8000-000000000004",
    updated_at: now,
    worker_id: "worker-a",
    ...overrides,
  };
}

interface MemoryStoreOptions {
  jobs?: ClaimedProcessingJob[];
  renewLease?: boolean;
}

function memoryStore(options: MemoryStoreOptions = {}) {
  const jobs = [...(options.jobs ?? [])];
  const claims: Array<{ kind: ProcessingJobKind; workerId: string }> = [];
  const completed: string[] = [];
  const heartbeats: string[] = [];
  const releases: Array<{ failure: WorkerFailure; jobId: string }> = [];

  const store: WorkerJobStore = {
    async claim(kind, workerId) {
      claims.push({ kind, workerId });
      const index = jobs.findIndex((job) => job.kind === kind);
      if (index === -1) return null;
      const [job] = jobs.splice(index, 1);
      return job ?? null;
    },
    async complete(jobId) {
      completed.push(jobId);
      return true;
    },
    async heartbeat(jobId) {
      heartbeats.push(jobId);
      return options.renewLease ?? true;
    },
    async release(jobId, _workerId, failure) {
      releases.push({ failure, jobId });
      return true;
    },
  };

  return { claims, completed, heartbeats, jobs, releases, store };
}

async function waitFor(
  predicate: () => boolean,
  timeoutMs = 1_000,
): Promise<void> {
  const deadline = Date.now() + timeoutMs;
  while (!predicate()) {
    if (Date.now() >= deadline) throw new Error("Timed out waiting for condition.");
    await new Promise((resolve) => setTimeout(resolve, 5));
  }
}

describe("durable worker runtime", () => {
  // Given one due job and two workers, when both poll concurrently, then the store's
  // atomic claim is consumed once and only one registered handler completes it.
  test("one due job is claimed and completed by one worker", async () => {
    const memory = memoryStore({ jobs: [claimedJob()] });
    const handledBy: string[] = [];
    const createWorker = (workerId: string) =>
      createDurableWorkerRuntime({
        handlers: {
          photo_extraction: async () => {
            handledBy.push(workerId);
          },
        },
        logger: vi.fn(),
        store: memory.store,
        workerId,
      });

    const results = await Promise.all([
      createWorker("worker-a").runOnce(),
      createWorker("worker-b").runOnce(),
    ]);

    expect(results.map((result) => result.status).sort()).toEqual([
      "completed",
      "idle",
    ]);
    expect(handledBy).toHaveLength(1);
    expect(memory.completed).toEqual(["10000000-0000-4000-8000-000000000001"]);
  });

  test("a long running handler heartbeats its active lease", async () => {
    const memory = memoryStore({ jobs: [claimedJob()] });
    const runtime = createDurableWorkerRuntime({
      handlers: {
        photo_extraction: async () => {
          await new Promise((resolve) => setTimeout(resolve, 45));
        },
      },
      heartbeatIntervalMs: 10,
      leaseSeconds: 1,
      logger: vi.fn(),
      store: memory.store,
      workerId: "worker-a",
    });

    await expect(runtime.runOnce()).resolves.toEqual({
      jobId: "10000000-0000-4000-8000-000000000001",
      status: "completed",
    });
    expect(memory.heartbeats.length).toBeGreaterThanOrEqual(2);
  });

  test("an unregistered job type is released as safe retryable work without payload logging", async () => {
    const memory = memoryStore({ jobs: [claimedJob()] });
    const logs: WorkerLogRecord[] = [];
    const runtime = createDurableWorkerRuntime({
      claimKinds: ["photo_extraction"],
      handlers: {},
      logger: (record) => logs.push(record),
      store: memory.store,
      workerId: "worker-a",
    });

    await expect(runtime.runOnce()).resolves.toMatchObject({ status: "released" });
    expect(memory.releases).toHaveLength(1);
    expect(memory.releases[0]?.failure).toEqual({
      code: "WORKER_HANDLER_UNAVAILABLE",
      details: {
        customer_message_key: "processing_temporarily_unavailable",
        job_kind: "photo_extraction",
        operation_stage: "decode",
        retryable: true,
      },
    });
    expect(JSON.stringify(logs)).not.toContain(payloadSentinel);
    expect(JSON.stringify(logs)).not.toContain("owner_id");
  });

  test("shutdown aborts the active handler and releases a safe retryable state", async () => {
    const memory = memoryStore({ jobs: [claimedJob()] });
    let handlerStarted = false;
    const logs: WorkerLogRecord[] = [];
    const runtime = createDurableWorkerRuntime({
      handlers: {
        photo_extraction: async (_job, context) => {
          handlerStarted = true;
          await new Promise((_resolve, reject) => {
            context.signal.addEventListener(
              "abort",
              () => reject(context.signal.reason),
              { once: true },
            );
          });
        },
      },
      logger: (record) => logs.push(record),
      store: memory.store,
      workerId: "worker-a",
    });
    const result = runtime.runOnce();
    await waitFor(() => handlerStarted);

    runtime.shutdown();

    await expect(result).resolves.toMatchObject({ status: "released" });
    expect(memory.releases[0]?.failure).toMatchObject({
      code: "WORKER_SHUTDOWN",
      details: { retryable: true },
    });
    expect(JSON.stringify(logs)).not.toContain(payloadSentinel);
  });

  test("lease loss aborts work without overwriting a lease owned elsewhere", async () => {
    const memory = memoryStore({ jobs: [claimedJob()], renewLease: false });
    const runtime = createDurableWorkerRuntime({
      handlers: {
        photo_extraction: async (_job, context) => {
          await new Promise((_resolve, reject) => {
            context.signal.addEventListener(
              "abort",
              () => reject(context.signal.reason),
              { once: true },
            );
          });
        },
      },
      heartbeatIntervalMs: 10,
      leaseSeconds: 1,
      logger: vi.fn(),
      store: memory.store,
      workerId: "worker-a",
    });

    await expect(runtime.runOnce()).resolves.toEqual({ status: "lease_lost" });
    expect(memory.releases).toHaveLength(0);
    expect(memory.completed).toHaveLength(0);
  });

  test("the worker entrypoint exits cleanly on SIGTERM without contacting Supabase", async () => {
    const workerProcess = spawn("bun", ["src/worker.ts"], {
      cwd: apiRoot,
      env: {
        PATH: process.env.PATH,
        APP_BASE_URL: "https://example.test",
        CORS_ALLOWED_ORIGINS: "https://example.test",
        DECART_API_KEY: "synthetic-decart-key",
        EMAIL_DELIVERY_API_KEY: "synthetic-email-key",
        EMAIL_FROM_ADDRESS: "hello@example.test",
        GEMINI_API_KEY: "synthetic-gemini-key",
        HOST: "127.0.0.1",
        OPENAI_API_KEY: "synthetic-openai-key",
        PORT: "3101",
        SHOPIFY_AGENT_PROFILE_URL: "https://example.test/agent-profile",
        SUPABASE_SERVICE_ROLE_KEY: "synthetic-server-key",
        VITE_SUPABASE_PUBLISHABLE_KEY: "synthetic-publishable-key",
        VITE_SUPABASE_URL: "https://project.supabase.co",
      },
      stdio: ["ignore", "pipe", "pipe"],
    });
    let stdout = "";
    let stderr = "";
    workerProcess.stdout.on("data", (chunk: Buffer) => {
      stdout += chunk.toString("utf8");
    });
    workerProcess.stderr.on("data", (chunk: Buffer) => {
      stderr += chunk.toString("utf8");
    });
    await waitFor(() => stdout.includes("worker_started"));

    expect(workerProcess.kill("SIGTERM")).toBe(true);
    const [exitCode, signal] = await once(workerProcess, "exit");

    expect(exitCode).toBe(0);
    expect(signal).toBeNull();
    expect(stderr).toBe("");
  });
});
