#!/usr/bin/env node

import fs from "node:fs";
import path from "node:path";

const root = path.resolve(import.meta.dirname, "../../../..");
const manifestPath = path.join(root, "company/artifacts/copy/copy-manifest.json");
const screensPath = path.join(root, "company/artifacts/prd/screens.json");
const voicePath = path.join(root, "company/voice.md");
const manifest = JSON.parse(fs.readFileSync(manifestPath, "utf8"));
const screens = JSON.parse(fs.readFileSync(screensPath, "utf8")).screens;
const screenById = new Map(screens.map((screen) => [screen.screen_id, screen]));
const errors = [];

if (manifest.schema_version !== "1.0") errors.push("copy manifest schema_version must be 1.0");
if (!new Set(["draft", "approved"]).has(manifest.status)) errors.push("copy manifest status must be draft or approved");
if (manifest.status === "approved" && !manifest.approved_at) errors.push("approved copy manifest must record approved_at");
const voice = fs.existsSync(voicePath) ? fs.readFileSync(voicePath, "utf8") : "";
const expectedVoiceStatus = manifest.status === "approved" ? "Status: Approved" : "Status: Draft";
if (!voice.includes(expectedVoiceStatus)) errors.push(`company/voice.md must exist with ${expectedVoiceStatus.replace("Status: ", "")} status`);
if (manifest.screens.length !== screens.length) errors.push(`expected ${screens.length} copy records, found ${manifest.screens.length}`);

const seen = new Set();
for (const record of manifest.screens) {
  const screen = screenById.get(record.screen_id);
  const key = `${record.screen_id}/${record.state}`;
  if (seen.has(key)) errors.push(`duplicate copy record ${key}`);
  seen.add(key);
  if (!screen) { errors.push(`unknown screen_id ${record.screen_id}`); continue; }
  if (record.screen_slug !== screen.screen_slug) errors.push(`${key}: screen_slug mismatch`);
  if (manifest.status === "approved") {
    if (record.status !== "approved" || !record.approved_at) errors.push(`${key}: approved copy must record approved status and approved_at`);
    if (screen.copy?.status !== "approved") errors.push(`${key}: screens.json copy status must be approved`);
  } else {
    if (record.status !== "draft" || record.approved_at !== null) errors.push(`${key}: unapproved copy must be draft with null approved_at`);
    if (screen.copy?.status !== "ready-for-review") errors.push(`${key}: screens.json copy status must be ready-for-review`);
  }
  for (const source of Object.values(record.source_wireframe || {})) if (!fs.existsSync(path.join(root, source))) errors.push(`${key}: missing wireframe source ${source}`);
  if (!fs.existsSync(path.join(root, record.copy_file))) errors.push(`${key}: missing copy file ${record.copy_file}`);
  const exact = record.exact_copy || {};
  if (!exact.headline || !exact.primary_cta) errors.push(`${key}: headline and primary_cta are required`);
  const serialized = JSON.stringify(exact).toLowerCase();
  if (serialized.includes("lorem ipsum")) errors.push(`${key}: lorem ipsum found in exact copy`);
  for (const phrase of ["guaranteed fit", "perfect body", "photos delete automatically", "scientifically proven"]) if (serialized.includes(phrase)) errors.push(`${key}: prohibited claim ${phrase}`);
  const dynamicTokens = new Set(exact.metadata?.dynamic_tokens || []);
  for (const match of JSON.stringify(exact).matchAll(/\{\{([a-z0-9_]+)\}\}/gi)) if (!dynamicTokens.has(match[1])) errors.push(`${key}: undocumented dynamic token ${match[1]}`);
  if (!Array.isArray(exact.sections) || !exact.sections.length) errors.push(`${key}: wireframe-ordered section copy is missing`);
}

if (errors.length) {
  for (const error of errors) console.error(`ERROR: ${error}`);
  process.exit(1);
}

console.log(`Validated ${manifest.screens.length} ${manifest.status} copy records and company/voice.md.`);
