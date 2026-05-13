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

### "Commit and prepare the PR"
**→** `git-workflow`

No `.forge/` artifact — this one shapes git history directly. Atomic
commits per logical change, conventional commit prefixes
(`feat:` / `fix:` / `refactor:` / `docs:` / `test:` / `chore:`),
no-behavior-change refactors land before behavior changes that depend
on them, and commit messages explain the WHY, not just the WHAT.

```
Commit these changes. 3 distinct logical units across 8 files —
split them: refactor first, then CSRF feature with its docs, then
the avatar feature. Conventional commit messages explaining why.
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

### Design-phase additions (v3.0)

After `architecture-and-contracts`, four design-layer skills deepen specific surfaces.

**`api-design` → `.forge/api-design.md`** — REST conventions, error envelopes, versioning, pagination, idempotency.
```
/api

Define the error envelope schema, versioning policy, pagination
shape, and idempotency rules for every public endpoint.
```

**`database-design` → `.forge/database-design.md` + `.forge/migrations-policy.md`** — schema conventions, FK rules, migration safety, query review.
```
/db

Set naming conventions, audit columns, migration guardrails
(reversibility, idempotency, locking-aware), and the query-review
checklist. Identify partition candidates.
```

**`design-system` → `.forge/design-system.md`** — semantic token layer, primitive components with all 6 states, dark-mode parity.
```
/design

Establish brand foundation, two-layer tokens (reference + semantic),
spacing/radius/motion scales, primitive components (Button / Input /
Card) with default/hover/active/focus-visible/disabled/loading/error.
```

**`interaction-patterns` → `.forge/interaction-patterns.md`** — modal-vs-sheet, expand-vs-navigate, optimistic UI, undo vs confirm.
```
/interaction

Decide the canonical pattern per interaction primitive. Mobile modals
are bottom sheets. Destructive actions get undo or confirm — never
neither. 44pt tap target minimum.
```

### Plan-phase additions

**`parallel-execution-strategy` → `.forge/parallel-plan.md`** — file-conflict matrix, worktree isolation, merge order, integration-test cadence.
```
/parallel

Read .forge/tasks.yaml. Identify dependency-free groups, build
file-conflict matrix, assign one branch + one worktree per task,
fix the merge order before dispatch.
```

**`seed-data-and-fixtures` → `.forge/seed-data.md`** — realistic data for dev, tests, and demos. Idempotent factories with overrides.
```
/seed

Inventory entities needing seed. Define realistic distributions
(names across cultures, timestamps with curves, weighted statuses).
Write idempotent factories keyed by stable IDs. Edge cases included.
```

**`testing-strategy` → `.forge/testing-strategy.md`** — test pyramid, mocking boundaries, coverage targets, flake policy, CI gates.
```
/test-strategy

Identify critical user paths. Set test level per path
(unit/integration/e2e). Mock at seams, never internals. Per-component
coverage targets. Flake quarantine policy.
```

### Operate, observe, respond

**`error-handling-and-resilience` → `.forge/error-handling.md`** — failure classification, retries with backoff, circuit breakers, user-facing messages.
```
/errors

Classify every failure mode as transient / permanent /
user-correctable. Add timeouts, max-attempts, deadlines, idempotency
keys. Document compensation for irreversible flows.
```

**`observability` → `.forge/observability.md`** — correlation IDs, golden signals, SLOs, alert thresholds, runbook links, log redaction.
```
/observe

Define trace ID propagation. List golden signals (RED) per service.
SLOs with page-worthy vs ticket-worthy thresholds. Every alert links
a runbook. PII redaction documented.
```

**`performance-and-cost-optimization` → `.forge/performance-budget.md`** — latency budgets, LLM cost budgets, cache strategy, bundle limits.
```
/perf

Set latency budgets per request type. LLM cost budget per call type
with max_tokens. Cache key schema + TTLs + invalidation events.
Frontend bundle <200KB initial JS.
```

**`incident-response-and-postmortems` → `.forge/incident-response.md`** — severity definitions, response flow, runbook template, blameless postmortems.
```
/incident

Define Sev1-4 with response SLAs. Declare → mitigate → communicate
→ resolve → review flow. Runbook per critical service. Blameless
postmortem template.
```

### Polish, ship, share

**`accessibility` → `.forge/accessibility.md`** — WCAG AA baseline, semantic HTML, ARIA discipline, keyboard nav, contrast, reduced-motion.
```
/a11y

Audit semantic HTML usage. Review ARIA (sparingly). Verify keyboard
nav, focus return on overlay close, 4.5:1 contrast on body, prefers-
reduced-motion respected.
```

**`refactoring-and-tech-debt` → `.forge/tech-debt-registry.md`** — debt registry with triggers, strangler-fig for rewrites, refactor-only PRs.
```
/debt

Walk the codebase. Inventory debt with location, cost-to-fix,
cost-of-not-fixing, owner, trigger (third-occurrence, adjacent-work,
budget-breach). Assign pattern per item.
```

**`demo-narrative` → `.forge/demo-narrative.md`** — scripted scenes, wow moments, fallbacks, dry-run checklist.
```
/demo

Audience + goal + one key insight. 5-7 scenes (setup → tension →
wow → resolution). Named seed function and fallback GIF per scene.
Dry-run within 24h.
```

**`documentation-hygiene` → `.forge/docs-policy.md`** — README standards, in-code comment policy (WHY not WHAT), changelog discipline.
```
/docs

Define README standard for repo and subdirectories. Comment policy
explains WHY. Doc-rot prevention via dates, code permalinks, owners.
Keep-a-Changelog format per release.
```

### Cross-cutting

**`forge-sync` → `.forge/sync-report.md`** — Check `.forge/` artifact freshness against the canonical dependency graph. Read-only diagnosis; produces the cascade order to re-sync.
```
/sync

Scan every .forge/ artifact for forge:meta headers. Compare timestamps
against references/forge-dependency-graph.md. Report what's stale,
what's up to date, and the exact skill cascade order to bring
everything back in sync.
```

---

## 3. The Artifact Chain

```
idea-brief.md (idea-griller)
     ↓
   prd.md (spec-driven-development)
     ↓
── DESIGN FAN-OUT ─────────────────────────────────────────────
architecture.md + contracts/ + adr/    (architecture-and-contracts)
api-design.md                          (api-design)
database-design.md + migrations-policy (database-design)
design-system.md                       (design-system)
interaction-patterns.md                (interaction-patterns)
     ↓
── VALIDATE BEFORE BUILDING ───────────────────────────────────
competitive.md  scalability.md  security.md  gtm.md
cross-validation-prompt.md → cross-validation-synthesis.md
     ↓
── PLAN ───────────────────────────────────────────────────────
tasks.yaml + tasks-summary.md  (planning-and-task-breakdown)
parallel-plan.md               (parallel-execution-strategy)
seed-data.md                   (seed-data-and-fixtures)
testing-strategy.md            (testing-strategy)
     ↓
── BUILD & OPERATE ────────────────────────────────────────────
code + commits         (incremental-implementation + tdd)
error-handling.md      (error-handling-and-resilience)
observability.md       (observability)
performance-budget.md  (performance-and-cost-optimization)
incident-response.md   (incident-response-and-postmortems)
     ↓
── POLISH & SHIP ──────────────────────────────────────────────
accessibility.md       (accessibility)
tech-debt-registry.md  (refactoring-and-tech-debt)
demo-narrative.md      (demo-narrative)
docs-policy.md         (documentation-hygiene)
     ↓
review → ship → (optional) redaction-manifest.md + redacted/
```

**What happens if you skip a step:**

- Skip `idea-griller` → spec-driven-development asks the questions itself (slower, less focused).
- Skip `architecture-and-contracts` → tasks.yaml has unclear module boundaries; parallel work will conflict.
- Skip `design-system` → 50 components with 50 different spacing values when you go to add the 51st.
- Skip `error-handling-and-resilience` / `observability` → first 3am page has no runbook and no dashboard to look at.
- Skip `parallel-execution-strategy` → 5 agents merge into the same file and produce conflicts that take longer to resolve than the work took to produce.
- Skip `planning-and-task-breakdown` → incremental-implementation has no plan, agent improvises.
- Skip `cross-validation` → no external pressure-test; you find out about gaps in production.
- Skip `accessibility` / `documentation-hygiene` → retrofitting costs 5-10x.

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

### api-design
```
/api — Define error envelope, versioning, pagination shape, idempotency for /v1/orders, /v1/payments.
/api — Audit our existing endpoints. Every 200-with-error gets flagged.
/api — Public-vs-internal boundary review. Tag every endpoint.
```

### database-design
```
/db — Set conventions for a new Postgres schema. FK rules, audit columns, soft-delete policy.
/db — Audit migrations from the last quarter. Flag ALTER TABLE without locking review.
/db — EXPLAIN every hot-path query. Identify partition candidates over 100M rows.
```

### design-system
```
/design — Build a token system for a B2B SaaS dashboard. Tailwind + TypeScript. WCAG AA.
/design — Audit our component library — find every raw hex and every missing state.
/design — Add dark mode parity. Semantic layer remapping, not a rewrite.
```

### interaction-patterns
```
/interaction — Decide: modal vs bottom sheet on mobile. Optimistic vs pessimistic UI for edits.
/interaction — Audit our destructive actions. Every one needs undo or confirm.
/interaction — Map the keyboard contract — Esc, Tab order, focus return on overlay close.
```

### seed-data-and-fixtures
```
/seed — Build seed scenarios for our demo narrative — 5 scenes, idempotent, realistic.
/seed — Replace lorem ipsum across the dev environment with culturally-varied real-feeling data.
/seed — Add edge cases — long names, all-caps, missing optional fields, overflow counts.
```

### testing-strategy
```
/test-strategy — Define the pyramid for our app. Critical paths get e2e. Mock at HTTP, not at modules.
/test-strategy — Audit our test suite for internal mocks. List violations.
/test-strategy — Flake rate is 4%. Triage the top 10 offenders and write the quarantine policy.
```

### parallel-execution-strategy
```
/parallel — Read tasks.yaml. Build file-conflict matrix and dispatch plan for 5 parallel agents.
/parallel — Tasks T-002 and T-004 both touch auth/middleware.ts. Resolve before dispatch.
/parallel — Set worktree assignments, branch names, merge order, integration-test cadence.
```

### error-handling-and-resilience
```
/errors — Service makes 3 external API calls. Classify failures, add timeouts, retries, circuit breakers.
/errors — Inventory failure modes for the payment flow. Define compensation actions.
/errors — Build the user-facing error message catalog. Stable codes, non-technical text.
```

### observability
```
/observe — Define golden signals for the API gateway. SLOs, alerts, runbook links.
/observe — Add trace ID propagation through every service. Audit log redaction for PII.
/observe — Audit our alerts. Flag every alert that fires >10x/day without ack — fatigue.
```

### performance-and-cost-optimization
```
/perf — Set latency budgets per endpoint. Profile the top 3 by traffic. Identify cache candidates.
/perf — Our LLM bill 4x'd last month. Set per-call cost budget, model selection rationale, token caps.
/perf — Frontend bundle is 480KB initial. Split per route, lazy-load editors and charts.
```

### incident-response-and-postmortems
```
/incident — Production is down. Declare Sev1. Mitigate first, root-cause later. Run the comms cadence.
/incident — Write the postmortem for yesterday's outage. Blameless. Action items with owners.
/incident — Define severity levels and on-call procedures. Write the runbook for auth service.
```

### refactoring-and-tech-debt
```
/debt — Walk the codebase for tech debt. Inventory with triggers, owners, costs.
/debt — Plan a strangler-fig migration off the legacy auth module. Don't big-bang it.
/debt — This workaround is in 3 places. Extract it. Refactor-only PR — no behavior change.
```

### accessibility
```
/a11y — Audit our app for WCAG AA. Semantic HTML, ARIA, keyboard, contrast, reduced-motion.
/a11y — Find every div with onClick. Replace with button or document why not.
/a11y — Run the screen reader checklist on the checkout flow. VoiceOver iOS first.
```

### demo-narrative
```
/demo — Series-A pitch in 3 days. 30 min slot, 18 min demo. Script the scenes.
/demo — Audience: VP of Engineering at a 500-person SaaS. Goal: pilot agreement. One key insight.
/demo — Add fallback GIFs for every wow moment. Dry-run tomorrow.
```

### documentation-hygiene
```
/docs — Audit our README. Subdirectory entry-point docs. CHANGELOG discipline.
/docs — Comment policy: explain WHY. Find every comment that restates the code.
/docs — Dead-link scan across the repo. Fix or delete.
```

### forge-sync
```
/sync — I updated the PRD. What's stale?
/sync — Run a sync check before I start building.
/sync — The architecture changed. What needs regenerating?
```

### git-workflow
```
Commit these 8 modified files. Split into atomic commits by logical change.
Refactor before feature in the commit order.
Conventional commit messages — explain the WHY, not just the file list.
```

### For contributors

These skills don't fit the user-facing pipeline — they're for people working on forge-skills itself.

#### writing-skills
```
Write a new skill for code formatting. Use TDD-for-skills:
RED scenario first, observe baseline, write the skill,
GREEN run, refactor.
I'll only commit after we have the test results.
```
```
Audit the rationalizations table in skills/observability — are these
the verbatim quotes we observed in RED, or invented at our desk?
```
```
Review this draft SKILL.md against the writing-skills anatomy.
Does it have all 7 sections? Is the description CSO-compliant
(triggers only, no workflow summary)? Are the Red Flags
agent-level behaviors or project-level conditions?
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
