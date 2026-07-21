import { z } from "zod";

const commaSeparatedUrlsSchema = z
  .string()
  .trim()
  .min(1)
  .transform((value) => value.split(",").map((origin) => origin.trim()))
  .pipe(z.array(z.url()).min(1));

const nonemptySecretSchema = z.string().min(1).max(16_384);

const serverEnvironmentSchema = z.object({
  APP_BASE_URL: z.url(),
  CORS_ALLOWED_ORIGINS: commaSeparatedUrlsSchema,
  DECART_API_KEY: nonemptySecretSchema,
  EMAIL_DELIVERY_API_KEY: nonemptySecretSchema,
  EMAIL_FROM_ADDRESS: z.email(),
  GEMINI_API_KEY: nonemptySecretSchema,
  HOST: z.string().trim().min(1).default("0.0.0.0"),
  OPENAI_API_KEY: nonemptySecretSchema,
  PORT: z
    .union([z.number(), z.string().regex(/^[1-9]\d*$/).transform(Number)])
    .pipe(z.number().int().min(1).max(65_535))
    .default(3000),
  SHOPIFY_AGENT_PROFILE_URL: z.url(),
  SUPABASE_SERVICE_ROLE_KEY: nonemptySecretSchema,
  VITE_SUPABASE_PUBLISHABLE_KEY: z.string().trim().min(1).max(4_096),
  VITE_SUPABASE_URL: z.url(),
});

export type ServerEnvironment = z.infer<typeof serverEnvironmentSchema>;

export type EnvironmentSource = Record<string, string | undefined>;

function configurationError(result: z.ZodSafeParseError<unknown>, source: EnvironmentSource): Error {
  const issue = result.error.issues[0];
  const variableName = issue?.path[0];
  const safeName = typeof variableName === "string" ? variableName : "configuration";
  const isMissing = safeName !== "configuration" && source[safeName] === undefined;
  const reason = isMissing ? "Missing required" : "Invalid";

  return new Error(`${reason} server environment variable: ${safeName}.`);
}

export function loadServerEnvironment(source: EnvironmentSource): ServerEnvironment {
  const result = serverEnvironmentSchema.safeParse(source);

  if (!result.success) {
    throw configurationError(result, source);
  }

  return result.data;
}
