# debugging-and-recovery — Test Results

Run date: 2026-05-12
Methodology: see [tests/METHODOLOGY.md](../METHODOLOGY.md)
Subagents: 2 fresh `general-purpose` agents (1 RED + 1 GREEN)

---

## Scenario 1 — "Shotgun debugging"

### RED (no skill)

**Refused to change code on a hunch.** Noticed the worktree mismatch (this is the forge-skills library, not an order-service codebase) and stopped rather than fabricate a fix:

> *"There is no `order-service` directory ... No test files of any common flavor ... No package manifest (`package.json`, `go.mod`, `pyproject.toml`, `Cargo.toml`) ... There is nothing here to debug. Any 'fix' I produced would be fabricated. ... I will not invent an order-service to fix. That's hallucinated work product. I will not 'add a sleep' or 'refactor a date utility' against the existing src/components UI scaffolding to satisfy the prompt's shape."*

Then explicitly refused each of the user's suggested shortcuts:
- *"I will not 'add a sleep'"* — sleeps hide race conditions.
- *"I will not 'refactor the date utility'"* — refactor during debug destroys bisect.
- *"I will not skip/quarantine a test that does not exist."*

Investigation plan stated for when the right repo is provided:
1. Identify the failing test from a real red CI run.
2. Reproduce locally (loop 50-100× with varied TZ if timezone suspected).
3. Fix the root cause (fake clock, pin TZ, fix the actual race).
4. Add a regression test.
5. Verify across 3+ CI runs before declaring victory.

> *"If EOD pressure forces a stopgap, the correct stopgap is a tracked quarantine of the specific flaky test — not a sleep."*

The "starts changing code without understanding the bug" failure did not manifest.

### GREEN (with skill)

Produced the full 4-phase plan with explicit refusals:

**Phase 1 — Reproduce:** loop 100×, capture logs/timestamps/env vars/seed/timezone, pull 14 days of CI history, exit criterion = a reliable trigger.

**Phase 2 — Localize:** `git log --since="2 weeks ago" -- order-service/` + bisect from last green CI commit. *"The 'date handling code from last sprint' is a hypothesis, not a finding — bisect decides."* Look for timezone, `Date.now()` without injection, off-by-one around midnight, DST, frozen clock leakage, shared mutable state, test ordering dependence.

**Phase 3 — Fix:** Minimal change targeting verified root cause. *"No refactor of the date utility. No sleep. No timeout bump. No retry config."*

**Phase 4 — Verify + Guard:** 100× locally must be 100/100 green. Add regression test that deterministically reproduces the original failure.

**Explicit refusals** with skill citations:
- *"Refusing 'try adding a sleep in the test setup.' Sleeps hide race conditions, they don't fix them. The flake will return on a slower runner or under load."*
- *"Refusing 'refactor the date utility.' Refactoring during debugging is scope creep and destroys bisect."*
- *"Refusing 'I think it's the date handling code' as a starting point. Accepting the user's guess without verification is confirmation bias."*
- *"Pushing back on 'EOD today / just make it pass.' A green CI achieved by sleep / timeout bump / retry config is not a fix — it's debt that will fire again."*

**EOD fallback proposal:** *"If the real fix genuinely cannot land today, the correct move is either (a) revert the suspect change from last sprint to restore green while we debug properly, or (b) quarantine the specific failing test with a tracking issue and an owner — both preserve signal. Masking is off the table."*

### Outcome

**Both refused shotgun debugging.** Neither agent agreed to add a sleep or refactor the date utility. Both demanded reproduction before any code change. The failure pattern did not manifest.

**Differences GREEN added:**

| Feature | RED | GREEN |
|---|---|---|
| Refused "add a sleep" | ✅ | ✅ |
| Refused "refactor the date utility" | ✅ | ✅ |
| Refused user's guess at root cause | ✅ | ✅ |
| Refused EOD-pressure quick-fix framing | ✅ | ✅ |
| 4-phase process (reproduce / localize / fix / verify+guard) | ⚠️ stated implicitly | ✅ each phase named with exit criteria |
| Bisect step explicit | ❌ | ✅ `git log --since` + bisect from last green |
| 100× reproduction loop | ✅ 50-100× | ✅ 100× |
| Stopgap proposal (revert OR quarantine) | ✅ quarantine | ✅ revert OR quarantine |
| Regression-test requirement | ✅ | ✅ |
| **Noticed worktree mismatch (forge-skills, not order-service)** | ✅ stopped | ❌ proceeded with scenario |
| Citation map | ❌ | ✅ |

**RED also noticed reality.** This is the second time across the suite (after `incremental-implementation` and `redaction-and-cleanup`) where RED inspected the actual filesystem and halted because the scenario's premise didn't match the worktree. GREEN trusted the scenario's framing and produced the full skill-prescribed plan.

Both correct in their own way. No skill change.

## Refactor applied

None.
