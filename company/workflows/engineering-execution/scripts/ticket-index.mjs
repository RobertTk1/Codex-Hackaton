#!/usr/bin/env bun

import { createHash } from "node:crypto";
import { readFile, rename, writeFile } from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";

const scriptDirectory = path.dirname(fileURLToPath(import.meta.url));
const workflowRoot = path.resolve(scriptDirectory, "..");
const repositoryRoot = path.resolve(workflowRoot, "../../..");
const planPath = path.join(repositoryRoot, "company/artifacts/engineering-plan/engineering-plan.json");
const readinessPath = path.join(repositoryRoot, "company/artifacts/engineering-plan/implementation-readiness.json");
const indexPath = path.join(workflowRoot, "ticket-index.json");

const relativePlanPath = path.relative(repositoryRoot, planPath);
const relativeReadinessPath = path.relative(repositoryRoot, readinessPath);
const relativeIndexPath = path.relative(repositoryRoot, indexPath);

const sha256 = (value) => createHash("sha256").update(value).digest("hex");

async function readJsonWithSource(filePath) {
  const source = await readFile(filePath, "utf8");
  return { source, value: JSON.parse(source) };
}

function validateInputs(plan, readiness) {
  if (plan.status !== "approved") {
    throw new Error(`Engineering plan must be approved; observed ${JSON.stringify(plan.status)}.`);
  }
  if (!Array.isArray(plan.tickets) || plan.tickets.length === 0) {
    throw new Error("Engineering plan has no tickets array.");
  }
  if (!Array.isArray(readiness.requirements)) {
    throw new Error("Implementation readiness has no requirements array.");
  }

  const ticketIds = new Set();
  for (const ticket of plan.tickets) {
    if (!ticket.id || ticketIds.has(ticket.id)) {
      throw new Error(`Missing or duplicate ticket ID: ${JSON.stringify(ticket.id)}.`);
    }
    ticketIds.add(ticket.id);
  }
  for (const ticket of plan.tickets) {
    for (const dependencyId of ticket.dependsOn ?? []) {
      if (!ticketIds.has(dependencyId)) {
        throw new Error(`${ticket.id} references missing dependency ${dependencyId}.`);
      }
    }
  }
}

function buildIndex(planSource, plan, readinessSource, readiness) {
  validateInputs(plan, readiness);

  const readinessById = new Map(readiness.requirements.map((item) => [item.id, item]));
  const ticketById = new Map(plan.tickets.map((ticket) => [ticket.id, ticket]));
  const priorityRank = { must: 0, should: 1, could: 2 };
  const bootstrapTicketIds = new Set([
    "ENG-001", "ENG-002", "ENG-003", "ENG-004", "ENG-005", "ENG-006", "ENG-008", "ENG-013",
    "ENG-014", "ENG-024", "ENG-039", "ENG-043", "ENG-046", "ENG-152", "ENG-153", "ENG-154", "ENG-155"
  ]);
  const bootstrapTicket = ticketById.get("ENG-155");
  const bootstrapComplete = bootstrapTicket?.status === "completed" && bootstrapTicket?.passes === true;

  const tickets = plan.tickets.map((ticket, offset) => {
    const dependencies = (ticket.dependsOn ?? []).map((id) => {
      const dependency = ticketById.get(id);
      return {
        id,
        status: dependency.status,
        passes: dependency.passes === true
      };
    });
    const readinessPrerequisites = (ticket.readinessPrerequisites ?? []).map((id) => {
      const item = readinessById.get(id);
      return {
        id,
        status: item?.status ?? "missing"
      };
    });
    const blockers = [];

    if (ticket.passes === true) blockers.push("already-passing");
    if (!["not-started", "in-progress"].includes(ticket.status)) blockers.push(`status:${ticket.status}`);
    for (const dependency of dependencies) {
      if (dependency.status !== "completed" || !dependency.passes) {
        blockers.push(`dependency:${dependency.id}`);
      }
    }
    for (const requirement of readinessPrerequisites) {
      if (!["ready", "not-required"].includes(requirement.status)) {
        blockers.push(`readiness:${requirement.id}:${requirement.status}`);
      }
    }
    if (!bootstrapComplete && !bootstrapTicketIds.has(ticket.id)) {
      blockers.push("bootstrap:ENG-155");
    }

    return {
      order: offset + 1,
      id: ticket.id,
      title: ticket.title,
      priority: ticket.priority,
      status: ticket.status,
      passes: ticket.passes === true,
      dependsOn: ticket.dependsOn ?? [],
      readinessPrerequisites: ticket.readinessPrerequisites ?? [],
      eligible: blockers.length === 0,
      blockers
    };
  });

  const eligible = tickets
    .filter((ticket) => ticket.eligible)
    .sort((left, right) => {
      const resumeDifference = Number(left.status !== "in-progress") - Number(right.status !== "in-progress");
      if (resumeDifference !== 0) return resumeDifference;
      const priorityDifference = (priorityRank[left.priority] ?? 99) - (priorityRank[right.priority] ?? 99);
      if (priorityDifference !== 0) return priorityDifference;
      return left.order - right.order;
    });

  const statusCounts = Object.fromEntries(
    [...new Set(tickets.map((ticket) => ticket.status))]
      .sort()
      .map((status) => [status, tickets.filter((ticket) => ticket.status === status).length])
  );

  return {
    schema_version: 1,
    generated_at: new Date().toISOString(),
    source_plan: relativePlanPath,
    source_plan_sha256: sha256(planSource),
    source_readiness: relativeReadinessPath,
    source_readiness_sha256: sha256(readinessSource),
    plan_status: plan.status,
    bootstrap_gate: {
      ticket_id: "ENG-155",
      complete: bootstrapComplete,
      allowed_ticket_ids: [...bootstrapTicketIds]
    },
    ticket_count: tickets.length,
    eligible_count: eligible.length,
    passing_count: tickets.filter((ticket) => ticket.passes).length,
    status_counts: statusCounts,
    next_ticket_id: eligible[0]?.id ?? null,
    tickets
  };
}

async function computeIndex() {
  const [{ source: planSource, value: plan }, { source: readinessSource, value: readiness }] = await Promise.all([
    readJsonWithSource(planPath),
    readJsonWithSource(readinessPath)
  ]);
  return {
    index: buildIndex(planSource, plan, readinessSource, readiness),
    plan
  };
}

async function writeJsonAtomically(filePath, value) {
  const temporaryPath = `${filePath}.tmp`;
  await writeFile(temporaryPath, `${JSON.stringify(value, null, 2)}\n`, "utf8");
  await rename(temporaryPath, filePath);
}

async function syncIndex() {
  const { index } = await computeIndex();
  await writeJsonAtomically(indexPath, index);
  return index;
}

async function assertFresh() {
  const { index: expected } = await computeIndex();
  const existing = JSON.parse(await readFile(indexPath, "utf8"));
  const checks = [
    ["source_plan_sha256", existing.source_plan_sha256, expected.source_plan_sha256],
    ["source_readiness_sha256", existing.source_readiness_sha256, expected.source_readiness_sha256],
    ["plan_status", existing.plan_status, expected.plan_status],
    ["ticket_count", existing.ticket_count, expected.ticket_count]
  ];
  const stale = checks.filter(([, actual, wanted]) => actual !== wanted);
  if (stale.length > 0) {
    const details = stale.map(([field, actual, wanted]) => `${field}: ${actual} != ${wanted}`).join("; ");
    throw new Error(`Ticket index is stale (${details}). Run: bun ${path.relative(repositoryRoot, fileURLToPath(import.meta.url))} sync`);
  }
  return existing;
}

async function setTicketState([ticketId, status, passesText, ...options]) {
  const allowedStatuses = new Set(["not-started", "in-progress", "blocked", "completed"]);
  if (!ticketId || !allowedStatuses.has(status) || !["true", "false"].includes(passesText)) {
    throw new Error("Usage: set <ticket-id> <not-started|in-progress|blocked|completed> <true|false> --note <text>");
  }
  const passes = passesText === "true";
  if ((status === "completed") !== passes) {
    throw new Error("Engineering tickets require completed + true together; every other status requires false.");
  }
  const noteIndex = options.indexOf("--note");
  const note = noteIndex >= 0 ? options.slice(noteIndex + 1).join(" ").trim() : "";
  if (!note) {
    throw new Error("Every state change requires --note with ownership, evidence, blocker, or result context.");
  }

  const { source: planSource, value: plan } = await readJsonWithSource(planPath);
  const { source: readinessSource, value: readiness } = await readJsonWithSource(readinessPath);
  validateInputs(plan, readiness);
  const ticket = plan.tickets.find((item) => item.id === ticketId);
  if (!ticket) throw new Error(`Unknown ticket ${ticketId}.`);

  if (["in-progress", "completed"].includes(status)) {
    const currentIndex = buildIndex(planSource, plan, readinessSource, readiness);
    const indexedTicket = currentIndex.tickets.find((item) => item.id === ticketId);
    if (!indexedTicket?.eligible) {
      throw new Error(`${ticketId} is not eligible: ${(indexedTicket?.blockers ?? ["missing-index-entry"]).join(", ")}.`);
    }
  }
  if (status === "completed" && ticket.status !== "in-progress") {
    throw new Error(`${ticketId} must be in-progress before it can be completed.`);
  }

  const timestamp = new Date().toISOString();
  ticket.status = status;
  ticket.passes = passes;
  ticket.stateUpdatedAt = timestamp;
  ticket.notes = [ticket.notes?.trim(), `[${timestamp}] ${note}`].filter(Boolean).join("\n");
  await writeJsonAtomically(planPath, plan);
  const index = await syncIndex();
  return index.tickets.find((item) => item.id === ticketId);
}

async function main() {
  const [command = "check", ...arguments_] = process.argv.slice(2);
  if (command === "sync") {
    const index = await syncIndex();
    console.log(JSON.stringify({ index: relativeIndexPath, ticket_count: index.ticket_count, next_ticket_id: index.next_ticket_id }, null, 2));
    return;
  }
  if (command === "check") {
    const index = await assertFresh();
    console.log(JSON.stringify({ fresh: true, ticket_count: index.ticket_count, next_ticket_id: index.next_ticket_id }, null, 2));
    return;
  }
  if (command === "next") {
    const index = await assertFresh();
    const ticket = index.tickets.find((item) => item.id === index.next_ticket_id) ?? null;
    console.log(JSON.stringify(ticket, null, 2));
    return;
  }
  if (command === "get") {
    const [ticketId] = arguments_;
    if (!ticketId) throw new Error("Usage: get <ticket-id>");
    await assertFresh();
    const { value: plan } = await readJsonWithSource(planPath);
    const ticket = plan.tickets.find((item) => item.id === ticketId);
    if (!ticket) throw new Error(`Unknown ticket ${ticketId}.`);
    console.log(JSON.stringify(ticket, null, 2));
    return;
  }
  if (command === "set") {
    console.log(JSON.stringify(await setTicketState(arguments_), null, 2));
    return;
  }
  throw new Error("Commands: check | sync | next | get <ticket-id> | set <ticket-id> <status> <passes> --note <text>");
}

main().catch((error) => {
  console.error(error instanceof Error ? error.message : String(error));
  process.exitCode = 1;
});
