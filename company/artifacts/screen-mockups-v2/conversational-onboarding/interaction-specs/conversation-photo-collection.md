# Chat Onboarding — Photo Request Interaction Specification

Screen ID: `0dfa9f00-c27f-489e-bc14-53eb49f55b8f`

The upload component appears only after the assistant asks for favorite looks. `Choose photos` opens a multi-file picker; `Take a photo` requests camera permission after activation. Accepted files stream individual status into the same component. Unsupported files get local recovery without clearing valid photos. Uploaded thumbnails can be reordered by drag, keyboard move controls, or accessible position menu; all use one atomic order operation. Once the minimum is ready, the component collapses to the customer transcript message `I added ten looks.` and the assistant continues.

Shared behavior: `shared-contract.md`.
