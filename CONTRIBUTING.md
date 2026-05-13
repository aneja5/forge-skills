# Contributing to forge-skills

Thanks for considering a contribution. forge-skills is opinionated by design — these rules keep it that way.

## The 8 rules

1. **Fork and branch.** Fork the repo, create a branch from `main`. One branch per skill.

2. **Follow the anatomy.** Every new skill must follow the structure documented in [`skills/writing-skills/SKILL.md`](skills/writing-skills/SKILL.md): frontmatter, Overview, When to Use, When NOT to Use, Common Rationalizations table, Red Flags, Core Process (numbered steps), Verification checklist.

3. **No skill without a failing test first.** Every new skill must have at least one RED/GREEN pressure test in `tests/<skill-name>/scenarios.md` with verbatim results in `tests/<skill-name>/results.md`. See [`tests/METHODOLOGY.md`](tests/METHODOLOGY.md) for the cycle. Skills without tests will not be merged.

4. **CSO-compliant descriptions.** The frontmatter `description` field must describe **only** when to use the skill — triggers, symptoms, situations. Never summarize the workflow. Workflow summaries create a shortcut Claude follows instead of reading the skill body. Start with "Use when..." Read the CSO Rules section of `writing-skills` for examples.

5. **100–150 lines.** SKILL.md is the entry point, not the encyclopedia. Extract heavy reference material (templates, checklists, taxonomies, supporting examples) into `references/` or alongside the skill as a sibling file. The SKILL.md itself stays in the band.

6. **One skill per PR.** Don't bundle. A PR that adds two skills will be asked to split. Same applies to skill + agent + command — separate PRs, separate reviews, separate revert points.

7. **Fill in the PR description.** Three required sections:
   - **Problem.** What real-session failure or gap motivated this skill? Be specific — "I noticed Claude does X when I want Y" is the right shape.
   - **RED baseline.** What did fresh subagents do *without* the skill? Quote rationalizations verbatim.
   - **GREEN improvement.** What changed once the skill loaded? Cite the sections of your skill that drove the difference.

8. **No domain-specific skills in core.** If a skill only helps one type of project (React apps, Postgres-only, ML training, a specific industry vertical), it doesn't belong in core. Publish it as a separate plugin that depends on forge-skills. Core skills must apply to most software projects.

## Other expectations

- **Match existing style.** Read `skills/idea-griller/SKILL.md` and `skills/architecture-and-contracts/SKILL.md` before writing. The voice is direct, the tables are populated, the verification gates are objective.
- **No emojis** in skill bodies, agent files, or commit messages unless the surrounding file already uses them.
- **Conventional commit prefixes** — `feat:` for new skills/agents/commands, `test:` for scenarios/results, `fix:` for bug fixes, `docs:` for everything else.
- **No Co-Authored-By footer** in commits unless requested by the maintainer.
- If a skill change is forced by testing (REFACTOR phase), update the skill **in the same commit** as the test results.

## What lives where

| Where | What goes there |
|---|---|
| `skills/<name>/SKILL.md` | The skill itself, 100–150 lines |
| `skills/<name>/*.md` | Supporting files referenced from SKILL.md |
| `references/*.md` | Shared templates and checklists used by multiple skills |
| `agents/<role>.md` | Specialist persona — role, mental model, push-back, never-do, quality bar |
| `commands/<verb>.md` | Slash command — 5–15 lines, references the skill it invokes |
| `tests/<skill>/scenarios.md` | 1+ pressure scenarios with setup, expected behavior, red flags |
| `tests/<skill>/results.md` | Verbatim subagent outputs from RED + GREEN runs + REFACTOR notes |

## Process

1. Open an issue describing the gap (optional but recommended — saves rework).
2. Fork, branch from `main`.
3. Write `tests/<skill>/scenarios.md` first.
4. Run RED (fresh subagent, no skill loaded). Record verbatim in `results.md`.
5. Write `skills/<skill>/SKILL.md` addressing the specific failures you observed.
6. Run GREEN. Record verbatim. REFACTOR if new rationalizations appeared.
7. Add slash command in `commands/` if it fits the pipeline.
8. Update `skills/using-forge-skills/SKILL.md` discovery flowchart if the trigger pattern is new.
9. Open a PR with the three required description sections.

## What gets rejected

- Skills without tests
- Skills where description summarizes the workflow
- Skills over 150 lines without a supporting-file split
- PRs that bundle multiple skills or skill+agent+command
- Domain-specific skills targeted for core
- Skills that duplicate existing functionality (e.g., a second TDD skill, a second debugging skill)
- Skills where the PR description doesn't include the RED baseline or cite a real session

## Not sure?

Not sure if your idea belongs in core? **Open an issue first and describe the use case.** Faster than writing a skill that gets rejected. Tag it `question`. We'll work out whether it's core, plugin, or something already covered.
