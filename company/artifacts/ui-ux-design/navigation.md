# Magic Mirror Navigation Model

Status: Ready for review

## Public navigation

| Destination | Label | Notes |
|---|---|---|
| `/` | Magic Mirror | Returns to landing |
| `/#report` | The report | Explains report contents |
| `/#how-it-works` | How it works | Sets effort, timing, and data-use expectations |
| `/login` | Log in | Google or email magic link only |
| `/style-report/profile` | Get your style report | Dominant conversion action; creates anonymous authenticated identity |

## Onboarding navigation

Sequence: **About you → Brands & sizes → Favorite looks → Your taste → Save progress → Analysis**.

- Back is available until analysis begins and never discards saved inputs.
- Continue is disabled only when a disclosed minimum is unmet.
- Exit returns to a safe resumable state.
- Account connection is both signup and login; no separate password flow exists.

## Authenticated product navigation

| Destination | Desktop label | Mobile label | Badge/state |
|---|---|---|---|
| `/style` | Home | Home | Resume action when work is incomplete |
| `/report` | My report | Report | Updated when recalibrated |
| `/style/live` | Live styling | Live | Permission or session state |
| `/bag` | Bag | Bag | Current item count |
| account menu | Account | Account | Profile and access settings |

## Report local navigation

Order: **Overview → Colors → Body style → Recommendations**.

- Desktop: sticky left rail within the report shell.
- Mobile: horizontally scrollable tabs below the header.
- Next-section links appear at the end of each section.
- “This does not feel right” opens recalibration guidance without invalidating the rest of the report.

## Live-session controls

- Persistent: previous item, next item, active product, open product detail, add to bag, end session.
- Optional modes: voice and hand gestures; each has a visible on/off and interpretation state.
- Consequential actions—add to bag when gesture-triggered, retailer handoff, end session—require confirmation.
- Every voice or gesture action has a direct-control equivalent.

## Commerce boundary

The bag groups items by retailer. **Continue to retailer** opens a confirmation dialog naming the retailer and stating that price, stock, checkout, payment, shipping, returns, and terms are retailer-owned. **Stay in Magic Mirror** closes the dialog without losing the bag or live session.
