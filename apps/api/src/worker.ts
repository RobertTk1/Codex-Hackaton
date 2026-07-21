import { loadServerEnvironment, type ServerEnvironment } from "./env";
import { createServerOnlySupabaseClient } from "./supabase/clients";
import {
  createDurableWorkerRuntime,
  createSupabaseWorkerJobStore,
  type WorkerHandlerRegistry,
} from "./workers/runtime";

// Feature tickets register handlers here. With no handlers the baseline worker
// stays healthy and idle rather than claiming work it cannot safely complete.
const handlers: WorkerHandlerRegistry = {};

export async function runWorkerProcess(configuration: ServerEnvironment): Promise<void> {
  const workerId = `worker-${crypto.randomUUID()}`;
  const client = createServerOnlySupabaseClient(configuration);
  const runtime = createDurableWorkerRuntime({
    handlers,
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

if (import.meta.main) {
  try {
    await runWorkerProcess(loadServerEnvironment(Bun.env));
  } catch (error) {
    const message = error instanceof Error ? error.message : "Unknown worker error.";
    console.error(`Worker startup failed: ${message}`);
    process.exitCode = 1;
  }
}
