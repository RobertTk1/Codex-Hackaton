#!/usr/bin/env node

import fs from "node:fs";
import path from "node:path";

const root = path.resolve(import.meta.dirname, "../../../..");
const screenRoot = path.join(root, "company/artifacts/screen-mockups");
const promptsRoot = path.join(screenRoot, "prompts");
const specsRoot = path.join(screenRoot, "interaction-specs");
const screens = JSON.parse(fs.readFileSync(path.join(root, "company/artifacts/prd/screens.json"), "utf8")).screens;
const copies = JSON.parse(fs.readFileSync(path.join(root, "company/artifacts/copy/copy-manifest.json"), "utf8")).screens;
const wireframes = JSON.parse(fs.readFileSync(path.join(root, "company/artifacts/ui-ux-design/wireframe-manifest.json"), "utf8")).screens;

fs.mkdirSync(promptsRoot, { recursive: true });
fs.mkdirSync(specsRoot, { recursive: true });

const copyById = new Map(copies.map((item) => [item.screen_id, item]));
const wireframeById = new Map(wireframes.map((item) => [item.screen_id, item]));

const brandRefs = [
  "company/brand/exports/combined/png/transparent/ink/magic-mirror-combined-ink-1024px.png",
  "company/brand/exports/icon/png/transparent/ink/magic-mirror-icon-ink-512px.png",
  "company/brand/brandbook-packet/pages/source/page-06-primary-colors.png",
  "company/brand/brandbook-packet/pages/source/page-08-buttons-links.png",
  "company/brand/brandbook-packet/pages/source/page-18-typography.png"
];

function familyFor(slug) {
  if (slug.startsWith("live-styling")) return "live-styling";
  if (slug.startsWith("style-report") || slug.startsWith("style-home")) return "report";
  if (slug.includes("product") || slug.includes("bag") || slug.includes("retailer")) return "commerce";
  return "onboarding";
}

function familyDirection(family) {
  if (family === "live-styling") {
    return "Use a large, realistic live-mirror camera workspace with the current garment clearly visible, a restrained recommended-item rail, and distance-readable controls. Preserve shared chrome across live states so the named state—not a redesigned interface—is the visual change. Acid marks the primary action or active voice/gesture signal; Ink and Cloud keep the camera workspace grounded.";
  }
  if (family === "report") {
    return "Use an editorial personal-report system: strong Instrument Serif moments, Space Grotesk data clarity, thoughtful color chips, silhouette or outfit imagery, and believable report modules. Avoid generic analytics dashboards. Make findings feel useful, personal, and visually connected to clothing.";
  }
  if (family === "commerce") {
    return "Use premium editorial product photography and a clear shopping-decision interface. Keep price, availability, size context, rationale, bag grouping, and retailer boundaries easy to scan. Do not add retailer logos, checkout UI, payment controls, inventory claims, or fit guarantees.";
  }
  return "Use calm, progressive onboarding with a narrow task column, clear progress, realistic form/upload/card controls, and one obvious Acid action. Editorial imagery may orient the step but must not obstruct inputs. Preserve completed work and recovery guidance visually when the state requires it.";
}

function stateDirection(state) {
  const directions = {
    base: "Show the ordinary usable base state with the primary task immediately clear.",
    unauthenticated: "Show a welcoming signed-out state with Google and email access unmistakable and no unnecessary product explanation.",
    empty: "Show the true empty state with guidance and the upload/action area ready for input.",
    partial: "Show several completed items alongside checking or incomplete items; continuation should be visibly available only when requirements are met.",
    error: "Show a localized error with preserved valid work, a calm error treatment, and one obvious correction path.",
    recovery: "Show preserved progress and a clear retry or alternate route; avoid alarmist visuals.",
    processing: "Show active progress with a believable multi-stage indicator and a safe leave/notification option; no AI glow.",
    slow: "Show continued work beyond the normal target with waiting and alternate actions clearly separated.",
    success: "Show a confident completed result and an obvious next exploration action; no confetti.",
    feedback: "Show the current result in context with a focused correction form and one clear update action.",
    permission: "Show the requested camera or microphone capability, why it helps, and the exact allow/decline actions.",
    denied: "Show the permission-off state, browser-setting recovery, and the usable fallback route.",
    connecting: "Show the shared live workspace in a short connection state with selected content preserved.",
    changing: "Show the shared live workspace while one garment visualization changes; preserve all surrounding controls.",
    ended: "Show a calm session summary with saved picks and clear next choices.",
    listening: "Show an unmistakable active listening state with an example request and a visible stop action.",
    interpreting: "Show a brief in-progress interpretation state inside the unchanged live workspace.",
    confirming: "Show the interpreted request or gesture and require an explicit confirmation before the action.",
    acting: "Show the confirmed request being applied inside the unchanged live workspace.",
    observing: "Show hand controls active with hands-in-frame guidance and a visible pause action.",
    accepted: "Show a brief successful gesture result with undo and continued-control choices.",
    unavailable: "Show the unavailable product in context, preserve other selections, and prioritize similar alternatives."
  };
  return directions[state] || "Make the named state visually unmistakable while preserving the approved structure and controls.";
}

function actionBehavior(label, slug) {
  if (!label) return null;
  const value = label.toLowerCase();
  if (value.includes("continue with google")) return "Start Google authentication; on success, resume the preserved customer journey.";
  if (value.includes("sign-in link") || value.includes("magic link") || value.includes("send another link")) return "Validate the email field, send a passwordless sign-in link, and move to the link-sent state.";
  if (value === "open email" || value.includes("open my email")) return "Open the device email application when available; otherwise keep resend and alternate sign-in actions visible.";
  if (value.includes("choose my brands")) return "Save the profile fields and navigate to `/style-report/brands-and-sizes`.";
  if (value.includes("add my photos")) return "Save brand-size entries and navigate to `/style-report/photos`.";
  if (value.includes("choose photos") || value.includes("add more") || value.includes("replace photo")) return "Open the supported image picker and validate selected files without removing accepted photos.";
  if (value.includes("refine my taste")) return "Navigate to `/style-report/taste` when the required photos are ready.";
  if (["love", "hate", "maybe"].includes(value)) return `Record ${label}, animate the card in the matching direction, and load the next look.`;
  if (value.includes("load the next look") || value === "try again") return "Retry the failed operation while preserving completed customer work.";
  if (value.includes("email me when")) return "Save the notification preference and confirm that the customer may leave the page.";
  if (value.includes("come back later") || value.includes("go home")) return "Navigate to the safest available home or resume destination without discarding progress.";
  if (value.includes("explore my report")) return "Open the first detailed report module and preserve report navigation.";
  if (value.includes("view my report")) return "Navigate to the report overview.";
  if (value.includes("my colors") || value.includes("matching") || value.includes("silhouette")) return "Open the matching recommendation or report module while preserving the current report context.";
  if (value.includes("see my picks") || value.includes("browse my picks") || value.includes("recommended")) return "Open personalized product recommendations.";
  if (value.includes("start styling") || value.includes("style another")) return "Enter the live-styling permission or ready flow with the chosen recommendation preserved.";
  if (value.includes("turn on camera") || value.includes("allow camera")) return "Request browser camera permission and continue only after the browser resolves it.";
  if (value.includes("turn on microphone") || value.includes("allow microphone")) return "Request browser microphone permission and enter listening only after approval.";
  if (value.includes("hand controls") || value === "practice") return "Enter, pause, or demonstrate hand-control mode without changing unrelated session state.";
  if (value.includes("use voice")) return "Open voice control while preserving the current item and live view.";
  if (value.includes("use buttons")) return "Return focus to the on-screen direct controls without changing the current item.";
  if (value.includes("add to bag")) return "Add the current product selection to the Magic Mirror bag and confirm the result.";
  if (value.includes("next look") || value.includes("another look")) return "Load the next recommended item in the same live-styling workspace.";
  if (value.includes("end session")) return "Require confirmation when appropriate, end camera/voice/gesture capture, and show the session-ended summary.";
  if (value.includes("shop at") || value.includes("retailer")) return "Show or confirm the retailer handoff, then open the retailer destination in a new tab.";
  if (value.includes("update my report")) return "Validate the feedback and refresh the affected report guidance.";
  if (value.includes("similar")) return "Open alternatives selected for the same recommendation rationale.";
  if (value.includes("remove")) return "Remove only the named item after confirmation when the consequence is not already obvious.";
  if (value.includes("undo")) return "Reverse the immediately preceding reversible choice and restore the prior state.";
  if (value.includes("cancel") || value.includes("not now") || value.includes("not yet") || value === "back") return "Dismiss the current overlay or state and return to the previous usable context without losing work.";
  if (value.includes("save and exit")) return "Persist current valid work and leave to the resume destination.";
  if (value.includes("save")) return "Persist the current customer selection and confirm completion without changing unrelated state.";
  if (value.includes("keep going") || value.includes("continue")) return "Advance to the next PRD-defined step after validating the current state.";
  if (value.includes("help") || value.includes("how to")) return "Open contextual guidance without discarding current work.";
  if (value.includes("close")) return "Close the current drawer or overlay and restore focus to its trigger.";
  return `Perform the approved “${label}” action for ${slug} and preserve unrelated customer work.`;
}

function jsonFence(value) {
  return `\`\`\`json\n${JSON.stringify(value, null, 2)}\n\`\`\``;
}

for (const screen of screens) {
  if (screen.screen_slug === "landing-page-base") continue;
  const copy = copyById.get(screen.screen_id);
  const wireframe = wireframeById.get(screen.screen_id);
  if (!copy || !wireframe) throw new Error(`Missing approved handoff for ${screen.screen_slug}`);
  const family = familyFor(screen.screen_slug);
  const sectionList = wireframe.sections.map((section) => `${section.order}. ${section.name} — ${section.purpose}`).join("\n");
  const outputBase = `company/artifacts/screen-mockups/screens/${screen.screen_slug}/${copy.state}`;
  const exact = copy.exact_copy;
  const prompt = `# ${screen.name} ImageGen Brief

Screen ID: \`${screen.screen_id}\`  
Screen slug: \`${screen.screen_slug}\`  
State: \`${copy.state}\`  
Surface: \`${screen.surface}\`  
Family: \`${family}\`  
Route/context: \`${screen.route_or_context}\`  
User job: ${screen.description}  
Primary action: \`${exact.primary_cta}\`

## Authoritative references

- Approved desktop wireframe: \`${copy.source_wireframe.desktop_png}\`
- Approved mobile wireframe: \`${copy.source_wireframe.mobile_png}\`
- Exact copy: \`company/artifacts/copy/copy-manifest.json#${screen.screen_slug}/${copy.state}\`
- Shared direction: \`company/artifacts/screen-mockups/design-direction.md\`
- Application continuity reference: \`company/artifacts/screen-mockups/screens/personal-profile-base/base/personal-profile-base-desktop.png\`
- Live-styling continuity reference when applicable: \`company/artifacts/screen-mockups/screens/live-styling-ready/base/live-styling-ready-desktop.png\`

## Fixed section order

${sectionList}

## Approved exact copy

${jsonFence({
    eyebrow: exact.eyebrow,
    headline: exact.headline,
    supporting_copy: exact.supporting_copy,
    primary_cta: exact.primary_cta,
    secondary_cta: exact.secondary_cta,
    tertiary_cta: exact.tertiary_cta,
    navigation: exact.navigation,
    labels: exact.labels,
    helper_text: exact.helper_text,
    validation: exact.validation,
    status_messages: exact.status_messages,
    consent: exact.consent
  })}

## Art direction

${familyDirection(family)}

${stateDirection(copy.state)}

Use the approved Acid Dispatch / Editorial Edge system: White and Cloud canvases, Ink structure, Acid only for the primary action or active signal, Pale/Deep supporting fields, Instrument Serif for short editorial moments, Space Grotesk for product clarity, 999 px buttons, 24 px cards, visible focus treatment, restrained shadows, and realistic fashion imagery only where the wireframe provides media or product content.

## Desktop prompt

Create one flat, straight-on desktop frontend raster comp for this exact screen/state. Use the approved desktop wireframe as the strict composition reference. Preserve the current job, section order, control placement, navigation, primary-action priority, and named state. Use realistic production-sized controls and readable density. Do not add a browser/device frame, annotations, alternate screens, proof, metrics, retailer logos, new features, purple/blue AI gradients, glassmorphism, or generic dashboard cards.

Canonical output: \`${outputBase}/${screen.screen_slug}-desktop.png\`

## Mobile prompt

Create one flat, straight-on mobile frontend raster comp for this exact screen/state. Use the approved mobile wireframe as its own structural reference; do not shrink desktop. Recompose navigation, content order, image crops, and actions for a narrow viewport while preserving the same job and priority. Use large touch targets and legible text. Do not add a phone frame, browser chrome, annotations, alternate screens, or new product behavior.

Canonical output: \`${outputBase}/${screen.screen_slug}-mobile.png\`

## Output and QA rules

- One screen/state/viewport per final PNG.
- Generated lettering is approximate; the copy manifest is authoritative.
- Use supplied production logo/icon references rather than redrawing the mark from text.
- The named state must be unmistakable.
- Preserve structure before decoration and implementation clarity before cinematic effect.
`;
  fs.writeFileSync(path.join(promptsRoot, `${screen.screen_slug}.md`), prompt);

  const actions = [exact.primary_cta, exact.secondary_cta, exact.tertiary_cta].filter(Boolean);
  const actionRows = actions.map((label) => `| ${label} | Click/tap; Enter or Space when focused | ${actionBehavior(label, screen.screen_slug)} |`).join("\n");
  const spec = `# ${screen.name} Interaction Specification

Status: Prepared for generated-mockup review  
Screen ID: \`${screen.screen_id}\`  
Screen slug: \`${screen.screen_slug}\`  
State: \`${copy.state}\`  
Route/context: \`${screen.route_or_context}\`  
Viewports: ${screen.viewports.join(" and ")}

## Sources

- Screen contract: \`company/artifacts/prd/screens.json#${screen.screen_slug}\`
- Wireframes: \`company/artifacts/ui-ux-design/wireframe-manifest.json#${screen.screen_slug}/${copy.state}\`
- Exact copy: \`company/artifacts/copy/copy-manifest.json#${screen.screen_slug}/${copy.state}\`
- Visual system: \`company/artifacts/screen-mockups/design-direction.md\`
- Prompt: \`company/artifacts/screen-mockups/prompts/${screen.screen_slug}.md\`

The copy manifest is authoritative. Generated text and imagery are visual references only.

## User job

${screen.description}

## Component hierarchy

${wireframe.sections.map((section) => `${section.order}. ${section.name}`).join("\n")}

## Controls and behavior

| Control | Trigger | Behavior |
| --- | --- | --- |
${actionRows}

All additional labels, links, form controls, validation, consent, and status strings follow the approved exact-copy object. Restore focus to the triggering control after closing a dialog, drawer, permission explanation, or recoverable overlay.

## Named state behavior

${stateDirection(copy.state)}

Preserve valid work and the customer’s current product/report/live context across waiting, error, permission, and recovery states. Do not silently retry consequential actions or begin camera/microphone capture without browser permission.

## Responsive behavior

- Desktop preserves the approved wide composition, grouping, navigation, and control hierarchy.
- Mobile follows the approved narrow composition and reading order; it is not a scaled desktop image.
- Stack paired actions when the approved mobile wireframe does so.
- Maintain at least 44 px touch targets, 16 px body copy, readable labels, and uninterrupted keyboard order.
- Keep the primary action visually dominant at both viewports.

## Interaction states

- Hover and active treatments must not change labels or layout.
- Keyboard focus uses the approved Acid ring with an Ink edge/offset.
- Disabled states combine muted tokens with native disabled semantics.
- Waiting controls communicate progress and prevent duplicate submission when the action is not repeatable.
- Errors appear beside the affected control or in the approved state region and always expose a recovery action.

## Motion and reduced motion

- Use short, functional transitions for drawers, cards, progress, live-item changes, voice, and gesture feedback.
- Do not animate sensitive imagery merely for decoration.
- Reduced-motion mode removes parallax, card flight, and nonessential transforms while preserving state changes.

## Assets and accessibility

- Use production Magic Mirror logo/icon exports and exact brand tokens, never pixels sampled from generated comps.
- Use realistic, purpose-based alternative text for informative images and empty alternative text for decorative imagery.
- Do not rely on color, swipe, gesture, or voice alone; retain equivalent visible controls.
- Announce processing, errors, completed actions, and gesture/voice changes through an appropriate live region.
- Permission and consent controls remain explicit, reversible when the platform allows, and separate by capability.

## Generated-image discrepancy rule

Implementation uses the approved copy, production logo assets, responsive wireframes, and this behavior—not generated glyphs, accidental image text, or inferred controls.
`;
  fs.writeFileSync(path.join(specsRoot, `${screen.screen_slug}.md`), spec);
}

console.log(`Scaffolded ${screens.length - 1} prompt and interaction-spec pairs.`);
