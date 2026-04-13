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
│   └── triage-issue/                # Bug investigation → GitHub Issue + TDD fix plan
├── agents/                          # Specialist agent personas
│   ├── architect.md                 # System design, contracts, ADRs
│   ├── project-manager.md           # Task breakdown, dependency ordering
│   ├── test-engineer.md             # Test strategy, TDD coaching
│   ├── code-reviewer.md             # PR review, contract validation
│   └── security-auditor.md          # Threat modeling, hardening
├── references/                      # Shared checklists linked from skills
│   ├── contract-templates.md        # Interface contract + ADR formats
│   ├── idea-evaluation.md           # Per-branch resolution criteria for idea-griller
│   ├── testing-patterns.md          # Good/bad tests, mocking rules, TDD patterns
│   └── security-checklist.md        # OWASP checklist, severity levels
├── .claude/
│   └── commands/                    # Slash commands for the full lifecycle
│       ├── grill.md                 # /grill → idea-griller
│       ├── spec.md                  # /spec → spec-driven-development
│       ├── architect.md             # /architect → architecture-and-contracts
│       ├── plan.md                  # /plan → planning-and-task-breakdown
│       ├── build.md                 # /build → incremental-implementation + tdd
│       ├── review.md                # /review → code-review-and-quality
│       └── ship.md                  # /ship → shipping-and-launch
├── hooks/
│   ├── hooks.json                   # SessionStart hook configuration
│   └── session-start.sh             # Injects using-forge-skills at every session start
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

- Short files in `.claude/commands/`
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

## Adding a New Skill

1. Create `skills/<name>/SKILL.md` with all required sections (see skill anatomy in docs/)
2. Add supporting files to `skills/<name>/` if needed
3. If it fits the pipeline, add a slash command in `.claude/commands/<name>.md`
4. Update the skills tables in README.md and this file
5. Keep SKILL.md under 150 lines
6. Update `using-forge-skills/SKILL.md` skill discovery flowchart if the skill has a new trigger pattern
