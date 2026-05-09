# AGENTS.md

Forge Skills for AI coding agents. Skills encode structured engineering workflows — not reference docs. Every skill has a trigger, a process, and a verification gate.

## Core Rules

- If a task matches a skill, invoke the skill before doing anything else
- Skills are in `skills/<name>/SKILL.md`
- Never implement directly when a skill applies
- Follow skill steps in order — do not skip steps
- A task is not complete until the skill's Verification checklist passes

## Intent → Skill Mapping

```
Raw idea / haven't thought it through  →  idea-griller
Write a spec / PRD / requirements       →  spec-driven-development
Design system / write contracts         →  architecture-and-contracts
Break into tasks / plan implementation  →  planning-and-task-breakdown
Implement code / execute tasks          →  incremental-implementation
Need test-first discipline              →  tdd
Something broke / unexpected behavior  →  debugging-and-recovery
Review code / validate PR               →  code-review-and-quality
Commit / branch / prepare PR            →  git-workflow
Deploy / launch / pre-launch check      →  shipping-and-launch
Research competitors                    →  competitive-analysis
Analyze scalability / capacity          →  scalability-analysis
Security & compliance review            →  security-and-compliance
Plan go-to-market / find customers      →  gtm-strategy
Validate decisions externally           →  cross-validation
Redact before sharing                   →  redaction-and-cleanup
```

## Lifecycle Mapping

For tools that don't support slash commands, follow this internal lifecycle:

| Phase   | Skill                        | Trigger                              |
|---------|------------------------------|--------------------------------------|
| DEFINE  | idea-griller                 | Vague idea, needs pressure-testing   |
| SPECIFY | spec-driven-development      | Ready to formalize requirements      |
| DESIGN  | architecture-and-contracts   | .forge/prd.md exists                 |
| PLAN    | planning-and-task-breakdown  | .forge/architecture.md exists        |
| BUILD   | incremental-implementation   | .forge/tasks.yaml exists             |
| VERIFY  | debugging-and-recovery       | Something broke                      |
| REVIEW  | code-review-and-quality      | Code ready for review                |
| SHIP    | shipping-and-launch          | All tasks done, ready to deploy      |
| COMPETE | competitive-analysis         | PRD exists, entering a market        |
| SCALE   | scalability-analysis         | Architecture exists, need growth plan|
| SECURE  | security-and-compliance      | Handles sensitive data               |
| LAUNCH  | gtm-strategy                 | Product ready for market             |
| VALIDATE| cross-validation             | Major decisions need external input  |
| REDACT  | redaction-and-cleanup        | Sharing docs externally              |

## The .forge/ Artifact Chain

Each phase produces an artifact consumed by the next:

```
.forge/idea-brief.md    (idea-griller output)
         ↓
.forge/prd.md           (spec-driven-development output)
         ↓
.forge/architecture.md  (architecture-and-contracts output)
.forge/contracts/*.md
.forge/adr/*.md
         ↓
.forge/tasks.yaml       (planning-and-task-breakdown output)
         ↓
code + commits          (incremental-implementation output)

.forge/competitive.md              (competitive-analysis output)
.forge/scalability.md              (scalability-analysis output)
.forge/security.md                 (security-and-compliance output)
.forge/gtm.md                      (gtm-strategy output)
.forge/cross-validation-prompt.md  (cross-validation output, phase 1)
.forge/cross-validation-synthesis.md (cross-validation output, phase 2)
.forge/redaction-manifest.md       (redaction-and-cleanup output)
.forge/redacted/*                  (redaction-and-cleanup output)
```

A phase must not start without its input artifact. If the artifact is missing, run the preceding phase first.

## Anti-Rationalization

The following thoughts are wrong — do not act on them:

| Thought | Why it's wrong |
|---------|----------------|
| "This is too small for a skill" | Small tasks have the most unchecked assumptions |
| "I'll gather context first, then invoke the skill" | Skills tell you HOW to gather context — invoke first |
| "I remember this skill from before" | Skills evolve — always read the current SKILL.md |
| "The .forge/ artifact is close enough" | Missing artifacts break the handoff chain downstream |
| "I can skip architecture for a small feature" | Contracts protect parallel work — skip them and work diverges |
| "Tests can come after" | Then they test implementation shape, not behavior |

## Skill Directory Structure

```
skills/
  {skill-name}/
    SKILL.md          # Required — frontmatter + full skill anatomy
    *.md              # Optional supporting files (linked from SKILL.md)

agents/
  {persona}.md        # Specialist agent personas (invoked via Task tool)

references/
  *.md                # Shared checklists and templates (linked from skills)
```

## SKILL.md Frontmatter

```yaml
---
name: skill-name
description: One sentence. Include "Use when..." trigger phrases.
---
```

## Required Sections in Every SKILL.md

1. Overview (1-2 sentences)
2. When to Use
3. When NOT to Use
4. Common Rationalizations (table: thought | reality)
5. Red Flags
6. Core Process (numbered steps with verification gates)
7. Verification (checklist)

## Agent Personas

Specialist personas for dispatch via Task tool:

| Persona | File | Role |
|---------|------|------|
| Architect | `agents/architect.md` | System design, contracts, ADRs |
| Project Manager | `agents/project-manager.md` | Task breakdown, dependency ordering |
| Test Engineer | `agents/test-engineer.md` | TDD coaching, test quality review |
| Code Reviewer | `agents/code-reviewer.md` | PR review, contract validation |
| Security Auditor | `agents/security-auditor.md` | Threat modeling, hardening |
| Competitive Analyst | `agents/competitive-analyst.md` | Competitor research, positioning |
| Compliance Officer | `agents/compliance-officer.md` | Regulatory, privacy, certifications |
