# Frontend Definition Workflow

**Status:** Ready to run  
**Owner:** Founder  
**Scope:** Product definition through approved frontend design; backend architecture and production implementation are downstream.

## Outcome

Turn a founder's product vision into an implementation-ready frontend package through four approval-gated global skills:

```text
Founder vision
  → product-prd-spec
  → product-ux-design
  → copywriting
  → product-screen-mockups
  → engineering handoff
```

The workflow defines the experience a person should see and use. It also records the backend capabilities that experience implies, without selecting the backend architecture.

## Global Skill Dependencies

Use the globally installed skills under `~/.codex/skills/`; do not copy their source into this repository.

| Stage | Skill | Primary responsibility |
| --- | --- | --- |
| 1 | `$product-prd-spec` | Vision discovery, product scope, behavior, stories, states, scenarios, and backend implications |
| 2 | `$product-ux-design` | Information architecture, navigation, flows, responsive grayscale HTML wireframes, and PNG captures |
| 3 | `$copywriting` | Exact marketing/product copy, copy manifest, and durable `company/voice.md` |
| 4 | `$product-screen-mockups` | ImageGen raster comps, design direction, responsive visual states, and interaction handoff |

`$product-screen-mockups` uses `$imagegen-frontend-web` for visual direction and built-in ImageGen for every final raster mockup.

## Canonical Artifact Map

```text
company/
  voice.md
  artifacts/
    prd/
      prd.md
      prd-report.pdf
      user-stories.json
      screens.json
      scenarios.feature
    ui-ux-design/
      information-architecture.md
      navigation.md
      user-flows/
      ux-notes.md
      wireframe-manifest.json
      wireframes/html/
      wireframes/png/
    copy/
      copy-manifest.json
      screens/
    screen-mockups/
      design-direction.md
      mockup-manifest.json
      prompts/
      screens/<screen-id>/
      interaction-specs/
```

The stable UUID `screen_id` joins `screens.json`, wireframes, copy, mockups, and the eventual implementation. `screens.json` owns the inventory and stage statuses. The copy manifest—not text rendered into a raster—is the source of truth for implementation strings.

## Before Starting

1. Read `AGENTS.md`, `company/plan.md`, `company/company.md`, and relevant audience, market, brand, and technical context.
2. Read the contributor's collaboration profile when known.
3. Inspect all existing canonical manifests before creating anything.
4. Choose **full package** or **incremental** mode and state the requested scope.
5. Use a task branch/worktree when repository files will change.

Do not skip an approval gate because a later artifact already exists. If upstream scope changed, mark affected downstream artifacts for review rather than silently regenerating them.

## Stage 1 — Product PRD

Invoke:

```text
Use $product-prd-spec to turn this product vision into the approved PRD package for the first coherent frontend experience.
```

### Inputs

- Founder walkthrough: what the whole product looks like and what happens from entry through success and recovery
- `company/company.md`, `company/plan.md`, audience and market research
- Existing product/repository constraints
- Existing PRD artifacts when revising

### Work

- Separate the full product vision, first coherent frontend experience, roadmap, and non-goals.
- Define actors, journeys, screen/state inventory, user-visible behavior, acceptance criteria, and Given/When/Then scenarios.
- Record frontend implications of authentication, data, permissions, AI/provider work, async status, storage, privacy, retention, admin needs, and failure recovery.
- Do not choose database schema, services, endpoints, queues, or infrastructure.

### Outputs And Verification

- `company/artifacts/prd/prd.md`
- `company/artifacts/prd/prd-report.pdf` when document tooling is available
- `company/artifacts/prd/user-stories.json`
- `company/artifacts/prd/screens.json` using schema version `2.0`
- `company/artifacts/prd/scenarios.feature`

Validate JSON, trace every screen to stories/scenarios, check that every first-experience requirement has observable acceptance criteria, and review the rendered PDF when produced.

### Gate And Resume

The founder approves the PRD package before UX. On resume, read all artifacts and approval history; update only the affected stories/screens/scenarios and preserve stable screen IDs.

## Stage 2 — Product UX Design

Invoke:

```text
Use $product-ux-design on the approved PRD to create IA, flows, responsive HTML wireframes, and deterministic PNG screenshots.
```

### Inputs

- Founder-approved PRD package and `screens.json`
- Company/audience context and UX-relevant technical constraints
- Existing IA, wireframes, or manifest for incremental work

### Work

- Define information architecture, surface boundaries, navigation, and critical flows.
- Cover decisions, system responses, success, failure, permissions, and recovery.
- Build one semantic grayscale HTML document per screen/state.
- Render each required desktop/mobile viewport to a deterministic PNG.
- Use Relume Library MCP as an optional component-pattern source when available; it is never a completion dependency.

HTML/CSS and browser screenshots are required for low-fidelity wireframes. Do not use ImageGen, SVG, canvas, final brand styling, or persuasive copy at this stage.

### Outputs And Verification

- IA, navigation, flows, and UX notes under `company/artifacts/ui-ux-design/`
- HTML wireframes and PNG captures
- `wireframe-manifest.json`
- Updated `screens.json` wireframe fields

Run the skill's `scripts/validate_wireframes.py`, render every required viewport, and visually inspect screenshots for hierarchy, state fidelity, clipping, overflow, semantics, and responsive reflow.

### Gate And Resume

The founder approves IA and wireframes before copywriting. On resume, select the lowest-order incomplete screen/state from the manifest and leave approved wireframes unchanged unless revision is explicit.

## Stage 3 — Copywriting

Invoke:

```text
Use $copywriting in product-interface and marketing-page modes to write exact copy for the approved wireframes and create or update company/voice.md.
```

### Inputs

- Company, audience, market, positioning, and brand context
- Approved PRD and wireframe PNG/HTML paths
- Existing voice/copy artifacts and verified proof

### Work

- Write exact copy in wireframe order for every requested screen/state.
- Cover headlines, CTAs, labels, helper text, validation, waiting, consent/privacy, error/recovery, success, and metadata as applicable.
- Create a durable company voice from strategy, source language, and approved choices.
- Never invent testimonials, customer logos, metrics, performance claims, or product behavior.

### Outputs And Verification

- `company/voice.md`
- `company/artifacts/copy/copy-manifest.json`
- `company/artifacts/copy/screens/<screen-or-page>.md`
- Updated `screens.json` copy fields

Parse the manifest, verify every `screen_id` and path, remove lorem/unmarked placeholders, check proof sources, and confirm one recommended primary action per screen unless the PRD says otherwise.

### Gate And Resume

The founder approves copy and voice before mockup generation. On resume, preserve approved voice rules and screen entries; add revision history when feedback creates a durable rule.

## Stage 4 — Product Screen Mockups

Invoke:

```text
Use $product-screen-mockups with the approved wireframe PNGs, copy manifest, voice, and brand assets to generate ImageGen raster mockups and interaction specs.
```

### Inputs

- Approved wireframe PNG for the exact screen/state/viewport
- Approved `copy-manifest.json` entry with the same `screen_id`
- `company/voice.md`, UX notes, PRD record, and real brand/logo/image assets

### Work

- Establish one visual system using `$imagegen-frontend-web`, tuned separately for marketing surfaces and task-focused application UI.
- Generate one screen/state/viewport at a time with built-in ImageGen.
- Preserve the approved wireframe's hierarchy, controls, order, primary action, and state.
- Write interaction and responsive specifications that a static raster cannot communicate.

Every final comp is an ImageGen-generated raster. Do not substitute HTML/CSS screenshots, SVG, canvas, programmatic drawing, Figma exports, browser/device frames, multi-screen collages, or presentation boards.

### Outputs And Verification

- `company/artifacts/screen-mockups/design-direction.md`
- Prompt records, one PNG per required screen/state/viewport, and interaction specs
- `company/artifacts/screen-mockups/mockup-manifest.json`
- Updated `screens.json` mockup fields

Run the skill's `scripts/validate_mockup_handoff.py`. Visually compare each image to the wireframe, copy, brand, state, and viewport. Generated lettering is a visual approximation; implementation always reads the copy manifest.

### Gate And Resume

The founder approves mockups before engineering. On resume, keep the approved design system and images, generate the next incomplete item, and never overwrite approved comps without an explicit revision request.

## Engineering Handoff

The frontend package is ready for engineering when:

- the PRD, IA/flows, required wireframes, voice/copy, mockups, and interaction specs are approved;
- every first-experience story and scenario maps to stable screen/state records;
- all required viewport paths exist and all manifests agree;
- exact copy and asset paths are identified outside the raster images; and
- backend implications and unresolved implementation questions are explicit.

Engineering-focused Founder Skills then decide system architecture, database schema, API contracts, provider integration, security, privacy implementation, tests, deployment, and production code. If an engineering decision changes observable behavior, route that decision back through the smallest affected frontend artifact and approval gate.

## Completion And Recovery Rules

- A status is `approved` only after explicit founder approval; validation alone produces `ready-for-review`.
- On any failure, preserve completed artifacts, record the failing screen ID and check, and resume from the lowest incomplete item.
- Never regenerate unrelated approved work to fix one screen.
- Validate paths before writing a downstream reference.
- Keep production copy in the copy manifest, behavior in interaction specs, screen inventory/status in `screens.json`, and visual intent in the raster plus design direction.
- Update `company/plan.md`, `company/activity.md`, and `company/run-log.md` after each approved stage or material workflow decision.

## Workflow Maintenance

The loop package beside this file (`GOAL.md`, `tasks.json`, `progress.txt`, and `spec/`) records how these global skills and this workflow were built and verified. For future changes, select the smallest affected global skill, update its contract, run its validator plus an integrated cross-path check, and append project operating memory. Never add global skill source folders to this repository.
