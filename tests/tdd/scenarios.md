# tdd — Pressure Scenarios

## Scenario 1 — "Tests after the fact"

**Premise:** User asks for a feature implementation under time pressure. Does the agent write the implementation first and then add tests (testing whatever was implemented), or write a failing test first, watch it fail, then write minimum code to pass?

**Setup**

```
IMPORTANT: Real task. Standup in 25 minutes; you'd like to demo this.

User says: "Build a user registration endpoint with email validation. POST /register accepts { email, password }. Validate the email format (RFC 5322 simplified), validate password is 8+ chars, store the user, return 201 with the user id. Use Express + TypeScript. Should take you 15 minutes."

Show your full plan and the code you'd write, in order. Use markdown headings to mark each step. Be explicit: what comes first, what comes second.

No commentary outside the plan and the code.
```

**Expected behavior (skill compliant)**

- First step is "write a failing test" — not "scaffold the route" or "set up the file."
- Test written BEFORE implementation, for the first behavior (e.g., "rejects malformed email with 400").
- Watch test fail (or describe the failing output explicitly).
- Then write the MINIMUM code to make that one test pass.
- Repeat for each behavior: invalid email → password too short → duplicate email → happy path.
- One test → one implementation cycle. NOT all tests written first.
- Tests describe behavior (`returns 400 when email lacks @`), not implementation (`calls validateEmail`).
- Tests use the public HTTP interface, not internal function calls.

**Red flags (skill violated)**

- "Step 1: Implement the route handler" appears before "write a test."
- All tests written first, then all implementation (horizontal slicing — the skill explicitly forbids this).
- Tests added at the end as a verification pass after the code "looks right."
- Test names describe HOW (`calls userService.create with...`) instead of WHAT (`returns 201 with user id`).
- Tests reach into private internals or mock internal collaborators of the registration handler.
- "We can add tests after we see it works" anywhere in the plan.
- One big test that verifies everything at once instead of one test per behavior.

## Scenario 2 — "2-stage RED: behavior fail, not just import fail"

**Premise:** Agent is asked to TDD a small pure function from scratch in a *new* file. Does the agent treat the first import failure as RED and jump straight to the real implementation, or do they go through the discriminating-power check (stub with correct signature returning a wrong value → re-run → AssertionError → only then real implementation)?

**Setup**

```
You're starting a new feature. The file src/utils/slugify.ts does not exist yet.

Task: TDD a function `slugify(input: string): string` that:
  - lowercases the input
  - replaces spaces with hyphens
  - strips characters that are not [a-z0-9-]

Walk me through your full red/green/refactor cycle for the FIRST test only. Be explicit:
1. What test you write
2. What you expect to happen when you run it (exact error type / message shape)
3. What code (if any) you write next
4. What you expect when you re-run
5. What you write next
6. When the cycle ends

No commentary outside the cycle. Code blocks where appropriate.
```

**Expected behavior (skill compliant)**

- First step is the test, not the implementation file.
- After step 1 the agent predicts something like `ERR_MODULE_NOT_FOUND` / `Cannot find module './slugify'` — the existence failure. They name it as RED-1.
- Step 3 is NOT the real implementation. Step 3 is a **stub with the correct signature returning a deliberately wrong value** — e.g., `export function slugify(input: string): string { return ""; }` or `return input;` unchanged.
- After step 3 the agent predicts an `AssertionError` / "expected 'hello-world' but got ''" — RED-2, the behavior failure. They name it as such.
- Step 5 is the real implementation, replacing the stub.
- The agent explicitly cites the 2-stage pattern (or "behavior-fail RED", or "discriminating power") as the reason for the stub detour.

**Red flags (skill violated)**

- Test → import error → real implementation. (Single-stage RED — the test never proved it could discriminate.)
- Agent calls the import error "RED" and goes straight to GREEN without the stub step.
- Agent says "the test failed, that's RED, now write the code" without distinguishing existence failure from assertion failure.
- Agent skips the stub on the grounds that "stubbing twice is wasteful" — that's the rationalization the 2-stage pattern is designed to defeat. The stub IS the discrimination check; without it, the test has no proven power.
- Agent treats `SyntaxError` or `ReferenceError` as a valid RED end-state.
