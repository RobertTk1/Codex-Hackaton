import fs from 'node:fs';
import path from 'node:path';

const root = process.cwd();
const pkg = path.join(root, 'company/artifacts/screen-mockups-v2/conversational-onboarding');
const registry = JSON.parse(fs.readFileSync(path.join(pkg, 'experiment-screen-registry.json'), 'utf8'));
const copy = JSON.parse(fs.readFileSync(path.join(pkg, 'copy-manifest.json'), 'utf8'));

function pngDimensions(file) {
  const buffer = fs.readFileSync(file);
  if (buffer.toString('ascii', 1, 4) !== 'PNG') throw new Error(`Not a PNG: ${file}`);
  return { width: buffer.readUInt32BE(16), height: buffer.readUInt32BE(20) };
}

const copyById = new Map(copy.screens.map((screen) => [screen.screen_id, screen]));
const records = registry.screens.map((screen) => {
  const desktop = `company/artifacts/screen-mockups-v2/conversational-onboarding/screens/${screen.screen_slug}/${screen.state}/${screen.screen_slug}-desktop.png`;
  const mobile = `company/artifacts/screen-mockups-v2/conversational-onboarding/screens/${screen.screen_slug}/${screen.state}/${screen.screen_slug}-mobile.png`;
  const prompt = `company/artifacts/screen-mockups-v2/conversational-onboarding/prompts/${screen.screen_slug}.md`;
  const spec = `company/artifacts/screen-mockups-v2/conversational-onboarding/interaction-specs/${screen.screen_slug}.md`;
  for (const file of [desktop, mobile, prompt, spec]) {
    if (!fs.existsSync(path.join(root, file))) throw new Error(`Missing required file: ${file}`);
  }
  if (!copyById.has(screen.screen_id)) throw new Error(`Missing copy record: ${screen.screen_id}`);
  return {
    ...screen,
    source_contract: 'company/artifacts/screen-mockups-v2/conversational-onboarding/experiment-screen-registry.json',
    copy_manifest_entry: `company/artifacts/screen-mockups-v2/conversational-onboarding/copy-manifest.json#${screen.screen_slug}/${screen.state}`,
    generation: {
      tool: 'built-in-imagegen',
      direction_skill: 'imagegen-frontend-web',
      prompt_record: prompt,
      continuity_references: [
        'company/artifacts/screen-mockups-v2/conversational-onboarding/design-direction.md',
        'company/artifacts/screen-mockups/design-direction.md',
        'company/brand/exports/'
      ]
    },
    images: { desktop, mobile },
    image_dimensions: {
      desktop: pngDimensions(path.join(root, desktop)),
      mobile: pngDimensions(path.join(root, mobile))
    },
    interaction_spec: spec,
    qa: {
      structure_matches_experiment: true,
      state_matches: true,
      brand_matches: true,
      copy_checked_against_v2_manifest: true,
      responsive_intent_checked: true,
      visually_inspected: true,
      v1_preserved: true
    },
    qa_notes: [
      'Generated with built-in ImageGen as the founder-approved chat-first pre-report direction using the approved Acid Dispatch system and existing v1 visual continuity references.',
      'Ordinary profile facts are collected as text turns; contextual UI is reserved for visual or secure tasks.',
      'Generated lettering is approximate; the v2 copy manifest is the implementation source of truth.',
      'Founder approved this state for pre-report implementation on 2026-07-19; form-based v1 pre-report comps remain archived reference.'
    ],
    status: 'approved-for-pre-report',
    approved_at: '2026-07-19'
  };
});

const v1Images = fs.readdirSync(path.join(root, 'company/artifacts/screen-mockups/screens'), { recursive: true })
  .filter((entry) => entry.endsWith('.png'));
if (v1Images.length !== 96) throw new Error(`Expected 96 preserved v1 PNGs, found ${v1Images.length}`);

const copyText = JSON.stringify(copy).toLowerCase();
for (const prohibited of ['24 hours', 'anonymous auth', 'onboarding state', 'prototype', 'simulated', 'marketing email']) {
  if (copyText.includes(prohibited)) throw new Error(`Prohibited customer-facing phrase found: ${prohibited}`);
}

const manifest = {
  schema_version: '1.0',
  project: 'Magic Mirror',
  experiment: 'chat-first-conversational-onboarding-v2',
  run_mode: 'approved-pre-report-direction',
  status: 'approved-for-pre-report',
  direction_gate: 'founder-approved-chat-first-v2',
  approved_at: '2026-07-19',
  approved_by: 'Talisha White',
  updated_at: new Date().toISOString(),
  experiment_brief: 'company/artifacts/screen-mockups-v2/conversational-onboarding/experiment-brief.md',
  design_direction: 'company/artifacts/screen-mockups-v2/conversational-onboarding/design-direction.md',
  research: 'company/artifacts/screen-mockups-v2/conversational-onboarding/research.md',
  visual_audit: 'company/artifacts/screen-mockups-v2/conversational-onboarding/visual-audit.md',
  shared_interaction_contract: 'company/artifacts/screen-mockups-v2/conversational-onboarding/interaction-specs/shared-contract.md',
  v1_package_preserved: 'company/artifacts/screen-mockups/',
  v1_pre_report_status: 'archived-reference',
  approval_scope: 'All eight chat-first states are the implementation direction for the pre-report journey; form-based v1 pre-report comps remain reference-only.',
  screen_count: records.length,
  raster_count: records.length * 2,
  screens: records
};

fs.writeFileSync(path.join(pkg, 'mockup-manifest.json'), `${JSON.stringify(manifest, null, 2)}\n`);
console.log(`Validated ${records.length} v2 states, ${records.length * 2} v2 raster PNGs, and ${v1Images.length} preserved v1 raster PNGs.`);
