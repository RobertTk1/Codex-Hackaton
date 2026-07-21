import { z } from "zod";

export const serverOnlyEnvironmentNames = [
  "APP_BASE_URL",
  "CORS_ALLOWED_ORIGINS",
  "DECART_API_KEY",
  "EMAIL_DELIVERY_API_KEY",
  "EMAIL_FROM_ADDRESS",
  "GEMINI_API_KEY",
  "HOST",
  "OPENAI_API_KEY",
  "PORT",
  "SHOPIFY_AGENT_PROFILE_URL",
  "SUPABASE_SERVICE_ROLE_KEY",
] as const;

const browserEnvironmentSchema = z.strictObject({
  BASE_URL: z.string().startsWith("/"),
  DEV: z.boolean(),
  MODE: z.string().trim().min(1),
  PROD: z.boolean(),
  SSR: z.boolean(),
  VITE_API_BASE_URL: z.url(),
  VITE_SUPABASE_PUBLISHABLE_KEY: z.string().trim().min(1).max(4_096),
  VITE_SUPABASE_URL: z.url(),
});

const browserRuntimeConfigurationSchema = z.strictObject({
  schemaVersion: z.literal(1),
  VITE_API_BASE_URL_BASE64: z.string().trim().min(1).max(8_192),
  VITE_SUPABASE_PUBLISHABLE_KEY_BASE64: z.string().trim().min(1).max(8_192),
  VITE_SUPABASE_URL_BASE64: z.string().trim().min(1).max(8_192),
});

const browserPublicEnvironmentSchema = browserEnvironmentSchema.pick({
  VITE_API_BASE_URL: true,
  VITE_SUPABASE_PUBLISHABLE_KEY: true,
  VITE_SUPABASE_URL: true,
});

export type BrowserEnvironment = z.infer<typeof browserEnvironmentSchema>;
export type BrowserRuntimeConfiguration = z.infer<typeof browserRuntimeConfigurationSchema>;

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null && !Array.isArray(value);
}

export function loadBrowserEnvironment(source: unknown): BrowserEnvironment {
  if (isRecord(source)) {
    const forbiddenName = serverOnlyEnvironmentNames.find((name) => name in source);
    if (forbiddenName !== undefined) {
      throw new Error(`Server-only environment variable is not allowed in browser configuration: ${forbiddenName}.`);
    }
  }

  const result = browserEnvironmentSchema.safeParse(source);
  if (!result.success) {
    const variableName = result.error.issues[0]?.path[0];
    const safeName = typeof variableName === "string" ? variableName : "configuration";
    throw new Error(`Invalid browser environment variable: ${safeName}.`);
  }

  return result.data;
}

function decodeBase64EnvironmentValue(name: string, value: string): string {
  try {
    const binaryValue = globalThis.atob(value);
    const bytes = Uint8Array.from(binaryValue, (character) => character.charCodeAt(0));
    return new TextDecoder("utf-8", { fatal: true }).decode(bytes);
  } catch {
    throw new Error(`Invalid browser runtime environment variable: ${name}.`);
  }
}

export function loadBrowserRuntimeEnvironment(source: unknown) {
  const result = browserRuntimeConfigurationSchema.safeParse(source);
  if (!result.success) {
    const variableName = result.error.issues[0]?.path[0];
    const safeName = typeof variableName === "string" ? variableName : "configuration";
    throw new Error(`Invalid browser runtime environment variable: ${safeName}.`);
  }

  const decodedResult = browserPublicEnvironmentSchema.safeParse({
    VITE_API_BASE_URL: decodeBase64EnvironmentValue(
      "VITE_API_BASE_URL",
      result.data.VITE_API_BASE_URL_BASE64,
    ),
    VITE_SUPABASE_PUBLISHABLE_KEY: decodeBase64EnvironmentValue(
      "VITE_SUPABASE_PUBLISHABLE_KEY",
      result.data.VITE_SUPABASE_PUBLISHABLE_KEY_BASE64,
    ),
    VITE_SUPABASE_URL: decodeBase64EnvironmentValue(
      "VITE_SUPABASE_URL",
      result.data.VITE_SUPABASE_URL_BASE64,
    ),
  });

  if (!decodedResult.success) {
    const variableName = decodedResult.error.issues[0]?.path[0];
    const safeName = typeof variableName === "string" ? variableName : "configuration";
    throw new Error(`Invalid browser runtime environment variable: ${safeName}.`);
  }

  return decodedResult.data;
}
