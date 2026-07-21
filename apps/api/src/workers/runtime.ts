import { z } from "zod";

import type { ServerOnlySupabaseClient } from "../supabase/clients";

const DATABASE_OPERATION_TIMEOUT_MS = 10_000;

export const PROCESSING_JOB_KINDS = [
  "photo_extraction",
  "taste_candidates",
  "report_generation",
  "wardrobe_preview",
  "report_notification",
  "retention_purge",
] as const;

export const processingJobKindSchema = z.enum(PROCESSING_JOB_KINDS);
export type ProcessingJobKind = z.infer<typeof processingJobKindSchema>;

const processingJobStatusSchema = z.enum([
  "queued",
  "leased",
  "retry_wait",
  "succeeded",
  "failed",
  "cancelled",
]);

const processingJobSchema = z.strictObject({
  attempt_count: z.number().int().min(0).max(3),
  available_at: z.iso.datetime({ offset: true }),
  completed_at: z.iso.datetime({ offset: true }).nullable(),
  created_at: z.iso.datetime({ offset: true }),
  id: z.uuid(),
  idempotency_key: z.string().trim().min(1).max(512),
  kind: processingJobKindSchema,
  last_error_code: z.string().trim().min(1).max(80).nullable(),
  last_error_details: z.record(z.string(), z.unknown()).nullable(),
  lease_expires_at: z.iso.datetime({ offset: true }).nullable(),
  leased_at: z.iso.datetime({ offset: true }).nullable(),
  max_attempts: z.number().int().min(1).max(3),
  owner_id: z.uuid(),
  priority: z.number().int().min(0).max(1_000),
  profile_id: z.uuid(),
  status: processingJobStatusSchema,
  subject_id: z.uuid(),
  updated_at: z.iso.datetime({ offset: true }),
  worker_id: z.string().trim().min(1).max(120).nullable(),
});

const claimedProcessingJobSchema = processingJobSchema
  .extend({
    completed_at: z.null(),
    last_error_code: z.null(),
    last_error_details: z.null(),
    lease_expires_at: z.iso.datetime({ offset: true }),
    leased_at: z.iso.datetime({ offset: true }),
    status: z.literal("leased"),
    worker_id: z.string().trim().min(1).max(120),
  })
  .superRefine((job, context) => {
    if (job.attempt_count < 1) {
      context.addIssue({
        code: "custom",
        message: "A claimed job must have at least one attempt.",
        path: ["attempt_count"],
      });
    }

    if (Date.parse(job.lease_expires_at) <= Date.parse(job.leased_at)) {
      context.addIssue({
        code: "custom",
        message: "A claimed job lease must expire after it starts.",
        path: ["lease_expires_at"],
      });
    }
  });

export type ClaimedProcessingJob = z.infer<typeof claimedProcessingJobSchema>;

const operationStages = {
  photo_extraction: ["decode", "analysis", "cutout", "persist"],
  report_generation: [
    "profile_analysis",
    "catalog_matching",
    "report_writing",
    "finalizing",
  ],
  report_notification: ["resolve_recipient", "send"],
  retention_purge: ["enumerate", "delete_object", "delete_rows", "reconcile"],
  taste_candidates: ["seed", "balance", "persist"],
  wardrobe_preview: ["source_prepare", "generate", "quality_check", "persist"],
} as const satisfies Record<ProcessingJobKind, readonly string[]>;

const defaultOperationStage = {
  photo_extraction: "decode",
  report_generation: "profile_analysis",
  report_notification: "resolve_recipient",
  retention_purge: "enumerate",
  taste_candidates: "seed",
  wardrobe_preview: "source_prepare",
} as const satisfies Record<ProcessingJobKind, string>;

const workerFailureSchema = z
  .strictObject({
    code: z.string().trim().min(1).max(80),
    details: z.strictObject({
      customer_message_key: z.string().trim().min(1).max(120),
      job_kind: processingJobKindSchema,
      operation_stage: z.string().trim().min(1).max(80),
      retryable: z.boolean(),
    }),
  })
  .superRefine((failure, context) => {
    const allowedStages: readonly string[] = operationStages[failure.details.job_kind];
    if (!allowedStages.includes(failure.details.operation_stage)) {
      context.addIssue({
        code: "custom",
        message: "Operation stage is invalid for the processing job kind.",
        path: ["details", "operation_stage"],
      });
    }
  });

export type WorkerFailure = z.infer<typeof workerFailureSchema>;

export class WorkerHandlerFailure extends Error {
  readonly failure: WorkerFailure;

  constructor(failure: WorkerFailure) {
    const parsed = workerFailureSchema.parse(failure);
    super(parsed.code);
    this.name = "WorkerHandlerFailure";
    this.failure = parsed;
  }
}

export interface WorkerJobStore {
  claim(
    kind: ProcessingJobKind,
    workerId: string,
    leaseSeconds: number,
  ): Promise<ClaimedProcessingJob | null>;
  complete(jobId: string, workerId: string): Promise<boolean>;
  heartbeat(jobId: string, workerId: string, leaseSeconds: number): Promise<boolean>;
  release(
    jobId: string,
    workerId: string,
    failure: WorkerFailure,
    retryDelaySeconds: number,
  ): Promise<boolean>;
}

export interface WorkerHandlerContext {
  signal: AbortSignal;
}

export type WorkerJobHandler = (
  job: ClaimedProcessingJob,
  context: WorkerHandlerContext,
) => Promise<void>;

export type WorkerHandlerRegistry = Partial<
  Record<ProcessingJobKind, WorkerJobHandler>
>;

export interface WorkerLogRecord {
  attempt?: number;
  code?: string;
  event:
    | "job_completed"
    | "job_lease_lost"
    | "job_released"
    | "worker_stopped";
  jobId?: string;
  kind?: ProcessingJobKind;
}

export type WorkerLogger = (record: WorkerLogRecord) => void;

const runtimeConfigurationSchema = z
  .strictObject({
    claimKinds: z.array(processingJobKindSchema).max(PROCESSING_JOB_KINDS.length),
    heartbeatIntervalMs: z.number().int().min(10).max(3_599_000),
    leaseSeconds: z.number().int().min(1).max(3_600),
    pollIntervalMs: z.number().int().min(10).max(60_000),
    retryDelaySeconds: z.number().int().min(0).max(3_600),
    workerId: z.string().trim().min(1).max(120),
  })
  .superRefine((configuration, context) => {
    if (new Set(configuration.claimKinds).size !== configuration.claimKinds.length) {
      context.addIssue({
        code: "custom",
        message: "Claimed processing job kinds must be unique.",
        path: ["claimKinds"],
      });
    }

    if (configuration.heartbeatIntervalMs >= configuration.leaseSeconds * 1_000) {
      context.addIssue({
        code: "custom",
        message: "Heartbeat interval must be shorter than the lease.",
        path: ["heartbeatIntervalMs"],
      });
    }
  });

export type WorkerRunResult =
  | { status: "completed" | "released"; jobId: string }
  | { status: "idle" | "lease_lost" };

interface DurableWorkerRuntimeOptions {
  claimKinds?: readonly ProcessingJobKind[];
  handlers: WorkerHandlerRegistry;
  heartbeatIntervalMs?: number;
  leaseSeconds?: number;
  logger?: WorkerLogger;
  pollIntervalMs?: number;
  retryDelaySeconds?: number;
  store: WorkerJobStore;
  workerId: string;
}

class WorkerShutdownError extends Error {
  constructor() {
    super("Worker shutdown requested.");
    this.name = "WorkerShutdownError";
  }
}

class WorkerLeaseLostError extends Error {
  constructor() {
    super("Processing job lease was lost.");
    this.name = "WorkerLeaseLostError";
  }
}

class WorkerStoreError extends Error {
  constructor(operation: string) {
    super(`Worker job store ${operation} failed.`);
    this.name = "WorkerStoreError";
  }
}

function safeRuntimeFailure(
  job: ClaimedProcessingJob,
  code: "INTERNAL_ERROR" | "WORKER_HANDLER_UNAVAILABLE" | "WORKER_SHUTDOWN",
  retryable: boolean,
): WorkerFailure {
  return workerFailureSchema.parse({
    code,
    details: {
      customer_message_key:
        code === "WORKER_SHUTDOWN"
          ? "processing_interrupted_retrying"
          : code === "WORKER_HANDLER_UNAVAILABLE"
            ? "processing_temporarily_unavailable"
            : "processing_failed",
      job_kind: job.kind,
      operation_stage: defaultOperationStage[job.kind],
      retryable,
    },
  });
}

function parseSingleRow<T>(
  data: unknown,
  schema: z.ZodType<T>,
  operation: string,
): T | null {
  const parsed = z.array(schema).max(1).safeParse(data);

  if (!parsed.success) throw new WorkerStoreError(operation);
  return parsed.data[0] ?? null;
}

function assertNoStoreError(error: unknown, operation: string): void {
  if (error !== null) throw new WorkerStoreError(operation);
}

export function createSupabaseWorkerJobStore(
  client: ServerOnlySupabaseClient,
): WorkerJobStore {
  return {
    async claim(kind, workerId, leaseSeconds) {
      const result = await client.execute((supabase) =>
        supabase
          .rpc("worker_claim_processing_job", {
            p_kind: kind,
            p_lease_seconds: leaseSeconds,
            p_worker_id: workerId,
          })
          .abortSignal(AbortSignal.timeout(DATABASE_OPERATION_TIMEOUT_MS)),
      );
      assertNoStoreError(result.error, "claim");
      const job = parseSingleRow(result.data, claimedProcessingJobSchema, "claim");
      if (job !== null && (job.kind !== kind || job.worker_id !== workerId)) {
        throw new WorkerStoreError("claim");
      }
      return job;
    },
    async complete(jobId, workerId) {
      const result = await client.execute((supabase) =>
        supabase
          .rpc("worker_complete_processing_job", {
            p_job_id: jobId,
            p_worker_id: workerId,
          })
          .abortSignal(AbortSignal.timeout(DATABASE_OPERATION_TIMEOUT_MS)),
      );
      assertNoStoreError(result.error, "complete");
      const row = parseSingleRow(
        result.data,
        processingJobSchema.extend({ status: z.literal("succeeded") }),
        "complete",
      );
      if (row !== null && row.id !== jobId) throw new WorkerStoreError("complete");
      return row !== null;
    },
    async heartbeat(jobId, workerId, leaseSeconds) {
      const result = await client.execute((supabase) =>
        supabase
          .rpc("worker_heartbeat_processing_job", {
            p_job_id: jobId,
            p_lease_seconds: leaseSeconds,
            p_worker_id: workerId,
          })
          .abortSignal(AbortSignal.timeout(DATABASE_OPERATION_TIMEOUT_MS)),
      );
      assertNoStoreError(result.error, "heartbeat");
      const row = parseSingleRow(result.data, claimedProcessingJobSchema, "heartbeat");
      if (row !== null && (row.id !== jobId || row.worker_id !== workerId)) {
        throw new WorkerStoreError("heartbeat");
      }
      return row !== null;
    },
    async release(jobId, workerId, failure, retryDelaySeconds) {
      const parsedFailure = workerFailureSchema.parse(failure);
      const result = await client.execute((supabase) =>
        supabase
          .rpc("worker_release_processing_job", {
            p_error_code: parsedFailure.code,
            p_error_details: parsedFailure.details,
            p_job_id: jobId,
            p_retry_delay_seconds: retryDelaySeconds,
            p_worker_id: workerId,
          })
          .abortSignal(AbortSignal.timeout(DATABASE_OPERATION_TIMEOUT_MS)),
      );
      assertNoStoreError(result.error, "release");
      const row = parseSingleRow(
        result.data,
        processingJobSchema.extend({ status: z.enum(["failed", "retry_wait"]) }),
        "release",
      );
      if (row !== null && row.id !== jobId) throw new WorkerStoreError("release");
      return row !== null;
    },
  };
}

function abortableSleep(milliseconds: number, signal: AbortSignal): Promise<void> {
  return new Promise((resolve, reject) => {
    if (signal.aborted) {
      reject(signal.reason);
      return;
    }

    const onAbort = () => {
      clearTimeout(timer);
      reject(signal.reason);
    };
    const timer = setTimeout(() => {
      signal.removeEventListener("abort", onAbort);
      resolve();
    }, milliseconds);
    signal.addEventListener("abort", onAbort, { once: true });
  });
}

export function createDurableWorkerRuntime(options: DurableWorkerRuntimeOptions) {
  const configuredKinds =
    options.claimKinds ??
    PROCESSING_JOB_KINDS.filter((kind) => options.handlers[kind] !== undefined);
  const configuration = runtimeConfigurationSchema.parse({
    claimKinds: configuredKinds,
    heartbeatIntervalMs: options.heartbeatIntervalMs ?? 30_000,
    leaseSeconds: options.leaseSeconds ?? 120,
    pollIntervalMs: options.pollIntervalMs ?? 500,
    retryDelaySeconds: options.retryDelaySeconds ?? 5,
    workerId: options.workerId,
  });
  const logger: WorkerLogger =
    options.logger ?? ((record) => console.info(JSON.stringify(record)));
  const processController = new AbortController();
  let activeJobController: AbortController | null = null;
  let claimCursor = 0;

  async function claimNext(): Promise<ClaimedProcessingJob | null> {
    if (configuration.claimKinds.length === 0) return null;

    for (let offset = 0; offset < configuration.claimKinds.length; offset += 1) {
      const index = (claimCursor + offset) % configuration.claimKinds.length;
      const kind = configuration.claimKinds[index];
      if (kind === undefined) continue;
      const job = await options.store.claim(
        kind,
        configuration.workerId,
        configuration.leaseSeconds,
      );

      if (job !== null) {
        claimCursor = (index + 1) % configuration.claimKinds.length;
        return job;
      }
    }

    claimCursor = (claimCursor + 1) % configuration.claimKinds.length;
    return null;
  }

  async function release(
    job: ClaimedProcessingJob,
    failure: WorkerFailure,
  ): Promise<WorkerRunResult> {
    const released = await options.store.release(
      job.id,
      configuration.workerId,
      failure,
      configuration.retryDelaySeconds,
    );

    if (!released) {
      logger({ event: "job_lease_lost" });
      return { status: "lease_lost" };
    }

    logger({
      attempt: job.attempt_count,
      code: failure.code,
      event: "job_released",
      jobId: job.id,
      kind: job.kind,
    });
    return { jobId: job.id, status: "released" };
  }

  async function runClaimedJob(job: ClaimedProcessingJob): Promise<WorkerRunResult> {
    const handler = options.handlers[job.kind];

    if (handler === undefined) {
      return release(
        job,
        safeRuntimeFailure(job, "WORKER_HANDLER_UNAVAILABLE", true),
      );
    }

    const jobController = new AbortController();
    activeJobController = jobController;
    let heartbeatInFlight: Promise<void> | null = null;
    let leaseLost = false;
    const heartbeat = () => {
      if (heartbeatInFlight !== null || jobController.signal.aborted) return;
      heartbeatInFlight = options.store
        .heartbeat(job.id, configuration.workerId, configuration.leaseSeconds)
        .then((renewed) => {
          if (!renewed) {
            leaseLost = true;
            jobController.abort(new WorkerLeaseLostError());
          }
        })
        .catch(() => {
          leaseLost = true;
          jobController.abort(new WorkerLeaseLostError());
        })
        .finally(() => {
          heartbeatInFlight = null;
        });
    };
    const heartbeatTimer = setInterval(heartbeat, configuration.heartbeatIntervalMs);
    const abortPromise = new Promise<never>((_resolve, reject) => {
      jobController.signal.addEventListener(
        "abort",
        () => reject(jobController.signal.reason),
        { once: true },
      );
    });
    const handlerPromise = handler(job, { signal: jobController.signal });

    try {
      await Promise.race([handlerPromise, abortPromise]);
      clearInterval(heartbeatTimer);
      if (heartbeatInFlight !== null) await heartbeatInFlight;

      if (leaseLost) {
        logger({ event: "job_lease_lost" });
        return { status: "lease_lost" };
      }

      if (processController.signal.aborted) {
        return release(job, safeRuntimeFailure(job, "WORKER_SHUTDOWN", true));
      }

      const completed = await options.store.complete(job.id, configuration.workerId);
      if (!completed) {
        logger({ event: "job_lease_lost" });
        return { status: "lease_lost" };
      }

      logger({
        attempt: job.attempt_count,
        event: "job_completed",
        jobId: job.id,
        kind: job.kind,
      });
      return { jobId: job.id, status: "completed" };
    } catch (error) {
      clearInterval(heartbeatTimer);
      if (heartbeatInFlight !== null) await heartbeatInFlight;

      if (leaseLost || error instanceof WorkerLeaseLostError) {
        void handlerPromise.catch(() => undefined);
        logger({ event: "job_lease_lost" });
        return { status: "lease_lost" };
      }

      if (processController.signal.aborted || error instanceof WorkerShutdownError) {
        void handlerPromise.catch(() => undefined);
        return release(job, safeRuntimeFailure(job, "WORKER_SHUTDOWN", true));
      }

      const failure =
        error instanceof WorkerHandlerFailure
          ? error.failure
          : safeRuntimeFailure(job, "INTERNAL_ERROR", false);
      return release(job, failure);
    } finally {
      clearInterval(heartbeatTimer);
      if (activeJobController === jobController) activeJobController = null;
    }
  }

  async function runOnce(): Promise<WorkerRunResult> {
    if (processController.signal.aborted) return { status: "idle" };
    const job = await claimNext();
    return job === null ? { status: "idle" } : runClaimedJob(job);
  }

  async function run(): Promise<void> {
    while (!processController.signal.aborted) {
      const result = await runOnce();
      if (result.status === "idle" && !processController.signal.aborted) {
        try {
          await abortableSleep(
            configuration.pollIntervalMs,
            processController.signal,
          );
        } catch (error) {
          if (!processController.signal.aborted) throw error;
        }
      }
    }

    logger({ event: "worker_stopped" });
  }

  function shutdown(): void {
    if (processController.signal.aborted) return;
    processController.abort(new WorkerShutdownError());
    activeJobController?.abort(new WorkerShutdownError());
  }

  return Object.freeze({ run, runOnce, shutdown });
}
