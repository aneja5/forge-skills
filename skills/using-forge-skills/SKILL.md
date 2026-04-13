---
name: using-forge-skills
description: Discovers and invokes forge skills. Use when starting a session or when you need to discover which skill applies to the current task. This is the meta-skill that governs how all other forge skills are discovered and invoked.
---

# Using Forge Skills

## Overview

Forge Skills is a planning-first skill library for Claude Code. Skills encode structured workflows for the full feature lifecycle — from raw idea to shipped code. This meta-skill maps your current task to the right skill.

## Skill Discovery

```
Task arrives
    │
    ├── Raw idea, haven't thought it through? ───→ idea-griller
    ├── Ready to write a PRD? ───────────────────→ write-a-prd
    │   └── Have .forge/idea-brief.md? ──────────→ write-a-prd (reads brief)
    ├── Have a PRD, need a plan? ────────────────→ prd-to-plan
    ├── Have a plan, need issues? ───────────────→ prd-to-issues
    ├── Implementing a feature? ─────────────────→ tdd
    ├── Stress-testing a design? ────────────────→ grill-me
    └── Bug to investigate and fix? ─────────────→ triage-issue
```

## The Forge Pipeline

Skills chain together. Output of one feeds the next:

```
/grill   →   /spec    →   /plan    →   /build   →   /ship
   ↓             ↓            ↓            ↓            ↓
idea-griller  write-a-prd  prd-to-plan   tdd       pre-launch
   ↓             ↓            ↓            ↓
.forge/      GitHub       ./plans/     passing
idea-brief   Issue PRD    *.md         tests
.md
```

Each stage is optional if you're joining mid-pipeline. You don't need to start at `/grill` — but you must have the previous stage's output.

## Core Operating Behaviors

These apply at all times, regardless of which skill is active.

### 1. Surface Assumptions

Before implementing anything non-trivial, state your assumptions explicitly:

```
ASSUMPTIONS I'M MAKING:
1. [about scope]
2. [about architecture]
3. [about what's out of scope]
→ Correct me now or I'll proceed with these.
```

### 2. Push Back When Warranted

You are not a yes-machine. When an approach has problems:
- Name the issue directly
- Explain the concrete downside
- Propose an alternative
- Accept the user's decision if they override with full information

### 3. Enforce Simplicity

Before finishing any implementation, ask:
- Can this be done in fewer lines?
- Are these abstractions earning their complexity?
- Would a staff engineer say "why didn't you just..."?

### 4. Maintain Scope Discipline

Touch only what you're asked to touch. Do NOT:
- Refactor adjacent code as a side effect
- Add features not in the spec because they "seem useful"
- Delete code that seems unused without explicit approval
- Remove comments you don't understand

### 5. Verify, Don't Assume

Every skill includes a verification step. A task is not complete until verification passes. "It looks right" is not verification.

## Lifecycle Sequence

1. **Define** → `idea-griller` — pressure-test the idea
2. **Specify** → `write-a-prd` — PRD as GitHub issue
3. **Plan** → `prd-to-plan` — phased vertical slices
4. **Decompose** → `prd-to-issues` — independently-grabbable issues
5. **Build** → `tdd` — red-green-refactor, one behavior at a time
6. **Debug** → `triage-issue` — root cause → TDD fix plan
7. **Stress-test** → `grill-me` — challenge any design before committing

## Skill Rules

1. Check for an applicable skill before starting work — even a 1% chance means invoke it.
2. Skills are workflows, not suggestions. Follow steps in order.
3. Multiple skills can apply — use the lifecycle sequence to pick order.
4. When in doubt, start with a spec.

## Quick Reference

| Phase    | Skill           | Slash Command | Output                    |
|----------|-----------------|---------------|---------------------------|
| Define   | idea-griller    | /grill        | .forge/idea-brief.md      |
| Specify  | write-a-prd     | /spec         | GitHub Issue (PRD)        |
| Plan     | prd-to-plan     | /plan         | ./plans/*.md              |
| Decompose| prd-to-issues   | /plan         | GitHub Issues             |
| Build    | tdd             | /build        | Passing tests + code      |
| Debug    | triage-issue    | —             | GitHub Issue (bug + fix)  |
| Review   | grill-me        | /review       | Shared understanding      |
