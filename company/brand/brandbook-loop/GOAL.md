# Magic Mirror Brandbook Loop - Read Every Turn

Read this file every turn. Read deeper files only when the selected task's `spec_ref` points there.

## Mission

Create a polished brandbook packet for Magic Mirror using the approved wordmark, combined lockup, icon, and Acid Dispatch palette. Magic Mirror helps online clothing shoppers and people who want to dress better make faster, more confident clothing decisions through personalized guidance and privacy-conscious virtual try-on.

## Goal

Produce a final packet under `company/brand/brandbook-packet/` containing:

- `Magic-Mirror-Brandbook.pdf` with the 19 requested pages.
- `DESIGN.md` documenting the design system and tokens used in the PDF.
- Source files, page exports, mockup images, asset plan, tokens, and verification evidence.

## Verification

The loop can mark work complete only when the selected task's acceptance criteria pass and evidence is recorded in `tasks.json`.

Overall completion requires:

- The PDF exists, opens successfully, has the expected page count, and matches the requested outline.
- The packet uses only the approved Acid Dispatch anchors—Acid `#D7FF3F`, Deep `#263300`, Pale `#F2FFD0`, Ink `#17171A`, White `#FFFFFF`, Cloud `#F4F3F1`, and technical Black `#000000`—plus explicitly documented derived shades calculated from those anchors.
- Mockups are planned before generation, generated or screenshotted one family at a time, saved as raster assets, reviewed visually, and referenced in the PDF.
- `DESIGN.md` exists and matches the PDF tokens, palette, typography, component styles, logo rules, and WCAG results.

## Loop Contract

```text
START OF TURN
  1. If tasks.json is missing, read FIRST_START.md, initialize the loop, log progress, and stop.
  2. Read tasks.json fully.
  3. Read the tail of progress.txt.
  4. Select the next actionable task:
       - lowest order with status pending or in_progress
       - dependencies are complete
       - if it has pending subtasks, select the next pending subtask
  5. Mark the selected task or subtask in_progress and save tasks.json.
  6. If the selected pending parent task is not atomic, read SUBTASKS.md, create subtasks, log progress, and stop.
  7. Read only the selected task's spec_ref file.
  8. Do the selected task end to end.
  9. Run verification or collect required review evidence.
 10. Mark complete only if acceptance criteria pass. Otherwise leave in_progress or blocked and record why.
 11. Add newly discovered tasks when needed.
 12. Append one progress.txt entry.
END OF TURN
```

Default rule: complete exactly one task or subtask per turn. Do not generate the whole brandbook in one pass unless the user explicitly requests batching.

## Hard Rules

- Do not proceed without existing logo, icon/mark, and palette sources.
- Do not invent new brand colors. Secondary colors must be derived from the approved palette and documented.
- Use existing logo/icon assets as the source of truth; do not redesign them unless explicitly asked.
- Do not create SVG mockups. Final mockups must be raster images.
- For photorealistic mockups, try a complete imagegen mockup first and visually review it. If the logo/text/brand layer is less than about 95% accurate, iterate once with imagegen before exact compositing fallback.
- Before generating mockups, create and verify the asset plan.
- Save all final project-bound generated images inside `company/brand/brandbook-packet/`.
- Do not mark work complete without verification evidence.
- Do not delete or rewrite old `progress.txt` entries.

## File Map

| File | Read it | Contains |
| --- | --- | --- |
| `GOAL.md` | every turn | mission, goal, loop contract, checklist, hard rules |
| `tasks.json` | every turn | live task queue, dependencies, acceptance criteria, verification, notes |
| `progress.txt` | tail every turn | append-only record of prior turns |
| `FIRST_START.md` | once, only if `tasks.json` is missing | initialization instructions |
| `SUBTASKS.md` | only when decomposing | how to create right-sized subtasks |
| `spec/workflow.md` | when selected | overall production workflow |
| `spec/page-outline.md` | when selected | page content requirements |
| `spec/palette-and-tokens.md` | when selected | palette and token rules |
| `spec/imagegen-asset-plan.md` | when selected | imagegen/mockup planning and prompt requirements |
| `spec/pdf-production.md` | when selected | brandbook assembly, rendering, and PDF output |
| `spec/design-md.md` | when selected | final `DESIGN.md` requirements |
| `spec/verification.md` | when selected | completion checks and evidence rules |
