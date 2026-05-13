# performance-and-cost-optimization — Test Results

Run date: 2026-05-12
Methodology: see [tests/METHODOLOGY.md](../METHODOLOGY.md)
Subagents: 2 fresh `general-purpose` agents (1 RED + 1 GREEN)

---

## Scenario 1 — "Optimize everything"

### RED (no skill)

**Refused to start optimizing without measurement.** Lead with: *"Plan and first action remain as stated. Awaiting your answers to the three questions before any code change; diagnostic pass is read-only and will continue in parallel once you confirm repo path or grant access to APM / pg_stat_statements output."*

The "starts micro-optimizing random code" failure did not manifest. RED refused the Thursday-deadline framing and demanded measurement infrastructure (APM, `pg_stat_statements`) and clarification on which surface to investigate before any code change. The full output exceeded the agent's primary turn — the visible portion shows the agent in halt mode awaiting input rather than producing the deliverable.

### GREEN (with skill)

Per the agent's citation summary, produced a structured `.forge/performance-budget.md` with:

- **Latency budgets per request class** (verbatim from skill Step 1) plus an additional row for LLM-backed endpoints because the app has a GPT-4o endpoint.
- **LLM cost budget** with the skill's exact fields (model selection rationale, input token cap, `max_tokens`, cost-per-call target, per-user-per-day budget).
- **Caching strategy table** with the skill's exact columns (key schema with version, TTLs, invalidation events table, negative caching, stale-while-revalidate, failure mode).
- **Frontend bundle budget** split into route classes (`<200KB initial JS per route`) because one number for the whole app is too coarse for CI enforcement.
- **Profiling targets** verbatim from Step 5: top 3 by traffic with production-shaped data, top 3 by latency with flame graphs, top 3 DB queries by cost with EXPLAIN plans, audit of `setInterval` / `setTimeout` / render-loop code.
- **"What I'm NOT doing this week" section** mapping each rationalization to a refused action.
- **Sequence (no optimization until Wed EOD)** explicitly stated — measurement infrastructure first, then targeted fix backed by data.
- **Verification checklist** matching the skill's acceptance bar.

GREEN claimed to write `/Users/sahil/forge-skills/.claude/worktrees/serene-lalande/.forge/performance-budget.md`. Verified after run: no `.forge/` directory in our worktree; subagent's filesystem actions were sandboxed.

### Outcome

**Both refused to start optimizing without measurement.** The "premature optimization on random code" failure did not manifest. Base Claude correctly reads "make it faster, no data provided" as the canonical premature-optimization trap and refuses.

**Differences GREEN added:**

| Feature | RED | GREEN |
|---|---|---|
| Refused to optimize without data | ✅ | ✅ |
| Demanded measurement infrastructure first | ✅ APM + `pg_stat_statements` named | ✅ profiling targets enumerated |
| Latency budgets per request class | ⚠️ implied | ✅ table per skill Step 1 |
| LLM cost budget fields | ⚠️ implied | ✅ exact skill fields |
| Caching strategy table | ❌ | ✅ key schema / TTL / invalidation / negative cache / SWR / failure mode |
| Bundle budget per route class | ❌ | ✅ |
| Profiling target enumeration (top 3 traffic / latency / DB cost) | ❌ | ✅ verbatim |
| "What I'm NOT doing this week" section | ❌ | ✅ |
| Customer-call-Thursday counter-proposal | ⚠️ implicit (paused for info) | ⚠️ implicit |
| `.forge/performance-budget.md` artifact | ❌ | ✅ (sandboxed) |
| Citation map | ❌ | ✅ |

**RED's halt-for-information** is a different but defensible refusal pattern: instead of producing a partial answer with hypothetical numbers, ask for measurement infrastructure access first. **GREEN's full-budget-doc** is the skill-prescribed deliverable.

Both prevented the failure. No skill change.

## Refactor applied

None.
