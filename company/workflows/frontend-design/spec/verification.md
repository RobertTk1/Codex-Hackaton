# Verification Specification

## Global Skill Checks

Run Skill Creator validation against:

```text
/Users/talishawhite/.codex/skills/product-prd-spec
/Users/talishawhite/.codex/skills/product-ux-design
/Users/talishawhite/.codex/skills/copywriting
/Users/talishawhite/.codex/skills/product-screen-mockups
```

Confirm each contains `SKILL.md` and `agents/openai.yaml`, all referenced files exist, and no placeholder markers remain.

## Contract Checks

- Parse every workflow JSON file.
- Confirm the screen contract contains compatible `wireframe`, `copy`, and `mockup` status/path fields.
- Confirm copy manifests use screen IDs from `screens.json`.
- Confirm UX validation rejects missing HTML/PNG paths and accepts a complete fixture.
- Confirm the mockup skill requires built-in ImageGen and retains exact copy outside raster images.

## Repository Checks

- `git diff --check`
- no conflict markers
- no `.DS_Store` files in the feature changes
- no skill folders copied into the repository
- every relative path named in `WORKFLOW.md` resolves or is explicitly described as generated output
- `tasks.json` and all task notes accurately reflect observed evidence

## Manual Review

A fresh agent reading only `WORKFLOW.md` and the named global skills must be able to answer:

1. What does each stage consume and produce?
2. Where does founder approval occur?
3. How are wireframes generated and captured?
4. Which file is canonical for exact copy?
5. How are final mockups generated?
6. What passes to backend/engineering work?
