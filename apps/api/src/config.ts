import { z } from "zod";

const commaSeparatedUrlsSchema = z
  .string()
  .trim()
  .min(1)
  .transform((value) => value.split(",").map((origin) => origin.trim()))
  .pipe(z.array(z.url()).min(1));

const serverConfigSchema = z.object({
  APP_BASE_URL: z.url(),
  CORS_ALLOWED_ORIGINS: commaSeparatedUrlsSchema,
  HOST: z.string().trim().min(1).default("0.0.0.0"),
  PORT: z.coerce.number().int().min(1).max(65_535).default(3000),
});

export type ServerConfig = z.infer<typeof serverConfigSchema>;

type ServerEnvironment = Record<string, string | undefined>;

export function loadServerConfig(environment: ServerEnvironment): ServerConfig {
  const result = serverConfigSchema.safeParse(environment);

  if (!result.success) {
    const invalidFields = [
      ...new Set(
        result.error.issues.map((issue) =>
          issue.path.length > 0 ? issue.path.join(".") : "configuration",
        ),
      ),
    ].sort();

    throw new Error(
      `Invalid API configuration. Check: ${invalidFields.join(", ")}.`,
    );
  }

  return result.data;
}
