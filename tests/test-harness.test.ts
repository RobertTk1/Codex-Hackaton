import { afterEach, describe, expect, test } from "vitest";
import { spawnSync } from "node:child_process";
import { rm, writeFile } from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";

const repositoryRoot = fileURLToPath(new URL("../", import.meta.url));
const failingFixturePath = path.join(
  repositoryRoot,
  "tests",
  "__failing_assertion_fixture__.test.ts",
);

afterEach(async () => {
  await rm(failingFixturePath, { force: true });
});

describe("repository test harness", () => {
  // Given a failing assertion, when the root test command runs it, then it fails.
  test("a failing assertion returns a nonzero status", async () => {
    await writeFile(
      failingFixturePath,
      [
        'import { expect, test } from "vitest";',
        'test("intentional harness failure", () => expect("actual").toBe("expected"));',
        "",
      ].join("\n"),
      "utf8",
    );

    const result = spawnSync(
      "bun",
      ["run", "test", "--", "tests/__failing_assertion_fixture__.test.ts"],
      {
        cwd: repositoryRoot,
        encoding: "utf8",
        env: { ...process.env, CI: "1" },
      },
    );
    const output = `${result.stdout}\n${result.stderr}`;

    expect(result.status).not.toBe(0);
    expect(output).toContain("intentional harness failure");
  });
});
