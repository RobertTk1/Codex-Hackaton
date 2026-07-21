import { describe, expect, expectTypeOf, test } from "vitest";
import { z } from "zod";

import {
  createCollectionSchema,
  magicMirrorIdSchema,
  normalizedErrorSchema,
  paginationQuerySchema,
  type MagicMirrorId,
  type NormalizedError,
  type PaginationQuery,
} from "../src/common";

const requestId = "49c40934-01cb-4d1f-9614-1bf4d0362c6e";

describe("common contract schemas", () => {
  test("a valid fixture parses to its normalized value and infers strict types", () => {
    const error = normalizedErrorSchema.parse({
      code: "PROFILE_FIELD_INVALID",
      details: { field: "favoriteBrands", reason: "invalid_value" },
      error: "  Check that answer and try again.  ",
      requestId,
    });
    const query = paginationQuerySchema.parse({ cursor: "  cursor-token  ", limit: "25" });

    expect(error).toEqual({
      code: "PROFILE_FIELD_INVALID",
      details: { field: "favoriteBrands", reason: "invalid_value" },
      error: "Check that answer and try again.",
      requestId,
    });
    expect(query).toEqual({ cursor: "cursor-token", limit: 25 });
    expectTypeOf(error).toEqualTypeOf<NormalizedError>();
    expectTypeOf(query).toEqualTypeOf<PaginationQuery>();
    expectTypeOf(magicMirrorIdSchema.parse(requestId)).toEqualTypeOf<MagicMirrorId>();
  });

  test("unknown fields are rejected at every common object boundary", () => {
    expect(() => normalizedErrorSchema.parse({
      code: "AUTH_REQUIRED",
      details: {},
      error: "Sign in to continue.",
      requestId,
      stack: "must never cross the boundary",
    })).toThrow();

    expect(() => paginationQuerySchema.parse({ limit: 20, offset: 100 })).toThrow();

    const collectionSchema = createCollectionSchema(z.strictObject({ id: magicMirrorIdSchema }));
    expect(() => collectionSchema.parse({ items: [], nextCursor: null, total: 0 })).toThrow();
  });

  test("an invalid error-code discriminator is rejected", () => {
    const result = normalizedErrorSchema.safeParse({
      code: "PROVIDER_SECRET_LEAKED",
      details: {},
      error: "Something went wrong.",
      requestId,
    });

    expect(result.success).toBe(false);
  });

  test("malformed identifiers, details, and pagination bounds are rejected", () => {
    expect(magicMirrorIdSchema.safeParse("not-a-uuid").success).toBe(false);
    expect(normalizedErrorSchema.safeParse({
      code: "RATE_LIMITED",
      details: { retryable: true, retryAfterMs: -1 },
      error: "Wait before trying again.",
      requestId,
    }).success).toBe(false);
    expect(paginationQuerySchema.safeParse({ limit: 0 }).success).toBe(false);
    expect(paginationQuerySchema.safeParse({ limit: 51 }).success).toBe(false);
    expect(paginationQuerySchema.safeParse({ limit: true }).success).toBe(false);
    expect(normalizedErrorSchema.safeParse({
      code: "AUTH_REQUIRED",
      error: "Sign in to continue.",
      requestId,
    }).success).toBe(false);
  });
});
