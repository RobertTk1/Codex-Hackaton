# Magic Mirror Design System

Status: Hackathon prototype identity using the working name Magic Mirror

Direction: Acid Dispatch / Editorial Edge

Final packet: [Magic Mirror Brandbook](./Magic-Mirror-Brandbook.pdf)

## 1. Brand summary

Magic Mirror helps online clothing shoppers and people who want to dress better make faster, more confident clothing decisions through personalized guidance and privacy-conscious virtual try-on.

The visual system combines a sharp editorial voice with practical product signals. Instrument Serif creates fashion-editorial moments; Space Grotesk carries product guidance and interface copy; Acid provides the high-energy action signal; Ink keeps the system grounded and legible.

Magic Mirror is a hackathon working title. This packet supports the prototype and does not imply a permanent startup name, live social account, or launched company profile.

## 2. Source assets

The production exports are authoritative. Do not redraw a mark from a mockup or regenerate it with ImageGen.

| Form | Authoritative source | Intended role |
| --- | --- | --- |
| Standard wordmark | [Acid SVG](../exports/wordmark/svg/magic-mirror-wordmark-acid.svg) | Name-first placements, navigation, presentations, and quiet editorial moments |
| Combined lockup | [Acid SVG](../exports/combined/svg/magic-mirror-combined-acid.svg) | Hero, sponsorship, and presentation placements where the icon replacing the `o` stays distinct |
| Complete standalone icon | [Acid SVG](../exports/icon/svg/magic-mirror-icon-acid.svg) | App icon, social avatar, merchandise, and compact placements at 32 px and above |
| Simplified favicon | [16 px PNG](../exports/icon/favicon/favicon-16x16.png) | Browser favicon at 16 px; uses the lens without the two focus corners |
| Export manifest | [manifest.json](../exports/manifest.json) | Machine-readable inventory of PNG, SVG, PDF, treatment, and favicon files |
| Palette source | [brand-colors.json](../brand-colors.json) | Exact Acid Dispatch anchors and default treatments |

The complete export package and reproducible rebuild instructions are documented in the [logo package README](../README.md).

## 3. Logo system

### Standard wordmark

Use the concept-01 wordmark when immediate name recognition matters. It retains the standard lowercase `o` in Mirror and is the quietest, most editorial signature.

- Preferred minimum digital width: 160 px.
- Preferred light treatment: Ink on White.
- Preferred dark treatment: Acid on Ink.
- Do not typeset the name to imitate the artwork.

### Combined lockup

The combined lockup replaces the `o` in Mirror with the concept-03 lens/focus icon. Use it for expressive brand moments with enough horizontal room.

- Preferred minimum digital width in this brandbook: 220 px.
- Absolute package baseline: never below 200 px.
- Keep the icon legible as an `o`; switch to the standard wordmark when it becomes ambiguous.

### Complete standalone icon

The complete icon contains the S-curve lens plus upper-left and lower-right focus corners.

- Minimum digital size: 32 px.
- Use for app tiles, avatars, compact controls, apparel, and merchandise.
- Do not move the corners, change the S-curve, or remove pieces.

### Simplified favicon

At 16 px, use the supplied simplified favicon. It intentionally omits the focus corners so the lens remains recognizable at browser scale. Never present the complete icon as the recommended 16 px favicon.

## 4. Logo usage rules

- Use supplied production assets without changing their proportions or internal geometry.
- Preserve the clear space included in exported canvases; do not crop tightly against the outermost mark.
- Prefer Ink on White, Acid on Ink, Ink on Acid, or Deep on Pale.
- Use White on Ink or White on Black only when a reversed mark is required.
- Keep monochrome variants as technical production fallbacks, not the primary brand expression.
- Use the wordmark when the name must be immediately readable, the combined lockup for spacious hero placements, and the icon for compact applications.
- Validate the surrounding surface against the calculated contrast data when the mark must also carry readable text.

## 5. What to avoid

- Do not stretch, compress, rotate, skew, outline, shadow, glow, or add gradients to logo artwork.
- Do not recolor the artwork outside the approved export variants.
- Do not place a light mark on Pale or another low-contrast surface.
- Do not shrink the complete icon below 32 px.
- Do not use the combined lockup when its icon no longer reads clearly as the `o`.
- Do not recreate the wordmark with Instrument Serif; the logo artwork and the display typeface are separate assets.

## 6. Primary palette

| Token | Hex | Primary role |
| --- | --- | --- |
| Acid | `#D7FF3F` | Signature signal, primary action, mark on dark surfaces |
| Ink | `#17171A` | Default text, dark surface, structural anchor |
| White | `#FFFFFF` | Default canvas and inverse text |
| Cloud | `#F4F3F1` | Quiet editorial and product surface |
| Pale | `#F2FFD0` | Supporting light surface and callout |
| Deep | `#263300` | Supporting dark green and text on Pale/Acid |
| Technical Black | `#000000` | Monochrome fallback and strongest technical text |

Designed UI and brand layers must use these anchors or the documented derived scales. Natural colors may appear inside ImageGen photography and environmental mockups, but they do not become brand tokens.

## 7. Secondary shades and tints

Secondary values are calculated, not independently chosen. The source script performs linear interpolation in OKLab between approved anchors and rounds the result to 8-bit sRGB.

| Scale | 50 | 100 | 200 | 300 | 400 | 500 | 600 | 700 | 800 | 900 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Acid | `#F2FFD0` | `#ECFFBA` | `#E7FFA2` | `#E1FF88` | `#DCFF69` | `#D7FF3F` | `#A6C72C` | `#78921B` | `#4D610A` | `#263300` |
| Neutral | `#F4F3F1` | `#D6D5D4` | `#B8B8B7` | `#9C9B9C` | `#808081` | `#666567` | `#515052` | `#3C3C3F` | `#29292C` | `#17171A` |

Canonical files: [brand-tokens.json](./tokens/brand-tokens.json), [brand-tokens.css](./tokens/brand-tokens.css), and [derived-palette.json](./tokens/derived-palette.json). Rebuild with [build_tokens.py](./source/build_tokens.py).

## 8. WCAG-approved pairings

The matrix uses WCAG 2.x relative luminance. AA requires 4.5:1 for normal text and 3.0:1 for large text. The full dataset covers all 484 ordered foreground/background combinations across 22 unique anchor and derived colors.

| Foreground on background | Ratio | Normal AA | Large AA |
| --- | ---: | :---: | :---: |
| Ink on Acid | 15.56:1 | Pass | Pass |
| Acid on Ink | 15.56:1 | Pass | Pass |
| Ink on White | 17.89:1 | Pass | Pass |
| White on Ink | 17.89:1 | Pass | Pass |
| Ink on Cloud | 16.13:1 | Pass | Pass |
| Deep on Pale | 12.85:1 | Pass | Pass |
| Deep on Acid | 11.74:1 | Pass | Pass |
| Acid on Deep | 11.74:1 | Pass | Pass |

Do not infer accessibility from palette membership. Check the exact pair in [wcag-matrix.json](./tokens/wcag-matrix.json), including hover, disabled, and small-label use.

## 9. Buttons and links

| Element/state | Surface | Text/border | Guidance |
| --- | --- | --- | --- |
| Primary/default | Acid `#D7FF3F` | Ink `#17171A` | Main decision such as Try it on |
| Primary/hover | Acid 600 `#A6C72C` | Ink `#17171A` | Preserve the label and shape |
| Secondary/default | Pale `#F2FFD0` or White | Deep `#263300` / Ink border | Supporting decision such as Choose garment |
| Secondary/hover | Acid 100 `#ECFFBA` | Deep `#263300` | Keep visual priority below primary |
| Link/default | Transparent | Deep `#263300` | Underline or provide another persistent affordance |
| Link/hover | Transparent | Ink `#17171A` | Do not rely on color alone |
| Disabled | Neutral 100 `#D6D5D4` | Neutral 600 `#515052` | Pair muted color with disabled behavior and semantics |

- Button radius: 999 px.
- Focus: 3 px Acid ring with an Ink offset/edge that remains visible on light and dark surfaces.
- Labels: Space Grotesk 600.
- Never remove focus treatment for keyboard input.

## 10. Badges, callouts, headers, and tooltips

- Badges use short uppercase Space Grotesk labels, 999 px radius, and high-contrast token pairs.
- Callouts use concise editorial copy; use Pale or Cloud for quiet surfaces and Instrument Serif only for short expressive lines.
- Headers use a thin Pale/Acid-derived rule, small uppercase kicker, compact Space Grotesk headline, and generous whitespace.
- Tooltips use a 12 px radius, compact Space Grotesk, and a verified high-contrast foreground/background pair.
- Focus brackets and the lens icon are precise interface signals, not decorative patterns to scatter across every surface.

## 11. Typography system

### Display: Instrument Serif

Use Regular 400 and Italic 400 for short hero lines, editorial pull quotes, and expressive moments. Local sources: [Regular](./assets/fonts/instrument-serif/InstrumentSerif-Regular.ttf), [Italic](./assets/fonts/instrument-serif/InstrumentSerif-Italic.ttf), and [OFL 1.1](./assets/fonts/instrument-serif/OFL.txt). Fallback: Times New Roman, serif.

### Product and UI: Space Grotesk

Use Space Grotesk 300-700 for headings below hero scale, body copy, labels, buttons, tables, numbers, and navigation. Local source: [variable font](./assets/fonts/space-grotesk/SpaceGrotesk%5Bwght%5D.ttf) and [OFL 1.1](./assets/fonts/space-grotesk/OFL.txt). Fallback: Inter, Arial, sans-serif.

| Style | Size | Line height | Tracking | Family/weight |
| --- | ---: | ---: | ---: | --- |
| Display | 72 px | 0.94 | -0.03em | Instrument Serif 400 |
| H1 | 56 px | 1.0 | -0.025em | Space Grotesk 700 |
| H2 | 40 px | 1.05 | -0.02em | Space Grotesk 700 |
| H3 | 28 px | 1.15 | -0.012em | Space Grotesk 600-700 |
| Lead | 22 px | 1.4 | -0.01em | Space Grotesk 400 |
| Body | 16 px | 1.55 | 0 | Space Grotesk 400 |
| Caption | 13 px | 1.4 | 0.01em | Space Grotesk 400-500 |
| Label | 12 px | 1.2 | 0.12em | Space Grotesk 600-700, uppercase |
| Number | 16 px | 1.2 | -0.01em | Space Grotesk 600, tabular figures |

## 12. Typography to avoid

- Do not use loose or cramped line spacing that separates or overlaps related text.
- Do not use negative tracking that causes letters to touch.
- Do not use extreme positive tracking in body copy.
- Do not set essential guidance, render states, privacy information, or controls below a readable body/caption size.
- Do not use Instrument Serif for paragraphs, product labels, form instructions, tables, or dense navigation.
- Do not use low-contrast type even when the pairing looks aesthetically soft.

## 13. Application examples

All application examples are raster mockups generated with the built-in ImageGen workflow and visually audited. HTML/CSS is used only for brandbook layout and token/UI specimens.

| Application | Final mockup | Usage note |
| --- | --- | --- |
| Business card | [business-card.png](./mockups/business-card.png) | Acid name-first face paired with Ink icon face |
| Billboard | [billboard.png](./mockups/billboard.png) | Acid combined lockup on an Ink environmental surface |
| Browser light | [browser-favicon-light.png](./mockups/browser-favicon-light.png) | Visible favicon, tab title, navigation, address, and light page identity |
| Browser dark | [browser-favicon-dark.png](./mockups/browser-favicon-dark.png) | Matching browser structure with an Ink/Acid dark treatment |
| Twitter/X | [x-profile.png](./mockups/x-profile.png) | Paired light and dark X profiles; Ink icon on White and White icon on Ink |
| LinkedIn | [linkedin-profile.png](./mockups/linkedin-profile.png) | LinkedIn-specific company and Experience structures, not an X relabel |
| T-shirt | [tshirt.png](./mockups/tshirt.png) | Complete Acid icon integrated into dark fabric |
| Compact mirror | [compact-mirror.png](./mockups/compact-mirror.png) | Complete Acid icon integrated into an Ink product surface |

The social handles and company/profile views are concepts only and do not claim live account availability or real engagement metrics.

## 14. Production notes and caveats

- Brandbook source: [brandbook.html](./source/brandbook.html) and [brandbook.css](./source/brandbook.css).
- Page format: US Letter landscape, 11 x 8.5 inches.
- Final PDF: 19 pages, rendered and verified back to 19 PNG previews at 2112 x 1632.
- Source previews: [pages/source](./pages/source/); PDF-derived previews: [pages/pdf](./pages/pdf/); [contact sheet](./pages/contact-sheet.png).
- Page composition follows the preserved Mayven reference for hierarchy, geometry, whitespace, and density only. No Mayven branding, copy, colors, travel imagery, or product claims are part of Magic Mirror.
- Application mockups may contain natural environmental colors, lighting, and device materials. Those pixels are contextual photography, not reusable design tokens.
- Exact ImageGen scene prompts, source inputs, and QA requirements are recorded in [asset-plan.md](./asset-plan.md) and the task audit files under [references](./references/).
- Re-render the PDF after any source, font, token, or image change, then inspect the PDF-derived previews again. Do not treat an HTML preview as final evidence.
- The name and identity are intentionally appropriate for a hackathon prototype and may change if the project becomes a real product.
