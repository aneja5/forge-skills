---
description: Plan parallel agent dispatch from .forge/tasks.yaml — conflict matrix, worktree isolation, merge order
---

Invoke the forge-skills:parallel-execution-strategy skill.

Read `.forge/tasks.yaml`. Identify dependency-free groups — both `depends_on` AND `files` lists must not intersect.
Build a file-conflict matrix per group. Any row with two ✏️ marks is a conflict — split, sequence, or designate a primary.
Assign one branch per task (`task/T-XXX-description`), all based off main.
Define PR sequencing and merge order before dispatch. Lowest-blast-radius first; tasks that mutate shared types/contracts land first so others rebase on them.
Each agent runs in its own git worktree — never share.
Define integration-test gate between every merge and between groups.

After writing: "Parallel plan written to .forge/parallel-plan.md. Dispatch only after the plan is signed off."
