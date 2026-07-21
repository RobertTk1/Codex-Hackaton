import { afterEach, describe, expect, test } from "vitest";
import { spawnSync } from "node:child_process";
import { access, mkdtemp, readFile, rm, writeFile } from "node:fs/promises";
import { tmpdir } from "node:os";
import path from "node:path";
import { fileURLToPath } from "node:url";

const repositoryRoot = fileURLToPath(new URL("../../../", import.meta.url));
const invalidComponentPath = path.join(
  repositoryRoot,
  "apps",
  "web",
  "src",
  "__invalid_typecheck_fixture__.tsx",
);
const temporaryDirectories: string[] = [];

afterEach(async () => {
  await rm(invalidComponentPath, { force: true });
  await Promise.all(
    temporaryDirectories.splice(0).map((directory) =>
      rm(directory, { force: true, recursive: true })
    ),
  );
});

function runRootScript(script: string, environment: Record<string, string> = {}) {
  return spawnSync("bun", ["run", script], {
    cwd: repositoryRoot,
    encoding: "utf8",
    env: { ...process.env, ...environment, CI: "1" },
  });
}

describe("web smoke", () => {
  // Given the web scaffold, when it builds, then it emits a loadable HTML entry.
  test("build:web emits a production HTML bundle", async () => {
    const outputDirectory = await mkdtemp(path.join(tmpdir(), "magic-mirror-web-smoke-"));
    temporaryDirectories.push(outputDirectory);
    const result = runRootScript("build:web", {
      MAGIC_MIRROR_WEB_OUT_DIR: outputDirectory,
    });
    const output = `${result.stdout}\n${result.stderr}`;

    expect(result.status, output).toBe(0);
    await access(path.join(outputDirectory, "index.html"));
    const builtHtml = await readFile(
      path.join(outputDirectory, "index.html"),
      "utf8",
    );
    expect(builtHtml).toContain('<div id="root"></div>');
    expect(builtHtml).toMatch(/assets\/index-[^"']+\.js/);
  });

  // Given invalid application TypeScript, when checked, then the command fails.
  test("typecheck:web rejects an invalid TypeScript component", async () => {
    await writeFile(
      invalidComponentPath,
      "export function InvalidComponent() { return <div>{missingValue}</div>; }\n",
      "utf8",
    );

    const result = runRootScript("typecheck:web");
    const output = `${result.stdout}\n${result.stderr}`;

    expect(result.status).not.toBe(0);
    expect(output).toContain("Cannot find name 'missingValue'");
  });
});
