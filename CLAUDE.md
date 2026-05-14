# forge-skills

A planning-first skill library for Claude Code. Skills are structured workflows, not reference docs. Each skill encodes a specific engineering process that the agent follows step-by-step.

## Project Structure

```
forge-skills/
├── skills/                          # All skill definitions (one per directory)
│   ├── using-forge-skills/          # Meta-skill: skill discovery, pipeline, anti-rationalization
│   ├── idea-griller/                # Socratic interview → .forge/idea-brief.md
│   │   ├── SKILL.md
│   │   └── evaluation-criteria.md
│   ├── spec-driven-development/     # PRD via interview + codebase → .forge/prd.md
│   ├── architecture-and-contracts/  # System design + interface contracts → .forge/architecture.md + contracts/
│   ├── planning-and-task-breakdown/ # Task sizing + dependency graph → .forge/tasks.yaml
│   ├── incremental-implementation/  # Execute tasks.yaml one task at a time with TDD
│   ├── tdd/                         # Red-green-refactor with vertical slices
│   │   ├── SKILL.md
│   │   ├── deep-modules.md
│   │   ├── interface-design.md
│   │   ├── mocking.md
│   │   ├── refactoring.md
│   │   └── tests.md
│   ├── debugging-and-recovery/      # Reproduce → localize → fix → guard
│   ├── code-review-and-quality/     # Five-axis review with contract compliance
│   ├── git-workflow/                # Atomic commits, branch strategy, PR prep
│   ├── shipping-and-launch/         # Six-domain pre-launch gate
│   ├── triage-issue/                # Bug investigation → GitHub Issue + TDD fix plan
│   ├── competitive-analysis/        # Market research → .forge/competitive.md
│   ├── gtm-strategy/               # Go-to-market plan → .forge/gtm.md
│   ├── security-and-compliance/     # Security assessment → .forge/security.md
│   ├── scalability-analysis/        # Capacity planning → .forge/scalability.md
│   ├── cross-validation/            # External review → .forge/cross-validation-*.md
│   ├── redaction-and-cleanup/       # Redact for sharing → .forge/redacted/
│   ├── api-design/                  # REST conventions, error envelopes → .forge/api-design.md
│   ├── database-design/             # Schema + migrations → .forge/database-design.md + migrations-policy.md
│   ├── design-system/               # Tokens + components → .forge/design-system.md
│   ├── interaction-patterns/        # Modal/sheet/expand decisions → .forge/interaction-patterns.md
│   ├── parallel-execution-strategy/ # Multi-agent dispatch → .forge/parallel-plan.md
│   ├── seed-data-and-fixtures/      # Realistic data → .forge/seed-data.md
│   ├── testing-strategy/            # Test pyramid + coverage → .forge/testing-strategy.md
│   ├── error-handling-and-resilience/ # Retries + circuit breakers → .forge/error-handling.md
│   ├── observability/               # Logs + traces + alerts → .forge/observability.md
│   ├── performance-and-cost-optimization/ # Latency + cost budgets → .forge/performance-budget.md
│   ├── incident-response-and-postmortems/ # Severity + runbooks → .forge/incident-response.md
│   ├── accessibility/               # WCAG AA baseline → .forge/accessibility.md
│   ├── refactoring-and-tech-debt/   # Debt registry + strangler-fig → .forge/tech-debt-registry.md
│   ├── demo-narrative/              # Demo script + fallbacks → .forge/demo-narrative.md
│   ├── documentation-hygiene/       # README + changelog policy → .forge/docs-policy.md
│   ├── writing-skills/              # Meta-skill for contributors (TDD for skills)
│   ├── forge-sync/                  # Check .forge/ artifact freshness → .forge/sync-report.md
│   └── forge-migrate/               # Backfill forge:meta headers on legacy .forge/ files (in-place)
├── agents/                          # Specialist agent personas
│   ├── architect.md                 # System design, contracts, ADRs
│   ├── project-manager.md           # Task breakdown, dependency ordering
│   ├── test-engineer.md             # Test strategy, TDD coaching
│   ├── code-reviewer.md             # PR review, contract validation
│   ├── security-auditor.md          # Threat modeling, hardening
│   ├── competitive-analyst.md       # Market research, positioning
│   ├── compliance-officer.md        # Regulatory assessment, certification
│   ├── reliability-engineer.md      # Errors, observability, incidents, performance
│   ├── data-engineer.md             # Schema, migrations, query performance
│   ├── qa-engineer.md               # Test strategy, quality gates
│   └── design-engineer.md           # Visual system, interaction, accessibility
├── references/                      # Shared checklists linked from skills
│   ├── contract-templates.md        # Interface contract + ADR formats
│   ├── idea-evaluation.md           # Per-branch resolution criteria for idea-griller
│   ├── testing-patterns.md          # Good/bad tests, mocking rules, TDD patterns
│   ├── security-checklist.md        # OWASP checklist, severity levels
│   └── forge-dependency-graph.md    # Canonical .forge/ dependency tree (read by forge-sync)
├── commands/                        # 30 slash commands for the full lifecycle
│   ├── grill.md spec.md architect.md plan.md build.md review.md ship.md
│   ├── compete.md gtm.md secure.md scale.md validate.md redact.md
│   ├── api.md db.md design.md interaction.md
│   ├── parallel.md seed.md test-strategy.md
│   ├── errors.md observe.md perf.md incident.md
│   ├── a11y.md debt.md demo.md docs.md
│   └── sync.md
├── hooks/
│   ├── hooks.json                   # SessionStart hook configuration
│   └── session-start.sh             # Injects using-forge-skills at every session start
├── tests/                           # Pressure scenarios + RED/GREEN test results
│   ├── METHODOLOGY.md               # TDD-for-skills cycle
│   ├── idea-griller/                # Test scenarios and results
│   ├── architecture-and-contracts/
│   └── spec-driven-development/
├── docs/                            # Guides and explanations
├── install.sh                       # Single-skill installer
├── CLAUDE.md                        # This file
├── AGENTS.md                        # Intent-to-skill mapping for non-Claude-Code tools
└── README.md
```

## The .forge/ Handoff Chain

Skills produce and consume artifacts in `.forge/`:

```
.forge/idea-brief.md   ← idea-griller
.forge/prd.md          ← spec-driven-development  (reads idea-brief.md)
.forge/architecture.md ← architecture-and-contracts (reads prd.md)
.forge/contracts/*.md  ← architecture-and-contracts
.forge/adr/*.md        ← architecture-and-contracts
.forge/tasks.yaml      ← planning-and-task-breakdown (reads prd.md + architecture.md + contracts/)
.forge/tasks-summary.md ← planning-and-task-breakdown
.forge/competitive.md  ← competitive-analysis (reads prd.md)
.forge/gtm.md          ← gtm-strategy (reads prd.md + competitive.md)
.forge/security.md     ← security-and-compliance (reads architecture.md + contracts/)
.forge/scalability.md  ← scalability-analysis (reads architecture.md)
.forge/cross-validation-prompt.md    ← cross-validation (reads all .forge/ artifacts)
.forge/cross-validation-synthesis.md ← cross-validation (reads reviewer responses)
.forge/redaction-manifest.md         ← redaction-and-cleanup
.forge/redacted/       ← redaction-and-cleanup (copies, never modifies originals)
.forge/api-design.md           ← api-design
.forge/database-design.md      ← database-design
.forge/migrations-policy.md    ← database-design
.forge/design-system.md        ← design-system
.forge/interaction-patterns.md ← interaction-patterns
.forge/parallel-plan.md        ← parallel-execution-strategy (reads tasks.yaml)
.forge/seed-data.md            ← seed-data-and-fixtures
.forge/testing-strategy.md     ← testing-strategy
.forge/error-handling.md       ← error-handling-and-resilience
.forge/observability.md        ← observability
.forge/performance-budget.md   ← performance-and-cost-optimization
.forge/incident-response.md    ← incident-response-and-postmortems
.forge/accessibility.md        ← accessibility
.forge/tech-debt-registry.md   ← refactoring-and-tech-debt
.forge/demo-narrative.md       ← demo-narrative
.forge/docs-policy.md          ← documentation-hygiene
```

Never skip ahead without the previous artifact. You can join mid-pipeline if you have the artifact.

## Skills by Phase

| Phase   | Skill                        | Command    | Input                | Output                            |
|---------|------------------------------|------------|----------------------|-----------------------------------|
| Define  | idea-griller                 | /grill     | Raw idea             | .forge/idea-brief.md              |
| Specify | spec-driven-development      | /spec      | idea-brief.md        | .forge/prd.md                     |
| Design  | architecture-and-contracts   | /architect | prd.md               | architecture.md + contracts/ + adr/ |
| Plan    | planning-and-task-breakdown  | /plan      | prd.md + arch + contracts | .forge/tasks.yaml            |
| Build   | incremental-implementation   | /build     | tasks.yaml + contracts | code + commits                  |
| Build   | tdd                          | /build     | task acceptance criteria | passing tests                 |
| Verify  | debugging-and-recovery       | —          | bug description      | fix + regression test             |
| Review  | code-review-and-quality      | /review    | code change          | findings + merge decision         |
| Ship    | git-workflow                 | —          | completed tasks      | atomic commits + PR               |
| Ship    | shipping-and-launch          | /ship      | ready PR             | go/no-go decision                 |
| Triage  | triage-issue                 | —          | bug report           | GitHub issue + TDD plan           |
| Meta    | writing-skills               | —          | new skill / edit     | tested skill + scenarios + results|
| Analyze | competitive-analysis         | /compete   | prd.md               | .forge/competitive.md             |
| Analyze | gtm-strategy                 | /gtm       | prd.md + competitive.md | .forge/gtm.md                  |
| Analyze | security-and-compliance      | /secure    | architecture.md + contracts/ | .forge/security.md         |
| Analyze | scalability-analysis         | /scale     | architecture.md      | .forge/scalability.md             |
| Validate| cross-validation             | /validate  | .forge/ artifacts    | cross-validation-*.md             |
| Share   | redaction-and-cleanup        | /redact    | .forge/ artifacts    | .forge/redacted/                  |
| Design  | api-design                   | /api       | prd.md               | .forge/api-design.md              |
| Design  | database-design              | /db        | prd.md + architecture.md | .forge/database-design.md + migrations-policy.md |
| Design  | design-system                | /design    | prd.md               | .forge/design-system.md           |
| Design  | interaction-patterns         | /interaction | design-system.md   | .forge/interaction-patterns.md    |
| Plan    | parallel-execution-strategy  | /parallel  | tasks.yaml           | .forge/parallel-plan.md           |
| Plan    | seed-data-and-fixtures       | /seed      | architecture.md + database-design.md | .forge/seed-data.md     |
| Plan    | testing-strategy             | /test-strategy | prd.md           | .forge/testing-strategy.md        |
| Operate | error-handling-and-resilience | /errors   | architecture.md      | .forge/error-handling.md          |
| Operate | observability                | /observe   | architecture.md      | .forge/observability.md           |
| Operate | performance-and-cost-optimization | /perf | architecture.md      | .forge/performance-budget.md      |
| Operate | incident-response-and-postmortems | /incident | live incident or service list | .forge/incident-response.md |
| Polish  | accessibility                | /a11y      | UI surfaces          | .forge/accessibility.md           |
| Polish  | refactoring-and-tech-debt    | /debt      | codebase             | .forge/tech-debt-registry.md      |
| Polish  | demo-narrative               | /demo      | prd.md + seed-data.md | .forge/demo-narrative.md         |
| Polish  | documentation-hygiene        | /docs      | repo                 | .forge/docs-policy.md             |
| Sync    | forge-sync                   | /sync      | every .forge/ file   | .forge/sync-report.md             |
| Migrate | forge-migrate                | /forge-migrate | legacy .forge/ files (no headers) | in-place forge:meta backfill |

## Conventions

### Skill files

- Every skill lives in `skills/<name>/SKILL.md`
- Frontmatter: `name` (kebab-case), `description` (≤1024 chars, includes trigger phrases)
- Required sections: Overview, When to Use, When NOT to Use, Common Rationalizations, Red Flags, Core Process, Verification
- Keep SKILL.md under 150 lines — extract reference material to supporting files in the same directory
- Supporting files linked from SKILL.md with relative paths

### Agent personas

- One file per persona in `agents/`
- Frontmatter: `name`, `role`, `invoke_when`
- Each persona defines: responsibilities, how they think, how they push back, what they never do, output quality bar

### Reference files

- Shared checklists and templates in `references/`
- Skills link to references with relative paths: `../../references/contract-templates.md`
- References don't contain skill logic — they contain structured data (templates, checklists, examples)

### Slash commands

- Short files in `commands/`
- Frontmatter: `description` (one line, shown in command picker)
- Body: which skill to invoke + 5-15 lines of concrete instruction
- Commands align 1:1 with pipeline phases

### Hooks

- `hooks/hooks.json` — copy content into project's `.claude/settings.json` to activate
- `hooks/session-start.sh` — reads `skills/using-forge-skills/SKILL.md`, emits it as IMPORTANT context

## Boundaries

**This repo IS:**
- A collection of planning and development workflow skills for Claude Code and other agents
- Installable into any project via `install.sh`
- Designed to chain together into a full feature lifecycle via the .forge/ artifact chain

**This repo is NOT:**
- Project-specific business logic
- A framework or runtime — it's Markdown files and shell scripts
- A replacement for thinking — skills guide the thinking process, not bypass it

## Testing Skills

Skills are pressure-tested using TDD-for-skills methodology (see `tests/METHODOLOGY.md`):
- **RED** — run pressure scenario without skill, document failures verbatim
- **GREEN** — run with skill loaded, verify compliance
- **REFACTOR** — close any new rationalizations the agent invented

Tests live in `tests/<skill>/scenarios.md` (3+ scenarios) and `tests/<skill>/results.md` (verbatim outputs).

**Iron Law:** no skill ships without a failing test first. See `skills/writing-skills/SKILL.md` for the full contribution flow.

## Adding a New Skill

1. Read `skills/writing-skills/SKILL.md` first
2. Write `tests/<name>/scenarios.md` with 3+ pressure scenarios
3. Run RED — record verbatim subagent outputs in `tests/<name>/results.md`
4. Create `skills/<name>/SKILL.md` (under 150 lines, CSO-compliant description, all required sections)
5. Add supporting files to `skills/<name>/` if needed
6. Run GREEN — verify the skill closes the failures
7. REFACTOR until no new rationalizations appear
8. If it fits the pipeline, add a slash command in `commands/<name>.md`
9. Update skills tables in README.md and this file
10. Update `using-forge-skills/SKILL.md` discovery flowchart if the skill has a new trigger pattern
