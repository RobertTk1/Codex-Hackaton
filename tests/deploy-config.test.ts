import { readFile } from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";

import { describe, expect, test } from "vitest";

import {
  assertDevelopmentOnlyInvocation,
  assertSafeRollbackValidation,
  parseDoctlOutput,
} from "../scripts/deploy-development";
import {
  placeholderNames,
  renderDevelopmentTemplate,
  validateDeploymentTemplate,
  validateDeploymentTemplates,
} from "../scripts/validate-deploy";

const repositoryRoot = fileURLToPath(new URL("../", import.meta.url));

async function templates(): Promise<{ dev: string; prod: string }> {
  const [dev, prod] = await Promise.all([
    readFile(path.join(repositoryRoot, "deploy/digitalocean/dev.yaml"), "utf8"),
    readFile(path.join(repositoryRoot, "deploy/digitalocean/prod.yaml"), "utf8"),
  ]);
  return { dev, prod };
}

function replacement(source: string, search: string, replace: string): string {
  const result = source.replace(search, replace);
  if (result === source) throw new Error(`Fixture did not contain ${search}.`);
  return result;
}

describe("DigitalOcean deployment contract", () => {
  test("validates separate three-component development and production specs", async () => {
    const source = await templates();
    expect(() => validateDeploymentTemplates(source)).not.toThrow();
    expect(source.dev).toContain("name: magic-mirror-dev");
    expect(source.prod).toContain("name: magic-mirror-prod");
    expect(source.dev).toContain("repository: magic-mirror-web");
    expect(source.dev).not.toContain("github:");
    expect(source.dev).not.toContain("MAGIC_MIRROR_PROD_");
    expect(source.prod).not.toContain("MAGIC_MIRROR_DEV_");
    expect(source.dev).not.toContain("vhpxxmefcuewkmukissr");
  });

  test("requires region, API health, worker, and immutable production digest", async () => {
    const source = await templates();
    expect(() => validateDeploymentTemplate(replacement(source.dev, "region: nyc\n", ""), "dev"))
      .toThrow("dev.yaml.region");
    expect(() =>
      validateDeploymentTemplate(
        replacement(source.dev, "      http_path: /healthz\n", ""),
        "dev",
      ),
    ).toThrow("health_check.http_path");
    expect(() =>
      validateDeploymentTemplate(replacement(source.dev, "workers:\n", "jobs:\n"), "dev"),
    ).toThrow("workers");
    expect(() =>
      validateDeploymentTemplate(
        replacement(
          source.prod,
          "      digest: ${MAGIC_MIRROR_PROD_WEB_IMAGE_DIGEST}\n",
          "      tag: latest\n",
        ),
        "prod",
      ),
    ).toThrow("immutable digest");
  });

  test("requires environment-specific secret references on every server component", async () => {
    const source = await templates();
    const crossed = replacement(
      source.dev,
      "${MAGIC_MIRROR_DEV_SUPABASE_SERVICE_ROLE_KEY}",
      "${MAGIC_MIRROR_PROD_SUPABASE_SERVICE_ROLE_KEY}",
    );
    expect(() => validateDeploymentTemplate(crossed, "dev")).toThrow(
      "SUPABASE_SERVICE_ROLE_KEY.value",
    );
    const unencrypted = replacement(
      source.dev,
      "      - key: OPENAI_API_KEY\n        scope: RUN_TIME\n        type: SECRET",
      "      - key: OPENAI_API_KEY\n        scope: RUN_TIME\n        type: GENERAL",
    );
    expect(() => validateDeploymentTemplate(unencrypted, "dev")).toThrow("OPENAI_API_KEY.type");
  });

  test("renders development values without accepting missing or multiline secrets", async () => {
    const { dev } = await templates();
    const values = Object.fromEntries(
      placeholderNames(dev)
        .filter((name) => name.startsWith("MAGIC_MIRROR_DEV_"))
        .map((name, index) => [
          name,
          name.endsWith("IMAGE_DIGEST")
            ? "sha256:" + "a".repeat(64)
            : `synthetic-deployment-value-${index}`,
        ]),
    );
    const rendered = renderDevelopmentTemplate(dev, values);
    expect(rendered).not.toContain("MAGIC_MIRROR_DEV_");
    expect(rendered).toContain("${APP_URL}");
    expect(() => renderDevelopmentTemplate(dev, {})).toThrow(
      "Missing required development deployment variable",
    );
    expect(() =>
      renderDevelopmentTemplate(dev, { ...values, MAGIC_MIRROR_DEV_OPENAI_API_KEY: "bad\nvalue" }),
    ).toThrow("Invalid development deployment variable");
  });

  test("exposes only hard-coded development deployment commands", () => {
    expect(assertDevelopmentOnlyInvocation(["apply"])).toEqual({ command: "apply" });
    expect(assertDevelopmentOnlyInvocation(["status"])).toEqual({ command: "status" });
    expect(
      assertDevelopmentOnlyInvocation(["rollback", "6ba7b810-9dad-4d65-a8cc-9995c8905889"]),
    ).toEqual({
      command: "rollback",
      targetDeploymentId: "6ba7b810-9dad-4d65-a8cc-9995c8905889",
    });
    expect(() => assertDevelopmentOnlyInvocation(["apply", "magic-mirror-prod"])).toThrow(
      "cannot target magic-mirror-prod",
    );
    expect(() => assertDevelopmentOnlyInvocation(["rollback"])).toThrow(
      "Rollback requires a development deployment ID",
    );
  });

  test("accepts only rollback validation with the expected static rebuild warning", () => {
    expect(() => assertSafeRollbackValidation({ valid: true })).not.toThrow();
    expect(() =>
      assertSafeRollbackValidation({
        valid: true,
        warnings: [{ code: "static_site_requires_rebuild" }],
      }),
    ).not.toThrow();
    expect(() => assertSafeRollbackValidation({ valid: false })).toThrow(
      "rejected the development rollback target",
    );
    expect(() =>
      assertSafeRollbackValidation({
        valid: true,
        warnings: [{ code: "image_source_missing_digest" }],
      }),
    ).toThrow("unsafe warning code");
  });

  test("accepts DigitalOcean's YAML validation response without weakening JSON commands", () => {
    expect(parseDoctlOutput("name: magic-mirror-dev\n", "text")).toBe(
      "name: magic-mirror-dev\n",
    );
    expect(() => parseDoctlOutput("", "text")).toThrow("empty response");
    expect(parseDoctlOutput('[{"id":"development-app"}]', "json")).toEqual([
      { id: "development-app" },
    ]);
    expect(() => parseDoctlOutput("name: magic-mirror-dev\n", "json")).toThrow(
      "invalid response",
    );
    expect(() => parseDoctlOutput('{"errors":[{"detail":"sensitive provider error"}]}', "json"))
      .toThrow("API error response");
  });

  test("root package exposes stable validation and development-only deployment commands", async () => {
    const packageValue: unknown = JSON.parse(
      await readFile(path.join(repositoryRoot, "package.json"), "utf8"),
    );
    if (typeof packageValue !== "object" || packageValue === null || Array.isArray(packageValue)) {
      throw new Error("package.json must be an object.");
    }
    const scripts = Reflect.get(packageValue, "scripts");
    if (typeof scripts !== "object" || scripts === null || Array.isArray(scripts)) {
      throw new Error("package.json scripts must be an object.");
    }
    expect(Reflect.get(scripts, "validate:deploy")).toBe("bun scripts/validate-deploy.ts");
    expect(Reflect.get(scripts, "deploy:dev")).toBe(
      "bun --env-file=.env.digitalocean.dev.local scripts/deploy-development.ts",
    );
    expect(Reflect.get(scripts, "deploy:prod")).toBeUndefined();
  });
});
