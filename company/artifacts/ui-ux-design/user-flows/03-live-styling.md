# Flow 03 — Live Styling with Distance Controls

Related scenarios: SC-010, SC-011, SC-015

1. Customer chooses a report-linked product and starts live styling.
2. Magic Mirror explains camera use, visualization limits, environment guidance, and gesture use before requesting permission.
3. After camera access, the live session opens with a current product and direct controls.
4. Customer may enable voice; microphone permission is requested separately.
5. A voice request is displayed as interpreted text and confirmed when ambiguous before recommendations change.
6. Customer may open the hand-gesture guide, practice supported gestures, and enable recognition.
7. The session shows observed gesture, intended action, accepted/ignored/unavailable state, and confirmation for consequential actions.
8. At any point, customer can use direct controls instead of voice or gestures.

Recovery:

- Camera denial preserves report and product access and offers retry/device guidance.
- Microphone denial leaves direct and gesture controls available.
- Low-confidence voice or gesture interpretations do not act silently.
- Recognition loss is visible and never traps the customer away from controls.

Completion signal: a customer standing away from the device can browse looks and make a selection using voice or hands, with safe direct-control fallback.
