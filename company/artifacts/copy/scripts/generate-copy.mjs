#!/usr/bin/env node

import fs from "node:fs";
import path from "node:path";

const root = path.resolve(import.meta.dirname, "../../../..");
const screensPath = path.join(root, "company/artifacts/prd/screens.json");
const wireframeManifestPath = path.join(root, "company/artifacts/ui-ux-design/wireframe-manifest.json");
const sectionPlanPath = path.join(root, "company/artifacts/ui-ux-design/section-plan.json");
const outputRoot = path.join(root, "company/artifacts/copy");
const outputScreens = path.join(outputRoot, "screens");
const generatedAt = new Date().toISOString();
const rel = (value) => path.relative(root, value).split(path.sep).join("/");

fs.mkdirSync(outputScreens, { recursive: true });

const screenPayload = JSON.parse(fs.readFileSync(screensPath, "utf8"));
const wireframeManifest = JSON.parse(fs.readFileSync(wireframeManifestPath, "utf8"));
const sectionPlan = JSON.parse(fs.readFileSync(sectionPlanPath, "utf8"));

const defaults = {
  eyebrow: null,
  headline: null,
  supporting_copy: null,
  primary_cta: null,
  secondary_cta: null,
  tertiary_cta: null,
  navigation: {},
  labels: {},
  helper_text: {},
  validation: {},
  status_messages: {},
  consent: {},
  metadata: {},
  accessibility: {},
  section_overrides: {},
  alternatives: [],
  voice_notes: "Clear, editorial, practical, and transparent.",
  layout_constraints: "Keep the headline concise, actions predictable, and state guidance readable on mobile."
};

const c = (value) => ({ ...defaults, ...value });

const copyBySlug = {
  "landing-page-base": c({
    eyebrow: "PERSONAL STYLE, MADE PRACTICAL",
    headline: "Your style already has a point of view.",
    supporting_copy: "Turn the looks you love into a personal guide to colors, silhouettes, and what to wear next.",
    primary_cta: "Get my style report",
    secondary_cta: "Log in",
    navigation: { how_it_works: "How it works", report: "What’s inside", trust: "Your privacy", login: "Log in" },
    labels: { report_preview: "YOUR REPORT", colors: "Your color direction", body_style: "Your proportions and silhouettes", recommendations: "What to wear next" },
    helper_text: { timing: "Your report is usually ready in 1–2 minutes.", inputs: "Start with a few details and 8–12 photos of looks you love." },
    consent: { photos: "Your photos are used only to create and improve your personal style report." },
    metadata: { retailer_boundary: "Found something you love? You’ll shop and check out directly with the retailer." },
    section_overrides: {
      "Hero": { headline: "Your style already has a point of view.", body: "Turn the looks you love into a personal guide to colors, silhouettes, and what to wear next.", primary_cta: "Get my style report", secondary_cta: "Log in" },
      "Report preview": { eyebrow: "YOUR REPORT", headline: "See what makes your style yours.", body: "Discover the colors, shapes, and details you return to—and where to take them next." },
      "How it works": { headline: "From favorite looks to your style report.", steps: ["Show us what you love", "Follow your first instinct", "Meet your style"] },
      "Report contents": { headline: "A guide you can actually wear.", cards: ["Your color direction", "Your proportions and silhouettes", "What to wear next"] },
      "Trust and retailer roles": { headline: "Your style. Your photos. Your choice.", body: "Your photos create your private report. When you find something you love, you’ll shop directly with the retailer." },
      "Frequently asked questions": { headline: "Good questions, answered.", questions: ["What do I need to get started?", "How long does the report take?", "Does Magic Mirror guarantee fit?", "How are my photos used?"] },
      "Closing action": { headline: "Meet the style that’s already yours.", primary_cta: "Get my style report", secondary_cta: "Log in" }
    },
    alternatives: [
      { label: "Headline alternative A", value: "Your style, decoded into something you can use." },
      { label: "Headline alternative B", value: "Turn your favorite looks into your personal style playbook." },
      { label: "CTA alternative", value: "Build my style report" }
    ],
    voice_notes: "Editorial and specific, with the mechanism immediately visible. Avoid unsupported proof or attractiveness language.",
    layout_constraints: "Keep the hero headline to two desktop lines when possible; the primary CTA must remain visible above the fold."
  }),
  "account-access-unauthenticated": c({
    eyebrow: null, headline: "Sign in to Magic Mirror", supporting_copy: null, primary_cta: "Continue with Google", secondary_cta: "Send me a sign-in link", tertiary_cta: null,
    labels: { email: "Email address" }, helper_text: { email: "No password needed." }, validation: { email: "Enter your email address." },
    alternatives: [{ label: "Headline alternative", value: "Welcome back." }]
  }),
  "personal-profile-base": c({
    eyebrow: "STEP 1 OF 4", headline: "A little about you.", supporting_copy: "This helps us make your style report more personal.", primary_cta: "Choose my brands", secondary_cta: "Save and exit",
    labels: { name: "Name", adult: "I confirm I’m 18 or older", gender: "Gender", age: "Age", height: "Height", weight: "Weight (optional)" },
    helper_text: { name: "The name you’d like us to use.", gender: "We use your gender only to shape styling and shopping recommendations. You can self-describe.", weight: "Skip this if you’d rather not say." },
    consent: { gender: "Your gender is used only to personalize styling and shopping recommendations." },
    validation: { adult: "Confirm that you’re 18 or older to continue.", age: "Enter your age.", height: "Enter your height." }
  }),
  "brand-and-size-profile-base": c({
    eyebrow: "STEP 2 OF 4", headline: "What fits you best?", supporting_copy: "Choose a few favorite brands and the sizes you reach for.", primary_cta: "Add my photos", secondary_cta: "Back", tertiary_cta: "Save and exit",
    labels: { brands: "Favorite brands", brand_search: "Search or add a brand", category: "Garment category", size: "Usual size", unknown: "I’m not sure" },
    helper_text: { sizing: "Add another entry when your size changes by brand or item." }, validation: { brand: "Choose or add a brand.", size: "Choose a size or select “I’m not sure.”" }
  }),
  "outfit-photo-upload-empty": c({
    eyebrow: "STEP 3 OF 4", headline: "Show us your favorite looks.", supporting_copy: "Add 8–12 full-body photos of outfits you feel great in.", primary_cta: "Choose photos", secondary_cta: "Back", tertiary_cta: "Save and exit",
    labels: { count: "0 of 8 required photos", accepted: "JPG, PNG, or HEIC" },
    helper_text: { quality: "Choose clear, well-lit photos that show your full outfit. One person per photo works best.", range: "8 photos minimum. 12 maximum." },
    consent: { photos: "I agree to let Magic Mirror use these photos to create my style report.", isolation: "Only you can access the photos you add." },
    validation: { consent: "Agree to photo use before continuing." }
  }),
  "outfit-photo-upload-partial": c({
    eyebrow: "STEP 3 OF 4", headline: "Your style is taking shape.", supporting_copy: "Add at least 8 photos, then follow your first instinct through a few more looks.", primary_cta: "Refine my taste", secondary_cta: "Add more photos", tertiary_cta: "Save and exit",
    labels: { ready: "Ready", checking: "Checking", replace: "Replace", remove: "Remove" }, helper_text: { minimum: "You can continue once 8 photos are ready." }, status_messages: { uploading: "Uploading…", validating: "Checking photo…", ready: "Ready" }
  }),
  "outfit-photo-upload-validation-error": c({
    eyebrow: null, headline: "Let’s swap this one.", supporting_copy: "Choose a different photo to keep going. Your other photos are ready.", primary_cta: "Replace photo", secondary_cta: "Remove", tertiary_cta: "Add another",
    labels: { rejected: "Try another photo", preserved: "Other photos ready" }, validation: { format: "Choose a JPG, PNG, or HEIC image.", duplicate: "You already added this photo.", full_body: "Choose a photo that shows your full outfit.", unreadable: "We couldn’t open this image. Try another one." }, status_messages: { preserved: "Your other photos are ready." }
  }),
  "taste-calibration-base": c({
    eyebrow: "STEP 4 OF 4", headline: "Trust your first reaction.", supporting_copy: "Swipe right for Love, left for Hate, or down for Maybe.", primary_cta: "Love", secondary_cta: "Hate", tertiary_cta: "Maybe",
    labels: { progress: "Your picks", undo: "Undo" }, helper_text: { gestures: "Right for Love. Left for Hate. Down for Maybe.", keyboard: "Use the right, left, or down arrow keys." }, accessibility: { card: "Style look", announcement: "Choice saved. Next look." }
  }),
  "taste-calibration-recovery": c({
    eyebrow: null, headline: "Let’s try that again.", supporting_copy: "Your choices are saved.", primary_cta: "Load the next look", secondary_cta: "Save and exit", labels: { progress: "Your picks" }, status_messages: { error: "The next look didn’t load.", preserved: "Your choices are saved." }
  }),
  "account-connection-base": c({
    eyebrow: "ONE LAST STEP", headline: "Your report is almost ready.", supporting_copy: "Save your progress to see your results and come back anytime.", primary_cta: "Continue with Google", secondary_cta: "Send me a sign-in link",
    labels: { email: "Email address" }, helper_text: { account: "Already have an account? Use the same email to sign in.", progress: "Everything you’ve added is saved when you continue." }, validation: { email: "Enter your email address." }, consent: { account: "By continuing, you agree to create or sign in to your Magic Mirror account." }
  }),
  "account-connection-magic-link-sent": c({
    eyebrow: null, headline: "Check your inbox.", supporting_copy: "We sent a sign-in link to {{email_address}}.", primary_cta: "Open email", secondary_cta: "Send another link", tertiary_cta: "Use Google instead",
    status_messages: { sent: "Link sent to {{email_address}}.", expired: "That link expired. Send a new one to continue." }, metadata: { dynamic_tokens: ["email_address"] }
  }),
  "style-report-analysis-processing": c({
    eyebrow: null, headline: "Your style report is coming together.", supporting_copy: "We’re turning your favorite looks and preferences into guidance made for you.", primary_cta: "Email me when it’s ready", secondary_cta: "Come back later",
    labels: { stage_profile: "Getting to know you", stage_photos: "Finding your patterns", stage_taste: "Following your taste", stage_report: "Creating your guide" }, helper_text: { timing: "This usually takes 1–2 minutes." }, status_messages: { active: "Building your report…", saved: "You can come back anytime." }
  }),
  "style-report-analysis-slow": c({
    eyebrow: null, headline: "Still putting the finishing touches on your report.", supporting_copy: "It’s taking a little longer, but you don’t need to stay on this page.", primary_cta: "Email me when it’s ready", secondary_cta: "Come back later", status_messages: { slow: "Still building your report…", saved: "Everything you added is saved." }
  }),
  "style-report-analysis-error-recovery": c({
    eyebrow: null, headline: "We hit a snag.", supporting_copy: "Your answers and photos are safe. Try again when you’re ready.", primary_cta: "Try again", secondary_cta: "Get help", tertiary_cta: "Come back later",
    status_messages: { error: "Your report couldn’t be finished.", preserved: "Everything you added is saved." }
  }),
  "style-report-overview": c({
    eyebrow: "YOUR STYLE REPORT", headline: "See what makes your style yours.", supporting_copy: "Meet the patterns behind your strongest looks—and where to take them next.", primary_cta: "Explore my report", secondary_cta: "See my picks",
    navigation: { overview: "Overview", colors: "Colors", body_style: "Body style", recommendations: "Recommendations" },
    labels: { identity: "Your style identity", strengths: "What’s already working", priorities: "Try these first", source: "Based on" },
    helper_text: { inference: "Something feel off? You can change it." },
    metadata: { dynamic_tokens: ["style_identity_name", "strength_one", "priority_one"] },
    section_overrides: { "Style identity summary": { headline: "{{style_identity_name}}", body: "The colors, shapes, and details you return to create a style that feels distinctly yours." }, "Feedback and next action": { primary_cta: "Explore my report", secondary_cta: "Change a result" } }
  }),
  "style-report-color": c({
    eyebrow: "YOUR COLORS", headline: "Meet your colors.", supporting_copy: "A personal palette for getting dressed, shopping smarter, and trying something new.", primary_cta: "Find pieces in my colors", secondary_cta: "Save my palette", tertiary_cta: "Update my colors",
    navigation: { overview: "Overview", colors: "Colors", body_style: "Body style", recommendations: "Recommendations" }, labels: { primary: "Core colors", neutrals: "Everyday neutrals", accents: "Accent colors", combinations: "Try these together" }, helper_text: { accessibility: "Each color includes a name and a way to wear it.", intent: "Think of this as a guide, not a rulebook." }
  }),
  "style-report-body-style": c({
    eyebrow: "YOUR STYLE LINES", headline: "Shapes that work with you.", supporting_copy: "Discover the silhouettes, proportions, and details that bring your style into balance.", primary_cta: "See my silhouettes", secondary_cta: "Update my result",
    navigation: { overview: "Overview", colors: "Colors", body_style: "Body style", recommendations: "Recommendations" }, labels: { profile: "Your Kibbe-inspired type", confidence: "Match", rationale: "Why it fits", implications: "Try this" }, helper_text: { framework: "This is a starting point. Keep what feels right." }, metadata: { dynamic_tokens: ["body_style_profile", "confidence_label"] }
  }),
  "style-report-recommendations": c({
    eyebrow: "WHAT TO WEAR NEXT", headline: "Your next looks, already styled.", supporting_copy: "Explore pieces and outfit ideas chosen to work with your colors, proportions, and taste.", primary_cta: "See my picks", secondary_cta: "Save this guide",
    navigation: { overview: "Overview", colors: "Colors", body_style: "Body style", recommendations: "Recommendations" }, labels: { silhouettes: "Silhouettes", proportions: "Proportions", layers: "Layers", fabrics: "Fabrics", outfits: "Example outfits", reason: "Why this works for you", preview: "Generated wardrobe preview" }, helper_text: { preview: "A styling visualization, not a fit guarantee. Shop the linked real product at the retailer." }, status_messages: { preview_unavailable: "Your recommendation and product link are ready without a generated preview." }
  }),
  "style-home-base": c({
    eyebrow: null, headline: "What are you in the mood to wear, {{preferred_name}}?", supporting_copy: null, primary_cta: "Start live styling", secondary_cta: "View my report", tertiary_cta: "Browse my picks",
    navigation: { home: "Style home", report: "My report", picks: "My picks", bag: "Bag", profile: "Profile" }, labels: { report: "Report highlights", next: "Recommended next step", picks: "Selected for you", recent: "Recent activity" }, metadata: { dynamic_tokens: ["preferred_name"] }
  }),
  "live-styling-camera-permission": c({
    eyebrow: null, headline: "Step into the mirror.", supporting_copy: "Turn on your camera to try on your picks and use hands-free controls.", primary_cta: "Turn on camera", secondary_cta: "Not now", tertiary_cta: "Back to my picks",
    consent: { camera: "Allow camera access for live styling and hand controls." }, helper_text: { limitation: "The live view is a styling preview. Fit may vary.", fallback: "You can still browse your picks without the camera." }
  }),
  "live-styling-ready": c({
    eyebrow: null, headline: "Try it on.", supporting_copy: null, primary_cta: "Add to bag", secondary_cta: "Next look", tertiary_cta: "End session",
    navigation: { report: "Report", bag: "Bag", exit: "End session" }, labels: { current: "Trying now", voice: "Voice", gestures: "Hand controls", direct: "Controls" }, helper_text: { limitation: "Styling preview only. Fit may vary." }, accessibility: { camera: "Live styling view", current_item: "Current item" }
  }),
  "live-styling-microphone-permission": c({
    eyebrow: null, headline: "Style it out loud.", supporting_copy: "Ask for another color, a different shape, or something for the occasion.", primary_cta: "Turn on microphone", secondary_cta: "Use buttons instead", tertiary_cta: "Cancel",
    consent: { microphone: "Allow microphone access while voice control is on." }
  }),
  "live-styling-voice-listening": c({
    eyebrow: "LISTENING", headline: "What’s next?", supporting_copy: "Try “a darker color,” “something for a wedding,” or “under $100.”", primary_cta: "Stop listening", secondary_cta: "Use buttons", status_messages: { listening: "Listening…" }, accessibility: { live_region: "Listening for your request." }
  }),
  "live-styling-hand-gesture-guide": c({
    eyebrow: null, headline: "Hands-free styling.", supporting_copy: "Swipe through looks and choose items without walking back to your screen.", primary_cta: "Turn on hand controls", secondary_cta: "Practice", tertiary_cta: "Use voice",
    labels: { next: "Next look", previous: "Previous look", select: "Choose" }, helper_text: { confirmation: "We’ll always ask before adding an item, opening a retailer, or ending your session.", alternatives: "You can use voice or the buttons anytime." }, accessibility: { guide: "Hand gestures and matching actions" }
  }),
  "recommended-product-detail-drawer": c({
    eyebrow: "PICKED FOR YOU", headline: "{{product_name}}", supporting_copy: "See why it works with your style, then try it on or save it for later.", primary_cta: "Add to bag", secondary_cta: "Try it on", tertiary_cta: "Shop at retailer",
    labels: { retailer: "Retailer", price: "Price", availability: "Availability", size: "Your usual size", rationale: "Why it works", checked: "Last checked" }, helper_text: { limitation: "Check the retailer for current price, availability, and fit." }, metadata: { dynamic_tokens: ["product_name", "retailer_name", "current_price", "availability_status", "availability_checked_at"] }
  }),
  "magic-mirror-bag-base": c({
    eyebrow: null, headline: "Your picks.", supporting_copy: "One more look before you shop.", primary_cta: "Shop at retailer", secondary_cta: "Keep styling",
    navigation: { report: "Report", style: "Live styling", bag: "Bag" }, labels: { retailer_group: "From {{retailer_name}}", availability: "Availability", remove: "Remove", subtotal: "Subtotal" }, helper_text: { boundary: "You’ll check out with each retailer." }, metadata: { dynamic_tokens: ["retailer_name"] }
  }),
  "retailer-handoff-confirmation": c({
    eyebrow: null, headline: "Ready to shop at {{retailer_name}}?", supporting_copy: "You’ll finish your purchase on their site. Your picks will be here when you come back.", primary_cta: "Shop at {{retailer_name}}", secondary_cta: "Not yet", metadata: { dynamic_tokens: ["retailer_name"] }, accessibility: { external: "Opens {{retailer_name}} in a new tab" }
  }),
  "personal-profile-validation-error": c({
    eyebrow: null, headline: "Check a few details.", supporting_copy: null, primary_cta: "Continue", secondary_cta: "Save and exit",
    labels: { saved: "Saved", error: "Check this", optional: "Weight (optional)" }, validation: { adult: "Confirm that you’re 18 or older.", gender: "Tell us your gender or self-describe so we can shape styling and shopping recommendations.", age: "Enter your age.", height: "Enter your height." }, status_messages: { preserved: "Your other answers are saved." }
  }),
  "account-connection-error-recovery": c({
    eyebrow: null, headline: "Let’s try that again.", supporting_copy: "Your progress is safe.", primary_cta: "Try again", secondary_cta: "Use another way", tertiary_cta: "Get help",
    status_messages: { interrupted: "Sign-in didn’t finish.", preserved: "Your progress is saved." }, validation: { email: "Check your email address and send a new link.", google: "Google sign-in didn’t finish. Try again or use email." }
  }),
  "style-report-feedback-and-recalibration": c({
    eyebrow: null, headline: "Make this feel more like you.", supporting_copy: "Tell us what missed the mark, and we’ll adjust your report.", primary_cta: "Update my report", secondary_cta: null, tertiary_cta: "Cancel",
    labels: { finding: "Your result", feedback_type: "What feels off?", correction: "What would you change?", context: "Anything else? (optional)" }, helper_text: { effect: "We’ll use your feedback to improve your report and picks." }, validation: { required: "Choose what feels off and tell us what you’d change." }
  }),
  "style-home-resume-or-recover": c({
    eyebrow: null, headline: "Right where you left it.", supporting_copy: "Your style report is waiting.", primary_cta: "Keep going", secondary_cta: "Try again", tertiary_cta: "View my report",
    labels: { incomplete: "Continue", paused: "Try again", ready: "Ready" }, status_messages: { saved: "Your progress is saved." }
  }),
  "live-styling-camera-denied": c({
    eyebrow: null, headline: "Your camera is off.", supporting_copy: "Turn it on in your browser settings to use the live mirror.", primary_cta: "Try again", secondary_cta: "How to turn it on", tertiary_cta: "Back to my picks",
    status_messages: { denied: "Camera access is off.", preserved: "Your picks are saved." }, helper_text: { fallback: "You can still browse your picks." }
  }),
  "live-styling-connecting": c({
    eyebrow: null, headline: "Opening your mirror…", supporting_copy: "Your first look is almost ready.", primary_cta: "Go back", labels: { camera: "Camera", item: "Your first look" }, status_messages: { connecting: "Getting ready…" }, accessibility: { live_region: "Opening the live mirror." }
  }),
  "live-styling-changing-item": c({
    eyebrow: null, headline: "Bringing up your next look…", supporting_copy: "Hold your position for a moment.", primary_cta: "Cancel", labels: { current: "Current look", next: "Up next" }, status_messages: { changing: "Changing your look…" }, accessibility: { live_region: "Bringing up the next look." }
  }),
  "live-styling-slow": c({
    eyebrow: null, headline: "This look needs another moment.", supporting_copy: "Keep waiting or choose something else.", primary_cta: "Keep waiting", secondary_cta: "Choose another look", tertiary_cta: "Back to my picks", status_messages: { slow: "Still working on this look…", preserved: "Your picks are saved." }
  }),
  "live-styling-error-recovery": c({
    eyebrow: null, headline: "That look didn’t load.", supporting_copy: "Try it again or choose another piece.", primary_cta: "Try again", secondary_cta: "Choose another look", tertiary_cta: "End session", status_messages: { error: "This look couldn’t be loaded.", preserved: "Your picks are saved." }
  }),
  "live-styling-ended": c({
    eyebrow: null, headline: "Great session.", supporting_copy: "Take another look at everything you saved.", primary_cta: "See my picks", secondary_cta: "Style another look", tertiary_cta: "Go home", labels: { tried: "Looks tried", saved: "Saved to bag" }
  }),
  "live-styling-voice-interpreting": c({
    eyebrow: null, headline: "Got it—one second.", supporting_copy: null, primary_cta: "Cancel", labels: { heard: "You said", request: "Looking for" }, status_messages: { interpreting: "Finding new options…" }, metadata: { dynamic_tokens: ["voice_transcript"] }, accessibility: { live_region: "Looking for options based on your request." }
  }),
  "live-styling-voice-confirmation": c({
    eyebrow: null, headline: "How does this sound?", supporting_copy: "“{{interpreted_request}}”", primary_cta: "Yes, show me", secondary_cta: "Change it", tertiary_cta: "Cancel", labels: { transcript: "You said", interpretation: "We’ll show" }, metadata: { dynamic_tokens: ["voice_transcript", "interpreted_request"] }
  }),
  "live-styling-voice-acting": c({
    eyebrow: null, headline: "Coming right up.", supporting_copy: null, primary_cta: "Cancel", status_messages: { acting: "Finding your next look…" }, accessibility: { live_region: "Finding your next look." }
  }),
  "live-styling-voice-failure": c({
    eyebrow: null, headline: "Could you say that again?", supporting_copy: "Try a color, shape, brand, budget, or occasion.", primary_cta: "Try again", secondary_cta: "Use buttons", tertiary_cta: "Cancel", status_messages: { unrecognized: "We didn’t catch that.", no_match: "We couldn’t find a matching item." }, helper_text: { examples: "Try “blue,” “more fitted,” or “under $100.”" }
  }),
  "live-styling-gesture-observing": c({
    eyebrow: null, headline: "Hand controls are on.", supporting_copy: "Keep your hands in frame.", primary_cta: "Pause", secondary_cta: "Use buttons", labels: { camera: "Hands in frame", status: "Ready" }, status_messages: { observing: "Ready for your gesture…" }, accessibility: { live_region: "Hand controls are ready." }
  }),
  "live-styling-gesture-interpreting": c({
    eyebrow: null, headline: "Got it—one second.", supporting_copy: "{{gesture_action}}", primary_cta: "Cancel", labels: { gesture: "Your gesture", action: "Up next" }, metadata: { dynamic_tokens: ["gesture_name", "gesture_action"] }, status_messages: { interpreting: "Reading your gesture…" }
  }),
  "live-styling-gesture-accepted": c({
    eyebrow: null, headline: "Done.", supporting_copy: null, primary_cta: "Keep styling", secondary_cta: "Undo", tertiary_cta: "Use buttons", metadata: { dynamic_tokens: ["gesture_action"] }, status_messages: { accepted: "{{gesture_action}}" }, accessibility: { live_region: "{{gesture_action}} completed." }
  }),
  "live-styling-gesture-ignored-or-unavailable": c({
    eyebrow: null, headline: "Let’s try that again.", supporting_copy: "Keep your hands in frame and make one clear gesture.", primary_cta: "Try again", secondary_cta: "Use voice", tertiary_cta: "Use buttons", status_messages: { ignored: "No gesture detected.", unavailable: "Hand controls can’t see you clearly." }, helper_text: { safety: "Nothing changed." }
  }),
  "live-styling-gesture-confirmation": c({
    eyebrow: null, headline: "Do you want to {{gesture_action}}?", supporting_copy: null, primary_cta: "{{gesture_action}}", secondary_cta: "Cancel", labels: { recognized: "Your gesture", action: "Next action" }, helper_text: { safety: "We always confirm before adding items, opening a retailer, or ending your session." }, metadata: { dynamic_tokens: ["gesture_name", "gesture_action"] }
  }),
  "recommended-product-unavailable": c({
    eyebrow: null, headline: "This one sold out.", supporting_copy: "We found similar pieces that work for the same reason.", primary_cta: "See similar", secondary_cta: "Close", tertiary_cta: "Back to my picks", status_messages: { unavailable: "Sold out" }, helper_text: { freshness: "Availability can change." }
  }),
  "bag-item-unavailable": c({
    eyebrow: null, headline: "One of your picks sold out.", supporting_copy: "Your other picks are still here.", primary_cta: "Find something similar", secondary_cta: "Remove it", tertiary_cta: "Keep styling", labels: { unavailable: "Sold out", available: "Available", preserved: "Other picks saved" }, status_messages: { preserved: "Your other picks are saved." }
  })
};

function sectionCopyFor(section, exact) {
  const override = exact.section_overrides[section.name];
  if (override) return override;
  const lower = section.name.toLowerCase();
  if (lower.includes("navigation")) return { navigation: exact.navigation };
  if (lower.includes("action") || lower.includes("closing") || lower.includes("next step")) return { primary_cta: exact.primary_cta, secondary_cta: exact.secondary_cta, tertiary_cta: exact.tertiary_cta };
  if (lower.includes("consent") || lower.includes("privacy") || lower.includes("trust") || lower.includes("preservation") || lower.includes("support") || lower.includes("safety")) return { helper_text: exact.helper_text, consent: exact.consent, metadata: exact.metadata };
  if (lower.includes("status") || lower.includes("recovery") || lower.includes("state") || lower.includes("permission")) return { headline: exact.headline, supporting_copy: exact.supporting_copy, status_messages: exact.status_messages, validation: exact.validation };
  return { eyebrow: exact.eyebrow, headline: exact.headline, supporting_copy: exact.supporting_copy, labels: exact.labels, helper_text: exact.helper_text };
}

const wireframeByKey = new Map(wireframeManifest.screens.map((record) => [`${record.screen_id}/${record.state}`, record]));
const sectionsByKey = new Map(sectionPlan.screens.map((record) => [`${record.screen_id}/${record.state}`, record]));
const copyManifest = { schema_version: "1.0", project: screenPayload.project, voice_source: "company/voice.md", source_screens: "company/artifacts/prd/screens.json", source_wireframe_manifest: "company/artifacts/ui-ux-design/wireframe-manifest.json", status: "draft", generated_at: generatedAt, screens: [] };

for (const screen of screenPayload.screens) {
  const state = screen.required_states[0];
  const key = `${screen.screen_id}/${state}`;
  const wireframe = wireframeByKey.get(key);
  const planned = sectionsByKey.get(key);
  const draft = copyBySlug[screen.screen_slug];
  if (!wireframe || !planned || !draft) throw new Error(`Missing copy or UX source for ${screen.screen_slug}`);

  const exactCopy = {
    eyebrow: draft.eyebrow,
    headline: draft.headline,
    supporting_copy: draft.supporting_copy,
    primary_cta: draft.primary_cta,
    secondary_cta: draft.secondary_cta,
    tertiary_cta: draft.tertiary_cta,
    navigation: draft.navigation,
    labels: draft.labels,
    helper_text: draft.helper_text,
    validation: draft.validation,
    status_messages: draft.status_messages,
    consent: draft.consent,
    metadata: draft.metadata,
    accessibility: draft.accessibility,
    sections: planned.sections.map((section) => ({ section_id: section.section_id, section_name: section.name, copy: sectionCopyFor(section, draft) }))
  };

  const copyFile = path.join(outputScreens, `${screen.screen_slug}.md`);
  const proofNote = "No testimonial, customer count, rating, fit guarantee, retailer partnership, or measured outcome claim is used. Timing and capability language is limited to the approved product contract and identified as a design target where relevant.";
  const sectionMarkdown = exactCopy.sections.map((section) => `### ${section.section_id} — ${section.section_name}\n\n\`\`\`json\n${JSON.stringify(section.copy, null, 2)}\n\`\`\``).join("\n\n");
  const alternatives = draft.alternatives.length ? draft.alternatives.map((item) => `- **${item.label}:** ${item.value}`).join("\n") : "No alternate is recommended for this state; clarity and state fidelity take priority.";
  const markdown = `# ${screen.name}\n\nStatus: Draft  \nScreen ID: \`${screen.screen_id}\`  \nScreen slug: \`${screen.screen_slug}\`  \nState: \`${state}\`  \nAudience: ${screen.description}\n\n## Job and primary action\n\n- **User job:** ${screen.description}\n- **Primary action:** ${draft.primary_cta}\n\n## Recommended exact copy in wireframe order\n\n${sectionMarkdown}\n\n## Complete implementation object\n\n\`\`\`json\n${JSON.stringify(exactCopy, null, 2)}\n\`\`\`\n\n## Proof and claims\n\n${proofNote}\n\n## Alternatives\n\n${alternatives}\n\n## Voice notes\n\n${draft.voice_notes}\n\n## Layout constraints\n\n${draft.layout_constraints}\n\n## Approval and revision notes\n\n- 2026-07-19: Initial draft created from the approved PRD, UX package, company context, and draft voice system.\n- Founder approval: Pending.\n`;
  fs.writeFileSync(copyFile, markdown);

  copyManifest.screens.push({
    screen_id: screen.screen_id,
    screen_slug: screen.screen_slug,
    screen_name: screen.name,
    state,
    source_wireframe: { html: wireframe.assembled.html, desktop_png: wireframe.assembled.captures.desktop.png, mobile_png: wireframe.assembled.captures.mobile.png },
    copy_file: rel(copyFile),
    related_stories: screen.related_user_stories,
    related_scenarios: screen.related_scenarios,
    status: "draft",
    exact_copy: exactCopy,
    approved_at: null
  });

  screen.copy = { status: "ready-for-review", manifest_entry: `company/artifacts/copy/copy-manifest.json#${screen.screen_slug}/${state}` };
}

fs.writeFileSync(path.join(outputRoot, "copy-manifest.json"), `${JSON.stringify(copyManifest, null, 2)}\n`);
fs.writeFileSync(screensPath, `${JSON.stringify(screenPayload, null, 2)}\n`);

const expectedFiles = new Set(copyManifest.screens.map((record) => path.basename(record.copy_file)));
for (const entry of fs.readdirSync(outputScreens)) {
  if (entry.endsWith(".md") && !expectedFiles.has(entry)) fs.unlinkSync(path.join(outputScreens, entry));
}

console.log(`Generated draft copy for ${copyManifest.screens.length} screen/state records.`);
