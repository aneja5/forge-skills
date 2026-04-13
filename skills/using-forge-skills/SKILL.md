---
name: using-forge-skills
description: Discovers and invokes forge skills. Use when starting a session or when you need to discover which skill applies to the current task. This is the meta-skill that governs how all other forge skills are discovered and invoked.
---

# Using Forge Skills

## Overview

Forge Skills is a planning-first engineering skill library. Skills encode structured workflows — not reference docs. This meta-skill maps your task to the right skill and explains the full .forge/ handoff chain.

## Skill Discovery

```
Task arrives
    │
    ├── Raw idea, not yet pressure-tested? ────────→ idea-griller
    ├── Ready to write a spec/PRD? ────────────────→ spec-driven-development
    │     └── .forge/idea-brief.md exists? ─────────→ (read it, skip answered questions)
    ├── Have .forge/prd.md, need architecture? ────→ architecture-and-contracts
    ├── Have architecture, need tasks? ────────────→ planning-and-task-breakdown
    ├── Have .forge/tasks.yaml, implementing? ─────→ incremental-implementation
    │     └── Need test-first discipline? ──────────→ tdd
    ├── Something broke or behaves wrong? ─────────→ debugging-and-recovery
    ├── Code ready for review? ────────────────────→ code-review-and-quality
    ├── Committing / branching? ───────────────────→ git-workflow
    ├── Deploying or launching? ───────────────────→ shipping-and-launch
    └── Stress-testing a design? ──────────────────→ (relentless questioning — ask one branch per turn)
```

## The Forge Pipeline

```
/grill  →  /spec   →  /architect  →  /plan   →  /build  →  /review  →  /ship
  │           │            │            │           │           │          │
idea-      spec-      architecture-  planning-  incremental  code-     shipping-
griller    driven     and-contracts  and-task-  implement-   review-   and-launch
           develop-                  breakdown  ation        and-
           ment                                             quality
  │           │            │            │           │
  ▼           ▼            ▼            ▼           ▼
.forge/    .forge/    .forge/arch-  .forge/    passing
idea-      prd.md     itecture.md   tasks.yaml tests +
brief.md              .forge/                  commits
                      contracts/*
                      .forge/adr/*
```

Each stage consumes the previous stage's artifact. You can join mid-pipeline if you have the artifact.

## The .forge/ Handoff Chain

| Artifact | Produced by | Consumed by |
|----------|-------------|-------------|
| `.forge/idea-brief.md` | idea-griller | spec-driven-development |
| `.forge/prd.md` | spec-driven-development | architecture-and-contracts, planning-and-task-breakdown |
| `.forge/architecture.md` | architecture-and-contracts | planning-and-task-breakdown, incremental-implementation |
| `.forge/contracts/*.md` | architecture-and-contracts | incremental-implementation, code-review-and-quality |
| `.forge/adr/*.md` | architecture-and-contracts | (reference for all future decisions) |
| `.forge/tasks.yaml` | planning-and-task-breakdown | incremental-implementation |

## Agent Team

Five specialist personas available via the Task tool or dispatch:

| Agent | File | When to invoke |
|-------|------|----------------|
| **Architect** | `agents/architect.md` | Designing system structure, evaluating tech decisions |
| **Project Manager** | `agents/project-manager.md` | Task breakdown, dependency ordering, scope management |
| **Test Engineer** | `agents/test-engineer.md` | Test strategy, TDD coaching, coverage gaps |
| **Code Reviewer** | `agents/code-reviewer.md` | PR review, contract validation, quality gates |
| **Security Auditor** | `agents/security-auditor.md` | Threat modeling, input validation, hardening |

## Core Operating Behaviors

Apply at all times, across all skills. Behaviors 1, 4, 5, and 6 are grounded in Andrej Karpathy's principles for LLM coding and his Agentic Engineering concept (Feb 2026).

### 1. Surface Assumptions *(Karpathy: Think Before Coding)*

Before implementing anything non-trivial:

```
ASSUMPTIONS I'M MAKING:
1. [about requirements]
2. [about architecture]
3. [about scope]
→ Correct me now or I'll proceed with these.
```

### 2. Manage Confusion Actively

When you encounter inconsistencies: STOP. Name the confusion. Present the tradeoff. Wait for resolution. Never silently pick one interpretation.

### 3. Push Back When Warranted

You are not a yes-machine. Name issues directly, explain concrete downside, propose an alternative, accept the human's decision if they override with full information.

### 4. Enforce Simplicity *(Karpathy: Simplicity First)*

Before finishing: Can this be done in fewer lines? Are these abstractions earning their complexity? Would a staff engineer say "why didn't you just..."?

### 5. Maintain Scope Discipline *(Karpathy: Surgical Changes)*

Touch only what you're asked to touch. Do NOT refactor adjacent code, add unasked features, delete code without approval, or remove comments you don't understand.

### 6. Verify, Don't Assume *(Karpathy: Goal-Driven Execution)*

Every skill includes a verification checklist. A task is not complete until verification passes. "It looks right" is not verification.

## Lifecycle Sequence

1. **Define** → `idea-griller` — pressure-test the idea, output `.forge/idea-brief.md`
2. **Specify** → `spec-driven-development` — PRD, output `.forge/prd.md`
3. **Design** → `architecture-and-contracts` — system design + interface contracts
4. **Plan** → `planning-and-task-breakdown` — output `.forge/tasks.yaml`
5. **Build** → `incremental-implementation` + `tdd` — one task at a time
6. **Verify** → `debugging-and-recovery` — reproduce → isolate → fix → guard
7. **Review** → `code-review-and-quality` — validate against contracts
8. **Ship** → `git-workflow` + `shipping-and-launch` — clean history, pre-launch gate

## Anti-Rationalization

| Thought | Why it's wrong |
|---------|----------------|
| "This is too simple for a skill" | Simple tasks are where unchecked assumptions cause the most waste |
| "I'll gather context first, then check skills" | Skills tell you HOW to gather context — check first |
| "I remember this skill" | Skills evolve. Always read the current version. |
| "The brief/PRD is close enough" | Missing artifacts break the handoff chain downstream |
| "I can skip architecture for a small feature" | Contracts protect parallel workers — skip them and work diverges |
| "Tests can come after the implementation" | Then they test implementation, not behavior |
| "I'll clean up the adjacent code while I'm here" | Scope creep disguised as helpfulness |

## Red Flags

- Starting implementation without a `.forge/prd.md`
- Writing tests after all implementation code is done
- Module list names files instead of behaviors
- Contracts written at function-level instead of module-boundary level
- Tasks in `.forge/tasks.yaml` that touch more than 2-3 modules
- PR that touches files not listed in the task's file list
- "Out of Scope" section in the PRD is empty

## Skill Rules

1. Check for an applicable skill before starting work — even a 1% chance.
2. Skills are workflows, not suggestions. Follow steps in order.
3. Multiple skills can apply — use the lifecycle sequence to choose order.
4. When in doubt, start with a spec.

