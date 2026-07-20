# Magic Mirror Screen Mockup Design Direction

Status: Ready for representative-screen review  
Run mode: Full package, gated by representative direction approval  
Direction: Acid Dispatch / Editorial Edge

## Source authority

- UX structure: `company/artifacts/ui-ux-design/wireframe-manifest.json`
- Exact customer copy: `company/artifacts/copy/copy-manifest.json`
- Voice: `company/voice.md`
- Brand system: `company/brand/brandbook-packet/DESIGN.md`
- Tokens: `company/brand/brandbook-packet/tokens/brand-tokens.json`
- Logo exports: `company/brand/exports/`

Generated lettering is a visual approximation. The copy manifest remains the implementation source of truth.

## Core visual idea

Magic Mirror feels like an independent fashion magazine that became a useful product. The editorial layer creates desire and point of view; the product layer turns that energy into calm, obvious decisions.

- **Marketing expression:** art-directed fashion imagery, assertive scale changes, off-grid editorial tension, generous whitespace, and occasional full Ink or Acid fields.
- **Product expression:** White and Cloud canvases, Space Grotesk clarity, restrained cards, obvious Acid actions, and compact editorial moments only where they help orientation.
- **Shared signal:** the focus-bracket icon language marks selections, active states, and moments of attention. It is precise and sparse, never a scattered decoration.

## Combinatorial direction

- Theme paradigm: Pristine Light Mode, interrupted by controlled Bold Studio Solid fields.
- Background character: quiet tactile paper on marketing surfaces; pure solid product surfaces.
- Typography character: Instrument Serif and refined grotesk pairing.
- Marketing architecture: editorial offset composition with an asymmetric premium flow.
- Application structure: Swiss grid discipline.
- Signature components: Off-Grid Editorial Layout; Layered Image Crop Frames; Vertical Rhythm Lines; Product UI Panel Stack.
- Motion-implied cues: staggered float-up energy and pinned narrative section energy.

## Color roles

| Role | Token | Use |
| --- | --- | --- |
| Signature action | Acid `#D7FF3F` | Primary buttons, selected states, short badges, purposeful rules |
| Structural anchor | Ink `#17171A` | Text, dark sections, outlines, navigation |
| Primary canvas | White `#FFFFFF` | Marketing and product background |
| Quiet surface | Cloud `#F4F3F1` | Forms, cards, report modules, subtle section changes |
| Supporting light | Pale `#F2FFD0` | Calm callouts and selected secondary content |
| Supporting dark | Deep `#263300` | Text on Pale/Acid and occasional editorial fields |

Acid is a signal, not wallpaper. Natural wardrobe and skin colors may appear in photography but do not become interface tokens.

## Typography

- Instrument Serif: short hero statements, editorial section openers, report pull-outs, and selected expressive numerals.
- Space Grotesk: navigation, product headings, body copy, forms, labels, buttons, status, and data.
- Marketing desktop display: approximately 72–104 px with compact line height; mobile 48–64 px.
- Product H1: approximately 40–56 px desktop and 32–40 px mobile.
- Body: 16–18 px desktop and 16 px mobile.
- Uppercase labels are brief and tracked; never use them as paragraph text.

## Components

- Primary button: Acid fill, Ink label, fully rounded 999 px radius.
- Secondary button: White or Pale fill, Ink/Deep label, 1–2 px Ink border, same radius.
- Focus: visible Acid ring with Ink edge/offset.
- Cards: 24 px radius on application surfaces; marketing imagery may use sharp editorial crops where the wireframe allows.
- Borders: thin Neutral 200 or Ink; no generic glass panels.
- Shadows: nearly flat. Use a restrained, broad shadow only for product previews that need depth.
- Icons: simple, high-contrast, geometric strokes. Use the supplied Magic Mirror mark without redrawing it.

## Marketing imagery

Use inclusive, contemporary editorial fashion photography showing real full-body styling and varied personal expression. Images feel commissioned: decisive crops, clear garments, soft studio light, and tactile fabric detail. Avoid influencer clichés, luxury-beige sameness, beauty-ranking language, distorted bodies, fake testimonials, retailer logos, or invented proof.

The landing page story moves from personal possibility to a tangible report preview, then through the three-step process, report contents, trust, FAQ, and action. The product and photography carry the story; copy remains secondary.

## Application imagery

Images are user content, garments, report visuals, or the live mirror—not decoration. Form screens remain calm and sparse. Report screens may use color chips, silhouette sketches, and outfit photography. Live styling prioritizes a large camera view and distance-readable controls.

## Responsive behavior

- Desktop uses wide editorial tension and visible relationships between copy and imagery.
- Mobile uses one clear narrative column, full-width actions, larger touch targets, and intentional image recrops.
- Mobile is recomposed from its approved wireframe; it is never a scaled desktop screenshot.
- Preserve the exact section order and primary action at every viewport.

## State behavior

Processing and waiting use purposeful progress signals without AI glows. Error and recovery use calm Cloud/Pale panels, concise state language, and one obvious next action. Permission screens make the requested capability visually clear. Success states feel editorial and confident without confetti.

## Prohibited visual additions

- No device or browser frame around the final comp.
- No presentation board, annotations, alternate screens, or multi-state collage.
- No fabricated metrics, reviews, customer logos, prices, retailer partnerships, or new product features.
- No purple/blue AI gradients, glassmorphism stacks, floating orbs, meaningless charts, or generic dashboard card spam.
- No restructuring of the approved wireframe or replacement of approved copy.

## Representative approval gate

Generate the Landing Page — Base in desktop and mobile first. After founder approval, reuse the confirmed color roles, typography, button system, image treatment, spacing rhythm, focus language, and chrome across the remaining 47 screen/state records.
