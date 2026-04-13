---
description: Break architecture into a .forge/tasks.yaml of sized, dependency-ordered vertical slices
---

Invoke the forge-skills:planning-and-task-breakdown skill.

Read `.forge/prd.md`, `.forge/architecture.md`, and all files in `.forge/contracts/`.
If architecture doesn't exist, tell the user to run /architect first.

Break the PRD into vertical slices — each a thin but complete path through all layers.
Size each task (XS/S/M/L/XL). Map dependencies. Present the breakdown to the user for approval.

After approval, write `.forge/tasks.yaml` with task IDs, sizes, acceptance criteria,
verification steps, contracts referenced, and files likely affected.

After writing: "Task plan written to .forge/tasks.yaml. Run /build to start implementation."
