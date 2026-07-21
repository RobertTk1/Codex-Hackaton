import { afterEach, describe, expect, test } from "vitest";
import { spawnSync } from "node:child_process";
import { mkdtemp, readFile, readdir, rm, writeFile } from "node:fs/promises";
import { tmpdir } from "node:os";
import path from "node:path";
import { fileURLToPath } from "node:url";

import { loadServerEnvironment } from "../src/env";
import { loadBrowserEnvironment } from "../../web/src/env";

const repositoryRoot = fileURLToPath(new URL("../../../", import.meta.url));
const temporaryDirectories: string[] = [];

const validServerEnvironment = {
  APP_BASE_URL: "http://127.0.0.1:5173",
  CORS_ALLOWED_ORIGINS: "http://127.0.0.1:5173, https://magicmirror.example",
  DECART_API_KEY: "test-decart-key",
  EMAIL_DELIVERY_API_KEY: "test-email-key",
  EMAIL_FROM_ADDRESS: "test@magicmirror.example",
  GEMINI_API_KEY: "test-gemini-key",
  HOST: "127.0.0.1",
  OPENAI_API_KEY: "test-openai-key",
  PORT: "3000",
  SHOPIFY_AGENT_PROFILE_URL: "https://shopify.example/ucp",
  SUPABASE_SERVICE_ROLE_KEY: "test-service-role-key",
  VITE_SUPABASE_PUBLISHABLE_KEY: "test-publishable-key",
  VITE_SUPABASE_URL: "https://project.supabase.co",
} as const;

afterEach(async () => {
  await Promise.all(
    temporaryDirectories.splice(0).map((directory) =>
      rm(directory, { force: true, recursive: true })
    ),
  );
});

describe("environment boundaries", () => {
  test("valid placeholder-shaped server configuration parses", () => {
    expect(loadServerEnvironment(validServerEnvironment)).toMatchObject({
      CORS_ALLOWED_ORIGINS: [
        "http://127.0.0.1:5173",
        "https://magicmirror.example",
      ],
      PORT: 3000,
      VITE_SUPABASE_PUBLISHABLE_KEY: "test-publishable-key",
    });
  });

  test("valid placeholder-shaped browser configuration parses", () => {
    expect(loadBrowserEnvironment({
      BASE_URL: "/",
      DEV: true,
      MODE: "test",
      PROD: false,
      SSR: false,
      VITE_API_BASE_URL: "http://127.0.0.1:3000",
      VITE_SUPABASE_PUBLISHABLE_KEY: "test-publishable-key",
      VITE_SUPABASE_URL: "https://project.supabase.co",
    })).toMatchObject({
      VITE_API_BASE_URL: "http://127.0.0.1:3000",
      VITE_SUPABASE_PUBLISHABLE_KEY: "test-publishable-key",
    });
  });

  test("browser configuration rejects server-only secrets without exposing values", () => {
    const secretSentinel = "must-not-appear-in-the-error";

    expect(() => loadBrowserEnvironment({
      BASE_URL: "/",
      DEV: true,
      MODE: "test",
      PROD: false,
      SSR: false,
      SUPABASE_SERVICE_ROLE_KEY: secretSentinel,
      VITE_API_BASE_URL: "http://127.0.0.1:3000",
      VITE_SUPABASE_PUBLISHABLE_KEY: "test-publishable-key",
      VITE_SUPABASE_URL: "https://project.supabase.co",
    })).toThrow("Server-only environment variable is not allowed in browser configuration: SUPABASE_SERVICE_ROLE_KEY.");

    try {
      loadBrowserEnvironment({ SUPABASE_SERVICE_ROLE_KEY: secretSentinel });
    } catch (error) {
      if (!(error instanceof Error)) throw error;
      expect(error.message).not.toContain(secretSentinel);
    }
  });

  test("server startup reports only the missing variable name", () => {
    const { GEMINI_API_KEY: _missing, ...environmentWithoutGemini } = validServerEnvironment;
    const result = spawnSync("bun", ["--no-env-file", "apps/api/src/server.ts"], {
      cwd: repositoryRoot,
      encoding: "utf8",
      env: {
        ...environmentWithoutGemini,
        PATH: process.env.PATH ?? "",
      },
    });

    expect(result.status).not.toBe(0);
    expect(result.stdout).toBe("");
    expect(result.stderr.trim()).toBe(
      "API startup failed: Missing required server environment variable: GEMINI_API_KEY.",
    );
    expect(result.stderr).not.toContain(validServerEnvironment.SUPABASE_SERVICE_ROLE_KEY);
    expect(result.stderr).not.toContain(validServerEnvironment.OPENAI_API_KEY);
  });

  test("the web build type gate rejects a server-only environment import", async () => {
    const fixtureDirectory = await mkdtemp(path.join(tmpdir(), "magic-mirror-env-"));
    temporaryDirectories.push(fixtureDirectory);
    const browserSecretProbe = path.join(fixtureDirectory, "server-secret-probe.ts");
    await writeFile(
      browserSecretProbe,
      "export const forbidden = import.meta.env.SUPABASE_SERVICE_ROLE_KEY;\n",
      "utf8",
    );
    const result = spawnSync("bunx", [
      "tsc",
      "--ignoreConfig",
      "--noEmit",
      "--strict",
      "--module",
      "Preserve",
      "--moduleResolution",
      "Bundler",
      "--target",
      "ES2024",
      path.join(repositoryRoot, "apps/web/src/vite-env.d.ts"),
      browserSecretProbe,
    ], {
      cwd: repositoryRoot,
      encoding: "utf8",
      env: {
        ...process.env,
        PATH: process.env.PATH ?? "",
      },
    });
    const output = `${result.stdout}\n${result.stderr}`;

    expect(result.status).not.toBe(0);
    expect(output).toContain("SUPABASE_SERVICE_ROLE_KEY");
    expect(output).toContain("does not exist on type 'ImportMetaEnv'");
  });

  test("a valid web build cannot contain a server secret value", async () => {
    const secretSentinel = "must-not-enter-the-browser-bundle";
    const outputDirectory = await mkdtemp(path.join(tmpdir(), "magic-mirror-env-build-"));
    temporaryDirectories.push(outputDirectory);
    const result = spawnSync("bun", ["run", "build:web"], {
      cwd: repositoryRoot,
      encoding: "utf8",
      env: {
        ...process.env,
        MAGIC_MIRROR_WEB_OUT_DIR: outputDirectory,
        SUPABASE_SERVICE_ROLE_KEY: secretSentinel,
        VITE_API_BASE_URL: "http://127.0.0.1:3000",
        VITE_SUPABASE_PUBLISHABLE_KEY: "test-publishable-key",
        VITE_SUPABASE_URL: "https://project.supabase.co",
      },
    });

    expect(result.status).toBe(0);
    const assetsDirectory = path.join(outputDirectory, "assets");
    const assets = await readdir(assetsDirectory);
    const contents = await Promise.all(
      assets.map((asset) => readFile(path.join(assetsDirectory, asset), "utf8")),
    );
    expect(contents.join("\n")).not.toContain(secretSentinel);
  });
});
