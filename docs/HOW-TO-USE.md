# How to Use forge-skills

A practical, example-driven walkthrough. If you read this end-to-end, you'll be using forge-skills on a real project in about 10 minutes.

---

## 1. Quick Start (2 minutes)

**Install (recommended — Claude Code plugin marketplace):**

```
/plugin marketplace add aneja5/forge-skills
/plugin install forge-skills@forge-skills
```

That's it. Skills, agents, slash commands, and the session-start hook all load automatically. No clone, no copy.

**Manual clone (if not using the marketplace):**

```bash
git clone https://github.com/aneja5/forge-skills.git ~/.claude/forge-skills
cp -r ~/.claude/forge-skills/skills ~/.claude/skills
cp -r ~/.claude/forge-skills/agents ~/.claude/agents
cp -r ~/.claude/forge-skills/commands ~/.claude/commands
```

**One-line mental model:**

> Skills are structured workflows, not reference docs. They tell the agent *what to do, in what order, and what to verify before declaring done* — they don't tell it facts.

**What goes in your project root:**

- `CLAUDE.md` (Claude Code) or `AGENTS.md` (Cursor / Gemini / others) — describes your project so the agent has context. Template at the bottom of this guide.
- `.forge/` — auto-created by skills. Holds the artifact chain (idea-brief, prd, architecture, contracts, tasks, etc.). Add to `.gitignore` for local-only, or commit to share with the team.
- `context/` (optional) — pre-research, interview transcripts, customer notes. Skills will read this if it exists.

---

## 2. The Lifecycle — When to Use What

Walking through a real example: **building a B2B SaaS product**.

### "I have a vague idea"
**→** `idea-griller` **→** `.forge/idea-brief.md`

```
/grill

I want to build a tool that helps remote teams run async standups
without slack noise. Grill me.
```

### "I want to write a spec"
**→** `spec-driven-development` **→** `.forge/prd.md`

```
/spec

Read .forge/idea-brief.md and write a PRD. Cover user roles,
core flows, data model, success metrics, and out-of-scope.
```

### "I need to research competitors"
**→** `competitive-analysis` **→** `.forge/competitive.md`

```
/compete

We're building from .forge/prd.md. Research direct competitors
(Geekbot, Standuply, Range) and indirect (Slack threads, Notion).
Build feature matrix, win/lose scenarios, positioning.
```

### "Design the system"
**→** `architecture-and-contracts` **→** `.forge/architecture.md` + `contracts/` + `adr/`

```
/architect

Read .forge/prd.md. Design modules, write interface contracts
between them, log every architecturally significant decision as
an ADR. Include cost model.
```

### "Is this secure?"
**→** `security-and-compliance` **→** `.forge/security.md`

```
/secure

Read .forge/architecture.md and contracts/. Run STRIDE threat model,
inventory all PII, scan for GDPR/SOC 2 applicability, build
certification roadmap.
```

### "Will this scale?"
**→** `scalability-analysis` **→** `.forge/scalability.md`

```
/scale

Targets: 10x = 5k teams, 100x = 50k teams, 1000x = 500k teams.
Identify bottlenecks at each tier, project costs, define migration
triggers.
```

### "How do we sell this?"
**→** `gtm-strategy` **→** `.forge/gtm.md`

```
/gtm

Reads .forge/prd.md and .forge/competitive.md. Define ICP, wedge
feature, pilot program, sales channels, ROI calculator.
```

### "Break it into tasks"
**→** `planning-and-task-breakdown` **→** `.forge/tasks.yaml` + `.forge/tasks-summary.md`

```
/plan

Read prd.md, architecture.md, contracts/. Break into vertical-slice
tasks (≤2 modules each). Output tasks.yaml + day-by-day summary.
```

### "Validate before building"
**→** `cross-validation` **→** `.forge/cross-validation-prompt.md`

```
/validate

Generate a self-contained reviewer prompt covering architecture,
security, scalability, business model, and risks. I'll send it
to 3 senior engineers.
```

(Later, when responses come back: `/validate` again with their answers — produces `cross-validation-synthesis.md`.)

### "Start building"
**→** `incremental-implementation` + `tdd` **→** code + commits

```
/build

Execute tasks.yaml one task at a time. TDD discipline: red, green,
refactor. Verify against the contract for each module before commit.
```

### "Something broke"
**→** `debugging-and-recovery`

```
The standup digest endpoint returns 500 when a team has zero
members. Reproduce, isolate, fix, write the regression test that
would have caught it.
```

### "Review code"
**→** `code-review-and-quality`

```
/review

Five-axis review of the diff: correctness, contracts, tests,
security, simplicity. Block merge if any axis fails.
```

### "Ready to share externally"
**→** `redaction-and-cleanup` **→** `.forge/redacted/`

```
/redact

Categories: pricing, internal team names, vendor contracts.
Keep: architecture patterns, public feature names. Copy to
.forge/redacted/ — never modify originals.
```

### "Deploy"
**→** `shipping-and-launch`

```
/ship

Run the six-domain pre-launch gate. Output go/no-go + rollback
plan.
```

---

## 3. The Artifact Chain

```
idea-brief.md
     ↓
   prd.md ──────────────┬─────────────┬──────────────┐
     ↓                  ↓             ↓              ↓
architecture.md    competitive.md   gtm.md     (skipped: rebuild later)
+ contracts/            ↓             
+ adr/             gtm.md (also reads competitive.md)
     ↓
  ┌──┴──┬──────────┬──────────┐
  ↓     ↓          ↓          ↓
tasks  security  scalability  cross-validation
.yaml  .md       .md          -prompt.md
  ↓
code + commits
  ↓
review → ship
```

**What happens if you skip a step:**

- Skip `idea-griller` → spec-driven-development asks the questions itself (slower, less focused).
- Skip `architecture-and-contracts` → tasks.yaml has unclear module boundaries; parallel work will conflict.
- Skip `planning-and-task-breakdown` → incremental-implementation has no plan, agent improvises.
- Skip `cross-validation` → no external pressure-test; you find out about gaps in production.

**Restart from the middle:**

You can join the pipeline at any stage if the *previous* artifact exists. Have a PRD but no architecture? Run `/architect` — it reads `.forge/prd.md` and produces architecture from there. The skills don't care how the artifact got there, only that it's present.

---

## 4. Example Prompts (copy-paste ready)

### idea-griller
```
/grill — I want to build an AI tutoring app for high school math. Grill me.
/grill — We're thinking about adding a marketplace to our SaaS. Pressure-test it.
/grill — A subscription box for indie board games. Should we build this?
```

### spec-driven-development
```
/spec — Write a PRD for a mobile expense tracking app. Target: freelancers.
/spec — I have research in context/CONTEXT.md. Skip the interview, generate .forge/prd.md.
/spec — Read .forge/idea-brief.md and produce the PRD.
```

### competitive-analysis
```
/compete — Research Notion, Coda, Slite. We're building a team wiki. Use .forge/prd.md.
/compete — Map competitors for our async standup tool. Direct + indirect. Honest about where we lose.
```

### architecture-and-contracts
```
/architect — Read .forge/prd.md. Design modules + contracts + ADRs. Include cost model.
/architect — Re-architect the auth module. Existing PRD is in .forge/prd.md.
```

### security-and-compliance
```
/secure — Run STRIDE on .forge/architecture.md. PII inventory, GDPR scan, certification roadmap.
/secure — We process payment data. Scan for PCI scope and SOC 2 readiness.
```

### scalability-analysis
```
/scale — 10x/100x/1000x targets from current 1k DAU. Bottlenecks, costs, triggers.
/scale — We're hitting DB CPU at 80%. Identify the next bottleneck and the migration plan.
```

### gtm-strategy
```
/gtm — Read prd.md + competitive.md. ICP, wedge, pilot program, ROI calc.
/gtm — We have a working prototype. Build the launch plan for early adopters.
```

### planning-and-task-breakdown
```
/plan — Break .forge/architecture.md into vertical-slice tasks. Output tasks.yaml + summary.
/plan — Re-plan with a 2-engineer team for 3-week sprint.
```

### cross-validation
```
/validate — Generate the reviewer prompt. I'm sending to 3 senior engineers.
/validate — Reviewer responses are in context/reviews/. Synthesize.
```

### incremental-implementation
```
/build — Execute tasks.yaml. TDD discipline. One task per commit.
/build — Pick up at TASK-007. Tests-first. Stop at first contract violation.
```

### debugging-and-recovery
```
The signup webhook fires twice for some users. Reproduce → isolate → fix → guard.
Production is throwing a NullPointerException in OrderService::finalize. Triage.
```

### code-review-and-quality
```
/review — Five-axis review of the current diff. Block merge if any axis fails.
/review — Review PR #142 against the OrderService contract.
```

### redaction-and-cleanup
```
/redact — Redact pricing, vendor names, internal headcount. Keep architecture and feature names.
/redact — Prep .forge/ for sharing with a potential investor. Categories: financials, customer names.
```

### shipping-and-launch
```
/ship — Six-domain pre-launch gate. Go/no-go + rollback plan.
/ship — We launch Tuesday. Walk the gate, flag every blocker.
```

### triage-issue
```
Bug: form submission silently fails on Safari iOS 16. Triage and write the GitHub issue + TDD plan.
```

---

## 5. Tips for Maximum Output Quality

**Front-load context.** If you have research, customer interviews, or domain notes, put them in `context/CONTEXT.md` and tell the skill to read it first. spec-driven-development has a context-loaded mode that skips the interview entirely.

**Be exhaustive — say so explicitly.** "Cover all edge cases" or "list every assumption" produces noticeably more thorough output than the default.

**Include *why* for every decision.** "Use Postgres" is generic. "Use Postgres because we need ACID for billing rows" is specific and survives the next person reading it.

**Chain artifacts deliberately.** Generate the PRD first. Architecture should explicitly reference PRD sections. tasks.yaml should reference architecture modules. Each artifact gets richer when grounded in the previous one.

**"Expand every section" as a follow-up.** After the first pass, ask the skill to deepen specific sections. Often produces 2-3x more useful detail than re-running from scratch.

**Use context-loaded mode when you have research.** If `context/CONTEXT.md` is >500 lines, spec-driven-development skips interviewing and goes straight to module design.

---

## 6. Common Mistakes

- **Starting with architecture before writing the PRD.** Architecture without requirements is a guess.
- **Skipping idea-griller because "I already know what I'm building."** Most ideas have unexamined assumptions. The grill takes 10 minutes and reveals them.
- **Not reading the skill before invoking it.** Skills evolve. The version in your head may be stale.
- **Treating tasks.yaml as rigid.** It's a structure, not a prison. Re-run /plan when scope changes.
- **Forgetting to sync .forge/ artifacts into team docs.** If your team works out of `docs/`, mirror the artifacts there or pin links.
- **Running /build before /architect.** No contracts means parallel work diverges fast.
- **Skipping /review because "it's just a small change."** The 5-axis check catches things by design — small changes are where defects hide.

---

## 7. Project Setup Template

Folder structure for a new project:

```
my-project/
├── CLAUDE.md                # Project context (template below)
├── context/
│   └── CONTEXT.md           # Your research, interviews, notes
├── .forge/                  # Pipeline artifacts (auto-generated)
│   ├── adr/
│   ├── contracts/
│   └── redacted/            # Created by /redact only
└── docs/                    # Team-facing copies (optional)
    ├── architecture/
    ├── competitive/
    ├── planning/
    └── security/
```

> **Install forge-skills as a plugin** (`/plugin marketplace add aneja5/forge-skills`). Skills load automatically. No need to clone into your project.

### Starter CLAUDE.md template

```markdown
# my-project

## What this is
[1–2 sentence description of the product / repo]

## Stack
- Runtime: [Node 22 / Python 3.12 / etc.]
- Framework: [Next.js / FastAPI / etc.]
- Datastore: [Postgres / DynamoDB / etc.]
- Hosted on: [AWS / Vercel / Fly.io / etc.]

## Important conventions
- Tests live next to the code: `foo.ts` + `foo.test.ts`
- Commits are atomic and follow Conventional Commits
- All public APIs go through contracts in `.forge/contracts/`

## Where context lives
- Customer research: `context/CONTEXT.md`
- Pipeline artifacts: `.forge/`
- Team docs: `docs/`

## When in doubt
Use forge-skills. Start with `/grill` for new ideas, `/spec` for new features.
```

---

## 8. Real Case Study

A sales coaching SaaS used forge-skills end-to-end for its initial planning sprint.

- **Skipped `/grill`** — the founder had already validated the idea with 30+ design partners.
- **`/spec`** produced a **1,255-line PRD** covering 9 product areas (onboarding, call recording, AI scoring, coaching workflows, manager dashboards, billing, compliance, integrations, mobile).
- **`/architect`** produced a **940-line architecture document** plus **7 interface contracts** and **12 ADRs** (decisions on event bus, multi-tenancy, ML inference path, audio storage, etc.).
- **`/plan`** produced **100 tasks across 28 days** with a critical-path map and risk-day callouts.
- Then 7 supplementary documents: competitive landscape, GTM plan, security assessment, scalability analysis, microservices design, feature priority matrix, testing strategy.
- **Total output: 33 documents, 11,521 lines.** Most produced in single-shot prompts; some expanded with follow-up "deepen this section" passes.

The gaps surfaced during this run drove the v2.0.0 release: there was no dedicated competitive-analysis skill, no security-and-compliance skill, no scalability-analysis skill, no GTM skill, no cross-validation skill, and no redaction skill for sharing with external reviewers. All six exist now, and the pipeline supports the same lifecycle without ad-hoc prompting.

The lesson: when you're about to write a one-off prompt for the third time, that's a skill.
