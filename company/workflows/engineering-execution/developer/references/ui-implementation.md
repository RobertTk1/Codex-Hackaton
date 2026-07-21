# UI Implementation and Mockup Validation

## UI Foundation

Use this hierarchy consistently:

1. Existing project shared component.
2. Existing shadcn/ui component configured for the project's Base UI foundation.
3. Base UI primitive composed into the shared layer when shadcn does not cover the required behavior.
4. A new shared composition only when the ticket demonstrates a real reusable need.

Use Tailwind and approved design tokens for styling. Use Lucide for interface icons. Do not mix primitive libraries for the same component family or create a second icon system.

## Before Coding the Screen

- Read the ticket's active screen IDs, desktop/mobile mockups, interaction specifications, copy, and screen-data contract.
- Confirm archived/replaced screen states are excluded.
- Inventory existing components, tokens, logos, icons, typefaces, and visual assets.
- Complete the asset workflow in `asset-production.md` before final layout work.
- Identify required base, loading, empty, partial, error, slow, success, confirmation, and recovery states.

## Responsive and Accessible Implementation

- Match the approved hierarchy and composition at the ticket's required viewports.
- Use semantic HTML, labeled controls, logical headings, visible focus, keyboard parity, and appropriate live regions.
- Preserve touch target size and distance-readable controls where the product is used away from the device.
- Honor `prefers-reduced-motion` and do not encode meaning through animation alone.

## Adjusted 90% Similarity Gate

UI tickets require at least 90% similarity after approved substitutions are normalized.

Score:

- Layout and section order.
- Relative dimensions and alignment.
- Spacing and density.
- Typography hierarchy and line length.
- Colors, borders, radii, shadows, and visual weight.
- Image placement, crop, and composition.
- Control placement and responsive behavior.

Do not penalize:

- Using the approved production logo file when a generated mockup approximated or misspelled the logo.
- Using the semantically correct Lucide icon when the mockup rendered an approximate glyph.
- Minor antialiasing or font-rendering differences across environments.
- Approved image-generation variation that preserves the required subject, crop, palette, visual balance, and narrative role.

Logo/icon substitutions still must match the mockup's size, placement, stroke/fill weight, contrast, and role. Exclusion is not permission to use an unrelated asset.

## Visual Evidence

Capture the implemented viewport at the exact comparison dimensions. Record:

- Raw similarity result.
- Adjusted result and each excluded production-asset region.
- Overlay/diff or written findings.
- Responsive screenshots.
- Accessibility and console/network results.

Below 90% adjusted similarity means `passes: false` with specific repair notes.
