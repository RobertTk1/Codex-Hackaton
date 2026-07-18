# Magic Mirror Logo Package

Status: Hackathon identity package, working name

Identity direction: Acid Dispatch / Editorial Edge

Year: 2026

## Approved Marks

1. **Wordmark** — the approved concept-01 high-contrast serif lettering with the standard lowercase `o` in “Mirror.”
2. **Combined lockup** — the same wordmark with icon concept 03 replacing the `o` in “Mirror.”
3. **Standalone icon** — concept 03: an S-curve lens framed by upper-left and lower-right focus corners.

The files in `masters/` are the approved ImageGen references. The files in `exports/` are the production package: exact colors, transparent PNGs, traced editable SVG paths, PDFs, treatment previews, and favicon formats.

## Color Specification

| Role | Name | HEX |
| --- | --- | --- |
| Primary | Acid | `#D7FF3F` |
| Deep supporting color | Deep | `#263300` |
| Pale supporting color | Pale | `#F2FFD0` |
| Dark surface / text | Ink | `#17171A` |
| Light surface | White | `#FFFFFF` |
| Neutral surface | Cloud | `#F4F3F1` |
| Technical monochrome | Black | `#000000` |

## Default Treatments

- **Primary:** Ink mark on Acid.
- **Dark:** Acid mark on Ink.
- **Soft:** Deep mark on Pale.
- **Light:** Ink mark on White.
- **Monochrome positive:** Black mark on White.
- **Monochrome reversed:** White mark on Black.

Monochrome files are technical fallbacks, not preferred brand expressions.

## Export Matrix

### Wordmark and combined lockup

- Transparent PNG widths: `2048`, `1024`, `512`, and `256` px.
- Transparent colors: Acid, Ink, Deep, White, and Black.
- Editable vector colors: SVG and PDF in Acid, Ink, Deep, White, and Black.
- Background previews: all six default treatments.

### Standalone icon

- Transparent PNG sizes: `1024`, `512`, `256`, `180`, `128`, `64`, `48`, `32`, and `16` px.
- Transparent colors: Acid, Ink, Deep, White, and Black.
- Editable vector colors: SVG and PDF in Acid, Ink, Deep, White, and Black.
- Browser/app files: multi-resolution `favicon.ico`, 16/32/48 px favicon PNGs, and a 180 px Apple Touch icon.

At `16px`, the favicon intentionally uses the simplified S-curve lens without focus corners. Use the complete standalone icon at `32px` and above.

## Usage Guidance

- Prefer the wordmark when the name must be immediately readable.
- Prefer the combined lockup for hero, navigation, sponsorship, and presentation placements with enough horizontal room.
- Prefer the standalone icon for favicons, app icons, social avatars, and compact controls.
- Keep the clear space already included in exported canvases. Do not crop tightly against the outermost mark.
- Recommended minimum digital widths: `160px` for the wordmark, `200px` for the combined lockup, and `32px` for the complete icon.
- Do not stretch, rotate, outline, add effects, introduce gradients, change the S-curve, rearrange the focus corners, or use unapproved colors.

## Directory Guide

```text
company/brand/
├── masters/            # Approved ImageGen visual references
├── exports/
│   ├── wordmark/       # PNG, SVG, PDF, and treatments
│   ├── combined/       # PNG, SVG, PDF, and treatments
│   ├── icon/           # PNG, SVG, PDF, treatments, and favicons
│   └── manifest.json   # Machine-readable package index
├── tools/              # Reproducible exporter
├── brand-colors.json
└── source-prompts.md
```

## Rebuild

From the repository root:

```bash
python company/brand/tools/export_brand_assets.py
```

The exporter uses Pillow and NumPy from the Codex workspace runtime and `rsvg-convert` for PDF output. It isolates the approved ImageGen geometry, removes generated lighting variation, applies exact HEX colors, and writes the complete export matrix.
