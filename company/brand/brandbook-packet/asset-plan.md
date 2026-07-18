# Magic Mirror Brandbook Asset Plan

Status: approved production plan; mockup generation has not started

Brand direction: Acid Dispatch / Editorial Edge

Page count: 19

## Production rules

- Approved identity geometry comes only from `company/brand/exports/`; never regenerate the wordmark, lockup, icon, or favicon from memory.
- Use ImageGen for realistic physical mockups where material, perspective, and lighting integration matter.
- Use deterministic HTML/CSS screenshots for browser and social interfaces where exact text and spacing matter more than photorealism.
- Every finished mockup is a raster PNG under `company/brand/brandbook-packet/mockups/`. No SVG mockup outputs.
- ImageGen gets one complete-scene attempt, visual inspection, and one targeted retry if the brand layer is below roughly 95% fidelity. Exact compositing is the finishing fallback only after that retry.
- Environmental photography may contain natural colors; designed brand layers and UI elements use only approved anchors or documented derived tokens.
- The complete icon is used at 32px and above. The simplified lens-only favicon is used at 16px.

## Source aliases

| Alias | Exact source path | Use |
| --- | --- | --- |
| `WORDMARK_ACID` | `company/brand/exports/wordmark/png/transparent/acid/magic-mirror-wordmark-acid-2048px.png` | Wordmark on Ink/dark surfaces |
| `WORDMARK_INK` | `company/brand/exports/wordmark/png/transparent/ink/magic-mirror-wordmark-ink-2048px.png` | Wordmark on Acid/light surfaces |
| `LOCKUP_ACID` | `company/brand/exports/combined/png/transparent/acid/magic-mirror-combined-acid-2048px.png` | Combined lockup on Ink/dark surfaces |
| `LOCKUP_INK` | `company/brand/exports/combined/png/transparent/ink/magic-mirror-combined-ink-2048px.png` | Combined lockup on Acid/light surfaces |
| `ICON_ACID` | `company/brand/exports/icon/png/transparent/acid/magic-mirror-icon-acid-1024px.png` | Complete icon on Ink/dark surfaces |
| `ICON_INK` | `company/brand/exports/icon/png/transparent/ink/magic-mirror-icon-ink-1024px.png` | Complete icon on Acid/light surfaces |
| `FAVICON_16` | `company/brand/exports/icon/favicon/favicon-16x16.png` | Simplified browser favicon at 16px |
| `PALETTE` | `company/brand/brand-colors.json` | Exact Acid Dispatch anchors and treatments |
| `TOKENS` | `company/brand/brandbook-packet/tokens/brand-tokens.json` | Derived colors, typography, radii, states, and focus rules |
| `TYPE_CSS` | `company/brand/brandbook-packet/tokens/brand-tokens.css` | Local font faces and CSS variables |

## Page-by-page matrix

| # | Page | Method | Required existing assets/data | New raster or data output | Production plan | Visual verification |
| --- | --- | --- | --- | --- | --- | --- |
| 01 | Logo on dark background | Existing asset + HTML/CSS | `LOCKUP_ACID`, Ink token | `pages/source/page-01-logo-dark.png` | Center the Acid combined lockup on a full Ink field with only edition/footer metadata. | Correct lockup geometry; exact Acid/Ink; generous clear space; no effects. |
| 02 | Logo on light background | Existing asset + HTML/CSS | `WORDMARK_INK`, White and Cloud tokens | `pages/source/page-02-logo-light.png` | Center the Ink standard wordmark on White with a narrow Cloud editorial rule. | Standard `o` remains present; no icon substitution; exact light treatment. |
| 03 | Table of contents | HTML/CSS | `TYPE_CSS`, page titles | `pages/source/page-03-contents.png` | Four editorial groups: Identity, Color & UI, Applications, Typography. | All 19 pages represented once; page numbers match final order. |
| 04 | Logo usage | Existing assets + HTML/CSS | `WORDMARK_ACID`, `WORDMARK_INK`, `LOCKUP_ACID`, `LOCKUP_INK`, `ICON_ACID`, `ICON_INK`, `FAVICON_16` | `pages/source/page-04-logo-usage.png` | Show standard wordmark, expressive lockup, complete icon, and small favicon with minimum-size/clear-space labels. | No geometry drift; complete icon shown at 32px+; simplified favicon shown at 16px. |
| 05 | What to avoid | Existing assets + HTML/CSS | `LOCKUP_INK`, `ICON_INK`, tokens | `pages/source/page-05-logo-avoid.png` | Deterministic incorrect examples: stretch, rotate, gradient, shadow, outline, recolor, corner rearrangement, low contrast, undersized full icon. | Every example is visibly marked incorrect; no misuse can be mistaken for approval. |
| 06 | Primary colors | Token data + HTML/CSS | `PALETTE`, `TOKENS` | `pages/source/page-06-primary-colors.png` | Present Acid, Ink, White, and Cloud with exact HEX, role, and default pairings. | HEX values match token source; primary operational set is unambiguous. |
| 07 | Secondary colors | Token data + HTML/CSS | `tokens/derived-palette.json`, `PALETTE` | `pages/source/page-07-secondary-colors.png` | Show Deep, Pale, and the documented Acid/neutral OKLab scales with method note. | Every shown color exists in derived-palette JSON; no new swatches. |
| 08 | Buttons and links | HTML/CSS screenshot | `TOKENS`, `TYPE_CSS` | `pages/source/page-08-buttons-links.png` | Render primary/secondary buttons, text links, hover, focus, and disabled states from tokens. | Exact labels; focus states visible; only token colors/radii used. |
| 09 | Brand elements and guidelines | HTML/CSS screenshot | `TOKENS`, `TYPE_CSS`, `ICON_INK` | `pages/source/page-09-elements.png` | Render badges, callouts, header blocks, tooltips, focus markers, and editorial rules. | Components feel related; icon remains intact; no off-token colors. |
| 10 | WCAG color compliance | Calculated data + HTML/CSS | future `tokens/wcag-matrix.json`, `TYPE_CSS` | `pages/source/page-10-wcag.png` | Render calculated contrast matrix with ratios and AA normal/large status. | Values come from JSON; thresholds 4.5:1 and 3.0:1 are stated. |
| 11 | Business card mockup | ImageGen | `LOCKUP_INK`, `ICON_ACID`, `PALETTE` | `mockups/business-card.png` | Generate two physically realistic editorial cards using Prompt IG-01 below. | ≥95% mark fidelity; exact visible copy; convincing paper/print integration; no watermark. |
| 12 | Billboard mockup | ImageGen | `LOCKUP_ACID`, `PALETTE` | `mockups/billboard.png` | Generate one fashion-district billboard with the lockup as the only visible brand copy using Prompt IG-02. | Lockup legible at page scale; no fake brands; Acid-on-Ink brand layer integrated into billboard. |
| 13 | Favicon/browser mockups | HTML/CSS screenshot | `FAVICON_16`, `ICON_ACID`, `TYPE_CSS`, `TOKENS` | `mockups/browser-favicon.png` | Render a deterministic browser tab/address-bar specimen using Screenshot DS-01. | Exact title/address; 16px lens-only favicon clear; full icon shown separately at 32px+. |
| 14 | Twitter/X mockup | HTML/CSS screenshot | `ICON_ACID`, `LOCKUP_INK`, `TYPE_CSS`, `TOKENS` | `mockups/x-profile.png` | Render a deterministic concept profile using Screenshot DS-02. | Exact profile copy; concept/non-live label present; no text clipping; correct icon. |
| 15 | LinkedIn mockup | HTML/CSS screenshot | `ICON_ACID`, `LOCKUP_INK`, `TYPE_CSS`, `TOKENS` | `mockups/linkedin-profile.png` | Render a deterministic company-profile concept using Screenshot DS-03. | Exact profile copy; concept/non-live label present; no false follower/customer claims. |
| 16 | T-shirt mockup | ImageGen | `ICON_ACID`, `PALETTE` | `mockups/tshirt.png` | Generate an Ink heavyweight crewneck with an Acid icon screen print using Prompt IG-03. | Icon shape ≥95% accurate; print follows fabric; no text, extra graphics, or unrelated logos. |
| 17 | Merchandise mockup | ImageGen | `ICON_ACID`, `PALETTE` | `mockups/compact-mirror.png` | Generate a premium Ink compact mirror with the Acid icon using Prompt IG-04. | Icon ≥95% accurate; enamel/print physically integrated; mirror/reflection plausible; no extra branding. |
| 18 | Typography | Local fonts + HTML/CSS | Instrument Serif files, Space Grotesk variable font, `TOKENS`, `TYPE_CSS` | `pages/source/page-18-typography.png` | Show real font specimens, hierarchy, weights, scale, tracking, and usage roles. | Font files load; display and UI roles distinct; specimens match token values. |
| 19 | Typography what to avoid | Local fonts + HTML/CSS | Instrument Serif files, Space Grotesk variable font, `TOKENS` | `pages/source/page-19-type-avoid.png` | Show tight line-height, loose/tight tracking, low contrast, tiny display serif, and too many weights. | Each misuse has a corrected counterpart and cannot be mistaken for guidance. |

## ImageGen prompts

### IG-01 — Business card

```text
Use case: product-mockup
Asset type: Magic Mirror business card brandbook mockup
Primary request: Create a premium photorealistic mockup of two overlapping Magic Mirror business cards.
Input images: Image 1: LOCKUP_INK, the exact approved combined lockup for the Acid card; Image 2: ICON_ACID, the exact approved standalone icon for the Ink card.
Scene/backdrop: seamless Cloud #F4F3F1 studio surface with generous clean margin.
Subject: one uncoated Acid #D7FF3F card with the Ink #17171A combined lockup; one uncoated Ink #17171A card with the Acid #D7FF3F icon and minimal small copy.
Style/medium: photorealistic premium print/product photography; subtle paper grain; crisp print registration.
Composition/framing: landscape 3:2, slightly elevated three-quarter view, cards overlapping without hiding either brand mark.
Lighting/mood: soft editorial studio light, restrained shadow, fashion-magazine art direction.
Color palette: Acid #D7FF3F, Ink #17171A, and Cloud #F4F3F1 only for designed surfaces.
Text (verbatim): "AI VIRTUAL TRY-ON" and "HACKATHON PROTOTYPE • 2026". The approved lockup already supplies the brand name; do not typeset it again.
Constraints: preserve both supplied marks exactly; physically print them into the paper surface; keep all visible copy correctly spelled; no contact details or real account claims.
Avoid: redesigned logo, distorted letters, extra logos, gradients inside marks, foil effects, glossy plastic, watermark, hands, or unrelated props.
```

Target: `1536×1024` PNG. Inputs: `LOCKUP_INK`, `ICON_ACID`. Final: `mockups/business-card.png`.

QA: inspect exact lockup/icon shapes, both copy lines, Acid/Ink dominance, paper integration, unrelated marks, watermarks, and useful page crop. Retry once with a single correction if any fidelity dimension is below roughly 95%; composite only after that retry.

### IG-02 — Billboard

```text
Use case: product-mockup
Asset type: Magic Mirror billboard brandbook mockup
Primary request: Create a cinematic but realistic street-level photograph of a large Magic Mirror fashion billboard.
Input images: Image 1: LOCKUP_ACID, the exact approved combined lockup.
Scene/backdrop: contemporary fashion district at blue hour; restrained architecture; pedestrians distant and anonymous; no visible store brands.
Subject: one large Ink #17171A billboard carrying only the Acid #D7FF3F combined lockup, centered with generous clear space.
Style/medium: photorealistic environmental advertising photography.
Composition/framing: landscape 3:2, billboard dominant and front-facing enough for the lockup to remain legible at brandbook scale.
Lighting/mood: moody editorial city light with realistic billboard illumination; energetic but premium.
Color palette: Acid #D7FF3F and Ink #17171A for the billboard design; natural restrained environmental colors outside it.
Text (verbatim): no additional text; the supplied lockup is the only visible copy.
Constraints: preserve the lockup exactly and integrate it into the printed/illuminated billboard surface.
Avoid: fake fashion brands, extra logos, duplicated signage, altered spelling, gradients inside the lockup, watermarks, extreme perspective, or illegible distance.
```

Target: `1536×1024` PNG. Input: `LOCKUP_ACID`. Final: `mockups/billboard.png`.

QA: inspect lockup fidelity/legibility, billboard integration, absence of fake brands, palette, lighting, watermark, and page-ready crop. Retry once before any exact finishing composite.

### IG-03 — T-shirt

```text
Use case: product-mockup
Asset type: Magic Mirror T-shirt brandbook mockup
Primary request: Create a premium photorealistic heavyweight crewneck T-shirt carrying the Magic Mirror icon.
Input images: Image 1: ICON_ACID, the exact approved complete standalone icon.
Scene/backdrop: quiet Cloud #F4F3F1 studio sweep with no props.
Subject: single Ink #17171A heavyweight cotton crewneck, front facing, with a medium Acid #D7FF3F icon screen print centered high on the chest.
Style/medium: premium fashion e-commerce/editorial product photography; real cotton texture and construction.
Composition/framing: landscape 3:2 with the complete garment visible and generous margin.
Lighting/mood: soft directional studio lighting, refined and tactile.
Color palette: Ink #17171A garment, Acid #D7FF3F print, Cloud #F4F3F1 background.
Text (verbatim): none.
Constraints: preserve the complete icon including both focus corners; integrate print with fabric folds and texture.
Avoid: wordmark, slogans, extra graphics, model, hanger, unrelated labels, altered icon, glow, foil, watermark, or dramatic wrinkles across the mark.
```

Target: `1536×1024` PNG. Input: `ICON_ACID`. Final: `mockups/tshirt.png`.

QA: inspect complete icon fidelity, both focus corners, print/fabric integration, approved colors, garment construction, absence of text/brands/watermark, and useful crop. Retry once before exact finishing.

### IG-04 — Compact mirror merchandise

```text
Use case: product-mockup
Asset type: Magic Mirror compact-mirror merchandise mockup
Primary request: Create a premium photorealistic branded compact mirror for Magic Mirror.
Input images: Image 1: ICON_ACID, the exact approved complete standalone icon.
Scene/backdrop: Pale #F2FFD0 matte editorial surface with generous negative space.
Subject: round compact mirror in smooth Ink #17171A enamel, partially open, with the Acid #D7FF3F icon centered on the lid; mirror glass visible but not reflecting a person.
Style/medium: luxury beauty-accessory product photography with precise material detail.
Composition/framing: landscape 3:2, elevated three-quarter view, compact centered slightly off-axis with clean margin.
Lighting/mood: soft premium studio light; controlled enamel highlight; calm editorial mood.
Color palette: Ink #17171A, Acid #D7FF3F, Pale #F2FFD0 for designed surfaces.
Text (verbatim): none.
Constraints: preserve the complete icon and physically integrate it as a crisp enamel/printed lid mark; keep mirror reflection neutral.
Avoid: wordmark, extra text, cosmetics, hands, faces, unrelated logos, distorted icon, chrome gradients inside the icon, watermark, or busy props.
```

Target: `1536×1024` PNG. Input: `ICON_ACID`. Final: `mockups/compact-mirror.png`.

QA: inspect complete icon fidelity, focus corners, enamel integration, plausible hinge/glass, approved brand colors, no person reflection, no extra branding/watermark, and page-ready crop. Retry once before exact finishing.

## Deterministic screenshot plans

### DS-01 — Browser and favicon

- Source: `source/specimens/browser-favicon.html` using `TYPE_CSS` and local assets.
- Canvas: `1600×1000`; final `mockups/browser-favicon.png`.
- Exact browser tab title: `Magic Mirror — Virtual Try-On`.
- Exact address: `magicmirror.example/demo` (`.example` intentionally signals a non-live concept).
- Show `FAVICON_16` at true 16px in the tab; show `ICON_ACID` separately at 32px and 64px with captions.
- QA: pixel dimensions, exact title/address, no browser trademark logo, favicon legibility at 100% scale, complete icon only at 32px+, local font/asset resolution.

### DS-02 — X profile concept

- Source: `source/specimens/x-profile.html` using `TYPE_CSS`, `ICON_ACID`, and `LOCKUP_INK`.
- Canvas: `1600×1000`; final `mockups/x-profile.png`.
- Exact display name: `Magic Mirror`.
- Exact handle: `@magicmirror_demo`.
- Exact bio: `AI virtual try-on for more confident clothing decisions. Hackathon prototype.`
- Exact status label: `CONCEPT PROFILE • NOT A LIVE ACCOUNT`.
- QA: all text verbatim, no invented verification badge/follower metrics, concept label visible, profile icon and Acid banner correct, no clipping or off-token UI color.

### DS-03 — LinkedIn company profile concept

- Source: `source/specimens/linkedin-profile.html` using `TYPE_CSS`, `ICON_ACID`, and `LOCKUP_INK`.
- Canvas: `1600×1000`; final `mockups/linkedin-profile.png`.
- Exact company name: `Magic Mirror`.
- Exact descriptor: `AI-powered virtual try-on • Hackathon prototype`.
- Exact about line: `Helping shoppers make faster, more confident clothing decisions.`
- Exact status label: `CONCEPT PROFILE • NOT A LIVE COMPANY PAGE`.
- QA: all text verbatim, no invented followers/customers/employee count, concept label visible, logo/icon fidelity, no clipping, and only token colors in designed UI.

## Generation order and ownership

1. T003: IG-01 business card.
2. T004: IG-02 billboard.
3. T005: DS-01 browser/favicon.
4. T006: DS-02 X and DS-03 LinkedIn.
5. T007: IG-03 T-shirt and IG-04 compact mirror.
6. T008: build the 19 source pages using only accepted raster mockups.

Each task records final prompt/method, attempt history, output dimensions/bytes, direct visual inspection result, any retry, and any exact finishing pass in `tasks.json` and `progress.txt`.

## Acceptance checklist for this plan

- Exactly 19 numbered page rows exist.
- Seven final raster mockup outputs are planned: four ImageGen and three deterministic screenshots.
- All required existing inputs use exact durable repository paths and currently exist.
- Every mockup family has a prompt or screenshot plan, final PNG path, target dimensions, and verification criteria.
- ImageGen and HTML/CSS methods are explicitly distinguished.
- No mockup generation begins until this plan passes automated and manual review.
