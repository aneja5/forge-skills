# Getting Started with Forge Skills

## What is this?

Forge Skills is a planning-first engineering skill library. Skills are Markdown files that encode structured workflows — the kind of process a senior engineer follows when building a feature well. You install them into your AI coding agent, and the agent follows the workflow instead of free-styling.

The library covers the full feature lifecycle: from raw idea to shipped code.

## Quick Start (Claude Code)

**Option 1: Install everything**

```bash
git clone https://github.com/aneja5/forge-skills.git
cp -r forge-skills/skills ~/.claude/skills
cp -r forge-skills/agents ~/.claude/agents
cp -r forge-skills/.claude/commands ~/.claude/commands
```

**Option 2: Install one skill**

```bash
curl -sL https://raw.githubusercontent.com/aneja5/forge-skills/main/install.sh | bash -s idea-griller
```

**Option 3: Enable the session-start hook** (recommended)

Copy the hook config into your project's `.claude/settings.json`:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash ${CLAUDE_PROJECT_DIR}/hooks/session-start.sh"
          }
        ]
      }
    ]
  }
}
```

This injects the `using-forge-skills` meta-skill at every session start, so Claude always knows the pipeline.

## Your First Feature

Run these commands in order:

```
/grill   ← describe your idea; Claude interviews you across 7 branches
/spec    ← Claude formalizes the requirements into .forge/prd.md
/architect ← Claude designs the system and writes interface contracts
/plan    ← Claude breaks work into sized, dependency-ordered tasks
/build   ← Claude implements the next task using TDD
/review  ← Claude reviews the implementation against contracts
/ship    ← Claude runs the pre-launch checklist
```

You don't have to start at `/grill`. If you already have a spec, start at `/spec` or `/architect`. Each stage just needs the previous stage's `.forge/` artifact.

## The .forge/ Directory

Forge Skills uses `.forge/` as a shared workspace for handoff artifacts:

```
.forge/
├── idea-brief.md      ← output of /grill
├── prd.md             ← output of /spec
├── architecture.md    ← output of /architect
├── contracts/         ← interface contracts per module
│   └── <module>.md
├── adr/               ← architecture decision records
│   └── 001-*.md
└── tasks.yaml         ← output of /plan
```

Add `.forge/` to your `.gitignore` if you want it local-only, or commit it to share context with teammates.

## Which Skill for Which Situation?

| Situation | Skill / Command |
|-----------|----------------|
| New idea, haven't thought it through | `/grill` |
| Ready to write requirements | `/spec` |
| Need system design + contracts | `/architect` |
| Need a task breakdown | `/plan` |
| Ready to implement | `/build` |
| Something broke | debugging-and-recovery (invoke inline) |
| Code ready for review | `/review` |
| Ready to deploy | `/ship` |
| Stress-test a design decision | grill-me (invoke inline) |

## Troubleshooting

**"The skill doesn't seem to be doing anything"**
Make sure the SKILL.md is in a location your agent can read. For Claude Code, skills go in `~/.claude/skills/<name>/SKILL.md` or in your project at `.claude/skills/<name>/SKILL.md`.

**"Claude skips steps in the skill"**
Remind Claude: "Skills are workflows — follow every step in order." The using-forge-skills meta-skill has anti-rationalization tables to help with this.

**"The .forge/ artifacts aren't being created"**
Check that the `.forge/` directory can be written to. The skills create it if it doesn't exist, but make sure your project directory is writable.
