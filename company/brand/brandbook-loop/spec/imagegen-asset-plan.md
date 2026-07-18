# Imagegen Asset Plan Spec

Use this file for asset planning and mockup generation.

## Core rule

Do not generate mockups until `company/brand/brandbook-packet/asset-plan.md` exists.

The plan must identify:

- every required brandbook page;
- every image asset needed by that page;
- which assets are existing PNG/JPG files;
- which assets are generated with imagegen;
- output path, prompt, references, and verification method for each mockup.

Every application mockup must use built-in ImageGen, including browser/favicon, social profile, device, product, environment, apparel, and merchandise scenes. HTML/CSS is allowed only for brandbook page source and non-mockup token/UI specimens. Browser/favicon mockups require separate light and dark generated images.

Approved identity inputs:

- Wordmark: `company/brand/exports/wordmark/png/transparent/acid/magic-mirror-wordmark-acid-2048px.png`
- Combined lockup: `company/brand/exports/combined/png/transparent/acid/magic-mirror-combined-acid-2048px.png`
- Standalone icon: `company/brand/exports/icon/png/transparent/acid/magic-mirror-icon-acid-1024px.png`
- Small favicon: `company/brand/exports/icon/favicon/favicon-16x16.png`
- Palette source: `company/brand/brand-colors.json`

Prefer transparent exact-color PNGs as ImageGen references. Do not use presentation-board crops when an exported mark exists.

## Mockup QA gate

For every application mockup, prefer a complete ImageGen-generated mockup first: environment or interface context, object/device, brand layer, logo, and any required visible copy in one pass.

Accept only if it is roughly 95% accurate on logo/icon fidelity, spelling, physical integration, palette compliance, and absence of unrelated marks or watermarks.

If the complete imagegen pass fails, try one targeted imagegen iteration before deterministic local compositing. Use exact compositing only as fallback or finishing pass.

## Raster-only mockups

All finished mockups must be ImageGen-created raster images. Do not create HTML/CSS, SVG, canvas, or deterministic UI mockups.

## Prompt scaffold

```text
Use case: product-mockup
Asset type: <business card / billboard / t-shirt / merch / phone mockup>
Primary request: Create a premium Magic Mirror brand mockup for <asset>.
Input images: Image 1: logo reference; Image 2: icon reference; Image 3: palette/style reference if available.
Scene/backdrop: <specific setting>
Subject: <object/surface carrying brand logo>
Style/medium: photorealistic product mockup
Composition/framing: clean brandbook-ready composition with generous whitespace
Lighting/mood: polished, premium, brand-appropriate
Color palette: Acid #D7FF3F, Deep #263300, Pale #F2FFD0, Ink #17171A, White #FFFFFF, Cloud #F4F3F1, and technical Black #000000 only for brand elements
Text (verbatim): "<only exact text if needed>"
Constraints: preserve the logo shape; no redesign; no unrelated brand colors; no watermark; no extra logos
Avoid: distorted logo, illegible text, gradients inside the logo, shadows added to logo artwork
```

## Visual verification

A mockup passes only if logo/icon is recognizable, palette is compliant, text is legible, no watermarks or unrelated logos appear, and the image fits the brand tone.

Browser/favicon QA requires both light and dark outputs, visible approved favicon/lockup assets, no copied reference-brand names, and no unrelated branding. Social QA requires an ImageGen-created profile/device scene, recognizable production assets, exact required copy or a corrected raster finishing pass after the permitted retry, and no live-account or invented-metric implication.
