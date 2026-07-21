# Implementation Standards

## Scope and Simplicity

- Implement only the selected ticket's target, scope, acceptance criteria, and pass conditions.
- Prefer the smallest complete vertical behavior.
- Do not add speculative layers, broad refactors, alternate frameworks, or unrelated cleanup.
- Keep data flow direct and visible.

## DRY Without Premature Abstraction

- Search the codebase before creating a component, helper, schema, hook, or utility.
- Reuse the shared implementation when it already represents the same behavior.
- Do not copy business rules, validation schemas, accessibility behavior, or design tokens into multiple places.
- Extract a shared abstraction after two real call sites demonstrate the same stable responsibility, or when an approved external boundary requires one typed adapter.
- A shared component must have a clear purpose and tests; do not build generic factories for imagined future use.

## Type and Boundary Safety

- Use strict TypeScript.
- Parse form input, API requests/responses, database reads, provider results, and generated-model output through the approved Zod schema.
- Do not cast untrusted data into trusted types.
- Preserve normalized error contracts and request IDs.

## Errors and Incomplete Work

- Every user-awaited operation has explicit loading, slow, failed, retry, and success behavior where the contract requires it.
- Surface actionable errors to the customer and safe diagnostic context to developers.
- Do not swallow errors, return fake success, or leave TODO/dummy behavior in a passing ticket.
- Missing secrets or provider access produce a real blocker or failure state.

## Dependencies

Use the platform and existing dependencies first. Every new dependency needs a one-line record covering:

- Purpose.
- Why the platform/existing stack is insufficient.
- Bundle/runtime size and maintenance impact.

Update the correct manifest and Bun lockfile in the same ticket. Do not add competing libraries for an existing responsibility.

## Security and Sensitive Data

- Derive ownership from authenticated identity, never from untrusted request data.
- Never log raw photos, media bytes, access tokens, signed URLs, prompts containing customer data, or provider bodies.
- Store binaries only in approved private storage.
- Preserve RLS, retention, consent, timeout, and deletion contracts.

## Comments and Documentation

Explain non-obvious constraints and external boundaries, not the syntax. Update the smallest relevant README or contract only when the ticket changes how contributors must work.
