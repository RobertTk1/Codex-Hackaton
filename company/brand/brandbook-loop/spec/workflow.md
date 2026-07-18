# Workflow Spec

Use this file for setup and orchestration tasks.

## Production order

1. Audit assets and palette.
2. Create packet directories and token files.
3. Write the asset/mockup plan.
4. Generate or select mockups one family at a time.
5. Build source pages.
6. Compute WCAG data.
7. Render PDF and previews.
8. Write `DESIGN.md`.
9. Run final audit.

## Source-of-truth inputs

- Brand positioning: recorded in `GOAL.md`; corroborated by the project company profile.
- Production identity assets: `company/brand/exports/`.
- Approved palette and treatments: `company/brand/brand-colors.json` and `company/brand/README.md`.
- ImageGen visual masters: `company/brand/masters/`; use only when a production export does not provide the required reference.

## Packet folders

Create:

- `company/brand/brandbook-packet/assets/`
- `company/brand/brandbook-packet/mockups/`
- `company/brand/brandbook-packet/source/`
- `company/brand/brandbook-packet/pages/`
- `company/brand/brandbook-packet/tokens/`
- `company/brand/brandbook-packet/references/`

## Evidence

Every completed task note should include output path, file size or dimensions where relevant, method, and verification result.
