---
name: write-a-prd
description: Create a PRD through user interview, codebase exploration, and module design, then submit as a GitHub issue. Use when user wants to write a PRD, create a product requirements document, or plan a new feature.
---

# Write a PRD

## Overview

Turn a feature idea into a GitHub issue PRD through structured interview, codebase exploration, and module design. Reads `.forge/idea-brief.md` if it exists (output of `idea-griller`) to skip already-answered questions.

## When to Use

- User wants to write a PRD or product requirements document
- User wants to plan a new feature from scratch
- User has a rough idea and wants to formalize it before implementation

## When NOT to Use

- Idea hasn't been pressure-tested yet — run `idea-griller` first
- Implementation has already started — PRD would be documenting history, not guiding work
- Change is trivial (single function, config tweak) — just use `tdd` or `triage-issue`

## Common Rationalizations

| Thought | Reality |
|---------|---------|
| "The feature is simple, we don't need a PRD" | Simple features grow. Write the scope down. |
| "I already know what to build" | The interview surfaces what you don't know you don't know |
| "We can figure out testing later" | Testing decisions made late are testing decisions skipped |
| "The codebase exploration is optional" | Skipping it produces PRDs with wrong module assumptions |
| "User stories take too long to write" | A thin story list produces thin acceptance criteria |

## Red Flags

- Problem statement is written from the engineer's perspective, not the user's
- User stories use passive voice ("the system shall") instead of actor/want/benefit format
- Out of Scope section is empty — everything is in scope until stated otherwise
- No testing decisions recorded — tests become an afterthought
- Module list names files instead of behaviors

## Core Process

### Step 0: Read the brief

Check if `.forge/idea-brief.md` exists. If it does, read it. Skip any discovery questions already answered. Only ask about gaps and open assumptions listed in the brief.

### Step 1: Understand the problem

If no brief exists, ask the user for a detailed description of the problem and any potential solutions they've considered.

### Step 2: Explore the codebase

Use the Agent tool to explore the repo. Verify the user's assertions. Understand current architecture, existing patterns, and where new modules would attach.

### Step 3: Interview to shared understanding

Interview the user about every aspect of the plan. Walk down each branch of the design tree, resolving dependencies between decisions one at a time. Don't proceed until ambiguities are resolved.

### Step 4: Design the modules

Sketch the major modules to build or modify. Look for opportunities to extract deep modules — small interface, deep implementation, testable in isolation. Confirm module list with the user. Ask which modules need tests.

### Step 5: Write and submit the PRD

Use the template below. Submit as a GitHub issue with `gh issue create`.

## PRD Template

```markdown
## Problem Statement
[The problem from the user's perspective — not the engineer's]

## Solution
[The solution from the user's perspective]

## User Stories
[Numbered list. Format: "As a <actor>, I want <feature>, so that <benefit>". Be extensive.]

## Implementation Decisions
[Modules to build/modify, interfaces, architectural decisions, schema changes, API contracts.
Do NOT include file paths or code snippets.]

## Testing Decisions
[What makes a good test here, which modules get tested, prior art in the codebase]

## Out of Scope
[Explicit list. If this section is empty, the PRD is incomplete.]

## Further Notes
[Anything that didn't fit above]
```

## Verification

Before submitting the GitHub issue, confirm:

- [ ] Brief read (if it existed) and gaps identified
- [ ] Codebase explored — assertions verified against real code
- [ ] All open assumptions from the brief addressed or re-noted
- [ ] Problem statement written from user's perspective
- [ ] User stories cover all acceptance criteria
- [ ] Out of Scope section is non-empty
- [ ] Module list confirmed with user
- [ ] Testing decisions recorded
- [ ] PRD submitted as GitHub issue — URL shared with user
