import {
  loadServerEnvironment,
  type EnvironmentSource,
  type ServerEnvironment,
} from "./env";
import { createServerOnlySupabaseClient } from "./supabase/clients";
import {
  createDurableWorkerRuntime,
  createSupabaseWorkerJobStore,
  type WorkerHandlerRegistry,
} from "./workers/runtime";

// Feature tickets register handlers here. With no handlers the baseline worker
// stays healthy and idle rather than claiming work it cannot safely complete.
const handlers: WorkerHandlerRegistry = {};

export interface WorkerProcessOptions {
  handlers?: WorkerHandlerRegistry;
  workerId?: string;
}

export async function runWorkerProcess(
  configuration: ServerEnvironment,
  options: WorkerProcessOptions = {},
): Promise<void> {
  const workerId = options.workerId ?? `worker-${crypto.randomUUID()}`;
  const client = createServerOnlySupabaseClient(configuration);
  const runtime = createDurableWorkerRuntime({
    handlers: options.handlers ?? handlers,
    store: createSupabaseWorkerJobStore(client),
    workerId,
  });
  const shutdown = () => runtime.shutdown();

  process.once("SIGINT", shutdown);
  process.once("SIGTERM", shutdown);

  try {
    console.info(JSON.stringify({ event: "worker_started", workerId }));
    await runtime.run();
  } finally {
    process.off("SIGINT", shutdown);
    process.off("SIGTERM", shutdown);
  }
}

export async function runWorkerProcessFromEnvironment(
  source: EnvironmentSource,
  options: WorkerProcessOptions = {},
): Promise<void> {
  await runWorkerProcess(loadServerEnvironment(source), options);
}

if (import.meta.main) {
  try {
    await runWorkerProcessFromEnvironment(Bun.env);
  } catch (error) {
    const message = error instanceof Error ? error.message : "Unknown worker error.";
    console.error(`Worker startup failed: ${message}`);
    process.exitCode = 1;
  }
}
