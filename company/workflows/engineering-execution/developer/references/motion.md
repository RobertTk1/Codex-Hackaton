# Motion and Micro-Interactions

## Required Skill

Every UI ticket must perform a motion review. When motion is warranted, invoke an approved micro-interactions skill before implementation.

Verified installable candidate, currently not installed:

- `dylantarre/animation-principles@micro-interactions`
- Install command: `npx skills add https://github.com/dylantarre/animation-principles --skill micro-interactions -g -y`
- Reference: [skills.sh](https://skills.sh/dylantarre/animation-principles/micro-interactions)

Until the skill is installed and visible in the runtime catalog, no ticket may claim the skill ran. The written contract in this file remains sufficient for a documented motion review; record `skill-not-installed` and implement only the motion justified by the approved interaction specification.

## When Motion Makes Sense

Use motion to improve:

- Immediate control feedback.
- State changes and confirmation.
- Spatial continuity between related views.
- Progressive disclosure.
- Loading/progress comprehension.
- Focus or hierarchy when a new element appears.

Do not animate merely to make a page feel busy, trendy, or “premium.” Avoid gratuitous scroll choreography, continuous motion, delayed access to content, and animations that compete with primary tasks.

## Implementation Rules

- Prefer CSS/Tailwind transitions for simple hover, focus, press, opacity, and transform feedback.
- Add a motion library only when coordinated presence/layout animation cannot be implemented clearly with the current stack; document the dependency justification.
- Keep durations and easing consistent through shared motion tokens.
- Animate transform and opacity when practical; avoid layout-thrashing properties.
- Never make motion the only carrier of meaning.
- Honor `prefers-reduced-motion` with an equivalent immediate state change.
- Preserve focus, pointer, and keyboard behavior throughout transitions.

## Ticket Evidence

Record:

- Motion review result: `not-needed`, `implemented`, or `blocked`.
- Skill used when implemented.
- Purpose of each motion behavior.
- Reduced-motion behavior.
- Browser evidence that the transition does not introduce console errors, jank, blocked interaction, or layout instability.
