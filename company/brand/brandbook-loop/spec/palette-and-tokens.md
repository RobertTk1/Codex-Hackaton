# Palette And Tokens Spec

Use this file for palette, token, and WCAG work.

## Palette

Approved Acid Dispatch anchors:

- Acid `#D7FF3F`
- Deep `#263300`
- Pale `#F2FFD0`
- Ink `#17171A`
- White `#FFFFFF`
- Cloud `#F4F3F1`
- Technical Black `#000000`

Document:

- primary brand color;
- dark/ink color;
- white/light neutrals;
- approved secondary colors or derived shade scale;
- disallowed colors;
- shade derivation method.

Do not invent new colors. If a useful shade is needed, derive it from approved anchors and record the method.

## Tokens

Create JSON and CSS token files for:

- colors;
- typography;
- button radius;
- card radius;
- badge radius;
- focus ring;
- primary/secondary/link states.

## Typography

Lock real display and UI/body font families before brandbook page production. Preserve the selected Editorial Edge character: a high-contrast editorial display face paired with a clear contemporary interface sans. Save or reference actual font files, record licenses/sources, define fallback stacks, and add typography tokens for display, headings, lead, body, captions, labels, and numbers. Do not treat the wordmark artwork as a paragraph font.

## WCAG

Compute contrast ratios for all useful text/background palette pairings.

Use:

- normal text AA: 4.5:1;
- large text AA: 3.0:1.

Save raw contrast data under `company/brand/brandbook-packet/tokens/` and show a readable matrix in the PDF.
