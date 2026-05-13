# observability — Test Results

Run date: 2026-05-12
Methodology: see [tests/METHODOLOGY.md](../METHODOLOGY.md)
Subagents: 2 fresh `general-purpose` agents (1 RED + 1 GREEN)

---

## Scenario 1 — "Console.log debugging in production"

### RED (no skill)

Produced a comprehensive structured-logging setup. The "console.log" failure did not manifest.

Highlights:
- **`pino` + `pino-http`** chosen for structured JSON output (ECS/CloudWatch friendly).
- **Redaction paths** declared up-front in logger config: `authorization`, `cookie`, `x-api-key`, `password`, `token`, `creditCard`, `ssn`, `set-cookie`, plus wildcard `*.password` / `*.token` / `*.apiKey`.
- **`x-request-id` correlation:** middleware reads incoming header or generates a UUID; sets it on the response; injected into every log line via `pino-http`'s `genReqId`.
- **Log-level discipline:** automatic mapping from `pino-http` — 5xx → error, 4xx → warn, 2xx/3xx → info; manual `req.log.debug` for fetch attempts.
- **Per-handler `req.log.child({handler: 'createUser'})`** so every line in a handler is grouped.
- **`event` field** namespaced: `user.create.attempt`, `user.create.success`, `user.create.conflict`, `user.create.failure`, etc.
- **`durationMs`** computed and emitted on every operation.
- **Process-level handlers** for `unhandledRejection` and `uncaughtException` at FATAL level.
- **`docs/logging.md`** with log shape, required fields, levels, redaction rules, correlation rules, env vars, ECS task definition snippet (including `mode: non-blocking` for backpressure safety).
- **`docs/runbook-logging.md`** with CloudWatch Insights queries for common investigations (errors, request tracing, slow requests, auth failures), alert table (5xx rate >1% page-worthy, fatal count, p99 latency, log volume drop).

The skill's golden test for this scenario — *"`console.log(req.body)` — unstructured, dumps the entire request body including passwords, tokens, PII"* — was never reached.

### GREEN (with skill)

Per the agent's summary, produced an equivalent setup with the skill sections cited explicitly. Notable structural additions:

- **CLS-stored `trace_id`** injected into log lines plus an **axios interceptor on outbound calls** to propagate `traceparent` to downstream services.
- **`hashUserId()`** function (sha256+salt, 16 chars) — explicit PII hashing strategy versus RED's "userId only if authenticated, otherwise omitted."
- **`has_email` / `has_name` boolean fields** in logs instead of raw values — explicit reduction of PII surface.
- **`eslint no-console: error`** enforced in CI — prevents regression to `console.log`.
- **Game-day on Day 12** to test alerts before production traffic.
- **Citation map** at the end tying every choice to a skill section (Step 1 correlation, Step 2 RED, Step 3 SLOs, Step 4 levels, Red Flags, Rationalizations).
- **Integration test** asserts `trace_id` reaches user-service logs (cross-service correlation verified).

The agent claimed to write `.forge/observability.md`. Verified after run: no `.forge/` directory in our worktree; subagent's filesystem actions were sandboxed.

### Outcome

**Both produced production-grade observability setups.** The "console.log debugging" failure pattern didn't manifest in RED — base Claude reaches for `pino` / `winston` and structured logging with redaction when asked for production logging.

**Differences GREEN added:**

| Feature | RED | GREEN |
|---|---|---|
| Structured JSON logger | ✅ `pino` | ✅ `pino` |
| `x-request-id` / `traceparent` correlation | ✅ inbound + response header | ✅ + CLS storage + outbound propagation via axios interceptor |
| Redaction paths declared | ✅ extensive list | ✅ same + `hashUserId` + boolean PII flags (`has_email`) |
| Log levels mapped to status codes | ✅ via `customLogLevel` | ✅ same |
| `event` field namespaced (`domain.action.outcome`) | ✅ | ✅ |
| `durationMs` on every operation | ✅ | ✅ |
| Per-handler child logger with context | ✅ | ✅ |
| Runbook for common investigations | ✅ comprehensive | ✅ |
| Alert thresholds defined | ✅ table | ✅ table |
| Linter rule against `console.log` | ❌ | ✅ `eslint no-console: error` |
| Integration test asserts cross-service trace propagation | ❌ | ✅ |
| Game-day before production traffic | ❌ | ✅ |
| `.forge/observability.md` artifact | ❌ uses `docs/logging.md` | ✅ named path |
| Citation map | ❌ | ✅ verbatim per row |

**Both are strong.** GREEN added enforcement (linter), verification (integration test), and operational practice (game-day). RED's `docs/runbook-logging.md` with concrete CloudWatch Insights queries is arguably more operationally useful for an on-call than GREEN's abstract alert table.

## Refactor applied

None.
