import { afterEach, describe, expect, test } from "bun:test";
import { copyFile, mkdir, mkdtemp, readFile, rm, writeFile } from "node:fs/promises";
import { tmpdir } from "node:os";
import path from "node:path";

const temporaryDirectories: string[] = [];

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null && !Array.isArray(value);
}

afterEach(async () => {
  await Promise.all(temporaryDirectories.splice(0).map((directory) => rm(directory, { force: true, recursive: true })));
});

describe("root Bun workspace", () => {
  test("declares the approved application and package workspace globs", async () => {
    const packageJson: unknown = JSON.parse(
      await readFile(path.join(import.meta.dir, "..", "package.json"), "utf8")
    );
    if (!isRecord(packageJson)) throw new Error("Root package.json must contain an object.");

    expect(packageJson.private).toBe(true);
    expect(packageJson.workspaces).toEqual(["apps/*", "packages/*"]);
  });

  test("bun install fails when an explicit workspace package is missing", async () => {
    const fixtureRoot = await mkdtemp(path.join(tmpdir(), "magic-mirror-workspace-"));
    temporaryDirectories.push(fixtureRoot);
    const fixtureScripts = path.join(fixtureRoot, "scripts");
    await mkdir(fixtureScripts);
    await copyFile(
      path.join(import.meta.dir, "..", "scripts", "validate-workspaces.ts"),
      path.join(fixtureScripts, "validate-workspaces.ts")
    );
    await writeFile(
      path.join(fixtureRoot, "package.json"),
      `${JSON.stringify({
        name: "missing-workspace-fixture",
        private: true,
        workspaces: ["packages/missing"],
        scripts: { preinstall: "bun scripts/validate-workspaces.ts" }
      }, null, 2)}\n`,
      "utf8"
    );

    const result = Bun.spawnSync(["bun", "install"], {
      cwd: fixtureRoot,
      env: { ...process.env, CI: "1" },
      stderr: "pipe",
      stdout: "pipe"
    });
    const output = `${result.stdout.toString()}\n${result.stderr.toString()}`;

    expect(result.exitCode).not.toBe(0);
    expect(output).toContain('Workspace not found "packages/missing"');
  });
});
