import { readFile } from "node:fs/promises";
import { fileURLToPath } from "node:url";

import { afterEach, describe, expect, expectTypeOf, test, vi } from "vitest";
import { z } from "zod";

import {
  createServerOnlySupabaseClient,
  createUserTokenSupabaseClient,
  type ServerOnlySupabaseClient,
  type UserTokenSupabaseClient,
} from "../src/supabase/clients";

const repositoryRoot = fileURLToPath(new URL("../../../", import.meta.url));
const projectUrl = "https://project.supabase.co";
const publishableKey = "publishable-key-sentinel";
const serverSecret = "server-secret-sentinel";
const verifiedAccessToken = "verified-user-token-sentinel";

interface CapturedRequest {
  body: BodyInit | null | undefined;
  headers: Headers;
  url: string;
}

function captureFetch(responseData: unknown) {
  const requests: CapturedRequest[] = [];
  const fetchMock = vi.fn(async (input: URL | RequestInfo, init?: RequestInit) => {
    const inputRequest = input instanceof Request ? input : undefined;
    const headers = new Headers(inputRequest?.headers);
    new Headers(init?.headers).forEach((value, name) => headers.set(name, value));
    requests.push({
      body: init?.body ?? inputRequest?.body,
      headers,
      url: inputRequest?.url ?? String(input),
    });

    return new Response(JSON.stringify(responseData), {
      headers: {
        "Content-Range": "0-0/*",
        "Content-Type": "application/json",
      },
      status: 200,
    });
  });

  vi.stubGlobal("fetch", fetchMock);
  return { fetchMock, requests };
}

afterEach(() => {
  vi.unstubAllGlobals();
});

describe("scoped server Supabase clients", () => {
  // Given a verified customer token, when an owned query executes, then Supabase receives
  // that token with the publishable key and the server credential never crosses the boundary.
  test("user-token client forwards the verified bearer token and never the server secret", async () => {
    const { fetchMock, requests } = captureFetch([]);
    const fullServerConfiguration = {
      SUPABASE_SERVICE_ROLE_KEY: serverSecret,
      VITE_SUPABASE_PUBLISHABLE_KEY: publishableKey,
      VITE_SUPABASE_URL: projectUrl,
    };
    const client = createUserTokenSupabaseClient(
      fullServerConfiguration,
      verifiedAccessToken,
    );

    await client.execute((supabase) => supabase.from("profiles").select("id"));

    expect(client.scope).toBe("user-token");
    expect(fetchMock).toHaveBeenCalledOnce();
    expect(requests).toHaveLength(1);
    const request = requests[0];
    if (request === undefined) throw new Error("Expected one captured request.");
    expect(request.headers.get("Authorization")).toBe(`Bearer ${verifiedAccessToken}`);
    expect(request.headers.get("apikey")).toBe(publishableKey);
    expect(JSON.stringify(request)).not.toContain(serverSecret);
  });

  // Given the browser workspace, then its TypeScript root and dependency graph exclude
  // the API-only constructor and Supabase SDK that can hold the service-role credential.
  test("server-only constructor is unavailable to the web package", async () => {
    const webPackage: unknown = JSON.parse(
      await readFile(`${repositoryRoot}/apps/web/package.json`, "utf8"),
    );
    const webTsConfig: unknown = JSON.parse(
      await readFile(`${repositoryRoot}/apps/web/tsconfig.json`, "utf8"),
    );
    const packageSchema = z.object({
      dependencies: z.record(z.string(), z.string()),
    });
    const tsConfigSchema = z.object({
      compilerOptions: z.object({ rootDir: z.literal(".") }),
      include: z.array(z.string()),
    });

    const parsedPackage = packageSchema.parse(webPackage);
    const parsedTsConfig = tsConfigSchema.parse(webTsConfig);
    expect(parsedPackage.dependencies).not.toHaveProperty("@magic-mirror/api");
    expect(parsedPackage.dependencies).not.toHaveProperty("@supabase/supabase-js");
    expect(parsedTsConfig.compilerOptions.rootDir).toBe(".");
    expect(parsedTsConfig.include).toEqual([
      "src/**/*.ts",
      "src/**/*.tsx",
      "vite.config.ts",
    ]);
  });

  // Given a database payload that does not satisfy the calling capability contract,
  // then the scoped client returns unknown data and only the caller's Zod parse can trust it.
  test("invalid database output remains untrusted until the calling schema parses it", async () => {
    captureFetch([{ id: "not-a-uuid", owner_id: serverSecret }]);
    const client = createUserTokenSupabaseClient(
      {
        VITE_SUPABASE_PUBLISHABLE_KEY: publishableKey,
        VITE_SUPABASE_URL: projectUrl,
      },
      verifiedAccessToken,
    );

    const result = await client.execute(async (supabase) => {
      const databaseResult = await supabase.from("profiles").select("id, owner_id");
      expectTypeOf(databaseResult.data).not.toBeAny();
      return databaseResult;
    });
    const ownedProfileSchema = z.array(
      z.strictObject({
        id: z.uuid(),
        owner_id: z.uuid(),
      }),
    );

    expectTypeOf(result.data).toEqualTypeOf<unknown>();
    expect(() => ownedProfileSchema.parse(result.data)).toThrow(z.ZodError);
  });

  test("the server-only constructor has a distinct nominal scope", () => {
    captureFetch([]);
    const userClient = createUserTokenSupabaseClient(
      {
        VITE_SUPABASE_PUBLISHABLE_KEY: publishableKey,
        VITE_SUPABASE_URL: projectUrl,
      },
      verifiedAccessToken,
    );
    const serverClient = createServerOnlySupabaseClient({
      SUPABASE_SERVICE_ROLE_KEY: serverSecret,
      VITE_SUPABASE_URL: projectUrl,
    });

    expectTypeOf(userClient).toEqualTypeOf<UserTokenSupabaseClient>();
    expectTypeOf(serverClient).toEqualTypeOf<ServerOnlySupabaseClient>();
    expectTypeOf(userClient).not.toEqualTypeOf<ServerOnlySupabaseClient>();
    expect(serverClient.scope).toBe("server-only");
  });

  test("invalid configuration fails without echoing secret values", () => {
    expect(() =>
      createServerOnlySupabaseClient({
        SUPABASE_SERVICE_ROLE_KEY: serverSecret,
        VITE_SUPABASE_URL: "not-a-url",
      }),
    ).toThrow("Invalid server-only Supabase client configuration.");

    try {
      createUserTokenSupabaseClient(
        {
          VITE_SUPABASE_PUBLISHABLE_KEY: publishableKey,
          VITE_SUPABASE_URL: projectUrl,
        },
        "",
      );
      throw new Error("Expected invalid configuration to throw.");
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      expect(message).toBe("Invalid user-token Supabase client configuration.");
      expect(message).not.toContain(publishableKey);
      expect(message).not.toContain(serverSecret);
    }
  });
});
