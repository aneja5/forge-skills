# forge-skills

> A planning-first engineering skill library for AI coding agents. From raw idea to shipped code — with contracts, TDD, and a pre-launch gate at every stage.

Skills are structured workflows, not reference docs. Each skill encodes the process a senior engineer follows. The agent follows the process — not its instincts.

---

## Your AI Engineering Team

Five specialist agents, available via the Task tool:

| Agent | Role |
|-------|------|
| **Architect** | System design, interface contracts, ADRs |
| **Project Manager** | Task breakdown, dependency ordering, scope management |
| **Test Engineer** | TDD coaching, test quality review, coverage gaps |
| **Code Reviewer** | PR review, contract validation, five-axis quality check |
| **Security Auditor** | Threat modeling, OWASP prevention, hardening |

Each agent has a defined role, push-back behavior, and quality bar. See `agents/` for the full personas.

---

## The Forge Pipeline

```
┌──────────┐   ┌──────────┐   ┌───────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐   ┌─────────┐
│  /grill  │──▶│  /spec   │──▶│ /architect│──▶│  /plan   │──▶│  /build  │──▶│ /review  │──▶│  /ship  │
└────┬─────┘   └────┬─────┘   └─────┬─────┘   └────┬─────┘   └────┬─────┘   └────┬─────┘   └────┬────┘
     │              │               │               │               │              │               │
     ▼              ▼               ▼               ▼               ▼              ▼               ▼
.forge/         .forge/        .forge/          .forge/        code +          review         go/no-go
idea-           prd.md         architecture.    tasks.yaml     commits         findings       decision
brief.md                       md                              + tests
                               .forge/
                               contracts/
                               .forge/adr/
```

Each stage produces an artifact. The next stage consumes it. You can join mid-pipeline if you already have the artifact.

---

## Slash Commands

| Command       | Skill(s)                        | Input                   | Output                          |
|---------------|---------------------------------|-------------------------|---------------------------------|
| `/grill`      | idea-griller                    | Raw idea (spoken)       | `.forge/idea-brief.md`          |
| `/spec`       | spec-driven-development         | idea-brief or idea      | `.forge/prd.md`                 |
| `/architect`  | architecture-and-contracts      | `.forge/prd.md`         | `.forge/architecture.md` + contracts/ + adr/ |
| `/plan`       | planning-and-task-breakdown     | prd + architecture      | `.forge/tasks.yaml`             |
| `/build`      | incremental-implementation + tdd| `.forge/tasks.yaml`     | code + commits                  |
| `/review`     | code-review-and-quality         | code change             | findings + merge decision       |
| `/ship`       | shipping-and-launch             | ready code              | go/no-go + rollback plan        |

---

## All Skills

| Phase   | Skill                          | What it does                                                          |
|---------|--------------------------------|-----------------------------------------------------------------------|
| Define  | `idea-griller`                 | 7-branch Socratic interview — pressure-tests a raw idea               |
| Specify | `spec-driven-development`      | Interview + codebase exploration → `.forge/prd.md`                    |
| Design  | `architecture-and-contracts`   | System design + interface contracts + ADRs                            |
| Plan    | `planning-and-task-breakdown`  | Sized, dependency-ordered vertical slices → `.forge/tasks.yaml`       |
| Build   | `incremental-implementation`   | Execute tasks one at a time, contract-aware, commit per task          |
| Build   | `tdd`                          | Red-green-refactor — behavior-first, vertical slices only             |
| Verify  | `debugging-and-recovery`       | Reproduce → localize → fix → regression test                         |
| Review  | `code-review-and-quality`      | Five-axis review + contract compliance validation                     |
| Ship    | `git-workflow`                 | Atomic commits, branch strategy, PR prep                              |
| Ship    | `shipping-and-launch`          | Six-domain pre-launch gate with go/no-go decision                    |
| Triage  | `triage-issue`                 | Bug investigation → GitHub Issue + TDD fix plan                       |
| Meta    | `using-forge-skills`           | Skill discovery flowchart + pipeline overview (injected at start)     |

---

## The .forge/ Artifact Chain

```
.forge/idea-brief.md    ← idea-griller
.forge/prd.md           ← spec-driven-development  (reads idea-brief)
.forge/architecture.md  ← architecture-and-contracts (reads prd)
.forge/contracts/*.md   ← architecture-and-contracts
.forge/adr/*.md         ← architecture-and-contracts
.forge/tasks.yaml       ← planning-and-task-breakdown (reads prd + arch + contracts)
code + commits          ← incremental-implementation (reads tasks + contracts)
```

Add `.forge/` to `.gitignore` for local-only, or commit it to share context across the team.

---

## Quick Start (Claude Code)

**Clone and link:**

```bash
git clone https://github.com/aneja5/forge-skills.git
cp -r forge-skills/skills ~/.claude/skills
cp -r forge-skills/agents ~/.claude/agents
cp -r forge-skills/.claude/commands ~/.claude/commands
```

**Install one skill:**

```bash
curl -sL https://raw.githubusercontent.com/aneja5/forge-skills/main/install.sh | bash -s idea-griller
```

**Enable the session-start hook** (recommended — injects the pipeline at every session start):

Copy `hooks/hooks.json` content into your project's `.claude/settings.json`.

**Start using:**

```
/grill    ← describe your idea
/spec     ← formalize requirements
/architect ← design the system
/plan     ← break into tasks
/build    ← implement (TDD)
/review   ← validate against contracts
/ship     ← pre-launch gate
```

---

## Quick Start (Cursor)

Add to `.cursorrules`:

```bash
cat skills/using-forge-skills/SKILL.md > .cursorrules
```

Or paste any SKILL.md into Cursor Notepad and reference it in your prompt.

See [docs/cursor-setup.md](docs/cursor-setup.md) for full setup including Gemini CLI and other tools.

---

## Agent Personas

| Persona | File | When to invoke |
|---------|------|----------------|
| Architect | `agents/architect.md` | System design, contracts, tech decisions |
| Project Manager | `agents/project-manager.md` | Task breakdown, dependency mapping |
| Test Engineer | `agents/test-engineer.md` | TDD coaching, test quality review |
| Code Reviewer | `agents/code-reviewer.md` | PR review, contract compliance |
| Security Auditor | `agents/security-auditor.md` | Threat modeling, OWASP review |

---

## Reference Checklists

| File | Used by |
|------|---------|
| `references/contract-templates.md` | architecture-and-contracts |
| `references/idea-evaluation.md` | idea-griller |
| `references/testing-patterns.md` | tdd, incremental-implementation, code-review-and-quality |
| `references/security-checklist.md` | shipping-and-launch, security-auditor |

---

## How is this different?

**vs. Addy's agent-skills:** forge-skills adds an explicit architecture phase with interface contracts — the differentiator for parallel implementation. It also has the full `.forge/` artifact chain and five specialist agent personas.

**vs. other skill libraries:** Most skill libraries are reference docs. Forge skills are workflows with verification gates, anti-rationalization tables, and explicit handoff artifacts. Skills can't be partially applied — the verification checklist defines done.

**vs. building your own orchestrator:** Zero Python. Zero YAML config. Zero infrastructure. Just Markdown files that any agent can read. The "orchestration" is the agent following the process.

---

## How Skills Work

Each `SKILL.md` has a fixed anatomy:

- **Frontmatter** — `name` + `description` with trigger phrases (used for skill discovery)
- **When to Use / When NOT to Use** — prevents misapplication
- **Common Rationalizations** — arguments an agent uses to skip steps, pre-rebutted
- **Red Flags** — observable signals something is going wrong
- **Core Process** — ordered steps with verification gates
- **Verification** — checkbox list; all must pass before the skill is "done"

Supporting files (templates, checklists, examples) live in the skill's directory and are linked from SKILL.md. This keeps SKILL.md under 150 lines and scannable.

See [docs/skill-anatomy.md](docs/skill-anatomy.md) for the full anatomy guide.

---

## Project Structure

```
forge-skills/
├── skills/                          # All skill definitions
│   ├── using-forge-skills/          # Meta-skill
│   ├── idea-griller/                # + evaluation-criteria.md
│   ├── spec-driven-development/
│   ├── architecture-and-contracts/
│   ├── planning-and-task-breakdown/
│   ├── incremental-implementation/
│   ├── tdd/                         # + deep-modules.md, mocking.md, tests.md, ...
│   ├── debugging-and-recovery/
│   ├── code-review-and-quality/
│   ├── git-workflow/
│   ├── shipping-and-launch/
│   └── triage-issue/
├── agents/                          # Specialist agent personas
│   ├── architect.md
│   ├── project-manager.md
│   ├── test-engineer.md
│   ├── code-reviewer.md
│   └── security-auditor.md
├── references/                      # Shared checklists and templates
│   ├── contract-templates.md
│   ├── idea-evaluation.md
│   ├── testing-patterns.md
│   └── security-checklist.md
├── .claude/
│   └── commands/                    # /grill /spec /architect /plan /build /review /ship
├── hooks/
│   ├── hooks.json
│   └── session-start.sh
├── docs/
│   ├── getting-started.md
│   ├── skill-anatomy.md
│   ├── cursor-setup.md
│   └── the-forge-pipeline.md
├── install.sh
├── CLAUDE.md
└── AGENTS.md
```

---

## Contributing

1. Create `skills/<name>/SKILL.md` — follow the anatomy in [docs/skill-anatomy.md](docs/skill-anatomy.md)
2. Keep SKILL.md under 150 lines — extract templates/checklists to supporting files
3. Add a slash command in `.claude/commands/` if it fits the pipeline
4. Update the skills table in this README
5. Update `using-forge-skills/SKILL.md` if the skill has a new trigger pattern
