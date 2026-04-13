# forge-skills

> An Agentic Engineering toolkit for AI coding agents. The human writes specs and architecture. Agents implement in parallel with contracts. Review gates enforce correctness.

Structured workflows that turn a raw idea into shipped code through 7 pipeline stages, 12 skills, and 5 specialist agent personas.

Andrej Karpathy's Agentic Engineering concept (Feb 2026) describes exactly this model: humans write the specs, architecture, and guardrails — AI agents implement in parallel — humans review. The `.forge/` artifact chain is the implementation: `prd.md` → `architecture.md` + `contracts/` → `tasks.yaml` → code.

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
 GRILL       SPEC       DESIGN       PLAN        BUILD      REVIEW      SHIP
┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐
│ Idea   │─▶│ PRD    │─▶│ Arch + │─▶│ Tasks  │─▶│ Code + │─▶│ 5-axis │─▶│ Launch │
│ Brief  │  │        │  │Contract│  │  .yaml │  │  TDD   │  │ Review │  │  Gate  │
└────────┘  └────────┘  └────────┘  └────────┘  └────────┘  └────────┘  └────────┘
/grill      /spec      /architect    /plan       /build     /review      /ship
```

> **Install:** `/plugin marketplace add aneja5/forge-skills` then `/plugin install forge-skills@forge-skills`

---

## Commands, Skills, and Artifacts

| Command | Phase | Skill | Reads | Produces |
|---------|-------|-------|-------|----------|
| `/grill` | Define | `idea-griller` | — | `.forge/idea-brief.md` |
| `/spec` | Specify | `spec-driven-development` | `idea-brief.md` | `.forge/prd.md` |
| `/architect` | Design | `architecture-and-contracts` | `prd.md` | `architecture.md` + `contracts/` + `adr/` |
| `/plan` | Plan | `planning-and-task-breakdown` | `prd.md` + `architecture.md` + `contracts/` | `.forge/tasks.yaml` |
| `/build` | Build | `incremental-implementation` + `tdd` | `tasks.yaml` + `contracts/` | code + commits |
| `/review` | Review | `code-review-and-quality` | code + `contracts/` | findings + decision |
| `/ship` | Ship | `shipping-and-launch` | ready code | go/no-go + rollback plan |
| — | Verify | `debugging-and-recovery` | bug report | fix + regression test |
| — | Ship | `git-workflow` | completed tasks | atomic commits + PR |
| — | Triage | `triage-issue` | bug report | GitHub issue + TDD plan |

Add `.forge/` to `.gitignore` for local-only, or commit it to share context across the team.

> **See [examples](docs/examples.md)** for before/after diffs of each pipeline stage.

---

<details>
<summary><b>Quick Start — Claude Code</b></summary>

**Marketplace install (recommended):**

```
/plugin marketplace add aneja5/forge-skills
/plugin install forge-skills@forge-skills
```

**Install one skill:**

```bash
curl -sL https://raw.githubusercontent.com/aneja5/forge-skills/main/install.sh | bash -s idea-griller
```

**Manual clone:**

```bash
git clone https://github.com/aneja5/forge-skills.git
cp -r forge-skills/skills ~/.claude/skills
cp -r forge-skills/agents ~/.claude/agents
cp -r forge-skills/commands ~/.claude/commands
```

**Enable the session-start hook** (optional — injects the pipeline at every session start):

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

</details>

<details>
<summary><b>Quick Start — Cursor / Gemini CLI / Other</b></summary>

**Cursor** — add to `.cursorrules`:

```bash
cat skills/using-forge-skills/SKILL.md > .cursorrules
```

**Gemini CLI:**

```bash
gemini skills install ./forge-skills/skills/
```

See [docs/cursor-setup.md](docs/cursor-setup.md) for Cursor, Gemini CLI, Windsurf, and other tools.

</details>

---

<details>
<summary><b>Agent Personas & Reference Checklists</b></summary>

### Agent Personas

| Persona | File | When to invoke |
|---------|------|----------------|
| Architect | `agents/architect.md` | System design, contracts, tech decisions |
| Project Manager | `agents/project-manager.md` | Task breakdown, dependency mapping |
| Test Engineer | `agents/test-engineer.md` | TDD coaching, test quality review |
| Code Reviewer | `agents/code-reviewer.md` | PR review, contract compliance |
| Security Auditor | `agents/security-auditor.md` | Threat modeling, OWASP review |

### Reference Checklists

| File | Used by |
|------|---------|
| `references/contract-templates.md` | architecture-and-contracts |
| `references/idea-evaluation.md` | idea-griller |
| `references/testing-patterns.md` | tdd, incremental-implementation, code-review-and-quality |
| `references/security-checklist.md` | shipping-and-launch, security-auditor |

</details>

<details>
<summary><b>Project Structure</b></summary>

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
├── commands/                        # /grill /spec /architect /plan /build /review /ship
├── hooks/
│   ├── hooks.json
│   └── session-start.sh
├── .claude-plugin/
│   ├── plugin.json                  # Plugin manifest
│   └── marketplace.json             # Marketplace listing
├── docs/
│   ├── getting-started.md
│   ├── skill-anatomy.md
│   ├── cursor-setup.md
│   ├── the-forge-pipeline.md
│   └── examples.md
├── install.sh
├── LICENSE
├── CLAUDE.md
└── AGENTS.md
```

</details>

---

## Contributing

1. Create `skills/<name>/SKILL.md` — follow the anatomy in [docs/skill-anatomy.md](docs/skill-anatomy.md)
2. Keep SKILL.md under 150 lines — extract templates/checklists to supporting files
3. Add a slash command in `commands/` if it fits the pipeline
4. Update the skills table in this README
5. Update `using-forge-skills/SKILL.md` if the skill has a new trigger pattern

---

## Credits & Inspiration

**Andrej Karpathy** — Behavioral principles (Think Before Coding, Simplicity First, Surgical Changes, Goal-Driven Execution) and the Agentic Engineering concept (Feb 2026) that frames the human-as-architect, AI-as-implementer model the forge pipeline embodies.

**Addy Osmani** ([agent-skills](https://github.com/addyosmani/agent-skills)) — Skill anatomy standard: frontmatter, When to Use / When NOT to Use, Common Rationalizations, Red Flags, Verification checklists. The anti-rationalization pattern is directly from his work.
