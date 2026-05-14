# AGENTS.md

Forge Skills for AI coding agents. Skills encode structured engineering workflows — not reference docs. Every skill has a trigger, a process, and a verification gate.

## Core Rules

- If a task matches a skill, invoke the skill before doing anything else
- Skills are in `skills/<name>/SKILL.md`
- Never implement directly when a skill applies
- Follow skill steps in order — do not skip steps
- A task is not complete until the skill's Verification checklist passes
- Every skill ships with pressure-scenario tests in `tests/<name>/` (see `tests/METHODOLOGY.md`)

## Intent → Skill Mapping

Grouped by lifecycle phase.

### Define & specify

```
Raw idea / haven't thought it through    →  idea-griller
Write a spec / PRD / requirements        →  spec-driven-development
```

### Design

```
Design system / write contracts          →  architecture-and-contracts
Design REST endpoints / API contracts    →  api-design
Design schema / migrations               →  database-design
Establish design tokens / component lib  →  design-system
Decide modal vs sheet, expand vs nav     →  interaction-patterns
```

### Validate before building

```
Research competitors / positioning       →  competitive-analysis
Plan go-to-market / find customers       →  gtm-strategy
Will this scale / capacity math          →  scalability-analysis
Security & compliance review             →  security-and-compliance
Validate decisions externally            →  cross-validation
```

### Plan & build

```
Break into tasks / sprint plan           →  planning-and-task-breakdown
Implement code / execute tasks           →  incremental-implementation
Need test-first discipline               →  tdd
Define test pyramid + coverage targets   →  testing-strategy
Run multiple agents in parallel          →  parallel-execution-strategy
Need realistic demo / test data          →  seed-data-and-fixtures
```

### Operate, observe, respond

```
Handle errors well / resilience          →  error-handling-and-resilience
Add logging / monitoring / alerts        →  observability
Optimize performance or cost             →  performance-and-cost-optimization
Respond to incident / write postmortem   →  incident-response-and-postmortems
```

### Review, polish, ship

```
Something broke / unexpected behavior    →  debugging-and-recovery
Triage a bug / file an issue             →  triage-issue
Code ready for review                    →  code-review-and-quality
Commit / branch / prepare PR             →  git-workflow
Make it accessible (WCAG)                →  accessibility
Pay down tech debt                       →  refactoring-and-tech-debt
Keep docs from rotting                   →  documentation-hygiene
Write demo script + dry-run plan         →  demo-narrative
Deploy / launch / pre-launch check       →  shipping-and-launch
Redact before sharing externally         →  redaction-and-cleanup
Creating or editing a forge-skill        →  writing-skills
Check if artifacts are stale             →  forge-sync
Legacy .forge/ files lack headers        →  forge-migrate
```

## Lifecycle Mapping

For tools that don't support slash commands, follow this internal lifecycle:

| Phase     | Skill                              | Trigger                                                          |
|-----------|------------------------------------|------------------------------------------------------------------|
| GRILL     | idea-griller                       | Vague idea, needs pressure-testing                               |
| SPEC      | spec-driven-development            | Ready to formalize requirements                                  |
| DESIGN    | architecture-and-contracts         | `.forge/prd.md` exists                                           |
| INTERFACE | api-design                         | Touching endpoints or designing a new API surface                |
| DATA      | database-design                    | Touching schema, writing migrations, or reviewing queries        |
| LOOK      | design-system                      | Touching UI without established tokens                           |
| FEEL      | interaction-patterns               | Touching UX or deciding interaction shape                        |
| COMPETE   | competitive-analysis               | PRD exists, entering a market                                    |
| SCALE     | scalability-analysis               | Architecture exists, need growth plan                            |
| SECURE    | security-and-compliance            | System handles sensitive data                                    |
| LAUNCH    | gtm-strategy                       | Product ready for market                                         |
| VALIDATE  | cross-validation                   | Major decisions need external input                              |
| PLAN      | planning-and-task-breakdown        | `.forge/architecture.md` exists                                  |
| FORK      | parallel-execution-strategy        | 3+ independent tasks ready in `tasks.yaml`                       |
| FILL      | seed-data-and-fixtures             | Demoing, testing, or seeding dev environment                     |
| BUILD     | incremental-implementation         | `.forge/tasks.yaml` exists                                       |
| TDD       | tdd                                | Implementing a feature test-first within BUILD                   |
| VERIFY    | testing-strategy                   | Defining test approach for a new project or after a flake spike  |
| OPERATE   | error-handling-and-resilience      | Service is real, must not fail silently                          |
| OBSERVE   | observability                      | Service deployed; "how will I know" needs an answer              |
| TUNE      | performance-and-cost-optimization  | Hot path or LLM-heavy surface needs budgets                      |
| RESPOND   | incident-response-and-postmortems  | Something broke in production                                    |
| REPAY     | refactoring-and-tech-debt          | Third occurrence of a pattern, or before adjacent feature work   |
| INCLUDE   | accessibility                      | Any UI shipping to users                                         |
| TELL      | demo-narrative                     | Sales / investor demo coming up                                  |
| KEEP      | documentation-hygiene              | Repo >1 month old, doc rot visible                               |
| DEBUG     | debugging-and-recovery             | Something broke                                                  |
| TRIAGE    | triage-issue                       | Bug reported, needs investigation + GitHub issue                 |
| REVIEW    | code-review-and-quality            | Code ready for review                                            |
| GIT       | git-workflow                       | Committing, branching, or preparing a PR                         |
| SHIP      | shipping-and-launch                | All tasks done, ready to deploy                                  |
| REDACT    | redaction-and-cleanup              | Sharing docs externally                                          |
| SYNC      | forge-sync                         | Upstream artifact changed; check what's stale before re-building |
| MIGRATE   | forge-migrate                      | Upgraded across forge-skills versions; legacy .forge/ files lack headers |
| META      | writing-skills                     | Creating or editing a forge-skill                                |

## The .forge/ Artifact Chain

Each phase produces an artifact consumed by the next. The chain branches after `.forge/architecture.md` — multiple analytical and operational artifacts can be produced in parallel.

```
Phase 1 — Define & Specify
.forge/idea-brief.md            (idea-griller)
         ↓
.forge/prd.md                   (spec-driven-development)
         ↓
Phase 2 — Design (fans out)
.forge/architecture.md          (architecture-and-contracts)
.forge/contracts/*.md           (architecture-and-contracts)
.forge/adr/*.md                 (architecture-and-contracts)
.forge/api-design.md            (api-design)
.forge/database-design.md       (database-design)
.forge/migrations-policy.md     (database-design)
.forge/design-system.md         (design-system)
.forge/interaction-patterns.md  (interaction-patterns)

Phase 3 — Validate before building
.forge/competitive.md           (competitive-analysis)
.forge/scalability.md           (scalability-analysis)
.forge/security.md              (security-and-compliance)
.forge/gtm.md                   (gtm-strategy)
.forge/cross-validation-prompt.md    (cross-validation, phase 1)
.forge/cross-validation-synthesis.md (cross-validation, phase 2)

Phase 4 — Plan
.forge/tasks.yaml               (planning-and-task-breakdown)
.forge/tasks-summary.md         (planning-and-task-breakdown)
.forge/parallel-plan.md         (parallel-execution-strategy)
.forge/seed-data.md             (seed-data-and-fixtures)
.forge/testing-strategy.md      (testing-strategy)

Phase 5 — Build & operate
code + commits                  (incremental-implementation + tdd)
.forge/error-handling.md        (error-handling-and-resilience)
.forge/observability.md         (observability)
.forge/performance-budget.md    (performance-and-cost-optimization)
.forge/incident-response.md     (incident-response-and-postmortems)

Phase 6 — Polish & ship
.forge/accessibility.md         (accessibility)
.forge/tech-debt-registry.md    (refactoring-and-tech-debt)
.forge/demo-narrative.md        (demo-narrative)
.forge/docs-policy.md           (documentation-hygiene)

Phase 7 — Share externally
.forge/redaction-manifest.md    (redaction-and-cleanup)
.forge/redacted/*               (redaction-and-cleanup)

Cross-cutting — chain consistency
.forge/sync-report.md           (forge-sync — reads every .forge/ file + references/forge-dependency-graph.md)
(in-place header backfill)      (forge-migrate — writes forge:meta onto legacy .forge/ files; no new artifact)
```

Every artifact-producing skill prepends a `<!-- forge:meta -->` header to its output (`generated_by`, `generated_at`, `depends_on`, `content_hash`). The headers are the source of truth for `forge-sync`'s staleness check. See `references/forge-dependency-graph.md` for the canonical dependency tree.

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
| "Dark mode / a11y / observability can wait" | Retrofitting these costs 5-10x building them in |
| "We'll just merge at the end" | Merge conflicts compound — fix parallel-execution-strategy at dispatch time |

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

tests/
  {skill-name}/
    scenarios.md      # Pressure scenarios (RED/GREEN methodology)
    results.md        # Verbatim subagent outputs + REFACTOR notes
```

## SKILL.md Frontmatter

```yaml
---
name: skill-name
description: Use when... [triggering conditions only — never a workflow summary; see writing-skills for CSO rules]
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
| Reliability Engineer | `agents/reliability-engineer.md` | Errors, observability, incidents, performance |
| Data Engineer | `agents/data-engineer.md` | Schema, migrations, query performance |
| QA Engineer | `agents/qa-engineer.md` | Test strategy, quality gates |
| Design Engineer | `agents/design-engineer.md` | Visual system, interaction, accessibility |
