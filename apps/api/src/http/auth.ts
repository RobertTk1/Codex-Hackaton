import {
  magicMirrorIdSchema,
  normalizedErrorSchema,
  type ErrorCode,
} from "@magic-mirror/contracts";
import { createClient } from "@supabase/supabase-js";
import { z } from "zod";

import type { ServerEnvironment } from "../env";

const bearerAuthorizationSchema = z
  .string()
  .trim()
  .max(16_391)
  .regex(/^Bearer [^\s,]+$/i)
  .transform((authorization) => authorization.slice(authorization.indexOf(" ") + 1));

const verifiedAuthUserSchema = z.object({
  id: magicMirrorIdSchema,
  is_anonymous: z.boolean().optional().default(false),
});

const authVerifierErrorSchema = z.object({
  name: z.string().optional(),
  status: z.number().int().optional(),
});

export type OwnerIdentityState = "anonymous" | "permanent";

export interface OwnerContext {
  identityState: OwnerIdentityState;
  ownerId: string;
}

export interface AccessTokenVerification {
  error: unknown | null;
  unavailable: boolean;
  user: unknown | null;
}

export type AccessTokenVerifier = (accessToken: string) => Promise<AccessTokenVerification>;

export type RequestAuthentication =
  | { ok: true; owner: OwnerContext }
  | { ok: false; response: Response };

function isAuthServiceUnavailable(error: unknown): boolean {
  const parsed = authVerifierErrorSchema.safeParse(error);

  return (
    parsed.success &&
    (parsed.data.name === "AuthRetryableFetchError" ||
      parsed.data.status === 0 ||
      (parsed.data.status !== undefined && parsed.data.status >= 500))
  );
}

const authenticationErrors = {
  AUTH_REQUIRED: {
    error: "Sign in to continue.",
    status: 401,
  },
  AUTH_SESSION_EXPIRED: {
    error: "Your session is no longer valid.",
    status: 401,
  },
  SERVICE_UNAVAILABLE: {
    error: "Authentication is temporarily unavailable.",
    status: 503,
  },
} as const satisfies Partial<Record<ErrorCode, { error: string; status: number }>>;

function authenticationErrorResponse(
  requestId: string,
  code: keyof typeof authenticationErrors,
): Response {
  const definition = authenticationErrors[code];
  const body = normalizedErrorSchema.parse({
    code,
    details: {},
    error: definition.error,
    requestId,
  });

  return Response.json(body, { status: definition.status });
}

export function createSupabaseAccessTokenVerifier(
  config: Pick<
    ServerEnvironment,
    "VITE_SUPABASE_PUBLISHABLE_KEY" | "VITE_SUPABASE_URL"
  >,
): AccessTokenVerifier {
  const supabase = createClient(
    config.VITE_SUPABASE_URL,
    config.VITE_SUPABASE_PUBLISHABLE_KEY,
    {
      auth: {
        autoRefreshToken: false,
        detectSessionInUrl: false,
        persistSession: false,
      },
    },
  );

  return async (accessToken) => {
    const { data, error } = await supabase.auth.getUser(accessToken);

    return {
      error,
      unavailable: isAuthServiceUnavailable(error),
      user: data.user,
    };
  };
}

export async function authenticateRequest(
  request: Request,
  requestId: string,
  verifyAccessToken: AccessTokenVerifier,
): Promise<RequestAuthentication> {
  const authorization = bearerAuthorizationSchema.safeParse(
    request.headers.get("Authorization"),
  );

  if (!authorization.success) {
    return {
      ok: false,
      response: authenticationErrorResponse(requestId, "AUTH_REQUIRED"),
    };
  }

  let verification: AccessTokenVerification;
  try {
    verification = await verifyAccessToken(authorization.data);
  } catch {
    return {
      ok: false,
      response: authenticationErrorResponse(requestId, "SERVICE_UNAVAILABLE"),
    };
  }

  if (verification.unavailable) {
    return {
      ok: false,
      response: authenticationErrorResponse(requestId, "SERVICE_UNAVAILABLE"),
    };
  }

  if (verification.error !== null || verification.user === null) {
    return {
      ok: false,
      response: authenticationErrorResponse(requestId, "AUTH_SESSION_EXPIRED"),
    };
  }

  const user = verifiedAuthUserSchema.safeParse(verification.user);
  if (!user.success) {
    return {
      ok: false,
      response: authenticationErrorResponse(requestId, "SERVICE_UNAVAILABLE"),
    };
  }

  return {
    ok: true,
    owner: {
      identityState: user.data.is_anonymous ? "anonymous" : "permanent",
      ownerId: user.data.id,
    },
  };
}
