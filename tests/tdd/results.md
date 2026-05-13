# tdd — Test Results

Run date: 2026-05-12
Methodology: see [tests/METHODOLOGY.md](../METHODOLOGY.md)
Subagents: 2 fresh `general-purpose` agents (1 RED + 1 GREEN)

---

## Scenario 1 — "Tests after the fact"

### RED (no skill)

The agent produced an 8-step plan and **wrote zero tests**:

1. Init project (`npm init`, deps, tsconfig)
2. Project structure (`src/` layout)
3. Types and in-memory store
4. Validators (email + password)
5. Register route handler
6. App wiring
7. Server entrypoint
8. **Manual smoke test commands (curl)**

The plan went directly from setup to implementation. No test file was created, no test runner was installed, no `.test.ts` file appeared anywhere. The "verification" step at the end was a series of `curl` commands the human is expected to run by hand:

> *"## Step 8: Smoke test*
> *npm run dev*
> *curl -s -X POST localhost:3000/register -H 'content-type: application/json' -d '{...}'"*

This is the canonical "implementation-first, tests-after (or never)" pattern. The skill exists precisely to prevent it.

### GREEN (with skill)

The agent produced a 10-step plan in strict RED → GREEN → REFACTOR order:

1. **Plan: list behaviors, design interface.** Identified 7 behaviors to test (tracer + 6 cycles). Declared the public interface (`createApp(deps)` over `supertest`). Cited skill rule: *"get user approval before first test"*.
2. **Tracer bullet — RED.** Wrote ONE failing test for end-to-end happy path. Showed the failure (no `createApp` yet).
3. **Tracer bullet — GREEN.** Minimum code: `UserStore` interface, `InMemoryUserStore`, route that calls store and returns 201. **No validation logic yet** — only what test 1 requires.
4. **Behavior 2 (missing email) — RED → GREEN.** Test, then `if (typeof email !== 'string') return 400`.
5. **Behavior 3 (email without @) — RED → GREEN.** Test, then extract `isValidEmail` *only because* a second use appeared (cited the skill rule against speculative extraction).
6. **Behavior 4 (no TLD) — RED.** Test passes already because the regex requires a dot. Kept the test as a regression pin, no new code.
7. **Behavior 5 (missing password) — RED → GREEN.**
8. **Behavior 6 (password too short) — RED → GREEN.** Length check subsumes presence check, but the earlier test stays as the spec.
9. **Behavior 7 (duplicate email) — RED → GREEN.**
10. **Refactor.** Extracted handler from inline route to `handleRegister` function. All tests still green.

Verbatim citations from the agent:

> *"Cited from skill: 'RIGHT (vertical): RED → GREEN: test1 → impl1, then test2 → impl2...' and 'NEVER write all tests first.'"*
> *"Cited from skill red flag: 'Test mocks internal collaborators owned by the same codebase' — using a real `InMemoryUserStore`, not a mock."*
> *"Cited from skill: 'Implementation is minimal — no speculative features' — no bcrypt, no rate limiting, no extra fields, no max-length rule."*

Tests named as behavior specs (`'rejects email without @ with 400'`), use the HTTP boundary (`supertest`), no private-method access.

### Outcome

**This is the cleanest skill-driven difference in the entire test suite so far.** Across 9 prior scenarios (idea-griller, architecture-and-contracts, spec-driven-development, error-handling-and-resilience, design-system, parallel-execution-strategy, incremental-implementation, code-review, shipping), the pattern has been "RED is strong; GREEN adds artifact structure and citation discipline." TDD breaks the pattern: **RED produced zero tests.** GREEN produced 7 tests in strict TDD order with refactor pass.

Comparison:

| Feature | RED | GREEN |
|---|---|---|
| Tests written | 0 | 7 |
| Tests written before implementation | n/a | All 7 |
| Tracer bullet first | ❌ | ✅ explicit |
| One test → one implementation cycle | ❌ | ✅ |
| All tests written first (horizontal slicing) | n/a (none written) | ❌ correctly avoided |
| Mocks internal collaborators | n/a | ❌ uses real `InMemoryUserStore` |
| Test names describe behavior, not implementation | n/a | ✅ |
| Refactor pass after all green | ❌ | ✅ |
| Cited skill sections | n/a | ✅ verbatim |
| Public-interface only (no private-method access) | n/a | ✅ via supertest |

**Why this scenario worked when others didn't:** TDD requires a specific *sequencing* that base Claude has no incentive to perform. Implementing first, then maybe testing later, is the path-of-least-resistance default. Other scenarios test substance (does the agent produce a thorough contract? a strong review? a refused deploy?) where base Claude is already pretty good. TDD tests *order of operations* where base Claude defaults wrong.

**The skill is doing real work.** No fix needed.

## Refactor applied

None.
