import { afterAll, beforeAll, describe, expect, test } from "vitest";
import { spawnSync } from "node:child_process";
import { rm, writeFile } from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";

const repositoryRoot = fileURLToPath(new URL("../../../", import.meta.url));
const imageName = "magic-mirror-web:test";
const containerName = `magic-mirror-web-eng152-${process.pid}`;
const secretProbePath = path.join(repositoryRoot, ".env.eng152-container-probe");
const secretSentinel = "eng152-server-secret-must-never-enter-image";

function runDocker(arguments_: string[], timeout = 30_000) {
  return spawnSync("docker", arguments_, {
    cwd: repositoryRoot,
    encoding: "utf8",
    env: {
      ...process.env,
      SUPABASE_SERVICE_ROLE_KEY: secretSentinel,
    },
    timeout,
  });
}

function dockerOutput(result: ReturnType<typeof runDocker>): string {
  return `${result.stdout ?? ""}\n${result.stderr ?? ""}`;
}

async function waitForWebContainer(): Promise<number> {
  let lastError = "container did not publish port 8080";

  for (let attempt = 0; attempt < 40; attempt += 1) {
    const portResult = runDocker(["port", containerName, "8080/tcp"]);
    const portLine = portResult.stdout?.trim().split("\n")[0];
    const portText = portLine?.split(":").at(-1);
    const port = portText === undefined ? Number.NaN : Number.parseInt(portText, 10);

    if (Number.isInteger(port)) {
      try {
        const response = await fetch(`http://127.0.0.1:${port}/healthz`);
        if (response.ok) return port;
        lastError = `health returned ${response.status}`;
      } catch (error) {
        lastError = error instanceof Error ? error.message : "health request failed";
      }
    }

    await new Promise((resolve) => setTimeout(resolve, 250));
  }

  const logs = runDocker(["logs", containerName]);
  throw new Error(`${lastError}\n${dockerOutput(logs)}`);
}

beforeAll(async () => {
  await writeFile(secretProbePath, `${secretSentinel}\n`, "utf8");
  const buildResult = runDocker(
    ["build", "-f", "apps/web/Dockerfile", "-t", imageName, "."],
    240_000,
  );
  expect(buildResult.status, dockerOutput(buildResult)).toBe(0);
}, 250_000);

afterAll(async () => {
  runDocker(["rm", "--force", containerName]);
  await rm(secretProbePath, { force: true });
});

describe("web production container", () => {
  test("contains no server secret in image metadata, history, or static files", () => {
    const inspectResult = runDocker(["image", "inspect", imageName]);
    const historyResult = runDocker(["history", "--no-trunc", imageName]);
    const filesystemResult = runDocker([
      "run",
      "--rm",
      "--entrypoint",
      "sh",
      imageName,
      "-c",
      `if grep -R -F '${secretSentinel}' /usr/share/nginx /etc/nginx /docker-entrypoint.d 2>/dev/null; then exit 1; fi`,
    ]);
    const userResult = runDocker(["image", "inspect", "--format", "{{.Config.User}}", imageName]);

    expect(inspectResult.status, dockerOutput(inspectResult)).toBe(0);
    expect(historyResult.status, dockerOutput(historyResult)).toBe(0);
    expect(filesystemResult.status, dockerOutput(filesystemResult)).toBe(0);
    expect(dockerOutput(inspectResult)).not.toContain(secretSentinel);
    expect(dockerOutput(historyResult)).not.toContain(secretSentinel);
    expect(userResult.stdout?.trim()).toBe("101:101");
  });

  test("serves health, runtime configuration, and browser routes", async () => {
    const runResult = runDocker([
      "run",
      "--detach",
      "--name",
      containerName,
      "--publish-all",
      "--env",
      "VITE_API_BASE_URL=https://api.magicmirror.test",
      "--env",
      "VITE_SUPABASE_URL=https://project.supabase.co",
      "--env",
      "VITE_SUPABASE_PUBLISHABLE_KEY=synthetic-public-key",
      "--env",
      `SUPABASE_SERVICE_ROLE_KEY=${secretSentinel}`,
      imageName,
    ]);
    expect(runResult.status, dockerOutput(runResult)).toBe(0);

    const port = await waitForWebContainer();
    const healthResponse = await fetch(`http://127.0.0.1:${port}/healthz`);
    const runtimeResponse = await fetch(`http://127.0.0.1:${port}/runtime-config.js`);
    const routeResponse = await fetch(`http://127.0.0.1:${port}/reports/latest`);
    const runtimeBody = await runtimeResponse.text();
    const routeBody = await routeResponse.text();

    expect(await healthResponse.json()).toEqual({ status: "ok", component: "web" });
    expect(healthResponse.headers.get("cache-control")).toBe("no-store");
    expect(runtimeResponse.status).toBe(200);
    expect(runtimeResponse.headers.get("cache-control")).toBe("no-store");
    expect(runtimeBody).toContain(Buffer.from("https://api.magicmirror.test").toString("base64"));
    expect(runtimeBody).toContain(Buffer.from("https://project.supabase.co").toString("base64"));
    expect(runtimeBody).toContain(Buffer.from("synthetic-public-key").toString("base64"));
    expect(runtimeBody).not.toContain(secretSentinel);
    expect(routeResponse.status).toBe(200);
    expect(routeBody).toContain('<div id="root"></div>');

    const uidResult = runDocker(["exec", containerName, "id", "-u"]);
    expect(uidResult.stdout?.trim()).toBe("101");
  }, 30_000);

  test("fails startup safely when required public configuration is missing", () => {
    const result = runDocker([
      "run",
      "--rm",
      "--env",
      `SUPABASE_SERVICE_ROLE_KEY=${secretSentinel}`,
      imageName,
    ]);
    const output = dockerOutput(result);

    expect(result.status).not.toBe(0);
    expect(output).toContain("Missing required browser environment variable: VITE_API_BASE_URL");
    expect(output).not.toContain(secretSentinel);
  });
});
