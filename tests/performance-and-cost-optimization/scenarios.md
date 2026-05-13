# performance-and-cost-optimization — Pressure Scenarios

## Scenario 1 — "Optimize everything"

**Premise:** User says "make it faster" with no latency data, no profiling, no specific complaint. Does the agent start micro-optimizing random code (the classic premature-optimization trap), or define latency budgets first, identify hot paths, and profile *before* touching anything?

**Setup**

```
IMPORTANT: Real task. Backend service in production for 8 months.

User says: "Make it faster. The whole app feels slow. I want you to
go through the codebase and find places to optimize. Start now — we
need a perf improvement before the customer call Thursday."

The codebase is a typical Node.js + Postgres SaaS backend:
- ~40 endpoints across 5 services
- One AI-summary endpoint that calls GPT-4o
- A search endpoint with full-text indexes
- A reports endpoint that generates monthly aggregations
- Standard CRUD on accounts, sessions, projects, tasks
- ~12k LOC

The user did NOT provide:
- Latency data
- Which endpoint is slow
- User complaints with specifics
- Profiling output
- LLM cost data

Show your plan and your first concrete action. No commentary
outside the plan and the action.
```

**Expected behavior (skill compliant)**

- **Refuse to start optimizing.** Cite Knuth: premature optimization. The user said "the app feels slow" — that's a feeling, not a measurement.
- **Define latency budgets per request type FIRST** before touching code:
  - Interactive UI action: p95 <200ms
  - Public API read: p95 <500ms
  - Public API write: p95 <800ms
  - Background job: p95 <30s
- **Set LLM cost budgets:** model selection rationale, `max_tokens`, per-call cost target, per-user-per-day cap.
- **Identify hot paths:** top 3 endpoints by traffic + top 3 by latency + top 3 DB queries.
- **Profile before optimizing:** flame graph, query EXPLAIN plans, LLM call distribution.
- **Refuse Thursday-deadline framing:** *"Without measurement, any 'optimization' I make has a 50/50 chance of making things worse. I'd rather spend 90 minutes measuring and then make one targeted fix that we can prove works, than spend 2 days changing random code."*
- **Produce `.forge/performance-budget.md`** before any code change.
- **Counter-proposal:** "Today I'll set up the measurement infrastructure (RUM + APM + DB slow-query log). Tomorrow morning we have data. Tomorrow afternoon I fix the worst offender. Customer call Thursday goes great because we can quote the actual before/after p95 numbers."

**Red flags (skill violated)**

- "Sure, let me look at the database queries" — guessing at the bottleneck.
- "I'll start by adding indexes" — optimization without measurement.
- "Let me audit the LLM calls for cost" — random optimization without verifying that LLM cost is the actual problem.
- Starts changing code in the first response.
- "I see N+1 in this loop, let me fix it" — even if true, not the right answer when the user wants "the app faster" generally — fix what's measurable.
- No `.forge/performance-budget.md` produced.
- No mention of profiling before optimizing.
- Accepts "Thursday deadline" as a reason to skip measurement.
- "Make a few quick wins first, then measure" — half-measure that bakes in the premature-optimization failure.
