# Frontend Design Skill Build Loop

Read this file at the start of every loop iteration. Read deeper files only when the selected task points to them.

## Mission

Build and verify a reusable founder-to-frontend workflow that turns a product vision into an approved PRD, structured HTML wireframes, exact copy, and ImageGen-created screen mockups before engineering begins.

## Goal

Maintain four global skills—`product-prd-spec`, `product-ux-design`, `copywriting`, and `product-screen-mockups`—and document their reusable handoff workflow under `company/workflows/frontend-design/`.

## Verification

Overall completion requires:

- All four global skill folders pass the Skill Creator validator and contain current `agents/openai.yaml` metadata.
- The copywriting skill produces `company/voice.md` and a structured copy manifest, while the UX and mockup skills share one compatible `screens.json` contract.
- The repository workflow, task evidence, plan, activity log, and run log are complete and internally consistent.

## Loop Contract

1. Read `tasks.json` fully and tail `progress.txt`.
2. Select the lowest-order actionable task whose dependencies are complete.
3. Mark it `in_progress` before acting.
4. Read only its `spec_ref` plus files directly required by that spec.
5. Complete the task, run its verification, and record evidence in `tasks.json`.
6. Mark it `complete` only when every acceptance criterion passes.
7. Append one immutable `progress.txt` entry.
8. Continue to the next task during this user-requested build run; future maintenance runs default to one task per turn.
9. Stop when all tasks are complete or when a blocker requires founder input.

## Hard Rules

- Global means `/Users/talishawhite/.codex/skills/`; do not place skill source inside this repository.
- Keep the upstream copywriting principles recognizable and record the upstream source/version in the customized skill.
- Wireframes are deterministic grayscale HTML rendered to PNG; they are not SVG drawings or high-fidelity designs.
- Final mockups are generated with built-in ImageGen using the wireframe PNG, approved copy, brand assets, and `imagegen-frontend-web` direction.
- `company/voice.md` and copy manifests—not raster mockup text—are the implementation source of truth.
- The frontend workflow may specify backend implications but must not invent backend architecture or implementation.
- Do not mark work complete without verification evidence.

## File Map

| File | Read it | Contains |
| --- | --- | --- |
| `GOAL.md` | every iteration | mission, goal, loop contract, hard rules |
| `tasks.json` | every iteration | live queue, dependencies, acceptance criteria, evidence |
| `progress.txt` | tail every iteration | append-only execution memory |
| `FIRST_START.md` | only if `tasks.json` is absent | initialization contract |
| `SUBTASKS.md` | only when decomposing | subtask rules |
| `spec/workflow.md` | workflow tasks | four-stage frontend workflow and boundaries |
| `spec/skills.md` | skill tasks | global skill requirements and handoff contracts |
| `spec/copywriting.md` | copywriting task | voice and copy output requirements |
| `spec/verification.md` | validation tasks | deterministic checks and review evidence |
