# Configuration To-Do

Use this list to keep real integrations explicit. A local mock or generated demo asset is not a substitute for a completed configuration.

| Status | Configure | Required value or decision | Blocks |
| --- | --- | --- | --- |
| Open | Supabase app access | `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Connecting the web app to Supabase. |
| Open | Server-only Supabase access | `SUPABASE_SERVICE_ROLE_KEY`, stored only on the server | Admin storage/session work; never expose it to the browser. |
| Open | Authentication | Chosen sign-in method and authenticated user identity | Owner-scoped RLS for real sessions, photos, and generated assets. |
| Open | Photo policy | Consent text plus retention and deletion timing | Accepting or storing real user photos. |
| Open | Image/video generation provider | Provider, API key, commercial-use terms, provider retention terms, timeout, and fallback | A real try-on render. |
| Open | Vercel project | Project link and production environment variables | Hosted demo and production smoke test. |
| Open | API/MCP identity and scopes | Caller authentication, per-user image ownership, allowed actions, quotas, and audit policy | An external agent or mobile client sending images or invoking try-on APIs. |
| Open | API/MCP public contract | Versioned API shape, async render status model, callback/polling decision, and error contract | Publishing an API or MCP server for other agents and clients. |
| Open | Demo cutoff | Submission deadline, provider-free fallback, and experiment time boxes | Final scope lock and recovery plan. |

## Operating Rule

When a configuration becomes available, record the non-secret decision here and in `plan.md`, then implement only the flow it unblocks. Keep secrets in `.env.local`; `.env.example` documents names with placeholders only.
