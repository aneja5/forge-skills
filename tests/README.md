# forge-skills Tests

Pressure-scenario tests for forge-skills. The methodology is **TDD applied to skill documentation**, adapted from [Superpowers' writing-skills](https://github.com/obra/superpowers/tree/main/skills/writing-skills).

## Coverage

**33 of 34 skills tested** with RED/GREEN pressure scenarios.

The only untested skill is `using-forge-skills` — the meta-skill that routes between other skills. Pressure-testing the routing flowchart requires a different test format (does the agent pick the right skill?) than the failure-pattern scenarios used for the other 33. Not in scope for this pass.

## Layout

```
tests/
├── README.md                    # This file
├── METHODOLOGY.md               # The RED-GREEN-REFACTOR cycle for skills
└── <skill-name>/
    ├── scenarios.md             # 1+ pressure scenarios
    └── results.md               # RED (without skill) + GREEN (with skill) + REFACTOR notes
```

## How to run a test

Each `scenarios.md` is a self-contained scenario you can paste into a fresh Claude Code session.

1. **RED** — paste the scenario into a session **without the skill loaded**. Record verbatim what the agent does, every rationalization it uses, and which red flags it trips.
2. **GREEN** — paste the same scenario into a session **with the skill loaded**. Record whether the agent complies and which sections of the skill it cites.
3. **REFACTOR** — if the agent invents a new rationalization, add an explicit counter to the skill and re-test.

All results documented in `<skill-name>/results.md` with verbatim agent output.

## Meta-finding across all 33 scenarios

After running every skill through the cycle, the consistent pattern is:

- **Base Claude is strong on substance.** Across 33 scenarios, the specific failure pattern the skill was designed to prevent **did not manifest in RED** in most cases. Base Claude reaches for the right answer when given a real task with concrete details.
- **The skill's value is structural and citational.** GREEN consistently adds: the named `.forge/<skill>.md` artifact (so downstream skills can consume it), the prescribed section structure (so outputs are uniform), and citation discipline (so future readers can audit why a decision was made).
- **Two failure modes that DID manifest in RED:**
  - `tdd`: base Claude reaches for implementation-first, not test-first. The skill genuinely flips the order of operations.
  - `spec-driven-development`: scope creep into v1 (RED admitted Excel into MVP scope; GREEN moved it to Phase 4 + Out of Scope).
- **The "RED writes for the room, GREEN writes for the artifact chain" pattern** is consistent — RED often produces more rhetorically powerful output (ready to send to a CEO or investor), GREEN produces more structured artifacts (ready for downstream skills to consume).

The full results across 33 skills are in each `<skill-name>/results.md`. The story is: **the skill chain works as designed — not by unlocking new behavior, but by standardizing strong behavior into a downstream-readable contract.**

## Scenario weakness logged

Several scenarios were flagged as needing strengthening:
- `redaction-and-cleanup` — the "hypothetical, do not modify" framing protected the worktree but prevented full pressure testing of copy-first behavior.
- `architecture-and-contracts` and `error-handling-and-resilience` — listing failure modes upfront in the prompt removed the opportunity for the agent to under-prompt.
- `incremental-implementation`, `debugging-and-recovery`, `git-workflow` — subagent filesystem access let RED notice worktree mismatches and halt rather than fabricate; future versions should use a sandboxed worktree.

## Iron Law

> No skill ships without a failing test first.

Applies to new skills AND edits to existing skills. If you can't show the baseline failure that motivated the skill, you don't know if the skill prevents the right failure.

## Inspiration

Methodology lifted from Superpowers' [writing-skills](https://github.com/obra/superpowers/tree/main/skills/writing-skills) and [testing-skills-with-subagents](https://github.com/obra/superpowers/blob/main/skills/writing-skills/testing-skills-with-subagents.md).
