import { mkdtemp, rm, writeFile } from "node:fs/promises";
import os from "node:os";
import path from "node:path";

import {
  readDeploymentTemplates,
  renderDevelopmentTemplate,
  validateDeploymentTemplates,
} from "./validate-deploy";

const developmentAppName = "magic-mirror-dev";
const deploymentTimeoutMilliseconds = 20 * 60 * 1_000;

type DevelopmentCommand = "apply" | "rollback" | "status";

interface SafeAppState {
  activeDeploymentId: string;
  appId: string;
  componentNames: string[];
  defaultIngress: string;
  phase: string;
}

function record(value: unknown, label: string): Record<string, unknown> {
  if (typeof value !== "object" || value === null || Array.isArray(value)) {
    throw new Error(`${label} must be an object.`);
  }
  return Object.fromEntries(Object.entries(value));
}

function string(value: unknown, label: string): string {
  if (typeof value !== "string" || value.length === 0) {
    throw new Error(`${label} must be a non-empty string.`);
  }
  return value;
}

function array(value: unknown, label: string): unknown[] {
  if (!Array.isArray(value)) throw new Error(`${label} must be an array.`);
  return value;
}

function parseJson(source: string, label: string): unknown {
  try {
    return JSON.parse(source);
  } catch {
    throw new Error(`${label} returned an invalid response.`);
  }
}

type DoctlOutput = "json" | "text";

export function parseDoctlOutput(source: string, output: DoctlOutput): unknown {
  if (output === "text") {
    if (source.trim().length === 0) throw new Error("DigitalOcean CLI returned an empty response.");
    return source;
  }
  const value = parseJson(source, "DigitalOcean CLI");
  if (typeof value === "object" && value !== null && !Array.isArray(value)) {
    const errors = Reflect.get(value, "errors");
    if (Array.isArray(errors) && errors.length > 0) {
      throw new Error("DigitalOcean CLI returned an API error response.");
    }
  }
  return value;
}

async function runDoctl(arguments_: string[], output: DoctlOutput = "json"): Promise<unknown> {
  const outputArguments = output === "json" ? ["--output", "json"] : [];
  const process = Bun.spawn(["doctl", ...arguments_, ...outputArguments], {
    stderr: "pipe",
    stdout: "pipe",
  });
  const [stdout, exitCode] = await Promise.all([new Response(process.stdout).text(), process.exited]);
  if (exitCode !== 0) {
    throw new Error(`DigitalOcean command failed at ${arguments_.slice(0, 2).join(" ")}.`);
  }
  return parseDoctlOutput(stdout, output);
}

export function appState(value: unknown): SafeAppState {
  const values = Array.isArray(value) ? value : [value];
  const candidate = values
    .map((entry, index) => record(entry, `apps[${index}]`))
    .find((entry) => {
      const spec = record(entry.spec, "app.spec");
      return spec.name === developmentAppName;
    });
  if (candidate === undefined) throw new Error(`${developmentAppName} does not exist.`);
  const spec = record(candidate.spec, "app.spec");
  const deployment = record(candidate.active_deployment, "app.active_deployment");
  const componentNames = ["static_sites", "services", "workers"].flatMap((key) =>
    (spec[key] === undefined ? [] : array(spec[key], `app.spec.${key}`)).map((component, index) =>
      string(record(component, `app.spec.${key}[${index}]`).name, `app.spec.${key}[${index}].name`),
    ),
  );
  return {
    activeDeploymentId: string(deployment.id, "app.active_deployment.id"),
    appId: string(candidate.id, "app.id"),
    componentNames,
    defaultIngress: string(candidate.default_ingress, "app.default_ingress"),
    phase: string(deployment.phase, "app.active_deployment.phase"),
  };
}

export function findDevelopmentAppId(value: unknown): string | null {
  const values = array(value, "apps");
  const match = values.find((entry, index) => {
    const app = record(entry, `apps[${index}]`);
    return record(app.spec, `apps[${index}].spec`).name === developmentAppName;
  });
  return match === undefined ? null : string(record(match, "development app").id, "development app.id");
}

async function findDevelopmentAppIdFromApi(): Promise<string | null> {
  return findDevelopmentAppId(await runDoctl(["apps", "list"]));
}

async function currentDevelopmentApp(): Promise<SafeAppState> {
  const appId = await findDevelopmentAppIdFromApi();
  if (appId === null) throw new Error(`${developmentAppName} does not exist.`);
  return appState(await runDoctl(["apps", "get", appId]));
}

async function withRenderedSpec<T>(action: (specPath: string) => Promise<T>): Promise<T> {
  const templates = await readDeploymentTemplates();
  validateDeploymentTemplates(templates);
  const rendered = renderDevelopmentTemplate(templates.dev, Bun.env);
  const temporaryDirectory = await mkdtemp(path.join(os.tmpdir(), "magic-mirror-dev-spec-"));
  const specPath = path.join(temporaryDirectory, "dev.yaml");
  await writeFile(specPath, rendered, { encoding: "utf8", mode: 0o600 });
  try {
    return await action(specPath);
  } finally {
    await rm(temporaryDirectory, { force: true, recursive: true });
  }
}

async function verifyHttp(url: string, label: string): Promise<void> {
  const response = await fetch(url, { signal: AbortSignal.timeout(15_000) });
  if (!response.ok) throw new Error(`${label} returned HTTP ${response.status}.`);
}

async function verifyHealthy(app: SafeAppState): Promise<void> {
  if (app.phase !== "ACTIVE") throw new Error(`${developmentAppName} is not active.`);
  const expectedComponents = ["magic-mirror-api", "magic-mirror-web", "magic-mirror-worker"];
  if (!expectedComponents.every((name) => app.componentNames.includes(name))) {
    throw new Error(`${developmentAppName} is missing an expected component.`);
  }
  await verifyHttp(`${app.defaultIngress}/`, "Development web health");
  await verifyHttp(`${app.defaultIngress}/api/healthz`, "Development API health");
  await verifyHttp(`${app.defaultIngress}/api/readyz`, "Development API readiness");
}

async function applyDevelopment(): Promise<SafeAppState> {
  return withRenderedSpec(async (specPath) => {
    // `doctl apps spec validate` emits a normalized YAML spec even when a global
    // JSON output flag is supplied. Treat successful validation as opaque text;
    // every command whose response we inspect remains strict JSON.
    await runDoctl(["apps", "spec", "validate", specPath, "--schema-only"], "text");
    await runDoctl(["apps", "spec", "validate", specPath], "text");
    const existingAppId = await findDevelopmentAppIdFromApi();
    if (existingAppId === null) {
      await runDoctl(["apps", "create", "--spec", specPath, "--wait"]);
    } else {
      await runDoctl([
        "apps",
        "update",
        existingAppId,
        "--spec",
        specPath,
        "--update-sources",
        "--wait",
      ]);
    }
    const active = await currentDevelopmentApp();
    await verifyHealthy(active);
    return active;
  });
}

function developmentToken(): string {
  const token = Bun.env.DIGITALOCEAN_ACCESS_TOKEN;
  if (token === undefined || token.length === 0) {
    throw new Error("Missing required development deployment variable: DIGITALOCEAN_ACCESS_TOKEN.");
  }
  return token;
}

async function digitalOceanPost(pathname: string, body?: Record<string, string>): Promise<unknown> {
  const request: RequestInit = {
    headers: {
      Authorization: `Bearer ${developmentToken()}`,
      "Content-Type": "application/json",
    },
    method: "POST",
    signal: AbortSignal.timeout(30_000),
  };
  if (body !== undefined) request.body = JSON.stringify(body);
  const response = await fetch(`https://api.digitalocean.com${pathname}`, request);
  if (!response.ok) {
    throw new Error(`DigitalOcean rollback request failed at ${pathname} with HTTP ${response.status}.`);
  }
  const source = await response.text();
  return source.length === 0 ? {} : parseJson(source, "DigitalOcean API");
}

export function assertSafeRollbackValidation(value: unknown): void {
  const validation = record(value, "rollback validation");
  if (validation.valid !== true) {
    throw new Error("DigitalOcean rejected the development rollback target.");
  }
  const warnings = validation.warnings === undefined ? [] : array(validation.warnings, "rollback warnings");
  for (const [index, warningValue] of warnings.entries()) {
    const warning = record(warningValue, `rollback warnings[${index}]`);
    const code = string(warning.code, `rollback warnings[${index}].code`);
    if (code !== "static_site_requires_rebuild") {
      throw new Error(`Development rollback has unsafe warning code: ${code}.`);
    }
  }
}

function deployment(value: unknown): Record<string, unknown> {
  const values = Array.isArray(value) ? value : [value];
  if (values.length !== 1) throw new Error("DigitalOcean deployment response is ambiguous.");
  return record(values[0], "deployment");
}

async function waitForDeployment(appId: string, deploymentId: string): Promise<void> {
  const startedAt = Date.now();
  while (Date.now() - startedAt < deploymentTimeoutMilliseconds) {
    const current = deployment(await runDoctl(["apps", "get-deployment", appId, deploymentId]));
    const phase = string(current.phase, "deployment.phase");
    if (phase === "ACTIVE") return;
    if (["CANCELED", "ERROR", "SUPERSEDED"].includes(phase)) {
      throw new Error(`Development rollback deployment ended in ${phase}.`);
    }
    await Bun.sleep(5_000);
  }
  throw new Error("Development rollback deployment timed out.");
}

async function rollbackDevelopment(targetDeploymentId: string): Promise<SafeAppState> {
  if (!/^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(targetDeploymentId)) {
    throw new Error("Rollback target must be a deployment UUID.");
  }
  const app = await currentDevelopmentApp();
  const target = deployment(
    await runDoctl(["apps", "get-deployment", app.appId, targetDeploymentId]),
  );
  if (target.phase !== "ACTIVE") throw new Error("Rollback target is not a previously healthy deployment.");
  assertSafeRollbackValidation(
    await digitalOceanPost(`/v2/apps/${app.appId}/rollback/validate`, {
      deployment_id: targetDeploymentId,
    }),
  );
  const rollback = record(
    await digitalOceanPost(`/v2/apps/${app.appId}/rollback`, {
      deployment_id: targetDeploymentId,
    }),
    "rollback",
  );
  const rollbackDeployment = record(rollback.deployment, "rollback.deployment");
  const rollbackDeploymentId = string(rollbackDeployment.id, "rollback.deployment.id");
  await waitForDeployment(app.appId, rollbackDeploymentId);
  const active = await currentDevelopmentApp();
  await verifyHealthy(active);
  await digitalOceanPost(`/v2/apps/${app.appId}/rollback/commit`);
  return active;
}

export function assertDevelopmentOnlyInvocation(arguments_: string[]): {
  command: DevelopmentCommand;
  targetDeploymentId?: string;
} {
  if (arguments_.some((argument) => argument.toLowerCase().includes("prod"))) {
    throw new Error("Developer deployment commands cannot target magic-mirror-prod.");
  }
  const [command, targetDeploymentId, ...extras] = arguments_;
  if (extras.length > 0 || (command !== "apply" && command !== "rollback" && command !== "status")) {
    throw new Error("Usage: deploy-development.ts <apply|status|rollback DEPLOYMENT_ID>.");
  }
  if (command === "rollback" && targetDeploymentId === undefined) {
    throw new Error("Rollback requires a development deployment ID.");
  }
  if (command !== "rollback" && targetDeploymentId !== undefined) {
    throw new Error(`${command} does not accept a deployment target.`);
  }
  return targetDeploymentId === undefined ? { command } : { command, targetDeploymentId };
}

if (import.meta.main) {
  try {
    const invocation = assertDevelopmentOnlyInvocation(Bun.argv.slice(2));
    const state =
      invocation.command === "apply"
        ? await applyDevelopment()
        : invocation.command === "rollback"
          ? await rollbackDevelopment(invocation.targetDeploymentId ?? "")
          : await currentDevelopmentApp();
    if (invocation.command === "status") await verifyHealthy(state);
    console.info(
      JSON.stringify({
        activeDeploymentId: state.activeDeploymentId,
        appId: state.appId,
        components: state.componentNames,
        defaultIngress: state.defaultIngress,
        operation: invocation.command,
        phase: state.phase,
        target: developmentAppName,
      }),
    );
  } catch (error) {
    const message = error instanceof Error ? error.message : "Unknown development deployment error.";
    console.error(`Development deployment failed: ${message}`);
    process.exit(1);
  }
}
