import { spawnSync } from "node:child_process";
import { readFile, rm, writeFile } from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";

import { afterEach, describe, expect, test } from "vitest";

const repositoryRoot = fileURLToPath(new URL("../", import.meta.url));
const workflowPath = path.join(repositoryRoot, ".github", "workflows", "ci.yml");
const failingFixturePath = path.join(
  repositoryRoot,
  "tests",
  "__ci_failing_gate_fixture__.test.ts",
);

interface PackageContract {
  devDependencies: Record<string, string>;
  scripts: Record<string, string>;
}

function isStringRecord(value: unknown): value is Record<string, string> {
  return (
    typeof value === "object" &&
    value !== null &&
    !Array.isArray(value) &&
    Object.values(value).every((entry) => typeof entry === "string")
  );
}

function parsePackageContract(source: string): PackageContract {
  const value: unknown = JSON.parse(source);
  if (typeof value !== "object" || value === null || Array.isArray(value)) {
    throw new Error("Root package manifest must be an object.");
  }

  const scripts = Reflect.get(value, "scripts");
  const devDependencies = Reflect.get(value, "devDependencies");
  if (!isStringRecord(scripts) || !isStringRecord(devDependencies)) {
    throw new Error("Root package manifest has an invalid CI command contract.");
  }

  return { devDependencies, scripts };
}

async function readWorkflow(): Promise<string> {
  return readFile(workflowPath, "utf8");
}

afterEach(async () => {
  await rm(failingFixturePath, { force: true });
});

describe("CI quality workflow", () => {
  test("runs every required clean-runner gate on pushes and pull requests", async () => {
    const workflow = await readWorkflow();
    const requiredFragments = [
      "on:\n  push:\n  pull_request:",
      "permissions:\n  contents: read",
      "persist-credentials: false",
      "bun-version: 1.3.11",
      "version: 2.109.1",
      "run: bun install --frozen-lockfile",
      "run: bun run lint",
      "run: bun run typecheck",
      "if ! supabase start",
      'start_log="${RUNNER_TEMP}/supabase-start.log"',
      "run: bun run db:reset",
      "run: docker build -f apps/api/Dockerfile -t magic-mirror-api:test .",
      "run: bun run test",
      "run: bun run test:db",
      "run: supabase db lint --local",
      "run: bunx playwright install --with-deps chromium",
      "run: bun run test:e2e -- apps/web/e2e/smoke.spec.ts",
    ];

    for (const fragment of requiredFragments) expect(workflow).toContain(fragment);
    expect(workflow).not.toContain("storage-api");

    const commandOrder = [
      "bun install --frozen-lockfile",
      "bun run lint",
      "bun run typecheck",
      "if ! supabase start",
      "bun run db:reset",
      "docker build -f apps/api/Dockerfile -t magic-mirror-api:test .",
      "bun run test",
      "bun run test:db",
      "supabase db lint --local",
      "bunx playwright install --with-deps chromium",
      "bun run test:e2e -- apps/web/e2e/smoke.spec.ts",
    ].map((command) => workflow.indexOf(command));

    expect(commandOrder.every((position) => position >= 0)).toBe(true);
    expect(commandOrder).toEqual(
      [...commandOrder].sort((left, right) => left - right),
    );
    expect(workflow).not.toMatch(/^\s+(branches|paths):/m);
  });

  test("pins every external action to a full commit and grants read-only access", async () => {
    const workflow = await readWorkflow();
    const actionReferences = [...workflow.matchAll(/^\s+uses:\s+([^\s#]+)/gm)].map(
      (match) => match[1],
    );

    expect(actionReferences).toHaveLength(3);
    for (const reference of actionReferences) {
      expect(reference).toMatch(/^[\w.-]+\/[\w.-]+@[a-f0-9]{40}$/);
    }
    expect(workflow).toContain("permissions:\n  contents: read");
    expect(workflow).toContain("persist-credentials: false");
  });

  test("uses only public synthetic configuration and cannot bypass a failed gate", async () => {
    const workflow = await readWorkflow();
    const forbiddenPatterns = [
      /continue-on-error/,
      /\|\|\s*true/,
      /\$\{\{\s*secrets\./,
      /\b(?:printenv|set\s+-x)\b/,
      /\b(?:OPENAI_API_KEY|GEMINI_API_KEY|DECART_API_KEY)\b/,
      /\b(?:EMAIL_DELIVERY_API_KEY|SUPABASE_SERVICE_ROLE_KEY)\b/,
    ];

    for (const pattern of forbiddenPatterns) expect(workflow).not.toMatch(pattern);

    expect(workflow).toContain("VITE_API_BASE_URL: http://127.0.0.1:3000");
    expect(workflow).toContain("VITE_SUPABASE_URL: https://example.supabase.co");
    expect(workflow).toContain(
      "VITE_SUPABASE_PUBLISHABLE_KEY: ci-public-test-key",
    );
    expect(workflow).toContain('>"${start_log}" 2>&1');
    expect(workflow).not.toMatch(/\bcat\s+[^\n]*supabase-start\.log/);
  });

  test("backs the lint gate with one pinned development-only linter", async () => {
    const packageContract = parsePackageContract(
      await readFile(path.join(repositoryRoot, "package.json"), "utf8"),
    );

    expect(packageContract.scripts.lint).toBe(
      "oxlint --deny-warnings apps packages tests scripts playwright.config.ts vitest.config.ts",
    );
    expect(packageContract.scripts.check).toContain("bun run lint");
    expect(packageContract.devDependencies.oxlint).toBe("1.74.0");
  });

  test("the workflow unit command exits nonzero for a failing focused test", async () => {
    await writeFile(
      failingFixturePath,
      [
        'import { expect, test } from "vitest";',
        'test("intentional CI gate failure", () => expect("actual").toBe("expected"));',
        "",
      ].join("\n"),
      "utf8",
    );
    const result = spawnSync(
      "bun",
      ["run", "test", "--", "tests/__ci_failing_gate_fixture__.test.ts"],
      {
        cwd: repositoryRoot,
        encoding: "utf8",
        env: { ...process.env, CI: "1" },
      },
    );
    const output = `${result.stdout}\n${result.stderr}`;

    expect(result.status).not.toBe(0);
    expect(output).toContain("intentional CI gate failure");
  });
});
