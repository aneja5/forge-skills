---
name: incremental-implementation
description: Execute tasks from .forge/tasks.yaml one at a time using thin vertical slices. Reads the task's contracts, implements the minimum code to satisfy acceptance criteria, and commits after each task. Use when .forge/tasks.yaml exists and implementation is starting.
---

# Incremental Implementation

## Overview

Pick the next ready task from `.forge/tasks.yaml`, load its contracts from `.forge/contracts/`, implement using `tdd` discipline (red-green-refactor), verify against acceptance criteria, commit, and mark done. Repeat until all tasks are complete.

## When to Use

- `.forge/tasks.yaml` exists with at least one unstarted task
- Dependencies for the next task are complete
- Ready to write code (not planning, not designing)

## When NOT to Use

- No task plan exists — run `planning-and-task-breakdown` first
- Architecture is unclear — run `architecture-and-contracts` first
- Task is XL and not decomposed — spike first, then plan

## Common Rationalizations

| Thought | Reality |
|---------|---------|
| "I'll implement a few tasks together to go faster" | Mixing tasks blurs acceptance criteria and commit history |
| "I don't need to read the contract — I know the interface" | Contracts encode invariants and error types you'll miss |
| "I'll write tests after the implementation is working" | Then you're testing implementation, not behavior |
| "This small extra thing is obviously correct to add" | Scope creep is always "obviously correct" in the moment |
| "I'll commit everything at the end" | Atomic commits per task make revert and review tractable |

## Red Flags

- Implementing a task that has unsatisfied dependencies in `tasks.yaml`
- Writing code that touches modules not listed in the task's `files_likely_affected`
- Skipping the contract read — implementing to an assumed interface
- Committing with a message that doesn't reference the task ID
- Acceptance criteria not verifiable after implementation
- Task marked done before verification step passes

## Core Process

### Step 1: Select the next task

Read `.forge/tasks.yaml`. Find all tasks where `depends_on` tasks are complete and the task is not started. Pick the highest-priority unblocked task (or ask the user if multiple are ready).

### Step 2: Load context

Read the task's acceptance criteria and verification steps. Read each contract listed in the task's `contracts` field from `.forge/contracts/`. Load only the files_likely_affected — don't read the whole codebase.

### Step 3: Implement with TDD

Follow the `tdd` skill. For this task's acceptance criteria:

```
RED:   Write a failing test for the first acceptance criterion
GREEN: Write minimum code to make it pass
REPEAT for each acceptance criterion
REFACTOR: Clean up while keeping all tests green
```

Stay within the task's scope. Do not add features not in the acceptance criteria. Do not touch files outside `files_likely_affected` without explicit reason.

### Step 4: Verify

Run the verification steps listed in the task. All must pass:
- Unit tests green
- Integration tests green (if listed)
- Manual verification step confirmed (if listed)

### Step 5: Commit

```
git add <files>
git commit -m "[T001] <task title>

- Implements: <acceptance criterion 1>
- Implements: <acceptance criterion 2>
- Tests: <what the tests verify>"
```

### Step 6: Mark done

Update `.forge/tasks.yaml`: set the task status to `done`. Check if any blocked tasks are now unblocked. Report progress to user.

## Verification

Before marking any task done:

- [ ] All acceptance criteria in tasks.yaml satisfied
- [ ] All verification steps in tasks.yaml passed
- [ ] No files touched outside the task's scope (or explicitly justified)
- [ ] Contract invariants not violated (check against `.forge/contracts/`)
- [ ] Tests verify behavior through public interface, not implementation details
- [ ] Commit message references task ID
- [ ] `.forge/tasks.yaml` updated with task status
