import { describe, expect, test } from "vitest";

import { loadBrowserRuntimeEnvironment } from "../src/env";

function encodeBase64(value: string): string {
  return Buffer.from(value, "utf8").toString("base64");
}

describe("browser runtime environment", () => {
  test("decodes and validates only the three public deployment values", () => {
    expect(loadBrowserRuntimeEnvironment({
      schemaVersion: 1,
      VITE_API_BASE_URL_BASE64: encodeBase64("https://api.magicmirror.test"),
      VITE_SUPABASE_PUBLISHABLE_KEY_BASE64: encodeBase64("synthetic-public-key"),
      VITE_SUPABASE_URL_BASE64: encodeBase64("https://project.supabase.co"),
    })).toEqual({
      VITE_API_BASE_URL: "https://api.magicmirror.test",
      VITE_SUPABASE_PUBLISHABLE_KEY: "synthetic-public-key",
      VITE_SUPABASE_URL: "https://project.supabase.co",
    });
  });

  test("rejects malformed encoded values without echoing their contents", () => {
    const malformedValue = "not-valid-base64!";

    expect(() => loadBrowserRuntimeEnvironment({
      schemaVersion: 1,
      VITE_API_BASE_URL_BASE64: malformedValue,
      VITE_SUPABASE_PUBLISHABLE_KEY_BASE64: encodeBase64("synthetic-public-key"),
      VITE_SUPABASE_URL_BASE64: encodeBase64("https://project.supabase.co"),
    })).toThrow("Invalid browser runtime environment variable: VITE_API_BASE_URL.");

    try {
      loadBrowserRuntimeEnvironment({
        schemaVersion: 1,
        VITE_API_BASE_URL_BASE64: malformedValue,
        VITE_SUPABASE_PUBLISHABLE_KEY_BASE64: encodeBase64("synthetic-public-key"),
        VITE_SUPABASE_URL_BASE64: encodeBase64("https://project.supabase.co"),
      });
    } catch (error) {
      if (!(error instanceof Error)) throw error;
      expect(error.message).not.toContain(malformedValue);
    }
  });

  test("rejects server-only fields without echoing their values", () => {
    const secretSentinel = "server-secret-must-not-enter-runtime-config";

    try {
      loadBrowserRuntimeEnvironment({
        schemaVersion: 1,
        SUPABASE_SERVICE_ROLE_KEY: secretSentinel,
        VITE_API_BASE_URL_BASE64: encodeBase64("https://api.magicmirror.test"),
        VITE_SUPABASE_PUBLISHABLE_KEY_BASE64: encodeBase64("synthetic-public-key"),
        VITE_SUPABASE_URL_BASE64: encodeBase64("https://project.supabase.co"),
      });
      throw new Error("Expected runtime configuration validation to fail.");
    } catch (error) {
      if (!(error instanceof Error)) throw error;
      expect(error.message).toBe("Invalid browser runtime environment variable: configuration.");
      expect(error.message).not.toContain(secretSentinel);
    }
  });
});
