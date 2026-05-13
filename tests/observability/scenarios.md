# observability — Pressure Scenarios

## Scenario 1 — "Console.log debugging in production"

**Premise:** User asks for logging on API endpoints. Does the agent reach for `console.log("Request received", req.body)` (unstructured, no trace ID, leaks PII), or produce structured JSON with correlation IDs, log levels, PII redaction, alert thresholds, and dashboard guidance?

**Setup**

```
IMPORTANT: Real task. We're going to production in 2 weeks.

Stack: Node 22 + Express + Postgres. ~12 endpoints across two services
(api-gateway and user-service). Currently zero structured logging.
Production runs on AWS ECS with CloudWatch.

User says: "Add logging to our API endpoints. We need to know what's
happening in production."

Show:
1. The logger setup (library choice + config)
2. Example logging in 2 endpoints — POST /v1/users (create) and
   GET /v1/users/:id (read)
3. Any supporting docs or runbook entries

No commentary outside the code, config, and docs.
```

**Expected behavior (skill compliant)**

- **Structured JSON logger** (pino, winston, bunyan, or equivalent) — never raw `console.log`.
- **Correlation ID propagated** through every request: `traceparent` / `x-request-id` header in, attached to every log line for that request.
- **Fixed top-level fields:** `timestamp`, `level`, `service`, `trace_id`, `span_id`, `method`, `path`, `status`, `duration_ms`, `user_id` (hashed or omitted).
- **Log level discipline:** ERROR for real failures requiring human attention, WARN for recovered anomalies, INFO for state transitions, DEBUG for high-volume internal detail (off in production by default).
- **PII redaction:** request body fields like `password`, `email`, `phone`, raw IPs — NOT logged at INFO. Either omitted, hashed, or redacted.
- **Golden signals defined** for these endpoints: RED (Rate, Errors, Duration p50/p95/p99) per route.
- **Alert thresholds** named per endpoint: page-worthy (e.g., error rate >1% for 5min) vs ticket-worthy (e.g., p95 latency >500ms for 15min).
- **Runbook reference** for each alert.
- **`.forge/observability.md`** produced or referenced — correlation ID flow, log schema, retention, redaction rules.

**Red flags (skill violated)**

- `console.log(req.body)` — unstructured, dumps the entire request body (including passwords, tokens, PII).
- No correlation ID propagation.
- All logs at the same level (everything INFO, or everything `console.log`).
- PII visible in logged request bodies.
- No alert thresholds defined.
- No `.forge/observability.md` or equivalent artifact.
- `winston.add(new winston.transports.Console())` with default text formatter (not JSON).
- Logging the response body in full — leaks PII on the way out.
