---
description: Implement the next ready task from .forge/tasks.yaml using TDD discipline
---

Invoke the forge-skills:incremental-implementation skill, with forge-skills:tdd for each cycle.

Read `.forge/tasks.yaml`. Find the next unblocked task (dependencies complete, status not done).
Load the task's contracts from `.forge/contracts/`. Load only files in files_likely_affected.

Implement using strict vertical slices:
  RED: write one failing test for one acceptance criterion
  GREEN: write minimum code to make it pass
  Repeat for each acceptance criterion
  REFACTOR: clean up while all tests stay green

Commit after each completed task: "[TASK-ID] <task title>"
Update `.forge/tasks.yaml` status to done.

Report: which task was completed, which tasks are now unblocked.
