# Copywriting and Voice Specification

## Upstream Base

Use `coreyhaines31/marketingskills@copywriting` as the conversion-copy foundation. Preserve its clarity, benefits, specificity, customer-language, section-flow, CTA, alternatives, and honest-claims principles.

## Additional Inputs

When available, read:

- `company/company.md`
- market research and audience-definition artifacts
- brand strategy, brandbook, and brand tokens
- PRD, user stories, scenarios, and `screens.json`
- UX notes, HTML wireframes, and wireframe PNGs
- existing `company/voice.md`

Ask only for material context not already present.

## Modes

- **Marketing page:** persuasive page argument, section copy, CTAs, proof, objections, and meta content.
- **Product interface:** labels, instructions, helper text, consent, empty/loading/processing/error/success/recovery states, and predictable action language.

## Required Outputs

### `company/voice.md`

Include:

- source basis and approval status
- audience and reader relationship
- voice traits and calibrated scales
- tone by context and state
- vocabulary to use and avoid
- sentence, paragraph, headline, and CTA rules
- product microcopy and accessibility rules
- privacy, consent, error, and recovery language rules
- claims/proof guardrails
- approved examples and before/after examples
- channel adaptation notes

Derive voice from company strategy, customer language, founder decisions, and approved copy. Do not reverse-engineer a durable voice from one draft alone.

### `company/artifacts/copy/copy-manifest.json`

Create one entry per `screens.json` record. Include the screen ID, state, source wireframe, output copy path, approval status, and exact strings for headings, body, CTAs, labels, helper text, status messages, and metadata that apply.

### Screen copy files

Write human-readable page/screen copy under `company/artifacts/copy/screens/` with annotations and alternatives separated from the approved exact copy.

## Quality Gate

- No lorem ipsum in approved copy.
- No fabricated statistics, testimonials, customer logos, guarantees, or product capabilities.
- One clear primary action per screen unless the PRD explicitly requires otherwise.
- Copy fits the wireframe hierarchy and target viewport.
- Interface messages tell the user what happened and what to do next.
- `copy-manifest.json` parses and references real screen IDs.
