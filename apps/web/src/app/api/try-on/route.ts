import { NextResponse } from "next/server";
import { MockTryOnError, MockTryOnTimeoutError, runMockTryOn } from "@/lib/mock-try-on";
import { tryOnErrorSchema, tryOnRequestSchema } from "@/lib/try-on";

export async function POST(request: Request) {
  try {
    const body: unknown = await request.json();
    const parsedRequest = tryOnRequestSchema.safeParse(body);
    if (!parsedRequest.success) {
      return NextResponse.json(tryOnErrorSchema.parse({ error: "We need a supported photo and garment to create a preview.", code: "INVALID_TRY_ON_REQUEST", details: parsedRequest.error.issues.map((issue) => issue.message).join(" ") }), { status: 400 });
    }
    return NextResponse.json(await runMockTryOn(parsedRequest.data), { status: 200 });
  } catch (error) {
    const isMockFailure = error instanceof MockTryOnError || error instanceof MockTryOnTimeoutError;
    return NextResponse.json(tryOnErrorSchema.parse({ error: isMockFailure ? error.message : "We could not start the try-on preview.", code: error instanceof MockTryOnTimeoutError ? "MOCK_RENDER_TIMEOUT" : error instanceof MockTryOnError ? "MOCK_RENDER_FAILED" : "TRY_ON_REQUEST_FAILED", details: "Your photo and garment selection are still available. Try again when you are ready." }), { status: 502 });
  }
}
