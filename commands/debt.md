---
description: Track and pay down tech debt — registry, triggers, strangler-fig for rewrites
---

Invoke the forge-skills:refactoring-and-tech-debt skill.

Audit codebase for debt — copy-paste blocks (3+ occurrences), TODO/HACK/FIXME comments, high-churn low-coverage modules, files >500 lines, cyclic imports, dead code, bus-factor-1 modules.
For each item: location, type, bus factor, cost-to-fix, cost-of-not-fixing, owner, trigger.
Set triggers — third-occurrence rule (extract), adjacent-work rule (refactor before feature, in a separate PR), budget-breach rule, security/compliance rule.
Assign pattern per item (extract / inline / rename / strangler-fig / delete).
Enforce refactor-only PRs — no behavior change mixed with structural change.

After writing: "Tech debt registry written to .forge/tech-debt-registry.md."
