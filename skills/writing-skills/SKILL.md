---
name: writing-skills
description: Use when creating a new forge-skill, editing an existing skill, when planning to contribute to forge-skills, when a session has produced a one-off prompt that should be promoted to a skill, or when verifying a skill works before deployment.
---

# Writing Skills

## Overview

**Writing a forge-skill IS test-driven development applied to documentation.**

You write a pressure scenario (test case), watch a fresh agent fail at it without the skill (RED), write the skill (production code), watch the agent comply (GREEN), then close loopholes the agent invents (REFACTOR).

Adapted from [Superpowers' writing-skills](https://github.com/obra/superpowers/tree/main/skills/writing-skills). See [tests/METHODOLOGY.md](../../tests/METHODOLOGY.md) for the full testing methodology.

## When to Use

- Creating a new skill in `skills/<name>/SKILL.md`
- Editing an existing skill's body, frontmatter, or supporting files
- Promoting a one-off prompt that's been used 3+ times into a reusable skill
- Verifying a skill works before opening a PR

## When NOT to Use

- Project-specific conventions — those go in CLAUDE.md, not a skill
- Pure reference material (templates, checklists) that doesn't enforce any rule — put it in `references/`
- One-off solutions to one-off problems

## The Iron Law

> **No skill ships without a failing test first.**

Applies to **new skills AND edits**. If you can't show the baseline failure that motivated the skill, you don't know if the skill prevents the right failure.

Wrote the skill before running the test? Delete it. Start over. **No exceptions:**
- Not for "simple additions"
- Not for "just adding a section"
- Not for "documentation updates"
- Don't keep the un-tested draft as reference

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "It's just a documentation file, no need to test" | Untested skills have unstated assumptions. Test catches them. |
| "I'm just adding a rationalization to the table" | New rationalizations come from real session failures. If you didn't see one, don't add one. |
| "The skill is obviously clear to me" | Clear to you ≠ clear to a fresh agent. Test it. |
| "I'll test if a user reports a problem" | By then the skill has already shipped broken. Test first. |
| "Three pressures is too many for one scenario" | One pressure agents resist easily. Three pressures forces the genuine choice. |
| "RED passed but that means the skill works" | RED passing means the scenario isn't strong enough OR the skill prevents nothing useful. |

## Red Flags

- A skill landed without a `tests/<name>/results.md`
- The description summarizes the workflow ("Generate a contract by reading the PRD and writing files in .forge/contracts/")
- The skill has no Common Rationalizations table
- Verification checklist items are subjective ("output is good")
- A skill is longer than 150 lines without a supporting-file split
- A rationalization was added without a corresponding scenario showing the rationalization in the wild

## RED-GREEN-REFACTOR for forge-skills

### RED — write the failing test first

Write 3 pressure scenarios at `tests/<skill-name>/scenarios.md`. Each scenario must:
- State the premise (1-2 sentences).
- Provide the setup verbatim — exactly what the subagent will see.
- Apply 3+ pressures: time, sunk cost, authority, exhaustion, scope creep, economic, social, pragmatic.
- Force a choice — no "I'd ask the user" escape hatch.
- Define expected behavior (compliant) and red flags (violated).

Dispatch a fresh `general-purpose` subagent with the scenario and **no skill content**. Record:
- Exact choice / output.
- Verbatim rationalizations.
- Red flags tripped.

If the subagent doesn't fail, the scenario is too weak. Strengthen pressure and re-run.

### GREEN — write the minimal skill

Write `skills/<name>/SKILL.md` addressing **only** the failures you observed in RED. Don't speculate about other failures.

Required sections:
- Frontmatter: `name` (kebab-case) + `description` (CSO-compliant — triggers only, see [CSO Rules](#cso-rules) below).
- Overview (1-2 paragraphs).
- When to Use / When NOT to Use.
- Common Rationalizations table (every excuse you saw in RED).
- Red Flags list.
- Core Process (numbered steps).
- Verification checklist (objective, not subjective).

Keep under 150 lines. Extract heavy templates/checklists to supporting files in the same directory.

Dispatch a fresh subagent with the scenario AND the skill content inlined. Record:
- Did the agent comply?
- Did it cite the skill?
- Did it acknowledge being tempted to violate?
- Did it invent a NEW rationalization?

### REFACTOR — close loopholes

For each new rationalization the agent invented:
1. Add an explicit negation in the body ("Don't X. Don't Y. Don't keep it as reference.").
2. Add the excuse to the Common Rationalizations table.
3. Add the symptom to the Red Flags list.
4. Optionally update the description with the new violation symptom.

Re-run the scenario. Repeat until no new rationalizations appear.

## CSO Rules for the Description

The `description` field decides whether future Claude loads the skill. Rules:

- Start with "Use when..." and list **triggers only** (situations, symptoms, contexts).
- **Never** summarize the workflow, steps, or outputs.
- Stay under ~500 chars; use third-person framing.

**Why:** [Superpowers found](https://github.com/obra/superpowers/blob/main/skills/writing-skills/SKILL.md#claude-search-optimization-cso) that workflow-summarizing descriptions create a shortcut Claude follows *instead of* reading the skill body. Triggers-only descriptions force the load.

Bad: *"Generate a PRD by interviewing the user. Outputs .forge/prd.md."*
Good: *"Use when user wants to write a spec, when idea-brief.md exists and is ready to formalize, or when requirements need capture before architecture."*

## Core Process

1. **Pick the gap.** A real session showed the agent skipping a step, or a user reported a missed case. Document what happened.
2. **Write 3 scenarios** at `tests/<skill>/scenarios.md` — each with 3+ pressures.
3. **Run RED.** Dispatch fresh subagents without the skill. Record verbatim outputs in `tests/<skill>/results.md`.
4. **Write the skill** at `skills/<skill>/SKILL.md` with all required sections. CSO-compliant description.
5. **Run GREEN.** Dispatch fresh subagents with the skill inlined. Record compliance + cited sections.
6. **REFACTOR.** For every new rationalization, add explicit counters. Re-test.
7. **Document.** Append RED + GREEN + REFACTOR to `results.md`. Note any skill changes.
8. **Update meta-skill.** If the skill has a new trigger pattern, add it to `skills/using-forge-skills/SKILL.md`'s discovery flowchart.
9. **Add slash command** if the skill fits the pipeline (`commands/<skill>.md`).
10. **Update references** — README skill table, CLAUDE.md, install.sh, AGENTS.md.

## Verification

- [ ] `tests/<skill>/scenarios.md` exists — 3+ scenarios, each with 3+ pressures
- [ ] `tests/<skill>/results.md` documents RED + GREEN outputs verbatim (with rationalizations + cited sections)
- [ ] Description starts with "Use when..." — no workflow summary
- [ ] Skill body under 150 lines (extract heavy reference if not)
- [ ] Common Rationalizations table populated from observed RED rationalizations
- [ ] Verification checklist items are objective (file exists, section non-empty, count >= N)
- [ ] No new rationalizations in latest GREEN run
- [ ] Skill registered in `using-forge-skills` discovery flowchart
- [ ] README, CLAUDE.md, install.sh updated

## Reference

Full methodology: [tests/METHODOLOGY.md](../../tests/METHODOLOGY.md). Worked examples: `tests/idea-griller/results.md`, `tests/spec-driven-development/results.md`. Origin: [obra/superpowers writing-skills](https://github.com/obra/superpowers/tree/main/skills/writing-skills).
