import { randomUUID } from "node:crypto";
import { type TryOnRequest, type TryOnResponse } from "@/lib/try-on";

const MOCK_LATENCY_MS = 2200;
export class MockTryOnError extends Error { constructor() { super("The mock renderer could not create a preview."); } }
export class MockTryOnTimeoutError extends Error { constructor() { super("The mock renderer timed out before it could create a preview."); } }

export async function runMockTryOn(request: TryOnRequest): Promise<TryOnResponse> {
  await new Promise((resolve) => setTimeout(resolve, MOCK_LATENCY_MS));
  if (request.simulation === "failure") throw new MockTryOnError();
  if (request.simulation === "timeout") throw new MockTryOnTimeoutError();
  return { requestId: randomUUID(), status: "succeeded", message: "This is a mock result proving the interface and request boundary. A real try-on provider will replace this adapter later.", latencyMs: MOCK_LATENCY_MS };
}
