# forge-skills

> An Agentic Engineering toolkit for AI coding agents. The human writes specs and architecture. Agents implement in parallel with contracts. Review gates enforce correctness.

Structured workflows that turn a raw idea into shipped, operated, and demoed code through 7 pipeline stages, 35 skills, and 11 specialist agent personas. Every discipline-enforcing skill is pressure-tested against fresh subagents using TDD-for-skills methodology (see [Testing](#testing)).

Andrej Karpathy's Agentic Engineering concept (Feb 2026) describes exactly this model: humans write the specs, architecture, and guardrails — AI agents implement in parallel — humans review. The `.forge/` artifact chain is the implementation: `prd.md` → `architecture.md` + `contracts/` → `tasks.yaml` → code.

---

## Your AI Engineering Team

Eleven specialist agents, available via the Task tool:

| Agent | Role |
|-------|------|
| **Architect** | System design, interface contracts, ADRs |
| **Project Manager** | Task breakdown, dependency ordering, scope management |
| **Test Engineer** | TDD coaching, test quality review, coverage gaps |
| **Code Reviewer** | PR review, contract validation, five-axis quality check |
| **Security Auditor** | Threat modeling, OWASP prevention, hardening |
| **Competitive Analyst** | Market research, feature matrices, positioning |
| **Compliance Officer** | Regulatory assessment, data governance, certification |
| **Reliability Engineer** | Errors, observability, incidents, performance — the person who gets paged |
| **Data Engineer** | Schema, migrations, query performance, data integrity |
| **QA Engineer** | Test strategy, quality gates — the person who breaks things before users do |
| **Design Engineer** | Design system, interaction patterns, accessibility, visual quality |

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
>
> **New here?** Read [docs/HOW-TO-USE.md](docs/HOW-TO-USE.md) — a 10-minute walkthrough with copy-paste prompts for every skill.
>
> **Need patterns and a setup guide?** Read [docs/cookbook.md](docs/cookbook.md) — `Setup: Adding Forge to Your Project` plus situational patterns (greenfield, mid-project, brownfield, parallel, demo prep, incident).

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
| `/compete` | Analyze | `competitive-analysis` | `prd.md` | `.forge/competitive.md` |
| `/gtm` | Analyze | `gtm-strategy` | `prd.md` + `competitive.md` | `.forge/gtm.md` |
| `/secure` | Analyze | `security-and-compliance` | `architecture.md` | `.forge/security.md` |
| `/scale` | Analyze | `scalability-analysis` | `architecture.md` | `.forge/scalability.md` |
| `/validate` | Validate | `cross-validation` | `.forge/` artifacts | `.forge/cross-validation-*.md` |
| `/redact` | Share | `redaction-and-cleanup` | `.forge/` artifacts | `.forge/redacted/` |
| `/api` | Design | `api-design` | `prd.md` | `.forge/api-design.md` |
| `/db` | Design | `database-design` | `prd.md` + `architecture.md` | `.forge/database-design.md` + `migrations-policy.md` |
| `/design` | Design | `design-system` | `prd.md` | `.forge/design-system.md` |
| `/interaction` | Design | `interaction-patterns` | `design-system.md` | `.forge/interaction-patterns.md` |
| `/parallel` | Plan | `parallel-execution-strategy` | `tasks.yaml` | `.forge/parallel-plan.md` |
| `/seed` | Plan | `seed-data-and-fixtures` | `architecture.md` + `database-design.md` | `.forge/seed-data.md` |
| `/test-strategy` | Plan | `testing-strategy` | `prd.md` | `.forge/testing-strategy.md` |
| `/errors` | Operate | `error-handling-and-resilience` | `architecture.md` | `.forge/error-handling.md` |
| `/observe` | Operate | `observability` | `architecture.md` | `.forge/observability.md` |
| `/perf` | Operate | `performance-and-cost-optimization` | `architecture.md` | `.forge/performance-budget.md` |
| `/incident` | Operate | `incident-response-and-postmortems` | live incident or service inventory | `.forge/incident-response.md` |
| `/a11y` | Polish | `accessibility` | UI surfaces | `.forge/accessibility.md` |
| `/debt` | Polish | `refactoring-and-tech-debt` | codebase | `.forge/tech-debt-registry.md` |
| `/demo` | Polish | `demo-narrative` | `prd.md` + `seed-data.md` | `.forge/demo-narrative.md` |
| `/docs` | Polish | `documentation-hygiene` | repo | `.forge/docs-policy.md` |
| `/sync` | Cross-cutting | `forge-sync` | every `.forge/` file + dependency graph | `.forge/sync-report.md` |
| — | Verify | `debugging-and-recovery` | bug report | fix + regression test |
| — | Ship | `git-workflow` | completed tasks | atomic commits + PR |
| — | Triage | `triage-issue` | bug report | GitHub issue + TDD plan |
| — | Meta | `writing-skills` | new skill spec | tested skill + scenarios + results |

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
| Competitive Analyst | `agents/competitive-analyst.md` | Market research, positioning |
| Compliance Officer | `agents/compliance-officer.md` | Regulatory assessment, certification |
| Reliability Engineer | `agents/reliability-engineer.md` | Errors, observability, incidents, performance |
| Data Engineer | `agents/data-engineer.md` | Schema, migrations, query performance |
| QA Engineer | `agents/qa-engineer.md` | Test strategy, quality gates |
| Design Engineer | `agents/design-engineer.md` | Visual system, interaction, accessibility |

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
│   ├── triage-issue/
│   ├── competitive-analysis/
│   ├── gtm-strategy/
│   ├── security-and-compliance/
│   ├── scalability-analysis/
│   ├── cross-validation/
│   ├── redaction-and-cleanup/
│   ├── api-design/
│   ├── database-design/
│   ├── design-system/
│   ├── interaction-patterns/
│   ├── parallel-execution-strategy/
│   ├── seed-data-and-fixtures/
│   ├── testing-strategy/
│   ├── error-handling-and-resilience/
│   ├── observability/
│   ├── performance-and-cost-optimization/
│   ├── incident-response-and-postmortems/
│   ├── accessibility/
│   ├── refactoring-and-tech-debt/
│   ├── demo-narrative/
│   ├── documentation-hygiene/
│   ├── writing-skills/              # Meta-skill for contributors
│   └── forge-sync/                  # Check .forge/ artifact freshness
├── agents/                          # Specialist agent personas
│   ├── architect.md
│   ├── project-manager.md
│   ├── test-engineer.md
│   ├── code-reviewer.md
│   ├── security-auditor.md
│   ├── competitive-analyst.md
│   ├── compliance-officer.md
│   ├── reliability-engineer.md
│   ├── data-engineer.md
│   ├── qa-engineer.md
│   └── design-engineer.md
├── references/                      # Shared checklists and templates
│   ├── contract-templates.md
│   ├── idea-evaluation.md
│   ├── testing-patterns.md
│   └── security-checklist.md
├── commands/                        # 29 slash commands across the full lifecycle
├── hooks/
│   ├── hooks.json
│   └── session-start.sh
├── .claude-plugin/
│   ├── plugin.json                  # Plugin manifest
│   └── marketplace.json             # Marketplace listing
├── tests/                           # Pressure scenarios + RED/GREEN results
│   ├── METHODOLOGY.md
│   ├── idea-griller/
│   ├── architecture-and-contracts/
│   └── spec-driven-development/
├── docs/
│   ├── getting-started.md
│   ├── skill-anatomy.md
│   ├── cursor-setup.md
│   ├── the-forge-pipeline.md
│   ├── examples.md
│   └── HOW-TO-USE.md
├── install.sh
├── LICENSE
├── CLAUDE.md
└── AGENTS.md
```

</details>

---

## Testing

Skills are pressure-tested against fresh subagents using **TDD-for-skills** methodology adapted from [Superpowers' writing-skills](https://github.com/obra/superpowers/tree/main/skills/writing-skills):

- **RED** — run a pressure scenario on a fresh subagent without the skill. Document verbatim failures and rationalizations.
- **GREEN** — run the same scenario with the skill loaded. Verify compliance and cited sections.
- **REFACTOR** — close any new rationalizations the agent invented.

Test results live in `tests/<skill>/results.md`. See [tests/METHODOLOGY.md](tests/METHODOLOGY.md) for the full cycle and the [writing-skills](skills/writing-skills/SKILL.md) skill for contributors.

**Iron Law:** *No skill ships without a failing test first.*

---

## Contributing

1. Read `skills/writing-skills/SKILL.md` — it encodes the contribution flow
2. Create `tests/<name>/scenarios.md` first (3+ pressure scenarios)
3. Run RED — record verbatim subagent failures in `tests/<name>/results.md`
4. Write `skills/<name>/SKILL.md` (under 150 lines, CSO-compliant description, follow [docs/skill-anatomy.md](docs/skill-anatomy.md))
5. Run GREEN — verify the skill closes the failures
6. REFACTOR until no new rationalizations appear
7. Add slash command in `commands/` if it fits the pipeline
8. Update the skills table, `using-forge-skills` discovery flowchart, `install.sh`, and CLAUDE.md

---

## Credits & Inspiration

**Andrej Karpathy** — Behavioral principles (Think Before Coding, Simplicity First, Surgical Changes, Goal-Driven Execution) and the Agentic Engineering concept (Feb 2026) that frames the human-as-architect, AI-as-implementer model the forge pipeline embodies.

**Addy Osmani** ([agent-skills](https://github.com/addyosmani/agent-skills)) — Skill anatomy standard: frontmatter, When to Use / When NOT to Use, Common Rationalizations, Red Flags, Verification checklists. The anti-rationalization pattern is directly from his work.
