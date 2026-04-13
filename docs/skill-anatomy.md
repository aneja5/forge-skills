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
