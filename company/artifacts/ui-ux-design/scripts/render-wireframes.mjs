#!/usr/bin/env node

import fs from "node:fs";
import path from "node:path";
import { createRequire } from "node:module";
import { pathToFileURL } from "node:url";

const root = path.resolve(import.meta.dirname, "../../../..");
const manifestPath = path.join(root, "company/artifacts/ui-ux-design/wireframe-manifest.json");
const manifest = JSON.parse(fs.readFileSync(manifestPath, "utf8"));
const requestedIds = new Set(process.argv.slice(2));
const require = createRequire(import.meta.url);
const { chromium } = require("playwright");
const browser = await chromium.launch({ headless: true });
const page = await browser.newPage({ viewport: { width: 1440, height: 1024 }, deviceScaleFactor: 1 });
await page.emulateMedia({ reducedMotion: "reduce", colorScheme: "light" });

async function capture(html, png, width, height) {
  const htmlPath = path.join(root, html);
  const pngPath = path.join(root, png);
  fs.mkdirSync(path.dirname(pngPath), { recursive: true });
  await page.setViewportSize({ width, height });
  await page.goto(pathToFileURL(htmlPath).href, { waitUntil: "networkidle" });
  await page.screenshot({ path: pngPath, fullPage: true, animations: "disabled" });
  const size = await page.evaluate(() => ({ width: document.documentElement.scrollWidth, height: document.documentElement.scrollHeight }));
  return size;
}

let count = 0;
for (const record of manifest.screens) {
  if (requestedIds.size && !requestedIds.has(record.screen_id)) continue;
  for (const [viewport, dimensions] of Object.entries({ desktop: [1440, 1024], mobile: [390, 844] })) {
    const captureRecord = record.assembled.captures[viewport];
    const size = await capture(record.assembled.html, captureRecord.png, ...dimensions);
    captureRecord.height = size.height;
    count += 1;
  }
  for (const section of record.sections) {
    for (const [viewport, dimensions] of Object.entries({ desktop: [1440, 1024], mobile: [390, 844] })) {
      await capture(section.html, section.captures[viewport], ...dimensions);
      count += 1;
    }
  }
  record.verified_at = new Date().toISOString();
  if (count % 50 === 0) process.stdout.write(`Rendered ${count} captures...\n`);
}

fs.writeFileSync(manifestPath, `${JSON.stringify(manifest, null, 2)}\n`);
await browser.close();
const renderedRecords = requestedIds.size ? manifest.screens.filter((record) => requestedIds.has(record.screen_id)).length : manifest.screens.length;
process.stdout.write(`Rendered ${count} captures across ${renderedRecords} screen/state records.\n`);
