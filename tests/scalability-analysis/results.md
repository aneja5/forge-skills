# scalability-analysis — Test Results

Run date: 2026-05-12
Methodology: see [tests/METHODOLOGY.md](../METHODOLOGY.md)
Subagents: 2 fresh `general-purpose` agents (1 RED + 1 GREEN)

---

## Scenario 1 — "It'll scale fine"

### RED (no skill)

**Refused the hand-wave.** Lead with:

> *"You are not fine. Your architecture survives 10x with duct tape, breaks structurally between 10x and 100x, and the system you have today cannot reach 1000x without being substantially rebuilt. The first thing to break is not Postgres or EC2 — it is the synchronous OpenAI call in the request path."*

**Baseline math** before projecting:
- 500 MAU × 20% DAU/MAU × 2 sessions × 15 req × 6x peak-to-average → **~0.2 peak RPS today**.
- Projected at 10x/100x/1000x: 2 / 20 / 200 peak RPS.
- Projected at 1-3 LLM calls per request × 60% LLM traffic: 0.12 / 1.2 / 12 / 120 LLM calls/sec.

**Per-component breaking points:**
1. **Sync LLM in request path:** OpenAI tier RPM/TPM caps; default tier breaks at ~30-50x; tier 5 needed for 100x; LLM cost is 78% of bill at 100x and 85% at 1000x.
2. **Single Node.js EC2:** stateless and horizontal-scales cleanly *once LLM is async*. Until then, t3.small saturates at ~5-10 RPS because each LLM call holds a slot for ~2s. HA requires 2 instances regardless of capacity.
3. **Postgres t3.medium:** working set > RAM at ~50K MAU. Connection limit (~100) exhausts before CPU. PgBouncer cost: $15/mo. Read replicas needed at 100x.
4. **No Redis (the absence is the bug):** session/auth cache, rate limit, queue, semantic LLM cache, idempotency keys, cross-instance state. ElastiCache t4g.small ~$15/mo. Skipping it = unbounded LLM spend from a single abusive user.
5. **OpenAI cost:** $1.3K → $13K → $135K → **$1.35M/month** at 1x/10x/100x/1000x.

**Migration sequence** ordered by trigger, not by glamour. **Investor-facing paragraph** at the end with the exact framing to send: *"At our current 500 MAU, the architecture is intentionally minimal... we have a clear-eyed view of what breaks first... the riskiest thing in the plan is not Postgres or EC2; it's the LLM-cost curve."*

### GREEN (with skill)

Per-component math with breaking points ranked by failure order:

| # | Component | Breaks at | Symptom |
|---|---|---|---|
| 1 | Node.js event loop under sync LLM | **5K-15K MAU** | p95 latency cliff |
| 2 | Postgres connection exhaustion (no pooler) | **5K-10K MAU** | "too many connections" |
| 3 | OpenAI Tier 1 RPM | **~55K MAU** | 429 errors |
| 4 | Postgres working set > RAM | **~50K MAU** | search p95 50ms → 500ms+ |
| 5 | Node.js raw throughput | **~880K MAU** | academic; never reached |

**Migration triggers table** with MAU + symptom thresholds and specific migrations (PgBouncer at 3K, queue at 2K, worker split at 5K, cache at 10K, read replica at 50K, shard at 250K, multi-region at 500K+).

**Cost projections at each tier** with real dollar tables:
- Today: ~$140/mo
- 10x: ~$630/mo
- 100x: ~$7,665/mo (OpenAI 78%)
- 1000x: ~$62K-92K/mo (OpenAI 85%+)

**Challenge to founder's hypothesis** in 3 numbered points:
1. Postgres is not the first failure point. Connection exhaustion hits at 5-10K MAU.
2. "Add more EC2 instances" actively worsens the real bottleneck — multiplies concurrent OpenAI calls against a shared RPM quota.
3. The first failure is p95 latency, not capacity.

**Verdict:** *"Your architecture is fine to ~2,000 MAU. Between 2K-10K MAU you must (a) remove sync LLM from request path via queue, (b) add PgBouncer. Without those, the demo breaks before the Series A closes."*

**Citation map** tying every section to skill rules.

### Outcome

**Both refused the hand-wave.** The "it'll scale fine" failure pattern didn't manifest in RED. Base Claude correctly identifies that *Postgres scales well* is true in the abstract but **not** the binding constraint when synchronous LLM calls sit in the request path eating connection slots.

**Differences GREEN added:**

| Feature | RED | GREEN |
|---|---|---|
| Per-component capacity math | ✅ extensive | ✅ extensive |
| Identified sync LLM as #1 bottleneck (not Postgres) | ✅ | ✅ |
| Challenged "add more EC2" hypothesis with RPM math | ✅ | ✅ |
| Migration triggers with specific thresholds | ✅ sequenced | ✅ table with MAU + symptom + migration |
| Cost projection at each tier with real dollars | ✅ | ✅ |
| LLM cost as % of total bill at scale | ✅ 78% / 85% | ❌ implied |
| Investor-facing framing paragraph (ready to send) | ✅ verbatim quote | ❌ |
| Data lifecycle policy mentioned | ❌ | ✅ TTL on Redis, 90-day default on /generate outputs |
| Ordered failure-rank table (#1 → #5) | ❌ | ✅ |
| Citation map | ❌ | ✅ |

**RED was richer on cost economics** (explicit LLM-cost-as-% and the gross-margin framing) and the investor pitch (an exact paragraph the founder can send). **GREEN was structurally cleaner** (the ranked failure table and the day-trigger / migration / rationale columns).

This is consistent with the broader pattern: RED writes for the conversation, GREEN writes for the artifact chain. For a founder pitching investors, RED's output is more useful as-is; for downstream `incident-response` and `architecture-and-contracts` skills consuming `.forge/scalability.md`, GREEN's structure is what they need.

## Refactor applied

None.
