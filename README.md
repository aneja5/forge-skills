# sahil-skills

Personal Claude Code skill library.

## Install

```bash
# Install a single skill
curl -sL https://raw.githubusercontent.com/aneja5/sahil-skills/main/install.sh | bash -s <skill-name>

# Example
curl -sL https://raw.githubusercontent.com/aneja5/sahil-skills/main/install.sh | bash -s idea-griller
```

## Planning Pipeline

These skills chain together for end-to-end feature planning:

```
idea-griller → write-a-prd → prd-to-plan → prd-to-issues
     ↓              ↓             ↓              ↓
.forge/idea-brief.md → GitHub Issue PRD → ./plans/*.md → GitHub Issues
```

1. **idea-griller** — Pressure-test a raw idea through Socratic questioning. Outputs `.forge/idea-brief.md`
2. **write-a-prd** — Interview + codebase exploration → PRD as GitHub issue
3. **prd-to-plan** — Break PRD into phased vertical slices → `./plans/*.md`
4. **prd-to-issues** — Convert PRD into independently-grabbable GitHub issues

## All Skills

| Skill | Description |
|-------|-------------|
| `idea-griller` | Socratic interview to pressure-test a raw idea before writing a PRD |
| `write-a-prd` | Create a PRD through user interview and codebase exploration |
| `prd-to-plan` | Turn a PRD into a multi-phase implementation plan using vertical slices |
| `prd-to-issues` | Break a PRD into GitHub issues using tracer-bullet vertical slices |
| `tdd` | Test-driven development with red-green-refactor loop |
| `grill-me` | Interview relentlessly about a plan until reaching shared understanding |
| `triage-issue` | Investigate a bug, find root cause, create GitHub issue with TDD fix plan |
| `scaffold-fastapi-agent` | Scaffold a FastAPI + LangGraph agent project (personal) |

## Setup

Add to your project's `CLAUDE.md`:

```markdown
## Skills

This project uses skills from [sahil-skills](https://github.com/aneja5/sahil-skills).

Available commands:
- `/idea-griller` — pressure-test a new idea
- `/write-a-prd` — create a PRD
- `/prd-to-plan` — break PRD into phases
- `/prd-to-issues` — convert PRD to GitHub issues
- `/tdd` — test-driven development workflow
- `/grill-me` — stress-test a design
- `/triage-issue` — investigate and plan a bug fix
```
