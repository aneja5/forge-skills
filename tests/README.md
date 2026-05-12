# forge-skills Tests

This directory contains pressure-scenario tests for forge-skills. The methodology is **TDD applied to skill documentation**, adapted from [Superpowers' writing-skills](https://github.com/obra/superpowers/tree/main/skills/writing-skills).

## What's tested

Skills that enforce discipline, that have compliance costs, or that an agent could rationalize away. Pure reference skills (templates, checklists) don't get pressure-tested — they get retrieval-tested.

| Skill | Why it's tested |
|-------|-----------------|
| `idea-griller` | Discipline skill — easy to skip drilling and accept vague answers |
| `architecture-and-contracts` | Discipline skill — easy to skip typed contracts under time pressure |
| `spec-driven-development` | Discipline skill — easy to skip the interview when the user "knows what they want" |

More skills get tests as gaps are discovered. See [METHODOLOGY.md](METHODOLOGY.md).

## Layout

```
tests/
├── README.md             # This file
├── METHODOLOGY.md        # The RED-GREEN-REFACTOR cycle for skills
└── <skill-name>/
    ├── scenarios.md      # 3+ pressure scenarios per skill
    └── results.md        # RED (without skill) + GREEN (with skill) + fixes
```

## How to run a test

Tests are run manually by dispatching subagents or pasting the scenario into a fresh Claude Code session.

1. **RED** — paste the scenario into a session **without the skill loaded**. Record verbatim what the agent does, every rationalization it uses, and which red flags it trips.
2. **GREEN** — paste the same scenario into a session **with the skill loaded**. Record whether the agent complies and which sections of the skill it cites.
3. **REFACTOR** — if the agent finds a new rationalization, add an explicit counter to the skill and re-test.

Results are written to `tests/<skill-name>/results.md` — one section per scenario, with verbatim agent output.

## The Iron Law

> No skill ships without a failing test first.

This applies to new skills AND edits to existing skills. If you can't show the baseline failure that motivated the skill, you don't know if the skill prevents the right failure.

## How a scenario gets into this directory

1. A skill ships and a real user finds it skipping a step under pressure.
2. Document the exact pressure (time, sunk cost, authority, exhaustion, scope creep).
3. Write a minimal scenario that reproduces the rationalization.
4. Add it to `tests/<skill>/scenarios.md`.
5. Re-test the skill against the new scenario — refactor if it fails.

## Inspiration

Methodology lifted from Superpowers' [writing-skills](https://github.com/obra/superpowers/tree/main/skills/writing-skills) and [testing-skills-with-subagents](https://github.com/obra/superpowers/blob/main/skills/writing-skills/testing-skills-with-subagents.md). forge-skills adapts the cycle for the .forge/ pipeline.
