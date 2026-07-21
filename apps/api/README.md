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
