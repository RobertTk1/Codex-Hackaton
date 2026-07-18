# Imagegen Asset Plan Spec

Use this file for asset planning and mockup generation.

## Core rule

Do not generate mockups until `company/brand/brandbook-packet/asset-plan.md` exists.

The plan must identify:

- every required brandbook page;
- every image asset needed by that page;
- which assets are existing PNG/JPG files;
- which assets are generated with imagegen;
- which assets are deterministic HTML/CSS screenshots;
- output path, prompt, references, and verification method for each mockup.

Approved identity inputs:

- Wordmark: `company/brand/exports/wordmark/png/transparent/acid/magic-mirror-wordmark-acid-2048px.png`
- Combined lockup: `company/brand/exports/combined/png/transparent/acid/magic-mirror-combined-acid-2048px.png`
- Standalone icon: `company/brand/exports/icon/png/transparent/acid/magic-mirror-icon-acid-1024px.png`
- Small favicon: `company/brand/exports/icon/favicon/favicon-16x16.png`
- Palette source: `company/brand/brand-colors.json`

Prefer transparent exact-color PNGs as ImageGen references. Do not use presentation-board crops when an exported mark exists.

## Mockup QA gate

For photorealistic mockups, prefer a complete imagegen-generated mockup first: environment, object, brand layer, logo, and any required visible copy in one pass.

Accept only if it is roughly 95% accurate on logo/icon fidelity, spelling, physical integration, palette compliance, and absence of unrelated marks or watermarks.

If the complete imagegen pass fails, try one targeted imagegen iteration before deterministic local compositing. Use exact compositing only as fallback or finishing pass.

## Raster-only mockups

All finished mockups must be raster images. Do not create SVG mockups.

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
