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

export type BrowserEnvironment = z.infer<typeof browserEnvironmentSchema>;

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
