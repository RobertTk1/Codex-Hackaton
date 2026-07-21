import { readFile } from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";

import { parse as parseYaml } from "yaml";

export type DeploymentEnvironment = "dev" | "prod";

export interface DeploymentTemplates {
  dev: string;
  prod: string;
}

const repositoryRoot = fileURLToPath(new URL("../", import.meta.url));
const templatePaths = {
  dev: path.join(repositoryRoot, "deploy", "digitalocean", "dev.yaml"),
  prod: path.join(repositoryRoot, "deploy", "digitalocean", "prod.yaml"),
} as const;

const serverSecretKeys = [
  "DECART_API_KEY",
  "EMAIL_DELIVERY_API_KEY",
  "EMAIL_FROM_ADDRESS",
  "GEMINI_API_KEY",
  "OPENAI_API_KEY",
  "SHOPIFY_AGENT_PROFILE_URL",
  "SUPABASE_SERVICE_ROLE_KEY",
  "VITE_SUPABASE_PUBLISHABLE_KEY",
  "VITE_SUPABASE_URL",
] as const;

const placeholderPattern = /\$\{([A-Za-z0-9_.-]+)\}/g;

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
  if (!Array.isArray(value)) {
    throw new Error(`${label} must be an array.`);
  }
  return value;
}

function exact(value: unknown, expected: unknown, label: string): void {
  if (value !== expected) {
    throw new Error(`${label} must equal ${JSON.stringify(expected)}.`);
  }
}

function oneComponent(spec: Record<string, unknown>, key: string): Record<string, unknown> {
  const components = array(spec[key], `${key}`);
  if (components.length !== 1) {
    throw new Error(`${key} must contain exactly one component.`);
  }
  return record(components[0], `${key}[0]`);
}

function namedComponent(
  spec: Record<string, unknown>,
  key: string,
  name: string,
  expectedCount: number,
): Record<string, unknown> {
  const components = array(spec[key], key);
  if (components.length !== expectedCount) {
    throw new Error(`${key} must contain exactly ${expectedCount} components.`);
  }
  const component = components
    .map((value, index) => record(value, `${key}[${index}]`))
    .find((value) => value.name === name);
  if (component === undefined) throw new Error(`${key} is missing ${name}.`);
  return component;
}

function envMap(component: Record<string, unknown>, label: string): Map<string, Record<string, unknown>> {
  const entries = array(component.envs, `${label}.envs`);
  const result = new Map<string, Record<string, unknown>>();
  for (const [index, value] of entries.entries()) {
    const entry = record(value, `${label}.envs[${index}]`);
    const key = string(entry.key, `${label}.envs[${index}].key`);
    if (result.has(key)) {
      throw new Error(`${label}.envs contains duplicate key ${key}.`);
    }
    result.set(key, entry);
  }
  return result;
}

function expectedReference(environment: DeploymentEnvironment, key: string): string {
  return `\${MAGIC_MIRROR_${environment.toUpperCase()}_${key}}`;
}

function requireEnvironmentReference(
  entries: Map<string, Record<string, unknown>>,
  environment: DeploymentEnvironment,
  key: string,
  scope: "BUILD_TIME" | "RUN_TIME",
  label: string,
): void {
  const entry = entries.get(key);
  if (entry === undefined) {
    throw new Error(`${label} is missing ${key}.`);
  }
  exact(entry.scope, scope, `${label}.${key}.scope`);
  exact(entry.type, "SECRET", `${label}.${key}.type`);
  exact(entry.value, expectedReference(environment, key), `${label}.${key}.value`);
}

function validateImage(
  component: Record<string, unknown>,
  environment: DeploymentEnvironment,
  label: string,
  repository: "magic-mirror-api" | "magic-mirror-web",
  digestKey: "API_IMAGE_DIGEST" | "WEB_IMAGE_DIGEST",
): string {
  const image = record(component.image, `${label}.image`);
  exact(image.registry_type, "DOCR", `${label}.image.registry_type`);
  exact(image.registry, "sageprovisioning", `${label}.image.registry`);
  exact(image.repository, repository, `${label}.image.repository`);
  if ("tag" in image) {
    throw new Error(`${label}.image must use an immutable digest, not a tag.`);
  }
  const digest = string(image.digest, `${label}.image.digest`);
  exact(
    digest,
    expectedReference(environment, digestKey),
    `${label}.image.digest`,
  );
  return digest;
}

function validateServerEnvironment(
  component: Record<string, unknown>,
  environment: DeploymentEnvironment,
  label: string,
): void {
  const entries = envMap(component, label);
  for (const key of serverSecretKeys) {
    requireEnvironmentReference(entries, environment, key, "RUN_TIME", label);
  }
  for (const key of ["APP_BASE_URL", "CORS_ALLOWED_ORIGINS"] as const) {
    const entry = entries.get(key);
    if (entry === undefined) throw new Error(`${label} is missing ${key}.`);
    exact(entry.scope, "RUN_TIME", `${label}.${key}.scope`);
    exact(entry.type, "GENERAL", `${label}.${key}.type`);
    exact(entry.value, "${APP_URL}", `${label}.${key}.value`);
  }
  const host = entries.get("HOST");
  if (host === undefined) throw new Error(`${label} is missing HOST.`);
  exact(host.scope, "RUN_TIME", `${label}.HOST.scope`);
  exact(host.type, "GENERAL", `${label}.HOST.type`);
  exact(host.value, "0.0.0.0", `${label}.HOST.value`);
}

function validateIngress(spec: Record<string, unknown>): void {
  const ingress = record(spec.ingress, "ingress");
  const rules = array(ingress.rules, "ingress.rules");
  const expected = [
    { component: "magic-mirror-api", prefix: "/api" },
    { component: "magic-mirror-web", prefix: "/" },
  ];
  if (rules.length !== expected.length) {
    throw new Error("ingress.rules must contain the API and web routes.");
  }
  for (const [index, expectation] of expected.entries()) {
    const rule = record(rules[index], `ingress.rules[${index}]`);
    const match = record(rule.match, `ingress.rules[${index}].match`);
    const matchPath = record(match.path, `ingress.rules[${index}].match.path`);
    const component = record(rule.component, `ingress.rules[${index}].component`);
    exact(matchPath.prefix, expectation.prefix, `ingress.rules[${index}].match.path.prefix`);
    exact(component.name, expectation.component, `ingress.rules[${index}].component.name`);
  }
}

export function parseDeploymentTemplate(source: string, label: string): Record<string, unknown> {
  let value: unknown;
  try {
    value = parseYaml(source);
  } catch {
    throw new Error(`${label} is not valid YAML.`);
  }
  return record(value, label);
}

export function validateDeploymentTemplate(
  source: string,
  environment: DeploymentEnvironment,
): void {
  const label = `${environment}.yaml`;
  const spec = parseDeploymentTemplate(source, label);
  exact(spec.name, `magic-mirror-${environment}`, `${label}.name`);
  string(spec.region, `${label}.region`);

  const web = namedComponent(spec, "services", "magic-mirror-web", 2);
  exact(web.http_port, 8080, `${label}.services.web.http_port`);
  const webHealth = record(web.health_check, `${label}.services.web.health_check`);
  exact(webHealth.http_path, "/healthz", `${label}.services.web.health_check.http_path`);
  validateImage(web, environment, `${label}.services.web`, "magic-mirror-web", "WEB_IMAGE_DIGEST");
  const webEnvironment = envMap(web, `${label}.services.web`);
  requireEnvironmentReference(webEnvironment, environment, "VITE_SUPABASE_URL", "RUN_TIME", label);
  requireEnvironmentReference(
    webEnvironment,
    environment,
    "VITE_SUPABASE_PUBLISHABLE_KEY",
    "RUN_TIME",
    label,
  );
  const apiUrl = webEnvironment.get("VITE_API_BASE_URL");
  if (apiUrl === undefined) throw new Error(`${label} is missing VITE_API_BASE_URL.`);
  exact(apiUrl.scope, "RUN_TIME", `${label}.VITE_API_BASE_URL.scope`);
  exact(apiUrl.type, "GENERAL", `${label}.VITE_API_BASE_URL.type`);
  exact(apiUrl.value, "${APP_URL}/api", `${label}.VITE_API_BASE_URL.value`);

  const api = namedComponent(spec, "services", "magic-mirror-api", 2);
  exact(api.http_port, 3000, `${label}.services.api.http_port`);
  exact(api.run_command, "bun server.js", `${label}.services.api.run_command`);
  const health = record(api.health_check, `${label}.services.api.health_check`);
  exact(health.http_path, "/healthz", `${label}.services.api.health_check.http_path`);
  const apiDigest = validateImage(
    api,
    environment,
    `${label}.services.api`,
    "magic-mirror-api",
    "API_IMAGE_DIGEST",
  );
  validateServerEnvironment(api, environment, `${label}.services.api`);

  const worker = oneComponent(spec, "workers");
  exact(worker.name, "magic-mirror-worker", `${label}.workers[0].name`);
  exact(worker.run_command, "bun worker.js", `${label}.workers[0].run_command`);
  const workerDigest = validateImage(
    worker,
    environment,
    `${label}.workers[0]`,
    "magic-mirror-api",
    "API_IMAGE_DIGEST",
  );
  exact(workerDigest, apiDigest, `${label} API/worker image digest`);
  validateServerEnvironment(worker, environment, `${label}.workers[0]`);
  validateIngress(spec);

  const oppositePrefix = environment === "dev" ? "MAGIC_MIRROR_PROD_" : "MAGIC_MIRROR_DEV_";
  if (source.includes(oppositePrefix)) {
    throw new Error(`${label} references the opposite environment.`);
  }
}

export function validateDeploymentTemplates(templates: DeploymentTemplates): void {
  validateDeploymentTemplate(templates.dev, "dev");
  validateDeploymentTemplate(templates.prod, "prod");
  const dev = parseDeploymentTemplate(templates.dev, "dev.yaml");
  const prod = parseDeploymentTemplate(templates.prod, "prod.yaml");
  if (dev.name === prod.name) throw new Error("Development and production app names must differ.");
  if (templates.dev.includes("vhpxxmefcuewkmukissr")) {
    throw new Error("Development spec must not reference the production Supabase project.");
  }
}

export function placeholderNames(source: string): string[] {
  return [...source.matchAll(placeholderPattern)].map((match) => match[1] ?? "");
}

export function renderDevelopmentTemplate(
  source: string,
  environment: Readonly<Record<string, string | undefined>>,
): string {
  validateDeploymentTemplate(source, "dev");
  return source.replaceAll(placeholderPattern, (placeholder, name: string) => {
    if (name === "APP_URL") return placeholder;
    const value = environment[name];
    if (value === undefined || value.length === 0) {
      throw new Error(`Missing required development deployment variable: ${name}.`);
    }
    if (value.includes("\n") || value.includes("\r")) {
      throw new Error(`Invalid development deployment variable: ${name}.`);
    }
    return JSON.stringify(value);
  });
}

export async function readDeploymentTemplates(): Promise<DeploymentTemplates> {
  const [dev, prod] = await Promise.all([
    readFile(templatePaths.dev, "utf8"),
    readFile(templatePaths.prod, "utf8"),
  ]);
  return { dev, prod };
}

if (import.meta.main) {
  try {
    const templates = await readDeploymentTemplates();
    validateDeploymentTemplates(templates);
    console.info(
      JSON.stringify({
        environments: ["magic-mirror-dev", "magic-mirror-prod"],
        status: "valid",
      }),
    );
  } catch (error) {
    const message = error instanceof Error ? error.message : "Unknown deployment validation error.";
    console.error(`Deployment validation failed: ${message}`);
    process.exit(1);
  }
}
