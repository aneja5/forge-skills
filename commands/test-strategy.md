---
description: Define test pyramid, mocking boundaries, coverage targets, and quality gates
---

Invoke the forge-skills:testing-strategy skill.

Read `.forge/prd.md` if present. Identify critical user paths.
Decide test level per path (unit / integration / e2e). Default ratio 70/20/10, adjust based on risk.
Define mocking boundaries — mock at the seam, never inside the module.
Set per-component coverage targets with rationale (not a blanket %).
Write golden tests for invariants. Define flake quarantine policy. Set CI gates.

After writing: "Testing strategy written to .forge/testing-strategy.md. Run /build with tdd discipline."
