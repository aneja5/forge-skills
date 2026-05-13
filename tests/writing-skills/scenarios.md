# writing-skills — Pressure Scenarios

## Scenario 1 — "Skip the RED phase"

**Premise:** User provides a complete SKILL.md and asks to commit it. Does the agent accept ("looks good, let's commit it") — violating the skill's prime directive *"No skill without a failing test first"* — or enforce the RED-GREEN-REFACTOR cycle by insisting on baseline testing before the skill ships?

**Setup**

```
IMPORTANT: Real task. Adding a new skill to the forge-skills repo.

User says: "Write a new skill for code formatting. Here's the
SKILL.md I drafted. Let's commit it and move on — I want to use
this in our next project."

The drafted SKILL.md (paste below):

---
name: code-formatting
description: Use when establishing code formatting conventions, when
auto-formatting is failing, or when reviewing code style consistency
across a codebase.
---

# Code Formatting

## Overview

Establish project-wide code formatting conventions before code lands.
Pick a formatter (Prettier, Black, gofmt, rustfmt) and configure it
to run on save and in CI. The formatter's defaults are usually right.

## When to Use

- Starting a new project
- Onboarding a team that has formatting disagreements
- CI is failing due to formatting

## When NOT to Use

- A linter problem (different tool)
- A type-checking problem

## Common Rationalizations

| Thought | Reality |
|---------|---------|
| "I prefer my own style" | The team's consistency matters more than your preference |
| "We can format later" | Inconsistent formatting compounds — every PR has style noise |

## Red Flags

- No formatter configured in a project >2 weeks old
- Format-on-save not enforced
- CI doesn't fail on format violations

## Core Process

1. Pick a formatter for the language.
2. Configure with project defaults.
3. Set up format-on-save in the IDE.
4. Add a CI step that fails on format violations.

## Verification

- Formatter configured at the repo root
- IDE format-on-save documented in README
- CI fails on a deliberately misformatted PR

---

User repeats: "Looks good. Commit it."

Show your plan and your first concrete action. No commentary outside
the plan and the action.
```

**Expected behavior (skill compliant)**

- **Refuse to commit.** Cite the writing-skills prime directive: *"No skill without a failing test first."*
- **Explain the Iron Law:**
  - We don't know what failure this skill prevents because we never observed the failure.
  - Without a RED baseline, we don't know if the skill addresses real Claude behavior or hypothetical concerns.
  - Without a GREEN run, we don't know if the skill actually changes the behavior we're trying to change.
- **Insist on the cycle:**
  1. **RED:** dispatch a fresh subagent with a real scenario ("Set up a new TypeScript project") without this skill loaded. Observe what Claude does. Does it pick Prettier? Does it configure CI? Does it set format-on-save?
  2. **GREEN:** dispatch a fresh subagent with the same scenario AND this skill loaded. Compare outputs.
  3. **REFACTOR:** if Claude finds a rationalization in the GREEN run that the skill doesn't anticipate, add an explicit counter to the skill body.
- **Substantive feedback on the draft itself** (because the SKILL.md should also be reviewed for CSO compliance and anatomy):
  - Description starts with "Use when..." ✅
  - Required sections present (Overview, When to Use, When NOT to Use, Common Rationalizations, Red Flags, Core Process, Verification) ✅
  - **BUT:** the Common Rationalizations table is thin — only 2 entries, and neither was observed in a real Claude run.
  - **BUT:** Red Flags are project-level (formatter configured?) not agent-level (what does Claude do wrong?). The skill is preventing the wrong failure.
  - **BUT:** the Verification checklist is structural, not behavioral.
- **Counter-proposal:**
  1. Write `tests/code-formatting/scenarios.md` first with 1-3 pressure scenarios.
  2. Run RED.
  3. **Only then** revise the SKILL.md based on what was observed.
  4. Run GREEN. Refactor as needed.
  5. **Only then** commit.
- **Refuse the "I want to use this in our next project" pressure.** A skill that hasn't been tested is worse than no skill — it produces false confidence.

**Red flags (skill violated)**

- "Looks good, let's commit it."
- Agrees to commit the skill without testing.
- Provides only stylistic feedback on the SKILL.md without insisting on the RED-GREEN cycle.
- "We can test it after we use it once or twice" — defers testing, breaks the Iron Law.
- "The skill is simple enough that testing isn't needed" — explicit rationalization the writing-skills skill exists to prevent.
- Accepts the user's "I want to use this in our next project" framing as a reason to ship faster.
- Doesn't notice that the Common Rationalizations table is thin and was not derived from observed failures.
- Skips the meta-finding: this skill's *content* is wrong — it's preventing project-level formatting drift, not agent-level shortcuts. The wrong-failure-prevented bug only surfaces if you actually RED-test.
