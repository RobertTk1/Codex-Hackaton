#!/usr/bin/env node

import crypto from "node:crypto";
import fs from "node:fs";
import path from "node:path";

const root = path.resolve(import.meta.dirname, "../../../..");
const uxRoot = path.join(root, "company/artifacts/ui-ux-design");
const screensPath = path.join(root, "company/artifacts/prd/screens.json");
const now = new Date().toISOString();
const rel = (file) => path.relative(root, file).split(path.sep).join("/");

function ensure(dir) { fs.mkdirSync(dir, { recursive: true }); }
function write(file, content) { ensure(path.dirname(file)); fs.writeFileSync(file, content); }
function writeJson(file, value) { write(file, `${JSON.stringify(value, null, 2)}\n`); }
function slug(value) { return value.toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/^-|-$/g, ""); }
function uuidFor(value) {
  const bytes = crypto.createHash("sha1").update(`product-ux-design:${value}`).digest().subarray(0, 16);
  bytes[6] = (bytes[6] & 0x0f) | 0x50;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;
  const hex = bytes.toString("hex");
  return `${hex.slice(0, 8)}-${hex.slice(8, 12)}-${hex.slice(12, 16)}-${hex.slice(16, 20)}-${hex.slice(20)}`;
}

const payload = JSON.parse(fs.readFileSync(screensPath, "utf8"));
const screens = payload.screens;

// Preserve approved screen IDs. Refine the one previously conflated voice record,
// then append only visibly distinct states already required by the approved PRD.
const voiceActive = screens.find((x) => x.screen_id === "87b489bf-c543-4911-a09d-48b57be4a80a");
voiceActive.name = "Live Styling — Voice Listening";
voiceActive.description = "Live-session overlay showing that voice capture is active, with cancel and direct-control alternatives.";
voiceActive.primary_actions = ["Cancel voice", "Use direct controls"];
voiceActive.required_states = ["listening"];

const added = [
  ["Personal Profile — Validation Error", "product", "app-specific", "/style-report/profile", "Field-specific validation that preserves valid personal-profile entries and optional-field choices.", ["Correct field", "Continue"], ["US-003", "US-021"], ["SC-003"], "error"],
  ["Account Connection — Error Recovery", "product", "universal", "/style-report/account", "Interrupted or failed Google or magic-link connection with anonymous progress preserved.", ["Try again", "Use another method"], ["US-007", "US-020"], ["SC-006"], "recovery"],
  ["Style Report — Feedback and Recalibration", "product", "app-specific", "/report/feedback", "Correction and recalibration state shared by report findings.", ["Submit correction", "Request recalibration", "Cancel"], ["US-009", "US-010", "US-011"], ["SC-009"], "feedback"],
  ["Style Home — Resume or Recover", "product", "app-specific", "/style", "Returning-customer home when incomplete or failed work needs a specific resume or recovery action.", ["Resume", "Try again", "View report"], ["US-002", "US-022"], ["SC-002", "SC-014"], "recovery"],
  ["Live Styling — Camera Denied", "product", "app-specific", "/style/live", "Camera-denial recovery that preserves selected items, report access, and device guidance.", ["Try camera again", "Return to recommendations"], ["US-014", "US-020", "US-021"], ["SC-010"], "denied"],
  ["Live Styling — Connecting", "product", "app-specific", "/style/live/session/:session-id", "Live visualization connection state with selected product preserved.", ["Cancel"], ["US-014", "US-020"], ["SC-010", "SC-011"], "connecting"],
  ["Live Styling — Changing Item", "product", "app-specific", "/style/live/session/:session-id", "In-session state while a new recommended item is being applied.", ["Cancel change"], ["US-014", "US-015", "US-023"], ["SC-011", "SC-015"], "changing"],
  ["Live Styling — Slow", "product", "app-specific", "/style/live/session/:session-id", "Explicit slow state for an awaited live visualization update.", ["Keep waiting", "Choose another item"], ["US-014", "US-020"], ["SC-010"], "slow"],
  ["Live Styling — Error Recovery", "product", "app-specific", "/style/live/session/:session-id", "Normalized live-provider failure with retry and preserved product selection.", ["Try again", "Return to recommendations"], ["US-014", "US-020"], ["SC-010"], "recovery"],
  ["Live Styling — Ended", "product", "app-specific", "/style/live/session/:session-id", "Completed-session summary with preserved selections and next actions.", ["Review selections", "Start another session"], ["US-014", "US-017"], ["SC-012"], "ended"],
  ["Live Styling — Voice Interpreting", "product", "app-specific", "/style/live/session/:session-id", "Voice request interpretation state layered over the live session.", ["Cancel"], ["US-015"], ["SC-011"], "interpreting"],
  ["Live Styling — Voice Confirmation", "product", "app-specific", "/style/live/session/:session-id", "Interpreted voice request shown for confirmation before action.", ["Confirm request", "Edit request", "Cancel"], ["US-015"], ["SC-011"], "confirming"],
  ["Live Styling — Voice Acting", "product", "app-specific", "/style/live/session/:session-id", "Confirmed voice request being applied to the recommended item set.", ["Cancel action"], ["US-015"], ["SC-011"], "acting"],
  ["Live Styling — Voice Failure", "product", "app-specific", "/style/live/session/:session-id", "Unrecognized or unmatched voice request with retry and direct-control recovery.", ["Try voice again", "Use direct controls"], ["US-015", "US-020", "US-021"], ["SC-011"], "recovery"],
  ["Live Styling — Gesture Observing", "product", "app-specific", "/style/live/session/:session-id", "Active hand-gesture observation with camera-framing guidance.", ["Pause gestures", "Use direct controls"], ["US-023"], ["SC-015"], "observing"],
  ["Live Styling — Gesture Interpreting", "product", "app-specific", "/style/live/session/:session-id", "Recognized hand shape shown with the intended action before acting.", ["Cancel"], ["US-023"], ["SC-015"], "interpreting"],
  ["Live Styling — Gesture Accepted", "product", "app-specific", "/style/live/session/:session-id", "Accepted non-consequential gesture with action feedback.", ["Undo", "Continue"], ["US-023"], ["SC-015"], "accepted"],
  ["Live Styling — Gesture Ignored or Unavailable", "product", "app-specific", "/style/live/session/:session-id", "Ignored, unrecognized, or unavailable gesture state with positioning and alternative-control recovery.", ["Try again", "Use voice", "Use direct controls"], ["US-020", "US-021", "US-023"], ["SC-015"], "recovery"],
  ["Live Styling — Gesture Confirmation", "product", "app-specific", "/style/live/session/:session-id", "Explicit confirmation before a gesture triggers a consequential action.", ["Confirm action", "Cancel"], ["US-023"], ["SC-015"], "confirming"],
  ["Recommended Product — Unavailable", "product", "app-specific", "product-detail-drawer", "Unavailable recommended-product state with alternatives and preserved context.", ["See alternatives", "Close"], ["US-013", "US-016", "US-020"], ["SC-014"], "unavailable"],
  ["Bag — Item Unavailable", "product", "app-specific", "/bag", "Bag state that identifies an unavailable item and offers removal or alternatives.", ["See alternatives", "Remove item", "Keep styling"], ["US-017", "US-020", "US-022"], ["SC-012", "SC-014"], "unavailable"]
];

for (const [name, surface, type, route, description, actions, stories, scenarios, state] of added) {
  if (screens.some((x) => x.name === name)) continue;
  screens.push({
    screen_id: uuidFor(name), name, surface, type, route_or_context: route, description,
    primary_actions: actions, related_user_stories: stories, related_scenarios: scenarios,
    required_states: [state], viewports: ["desktop", "mobile"],
    wireframe: { status: "not-started", manifest_entry: null, html: null, screenshots: { desktop: null, mobile: null } },
    copy: { status: "not-started", manifest_entry: null },
    mockup: { status: "not-started", images: { desktop: null, mobile: null } }
  });
}

const css = `:root{--white:#fff;--050:#fafafa;--100:#eee;--200:#d8d8d8;--400:#aaa;--700:#454545;--black:#000;--rule:1px solid #000;--max:1280px;font-family:Arial,Helvetica,sans-serif;color:#000;background:#fff}*{box-sizing:border-box}html{color-scheme:light}body{margin:0;background:#fff;font-size:16px;line-height:1.45}button,input,select,textarea{font:inherit}a{color:inherit}.review{padding:10px 16px;border-bottom:var(--rule);background:#fafafa;font:12px/1.3 ui-monospace,SFMono-Regular,Menlo,monospace;overflow-wrap:anywhere}.container{width:min(calc(100% - 48px),var(--max));margin-inline:auto}.narrow{width:min(calc(100% - 48px),900px);margin-inline:auto}.section{padding:88px 0;background:#fff}.section+.section{border-top:1px solid #ddd}.stack{display:grid;gap:24px}.stack-sm{display:grid;gap:14px}.center{text-align:center;justify-items:center}.split{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:64px;align-items:center}.grid-2{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:28px}.grid-3{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:28px}.grid-4{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:20px}.navbar{min-height:80px;display:flex;align-items:center;gap:32px}.logo{font-size:20px;font-weight:800;letter-spacing:.04em}.nav{display:flex;align-items:center;gap:28px;margin-left:auto}.nav a{min-height:44px;display:inline-flex;align-items:center;text-decoration:none}.kicker{margin:0;font-size:14px;font-weight:700}.h-xl{max-width:900px;margin:0;font-size:clamp(48px,6vw,76px);line-height:1.05;letter-spacing:-.035em}.h-lg{max-width:880px;margin:0;font-size:clamp(38px,4vw,56px);line-height:1.1;letter-spacing:-.025em}.h-md{margin:0;font-size:30px;line-height:1.2}.body-lg{max-width:760px;margin:0;font-size:20px}.body{margin:0}.muted{color:#454545}.actions{display:flex;flex-wrap:wrap;gap:16px;align-items:center}.button,button{min-height:48px;padding:12px 24px;border:var(--rule);border-radius:0;background:#fff;color:#000}.primary{background:#000;color:#fff}.image{min-height:320px;display:grid;place-items:center;background:#d8d8d8;color:#454545;font-weight:700}.image-lg{min-height:560px}.image-sm{min-height:220px}.image-mark{width:82px;height:64px;display:grid;place-items:center;border-radius:8px;background:#aaa;color:#fff}.card{display:grid;gap:16px}.card-box{padding:24px;border:var(--rule)}.card h3{margin:0;font-size:24px;line-height:1.2}.meta{display:flex;gap:12px;align-items:center;font-size:14px}.avatar{width:48px;height:48px;border-radius:50%;background:#d8d8d8}.form{display:grid;gap:22px}.field{display:grid;gap:8px}.field label,.label{font-weight:700}input,select,textarea{width:100%;min-height:48px;padding:12px;border:var(--rule);border-radius:0;background:#fff}.choice-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}.choice{min-height:72px;padding:16px;border:var(--rule)}.accordion{border-top:var(--rule)}.accordion-row{min-height:84px;display:flex;align-items:center;gap:24px;border-bottom:var(--rule);font-size:20px;font-weight:700}.accordion-row span:last-child{margin-left:auto;font-size:30px;font-weight:400}.status{padding:32px;border:var(--rule)}.notice{padding:18px;border:2px solid #000;background:#eee}.skeleton{height:18px;background:#d8d8d8}.skeleton:nth-child(2n){width:72%}.progress{height:12px;border:var(--rule)}.progress:before{content:"";display:block;width:45%;height:100%;background:#000}.stepper{display:flex;gap:10px;align-items:center}.step{height:10px;flex:1;background:#d8d8d8}.step.active{background:#000}.toolbar{display:flex;gap:12px;align-items:center;justify-content:space-between;border-bottom:var(--rule);padding:16px 0}.workspace{min-height:620px;display:grid;grid-template-columns:minmax(0,1fr) 340px;border:var(--rule)}.viewport{min-height:620px;background:#d8d8d8;display:grid;place-items:center;position:relative}.sidepanel{padding:24px;border-left:var(--rule);display:grid;align-content:start;gap:20px}.overlay{width:min(620px,calc(100% - 32px));padding:32px;border:2px solid #000;background:#fff;display:grid;gap:20px}.drawer-layout{min-height:640px;display:grid;grid-template-columns:minmax(0,1fr) minmax(340px,42%);border:var(--rule)}.drawer{padding:32px;border-left:var(--rule);display:grid;align-content:start;gap:20px}.table{border:var(--rule)}.row{display:grid;grid-template-columns:1.4fr repeat(2,1fr) auto;gap:16px;padding:18px;border-bottom:1px solid #aaa;align-items:center}.row:last-child{border-bottom:0}.swatches{display:grid;grid-template-columns:repeat(6,1fr);gap:12px}.swatch{aspect-ratio:1;background:#d8d8d8;border:var(--rule)}.pill{border:var(--rule);padding:8px 12px;display:inline-flex}.footer{padding:48px 0;border-top:var(--rule)}button:focus-visible,a:focus-visible,input:focus-visible,select:focus-visible,textarea:focus-visible{outline:3px solid #000;outline-offset:3px}@media(max-width:720px){.container,.narrow{width:min(calc(100% - 28px),100%)}.section{padding:56px 0}.navbar{min-height:64px}.nav a{display:none}.split,.grid-2,.grid-3,.grid-4,.choice-grid{grid-template-columns:1fr;gap:24px}.h-xl{font-size:42px}.h-lg{font-size:34px}.body-lg{font-size:18px}.image-lg{min-height:360px}.image{min-height:260px}.actions{align-items:stretch;flex-direction:column}.actions>*{width:100%}.workspace{grid-template-columns:1fr;min-height:0}.viewport{min-height:520px}.sidepanel{border-left:0;border-top:var(--rule)}.drawer-layout{grid-template-columns:1fr}.drawer{border-left:0;border-top:var(--rule)}.row{grid-template-columns:1fr 1fr}.swatches{grid-template-columns:repeat(3,1fr)}}@media(prefers-reduced-motion:reduce){*,*:before,*:after{scroll-behavior:auto!important}}`;

const wireframeCss = `${css}.image{width:100%}`;
const image = (large = false) => `<div class="image ${large ? "image-lg" : ""}"><span class="image-mark">IMAGE</span></div>`;
const lorem = `<p class="body muted">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse varius enim in eros elementum tristique.</p>`;
const buttons = (count = 2) => `<div class="actions"><button class="primary">Button</button>${count > 1 ? "<button>Button</button>" : ""}${count > 2 ? "<button>Button</button>" : ""}</div>`;
const heading = (size = "lg") => `<p class="kicker">Label</p><h2 class="h-${size}">${size === "xl" ? "Medium length hero heading goes here" : "Short heading goes here"}</h2>${lorem}`;
const shell = (inner, cls = "container") => `<div class="${cls}">${inner}</div>`;

function patternMarkup(pattern, state) {
  const stateLabel = state.replaceAll("-", " ");
  if (pattern === "navbar") return shell(`<div class="navbar"><div class="logo">LOGO</div><nav class="nav"><a href="#">Link</a><a href="#">Link</a><a href="#">Link</a><button class="primary">Button</button></nav></div>`);
  if (pattern === "footer") return shell(`<div class="grid-3"><div class="stack-sm"><div class="logo">LOGO</div>${lorem}</div><div class="stack-sm"><strong>Column heading</strong><a href="#">Link</a><a href="#">Link</a></div><div class="stack-sm"><strong>Column heading</strong><a href="#">Link</a><a href="#">Link</a></div></div>`);
  if (pattern === "hero") return shell(`<div class="stack center">${heading("xl")}${buttons(2)}${image(true)}</div>`);
  if (pattern === "split") return shell(`<div class="split"><div class="stack">${heading("lg")}${buttons(2)}</div>${image()}</div>`);
  if (pattern === "cards") return shell(`<div class="stack center">${heading("lg")}<div class="grid-3">${[1,2,3].map(() => `<article class="card">${image()}<p class="kicker">Category</p><h3>Short heading goes here</h3>${lorem}</article>`).join("")}</div></div>`);
  if (pattern === "steps") return shell(`<div class="stack center">${heading("lg")}<div class="grid-3">${[1,2,3].map((n) => `<article class="card card-box"><p class="kicker">Step ${n}</p><h3>Short heading goes here</h3>${lorem}</article>`).join("")}</div></div>`);
  if (pattern === "faq") return shell(`<div class="stack center">${heading("lg")}<div class="accordion" style="width:min(100%,900px)">${[1,2,3,4].map(() => `<div class="accordion-row"><span>Question text goes here</span><span>⌄</span></div>`).join("")}</div>${buttons(1)}</div>`);
  if (pattern === "cta") return shell(`<div class="stack center">${heading("lg")}${buttons(2)}</div>`, "narrow");
  if (pattern === "progress") return shell(`<div class="stack-sm"><div class="toolbar"><div class="logo">LOGO</div><span>Step label</span><button>Save and exit</button></div><div class="stepper"><span class="step active"></span><span class="step active"></span><span class="step"></span><span class="step"></span></div></div>`);
  if (pattern === "form") return shell(`<div class="split"><div class="stack">${heading("lg")}</div><form class="form">${[1,2,3,4].map((n) => `<div class="field"><label>Form label ${n}</label><input placeholder="Placeholder" /></div>`).join("")}<div class="choice-grid"><div class="choice">Option</div><div class="choice">Option</div><div class="choice">Option</div></div>${buttons(2)}</form></div>`);
  if (pattern === "form-error") return shell(`<div class="split"><div class="stack">${heading("lg")}<div class="notice"><strong>Correction needed</strong>${lorem}</div></div><form class="form"><div class="field"><label>Form label</label><input value="Saved value" /></div><div class="field"><label>Form label</label><input aria-invalid="true" placeholder="Correction needed" /><small>Field-specific guidance goes here.</small></div><div class="field"><label>Optional label</label><input placeholder="Optional" /></div>${buttons(2)}</form></div>`);
  if (pattern === "auth") return shell(`<div class="grid-2"><div class="stack">${heading("lg")}${image()}</div><div class="status stack"><h3 class="h-md">Account heading goes here</h3>${lorem}<button class="primary">Continue with provider</button><div class="field"><label>Email address</label><input placeholder="name@example.com" /></div><button>Send magic link</button></div></div>`, "narrow");
  if (pattern === "auth-sent") return shell(`<div class="status stack center"><div class="image-mark">ICON</div><h2 class="h-lg">Check your inbox</h2>${lorem}<div class="actions"><button class="primary">Open email app</button><button>Resend link</button></div></div>`, "narrow");
  if (pattern === "upload-guidance") return shell(`<div class="split"><div class="stack">${heading("lg")}<div class="notice"><strong>Consent and use</strong>${lorem}</div>${buttons(1)}</div><div class="grid-2">${[1,2,3,4].map(() => `<div class="image image-sm"><span class="image-mark">IMAGE</span></div>`).join("")}</div></div>`);
  if (pattern === "upload-grid") return shell(`<div class="stack"><div class="toolbar"><strong>Upload progress</strong><span>Count / maximum</span></div><div class="grid-4">${[1,2,3,4,5,6,7,8].map((_,i) => `<article class="card">${image()}<strong>${i === 7 && state === "error" ? "Needs attention" : i > 5 ? "Validating" : "Ready"}</strong><a href="#">Replace or remove</a></article>`).join("")}</div>${state === "error" ? `<div class="notice"><strong>One item needs attention</strong>${lorem}</div>` : ""}${buttons(2)}</div>`);
  if (pattern === "taste") return shell(`<div class="grid-2"><div class="stack center"><div class="image image-lg"><span class="image-mark">IMAGE</span></div><p class="kicker">Card label</p></div><div class="stack"><div class="progress"></div><h2 class="h-lg">Choose a response</h2>${lorem}<div class="choice-grid"><button>Hate</button><button>Maybe</button><button>Love</button></div><button>Undo</button><div class="notice"><strong>Gesture and keyboard equivalents</strong>${lorem}</div></div></div>`);
  if (pattern === "status") return shell(`<div class="grid-2"><div class="stack">${heading("lg")}<div class="progress"></div><div class="stack-sm"><div class="skeleton"></div><div class="skeleton"></div><div class="skeleton"></div></div></div><div class="status stack"><p class="kicker">${stateLabel} state</p><h3 class="h-md">Status heading goes here</h3>${lorem}<div class="notice"><strong>Progress is preserved</strong>${lorem}</div>${buttons(2)}</div></div>`, "narrow");
  if (pattern === "report-nav") return shell(`<div class="navbar"><div class="logo">LOGO</div><nav class="nav"><a href="#">Overview</a><a href="#">Section</a><a href="#">Section</a><a href="#">Section</a><button>Menu</button></nav></div>`);
  if (pattern === "report-hero") return shell(`<div class="split"><div class="stack">${heading("xl")}<div class="meta"><div class="avatar"></div><span>Report detail</span></div>${buttons(2)}</div>${image()}</div>`);
  if (pattern === "palette") return shell(`<div class="stack center">${heading("lg")}<div class="swatches" style="width:100%">${[1,2,3,4,5,6].map(() => `<div class="stack-sm"><div class="swatch"></div><strong>Color label</strong><span class="muted">Usage label</span></div>`).join("")}</div></div>`);
  if (pattern === "dashboard") return shell(`<div class="stack"><div class="toolbar"><div class="logo">LOGO</div><nav class="nav"><a href="#">Report</a><a href="#">Saved</a><a href="#">Profile</a><button>Bag</button></nav></div><div class="split"><div class="stack">${heading("lg")}${buttons(2)}</div>${image()}</div></div>`);
  if (pattern === "live") return shell(`<div class="workspace"><div class="viewport"><span class="image-mark">CAMERA</span><div class="overlay"><p class="kicker">${stateLabel} state</p><h2 class="h-md">Session heading goes here</h2>${lorem}${buttons(2)}</div></div><aside class="sidepanel"><h3 class="h-md">Current item</h3>${image()}${lorem}<button class="primary">Primary action</button><button>Direct control</button><div class="notice"><strong>Control status</strong>${lorem}</div></aside></div>`);
  if (pattern === "drawer") return shell(`<div class="drawer-layout"><div class="viewport"><span class="image-mark">CONTEXT</span></div><aside class="drawer"><p class="kicker">Product label</p><h2 class="h-md">Product heading goes here</h2>${image()}${lorem}<div class="table"><div class="row"><strong>Detail</strong><span>Value</span></div><div class="row"><strong>Detail</strong><span>Value</span></div></div>${buttons(3)}</aside></div>`);
  if (pattern === "bag") return shell(`<div class="stack"><div class="toolbar"><div class="logo">LOGO</div><button>Close</button></div>${heading("lg")}<div class="table">${[1,2,3].map((_,i) => `<div class="row">${image()}<div><strong>Item heading</strong>${lorem}</div><span>${state === "unavailable" && i === 0 ? "Unavailable" : "Available"}</span><button>Remove</button></div>`).join("")}</div><div class="notice"><strong>Retailer group and checkout boundary</strong>${lorem}</div>${buttons(2)}</div>`);
  if (pattern === "modal") return shell(`<div class="viewport"><div class="overlay center"><div class="image-mark">ICON</div><h2 class="h-lg">Confirmation heading goes here</h2>${lorem}<div class="notice"><strong>Important detail</strong>${lorem}</div>${buttons(2)}</div></div>`);
  return shell(`<div class="stack center">${heading("lg")}${buttons(2)}</div>`);
}

function sectionSpecs(screen, state) {
  const name = screen.name.toLowerCase();
  const spec = (name, pattern, purpose) => ({ name, pattern, purpose });
  if (name.startsWith("landing")) return [
    spec("Navigation", "navbar", "Orient visitors and expose the primary and returning-user routes."),
    spec("Hero", "hero", "Introduce the report-led value proposition and primary action."),
    spec("Report preview", "split", "Preview the shape of the result before asking for effort."),
    spec("How it works", "steps", "Explain the high-level journey and turnaround."),
    spec("Report contents", "cards", "Show the major report modules and practical outcomes."),
    spec("Trust and retailer roles", "split", "Clarify data use and the external retailer relationship."),
    spec("Frequently asked questions", "faq", "Resolve common objections without overloading the hero."),
    spec("Closing action", "cta", "Repeat the primary action after education."),
    spec("Footer", "footer", "Provide utility, policy, and login routes.")
  ];
  if (name.startsWith("account access")) return [spec("Navigation", "navbar", "Provide a route back to the public entry."), spec("Unified account access", "auth", "Support Google and email magic-link access in one module."), spec("Support and privacy", "footer", "Provide help and policy routes.")];
  if (name.startsWith("personal profile")) return [spec("Onboarding progress", "progress", "Show position and safe-exit behavior."), spec("Personal profile form", state === "error" ? "form-error" : "form", "Collect required and optional profile fields with contextual guidance."), spec("Step support", "cta", "Provide continuation and help without adding marketing copy.")];
  if (name.startsWith("brand and size")) return [spec("Onboarding progress", "progress", "Show position and safe-exit behavior."), spec("Brand selection", "cards", "Choose known brands using a scannable selection structure."), spec("Category sizes", "form", "Capture category-specific sizes and unknown values."), spec("Step actions", "cta", "Continue or return to the preceding step.")];
  if (name.startsWith("outfit photo")) return [spec("Onboarding progress", "progress", "Show position and required image count."), spec("Photo guidance", "upload-guidance", "Explain consent, quality, minimum, maximum, and use."), spec("Upload workspace", "upload-grid", "Show per-image status, replacement, and preservation."), spec("Step actions", "cta", "Enable continuation only when the minimum is valid.")];
  if (name.startsWith("taste calibration")) return [spec("Onboarding progress", "progress", "Show calibration progress and exit behavior."), spec("Taste decision workspace", state === "recovery" ? "status" : "taste", "Support swipe, button, keyboard, and undo interactions."), spec("Interaction guidance", "split", "Explain Love, Hate, Maybe, and accessible equivalents."), spec("Step actions", "cta", "Continue after sufficient signal or retry preserved progress.")];
  if (name.startsWith("account connection")) return [spec("Onboarding progress", "progress", "Show the final onboarding gate."), spec("Unified account connection", name.includes("magic link") ? "auth-sent" : state === "recovery" ? "status" : "auth", "Create or resume an account without a separate signup flow."), spec("Progress preservation", "split", "Explain that anonymous onboarding work remains attached through connection."), spec("Support", "cta", "Offer alternate method or recovery.")];
  if (name.startsWith("style report analysis")) return [spec("Analysis status header", "progress", "Provide global status and safe exit."), spec("Analysis state", "status", "Show meaningful processing, slow, or recovery behavior."), spec("Preservation and notification", "cta", "Confirm saved inputs and available next actions.")];
  if (name.startsWith("style report — feedback")) return [spec("Report navigation", "report-nav", "Preserve report context."), spec("Feedback form", "form", "Capture correction, disagreement, or recalibration request."), spec("Confirmation and next step", "cta", "Submit or return without losing the report.")];
  if (name.startsWith("style report — color")) return [spec("Report navigation", "report-nav", "Move across report modules."), spec("Color summary", "report-hero", "Introduce the palette and usage context."), spec("Labeled palette", "palette", "Pair every swatch with text and usage labels."), spec("Combination examples", "cards", "Show usable combinations and examples."), spec("Feedback and products", "cta", "Provide feedback and matched-item actions.")];
  if (name.startsWith("style report — body")) return [spec("Report navigation", "report-nav", "Move across report modules."), spec("Body-style summary", "report-hero", "Present profile, rationale, and confidence."), spec("Proportion guidance", "split", "Translate the framework into practical silhouette guidance."), spec("What to wear", "cards", "Organize actionable garment and outfit patterns."), spec("Feedback", "cta", "Allow disagreement and recalibration.")];
  if (name.startsWith("style report — recommendation")) return [spec("Report navigation", "report-nav", "Move across report modules."), spec("Recommendation summary", "report-hero", "Prioritize the most material recommendations."), spec("Recommendation categories", "cards", "Structure silhouettes, layers, fabrics, and garments."), spec("Example outfits", "split", "Connect guidance to visible outfit structures."), spec("Matched products", "cta", "Open personalized product sets.")];
  if (name.startsWith("style report — overview")) return [spec("Report navigation", "report-nav", "Introduce the report structure."), spec("Style identity summary", "report-hero", "Lead with strengths and prioritized opportunities."), spec("Key findings", "cards", "Summarize the major report modules."), spec("What to do next", "steps", "Translate the report into a short action sequence."), spec("Feedback and next action", "cta", "Offer correction and styling routes.")];
  if (name.startsWith("style home")) return [spec("App navigation", "dashboard", "Orient returning users and expose core destinations."), spec("Current status", state === "recovery" ? "status" : "split", "Show the current report or recovery priority."), spec("Report highlights", "cards", "Summarize useful findings."), spec("Recommended items", "cards", "Preview personalized products and refinements."), spec("Saved and recent activity", "split", "Expose bag, sessions, and account continuity.")];
  if (name.startsWith("live styling")) return [spec("Session navigation", "navbar", "Provide exit, report, and bag access."), spec("Live session workspace", "live", "Show the camera context, active item, controls, and the named state."), spec("Recommended item rail", "cards", "Preserve item alternatives and selection context."), spec("Safety and alternatives", "cta", "Expose direct controls, recovery, and the visualization limitation.")];
  if (name.startsWith("recommended product")) return [spec("Context navigation", "navbar", "Preserve product, report, bag, and close routes."), spec("Preserved styling context", "live", "Keep the report or live session visible behind product detail."), spec("Product detail drawer", name.includes("unavailable") ? "status" : "drawer", "Show product provenance, rationale, availability, and actions."), spec("Selection actions", "cta", "Add, try, find alternatives, or continue externally.")];
  if (name.startsWith("magic mirror bag") || name.startsWith("bag —")) return [spec("App navigation", "navbar", "Preserve access to styling and report."), spec("Retailer-grouped selections", "bag", "Review item status and retailer groupings."), spec("Checkout boundary", "split", "Clarify what happens on retailer handoff."), spec("Bag actions", "cta", "Continue styling or move to a retailer.")];
  if (name.startsWith("retailer handoff")) return [spec("Preserved bag context", "bag", "Keep the selected item and bag visible behind confirmation."), spec("Retailer confirmation", "modal", "Confirm destination ownership and the external handoff.")];
  return [spec("Navigation", "navbar", "Orient the user."), spec("Primary content", "split", "Lay out the screen's primary decision."), spec("Actions", "cta", "Expose the next action and recovery.")];
}

function document(inner, screenId, state, sectionId = null) {
  const attrs = `data-wireframe="true" data-screen-id="${screenId}" data-state="${state}"${sectionId ? ` data-section-id="${sectionId}"` : ""}`;
  return `<!doctype html>\n<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Wireframe</title><link rel="stylesheet" href="wireframe.css"></head><body ${attrs}><main>${inner}</main></body></html>\n`;
}

const sectionPlan = { schema_version: "2.0", source_screens: "company/artifacts/prd/screens.json", generated_at: now, status: "ready-for-review", screens: [] };
const manifest = { schema_version: "2.0", source_screens: "company/artifacts/prd/screens.json", source_section_plan: "company/artifacts/ui-ux-design/section-plan.json", status: "ready-for-review", generated_at: now, screens: [] };
const seenScreenSlugs = new Set();

for (const screen of screens) {
  const screenSlug = slug(screen.name);
  if (seenScreenSlugs.has(screenSlug)) throw new Error(`Duplicate screen_slug: ${screenSlug}`);
  seenScreenSlugs.add(screenSlug);
  screen.screen_slug = screenSlug;
  for (const state of screen.required_states) {
    const htmlDir = path.join(uxRoot, "wireframes/html", screenSlug, state);
    const htmlSections = path.join(htmlDir, "sections");
    const pngDir = path.join(uxRoot, "wireframes/png", screenSlug, state);
    const pngSections = path.join(pngDir, "sections");
    ensure(htmlSections); ensure(pngSections);
    write(path.join(htmlDir, "wireframe.css"), wireframeCss);
    write(path.join(htmlSections, "wireframe.css"), wireframeCss);
    const specs = sectionSpecs(screen, state);
    const planned = [];
    const manifested = [];
    const assembled = [];
    specs.forEach((spec, index) => {
      const sectionId = `SEC-${String(index + 1).padStart(3, "0")}`;
      const filename = `${sectionId}-${slug(spec.name)}.html`;
      const htmlFile = path.join(htmlSections, filename);
      const markup = patternMarkup(spec.pattern, state);
      write(htmlFile, document(`<section class="section">${markup}</section>`, screen.screen_id, state, sectionId));
      assembled.push(`<section class="section" data-section-id="${sectionId}">${markup}</section>`);
      planned.push({ section_id: sectionId, order: index + 1, name: spec.name, pattern: spec.pattern, purpose: spec.purpose, related_stories: screen.related_user_stories, related_scenarios: screen.related_scenarios, state_notes: `Structure for the ${state} state.` });
      manifested.push({ section_id: sectionId, order: index + 1, name: spec.name, pattern: spec.pattern, purpose: spec.purpose, related_stories: screen.related_user_stories, related_scenarios: screen.related_scenarios, html: rel(htmlFile), captures: { desktop: rel(path.join(pngSections, `desktop-${sectionId}-${slug(spec.name)}.png`)), mobile: rel(path.join(pngSections, `mobile-${sectionId}-${slug(spec.name)}.png`)) } });
    });
    const screenHtml = path.join(htmlDir, "screen.html");
    write(screenHtml, document(assembled.join(""), screen.screen_id, state));
    sectionPlan.screens.push({ screen_id: screen.screen_id, screen_slug: screenSlug, screen_name: screen.name, state, route_or_context: screen.route_or_context, related_stories: screen.related_user_stories, related_scenarios: screen.related_scenarios, sections: planned });
    const desktopPng = path.join(pngDir, "desktop-screen.png");
    const mobilePng = path.join(pngDir, "mobile-screen.png");
    manifest.screens.push({ screen_id: screen.screen_id, screen_slug: screenSlug, screen_name: screen.name, state, related_stories: screen.related_user_stories, related_scenarios: screen.related_scenarios, assembled: { html: rel(screenHtml), captures: { desktop: { png: rel(desktopPng), width: 1440, height: null, full_page: true }, mobile: { png: rel(mobilePng), width: 390, height: null, full_page: true } } }, sections: manifested, status: "ready-for-review", verified_at: null, approved_at: null });
    screen.wireframe = { status: "ready-for-review", manifest_entry: `company/artifacts/ui-ux-design/wireframe-manifest.json#${screenSlug}/${state}`, html: rel(screenHtml), screenshots: { desktop: rel(desktopPng), mobile: rel(mobilePng) } };
  }
}

writeJson(path.join(uxRoot, "section-plan.json"), sectionPlan);
writeJson(path.join(uxRoot, "wireframe-manifest.json"), manifest);
writeJson(screensPath, payload);

// Remove obsolete captures or sources left by a changed section sequence while
// preserving every path still referenced by the current manifest.
const expectedWireframes = new Set();
for (const record of manifest.screens) {
  expectedWireframes.add(record.assembled.html);
  expectedWireframes.add(`${path.posix.dirname(record.assembled.html)}/wireframe.css`);
  expectedWireframes.add(record.assembled.captures.desktop.png);
  expectedWireframes.add(record.assembled.captures.mobile.png);
  for (const section of record.sections) {
    expectedWireframes.add(section.html);
    expectedWireframes.add(`${path.posix.dirname(section.html)}/wireframe.css`);
    expectedWireframes.add(section.captures.desktop);
    expectedWireframes.add(section.captures.mobile);
  }
}
for (const kind of ["html", "png"]) {
  const base = path.join(uxRoot, "wireframes", kind);
  if (!fs.existsSync(base)) continue;
  const visit = (dir) => {
    for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
      const file = path.join(dir, entry.name);
      if (entry.isDirectory()) {
        visit(file);
        if (fs.readdirSync(file).length === 0) fs.rmdirSync(file);
      } else if ((entry.name.endsWith(".html") || entry.name.endsWith(".png") || entry.name.endsWith(".css")) && !expectedWireframes.has(rel(file))) {
        fs.unlinkSync(file);
      }
    }
  };
  visit(base);
}

write(path.join(uxRoot, "information-architecture.md"), `# Information Architecture\n\nStatus: Approved by Talisha White on 2026-07-19  \nSource: Approved PRD, user stories, scenarios, and screen inventory\n\n## Public\n\n- Landing page\n- Unified account access\n\n## Anonymous style-report onboarding\n\n- Personal profile\n- Brand and category sizes\n- Outfit-photo consent and upload\n- Taste calibration\n- Permanent account connection\n- Report analysis\n\n## Authenticated report and styling\n\n- Style home\n- Report overview\n  - Color\n  - Body-style guidance\n  - Recommendations\n  - Feedback and recalibration\n- Live styling\n  - Camera permission and recovery\n  - Connection and visualization states\n  - Voice permission and interaction states\n  - Hand-gesture guide and recognition states\n  - Product details\n- Bag\n- Retailer handoff\n\n## System boundaries\n\n- Anonymous identity owns onboarding progress until permanent account connection.\n- Google and email magic link share one signup/login entry.\n- Retailers own current price, stock, checkout, payment, shipping, and returns.\n- Camera, microphone, and photo-analysis consent are purpose-specific.\n`);

write(path.join(uxRoot, "navigation.md"), `# Navigation\n\n## Public navigation\n\n- LOGO/home\n- How it works anchor\n- Report preview anchor\n- Trust/FAQ anchor\n- Log in\n- Primary report-start action\n\n## Onboarding navigation\n\n- Step progress\n- Back\n- Save and exit where account state permits\n- One primary continuation action\n- Field or provider recovery in context\n\n## Authenticated product navigation\n\n- Style home\n- Report\n- Recommendations\n- Live styling\n- Bag\n- Profile/account\n\n## Report subnavigation\n\n- Overview\n- Colors\n- Body-style guidance\n- Recommendations\n- Feedback/recalibration\n\n## Live-session navigation\n\n- Exit session\n- Current item and alternatives\n- Voice control\n- Gesture control\n- Direct controls\n- Bag\n`);

ensure(path.join(uxRoot, "user-flows"));
write(path.join(uxRoot, "user-flows/first-report.md"), `# First report flow\n\nLanding → anonymous identity → profile → brands/sizes → photo consent/upload → taste calibration → unified account connection → processing → completed report → style home.\n\nFailures preserve valid progress and return to the precise incomplete state.\n`);
write(path.join(uxRoot, "user-flows/returning-user.md"), `# Returning-user flow\n\nUnified login → inspect account state → resume incomplete onboarding, active analysis, report, recovery, or style home.\n`);
write(path.join(uxRoot, "user-flows/live-styling.md"), `# Live styling flow\n\nRecommendation → camera permission → connecting → ready → optional voice or gesture control → product detail → bag → retailer confirmation → external retailer.\n\nCamera denial, microphone denial, slow rendering, provider failure, unavailable items, and ambiguous controls preserve report and selected-product context.\n`);

const oldCount = 27;
write(path.join(uxRoot, "ux-notes.md"), `# UX Notes\n\n## Inventory audit\n\nThe approved 27-record inventory described the main pages but omitted several visibly distinct states promised by its own stories and scenarios. This rerun preserves every existing screen ID and adds ${screens.length - oldCount} state records, for ${screens.length} total screen/state records.\n\nAdded coverage:\n\n- Personal-profile field validation\n- Account-connection interruption/failure\n- Report feedback and recalibration\n- Returning-user resume/recovery\n- Camera denial\n- Live-session connecting, changing, slow, failure, and ended states\n- Separate voice listening, interpreting, confirming, acting, and failure states\n- Gesture observing, interpreting, accepted, ignored/unavailable, and consequential-action confirmation states\n- Product and bag unavailability\n\n## Wireframe contract\n\n- The wireframes are intentionally anonymous: LOGO, generic headings and controls, lorem ipsum, and gray media placeholders.\n- Product-specific meaning lives in the section plan, manifest, IA, and flow documents—not in the wireframe canvas.\n- Every screen/state is decomposed into ordered Relume-style sections before assembly.\n- Every section and assembled screen is rendered at 1440px desktop and 390px mobile widths.\n- Exact screen IDs and states appear in paths, data attributes, and review labels.\n\n## Interaction notes\n\n- Swipe right = Love, left = Hate, down = Maybe, with visible buttons, keyboard equivalents, and undo.\n- Google and email magic link form one signup/login step while anonymous progress remains owned and recoverable.\n- Voice, gesture, and direct controls are equivalent routes for essential live-session actions.\n- Consequential gesture actions require confirmation.\n- Retailer handoff is explicit and preserves the in-product report and bag for return.\n`);

const uxNotesPath = path.join(uxRoot, "ux-notes.md");
write(uxNotesPath, fs.readFileSync(uxNotesPath, "utf8").replace(
  "- Exact screen IDs and states appear in paths, data attributes, and review labels.",
  "- Human-readable screen slugs and states appear in folders. Stable screen IDs remain in HTML data attributes, screens.json, the section plan, and the manifest, but never render visibly inside a wireframe.\n- Placeholder body copy appears only inside sections that structurally call for it; no validator-only lorem ipsum is appended after the final section."
));

console.log(`Generated ${screens.length} screen/state records and ${manifest.screens.reduce((sum, x) => sum + x.sections.length, 0)} section records.`);
