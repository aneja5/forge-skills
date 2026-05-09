---
description: Scalability analysis — capacity math, bottlenecks, cost projections, migration triggers
---

Invoke the forge-skills:scalability-analysis skill.

Read `.forge/architecture.md`. If it doesn't exist, tell the user to run /architect first.

Document current capacity per component.
Define scale targets with the user (10x, 100x, 1000x).
Identify bottlenecks per component at each target — what breaks first and at what threshold.
Calculate scale-out triggers with specific metrics and thresholds.
Project costs at each milestone with real pricing.
Map migration decision points (when to add caching, shard, split monolith).
Define data lifecycle policies for every data store.

After writing: "Scalability analysis written to .forge/scalability.md."
