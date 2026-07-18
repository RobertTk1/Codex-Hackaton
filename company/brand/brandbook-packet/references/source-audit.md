# Magic Mirror Brandbook Source Audit

Audit date: 2026-07-18

## Positioning

Magic Mirror helps online clothing shoppers and people who want to dress better make faster, more confident clothing decisions through personalized outfit guidance and privacy-conscious virtual try-on.

The name remains a hackathon working title. The brandbook supports the prototype and does not imply that the identity is a permanent startup commitment.

## Approved identity sources

| Asset | Source path | Role |
| --- | --- | --- |
| Standard wordmark | `company/brand/exports/wordmark/svg/magic-mirror-wordmark-acid.svg` | Immediate name recognition and wide placements |
| Combined lockup | `company/brand/exports/combined/svg/magic-mirror-combined-acid.svg` | Primary expressive lockup; concept-03 icon replaces the `o` |
| Standalone icon | `company/brand/exports/icon/svg/magic-mirror-icon-acid.svg` | App icon, social avatar, compact brand placements at 32px and above |
| Simplified favicon | `company/brand/exports/icon/favicon/favicon-16x16.png` | Browser favicon at 16px; lens only without focus corners |
| Palette source | `company/brand/brand-colors.json` | Exact Acid Dispatch anchors and default treatments |
| Usage source | `company/brand/README.md` | Clear space, minimum sizes, treatments, and misuse guidance |

The logo artwork is the identity source of truth. It must not be regenerated or treated as a typeface.

## Approved Acid Dispatch anchors

| Token | HEX | Role |
| --- | --- | --- |
| Acid | `#D7FF3F` | Primary signal and dark-surface mark |
| Deep | `#263300` | Soft-treatment text and supporting dark green |
| Pale | `#F2FFD0` | Soft surface and selected-state tint |
| Ink | `#17171A` | Default text and dark surface |
| White | `#FFFFFF` | Clean light surface and inverse mark |
| Cloud | `#F4F3F1` | Editorial neutral surface |
| Black | `#000000` | Technical monochrome fallback only |

## Derived-color method

Secondary scales are not independently invented colors. They are calculated by linear interpolation in OKLab between approved anchors, then rounded to 8-bit sRGB hex:

- Acid 50–500 interpolates from Pale to Acid; Acid 600–900 interpolates from Acid to Deep.
- Neutral 50–900 interpolates from Cloud to Ink; White is Neutral 0.
- The reproducible implementation is `company/brand/brandbook-packet/source/build_tokens.py`.
- Exact outputs are saved in `tokens/derived-palette.json`.

Disallowed designed colors are any colors outside the approved anchors or the documented derived scales. Natural environmental colors may appear in photography/mockups, but UI elements, typography, and applied brand layers must remain on-token. Gradients inside logo artwork are disallowed.

## Typography lock

### Display: Instrument Serif

- Use: hero display, chapter openings, expressive pull quotes, and large editorial numerals.
- Weight/style: Regular 400 and Italic 400.
- Rationale: a condensed contemporary editorial serif that complements the approved high-contrast wordmark without imitating it.
- Local files: `assets/fonts/instrument-serif/InstrumentSerif-Regular.ttf` and `InstrumentSerif-Italic.ttf`.
- Fallback: `'Times New Roman', serif`.
- Source: <https://github.com/google/fonts/tree/main/ofl/instrumentserif>
- License: SIL Open Font License 1.1; local `OFL.txt` included.

### UI and body: Space Grotesk

- Use: headings below hero scale, body copy, captions, labels, buttons, navigation, tables, and numbers.
- Weight range: variable 300–700; default body 400, medium 500, semibold 600, bold 700.
- Rationale: a readable contemporary grotesk with enough idiosyncratic detail to match Editorial Edge while remaining practical in product UI.
- Local file: `assets/fonts/space-grotesk/SpaceGrotesk[wght].ttf`.
- Fallback: `Inter, Arial, sans-serif`.
- Source: <https://github.com/google/fonts/tree/main/ofl/spacegrotesk>
- License: SIL Open Font License 1.1; local `OFL.txt` included.

## Production cautions

- Use the complete icon at 32px and above. Use the simplified lens-only favicon at 16px.
- Keep the standard wordmark available; the combined lockup does not replace it in every context.
- Use monochrome variants only when production constraints prevent an Acid Dispatch treatment.
- Validate exact color contrast through calculated WCAG data before declaring text/background pairings accessible.
