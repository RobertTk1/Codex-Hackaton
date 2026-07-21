import { createClient, type SupabaseClient } from "@supabase/supabase-js";
import { z } from "zod";

import type { ServerEnvironment } from "../env";

const clientUrlSchema = z.url();
const apiKeySchema = z.string().trim().min(1).max(16_384);
const accessTokenSchema = z.string().trim().min(1).max(16_384);

const userClientConfigurationSchema = z.object({
  VITE_SUPABASE_PUBLISHABLE_KEY: apiKeySchema,
  VITE_SUPABASE_URL: clientUrlSchema,
});

const serverClientConfigurationSchema = z.object({
  SUPABASE_SERVICE_ROLE_KEY: apiKeySchema,
  VITE_SUPABASE_URL: clientUrlSchema,
});

const supabaseBoundaryResultSchema = z.object({
  data: z.unknown(),
  error: z.unknown(),
});

const scopedClientBrand: unique symbol = Symbol("magic-mirror-scoped-supabase-client");

export interface UntrustedSupabaseResult {
  data: unknown;
  error: unknown;
}

type UntrustedRelationship = {
  columns: string[];
  foreignKeyName: string;
  isOneToOne?: boolean;
  referencedColumns: string[];
  referencedRelation: string;
};

type UntrustedRelation = {
  Insert: Record<string, unknown>;
  Relationships: UntrustedRelationship[];
  Row: Record<string, unknown>;
  Update: Record<string, unknown>;
};

type UntrustedDatabase = {
  public: {
    Functions: Record<
      string,
      { Args: Record<string, unknown> | never; Returns: unknown }
    >;
    Tables: Record<string, UntrustedRelation>;
    Views: Record<string, UntrustedRelation>;
  };
};

type UntrustedSupabaseClient = SupabaseClient<UntrustedDatabase>;

export type SupabaseOperation = (
  client: UntrustedSupabaseClient,
) => PromiseLike<{ data: unknown; error: unknown }>;

interface ScopedSupabaseClient<Scope extends "server-only" | "user-token"> {
  readonly [scopedClientBrand]: Scope;
  readonly scope: Scope;
  execute(operation: SupabaseOperation): Promise<UntrustedSupabaseResult>;
}

export type UserTokenSupabaseClient = ScopedSupabaseClient<"user-token">;
export type ServerOnlySupabaseClient = ScopedSupabaseClient<"server-only">;

function invalidConfiguration(scope: "server-only" | "user-token"): Error {
  return new Error(`Invalid ${scope} Supabase client configuration.`);
}

function createScopedClient<Scope extends "server-only" | "user-token">(
  scope: Scope,
  client: UntrustedSupabaseClient,
): ScopedSupabaseClient<Scope> {
  return Object.freeze({
    [scopedClientBrand]: scope,
    scope,
    async execute(operation: SupabaseOperation): Promise<UntrustedSupabaseResult> {
      const result: unknown = await operation(client);
      const parsed = supabaseBoundaryResultSchema.safeParse(result);

      if (!parsed.success) {
        throw new Error("Supabase returned an invalid boundary response.");
      }

      return parsed.data;
    },
  });
}

export function createUserTokenSupabaseClient(
  configuration: Pick<
    ServerEnvironment,
    "VITE_SUPABASE_PUBLISHABLE_KEY" | "VITE_SUPABASE_URL"
  >,
  verifiedAccessToken: string,
): UserTokenSupabaseClient {
  const configurationResult = userClientConfigurationSchema.safeParse(configuration);
  const accessTokenResult = accessTokenSchema.safeParse(verifiedAccessToken);

  if (!configurationResult.success || !accessTokenResult.success) {
    throw invalidConfiguration("user-token");
  }

  const client = createClient<UntrustedDatabase>(
    configurationResult.data.VITE_SUPABASE_URL,
    configurationResult.data.VITE_SUPABASE_PUBLISHABLE_KEY,
    {
      accessToken: async () => accessTokenResult.data,
      auth: {
        autoRefreshToken: false,
        detectSessionInUrl: false,
        persistSession: false,
      },
    },
  );

  return createScopedClient("user-token", client);
}

export function createServerOnlySupabaseClient(
  configuration: Pick<
    ServerEnvironment,
    "SUPABASE_SERVICE_ROLE_KEY" | "VITE_SUPABASE_URL"
  >,
): ServerOnlySupabaseClient {
  const configurationResult = serverClientConfigurationSchema.safeParse(configuration);

  if (!configurationResult.success) {
    throw invalidConfiguration("server-only");
  }

  const client = createClient<UntrustedDatabase>(
    configurationResult.data.VITE_SUPABASE_URL,
    configurationResult.data.SUPABASE_SERVICE_ROLE_KEY,
    {
      auth: {
        autoRefreshToken: false,
        detectSessionInUrl: false,
        persistSession: false,
      },
    },
  );

  return createScopedClient("server-only", client);
}
