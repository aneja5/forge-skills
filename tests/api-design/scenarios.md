# api-design — Pressure Scenarios

## Scenario 1 — "Inconsistent error shapes"

**Premise:** User asks for 3 REST endpoints. Does the agent define a single error envelope schema and apply it across all 3, or invent a different error shape per endpoint (some `{error: "msg"}`, others `{message: "msg", code: 400}`, others a raw string)?

**Setup**

```
IMPORTANT: Real task. Ship by end of week.

User says: "Design 3 REST endpoints for a todo app:

  - POST /todos — create a new todo
  - GET /todos — list todos (we'll have hundreds per user eventually)
  - DELETE /todos/:id — delete one

Cover: request shape, response shape, status codes, error responses,
and any headers I should think about. We'll add auth later — assume
the user is already identified."

Show the full design — all 3 endpoints, all status codes, all error
cases. Be specific. No commentary outside the design.
```

**Expected behavior (skill compliant)**

- **One error envelope** defined up-front (or referenced from `.forge/api-design.md`) and used across all 3 endpoints. Stable shape: `{ error: { code, message, field?, request_id, details? } }` or equivalent.
- **No `200 OK` with an error body** anywhere.
- **Cursor-based pagination on the list endpoint** (not OFFSET) — the user explicitly said "hundreds per user."
- **Idempotency support on POST /todos** — `Idempotency-Key` header or equivalent.
- **Versioning** — `/v1/` prefix or version header on all 3 endpoints (no unversioned).
- Status codes follow REST conventions: 201 on create, 200 on list, 204 on delete success.
- 404 on delete-nonexistent, 409 or similar on idempotency conflict, 429 on rate-limit, 4xx on validation.

**Red flags (skill violated)**

- Different error shapes per endpoint (`{error: "..."}` here, `{message: "..."}` there, a raw string elsewhere).
- `200 OK` with `{ success: false }` or `{ error: "..." }` in the body.
- `OFFSET`/`LIMIT` pagination on a list "with hundreds per user."
- No idempotency consideration on POST.
- No version prefix or header anywhere.
- `PATCH` semantics conflated with `PUT`.
- Errors as bare strings: `res.status(400).send("Invalid")`.
- No `.forge/api-design.md` reference or production of an envelope schema before the endpoints.
