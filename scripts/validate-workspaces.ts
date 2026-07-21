#!/usr/bin/env bun

import { access, readFile } from "node:fs/promises";
import path from "node:path";

const globCharacters = /[*?{}[\]]/;

function fail(message: string): never {
  throw new Error(`Invalid workspace configuration: ${message}`);
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null && !Array.isArray(value);
}

export async function validateWorkspaceConfig(packageJsonPath = path.join(process.cwd(), "package.json")) {
  const root = path.dirname(packageJsonPath);
  const parsedPackageJson: unknown = JSON.parse(await readFile(packageJsonPath, "utf8"));
  if (!isRecord(parsedPackageJson)) {
    fail("package.json must contain an object");
  }

  const workspaces = parsedPackageJson.workspaces;
  if (!Array.isArray(workspaces) || workspaces.length === 0) {
    fail("package.json must declare a non-empty workspaces array");
  }

  const seen = new Set<string>();
  for (const workspace of workspaces) {
    if (typeof workspace !== "string" || workspace.trim() !== workspace || workspace.length === 0) {
      fail("each workspace must be a non-empty, trimmed string");
    }
    if (path.isAbsolute(workspace) || workspace.split("/").includes("..")) {
      fail(`workspace must stay inside the repository: ${workspace}`);
    }
    if (seen.has(workspace)) {
      fail(`duplicate workspace entry: ${workspace}`);
    }
    seen.add(workspace);

    if (!globCharacters.test(workspace)) {
      const workspacePackage = path.join(root, workspace, "package.json");
      try {
        await access(workspacePackage);
      } catch {
        fail(`workspace package does not exist: ${workspace}`);
      }
    }
  }

  return workspaces;
}

if (import.meta.main) {
  await validateWorkspaceConfig();
  console.log("Workspace configuration is valid.");
}
