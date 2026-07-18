import { describe, expect, it } from "vitest";
import { MAX_PHOTO_SIZE_BYTES, tryOnRequestSchema } from "@/lib/try-on";

describe("try-on request validation", () => {
  it("accepts supported photo metadata and a catalog garment", () => {
    expect(tryOnRequestSchema.safeParse({ garmentId: "onyx-blazer", photo: { name: "look.png", size: 512_000, type: "image/png" } }).success).toBe(true);
  });
  it("rejects oversized and unsupported photo metadata", () => {
    expect(tryOnRequestSchema.safeParse({ garmentId: "onyx-blazer", photo: { name: "look.gif", size: MAX_PHOTO_SIZE_BYTES + 1, type: "image/gif" } }).success).toBe(false);
  });

  it("allows the test-only timeout mode", () => {
    expect(tryOnRequestSchema.safeParse({ garmentId: "onyx-blazer", photo: { name: "look.png", size: 512_000, type: "image/png" }, simulation: "timeout" }).success).toBe(true);
  });
});
