# error-handling-and-resilience — Test Results

Run date: 2026-05-12
Methodology: see [tests/METHODOLOGY.md](../METHODOLOGY.md)
Subagents: 2 fresh `general-purpose` agents (1 RED + 1 GREEN)

---

## Scenario 1 — "Just catch and log"

### RED (no skill)

Produced a strong revision:

- **Per-service timeouts via `AbortController`** (users 800ms, orders 1200ms, reco 600ms) — correctly tuned tighter for the non-critical reco-api.
- **Bounded retries** (2 attempts) with jittered exponential backoff. No infinite loops.
- **4xx vs 5xx distinction** — `retryable = res.status >= 500 || res.status === 429`. 4xx (except 429) does not retry.
- **Criticality tiering** — `users-api` and `orders-api` failures throw `DashboardUnavailableError`; `reco-api` failure degrades to a `degraded.recommendations = true` flag and renders the page without recommendations.
- **Structured error type** (`DashboardUnavailableError` with `cause.service`).
- **Parallel fan-out** via `Promise.allSettled` — correctly noticed that the original sequential awaits added latency unnecessarily.
- **Differentiated user-facing messages by failing service** in a React component.
- **Produced a runbook document** (`docs/runbooks/dashboard-load.md`) covering timeouts, alerts (`dashboard.error.rate > 1%` page-worthy, `dashboard.reco.degraded.rate > 5%` ticket-worthy), triage steps, trade-offs, and rollback.

**What's missing (compared to skill verification):**
- No `.forge/error-handling.md` produced.
- No formal three-class taxonomy (`transient` / `permanent` / `user-correctable`) — RED has an informal `retryable` boolean.
- No circuit breaker policy.
- No idempotency key propagation.
- No input validation as a separate user-correctable class.
- No `deadline` (only `maxAttempts`) — long retries could exceed user-visible budget if base delay is set wrong.
- No formal user-facing message catalog with stable codes.

### GREEN (with skill)

Produced the full skill-prescribed solution:

- **Explicit `ErrorClass` type** with three values matching the skill's taxonomy.
- **Named error classes** (`TransientUpstreamError`, `PermanentUpstreamError`, `UserCorrectableError`) with stable codes (`UPSTREAM_TRANSIENT_<DEP>`, `INVALID_INPUT`, etc.).
- **`fetchJsonWithPolicy`** central helper enforcing timeout + maxAttempts + baseDelay + **deadline** + idempotency key on every external call.
- **Input validation** as a `UserCorrectableError` (skill Step 2 user-correctable class).
- **Criticality tiering** — same as RED but expressed via the typed error classes.
- **`.forge/error-handling.md`** written as a full structured artifact: failure-mode inventory table, classification table, handling policy table (with SLO, criticality, timeout, max attempts, base delay, deadline, on-exhaustion behavior per dependency), **circuit breaker thresholds per dependency**, named error types section, user-facing message catalog with stable codes, logging+alerting table per error class, idempotency + compensation section.
- **Cited skill sections explicitly** — Step 1 (Inventory), Step 2 (Classify), Step 3 (Pattern per class), Step 4 (Taxonomy), Step 5 (Logging+alerting), Step 6 (Idempotency).

### Outcome

**RED is strong baseline.** Base Claude already handles timeouts, retries, criticality tiering, parallel fan-out, and differentiated user messages without the skill. The skill's value is **artifact production and taxonomy formalization**, not "teach the agent to add error handling."

**Differences GREEN added on top of RED:**

| Feature | RED | GREEN |
|---|---|---|
| `.forge/error-handling.md` artifact | ❌ | ✅ |
| Three-class taxonomy (transient/permanent/user-correctable) | Implicit boolean | Explicit enum |
| Circuit breaker policy | ❌ | ✅ per-dep thresholds |
| Idempotency key propagation | ❌ | ✅ on every fetch |
| Input validation as user-correctable class | ❌ | ✅ |
| Deadline (in addition to maxAttempts) | ❌ | ✅ |
| User-facing message **catalog** with stable codes | Inline JSX strings | ✅ table with codes + HTTP status |
| Skill section citations | n/a | ✅ |

**Skill demonstrates value** — the structured `.forge/error-handling.md` is what downstream skills (`observability`, `incident-response-and-postmortems`) need to consume. RED's runbook is good but lives in a different location and isn't structured for cross-skill handoff.

No skill change required. Scenario validates the skill's intent: shape unstructured pressure ("ship it tomorrow") into the prescribed artifact while preserving the technical quality base Claude already delivers.

## Refactor applied

None. The skill works as written.
