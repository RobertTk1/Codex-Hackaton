# Global Skill Requirements

## Shared Rules

- Install and maintain skills only under `/Users/talishawhite/.codex/skills/`.
- Keep each `SKILL.md` concise and route detailed contracts to one-level `references/` files.
- Include `agents/openai.yaml` with a short description and a default prompt that names the skill.
- Use the repository's company folder and artifact conventions when they exist.
- Support full-package and incremental modes; resume from manifest paths instead of recreating approved work.
- Validate external data and JSON manifests before trusting them.

## product-prd-spec

Required references:

- PRD contract with full vision, first coherent experience, frontend walkthrough, backend implications, metrics, risks, and approval status.
- User-story contract with observable acceptance criteria and Given/When/Then coverage.
- Screen contract with one record per state or long-page viewport and compatible `wireframe`, `copy`, and `mockup` fields.
- Discovery guide for founder vision, actors, frontend behavior, data/system implications, privacy, and recovery.

## product-ux-design

Required resources:

- IA and flow contract.
- HTML wireframe contract and a reusable grayscale CSS asset.
- Deterministic validator for `screens.json`, HTML wireframe files, and PNG paths.
- Optional Relume guidance: use an authenticated Relume Library MCP for component discovery when available; otherwise use semantic HTML patterns. Do not make Relume a completion dependency.

Wireframes must use accessible semantic HTML, visible component/state labels, realistic proportions, restrained placeholder content, desktop/mobile responsiveness, and no brand styling.

## copywriting

Install the upstream `coreyhaines31/marketingskills` copywriting folder with its references, then customize the global copy for the company-package workflow. Preserve upstream attribution inside `SKILL.md` and the upstream references.

## product-screen-mockups

Required references:

- Input and artifact contract.
- Marketing-page versus application-UI art-direction rules.
- ImageGen prompt and reference-image rules.
- Structure/copy/brand/state QA checklist.

Every final mockup is a raster ImageGen output. HTML is the wireframe source only. Do not use HTML/CSS, SVG, canvas, or Figma rendering as a substitute for final mockup generation.
