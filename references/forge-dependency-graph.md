# forge Dependency Graph

The canonical dependency map for all `.forge/` artifacts. This file is the source of truth for the `forge-sync` skill.

> **Update this graph when adding new skills that produce `.forge/` artifacts.**

## Chained dependencies

```
.forge/idea-brief.md
   └─▶ .forge/prd.md
         ├─▶ .forge/architecture.md
         │     ├─▶ .forge/contracts/*.md
         │     ├─▶ .forge/adr/*.md
         │     ├─▶ .forge/api-design.md
         │     ├─▶ .forge/database-design.md
         │     ├─▶ .forge/migrations-policy.md
         │     ├─▶ .forge/security.md
         │     ├─▶ .forge/scalability.md
         │     ├─▶ .forge/error-handling.md
         │     └─▶ .forge/observability.md
         ├─▶ .forge/competitive.md
         │     └─▶ .forge/gtm.md
         ├─▶ .forge/testing-strategy.md
         └─▶ .forge/tasks.yaml         (depends on prd.md + architecture.md + contracts/*)
               ├─▶ .forge/tasks-summary.md
               └─▶ .forge/parallel-plan.md
```

`gtm.md` reads both `.forge/prd.md` and `.forge/competitive.md`. `tasks.yaml` reads `prd.md`, `architecture.md`, and all of `contracts/`. `cross-validation-prompt.md` reads any `.forge/` artifact the user wants reviewed (typically `prd.md` + `architecture.md`).

## Independent artifacts (no upstream dependency)

These can be generated at any point in the pipeline. They don't have an enforced upstream because their inputs are project-wide conventions, not pipeline artifacts:

```
.forge/design-system.md
.forge/interaction-patterns.md
.forge/seed-data.md
.forge/accessibility.md
.forge/demo-narrative.md          (depends on .forge/seed-data.md if it exists)
.forge/docs-policy.md
.forge/performance-budget.md
.forge/incident-response.md
.forge/tech-debt-registry.md
```

`demo-narrative.md` is the one "soft" dependency in this list — if `.forge/seed-data.md` exists, the demo scenes should reference its named scenarios. If it doesn't, the demo skill produces its own seed-data requirements.

## Externally-fed artifacts

```
.forge/cross-validation-prompt.md   (Phase 1 — produced by cross-validation, reads any .forge/ artifact)
.forge/cross-validation-synthesis.md (Phase 2 — produced by cross-validation, reads reviewer responses)
.forge/redaction-manifest.md         (produced by redaction-and-cleanup, reads any .forge/ artifact)
.forge/redacted/*                    (produced by redaction-and-cleanup, copies of originals)
.forge/sync-report.md                (produced by forge-sync, reads every .forge/ file)
```

## Cascade rules

When an upstream artifact changes, every downstream artifact is potentially stale:

| Upstream changed | Cascade |
|---|---|
| `idea-brief.md` | `prd.md` → everything below `prd.md` |
| `prd.md` | `architecture.md` → contracts → tasks → competitive → gtm → testing-strategy |
| `architecture.md` | contracts, adr, api-design, database-design, migrations-policy, security, scalability, error-handling, observability, tasks.yaml |
| `contracts/*.md` | `tasks.yaml` (file-list and acceptance criteria may shift) |
| `competitive.md` | `gtm.md` |
| `tasks.yaml` | `tasks-summary.md`, `parallel-plan.md` |
| `seed-data.md` | `demo-narrative.md` (scene seed functions may need re-naming) |

When a downstream artifact is regenerated, no upstream cascade is required — staleness flows downward only.

## How `forge-sync` uses this graph

1. Read this file as the canonical dependency tree.
2. Scan every file in `.forge/` for `<!-- forge:meta -->` headers.
3. For each artifact with dependencies, compare `generated_at` of downstream against `generated_at` of upstream. Downstream older than upstream = stale.
4. Walk the cascade table above to produce the topologically-sorted list of skills to re-run.

## Artifact-producing skills (canonical list)

| Skill | Produces | Reads |
|---|---|---|
| `idea-griller` | `.forge/idea-brief.md` | — |
| `spec-driven-development` | `.forge/prd.md` | `.forge/idea-brief.md` (if exists) |
| `architecture-and-contracts` | `.forge/architecture.md`, `.forge/contracts/*.md`, `.forge/adr/*.md` | `.forge/prd.md` |
| `api-design` | `.forge/api-design.md` | `.forge/architecture.md` |
| `database-design` | `.forge/database-design.md`, `.forge/migrations-policy.md` | `.forge/architecture.md` |
| `security-and-compliance` | `.forge/security.md` | `.forge/architecture.md` + `.forge/contracts/*.md` |
| `scalability-analysis` | `.forge/scalability.md` | `.forge/architecture.md` |
| `error-handling-and-resilience` | `.forge/error-handling.md` | `.forge/architecture.md` |
| `observability` | `.forge/observability.md` | `.forge/architecture.md` |
| `competitive-analysis` | `.forge/competitive.md` | `.forge/prd.md` |
| `gtm-strategy` | `.forge/gtm.md` | `.forge/prd.md` + `.forge/competitive.md` |
| `testing-strategy` | `.forge/testing-strategy.md` | `.forge/prd.md` |
| `planning-and-task-breakdown` | `.forge/tasks.yaml`, `.forge/tasks-summary.md` | `.forge/prd.md` + `.forge/architecture.md` + `.forge/contracts/*.md` |
| `parallel-execution-strategy` | `.forge/parallel-plan.md` | `.forge/tasks.yaml` |
| `cross-validation` | `.forge/cross-validation-prompt.md`, `.forge/cross-validation-synthesis.md` | any `.forge/` artifact |
| `design-system` | `.forge/design-system.md` | — (independent) |
| `interaction-patterns` | `.forge/interaction-patterns.md` | — (independent) |
| `seed-data-and-fixtures` | `.forge/seed-data.md` | — (independent) |
| `accessibility` | `.forge/accessibility.md` | — (independent) |
| `demo-narrative` | `.forge/demo-narrative.md` | `.forge/seed-data.md` (soft, if exists) |
| `documentation-hygiene` | `.forge/docs-policy.md` | — (independent) |
| `performance-and-cost-optimization` | `.forge/performance-budget.md` | — (independent — measurement-driven, not artifact-chain-driven) |
| `incident-response-and-postmortems` | `.forge/incident-response.md` | — (independent) |
| `refactoring-and-tech-debt` | `.forge/tech-debt-registry.md` | — (independent) |
| `redaction-and-cleanup` | `.forge/redaction-manifest.md`, `.forge/redacted/*` | any `.forge/` artifact |
| `forge-sync` | `.forge/sync-report.md` | every `.forge/` file + this graph |
