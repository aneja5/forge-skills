# Forge Skills Cookbook

Practical patterns for using forge-skills in real projects. Not a reference doc. A "here's what to do in this situation" guide.

---

## Setup: Adding Forge to Your Project

Everything you need, in order. Takes 5 minutes.

### Step 1: Install the plugin

In Claude Code:

```
/plugin marketplace add aneja5/forge-skills
/plugin install forge-skills@forge-skills
```

Verify it worked:

```
/forge-skills:grill
```

If you see the Socratic interview start, you're set. Press Ctrl+C to cancel — you'll run it for real later.

### Step 2: Create your project CLAUDE.md

Every project that uses forge-skills needs a `CLAUDE.md` at the root. This tells Claude about your project and primes it to use skills.

```bash
touch CLAUDE.md
```

Paste this starter template:

```markdown
# [Project Name]

## What this is
[One paragraph. What does this project do and for whom.]

## Stack
[Language, framework, database, key dependencies]

## Important conventions
- This project uses forge-skills for planning and building
- Pipeline artifacts live in .forge/
- Every new feature starts with /spec or /grill
- Interface contracts in .forge/contracts/ are the source of truth for module boundaries
- Tests are written before implementation (TDD)

## Where context lives
- .forge/prd.md — current product requirements
- .forge/architecture.md — system design and tech stack decisions
- .forge/contracts/ — module boundary contracts (typed inputs, outputs, errors)
- .forge/tasks.yaml — current sprint tasks
- context/CONTEXT.md — research, interviews, raw notes (if exists)

## When in doubt
Read .forge/prd.md first. It has the problem statement, personas, and requirements.
Everything else builds on it.
```

Fill in the `[brackets]` with your project details.

### Step 3: Create the directory structure

```bash
mkdir -p .forge context docs
```

That's it. Skills create files inside `.forge/` automatically. You don't need to pre-create subdirectories like `contracts/` or `adr/` — the skills handle that.

### Step 4: Decide on .gitignore

**Commit .forge/ (recommended for most projects):**

Don't add `.forge/` to `.gitignore`. Your PRD, architecture, contracts, and ADRs are valuable documentation. Teammates can onboard by reading `.forge/`. Code reviewers can check implementation against contracts.

**Ignore .forge/ (for throwaway projects):**

```bash
echo ".forge/" >> .gitignore
```

Only do this for weekend hacks or solo experiments where the artifacts have no long-term value.

### Step 5: (Optional) Add research context

If you have existing research, interviews, competitor notes, or technical constraints, put them in `context/CONTEXT.md`:

```bash
touch context/CONTEXT.md
```

Structure it however makes sense. The spec-driven-development skill has a context-loaded mode — if `context/CONTEXT.md` exists and is 500+ lines, it skips the interview and generates the PRD directly from your research.

### Step 6: Verify the full setup

Run this quick check:

```bash
ls CLAUDE.md .forge context
```

You should see:

```
CLAUDE.md

.forge:

context:
```

Empty directories are fine. The skills will populate `.forge/` as you run the pipeline.

### Step 7: Start

You're ready. Pick your entry point:

| Your situation | Start with |
|---|---|
| Raw idea, not yet validated | `/forge-skills:grill` |
| Idea is clear, need a spec | `/forge-skills:spec` |
| Have a spec, need architecture | `/forge-skills:architect` |
| Have architecture, need tasks | `/forge-skills:plan` |
| Have tasks, ready to build | `/forge-skills:build` |

### What gets created as you go

After a full pipeline run, your project looks like this:

```
my-project/
├── CLAUDE.md                       # You created this
├── context/
│   └── CONTEXT.md                  # Your research (optional)
├── .forge/                         # Created by skills
│   ├── idea-brief.md               # From /grill
│   ├── prd.md                      # From /spec
│   ├── architecture.md             # From /architect
│   ├── contracts/                  # From /architect
│   │   ├── auth-service.md
│   │   ├── payment-service.md
│   │   └── notification-service.md
│   ├── adr/                        # From /architect
│   │   ├── 001-postgres-over-mongo.md
│   │   └── 002-ssr-over-spa.md
│   ├── tasks.yaml                  # From /plan
│   └── tasks-summary.md            # From /plan
├── src/                            # From /build
├── tests/                          # From /build (TDD)
└── docs/
```

### Updating the plugin

When a new version of forge-skills is released:

```
/plugin update forge-skills
```

Or in your terminal:

```bash
claude plugin marketplace update forge-skills
```

### Uninstalling

```
/plugin uninstall forge-skills
```

This removes the plugin. Your `.forge/` artifacts stay untouched in your project.

### Using without the plugin (manual)

If you don't want the plugin, clone the repo and reference skills directly:

```bash
git clone https://github.com/aneja5/forge-skills.git ~/.forge-skills
```

Then in your project's `CLAUDE.md`, add:

```markdown
## Skills
Load skills from ~/.forge-skills/skills/ when the task matches
a skill description. Check .forge/ for existing artifacts.
```

This works but you lose slash commands and auto-triggering. The plugin is better.

---

## Pattern 1: Greenfield Project (full pipeline)

You have nothing. No code, no spec, maybe just a sentence in your head. Run the full pipeline.

**Setup:**

```bash
mkdir my-project && cd my-project
git init
```

**The session:**

```
/forge-skills:grill
> I want to build an expense tracker for freelancers
```

Claude interviews you across 7 branches. Answer honestly. When it's done, you have `.forge/idea-brief.md`.

```
/forge-skills:spec
```

Claude reads the brief, skips questions you already answered, interviews you on the gaps. You get `.forge/prd.md`.

```
/forge-skills:architect
```

Claude reads the PRD, produces `.forge/architecture.md`, `.forge/contracts/`, and `.forge/adr/`. This is where most of the value is. Contracts define every module boundary with types.

```
/forge-skills:plan
```

Claude reads everything above, produces `.forge/tasks.yaml` with sized, ordered, dependency-mapped tasks.

```
/forge-skills:build
```

Claude picks the first unblocked task, loads its contracts, implements with TDD. Commits after each task. Repeat until tasks.yaml is done.

```
/forge-skills:review
```

Five-axis review against contracts. APPROVE, REQUEST CHANGES, or BLOCK.

```
/forge-skills:ship
```

Six-domain pre-launch gate. Go or no-go.

**What your .forge/ looks like after:**

```
.forge/
  idea-brief.md
  prd.md
  architecture.md
  contracts/
    auth-service.md
    expense-service.md
    reporting-service.md
  adr/
    001-postgres-over-mongo.md
    002-server-components.md
  tasks.yaml
  tasks-summary.md
```

**Time:** 2-4 hours for the full pipeline on a medium project. The spec and architecture phases take the longest because they involve conversation. Build phase depends on project size.

---

## Pattern 2: Single Skill (targeted use)

You don't need the pipeline. You need one specific thing.

**Scenario: You have code but no tests strategy.**

```
/forge-skills:test-strategy
```

Claude produces `.forge/testing-strategy.md`. Done. No pipeline needed.

**Scenario: Your demo is tomorrow.**

```
/forge-skills:demo
```

Claude walks you through scenes, talking points, wow moments, fallbacks, seed data checklist. Produces `.forge/demo-narrative.md`.

**Scenario: You just had an outage.**

```
/forge-skills:incident
```

Claude guides you through declare, mitigate, communicate, resolve, review. Produces `.forge/incident-response.md` with postmortem template.

**Key insight:** Every skill reads `.forge/` artifacts if they exist, but none of them require them. You can run any skill standalone. It just works better with upstream context.

**When standalone is fine:**
- The skill doesn't depend on upstream artifacts (testing-strategy, accessibility, documentation-hygiene, demo-narrative)
- You already know the context and can explain it in the prompt
- You need a quick artifact for one aspect of an existing project

**When you should use the pipeline instead:**
- You're making architectural decisions that affect multiple modules
- You need contracts for parallel implementation
- The project doesn't exist yet

---

## Pattern 3: Auto-triggering (Claude picks the skill)

You don't type `/forge-skills:grill`. You just describe what you need and Claude activates the right skill.

**How it works:**

The `using-forge-skills` meta-skill loads at session start via the SessionStart hook. It contains a discovery flowchart mapping intents to skills. When you say something, Claude matches your intent to a skill and activates it.

**Examples:**

```
"I have this idea for a fitness app. Can you help me think it through?"
```
Claude activates `idea-griller`. No slash command needed.

```
"We need to figure out our database schema for the user and subscription tables."
```
Claude activates `database-design`. Produces `.forge/database-design.md`.

```
"I want to know if our architecture will handle 100x traffic."
```
Claude activates `scalability-analysis`. Reads `.forge/architecture.md` if it exists.

**When auto-triggering works well:**
- Your intent clearly maps to one skill
- The session just started (meta-skill is fresh in context)
- You describe the problem, not the solution

**When to use slash commands instead:**
- You want a specific skill and don't want Claude guessing
- You're deep in a session and the meta-skill is out of context
- You want to chain skills in a specific order

**Making auto-triggering more reliable:**

Add this to your project's `CLAUDE.md`:

```markdown
## Skills
This project uses forge-skills. When a task matches a forge skill,
invoke that skill's workflow. Check .forge/ for existing artifacts
before starting any new skill — upstream context may already exist.
```

This primes Claude to look for skill matches even without the SessionStart hook.

---

## Pattern 4: Project Organization

How to structure your project repo when using forge-skills.

**The recommended layout:**

```
my-project/
├── CLAUDE.md              # Project context + skill routing
├── src/                   # Your code
├── tests/                 # Your tests
├── .forge/                # Pipeline artifacts
│   ├── idea-brief.md
│   ├── prd.md
│   ├── architecture.md
│   ├── contracts/
│   │   └── *.md
│   ├── adr/
│   │   └── *.md
│   ├── tasks.yaml
│   ├── tasks-summary.md
│   ├── competitive.md
│   ├── security.md
│   ├── observability.md
│   ├── testing-strategy.md
│   ├── design-system.md
│   └── ... (other artifacts)
├── context/               # Your research, notes, interviews
│   └── CONTEXT.md
└── docs/                  # Project documentation
    ├── architecture/
    └── planning/
```

**To .gitignore or not:**

Two valid approaches:

**Option A: Commit .forge/ (recommended for teams and learning)**

```
# .gitignore
# Don't ignore .forge/ — commit it
```

Why: Teammates can read the PRD, contracts, and ADRs. Onboarding becomes "read .forge/". The decision trail is preserved. Code reviewers can check implementation against contracts.

**Option B: Ignore .forge/ (for solo or disposable projects)**

```
# .gitignore
.forge/
```

Why: Artifacts are personal working docs. You don't need them in version history. Reduces repo noise.

**The CLAUDE.md for your project:**

```markdown
# Project Name

## What this is
[One paragraph about the project]

## Stack
[Tech stack and key dependencies]

## Important conventions
- We use forge-skills for planning and building
- Pipeline artifacts live in .forge/
- Every feature starts with /spec or /grill
- Interface contracts in .forge/contracts/ are the source of truth
  for module boundaries

## Where context lives
- .forge/prd.md — current product requirements
- .forge/architecture.md — system design
- .forge/contracts/ — module boundary contracts
- .forge/tasks.yaml — current sprint tasks
- context/CONTEXT.md — research, interviews, raw notes

## When in doubt
Read .forge/prd.md first. It has the problem statement,
personas, and requirements. Everything else builds on it.
```

---

## Pattern 5: Joining Mid-Project

You have an existing codebase with no `.forge/` artifacts. You want to start using forge-skills.

**Option A: Retroactively generate artifacts**

```
/forge-skills:spec
> We have an existing expense tracker app. Here's the current codebase.
> Generate a PRD that documents what we've already built.
```

Claude explores your code and writes `.forge/prd.md` documenting the current state. Then:

```
/forge-skills:architect
```

Generates architecture and contracts from your existing code. Now you have the foundation for future work.

**Option B: Start fresh for new features only**

Don't retroactively document everything. Just use the pipeline for the next feature:

```
/forge-skills:spec
> We're adding team expense sharing to our existing app.
> The current codebase is [describe briefly].
> Generate a PRD for just this feature.
```

This creates `.forge/prd.md` scoped to the new feature, not the whole project.

**Option C: Context-loaded mode**

If you have extensive notes, research, or existing docs, dump them into `context/CONTEXT.md` (500+ lines). Then:

```
/forge-skills:spec
> I have context in context/CONTEXT.md. Skip the interview
> and generate .forge/prd.md directly.
```

The skill detects the context file and skips discovery questions.

---

## Pattern 6: Re-running Skills

Requirements changed. Architecture needs updating. How to regenerate.

**When the PRD changes:**

```
/forge-skills:spec
> The PRD needs updating. [Describe what changed.]
> Read the current .forge/prd.md and update it.
```

Then re-run downstream:

```
/forge-skills:architect
> The PRD was updated. Re-read .forge/prd.md and update
> the architecture and contracts. Highlight what changed.
```

```
/forge-skills:plan
> Architecture was updated. Regenerate tasks.yaml.
> Mark tasks that are affected by the changes.
```

**Key rule: always re-run downstream.** If you update the PRD, the architecture, contracts, and tasks all need updating. The pipeline is a chain. Breaking a link upstream breaks everything below.

**When to version .forge/ artifacts:**

For significant changes, copy the old version:

```bash
cp .forge/prd.md .forge/prd.v1.md
```

Then regenerate. This gives you a diff trail.

---

## Pattern 7: Sprint Workflow

How .forge/ evolves across multiple sprints.

**Sprint 1: Foundation**

```
/grill → /spec → /architect → /plan → /build → /review → /ship
```

Full pipeline. Everything is new. `.forge/` is created from scratch.

**Sprint 2: Feature addition**

Don't re-run the full pipeline. Start from `/spec`:

```
/forge-skills:spec
> We're adding feature X to the existing product.
> Read .forge/prd.md for current state.
> Add a new section for feature X.
```

Then `/architect` to update contracts if new module boundaries are needed. Then `/plan` to generate new tasks. Existing tasks stay in tasks.yaml with status "done."

**Sprint 3+: Maintenance and debt**

```
/forge-skills:debt
> Scan the codebase and .forge/tech-debt-registry.md.
> What should we pay down this sprint?
```

```
/forge-skills:perf
> Review .forge/performance-budget.md against current metrics.
> Any budgets exceeded?
```

**Managing tasks.yaml across sprints:**

Option A: One tasks.yaml, tasks accumulate with status (todo/in-progress/done/blocked).

Option B: Archive per sprint. Move completed tasks to `.forge/sprints/sprint-1-tasks.yaml`, generate fresh for sprint 2.

Option B is cleaner for long projects.

---

## Pattern 8: Parallel Agent Dispatch

You have multiple tasks and want agents working simultaneously.

**Step 1: Generate the parallel plan**

```
/forge-skills:parallel
> Read .forge/tasks.yaml. I want to dispatch 3 agents in parallel.
> Identify dependency-free groups and file conflicts.
```

Produces `.forge/parallel-plan.md` with wave assignments, file-conflict matrix, merge order.

**Step 2: Dispatch agents**

In Claude Code, use the Task tool to dispatch subagents:

```
Dispatch 3 agents in parallel. Each agent:
1. Reads .forge/parallel-plan.md for their assigned tasks
2. Reads relevant .forge/contracts/ for their modules
3. Creates a git worktree for isolation
4. Implements with TDD
5. Commits to their branch

Agent 1: Tasks T-001, T-003 (auth module)
Agent 2: Tasks T-002, T-005 (expense module)
Agent 3: Task T-004 (reporting module)
```

**Step 3: Integration gates**

After each agent completes:

```
Pull main. Merge agent-1 branch. Run full test suite.
Green? Merge agent-2. Run full suite. Green? Merge agent-3.
```

Never merge all at once. Sequential integration with test gates between each.

**What the parallel skill prevents:**
- Two agents editing the same file (conflict matrix)
- Merge nightmare at the end (fixed merge order)
- Silent integration failures (test gates between merges)
- Shared worktree corruption (worktree-per-agent isolation)

---

## Pattern 9: Using Agent Personas

Skills tell Claude what to do. Agents tell it how to think. Use agents when you need a specific perspective.

**Invoke an agent for a review:**

```
Think as the security-auditor agent (read agents/security-auditor.md).
Review the authentication implementation in src/auth/.
```

**Invoke an agent during architecture:**

```
After generating the architecture, switch to the reliability-engineer
persona (read agents/reliability-engineer.md) and critique it.
What failure modes did we miss?
```

**The agent roster and when to use each:**

| Agent | Use when you need... |
|---|---|
| architect | System design critique, boundary decisions |
| project-manager | Task sizing, dependency ordering, scope control |
| test-engineer | Test strategy, coverage gaps, TDD coaching |
| code-reviewer | PR review, code quality, readability |
| security-auditor | Threat modeling, auth review, PII audit |
| competitive-analyst | Market positioning, feature comparison |
| compliance-officer | Regulatory review, data privacy, certifications |
| reliability-engineer | Error handling, monitoring, incident prep |
| data-engineer | Schema review, migration safety, query performance |
| qa-engineer | Test quality, flake detection, quality gates |
| design-engineer | Visual consistency, interaction patterns, a11y |

**Combining agents:**

For architecture review, chain two personas:

```
1. Generate architecture using /architect
2. Review as reliability-engineer: "What breaks at 3am?"
3. Review as security-auditor: "What can an attacker exploit?"
4. Review as data-engineer: "Will the schema support this at 100x?"
```

Each persona catches different gaps. The architecture improves with each pass.

---

## Pattern 10: Context Loading for Large Projects

Large projects need more context than a prompt can hold.

**The CONTEXT.md pattern:**

Create `context/CONTEXT.md` with everything Claude needs to understand the project:

```markdown
# Project Context

## What we're building
[2-3 paragraphs]

## Current state
[What exists, what's deployed, what's broken]

## User research
[Interviews, surveys, feedback — summarized]

## Technical constraints
[Infrastructure limits, regulatory requirements, budget]

## Prior decisions
[What was tried and didn't work, and why]
```

Then reference it in every prompt:

```
Read context/CONTEXT.md first. Then run /spec.
```

**When context exceeds what fits:**

Split into focused files:

```
context/
  CONTEXT.md          # Overview (500 lines max)
  user-research.md    # Interview summaries
  technical-debt.md   # Known issues
  competitor-notes.md # Market research
```

Tell Claude which context files to read for which skill:

```
Read context/CONTEXT.md and context/user-research.md.
Then run /spec.
```

**The "be exhaustive" trick:**

For any skill, adding "be exhaustive" to the prompt significantly increases output depth:

```
/forge-skills:architect
> Read .forge/prd.md. Be exhaustive. I want every module boundary
> defined, every error type listed, every invariant documented.
```

---

## Pattern 11: Keeping .forge/ in Sync

Over time, .forge/ artifacts drift from reality. Here's how to keep them useful.

**After every sprint:**

```
/forge-skills:docs
> Audit .forge/ artifacts against the current codebase.
> Which artifacts are stale? What needs updating?
```

**After major refactors:**

Re-run `/architect` to regenerate contracts:

```
/forge-skills:architect
> The codebase has been refactored. Regenerate .forge/architecture.md
> and .forge/contracts/ from the current code. Highlight what changed
> from the previous version.
```

**Signs your .forge/ is stale:**
- Contracts reference modules that don't exist anymore
- Tasks.yaml has tasks for features that already shipped
- The PRD describes a different product than what you built
- ADRs reference alternatives that no longer apply

**The mirror pattern:**

Some teams keep a `docs/` mirror of `.forge/`:

```bash
cp .forge/architecture.md docs/architecture/ARCHITECTURE.md
cp .forge/security.md docs/security/SECURITY.md
```

`.forge/` is the working directory (messy, evolving). `docs/` is the clean copy (reviewed, formatted). Update docs/ at the end of each sprint, not continuously.

---

## Pattern 12: Common Workflows

**"I need to ship by Friday"**

Skip the full pipeline. Use the minimum:

```
/forge-skills:spec     # 30 min — defines scope
/forge-skills:plan     # 15 min — breaks into tasks
/forge-skills:build    # Rest of the time — implement
/forge-skills:ship     # 15 min — pre-launch gate
```

Skip `/grill` (you already know the idea), `/architect` (small feature doesn't need contracts), `/review` (you're reviewing your own code by reading it).

**"I'm onboarding a new team member"**

Point them at `.forge/`:

```
Read these in order:
1. .forge/prd.md — what we're building and why
2. .forge/architecture.md — how it's designed
3. .forge/contracts/ — module boundaries
4. .forge/adr/ — why we made the decisions we made
5. .forge/tasks.yaml — what's in progress
```

Better than any onboarding doc because it's the actual working artifacts, not a summary of them.

**"The client wants a demo next week"**

```
/forge-skills:seed     # Create realistic demo data
/forge-skills:demo     # Write demo script with fallbacks
```

The demo-narrative skill produces scene-by-scene instructions with wow moments and fallback plans. The seed skill ensures your data looks real, not lorem ipsum.

**"Something broke in production"**

```
/forge-skills:incident  # Structured response
/forge-skills:errors    # Review error handling for the affected service
/forge-skills:observe   # Add monitoring to prevent recurrence
```

---

## Pattern 13: Right-sizing the Pipeline

Forge has 42 skills, but a weekend hackathon doesn't need 42 artifacts. Running the full pipeline on a 200-line script produces more documentation than code. Match the pipeline depth to the project's actual surface area.

### By codebase size

| Size | Suggested skills | Why |
|---|---|---|
| **< 500 LOC** (script, single page, one-shot tool) | `/spec` → `/build` | Spec captures intent in one short PRD. Skip architecture — there's only one module. Skip planning — the task list is "do the thing." |
| **500–2000 LOC** (weekend project, single-service app) | `/spec` → `/architect` → `/plan` → `/build` | Architecture pays off once you have ≥2 modules talking. Tasks.yaml clarifies the order. Skip the analysis skills (compete, scale, secure) unless they're a real concern. |
| **2000+ LOC** (real product, multi-module, shipping to users) | Full pipeline | Every artifact earns its keep at this scale. The analysis skills (compete, scale, secure) prevent the most expensive mistakes. |
| **Team project** (≥2 humans, shared codebase) | Full pipeline + `/sync` before every sprint | Drift between teammates' mental models is the dominant cost. `/sync` is cheap insurance. Also adopt Pattern 14 below. |

### By project type

A 200-line CLI tool gets `/spec` + `/build`. A 200-line **Stripe-integration script** that handles real money gets `/spec` + `/secure` + `/build` — the LOC count lies about the risk surface.

Map by *what the project does*, not just *how big it is*:

- Handles money, PII, or auth → always run `/secure`, regardless of size.
- Will scale beyond one server → always run `/scale`, regardless of size.
- Will be sold or pitched → always run `/compete` + `/gtm`, regardless of size.
- UI shipping to external users → always run `/a11y` + `/polish`, regardless of size.

### Pipeline-depth red flags

Pull back if you see:
- The PRD describes a 5-task project in 800 lines. The PRD is overscoped.
- `.forge/contracts/` has 8 files for a 300-LOC repo. You're documenting nothing into existence.
- The team spends more time updating `.forge/` than writing code two sprints in a row. The pipeline is too deep for the project.

Lean is fine. The pipeline is a tool, not a ritual.

---

## Pattern 14: Teams — Handling `.forge/` in Shared Repos

Two engineers independently run `/architect` on different branches. Both modify `.forge/architecture.md`. Git merges, hits a 500-line conflict, and now somebody is hand-resolving generated content. By the time they're done, neither file accurately represents the system.

`.forge/` artifacts are **generated**, not authored. Treat them like build output: regenerate, don't merge.

### The iron rule

> **Never hand-resolve a `.forge/` merge conflict.** Re-run the source skill on the merged base, then commit. The skill is the source of truth; the file is a render.

If you find yourself opening a `.forge/architecture.md` conflict marker, stop. Discard both sides. Re-run `/architect`. Commit the regenerated file.

### Three working models

**Option A — Single owner per sprint (smallest teams, 2–4 people)**

One person runs every `/grill`, `/spec`, `/architect`, `/plan` per sprint. The rest of the team is read-only on `.forge/`. At sprint boundaries the role can rotate. Pros: zero merge conflicts, single point of design coherence. Cons: bottlenecks on one person; risky if they're out.

**Option B — Dedicated `.forge/` branch (medium teams, 4–10 people)**

`.forge/` lives on a long-lived `forge` branch. Feature branches merge from it but never write to it. When a skill needs to re-run, it runs on the `forge` branch; feature branches rebase to pick up changes.

```
main ───────────────────────────────●─────── (code)
  ↑                                 │
  │ feature branches merge in       │
  │                                 │
forge ──────●───────●──────●────────●─────── (only .forge/ writes)
            │       │       │
        /architect /plan  /architect (re-run after PRD update)
```

Pros: code and `.forge/` evolve independently; no merge conflicts in feature branches. Cons: requires `.gitignore` discipline (feature branches must not write `.forge/`).

**Option C — Regenerate on merge to main (large teams, ≥10 people, mature CI)**

`.forge/` is committed but treated as machine-derived: a CI step on merge-to-main re-runs `/sync` and either auto-regenerates stale artifacts or fails the build with the cascade list. Engineers never edit `.forge/` directly; they edit upstream sources (the idea, the PRD, the contract) and let CI re-derive.

Pros: artifacts are always current; no human regenerates by hand. Cons: requires non-interactive skill invocation (which forge-skills supports for some skills but not the interview-heavy ones like `/grill` or `/spec`).

### Choosing between A/B/C

| Team size | Codebase | Recommended |
|---|---|---|
| 2–4 | any | Option A — rotate the role |
| 4–10 | < 50k LOC | Option A *or* Option B — pick by personality fit |
| 4–10 | ≥ 50k LOC | Option B |
| ≥ 10 | any | Option C (with Option B as the migration step) |

### Universal rules across all three

- `.forge/` is committed (not `.gitignore`d) so context survives crashes and onboards new teammates.
- Every PR that touches `.forge/` must be reviewed by whoever owns the sprint's pipeline role.
- `/sync` runs before every sprint kickoff — if it reports `STALE`, fix the chain before assigning new work.
- Pre-commit hook: reject commits where `.forge/` and `src/` both have changes (`.forge/` work and code work are separate PRs).
- When you DO get a conflict, regenerate. Don't merge.

---

## Pattern 15: Large Projects — Read `.forge/index.md` First

By sprint 6 of a real product, `.forge/` has 20–30 artifacts. A skill that needs to "read everything" — `cross-validation`, `demo-narrative`, `redaction-and-cleanup`, even `/forge-sync` itself across runs — blows its context window on full file loads when 80% of what it needs is the summary.

`/forge-skills:sync` now emits **`.forge/index.md`** alongside `.forge/sync-report.md`. It's a compact table: one row per artifact with path, owning skill, last-updated, status, size, and a one-line summary.

```markdown
| Artifact | Generated by | Last updated | Status | Size | One-line summary |
|---|---|---|---|---|---|
| .forge/prd.md | spec-driven-development | 2026-05-13T14:22Z | UP_TO_DATE | 12 KB | Forge Skills v3.5 product requirements |
| .forge/architecture.md | architecture-and-contracts | 2026-05-13T15:00Z | STALE | 8 KB | System design with 6 modules, REST + SSE |
| .forge/contracts/auth-service.md | architecture-and-contracts | 2026-05-13T15:00Z | UP_TO_DATE | 2 KB | AuthService — JWT issuance + validation |
```

### When to consult the index

Read `.forge/index.md` first when:

- A skill says "reads any `.forge/` artifact the user wants reviewed" (e.g., `cross-validation`) — scan the index, pick the 2-3 most relevant, load only those.
- You need to know *what's stale* without seeing the full sync report (use the `Status` column).
- You're preparing a demo or redaction pass and need to inventory what exists before deciding what to include.
- You're onboarding to an existing project — the index is the table of contents.

### When to skip the index

Skip it when:

- The project has fewer than 8 artifacts — at that scale, just read them all.
- You already know exactly which artifact you need (e.g., `/build` reads `tasks.yaml` directly — no detour through the index).
- The artifacts are tiny (under 200 lines each) — the savings don't justify the indirection.

### Keeping the index current

Run `/forge-skills:sync` whenever the index might be stale. The index is regenerated every time `/sync` runs — it shares the sync report's `depends_on` and `generated_from`, so `forge-check.sh` flags both stale together if any artifact drifts.

The index is a **convenience surface**, not a source of truth. Never edit it by hand. If a row looks wrong, fix the underlying artifact and re-run `/sync`.

---

## Anti-Patterns

**The YOLO pipeline:**
Running `/grill → /spec → /architect → /plan → /build → /review → /ship` without reading any output. The pipeline is a conversation, not a batch job. Read each artifact before invoking the next skill.

**The artifact hoarder:**
Running every skill on every project. A weekend hackathon doesn't need `.forge/competitive.md` and `.forge/scalability.md`. Match skill usage to project scale.

**The re-runner:**
Re-running `/spec` every time something changes instead of editing `.forge/prd.md` directly. Small changes should be manual edits. Re-run the skill only for major scope changes.

**The contract ignorer:**
Generating contracts with `/architect` then implementing without reading them. Contracts only work if `/build` and `/review` actually reference them. Check during review: "does this implementation match `.forge/contracts/auth-service.md`?"

**The stale forge:**
Never updating `.forge/` after the initial run. By sprint 3, the artifacts describe a different product. Schedule a quarterly `.forge/` audit.

**The solo everything:**
Using forge-skills alone when you should be using agent personas for review. After generating architecture, ask the reliability-engineer to critique it. After writing the PRD, ask the competitive-analyst to find gaps. The agents exist for a reason.

---

## Quick Reference: Skill by Situation

| I need to... | Skill | Command |
|---|---|---|
| Pressure-test a raw idea | idea-griller | /grill |
| Write a product spec | spec-driven-development | /spec |
| Design system architecture | architecture-and-contracts | /architect |
| Research competitors | competitive-analysis | /compete |
| Plan go-to-market | gtm-strategy | /gtm |
| Check security and compliance | security-and-compliance | /secure |
| Test if it scales | scalability-analysis | /scale |
| Validate decisions externally | cross-validation | /validate |
| Break work into tasks | planning-and-task-breakdown | /plan |
| Run agents in parallel | parallel-execution-strategy | /parallel |
| Implement a task with TDD | incremental-implementation + tdd | /build |
| Design REST endpoints | api-design | /api |
| Design database schema | database-design | /db |
| Build component library | design-system | /design |
| Define interaction rules | interaction-patterns | /interaction |
| Create demo/test data | seed-data-and-fixtures | /seed |
| Define test pyramid | testing-strategy | /test-strategy |
| Set up error handling | error-handling-and-resilience | /errors |
| Add monitoring | observability | /observe |
| Set latency/cost budgets | performance-and-cost-optimization | /perf |
| Handle an outage | incident-response-and-postmortems | /incident |
| Debug a problem | debugging-and-recovery | (auto-triggers) |
| Triage a bug | triage-issue | (auto-triggers) |
| Review code | code-review-and-quality | /review |
| Track tech debt | refactoring-and-tech-debt | /debt |
| Check accessibility | accessibility | /a11y |
| Fix doc rot | documentation-hygiene | /docs |
| Prepare a demo | demo-narrative | /demo |
| Manage git workflow | git-workflow | (auto-triggers) |
| Ship to production | shipping-and-launch | /ship |
| Redact before sharing | redaction-and-cleanup | /redact |
