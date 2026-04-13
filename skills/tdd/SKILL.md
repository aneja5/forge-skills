---
name: tdd
description: Test-driven development with red-green-refactor loop. Use when implementing features or fixing bugs test-first, when user mentions "red-green-refactor", or when incremental-implementation needs TDD discipline for a specific task.
---

# Test-Driven Development

## Overview

Tests verify behavior through public interfaces, not implementation details. One failing test → minimum code to pass → repeat. Never write all tests first. See [tests.md](tests.md) for examples and [mocking.md](mocking.md) for mocking guidelines.

## When to Use

- Implementing a task from `.forge/tasks.yaml` that needs test-first discipline
- Any feature or bug fix where behavior must be proven before merging
- User explicitly asks for TDD or red-green-refactor

## When NOT to Use

- Writing tests retroactively for already-working code — that's a different activity
- Exploratory spike to understand a problem space — spike first, then TDD the result
- Config changes with no behavioral assertions possible

## Common Rationalizations

| Thought | Reality |
|---------|---------|
| "I'll write tests after the implementation works" | Then you test implementation shape, not behavior |
| "Writing all tests first is TDD" | That's horizontal slicing — produces brittle tests |
| "This behavior is obvious, no test needed" | Obvious behaviors are the ones that silently break |
| "I need to mock my own modules to test this" | Your interface boundaries need rethinking |
| "The test is too hard to write" | The interface is too hard to use — fix the interface |

## Red Flags

- Test names describe HOW not WHAT ("calls paymentService.process")
- Test mocks internal collaborators owned by the same codebase
- Test breaks on refactor when behavior didn't change
- All tests written before any implementation ("horizontal slicing")
- Test verifies through side effects or database state instead of interface

## Anti-Pattern: Horizontal Slices

**DO NOT write all tests first, then all implementation.**

```
WRONG (horizontal):
  RED:   test1, test2, test3, test4, test5
  GREEN: impl1, impl2, impl3, impl4, impl5

RIGHT (vertical):
  RED → GREEN: test1 → impl1
  RED → GREEN: test2 → impl2
  RED → GREEN: test3 → impl3
```

Each test responds to what you learned from the previous implementation cycle.

## Workflow

### 1. Plan before coding

- [ ] Confirm public interface changes with user (or with task's contract from `.forge/contracts/`)
- [ ] List behaviors to test — not implementation steps
- [ ] Design interface for [testability](interface-design.md)
- [ ] Identify [deep module](deep-modules.md) opportunities
- [ ] Get user approval before writing the first test

### 2. Tracer bullet

Write ONE test that proves the end-to-end path works:

```
RED:   Write test for first behavior → must fail
GREEN: Write minimum code to pass → passes
```

### 3. Incremental loop

For each remaining behavior:

```
RED:   Write next test → fails
GREEN: Minimum code to pass → passes
REPEAT
```

Rules: one test at a time, only enough code for the current test, no speculative features.

### 4. Refactor

After all tests pass — see [refactoring.md](refactoring.md):

- [ ] Extract duplication
- [ ] Deepen modules (move complexity behind simple interfaces)
- [ ] Run tests after each refactor step
- [ ] **Never refactor while RED**

## Per-Cycle Checklist

- [ ] Test describes behavior (WHAT), not implementation (HOW)
- [ ] Test uses public interface only — no private method access
- [ ] Test would survive internal refactor without breaking
- [ ] Implementation is minimal — no speculative features
- [ ] Test name reads like a specification sentence

## Verification

- [ ] All behaviors listed in Step 1 have a passing test
- [ ] No tests mock internal collaborators
- [ ] Full test suite passes (not just new tests)
- [ ] Refactor pass complete — no duplication, no shallow modules
- [ ] If task from tasks.yaml: all acceptance criteria verified
