# forge-skills

A planning-first skill library for Claude Code. Skills are structured workflows — not reference docs. Each skill encodes a specific process an agent follows step-by-step to go from raw idea to shipped code.

---

## The Forge Pipeline

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   /grill    │────▶│   /spec     │────▶│   /plan     │────▶│   /build    │────▶│   /ship     │
│             │     │             │     │             │     │             │     │             │
│ idea-griller│     │ write-a-prd │     │ prd-to-plan │     │     tdd     │     │  checklist  │
│             │     │             │     │ prd-to-issues│    │             │     │             │
└──────┬──────┘     └──────┬──────┘     └──────┬──────┘     └──────┬──────┘     └─────────────┘
       │                   │                   │                   │
       ▼                   ▼                   ▼                   ▼
.forge/idea-         GitHub Issue          ./plans/           passing tests
brief.md               (PRD)               *.md               + code
```

Each stage produces an artifact consumed by the next. You can join mid-pipeline if you already have the upstream artifact.

---

## Commands

| Command   | Skill(s)                        | What it does                                               |
|-----------|---------------------------------|------------------------------------------------------------|
| `/grill`  | idea-griller                    | Socratic interview → `.forge/idea-brief.md`                |
| `/spec`   | write-a-prd                     | Interview + codebase exploration → GitHub Issue PRD        |
| `/plan`   | prd-to-plan, prd-to-issues      | PRD → `./plans/*.md` + GitHub Issues                       |
| `/build`  | tdd                             | Red-green-refactor, one behavior at a time                 |
| `/review` | grill-me                        | Relentless questioning → shared understanding              |
| `/ship`   | pre-launch checklist            | Tests, security, docs, PR review before deploy             |

---

## All Skills

| Phase    | Skill               | Description                                                          |
|----------|---------------------|----------------------------------------------------------------------|
| Define   | `idea-griller`      | Socratic interview across 7 branches — pressure-tests a raw idea     |
| Specify  | `write-a-prd`       | PRD via interview + codebase exploration, submitted as GitHub issue  |
| Plan     | `prd-to-plan`       | Breaks PRD into phased vertical slices → `./plans/*.md`              |
| Plan     | `prd-to-issues`     | Converts PRD into independently-grabbable GitHub issues              |
| Build    | `tdd`               | Test-driven development: red-green-refactor, vertical slices         |
| Debug    | `triage-issue`      | Investigates bugs, finds root cause, creates GitHub issue + fix plan |
| Review   | `grill-me`          | Interviews relentlessly about a plan until shared understanding      |
| Meta     | `using-forge-skills`| Skill discovery and pipeline overview — injected at session start    |

---

## Installation

### Claude Code

**Install a single skill into your project:**

```bash
curl -sL https://raw.githubusercontent.com/aneja5/forge-skills/main/install.sh | bash -s idea-griller
```

**Install all skills:**

```bash
for skill in idea-griller write-a-prd prd-to-plan prd-to-issues tdd grill-me triage-issue using-forge-skills; do
  curl -sL https://raw.githubusercontent.com/aneja5/forge-skills/main/install.sh | bash -s $skill
done
```

**Or clone and symlink:**

```bash
git clone https://github.com/aneja5/forge-skills.git
ln -s $(pwd)/forge-skills/skills ~/.claude/skills
```

### SessionStart hook (recommended)

Automatically injects the skill pipeline at every session start:

1. Copy `hooks/hooks.json` content into your project's `.claude/settings.json`
2. Make sure `hooks/session-start.sh` is executable: `chmod +x hooks/session-start.sh`

### Cursor / Windsurf / other agents

Skills are plain Markdown — compatible with any agent that can read files from a `skills/` directory or project knowledge:

1. Copy `skills/<name>/SKILL.md` into your agent's context or project knowledge
2. Reference the skill by name in your prompt, or add a rule: "When starting a new feature, always invoke idea-griller first"

---

## How Skills Work

Skills are Markdown files that encode the *process* a senior engineer follows — not just knowledge, but a workflow with checkpoints.

Each `SKILL.md` contains:

- **Frontmatter** — `name` and `description` (used for skill discovery)
- **When to Use / When NOT to Use** — prevents misapplication
- **Common Rationalizations** — arguments an agent uses to skip steps, with rebuttals
- **Red Flags** — signals that something is going wrong
- **Core Process** — ordered steps with checkpoints
- **Verification** — checklist that must pass before the skill is "done"

Supporting files (like `evaluation-criteria.md`) hold reference material so `SKILL.md` stays under 100 lines.

### Why planning-first?

The most expensive bugs are specification bugs. Coding too early locks in wrong assumptions. The forge pipeline forces clarity before commitment:

- `/grill` surfaces assumptions before they become requirements
- `/spec` records decisions before they become code
- `/plan` slices work before it becomes a big-bang PR
- `/build` implements one behavior at a time, verified by tests

---

## Project Structure

```
forge-skills/
├── skills/
│   ├── using-forge-skills/     # Meta-skill: discovery flowchart + pipeline
│   ├── idea-griller/           # Socratic interview skill
│   │   └── evaluation-criteria.md
│   ├── write-a-prd/            # PRD creation skill
│   ├── prd-to-plan/            # Planning skill
│   ├── prd-to-issues/          # Issue decomposition skill
│   ├── tdd/                    # TDD skill + supporting files
│   ├── grill-me/               # Design review skill
│   └── triage-issue/           # Bug triage skill
├── .claude/
│   └── commands/               # Slash commands (/grill, /spec, /plan, /build, /review, /ship)
├── hooks/
│   ├── hooks.json              # Hook configuration
│   └── session-start.sh        # Injects meta-skill at session start
├── install.sh                  # Single-skill installer
├── CLAUDE.md                   # Project conventions for Claude
└── README.md
```

---

## Adding a New Skill

1. Create `skills/<name>/SKILL.md` with the standard anatomy (see `CLAUDE.md`)
2. Add supporting files to `skills/<name>/` as needed
3. Add a slash command in `.claude/commands/<name>.md` if it fits the pipeline
4. Update the skills table above
