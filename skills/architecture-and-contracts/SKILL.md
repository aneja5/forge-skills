---
name: architecture-and-contracts
description: Design system architecture and write interface contracts from a PRD. Outputs .forge/architecture.md (system overview + tech decisions), .forge/contracts/ (per-module interface contracts precise enough for parallel implementation), and .forge/adr/ (architecture decision records). Use when .forge/prd.md exists and the system needs a structural design before task breakdown.
---

# Architecture and Contracts

## Overview

Read `.forge/prd.md` and produce three artifacts: a system architecture document, precise interface contracts per module boundary, and ADRs for non-obvious decisions. Contracts must be specific enough that two engineers can implement different modules independently and integrate without surprises.

## When to Use

- `.forge/prd.md` exists and is complete
- System has 2+ modules that need to interact
- Team will work in parallel — contracts prevent integration failures
- Non-obvious tech decisions need to be recorded with rationale

## When NOT to Use

- PRD doesn't exist yet — run `spec-driven-development` first
- Trivial change touching only one module — skip straight to `tdd`
- Architecture already exists and contracts are current — just update the affected contract

## Common Rationalizations

| Thought | Reality |
|---------|---------|
| "We don't need contracts for a small feature" | Contracts protect parallel workers — without them, work diverges |
| "I'll define interfaces as I implement" | Interfaces defined during implementation encode accidents as decisions |
| "ADRs are bureaucratic overhead" | ADRs are the only record of why — without them, decisions get relitigated |
| "The architecture is obvious from the PRD" | Make the obvious explicit — it's where disagreements hide |
| "I can keep the architecture in my head" | You can. Your parallel workers can't. |

## Red Flags

- Contracts written at function level instead of module boundary level
- Input/output types described in prose instead of typed schemas
- "Error handling: TBD" in any contract
- Architecture document names files and line numbers (these rot)
- ADR is missing a "Decision" section — only has "Context"
- `.forge/contracts/` has no files after this skill runs

## Core Process

### Step 1: Read the PRD

Read `.forge/prd.md`. Identify: module list, interaction points, data flows, NFRs that impose architectural constraints.

### Step 2: Explore existing architecture

If a codebase exists, explore it. Understand current patterns, tech stack, existing module boundaries. The architecture must fit the existing system unless the PRD explicitly calls for a rewrite.

### Step 3: Design the system

Produce a system overview:
- Component diagram (text-based: boxes and arrows)
- Tech stack decisions with rationale
- Data flow for the primary user journey
- Where each module from the PRD sits in the system

### Step 4: Write interface contracts

For each module boundary identified in the PRD, write a contract file at `.forge/contracts/<module-name>.md`. See [contract-templates.md](../../references/contract-templates.md).

Each contract must define:
- **Provides**: what this module exposes to callers
- **Consumes**: what this module depends on
- **Input types**: typed schemas for every input
- **Output types**: typed schemas for every output
- **Error types**: named error cases with conditions
- **Invariants**: guarantees the module always maintains
- **Not responsible for**: explicit out-of-scope list

### Step 5: Write ADRs

For each non-obvious decision made in steps 3-4, write an ADR at `.forge/adr/NNN-<slug>.md`. Use the format in [contract-templates.md](../../references/contract-templates.md).

### Step 6: Write architecture.md

Write `.forge/architecture.md` with system overview, component diagram, tech stack table, and a table of all contracts with their module names and file paths.

## Verification

- [ ] `.forge/prd.md` read in full
- [ ] Every module from the PRD has a contract in `.forge/contracts/`
- [ ] Every contract has input types, output types, error types, and invariants
- [ ] No contract says "TBD" in any required field
- [ ] Architecture document uses component names, not file paths
- [ ] At least one ADR written (even "use existing patterns" is a decision)
- [ ] `.forge/architecture.md` written with component diagram
- [ ] Contract table in architecture.md lists all contract files
