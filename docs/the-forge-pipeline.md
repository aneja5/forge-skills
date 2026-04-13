# The Forge Pipeline

The forge pipeline is a chain of skills where each skill's output is the next skill's input. The artifacts live in `.forge/` — a directory created in your project root when you start the pipeline.

## Full Pipeline

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           THE FORGE PIPELINE                                │
├──────────┬──────────┬───────────┬──────────┬──────────┬──────────┬─────────┤
│  DEFINE  │  SPECIFY │  DESIGN   │   PLAN   │  BUILD   │  REVIEW  │  SHIP   │
│          │          │           │          │          │          │         │
│  /grill  │  /spec   │ /architect│  /plan   │  /build  │ /review  │  /ship  │
│          │          │           │          │          │          │         │
│  idea-   │  spec-   │ architect-│ planning-│ incremen-│  code-   │shipping-│
│ griller  │ driven-  │   and-    │   and-   │  tal-    │ review-  │  and-   │
│          │  devel-  │ contracts │   task-  │ implem-  │  and-    │ launch  │
│          │  opment  │           │ breakdown│  entation│ quality  │         │
└────┬─────┴────┬─────┴─────┬─────┴────┬─────┴────┬─────┴────┬─────┴────┬────┘
     │          │           │          │          │          │          │
     ▼          ▼           ▼          ▼          ▼          ▼          ▼
.forge/     .forge/     .forge/    .forge/   code +    review    go/no-go
idea-       prd.md      arch-      tasks.    commits   findings   decision
brief.md                itecture.  yaml      + tests
                        md
                        .forge/
                        contracts/
                        *.md
                        .forge/
                        adr/*.md
```

## Artifacts in Detail

### `.forge/idea-brief.md`
Produced by: `idea-griller` (`/grill`)
Consumed by: `spec-driven-development` (`/spec`)

Contains: the 7-branch interview output — problem, founder fit, solution, business model, distribution, risks, MVP, and open assumptions. Gives `spec-driven-development` enough context to skip discovery and go straight to requirements.

### `.forge/prd.md`
Produced by: `spec-driven-development` (`/spec`)
Consumed by: `architecture-and-contracts`, `planning-and-task-breakdown`

Contains: problem statement, personas, Given/When/Then functional requirements, NFRs, data model, module design, release phases, out of scope, open assumptions.

### `.forge/architecture.md`
Produced by: `architecture-and-contracts` (`/architect`)
Consumed by: `planning-and-task-breakdown`, `incremental-implementation`

Contains: system overview, component diagram (text), tech stack decisions with rationale, table of all contracts.

### `.forge/contracts/<module>.md`
Produced by: `architecture-and-contracts` (`/architect`)
Consumed by: `incremental-implementation`, `code-review-and-quality`

Contains: what the module provides, what it consumes, input types, output types, error types, invariants, not-responsible-for list. One file per module boundary.

### `.forge/adr/<NNN>-<slug>.md`
Produced by: `architecture-and-contracts` (`/architect`)
Consumed by: all future decisions (reference only)

Contains: context, decision, consequences, alternatives considered. One file per non-obvious architectural decision.

### `.forge/tasks.yaml`
Produced by: `planning-and-task-breakdown` (`/plan`)
Consumed by: `incremental-implementation` (`/build`)

Contains: task list with IDs, sizes, acceptance criteria, verification steps, contracts referenced, files likely affected, dependencies, and status.

## Joining Mid-Pipeline

You don't have to start at `/grill`. The pipeline is designed so you can join at any stage if you already have the upstream artifact:

| You have... | Start at... |
|-------------|-------------|
| A raw idea | `/grill` |
| A fleshed-out idea | `/spec` |
| A PRD | `/architect` |
| Architecture + contracts | `/plan` |
| A task plan | `/build` |
| Completed code | `/review` |
| Reviewed code | `/ship` |

## What the Pipeline Prevents

Without the pipeline:

- **Specification bugs** — the most expensive kind. Coding before specifying locks in wrong assumptions.
- **Interface mismatch** — two engineers build to different assumptions, discover it at integration time.
- **Scope creep** — each task grows because there's no explicit out-of-scope list.
- **Brittle tests** — tests written after implementation test implementation shape, not behavior.
- **Surprise at launch** — no pre-launch gate, so security/observability/documentation gaps survive to production.

With the pipeline:

- Every feature starts with a written problem statement
- Every module boundary has a contract before implementation
- Every task has acceptance criteria before a line is written
- Every test is written before its implementation (TDD)
- Every launch goes through a six-domain pre-launch gate

## The .forge/ Directory

Add `.forge/` to `.gitignore` to keep it local, or commit it to share context with teammates and preserve the decision trail. The artifacts are meant to be human-readable and useful for code review, onboarding, and architectural retrospectives.
