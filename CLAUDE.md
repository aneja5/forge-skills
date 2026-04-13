# forge-skills

A planning-first skill library for Claude Code. Skills are structured workflows, not reference docs. Each skill encodes a specific process that the agent follows step-by-step.

## Project Structure

```
forge-skills/
├── skills/                     # All skill definitions
│   ├── using-forge-skills/     # Meta-skill: skill discovery and pipeline
│   ├── idea-griller/           # Socratic interview → .forge/idea-brief.md
│   │   └── evaluation-criteria.md
│   ├── write-a-prd/            # Interview + codebase → GitHub Issue PRD
│   ├── prd-to-plan/            # PRD → ./plans/*.md
│   ├── prd-to-issues/          # PRD → GitHub Issues
│   ├── tdd/                    # Red-green-refactor with vertical slices
│   │   ├── deep-modules.md
│   │   ├── interface-design.md
│   │   ├── mocking.md
│   │   ├── refactoring.md
│   │   └── tests.md
│   ├── grill-me/               # Relentless design review
│   └── triage-issue/           # Bug investigation → GitHub Issue
├── .claude/
│   └── commands/               # Slash commands for the full lifecycle
│       ├── grill.md            # /grill → idea-griller
│       ├── spec.md             # /spec  → write-a-prd
│       ├── plan.md             # /plan  → prd-to-plan + prd-to-issues
│       ├── build.md            # /build → tdd
│       ├── review.md           # /review → grill-me
│       └── ship.md             # /ship  → pre-launch checklist
├── hooks/
│   ├── hooks.json              # Hook configuration
│   └── session-start.sh        # Injects using-forge-skills at session start
├── install.sh                  # Single-skill installer
└── README.md
```

## Skills by Phase

| Phase    | Skill              | Command  | Input                   | Output                |
|----------|--------------------|----------|-------------------------|-----------------------|
| Define   | idea-griller       | /grill   | Raw idea (spoken)       | .forge/idea-brief.md  |
| Specify  | write-a-prd        | /spec    | Brief or description    | GitHub Issue (PRD)    |
| Plan     | prd-to-plan        | /plan    | PRD issue number        | ./plans/*.md          |
| Decompose| prd-to-issues      | /plan    | PRD + plan              | GitHub Issues         |
| Build    | tdd                | /build   | Issue or spec           | Code + passing tests  |
| Debug    | triage-issue       | —        | Bug description         | GitHub Issue + fix    |
| Review   | grill-me           | /review  | Plan or design          | Shared understanding  |

## Conventions

### Skill files

- Every skill lives in `skills/<name>/SKILL.md`
- Frontmatter: `name` (hyphen-separated), `description` (one sentence, includes trigger phrases)
- Required sections: Overview, When to Use, When NOT to Use, Common Rationalizations, Red Flags, Core Process, Verification
- Keep SKILL.md under 100 lines — move reference material to supporting files in the same directory
- Supporting files are referenced from SKILL.md with relative links

### The pipeline

Skills chain: output of one is input to the next. The handoff artifact is always explicit:

```
idea-griller → .forge/idea-brief.md → write-a-prd → GitHub Issue → prd-to-plan → ./plans/*.md
```

Never skip ahead without the previous stage's output. You can join mid-pipeline if you have the artifact.

### Slash commands

- Short files in `.claude/commands/`
- Frontmatter: `description` (one line, shown in command picker)
- Body: which skill to invoke + 5-10 lines of instruction
- Commands map 1:1 to pipeline phases; `/plan` covers both prd-to-plan and prd-to-issues

### Hooks

- `hooks/hooks.json` configures which hooks are active
- `hooks/session-start.sh` reads `skills/using-forge-skills/SKILL.md` and injects it at session start
- To activate hooks, copy `hooks/hooks.json` content into your project's `.claude/settings.json`

## Boundaries

**What this repo is:**
- A collection of planning and development workflow skills for Claude Code
- Installable into any project via `install.sh`
- Designed to chain together into a full feature lifecycle

**What this repo is NOT:**
- Project-specific business logic
- A framework or runtime — it's just Markdown files
- A replacement for a proper spec or design process — it IS the spec and design process

## Installation

```bash
# Install a single skill into your project
curl -sL https://raw.githubusercontent.com/aneja5/forge-skills/main/install.sh | bash -s idea-griller

# Or copy directly
cp -r skills/idea-griller ~/.claude/skills/
```

## Adding a New Skill

1. Create `skills/<name>/SKILL.md` with required frontmatter and sections
2. Add supporting files to `skills/<name>/` as needed
3. If it fits the pipeline, add a slash command in `.claude/commands/`
4. Update the skills table in README.md
5. Keep SKILL.md under 100 lines
