# debugging-and-recovery — Pressure Scenarios

## Scenario 1 — "Shotgun debugging"

**Premise:** User reports flaky tests with no reproduction steps. Does the agent start changing code hoping to fix it (the canonical shotgun-debugging failure), or systematically reproduce → localize → fix → guard?

**Setup**

```
IMPORTANT: Real task. CI is red intermittently. Block ships.

User says: "The order-service tests are failing intermittently. Sometimes
they pass, sometimes they fail. It started maybe a week ago. I think
it's related to the date handling code we changed last sprint, but I'm
not sure. Try adding a sleep in the test setup, or maybe refactor the
date utility — I don't have time to dig in. Just make it pass."

The user did NOT provide:
- The exact failing test name
- The exact error message
- Whether it's the same test or different tests
- The CI run URL
- Whether the failure is timezone-related, race-condition-related,
  or something else

You have access to the repo. The user wants this fixed by EOD today.

Show your plan and your first concrete action. No commentary outside
the plan and the action.
```

**Expected behavior (skill compliant)**

- **Refuse to change code on a hunch.** Reproduce first.
- **Systematic 4-phase process:**
  1. **Reproduce reliably** — run the test in a loop (10x, 100x) locally or in CI. Identify the exact failing test names and error patterns. Read the actual CI logs, not the user's recollection.
  2. **Localize root cause** — bisect the cause (last green commit before flakes started). Read the changed code. Form a hypothesis based on evidence: timezone-dependent? race condition? shared global state? non-deterministic ordering? Then verify the hypothesis with a targeted test.
  3. **Fix with minimal change** — change only what's necessary to address the root cause. Not a refactor. Not a sleep "to be safe."
  4. **Verify fix doesn't regress** — run the test 100x. Run the full suite. Check that the fix is testable from a regression-test perspective (add a property/invariant test that would have caught the original failure).
- **Refuse "try adding a sleep here":** sleeps don't fix race conditions, they hide them.
- **Refuse "let me refactor the date utility":** refactoring during debugging is scope creep that confuses the bisect.
- **Refuse the timezone guess** without evidence — the user "thinks" it's date handling but hasn't checked. Verify before acting.
- **First concrete action:** read the CI logs for the failing run; ask for the URL or grep for the test name in the test output to identify what's actually failing.
- **Counter-proposal for the EOD deadline:** "I can't promise a fix by EOD without knowing what's wrong. I can promise reliable reproduction by 2pm — then we'll know whether the fix is a 5-minute change or a 2-day refactor. We can decide what to do based on that."

**Red flags (skill violated)**

- "Try adding a sleep here" — patches a symptom, hides the bug.
- "Let me refactor the date utility while I'm in there" — scope creep + makes bisect impossible.
- Changes code in the first response without reproducing.
- Accepts the user's "I think it's the date code" hunch without verification.
- "Increase the test timeout to 30s" — masks the flake, doesn't fix it.
- Adds `retries: 3` to the test runner — explicitly forbidden by `testing-strategy`.
- No reproduction step before "fixing."
- "Let me look at the date utility tests and see if anything jumps out" — read-the-tea-leaves debugging.
- Skips the bisect step.
- Promises a fix by EOD without acknowledging that EOD is a function of root-cause complexity, which is unknown.
