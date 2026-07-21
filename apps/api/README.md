# Magic Mirror API

The API is a native Bun HTTP server. It requires `APP_BASE_URL` and
`CORS_ALLOWED_ORIGINS` at startup, with `HOST` and `PORT` available as optional
runtime overrides.

`GET /health` returns:

```json
{"service":"magic-mirror-api","status":"ok"}
```

Every response includes an `X-Request-Id` header.

Dependency justification: `zod` validates untrusted environment and request
boundaries at runtime; TypeScript types cannot do that, and the package is a
small, actively maintained dependency already required by the architecture.

Dependency justification: `@supabase/supabase-js` verifies customer access
tokens against Supabase Auth without handling signing secrets in application
code; the pinned package is about 667 KB unpacked before its maintained
Supabase client modules, an accepted API-runtime cost for this single boundary. The
existing `@magic-mirror/contracts` workspace package supplies the shared strict
error envelope without adding an external runtime dependency.
