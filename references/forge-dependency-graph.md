# forge Dependency Graph

The canonical dependency map for all `.forge/` artifacts. This file is the source of truth for the `forge-sync` skill.

> **Update this graph when adding new skills that produce `.forge/` artifacts.**

## `forge:meta` header schema

Every artifact-producing skill MUST prepend a header to its output. This is the source of truth that `forge-sync` reads.

```
<!-- forge:meta
generated_by: <skill-name>
generated_at: <ISO 8601 UTC with Z suffix>
depends_on: [<list of .forge/ paths>]
content_hash: <first 8 chars of sha256 over the file body excluding this header>
-->
```

For YAML files, use comment form:

```
# forge:meta
#   generated_by: <skill-name>
#   generated_at: <ISO 8601 UTC with Z suffix>
#   depends_on: [<list of .forge/ paths>]
#   content_hash: <first 8 chars of sha256 over the file body excluding this header>
```

**Schema rules — enforced by `forge-sync`:**

1. **`generated_at` MUST be UTC with `Z` suffix.** Example: `2026-05-14T08:30:00Z`. Local-time strings or offset suffixes (`+05:30`) are rejected — string comparison across timezones produces false staleness signals.
2. **`content_hash` is sha256 of the file body with the `forge:meta` block stripped**, truncated to the first 8 hex characters. If the on-disk content's hash doesn't match the stored hash, the artifact is **MODIFIED** (hand-edited after generation) and downstream is potentially stale even if `generated_at` is current.
3. **`depends_on` lists every `.forge/` artifact the skill READ to produce this output.** Glob patterns allowed (`.forge/contracts/*.md`). See "co-output rule" below for multi-output skills.
4. **`generated_by` is the kebab-case skill name** — must match an entry in `references/forge-dependency-graph.md`'s "Artifact-producing skills" table.

## Co-output rule

When one skill produces multiple artifacts in a single run (e.g., `planning-and-task-breakdown` writes both `tasks.yaml` and `tasks-summary.md`), **every co-output shares the upstream dependency set**. Not the immediate sibling.

| Skill | Co-outputs | Shared `depends_on` |
|---|---|---|
| `planning-and-task-breakdown` | `tasks.yaml`, `tasks-summary.md` | `[prd.md, architecture.md, contracts/*]` — both files |
| `parallel-execution-strategy` | `parallel-plan.md` | `[prd.md, architecture.md, contracts/*, tasks.yaml]` — transitive |
| `architecture-and-contracts` | `architecture.md`, `contracts/*.md`, `adr/*.md` | `[prd.md]` — all three groups |
| `database-design` | `database-design.md`, `migrations-policy.md` | `[architecture.md]` — both files |
| `cross-validation` | `cross-validation-prompt.md`, `cross-validation-synthesis.md` | inputs depend on what was reviewed |

**Why:** the alternative ("derivative" semantic where `tasks-summary` only depends on `tasks.yaml`) creates a silent staleness bug. If `prd.md` is edited after generation, only `tasks.yaml` is flagged stale; `tasks-summary.md` passes UP_TO_DATE because its single declared dep shares its generation timestamp. By pinning co-output to the full upstream set, both artifacts flip stale together.

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
| `parallel-execution-strategy` | `.forge/parallel-plan.md` | `.forge/prd.md` + `.forge/architecture.md` + `.forge/contracts/*.md` + `.forge/tasks.yaml` (transitive — see co-output rule) |
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
