# Chat Onboarding — Text Question Interaction Specification

Screen ID: `6d5f5ef1-a4a2-41d3-aa89-dc3722ae8df0`

This representative state shows an age question after name and styling-goal turns. The full dialogue asks name, desired styling help, adult confirmation, gender, age, height, and optional weight as separate turns. Before gender, explain that it is used only to shape styling and shopping recommendations; accept an inclusive option or self-description. Natural answers such as `28`, `non-binary`, `five foot seven`, `170 cm`, `skip`, or `I’m mostly looking for work outfits` are parsed and confirmed only when needed. Invalid or ambiguous answers trigger one narrow reprompt. `Prefer not to answer` is available only for optional weight, not age/adult confirmation/gender/height.

Shared behavior: `shared-contract.md`.
