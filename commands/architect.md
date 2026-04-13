---
description: Design system architecture and write interface contracts from .forge/prd.md
---

Invoke the forge-skills:architecture-and-contracts skill.

Read `.forge/prd.md` in full. If it doesn't exist, tell the user to run /spec first.

Produce three artifacts:
1. `.forge/architecture.md` — system overview, component diagram (text), tech stack decisions
2. `.forge/contracts/<module>.md` — one per module boundary, with input types, output types,
   error types, and invariants. See references/contract-templates.md for the format.
3. `.forge/adr/NNN-<slug>.md` — one per non-obvious architectural decision.

After writing: "Architecture and contracts written. Run /plan to break work into tasks."
