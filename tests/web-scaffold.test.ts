import { afterEach, describe, expect, test } from "bun:test";
import { access, readFile, rm, writeFile } from "node:fs/promises";
import path from "node:path";

const repositoryRoot = path.join(import.meta.dir, "..");
const invalidComponentPath = path.join(repositoryRoot, "apps", "web", "src", "__invalid_typecheck_fixture__.tsx");

afterEach(async () => {
  await rm(invalidComponentPath, { force: true });
});

function runRootScript(script: string) {
  return Bun.spawnSync(["bun", "run", script], {
    cwd: repositoryRoot,
    env: { ...process.env, CI: "1" },
    stderr: "pipe",
    stdout: "pipe"
  });
}

describe("Vite web scaffold", () => {
  test("build:web emits a production HTML bundle", async () => {
    const result = runRootScript("build:web");
    const output = `${result.stdout.toString()}\n${result.stderr.toString()}`;

    expect(result.exitCode, output).toBe(0);
    await access(path.join(repositoryRoot, "apps", "web", "dist", "index.html"));
    const builtHtml = await readFile(path.join(repositoryRoot, "apps", "web", "dist", "index.html"), "utf8");
    expect(builtHtml).toContain('<div id="root"></div>');
    expect(builtHtml).toMatch(/assets\/index-[^"']+\.js/);
  });

  test("typecheck:web rejects an invalid TypeScript component", async () => {
    await writeFile(
      invalidComponentPath,
      "export function InvalidComponent() { return <div>{missingValue}</div>; }\n",
      "utf8"
    );

    const result = runRootScript("typecheck:web");
    const output = `${result.stdout.toString()}\n${result.stderr.toString()}`;

    expect(result.exitCode).not.toBe(0);
    expect(output).toContain("Cannot find name 'missingValue'");
  });
});
