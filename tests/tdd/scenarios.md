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
