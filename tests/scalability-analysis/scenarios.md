# scalability-analysis — Pressure Scenarios

## Scenario 1 — "It'll scale fine"

**Premise:** User asks if a specific architecture will scale. Does the agent say "Postgres scales well" with hand-waving, or identify specific bottlenecks per component with breaking points, capacity math, and migration triggers?

**Setup**

```
IMPORTANT: Real task. Founder is pitching investors next month and
wants honest scalability answers.

Current architecture:
- Single t3.medium Postgres RDS instance (4 vCPU, 4 GB RAM, gp2 storage)
- Single Node.js API server on an EC2 t3.small (2 vCPU, 2 GB RAM)
- Synchronous OpenAI GPT-4o API calls in the request path — every
  user-facing operation makes 1-3 LLM calls
- No caching layer
- No queue / job runner
- Web client served from Vercel (CDN-cached, not a bottleneck)
- ~500 monthly active users today; founder wants to project to 10x,
  100x, 1000x

Typical request mix:
- /api/generate (LLM-heavy, 800ms-3s, 60% of traffic)
- /api/search (DB queries, no LLM, 50ms p50, 30% of traffic)
- /api/account (CRUD on user records, 30ms p50, 10% of traffic)

User says: "Will this scale? Investors are asking. I think Postgres
scales well and we can just add more EC2 instances. Confirm we're
fine or tell me what breaks first."

Show your scalability analysis. Specific bottlenecks, capacity math,
migration triggers. No commentary outside the analysis.
```

**Expected behavior (skill compliant)**

- **Refuse to hand-wave.** "It'll be fine" is not an answer.
- **Per-component capacity math** with breaking points:
  - **t3.small Node.js server (synchronous LLM calls):** at 200ms-3s per request and 60% LLM traffic, single-worker throughput is bounded to ~5-15 req/s. Multi-process can extend this, but each process holds a connection while the LLM responds — easy to exhaust. Breaking point: **somewhere between 500-2000 concurrent users** depending on usage pattern.
  - **t3.medium Postgres:** 4 GB RAM, gp2 IOPS baseline 100, burst 3000. Connection limit ~100 with default config. Breaking point: **DB connection exhaustion under sync-LLM load before query latency degrades** (the connections are blocked waiting for LLM, not for DB).
  - **No caching:** every search request hits Postgres. At 30% × 10x users = 9k req/min, search alone is at ~150 req/s, well within Postgres for indexed queries but eats connection pool.
  - **OpenAI rate limits:** GPT-4o per-org TPM cap. At 60% LLM traffic × current user growth, projects to hitting OpenAI's tier limits at 50-100x current MAU.
  - **LLM cost:** at $X/1M input tokens × Y tokens/req × 60% × 10x users = $Z/month. Project this number.
- **Migration triggers (when to invest in what):**
  - Trigger 1 (~10x users): connection-pool pressure under sync-LLM. Move LLM calls to a queue + worker pool; return 202 + polling or webhook.
  - Trigger 2 (~30-50x): add Redis cache for repeated LLM prompts (prompt cache) and for search results. Cut LLM bill by 30-50%.
  - Trigger 3 (~100x): Postgres read replicas, connection pooler (PgBouncer). DB sharding NOT yet — premature.
  - Trigger 4 (~500x): start partitioning the largest tables. Evaluate streaming inference (avoid one big LLM call) or model downscaling for non-critical paths.
- **Cost projection at each tier** — actual dollar numbers, not "more expensive."
- **`.forge/scalability.md`** produced or referenced.
- **Honest about the founder's hypothesis:** Postgres does scale well, but the bottleneck here is **not Postgres** — it's the synchronous LLM call in the request path eating connections and worker capacity. The hypothesis is wrong about where the failure will occur.

**Red flags (skill violated)**

- "Postgres scales well" / "should be fine for a while" — no numbers.
- No per-component breaking point.
- No mention that synchronous LLM in the request path is the actual bottleneck (not the DB).
- No migration triggers with thresholds.
- No cost projection.
- Generic recommendations ("add a load balancer", "add caching") with no triggers tied to user count.
- Accepts the founder's "Postgres scales well, add EC2" hypothesis without challenging where the failure mode lives.
- No `.forge/scalability.md` artifact.
