# Magic Mirror Brandbook Asset Plan

Status: revised production plan after owner correction; rejected deterministic browser/social assets are being replaced with ImageGen outputs

Brand direction: Acid Dispatch / Editorial Edge

Page count: 19

## Production rules

- Approved identity geometry comes only from `company/brand/exports/`; never regenerate the wordmark, lockup, icon, or favicon from memory.
- Use built-in ImageGen for every application mockup: browser/favicon, social, device, print, environmental, apparel, and merchandise.
- Do not use HTML/CSS, SVG, canvas, or deterministic UI rendering for application mockup imagery. HTML/CSS is reserved for the brandbook page source and non-mockup token/UI specimens.
- Generate browser/favicon as separate light and dark raster images, using the owner-provided reference pair for composition and finish while replacing all reference branding with approved Magic Mirror assets.
- Inspect the matching Mayven application example before every standardized UI mockup. Twitter/X, LinkedIn, and browser/favicon must each be recognizable from composition alone.
- Never reuse the same generic phone/profile composition for Twitter/X and LinkedIn. LinkedIn must show a LinkedIn-specific company/profile or experience hierarchy.
- Twitter/X always shows a paired light/dark presentation: one light-mode profile with the Ink icon on a White avatar surface and one dark-mode profile with the White icon on an Ink avatar surface, supported by Acid accents.
- Every finished mockup is an ImageGen-created raster PNG under `company/brand/brandbook-packet/mockups/`. No SVG mockup outputs.
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
| `ICON_WHITE` | `company/brand/exports/icon/png/transparent/white/magic-mirror-icon-white-1024px.png` | Reversed complete icon on Ink/dark avatar surfaces |
| `FAVICON_16` | `company/brand/exports/icon/favicon/favicon-16x16.png` | Simplified browser favicon at 16px |
| `TOUCH_ICON` | `company/brand/exports/icon/favicon/apple-touch-icon-180x180.png` | High-resolution exact app/favicon tile for generated browser and device scenes |
| `PALETTE` | `company/brand/brand-colors.json` | Exact Acid Dispatch anchors and treatments |
| `TOKENS` | `company/brand/brandbook-packet/tokens/brand-tokens.json` | Derived colors, typography, radii, states, and focus rules |
| `TYPE_CSS` | `company/brand/brandbook-packet/tokens/brand-tokens.css` | Local font faces and CSS variables |
| `BROWSER_LIGHT_REF` | `company/brand/brandbook-packet/references/mockup-direction/browser-light-reference.png` | Composition and finish reference only; do not copy Mayven branding or blue palette |
| `BROWSER_DARK_REF` | `company/brand/brandbook-packet/references/mockup-direction/browser-dark-reference.png` | Composition and finish reference only; do not copy Mayven branding or blue palette |
| `X_REF` | `company/brand/brandbook-packet/references/layout-direction/mayven/assets/14-twitter-x.png` | Twitter/X profile composition reference only; do not copy Mayven branding or blue palette |
| `LINKEDIN_REF` | `company/brand/brandbook-packet/references/layout-direction/mayven/assets/15-linkedin.png` | LinkedIn-specific company/profile and experience composition reference only; do not copy Mayven branding or blue palette |
| `MAYVEN_LAYOUT` | `company/brand/brandbook-packet/references/layout-direction/mayven/pages/contact-sheet.png` | Page geometry, hierarchy, whitespace, and density authority only |

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
| 13 | Favicon/browser mockups | ImageGen | `BROWSER_LIGHT_REF`, `BROWSER_DARK_REF`, `TOUCH_ICON`, `LOCKUP_INK`, `LOCKUP_ACID`, `PALETTE` | `mockups/browser-favicon-light.png`, `mockups/browser-favicon-dark.png` | Generate separate light and dark close-crop browser scenes using Prompts IG-05 and IG-06. | Both outputs page-ready; Magic Mirror favicon and lockup recognizable; title/address legible; no Mayven/blue reference branding; convincing browser materials. |
| 14 | Twitter/X mockup | ImageGen | `X_REF`, `ICON_INK`, `ICON_WHITE`, `LOCKUP_ACID`, `PALETTE` | `mockups/x-profile.png` | Generate a recognizable paired light/dark smartphone X profile scene using Prompt IG-07. | Identifiable as X; left/light profile uses Ink icon on White avatar, right/dark profile uses White icon on Ink avatar; required copy/non-live label legible; no invented metrics, copied reference branding, or watermark. |
| 15 | LinkedIn mockup | ImageGen | `LINKEDIN_REF`, `ICON_ACID`, `LOCKUP_ACID`, `PALETTE` | `mockups/linkedin-profile.png` | Generate a recognizable LinkedIn company/profile and experience scene using Prompt IG-08. | Identifiable as LinkedIn from professional navigation, company identity, and experience hierarchy; structurally distinct from X; no invented metrics, copied reference branding, or watermark. |
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

### IG-05 — Light browser and favicon

```text
Use case: product-mockup
Asset type: Magic Mirror light browser and favicon brandbook mockup
Primary request: Create a polished, realistic close-crop desktop browser scene in light mode, matching the supplied composition reference while replacing all reference branding with Magic Mirror.
Input images: Image 1: BROWSER_LIGHT_REF, composition and material reference only; Image 2: LOCKUP_INK, the exact approved combined lockup; Image 3: TOUCH_ICON, the exact approved high-resolution app/favicon tile.
Scene/backdrop: airy White #FFFFFF and Cloud #F4F3F1 desktop browser window with subtle translucent chrome, rounded tab, generic navigation controls, and generous negative space.
Subject: one close-crop light browser window. The tab shows the Magic Mirror favicon and exact title. The page header shows the Ink Magic Mirror lockup, minimal navigation, and one Acid call-to-action.
Style/medium: premium photorealistic product/UI visualization with soft studio depth, polished glass/aluminum browser materials, and the dimensional finish of the supplied reference.
Composition/framing: landscape 3:2, browser fills most of the frame, cropped at the right and lower edges like the reference, with tab, address bar, and page header all visible.
Lighting/mood: bright, clean, editorial product light.
Color palette: White #FFFFFF, Cloud #F4F3F1, Ink #17171A, and Acid #D7FF3F for designed surfaces; do not copy the reference blue palette.
Text (verbatim): tab title "Magic Mirror — Virtual Try-On"; address "magicmirror.example/demo"; navigation "How it works" and "Try it on".
Constraints: preserve the supplied Magic Mirror lockup and favicon; use the reference only for composition/material finish; no Mayven name, cruise copy, blue logo, or copied reference branding.
Avoid: HTML/CSS screenshot appearance, flat wireframe styling, unrelated brands, extra text, distorted lockup, altered favicon, blue brand palette, watermark, extreme blur, or illegible browser chrome.
```

Target: `1852×850` PNG. Inputs: `BROWSER_LIGHT_REF`, `LOCKUP_INK`, `TOUCH_ICON`. Final: `mockups/browser-favicon-light.png`.

QA: inspect browser realism, light treatment, lockup/favicon fidelity, exact required copy, absence of Mayven/blue reference branding, page-ready crop, and watermark. Retry once before any exact raster finishing pass.

### IG-06 — Dark browser and favicon

```text
Use case: product-mockup
Asset type: Magic Mirror dark browser and favicon brandbook mockup
Primary request: Create a polished, realistic close-crop desktop browser scene in dark mode, matching the supplied composition reference while replacing all reference branding with Magic Mirror.
Input images: Image 1: BROWSER_DARK_REF, composition and material reference only; Image 2: LOCKUP_ACID, the exact approved combined lockup; Image 3: TOUCH_ICON, the exact approved high-resolution app/favicon tile.
Scene/backdrop: deep Ink #17171A desktop browser window with dimensional dark chrome, rounded tab, generic navigation controls, and subtle premium reflections.
Subject: one close-crop dark browser window. The tab shows the Magic Mirror favicon and exact title. The page header shows the Acid Magic Mirror lockup, minimal White navigation, and one Acid call-to-action.
Style/medium: premium photorealistic product/UI visualization with the dimensional dark finish of the supplied reference.
Composition/framing: landscape 3:2, browser fills most of the frame, cropped at the right and lower edges like the reference, with tab, address bar, and page header all visible.
Lighting/mood: moody editorial product light with restrained highlights and strong legibility.
Color palette: Ink #17171A, technical Black #000000, Acid #D7FF3F, and White #FFFFFF for designed surfaces; do not copy the reference blue palette.
Text (verbatim): tab title "Magic Mirror — Virtual Try-On"; address "magicmirror.example/demo"; navigation "How it works" and "Try it on".
Constraints: preserve the supplied Magic Mirror lockup and favicon; use the reference only for composition/material finish; no Mayven name, cruise copy, blue logo, or copied reference branding.
Avoid: HTML/CSS screenshot appearance, flat wireframe styling, unrelated brands, extra text, distorted lockup, altered favicon, blue brand palette, watermark, crushed black detail, or illegible browser chrome.
```

Target: `1852×850` PNG. Inputs: `BROWSER_DARK_REF`, `LOCKUP_ACID`, `TOUCH_ICON`. Final: `mockups/browser-favicon-dark.png`.

QA: inspect browser realism, dark treatment, lockup/favicon fidelity, exact required copy, absence of Mayven/blue reference branding, page-ready crop, and watermark. Retry once before any exact raster finishing pass.

### IG-07 — X profile concept

```text
Use case: product-mockup
Asset type: Magic Mirror X profile smartphone mockup
Primary request: Create a premium photorealistic close-up of two smartphones presenting a Magic Mirror X profile concept, using the supplied phone composition as direction only.
Input images: Image 1: X_REF, Twitter/X profile composition reference only; Image 2: ICON_INK, the exact approved complete icon for the light avatar; Image 3: ICON_WHITE, the exact approved complete reversed icon for the dark avatar; Image 4: LOCKUP_ACID, the exact approved combined lockup for supporting brand context.
Scene/backdrop: minimal Cloud #F4F3F1 studio environment; two edge-to-edge premium smartphones with realistic metal/glass construction.
Subject: two recognizable X profile interfaces with matching profile hierarchy but different approved modes. Left phone is light mode with a White avatar surface carrying the exact Ink icon. Right phone is dark mode with an Ink avatar surface carrying the exact White icon and restrained Acid accents. Both include a header/banner, circular avatar overlapping the banner, display name, @handle, bio, location/link row, recognizable X controls, and profile tabs.
Style/medium: premium photorealistic device/product visualization, dimensional glass, crisp screen content, restrained reflections.
Composition/framing: landscape 3:2 close crop inspired by the reference, both phones dominant and partially cropped at frame edges.
Lighting/mood: clean editorial product light, fashion-tech tone.
Color palette: light phone uses White #FFFFFF and Cloud #F4F3F1 surfaces with Ink #17171A text/avatar icon; dark phone uses Ink #17171A surfaces with White #FFFFFF text/avatar icon; Acid #D7FF3F is a restrained brand accent. Do not copy the reference blue palette.
Text (verbatim): "Magic Mirror"; "@magicmirror_demo"; "AI virtual try-on for more confident clothing decisions. Hackathon prototype."; "CONCEPT PROFILE • NOT A LIVE ACCOUNT".
Constraints: the screens must be identifiable as X from layout alone; the two phones must visibly demonstrate different light and dark icon treatments; preserve the complete icon including both focus corners; no verification badge, follower/following metrics, live-account claim, Mayven name, cruise copy, or copied blue reference branding.
Avoid: two dark phones, duplicated avatar treatment, Acid icon on both phones, generic profile page, LinkedIn-style experience cards, HTML/CSS screenshot appearance, unrelated logos, invented metrics, altered icon, extra social copy, blue brand palette, watermark, hands, faces, or unreadable screen text.
```

Target: `1536×1024` PNG. Inputs: `X_REF`, `ICON_INK`, `ICON_WHITE`, `LOCKUP_ACID`. Final: `mockups/x-profile.png`.

QA: inspect phone realism, complete icon fidelity, exact concept copy, visible non-live label, no invented metrics or Mayven/blue reference branding, restrained reflections, crop, and watermark. Retry once before any exact raster finishing pass.

### IG-08 — LinkedIn company profile concept

```text
Use case: product-mockup
Asset type: Magic Mirror LinkedIn company profile smartphone mockup
Primary request: Create a premium photorealistic close-up of two smartphones presenting a Magic Mirror LinkedIn company profile concept, using the supplied phone composition as direction only.
Input images: Image 1: LINKEDIN_REF, LinkedIn-specific company/profile and experience composition reference only; Image 2: ICON_ACID, the exact approved complete company icon; Image 3: LOCKUP_ACID, the exact approved combined lockup for supporting brand context.
Scene/backdrop: clean white-to-Cloud #F4F3F1 studio environment; two overlapping edge-to-edge premium smartphones with realistic metal/glass construction.
Subject: a recognizable LinkedIn mobile interface in light mode. The rear phone shows a Magic Mirror company page with search/navigation, an editorial fashion banner, the square company icon, company name, category, and concise about copy. The front phone shows an Experience section with a Magic Mirror role card, company icon, dates marked as a hackathon concept, and a concise professional description.
Style/medium: premium photorealistic device/product visualization, dimensional glass, crisp screen content, restrained reflections.
Composition/framing: landscape 3:2 close crop inspired by the reference, both phones dominant and partially cropped at frame edges.
Lighting/mood: clean editorial product light, fashion-tech tone.
Color palette: White #FFFFFF and Cloud #F4F3F1 for the platform surface; Ink #17171A and Acid #D7FF3F for Magic Mirror brand elements; neutral gray UI lines; do not copy the reference blue brand palette.
Text (verbatim): "Magic Mirror"; "AI-powered virtual try-on"; "Hackathon prototype"; "Helping shoppers make faster, more confident clothing decisions."; "CONCEPT • NOT A LIVE COMPANY PAGE".
Constraints: the screen must be identifiable as LinkedIn from layout alone and structurally different from the X mockup; preserve the complete icon including both focus corners; no follower, customer, or employee metrics; no live-company-page claim; no Mayven name, cruise copy, or copied blue reference branding.
Avoid: dark generic social profile, X-style handle/bio layout, duplicated screens, HTML/CSS screenshot appearance, unrelated logos, invented metrics, altered icon, extra social copy, blue brand palette, watermark, hands, faces, or unreadable screen text.
```

Target: `1536×1024` PNG. Inputs: `LINKEDIN_REF`, `ICON_ACID`, `LOCKUP_ACID`. Final: `mockups/linkedin-profile.png`.

QA: inspect phone realism, complete icon fidelity, exact concept copy, visible non-live label, no invented metrics or Mayven/blue reference branding, restrained reflections, crop, and watermark. Retry once before any exact raster finishing pass.

## Generation order and ownership

1. T003: IG-01 business card.
2. T004: IG-02 billboard.
3. T005: IG-05 light browser and IG-06 dark browser.
4. T006: IG-07 X and IG-08 LinkedIn.
5. T007: IG-03 T-shirt and IG-04 compact mirror.
6. T008: build the 19 source pages using only accepted raster mockups.

Each task records final prompt/method, attempt history, output dimensions/bytes, direct visual inspection result, any retry, and any exact finishing pass in `tasks.json` and `progress.txt`.

## Acceptance checklist for this plan

- Exactly 19 numbered page rows exist.
- Eight final raster mockup outputs are planned, all created with ImageGen.
- All required existing inputs use exact durable repository paths and currently exist.
- Every mockup family has an ImageGen prompt, final PNG path, target dimensions, and verification criteria.
- Browser/favicon has separate light and dark ImageGen outputs.
- Twitter/X and LinkedIn use different platform-specific examples and are recognizable from layout alone.
- Twitter/X shows one approved light icon/profile treatment and one approved dark/reversed treatment.
- No application mockup is planned as HTML/CSS, SVG, canvas, or deterministic UI rendering.
- No mockup generation begins until this plan passes automated and manual review.
