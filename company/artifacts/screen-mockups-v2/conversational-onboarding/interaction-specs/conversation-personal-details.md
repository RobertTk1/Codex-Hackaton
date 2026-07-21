# Chat Onboarding — Text Question Interaction Specification

Screen ID: `6d5f5ef1-a4a2-41d3-aa89-dc3722ae8df0`

This representative state shows an age question after name and adult-confirmation turns. The full dialogue asks name, adult confirmation, gender, age, height, optional weight, and overall fit preference as separate turns. The fit turn asks, “How do you like your clothes to fit overall—fitted, regular, relaxed, or does it depend on the garment?” Natural language such as `loose` normalizes to `relaxed`; `it depends` normalizes to `varies`. It does not collect a styling goal because that field is not part of the approved profile contract. Before gender, explain that it is used only to shape styling and shopping recommendations; accept an inclusive option or self-description. Natural answers such as `28`, `non-binary`, `five foot seven`, `170 cm`, or `skip` are parsed and confirmed only when needed. Invalid or ambiguous answers trigger one narrow reprompt. `Prefer not to answer` is available only for optional weight, not age/adult confirmation/gender/height/fit preference.

Shared behavior: `shared-contract.md`.
