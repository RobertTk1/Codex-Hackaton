import { readFile, readdir } from "node:fs/promises";
import { join } from "node:path";
import { fileURLToPath } from "node:url";
// smol-toml is a small tooling-only parser because Vitest runs in Node, where Bun.TOML is absent.
import { parse } from "smol-toml";
import { z } from "zod";

export const APPROVED_AUTH_POLICY = {
  methods: ["anonymous", "google", "email_magic_link"],
  passwordSignInEnabled: false,
} as const;

export const APPROVED_LOCAL_REDIRECTS = [
  "http://127.0.0.1:5173/auth/callback",
  "https://magic-mirror-dev-mmv4h.ondigitalocean.app/auth/callback",
] as const;

const envReferenceSchema = z
  .string()
  .regex(/^env\([A-Z][A-Z0-9_]*\)$/, "provider credentials must use an environment reference");

const localAuthConfigSchema = z.object({
  auth: z.object({
    enabled: z.literal(true),
    site_url: z.string().url(),
    additional_redirect_urls: z.array(z.string().url()),
    enable_signup: z.literal(true),
    enable_anonymous_sign_ins: z.literal(true),
    enable_manual_linking: z.literal(true),
    email: z.object({
      enable_signup: z.literal(true),
    }),
    external: z.object({
      google: z.object({
        enabled: z.literal(true),
        client_id: envReferenceSchema,
        secret: envReferenceSchema,
        skip_nonce_check: z.literal(false),
      }),
    }),
  }),
});

const hostedSettingsSchema = z.object({
  external: z.object({
    anonymous_users: z.literal(true),
    email: z.literal(true),
    google: z.literal(true),
  }),
});

export type SafeAuthVerification = {
  anonymous: true;
  emailMagicLink: true;
  google: true;
  manualLinking: true;
  passwordSignIn: false;
  redirects: string[];
};

const forbiddenPasswordAuthPatterns = [
  /\.auth\.signInWithPassword\s*\(/,
  /\.auth\.signUp\s*\(/,
  /\.auth\.resetPasswordForEmail\s*\(/,
  /\.auth\.updateUser\s*\(\s*\{[^}]*\bpassword\s*:/s,
] as const;

function verifyApprovedRedirects(redirects: readonly string[]): string[] {
  const unique = [...new Set(redirects)];
  const expected = [...APPROVED_LOCAL_REDIRECTS];

  if (unique.some((value) => value.includes("*"))) {
    throw new Error("Auth redirects must be exact URLs; wildcards are not approved.");
  }

  const unapproved = unique.filter((value) => !expected.includes(value as (typeof expected)[number]));
  const missing = expected.filter((value) => !unique.includes(value));

  if (unapproved.length > 0 || missing.length > 0) {
    throw new Error("Auth redirect allowlist does not match the approved local and development callbacks.");
  }

  return unique.sort();
}

export function verifyLocalAuthConfig(input: unknown): SafeAuthVerification {
  const config = localAuthConfigSchema.parse(input);
  const redirects = verifyApprovedRedirects(config.auth.additional_redirect_urls);

  if (APPROVED_AUTH_POLICY.passwordSignInEnabled) {
    throw new Error("Password sign-in is not part of the approved product authentication surface.");
  }

  return {
    anonymous: true,
    emailMagicLink: true,
    google: true,
    manualLinking: true,
    passwordSignIn: false,
    redirects,
  };
}

export function verifyHostedAuthSettings(input: unknown): Pick<
  SafeAuthVerification,
  "anonymous" | "emailMagicLink" | "google" | "passwordSignIn"
> {
  hostedSettingsSchema.parse(input);

  return {
    anonymous: true,
    emailMagicLink: true,
    google: true,
    passwordSignIn: false,
  };
}

export function verifyPasswordlessClientSources(sources: readonly string[]): false {
  if (sources.some((source) => forbiddenPasswordAuthPatterns.some((pattern) => pattern.test(source)))) {
    throw new Error("The web client contains a password-based Supabase Auth call.");
  }

  return false;
}

async function readTypeScriptSources(directory: string): Promise<string[]> {
  const entries = await readdir(directory, { withFileTypes: true });
  const sources = await Promise.all(
    entries.map(async (entry) => {
      const path = join(directory, entry.name);
      if (entry.isDirectory()) return readTypeScriptSources(path);
      if (!entry.name.endsWith(".ts") && !entry.name.endsWith(".tsx")) return [];
      return [await readFile(path, "utf8")];
    }),
  );
  return sources.flat();
}

export async function loadLocalAuthConfig(
  configPath = fileURLToPath(new URL("../supabase/config.toml", import.meta.url)),
): Promise<unknown> {
  const source = await readFile(configPath, "utf8");
  return parse(source);
}

async function fetchHostedSettings(projectUrl: string, publishableKey: string): Promise<unknown> {
  const response = await fetch(new URL("/auth/v1/settings", projectUrl), {
    headers: { apikey: publishableKey },
    signal: AbortSignal.timeout(10_000),
  });

  if (!response.ok) {
    throw new Error(`Hosted Auth settings request failed with status ${response.status}.`);
  }

  return response.json();
}

async function main(): Promise<void> {
  const local = verifyLocalAuthConfig(await loadLocalAuthConfig());
  const webSourceRoot = fileURLToPath(new URL("../apps/web/src/", import.meta.url));
  verifyPasswordlessClientSources(await readTypeScriptSources(webSourceRoot));
  const projectUrl = process.env.VITE_SUPABASE_URL;
  const publishableKey = process.env.VITE_SUPABASE_PUBLISHABLE_KEY;

  if ((projectUrl && !publishableKey) || (!projectUrl && publishableKey)) {
    throw new Error("Hosted verification requires both VITE_SUPABASE_URL and VITE_SUPABASE_PUBLISHABLE_KEY.");
  }

  const hosted =
    projectUrl && publishableKey
      ? verifyHostedAuthSettings(await fetchHostedSettings(projectUrl, publishableKey))
      : undefined;

  process.stdout.write(`${JSON.stringify({ local, hosted }, null, 2)}\n`);
}

if (import.meta.main) {
  await main();
}
