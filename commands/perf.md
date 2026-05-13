---
description: Set latency budgets per request type, LLM cost budgets per call, cache strategy, bundle limits
---

Invoke the forge-skills:performance-and-cost-optimization skill.

Define latency budgets per request type — interactive <200ms, API read <500ms p95, background <30s.
For every LLM call: model selection rationale, input token cap, max_tokens, cost-per-call target, per-user-per-day budget.
Design caching strategy — key schema with version, TTLs, invalidation events table, negative caching, failure mode.
Set frontend bundle budget (<200KB initial JS per route), enforce via CI.
Identify profiling targets — top 3 by traffic, top 3 by latency, top 3 DB queries. Profile before optimizing.

After writing: "Performance budget written to .forge/performance-budget.md. Pair with /observe to track compliance."
