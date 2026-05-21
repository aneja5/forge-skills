# Skill Anatomy

Every SKILL.md in this library follows the same structure. This document explains each section and the principles behind it.

## Why Structure Matters

A skill without structure is just advice. Agents follow advice inconsistently — they apply it when convenient and rationalize past it when pressed. Structure forces process: you can't skip a step you haven't done, you can't claim done when the verification checklist isn't checked.

The anatomy below is designed to make three things hard to rationalize away:
1. Starting the wrong way (When NOT to Use)
2. Skipping uncomfortable steps (Common Rationalizations)  
3. Declaring victory prematurely (Verification checklist)

## Required Sections

### Frontmatter

```yaml
---
name: skill-name           # kebab-case, matches directory name
description: One sentence. Include "Use when..." trigger phrases so skill discovery works.
---
```

The description is used for skill discovery. It must include the trigger conditions.

### Overview

1-2 sentences: what this skill does and what it produces. No process here — just the purpose and the output artifact.

### When to Use

Bulleted list of specific situations. Each bullet should be concrete enough that an agent can match it to the current situation. Avoid vague triggers like "when building features."

### When NOT to Use

Equally important. List the situations where invoking this skill is a mistake — including the "looks similar but isn't" cases. This prevents the skill from being applied to every situation.

### Common Rationalizations

A table with two columns: **Thought** (the rationalization) and **Reality** (the rebuttal).

This section exists because agents skip steps. They don't skip them randomly — they skip them using specific arguments. This table names those arguments in advance and pre-rebuts them. When Claude thinks "this is too simple for a spec," the table says "Simple features grow. Write the scope down."

Write the rationalizations as first-person thoughts an agent might have. The rebuttals should be sharp and specific.

### Red Flags

A bulleted list of observable signals that something is going wrong. These are pattern-matches the agent can check during execution. Each red flag should be falsifiable — either the signal is present or it isn't.

Good: "Out of Scope section in the PRD is empty"
Bad: "The specification isn't thorough enough"

### Core Process

Numbered steps. Each step is an action, not a description. Use imperative verbs: "Read", "Write", "Ask", "Confirm".

Include verification gates inside steps where needed: "Before proceeding to Step 4, confirm X with the user."

Do not include optional steps. If a step is optional, explain the condition for skipping it.

### Verification

A checkbox list. Every item is falsifiable — either you can check the box or you can't.

Bad: "The spec is complete"
Good: "Out of Scope section is non-empty"
Good: "`.forge/prd.md` written and readable"

The verification list is the definition of done. If the list is vague, done is vague.

### Fit-Check (the meta-honesty step)

After Verification, every skill emits **one** of:

- **"No fit issues observed for this use case."** (one line, explicit)
- A short list of specific fit issues: places where the skill felt too heavy, too light, or wrong-shaped for the work that just happened.

The fit-check exists because skills are general but invocations are specific. A skill that worked perfectly for ten projects can be the wrong tool for the eleventh — and the agent will still produce an artifact if it just follows the steps. The fit-check forces the agent to step back and answer *"was this the right skill for what just happened?"* before declaring done.

Examples of fit issues an agent might report:

- "PRD generation produced 800 lines for what turned out to be a 50-line config tweak — too heavy for this use case; recommend `incremental-implementation` directly next time."
- "Architecture-and-contracts emitted 6 contracts but only 2 modules are actually being changed; consider skipping for single-module work."
- "The skill assumed multi-tenant SaaS; this is an internal admin tool — see issue #40 for non-SaaS conditional sections."
- "Auto-trigger fired this skill but the actual work was a debugging task; `debugging-and-recovery` would have been correct."

Silence is not the answer. If there are no fit issues, say so explicitly. The absence of fit-check output is itself a red flag — it means the agent didn't reflect.

This was promoted from cultural property to convention after the v3.2.0 dry-run (issue #35) — five of seven skills self-reported limitations spontaneously; the uneven application motivated making it mandatory.

## Supporting Files

Keep SKILL.md under 150 lines. If content is growing past that:

1. Move reference material (examples, templates, checklists) to a supporting file in the same directory
2. Link from SKILL.md with a relative path: `See [evaluation-criteria.md](evaluation-criteria.md)`
3. Keep process and structure in SKILL.md; move data and templates out

## Principles

**Process over knowledge**: Skills should tell the agent what to DO, not just what to KNOW. "Read the PRD" is a step. "A PRD contains requirements" is knowledge — put it in a reference file if needed.

**Specificity**: Vague instructions produce vague results. "Interview the user" → "Ask the user about edge cases, error paths, and what the feature does NOT do."

**Evidence in verification**: Verification items must be checkable against observable artifacts, not against intentions. "The user was interviewed" is not checkable. ".forge/prd.md exists and is non-empty" is checkable.

**Counter-arguments**: The Common Rationalizations and Red Flags sections exist to anticipate and preempt failure modes. Write them from the perspective of an agent actively trying to take shortcuts.

**Token efficiency**: Agents work with limited context. Every word in SKILL.md competes with code and conversation. Be concise. Cut anything that doesn't change agent behavior.
