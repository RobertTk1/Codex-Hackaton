# UI Asset Production from Mockups

## Purpose

Mockups often contain photographic or generated visual assets that cannot be implemented as empty placeholders, CSS boxes, or screenshot crops. A UI ticket must produce or select real assets before its final visual validation.

For the landing-page example, this includes the editorial hero portrait, report-book composition, fabric/color imagery, wardrobe imagery, and closing lifestyle image—not merely the page layout around them.

## Asset Inventory Subtask

Before final UI implementation:

1. Inspect every approved desktop/mobile mockup for the ticket.
2. List each distinct logo, icon, photograph, illustration, texture, product image, report preview, or decorative visual.
3. Record its screen/section, purpose, approximate aspect ratio, crop/focal point, required breakpoints, and whether text is baked into the image.
4. Search approved brand/product assets before generating anything new.
5. Mark each item `existing`, `generate`, `derive`, `provider-owned`, or `not-needed`.

This inventory may be delegated as a bounded subtask, but it remains part of the parent UI ticket.

## Production Rules

- Use the global `imagegen` skill for new raster images or edits.
- Use `imagegen-frontend-web` when translating a screen reference into web-ready visual direction and responsive asset requirements.
- Never recreate photographic imagery as HTML or SVG.
- Do not simply crop an image out of a low-resolution mockup and ship it as a production asset.
- Use the approved logo files directly.
- Use Lucide for interface icons rather than generating icon bitmaps.
- Do not bake customer-facing copy into imagery unless the approved design explicitly requires a non-HTML artifact.
- Preserve consent, likeness, licensing, and retailer-image constraints from the project contracts.

## File and Performance Requirements

- Store assets in the application asset structure named by the ticket or project conventions.
- Use descriptive stable filenames, not generated UUID-only names.
- Produce appropriate dimensions and responsive variants; avoid shipping the largest source to every viewport.
- Prefer modern web formats when quality and browser support allow.
- Set explicit dimensions/aspect ratio to prevent layout shift.
- Provide useful alt text for informative images and empty alt text for decorative images.

## Verification

- The implemented screen contains every required asset or an approved fallback.
- Crop, focal point, palette, contrast, and narrative role match the mockup.
- Assets remain sharp at target viewports and do not cause unacceptable page weight or layout shift.
- Generated assets are reviewed before the UI ticket can pass.
