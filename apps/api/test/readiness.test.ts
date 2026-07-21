import { describe, expect, test } from "vitest";

import { loadServerEnvironment } from "../src/env";
import { checkApiReadiness, createApiRequestHandler } from "../src/server";

const baseEnvironment = {
  APP_BASE_URL: "http://127.0.0.1:5173",
  CORS_ALLOWED_ORIGINS: "http://127.0.0.1:5173",
  DECART_API_KEY: "test-decart-key",
  EMAIL_DELIVERY_API_KEY: "test-email-key",
  EMAIL_FROM_ADDRESS: "test@magicmirror.example",
  GEMINI_API_KEY: "test-gemini-key",
  HOST: "127.0.0.1",
  OPENAI_API_KEY: "test-openai-key",
  PORT: "3112",
  SHOPIFY_AGENT_PROFILE_URL: "https://shopify.example/ucp",
  SUPABASE_SERVICE_ROLE_KEY: "test-service-role-key",
  VITE_SUPABASE_PUBLISHABLE_KEY: "test-publishable-key",
  VITE_SUPABASE_URL: "https://development.supabase.co",
};

describe("API deployment readiness", () => {
  test("probes only the configured Supabase Auth health boundary", async () => {
    const config = loadServerEnvironment(baseEnvironment);
    const calls: Array<{ apiKey: string | null; url: string }> = [];
    const fetcher = async (input: URL, init: RequestInit): Promise<Response> => {
      const request = new Request(input, init);
      calls.push({ apiKey: request.headers.get("apikey"), url: request.url });
      return new Response(null, { status: 200 });
    };
    await expect(checkApiReadiness(config, fetcher)).resolves.toBe(true);
    expect(calls).toEqual([
      {
        apiKey: "test-publishable-key",
        url: "https://development.supabase.co/auth/v1/health",
      },
    ]);
  });

  test("returns ready only when the isolated persistence boundary is reachable", async () => {
    const config = loadServerEnvironment(baseEnvironment);
    const handler = createApiRequestHandler(config, async () => true);
    const ready = await handler(new Request("http://127.0.0.1/readyz"));
    expect(ready.status).toBe(200);
    await expect(ready.json()).resolves.toEqual({ service: "magic-mirror-api", status: "ready" });
  });

  test("returns an explicit non-ready state without leaking provider details", async () => {
    const config = loadServerEnvironment(baseEnvironment);
    const handler = createApiRequestHandler(config, async () => false);
    const response = await handler(new Request("http://127.0.0.1/readyz"));
    expect(response.status).toBe(503);
    const body = await response.text();
    expect(JSON.parse(body)).toEqual({ service: "magic-mirror-api", status: "not_ready" });
    expect(body).not.toContain(baseEnvironment.SUPABASE_SERVICE_ROLE_KEY);
    expect(body).not.toContain(baseEnvironment.VITE_SUPABASE_URL);
  });
});
