---
description: Design REST endpoints with consistent error envelopes, versioning, pagination, and idempotency
---

Invoke the forge-skills:api-design skill.

Define base conventions — verbs, status codes (no 200 OK with error body), resource naming, wire format.
Write the error envelope schema (code, message, field, request_id, details).
Set versioning + deprecation policy (URI / header / query), minimum 6-month public deprecation window.
Define pagination (cursor preferred), filtering, sorting conventions.
Specify idempotency for mutations (Idempotency-Key header, server replay for 24h+).
Document rate-limiting headers and auth envelope. Mark every endpoint public or internal.

After writing: "API design written to .forge/api-design.md. Use as the contract for /architect module work."
