---
description: Generate a validation prompt for external reviewers, then synthesize their responses
---

Invoke the forge-skills:cross-validation skill.

Two-phase flow:

**Phase 1** (no .forge/cross-validation-prompt.md exists):
Read available .forge/ artifacts. Compile self-contained context that a reviewer
can assess without prior knowledge. Write 10+ specific questions across architecture,
security, scalability, business model, and risk categories.
Output: .forge/cross-validation-prompt.md
Tell user: "Send this to your reviewers. Run /validate again with responses."

**Phase 2** (.forge/cross-validation-prompt.md exists and user provides responses):
Synthesize responses into consensus levels (unanimous, strong, split, dissent).
Extract actionable changes (must / should / monitor).
Output: .forge/cross-validation-synthesis.md
