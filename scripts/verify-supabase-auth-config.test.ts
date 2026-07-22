import { describe, expect, it } from "vitest";
import {
  APPROVED_LOCAL_REDIRECTS,
  loadLocalAuthConfig,
  verifyHostedAuthSettings,
  verifyLocalAuthConfig,
  verifyPasswordlessClientSources,
} from "./verify-supabase-auth-config";

function validLocalConfig(): unknown {
  return {
    auth: {
      enabled: true,
      site_url: "http://127.0.0.1:5173",
      additional_redirect_urls: [...APPROVED_LOCAL_REDIRECTS],
      enable_signup: true,
      enable_anonymous_sign_ins: true,
      enable_manual_linking: true,
      email: { enable_signup: true },
      external: {
        google: {
          enabled: true,
          client_id: "env(SUPABASE_AUTH_EXTERNAL_GOOGLE_CLIENT_ID)",
          secret: "env(SUPABASE_AUTH_EXTERNAL_GOOGLE_CLIENT_SECRET)",
          skip_nonce_check: false,
        },
      },
    },
  };
}

describe("Supabase Auth configuration contract", () => {
  it("accepts anonymous, Google, and email-link modes without password sign-in", async () => {
    const result = verifyLocalAuthConfig(await loadLocalAuthConfig());

    expect(result).toEqual({
      anonymous: true,
      emailMagicLink: true,
      google: true,
      manualLinking: true,
      passwordSignIn: false,
      redirects: [...APPROVED_LOCAL_REDIRECTS].sort(),
    });
  });

  it("rejects an unapproved redirect origin", () => {
    const config = validLocalConfig() as {
      auth: { additional_redirect_urls: string[] };
    };
    config.auth.additional_redirect_urls.push("https://attacker.example/auth/callback");

    expect(() => verifyLocalAuthConfig(config)).toThrow(/allowlist/i);
  });

  it("rejects literal OAuth credentials", () => {
    const config = validLocalConfig() as {
      auth: { external: { google: { secret: string } } };
    };
    config.auth.external.google.secret = "do-not-commit-this-secret";

    expect(() => verifyLocalAuthConfig(config)).toThrow(/environment reference/i);
  });

  it("accepts only hosted settings with all approved providers enabled", () => {
    expect(
      verifyHostedAuthSettings({
        external: { anonymous_users: true, email: true, google: true },
      }),
    ).toEqual({
      anonymous: true,
      emailMagicLink: true,
      google: true,
      passwordSignIn: false,
    });

    expect(() =>
      verifyHostedAuthSettings({
        external: { anonymous_users: true, email: true, google: false },
      }),
    ).toThrow();
  });

  it("rejects password-based calls from the customer-facing auth surface", () => {
    expect(verifyPasswordlessClientSources(["supabase.auth.signInWithOtp({ email })"])).toBe(false);
    expect(() =>
      verifyPasswordlessClientSources(["supabase.auth.signInWithPassword({ email, password })"]),
    ).toThrow(/password-based/i);
  });
});
