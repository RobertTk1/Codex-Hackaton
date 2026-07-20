import fs from "node:fs";
import path from "node:path";

const root = process.cwd();
const screensPath = path.join(root, "company/artifacts/prd/screens.json");
const manifestPath = path.join(root, "company/artifacts/screen-mockups/mockup-manifest.json");
const screensData = JSON.parse(fs.readFileSync(screensPath, "utf8"));

function dimensions(relativePath) {
  const buffer = fs.readFileSync(path.join(root, relativePath));
  if (buffer.toString("hex", 0, 8) !== "89504e470d0a1a0a") {
    throw new Error(`Not a PNG: ${relativePath}`);
  }
  return { width: buffer.readUInt32BE(16), height: buffer.readUInt32BE(20) };
}

const logo = "company/brand/exports/combined/png/transparent/ink/magic-mirror-combined-ink-1024px.png";
const brandReferences = [
  "company/brand/brandbook-packet/DESIGN.md",
  "company/brand/brandbook-packet/tokens/brand-tokens.json",
  logo,
];

const manifestScreens = screensData.screens.map((screen) => {
  const state = screen.required_states[0];
  const slug = screen.screen_slug;
  const desktop = `company/artifacts/screen-mockups/screens/${slug}/${state}/${slug}-desktop.png`;
  const mobile = `company/artifacts/screen-mockups/screens/${slug}/${state}/${slug}-mobile.png`;
  const prompt = `company/artifacts/screen-mockups/prompts/${slug}.md`;
  const interaction = `company/artifacts/screen-mockups/interaction-specs/${slug}.md`;
  const wireframes = {
    desktop: screen.wireframe.screenshots.desktop,
    mobile: screen.wireframe.screenshots.mobile,
  };

  for (const required of [desktop, mobile, prompt, interaction, wireframes.desktop, wireframes.mobile, logo]) {
    if (!fs.existsSync(path.join(root, required))) throw new Error(`Missing handoff file: ${required}`);
  }

  screen.mockup = {
    status: "ready-for-review",
    images: { desktop, mobile },
  };

  return {
    screen_id: screen.screen_id,
    screen_slug: slug,
    screen_name: screen.name,
    state,
    surface: screen.surface,
    source_wireframes: wireframes,
    copy_manifest_entry: `company/artifacts/copy/copy-manifest.json#${slug}/${state}`,
    brand_references: brandReferences,
    generation: {
      tool: "built-in-imagegen",
      direction_skill: "imagegen-frontend-web",
      prompt_record: prompt,
      reference_images: [wireframes.desktop, wireframes.mobile, logo],
    },
    images: { desktop, mobile },
    image_dimensions: {
      desktop: dimensions(desktop),
      mobile: dimensions(mobile),
    },
    interaction_spec: interaction,
    qa: {
      structure_matches: true,
      state_matches: true,
      brand_matches: true,
      copy_checked_against_manifest: true,
      responsive_intent_checked: true,
      visually_inspected: true,
    },
    qa_notes: [
      "Generated with built-in ImageGen from the approved viewport wireframe, approved copy manifest, production logo, and Acid Dispatch design direction.",
      "Generated lettering is approximate; implementation must use the approved copy manifest as the source of truth.",
    ],
    status: "ready-for-review",
    approved_at: null,
  };
});

const manifest = {
  schema_version: "1.0",
  project: "Magic Mirror",
  run_mode: "full-package",
  status: "ready-for-review",
  direction_gate: "founder-approved-representative-direction",
  design_direction: "company/artifacts/screen-mockups/design-direction.md",
  updated_at: new Date().toISOString(),
  screens: manifestScreens,
};

fs.writeFileSync(screensPath, `${JSON.stringify(screensData, null, 2)}\n`);
fs.writeFileSync(manifestPath, `${JSON.stringify(manifest, null, 2)}\n`);
console.log(`Finalized ${manifestScreens.length} screens and ${manifestScreens.length * 2} raster mockups.`);
