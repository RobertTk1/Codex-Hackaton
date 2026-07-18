# Frontend Design Workflow Specification

## Outcome

Provide one reusable, approval-gated path from founder vision to implementation-ready frontend references:

`product-prd-spec → product-ux-design → copywriting → product-screen-mockups → engineering handoff`

## Stage Boundaries

### Product PRD

Understand the full vision, first coherent frontend experience, actors, journeys, screen/state inventory, and user-visible implications of backend capabilities. Produce testable product requirements without choosing backend architecture.

### Product UX

Define information architecture, navigation, flows, and low-fidelity structure. Produce semantic grayscale HTML wireframes and deterministic desktop/mobile screenshots. Do not add features, brand styling, or persuasive final copy.

### Copywriting

Use company, audience, brand, PRD, and approved wireframe context to write exact marketing and product-interface copy. Produce `company/voice.md`, page/screen copy files, and `company/artifacts/copy/copy-manifest.json`. Do not invent proof, testimonials, performance claims, or product behavior.

### Product Screen Mockups

Use approved wireframe PNGs, copy artifacts, brand tokens/assets, `company/voice.md`, `imagegen-frontend-web`, and built-in ImageGen to generate high-fidelity raster mockups. Preserve the approved structure. The copy manifest remains canonical when ImageGen text drifts.

## Approval Gates

1. Founder approves PRD scope before UX.
2. Founder approves IA and wireframes before copywriting.
3. Founder approves copy and voice before mockup generation.
4. Founder approves mockups before engineering implementation.

## Backend Boundary

This workflow identifies frontend dependencies such as data needs, authentication, permissions, API behavior, AI requests, asynchronous status, storage, privacy, retention, admin touchpoints, and failure recovery. Founder Skills engineering instructions decide system architecture, database schema, API specifications, security design, and implementation after the frontend package is approved.

## Repository Convention

For repositories with a canonical `company/` folder, use:

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
      wireframes/html/
      wireframes/png/
      wireframe-manifest.json
    copy/
      copy-manifest.json
      screens/
    screen-mockups/
      design-direction.md
      screens/
      interaction-specs/
```

If a project has a stronger documented convention, adapt all four skills consistently and record the resolved paths in the PRD package.

## Resume Behavior

Every skill reads the canonical manifest first, skips artifacts with verified paths, continues the lowest-order incomplete item, and updates the manifest immediately after verification. Never regenerate approved work without an explicit revision request.
