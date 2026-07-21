#!/usr/bin/env bun

import { createHash } from "node:crypto";
import { access, readFile } from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";

const scriptDirectory = path.dirname(fileURLToPath(import.meta.url));
const workflowRoot = path.resolve(scriptDirectory, "..");
const repositoryRoot = path.resolve(workflowRoot, "../../..");

const requiredProjectPaths = [
  "company/company.md",
  "company/plan.md",
  "company/build-notes.md",
  "company/voice.md",
  "company/artifacts/prd/prd.md",
  "company/artifacts/prd/user-stories.json",
  "company/artifacts/prd/scenarios.feature",
  "company/artifacts/prd/screens.json",
  "company/artifacts/build-plan/build-plan.md",
  "company/artifacts/ui-ux-design/wireframe-manifest.json",
  "company/artifacts/copy/copy-manifest.json",
  "company/artifacts/screen-mockups/design-direction.md",
  "company/artifacts/screen-mockups/interaction-specs",
  "company/artifacts/screen-mockups/screens",
  "company/artifacts/screen-mockups/mockup-manifest.json",
  "company/artifacts/screen-mockups-v2/conversational-onboarding/design-direction.md",
  "company/artifacts/screen-mockups-v2/conversational-onboarding/copy-manifest.json",
  "company/artifacts/screen-mockups-v2/conversational-onboarding/interaction-specs",
  "company/artifacts/screen-mockups-v2/conversational-onboarding/screens",
  "company/artifacts/screen-mockups-v2/conversational-onboarding/mockup-manifest.json",
  "company/brand/README.md",
  "company/brand/brandbook-packet/DESIGN.md",
  "company/brand/brandbook-packet/tokens/brand-tokens.json",
  "company/brand/brandbook-packet/tokens/brand-tokens.css",
  "company/brand/brandbook-packet/assets/fonts",
  "company/brand/exports/manifest.json",
  "company/brand/exports",
  "company/artifacts/engineering-plan/engineering-plan.json",
  "company/artifacts/engineering-plan/implementation-readiness.json",
  "company/artifacts/engineering-plan/architecture",
  "company/artifacts/engineering-plan/contracts",
  ".env.example"
];

const installedSkillPaths = [
  "/Users/talishawhite/.codex/plugins/cache/openai-curated-remote/supabase/1.0.0/skills/supabase/SKILL.md",
  "/Users/talishawhite/.codex/plugins/cache/openai-curated-remote/supabase/1.0.0/skills/supabase-postgres-best-practices/SKILL.md",
  "/Users/talishawhite/.codex/skills/frontend-design/SKILL.md",
  "/Users/talishawhite/.codex/skills/.system/imagegen/SKILL.md",
  "/Users/talishawhite/.codex/skills/imagegen-frontend-web/SKILL.md",
  "/Users/talishawhite/.codex/skills/mayven-taste/SKILL.md",
  "/Users/talishawhite/gstack/.agents/skills/gstack-qa/SKILL.md",
  "/Users/talishawhite/gstack/.agents/skills/gstack-qa-only/SKILL.md",
  "/Users/talishawhite/gstack/.agents/skills/gstack-design-review/SKILL.md",
  "/Users/talishawhite/gstack/.agents/skills/gstack-investigate/SKILL.md",
  "/Users/talishawhite/gstack/.agents/skills/gstack-cso/SKILL.md",
  "/Users/talishawhite/gstack/.agents/skills/gstack-review/SKILL.md",
  "/Users/talishawhite/gstack/.agents/skills/gstack-benchmark/SKILL.md",
  "/Users/talishawhite/.codex/plugins/cache/openai-bundled/browser/26.715.31251/skills/control-in-app-browser/SKILL.md",
  "/Users/talishawhite/gstack/.agents/skills/gstack-setup-deploy/SKILL.md",
  "/Users/talishawhite/gstack/.agents/skills/gstack-land-and-deploy/SKILL.md",
  "/Users/talishawhite/gstack/.agents/skills/gstack-canary/SKILL.md",
  "/Users/talishawhite/gstack/.agents/skills/gstack-document-release/SKILL.md"
];

const sha256 = (value) => createHash("sha256").update(value).digest("hex");
const failures = [];

for (const relativePath of requiredProjectPaths) {
  try {
    await access(path.join(repositoryRoot, relativePath));
  } catch {
    failures.push(`missing project source: ${relativePath}`);
  }
}

for (const skillPath of installedSkillPaths) {
  try {
    await access(skillPath);
  } catch {
    failures.push(`missing installed skill: ${skillPath}`);
  }
}

const planSource = await readFile(path.join(repositoryRoot, "company/artifacts/engineering-plan/engineering-plan.json"), "utf8");
const plan = JSON.parse(planSource);
const readinessSource = await readFile(path.join(repositoryRoot, "company/artifacts/engineering-plan/implementation-readiness.json"), "utf8");
const index = JSON.parse(await readFile(path.join(workflowRoot, "ticket-index.json"), "utf8"));
const workflowState = JSON.parse(await readFile(path.join(workflowRoot, "tasks.json"), "utf8"));
const canonicalManifest = JSON.parse(await readFile(path.join(repositoryRoot, "company/artifacts/screen-mockups/mockup-manifest.json"), "utf8"));
const v2Manifest = JSON.parse(await readFile(path.join(repositoryRoot, "company/artifacts/screen-mockups-v2/conversational-onboarding/mockup-manifest.json"), "utf8"));
const sourcesContract = await readFile(path.join(workflowRoot, "references/sources.md"), "utf8");
const stateContract = await readFile(path.join(workflowRoot, "references/state-contract.md"), "utf8");
const ticketSelectionContract = await readFile(path.join(workflowRoot, "developer/references/ticket-selection.md"), "utf8");
const releaseRequirements = await readFile(path.join(workflowRoot, "devops/references/requirements.md"), "utf8");
const releaseQueueContract = await readFile(path.join(workflowRoot, "devops/references/release-queue.md"), "utf8");

if (plan.status !== "approved") failures.push(`engineering plan status is ${plan.status}, expected approved`);
if (workflowState.loop_status !== "active") failures.push(`loop status is ${workflowState.loop_status}, expected active`);
if (workflowState.execution_queue?.stage !== workflowState.current_stage) {
  failures.push("execution queue stage differs from current_stage");
}
for (const [gateId, gate] of Object.entries(workflowState.stage_gates ?? {})) {
  if (gate?.status !== "defined" || !gate.authority || !gate.pass_signal || !gate.next_stage) {
    failures.push(`${gateId} does not define status, authority, pass_signal, and next_stage`);
  }
}
if (Object.keys(workflowState.stage_gates ?? {}).length !== 3) failures.push("expected exactly three stage gates");
for (const loopTask of workflowState.tasks ?? []) {
  if (!["pending", "in_progress", "blocked", "complete"].includes(loopTask.status)) {
    failures.push(`${loopTask.id} has invalid workflow status ${loopTask.status}`);
  }
}
for (const contractTaskId of ["LC-001", "LC-002", "LC-003", "LC-004"]) {
  const contractTask = workflowState.tasks?.find((item) => item.id === contractTaskId);
  if (contractTask?.status !== 'complete') failures.push(`${contractTaskId} is not reconciled as complete`);
}
if (index.source_plan_sha256 !== sha256(planSource)) failures.push("ticket index plan fingerprint is stale");
if (index.source_readiness_sha256 !== sha256(readinessSource)) failures.push("ticket index readiness fingerprint is stale");
if (index.ticket_count !== plan.tickets.length) failures.push("ticket index count differs from engineering plan");
if (canonicalManifest.status !== "approved-with-archived-pre-report") failures.push(`canonical mockup status is ${canonicalManifest.status}`);
if (v2Manifest.status !== "approved-for-pre-report") failures.push(`v2 mockup status is ${v2Manifest.status}`);
if (!sourcesContract.includes("git rev-parse --show-toplevel") || !sourcesContract.includes("apps/web") || !sourcesContract.includes("apps/api")) {
  failures.push("repository/application roots are not explicit in sources.md");
}
if (sourcesContract.includes("Project Paths to Confirm")) failures.push("sources.md still contains unresolved project-path placeholders");
if (!stateContract.includes("Controller and Gate Shape")) failures.push("state contract lacks the controller/gate shape");
if (!ticketSelectionContract.includes("Stale-Claim Recovery") || !ticketSelectionContract.includes("two hours")) {
  failures.push("ticket selection lacks bounded stale-claim recovery");
}
if (!releaseRequirements.includes("at most three") || !releaseRequirements.includes("never automatically retried")) {
  failures.push("DevOps requirements lack bounded retry rules");
}
if (!releaseQueueContract.includes("provision `magic-mirror-prod`")) {
  failures.push("release queue does not own production-app provisioning");
}

for (const ticket of plan.tickets) {
  for (const resourcePath of [
    ...(ticket.resources?.architecture ?? []),
    ...(ticket.resources?.contracts ?? []),
    ...(ticket.resources?.design ?? [])
  ]) {
    try {
      await access(path.join(repositoryRoot, resourcePath));
    } catch {
      failures.push(`${ticket.id} missing resource: ${resourcePath}`);
    }
  }
}

const branchResult = Bun.spawnSync(["git", "branch", "--show-current"], { cwd: repositoryRoot });
const branch = branchResult.stdout.toString().trim();
const rootResult = Bun.spawnSync(["git", "rev-parse", "--show-toplevel"], { cwd: repositoryRoot });
const resolvedRoot = rootResult.stdout.toString().trim();
if (resolvedRoot !== repositoryRoot) failures.push(`resolved repository root ${JSON.stringify(resolvedRoot)} differs from ${JSON.stringify(repositoryRoot)}`);
const validBranch = /^(codex\/engineering-execution|codex\/(eng-[0-9]+|qa-[a-f0-9]+|release-[a-z0-9-]+|fix-[a-z0-9-]+)(-[a-z0-9-]+)?)$/.test(branch);
if (!validBranch) failures.push(`branch ${JSON.stringify(branch)} does not match the execution branch contract`);

if (failures.length > 0) {
  console.error(JSON.stringify({ valid: false, failures }, null, 2));
  process.exitCode = 1;
} else {
  console.log(JSON.stringify({
    valid: true,
    branch,
    project_sources: requiredProjectPaths.length,
    installed_skills: installedSkillPaths.length,
    tickets: plan.tickets.length,
    next_ticket_id: index.next_ticket_id,
    optional_skill: {
      id: "micro-interactions",
      status: "installable-not-installed",
      source: "https://github.com/dylantarre/animation-principles/tree/main/skills/01-by-domain/micro-interactions"
    }
  }, null, 2));
}
