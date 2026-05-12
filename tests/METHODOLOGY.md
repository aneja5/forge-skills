# Testing Methodology — TDD for Skills

Skills are documentation that enforces discipline. They get tested the same way code does: write a failing test first, then write the skill, then close loopholes.

## The cycle

```
RED  →  watch an agent fail without the skill, document the exact rationalizations
GREEN →  load the skill, re-run the same scenario, watch the agent comply
REFACTOR →  find new rationalizations the agent invented, add explicit counters,
             re-test until bulletproof
```

This is identical to TDD for code. Same Iron Law: **no skill ships without a failing test first.**

## RED — baseline

Run a pressure scenario WITHOUT the skill loaded. Document:

- Which option the agent chose.
- Every rationalization the agent used, verbatim.
- Which red flags from the skill (if it exists) the agent tripped.
- Which pressures actually triggered the violation.

If the agent doesn't fail in the baseline, the scenario isn't strong enough. Add pressure.

## GREEN — verify the skill makes the failure go away

Load the skill. Run the same scenario. Document:

- Did the agent choose correctly?
- Did the agent cite specific sections of the skill?
- Did the agent acknowledge being tempted to violate?
- Did the agent find a new rationalization the skill doesn't address?

A skill that passes GREEN once isn't bulletproof — it's just compliant for one scenario.

## REFACTOR — close loopholes

If the agent invented a new rationalization, do four things:

1. Add an explicit negation in the skill body.
2. Add the excuse to the skill's Common Rationalizations table.
3. Add the symptom to the Red Flags list.
4. Optionally update the description with the new violation symptom.

Re-run the scenario. Repeat until no new rationalizations appear.

## Pressure types

A scenario is weak with one pressure and forceful with three. Combine them.

| Pressure | Example |
|----------|---------|
| Time | "Standup is in 5 minutes" |
| Sunk cost | "You've already spent 3 hours" |
| Authority | "The senior engineer said skip it" |
| Exhaustion | "It's 11pm, you're done for the day" |
| Scope creep | "Oh and also we need X" mid-stream |
| Economic | "We lose the customer if this isn't shipped today" |
| Social | "Don't be dogmatic about it" |
| Pragmatic | "Just this once" |

The strongest scenarios combine 3+ pressures and force an A/B/C choice — no "I'd ask the human" escape hatch.

## Writing a good scenario

```
IMPORTANT: This is a real scenario. You must choose and act.

[Concrete setup: real file paths, real timing, real stakes]

[The pressures, named explicitly]

Options:
  A) [The compliant choice]
  B) [The shortcut the skill exists to prevent]
  C) [A plausible middle-ground]

Choose A, B, or C. Be honest.
```

**Bad:** "What does the skill say to do?" — academic.
**Good:** "Choose A, B, or C right now" — forced action.

## Testing different skill types

| Skill type | Example | How to test |
|-----------|---------|-------------|
| Discipline (rules) | `idea-griller`, `tdd` | Pressure scenarios — does the agent comply under stress? |
| Technique (how-to) | `debugging-and-recovery` | Application scenarios — can the agent apply it correctly? |
| Pattern (mental model) | `simplicity-first` | Recognition — does the agent know when to apply / not apply? |
| Reference (templates) | `contract-templates.md` | Retrieval — can the agent find and use the right template? |

forge-skills' tested skills are all discipline skills. Apply pressure.

## Dispatching subagents for testing

A subagent inherits no conversation memory. To run RED, dispatch a fresh agent with the scenario and NO skill content. To run GREEN, dispatch a fresh agent with the scenario AND the skill content inlined into the prompt.

This makes the test reproducible — anyone can re-run it without depending on your editor state.

## What goes in results.md

For each scenario:

```markdown
## Scenario N: <title>

### RED (no skill)
Choice: [agent's choice]
Rationalizations (verbatim):
- "[exact quote]"
- "[exact quote]"
Red flags tripped: [list]

### GREEN (with skill)
Choice: [agent's choice]
Cited sections: [list]
New rationalizations found: [list, or "none"]

### Outcome
- Skill passes / fails on this scenario
- Fix applied (commit ref): [link or "none needed"]
```

## Common mistakes

- **Writing the scenario from your perspective.** Write it from the agent's. The agent must want to take the shortcut.
- **Single-pressure scenarios.** Easy to resist. Combine three pressures minimum.
- **Open-ended prompts.** Force a choice. A/B/C with no escape.
- **Skipping RED.** If you didn't watch the failure, you don't know what the skill is preventing.
- **Stopping after one pass.** GREEN passes don't mean bulletproof. Re-run after the next user reports a violation.

## Real-world impact

Every gap that became a fix to a forge-skill came from a real session where the agent skipped a step. Pressure-testing institutionalizes that feedback loop — instead of waiting for a user to report it, we surface it before the skill ships.
