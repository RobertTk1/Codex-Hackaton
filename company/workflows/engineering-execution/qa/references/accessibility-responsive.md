# Accessibility, Responsive, and Device QA

## Standard

Target applicable WCAG 2.2 Level AA criteria for the complete customer processes. This is a product QA target, not a claim of formal third-party certification.

Automated scanning is useful but insufficient. W3C notes that no tool alone can determine accessibility conformance, so pair automated checks with manual Browser evaluation.

## Manual Checks for Applicable Cases

- Complete the journey using keyboard only; verify logical focus order, visible focus, no trap, and operable dialogs/menus.
- Confirm controls expose correct names, roles, values, labels, instructions, and state changes.
- Confirm validation and operational errors are described in text, associated with the affected control or operation, and announced when appropriate.
- Confirm loading, progress, success, warning, chat, and error status messages are programmatically perceivable without stealing focus unnecessarily.
- Check contrast, non-color cues, text resize, zoom/reflow, orientation, target size, and content on hover/focus.
- Confirm pointer gestures and drag/swipe interactions have an accessible non-gesture alternative.
- Confirm motion respects reduced-motion preferences and is not required to understand or complete a task.
- Confirm image alternatives match purpose and decorative images are ignored appropriately.
- Check accessible authentication and timeout/re-authentication behavior when applicable.

## Responsive and Device Matrix

Use the target matrix from the engineering plan. At minimum, test representative mobile and desktop widths plus intermediate reflow for mandatory journeys. Verify:

- No clipped content, hidden required controls, horizontal page overflow, or overlapping layers.
- Touch targets and gesture controls remain usable at distance-appropriate sizes.
- Camera, microphone, upload, and permission-denied behavior on supported target devices.
- Virtual keyboard, safe-area, rotation/orientation, and viewport changes where applicable.
- Reduced bandwidth/slow response states for media-heavy and real-time experiences.

## Performance Evidence

Use requirement-specific budgets first. Where the plan adopts Core Web Vitals, record LCP, INP, and CLS against the approved environment and thresholds. Local synthetic results are diagnostic and must not be presented as production field performance.
