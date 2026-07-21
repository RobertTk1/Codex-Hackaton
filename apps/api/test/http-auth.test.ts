import { normalizedErrorSchema } from "@magic-mirror/contracts";
import { describe, expect, test, vi } from "vitest";

import {
  authenticateRequest,
  type AccessTokenVerifier,
} from "../src/http/auth";

const requestId = "9085911b-5882-47d7-a0aa-93a122ec58f2";
const tokenOwnerId = "0abed72f-2baf-4cf7-90bf-7a2cfb895097";
const bodyOwnerId = "c9f2ae1e-b0a9-4be7-96f8-b6f62453a321";

function protectedRequest(body?: unknown): Request {
  return new Request("https://api.magicmirror.example/protected", {
    ...(body === undefined ? {} : { body: JSON.stringify(body) }),
    headers: {
      Authorization: "Bearer verified-access-token",
      "Content-Type": "application/json",
    },
    method: body === undefined ? "GET" : "POST",
  });
}

describe("Supabase request authentication", () => {
  // Given a verified anonymous Supabase user, when a protected request is authenticated,
  // then the immutable Auth subject is attached with its anonymous identity state.
  test("a valid anonymous token yields its owner and anonymous status", async () => {
    const verifyAccessToken = vi.fn<AccessTokenVerifier>().mockResolvedValue({
      error: null,
      unavailable: false,
      user: {
        app_metadata: {},
        id: tokenOwnerId,
        is_anonymous: true,
        user_metadata: { owner_id: bodyOwnerId },
      },
    });

    const result = await authenticateRequest(
      protectedRequest(),
      requestId,
      verifyAccessToken,
    );

    expect(result).toEqual({
      ok: true,
      owner: {
        identityState: "anonymous",
        ownerId: tokenOwnerId,
      },
    });
    expect(verifyAccessToken).toHaveBeenCalledExactlyOnceWith("verified-access-token");
  });

  // Given a rejected Supabase token, when a protected request is authenticated,
  // then the API returns the approved strict 401 envelope without leaking provider details.
  test("an invalid token returns the approved 401 envelope", async () => {
    const verifyAccessToken = vi.fn<AccessTokenVerifier>().mockResolvedValue({
      error: new Error("sensitive provider rejection"),
      unavailable: false,
      user: null,
    });

    const result = await authenticateRequest(
      protectedRequest(),
      requestId,
      verifyAccessToken,
    );

    expect(result.ok).toBe(false);
    if (result.ok) throw new Error("Expected authentication to fail.");

    expect(result.response.status).toBe(401);
    const body: unknown = await result.response.json();
    expect(normalizedErrorSchema.parse(body)).toEqual({
      code: "AUTH_SESSION_EXPIRED",
      details: {},
      error: "Your session is no longer valid.",
      requestId,
    });
    expect(JSON.stringify(body)).not.toContain("sensitive provider rejection");
  });

  // Given a request body that claims a different owner, when authentication succeeds,
  // then ownership still comes exclusively from the verified Supabase subject.
  test("a body owner_id cannot override token ownership", async () => {
    const verifyAccessToken = vi.fn<AccessTokenVerifier>().mockResolvedValue({
      error: null,
      unavailable: false,
      user: {
        id: tokenOwnerId,
        is_anonymous: false,
      },
    });

    const result = await authenticateRequest(
      protectedRequest({ owner_id: bodyOwnerId }),
      requestId,
      verifyAccessToken,
    );

    expect(result).toEqual({
      ok: true,
      owner: {
        identityState: "permanent",
        ownerId: tokenOwnerId,
      },
    });
    expect(JSON.stringify(result)).not.toContain(bodyOwnerId);
  });

  test("a malformed authorization header is rejected before token verification", async () => {
    const verifyAccessToken = vi.fn<AccessTokenVerifier>();
    const request = new Request("https://api.magicmirror.example/protected", {
      headers: { Authorization: "Bearer token with spaces" },
    });

    const result = await authenticateRequest(request, requestId, verifyAccessToken);

    expect(result.ok).toBe(false);
    if (result.ok) throw new Error("Expected authentication to fail.");
    expect(result.response.status).toBe(401);
    expect(await result.response.json()).toMatchObject({ code: "AUTH_REQUIRED" });
    expect(verifyAccessToken).not.toHaveBeenCalled();
  });

  test("an unavailable verifier fails visibly without treating the request as anonymous", async () => {
    const verifyAccessToken = vi.fn<AccessTokenVerifier>().mockRejectedValue(
      new Error("network unavailable"),
    );

    const result = await authenticateRequest(
      protectedRequest(),
      requestId,
      verifyAccessToken,
    );

    expect(result.ok).toBe(false);
    if (result.ok) throw new Error("Expected authentication to fail.");
    expect(result.response.status).toBe(503);
    expect(await result.response.json()).toMatchObject({ code: "SERVICE_UNAVAILABLE" });
  });
});
