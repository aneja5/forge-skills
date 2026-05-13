# code-review-and-quality — Test Results

Run date: 2026-05-12
Methodology: see [tests/METHODOLOGY.md](../METHODOLOGY.md)
Subagents: 2 fresh `general-purpose` agents (1 RED + 1 GREEN)

---

## Scenario 1 — "LGTM review"

### RED (no skill)

Produced a thorough review titled *"PR Review: feat: add order summary endpoint for dashboard"* with three sections: **Summary**, **Blocking issues**, **Non-blocking but please fix before merge**, **Suggested shape**, **Verdict: Request changes.**

Caught all the seeded defects plus more:
- Contract bypass (handler reaches around `getOrderSummary` and reimplements aggregation in the controller)
- Invariant 1 violation (ownership isolation not enforced — no actor object constructed)
- Invariant 2 violation (90-day cap not enforced)
- No input validation on `from` / `to`
- N+1 query (correctly identified as N×M — 100 orders × 5 items ≈ 601 round trips)
- Error contract wrong (RateLimitError + ValidationError unhandled; try/catch in wrong place — wraps only the response serialization, not the awaits)
- Missing `ProductService` import (will fail at module load)
- `req.user` not type-narrowed
- `productRevenue` keyed by `product.name` (merges revenue across same-name products)
- Money stored as `number` (float drift)
- No tests
- No observability

**Verdict line:** *"Request changes."*

Verbatim excerpt:

> *"This handler does not implement the contract advertised in OrderService.md. The endpoint is supposed to expose `getOrderSummary(actor, query)` returning `OrderSummary | NotFoundError | RateLimitError | ValidationError`, but the handler reaches around the service, reimplements aggregation in the controller, and silently drops three of the four contract error modes. ... per the skill's anti-rationalization guidance, contracts exist precisely to prevent that framing."*

The "LGTM with style suggestions only" failure pattern **did not manifest.** RED produced a 13-finding structured review with a Request Changes verdict.

### GREEN (with skill)

Produced a five-axis review with the skill's exact finding format (`[CRITICAL]` / `[IMPORTANT]` / `[SUGGESTION]` + `File: src/path:line`):

- **Axis 1 — Contract Compliance:** 4 CRITICAL findings (RateLimitError unhandled, ValidationError unhandled, Invariant 2 unenforced, Invariant 1 enforced only by trust in `req.user.id`) + 1 IMPORTANT (NotFoundError semantics inverted — empty-list is not the same as NotFound).
- **Axis 2 — Correctness:** 1 CRITICAL (try/catch placed after the awaits — guards nothing), 1 IMPORTANT (product may be undefined), 1 IMPORTANT (float accumulation for revenue).
- **Axis 3 — Readability:** 3 SUGGESTIONs.
- **Axis 4 — Security:** 2 CRITICALs (input validation, auth guard), 1 IMPORTANT (generic 500 leak risk).
- **Axis 5 — Performance:** 1 CRITICAL (N+1 with concrete N×M math), 1 IMPORTANT (unbounded result set), 1 SUGGESTION.

**Each finding cited the skill section and red flag that drove it.** Final decision: **BLOCK** (stronger than RED's "Request changes"), with a numbered list of what unblocks a re-review.

Verbatim excerpt:

> *"[CRITICAL] Contract violation: RateLimitError is not handled. File: src/orders/handler.ts:4 ... Driven by: Axis 1 — 'Every error type in contract is handled'; Red Flag — 'Implementation ignores an error type defined in the contract'."*
> *"[CRITICAL] Unhandled rejections in the loop bypass the try/catch. File: src/orders/handler.ts:6-12. The try block starts at line 13, after every await in the loop. Any rejection from getItems or ProductService.getById propagates as an unhandled promise rejection."*

### Outcome

**Both reviews caught the substantive defects.** The "LGTM minor suggestions" failure didn't manifest in RED. Base Claude is strong on code review when given a real contract and concrete defects.

**Differences GREEN added:**

| Feature | RED | GREEN |
|---|---|---|
| Caught contract bypass | ✅ | ✅ |
| Caught N+1 | ✅ (correctly identified as N×M) | ✅ |
| Caught try/catch placement bug | ⚠️ noted but not as severe | ✅ explicit CRITICAL — try/catch guards nothing |
| Caught missing import | ✅ | ❌ not flagged |
| Caught key-by-name bug | ✅ | ❌ not flagged |
| Five-axis structure with axis labels | ❌ (Blocking / Non-blocking) | ✅ (Axis 1–5) |
| Severity labels `[CRITICAL]` `[IMPORTANT]` `[SUGGESTION]` | ❌ (Blocking vs non-blocking) | ✅ matches skill format |
| `File:line` citations on every finding | ⚠️ filename only on some | ✅ on every finding |
| Cites skill section/red flag per finding | n/a | ✅ verbatim |
| Final decision keyword | "Request changes" | "BLOCK" |
| Numbered unblock-criteria list | ❌ | ✅ |

**The skill's value is structural and citational.** RED's review is substantively equivalent (caught two issues GREEN missed: missing import and the name-collision bug). GREEN's review is more legible to downstream readers because every finding is severity-labeled and tied to a named axis + red flag.

**Interesting finding:** RED caught two defects GREEN missed (the unimported `ProductService`, and the `product.name` collision). This is the first scenario where RED beat GREEN on substance. Likely because RED's open-ended review structure encouraged more lateral reading, while GREEN's five-axis structure made the agent check each axis exhaustively but not range as far for surprises.

**Skill fix considered:** could add a sixth axis or a meta-check ("Did you look for anything that doesn't fit the axes — missing imports, name collisions, dead code, etc.?"). Logged but not applied — RED's lateral catches are valuable but adding a "miscellaneous" axis would dilute the discipline of the five.

## Refactor applied

None.
