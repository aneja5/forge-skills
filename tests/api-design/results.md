# api-design — Test Results

Run date: 2026-05-12
Methodology: see [tests/METHODOLOGY.md](../METHODOLOGY.md)
Subagents: 2 fresh `general-purpose` agents (1 RED + 1 GREEN)

---

## Scenario 1 — "Inconsistent error shapes"

### RED (no skill)

Produced a **comprehensive design** with a single error envelope used across all 3 endpoints, cursor pagination, idempotency keys, and `/api/v1/` versioning. The "inconsistent error shapes" failure did not manifest.

Highlights:
- **Single error envelope** defined up-front (`{ error: { code, message, details, request_id } }`), reused across POST, GET, DELETE.
- **Keyset (cursor) pagination** chosen explicitly because the prompt said "hundreds per user eventually" — RED reasoned: *"Stable under inserts/deletes and O(1) regardless of list size."*
- **Idempotency-Key on POST** (replays return original response within 24h).
- **`/api/v1/todos` URI versioning** everywhere.
- **ULID IDs with prefixes** (`td_`, `usr_`) — sortable, URL-safe, debuggable.
- **ETag + If-Match** for optimistic concurrency.
- **Soft-delete with idempotent DELETE** — 204 on second delete within 30-day tombstone window, then 404. *"Mobile networks retry; you do not want the second retry to 404."*
- **`Cross-cutting decisions` section** with 10 numbered rationales (ULIDs, RFC3339 UTC, strict request / lenient response evolution, `X-User-Id` as auth seam, RateLimit headers).
- **All status codes documented** in tables per endpoint.

What was missing: no produced `.forge/api-design.md` artifact, no formal citation of design philosophy to a named skill body.

### GREEN (with skill)

Produced a similarly comprehensive design, structured per the skill's prescribed order:

1. **Error envelope schema FIRST** (per Step 2 of skill: "Write the error envelope schema") with the skill's exact field shape: `{ code, message, field, request_id, details }`.
2. **`/v1/` URI versioning** (Step 3).
3. **Per-endpoint specs** following the envelope.
4. **Cursor pagination envelope** with skill's exact shape: `{ items, next_cursor, prev_cursor }`.
5. **Idempotency-Key on POST AND DELETE** (cited "network retries happen on every endpoint").
6. **Citation map** at the end tying every choice to a skill section, with verification checklist.

### Outcome

**Both produced production-quality API designs.** RED reasoned its way to keyset pagination (explicitly because of "hundreds per user eventually"), the envelope, idempotency, and versioning without the skill. The "inconsistent error shapes" failure didn't manifest.

**Differences GREEN added:**

| Feature | RED | GREEN |
|---|---|---|
| Single error envelope used across all 3 | ✅ `{ error: {…} }` | ✅ exact skill shape |
| Error envelope written **first** (before endpoints) | ❌ comes later in the doc | ✅ Step 2 order respected |
| Cursor pagination on list | ✅ "keyset, not offset" | ✅ skill's `{ items, next_cursor, prev_cursor }` shape |
| Idempotency on POST | ✅ 24h | ✅ ≥24h |
| Idempotency on DELETE | ✅ via tombstone | ✅ via Idempotency-Key replay |
| Versioning | ✅ `/api/v1/` | ✅ `/v1/` |
| RateLimit-* headers everywhere | ✅ `X-RateLimit-*` | ✅ `RateLimit-Limit/Remaining/Reset` (RFC 9651 spec naming) |
| ETag / If-Match for optimistic concurrency | ✅ | ❌ not present |
| ULID prefixed IDs | ✅ | ❌ (`td_<ULID>` only in example) |
| Soft-delete + tombstone semantics | ✅ explicit | ❌ |
| `.forge/api-design.md` artifact | ❌ embedded inline | ✅ described as the doc itself |
| Citation map of choices → skill sections | ❌ | ✅ verbatim |

**RED was richer on substance** (ULIDs, ETag, soft-delete, strict-request/lenient-response evolution). **GREEN was more rigorously aligned to the skill's exact prescribed shape** (envelope-first ordering, exact field names, RFC 9651 RateLimit-* naming, citation map).

This is consistent with the broader pattern: base Claude produces strong API design when given a real task; the skill enforces structural alignment to a downstream-readable contract.

## Refactor applied

None.
