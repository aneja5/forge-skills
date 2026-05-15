# forge Dependency Graph

The canonical dependency map for all `.forge/` artifacts. This file is the source of truth for the `forge-sync` skill.

> **Update this graph when adding new skills that produce `.forge/` artifacts.**

## `forge:meta` header schema

Every artifact-producing skill MUST prepend a header to its output. This is the source of truth that `forge-sync` reads.

```
<!-- forge:meta
generated_by: <skill-name>
generated_at: <ISO 8601 UTC with Z suffix>
depends_on: [<list of .forge/ paths — paths only, NEVER hashes>]
generated_from:
  <upstream path>: <first 8 chars of upstream's content_hash AT generation time>
  <upstream path>: <first 8 chars of upstream's content_hash AT generation time>
content_hash: <first 8 chars of sha256 over THIS file's body excluding this header>
-->
```

For YAML files, use comment form:

```
# forge:meta
#   generated_by: <skill-name>
#   generated_at: <ISO 8601 UTC with Z suffix>
#   depends_on: [<list of .forge/ paths — paths only, NEVER hashes>]
#   generated_from:
#     <upstream path>: <first 8 chars of upstream's content_hash AT generation time>
#   content_hash: <first 8 chars of sha256 over THIS file's body excluding this header>
```

**Schema rules — enforced by `forge-sync`:**

1. **`generated_at` MUST be UTC with `Z` suffix.** Example: `2026-05-14T08:30:00Z`. Local-time strings or offset suffixes (`+05:30`) are rejected — string comparison across timezones produces false staleness signals.
2. **`content_hash` is sha256 of THIS file's body with the `forge:meta` block stripped**, truncated to the first 8 hex characters. If the on-disk content's hash doesn't match the stored hash, the artifact is **MODIFIED** (hand-edited after generation) and downstream is potentially stale even if `generated_at` is current.
3. **`depends_on` is a list of `.forge/` paths only — NEVER hashes inline.** Glob patterns allowed (`.forge/contracts/*.md`). See "co-output rule" below for multi-output skills.
4. **`generated_from` captures a FROZEN hash snapshot of every upstream at generation time.** One entry per resolved upstream path (globs are expanded). When `forge-sync` runs, it compares each `generated_from` value against the upstream's CURRENT `content_hash`. Mismatch → downstream is STALE. **This is how staleness is detected without ever editing the downstream file.**
5. **`generated_by` is the kebab-case skill name** — must match an entry in `references/forge-dependency-graph.md`'s "Artifact-producing skills" table.

### Why `generated_from` exists (and `depends_on` never holds hashes)

The naive design — putting upstream hashes inline in `depends_on` — creates a **cascade-update problem**: editing `prd.md` would require editing every downstream file's `depends_on` to record the new hash. Each downstream edit changes that file's own `content_hash`, which then requires editing its downstream, and so on. One PRD edit cascades into N file rewrites.

By separating concerns:
- `depends_on` lists *which* upstreams (paths only — never changes when content changes).
- `generated_from` captures *what they looked like* at the moment of generation (a frozen snapshot; only the skill that generates this file ever writes it).
- `content_hash` captures *what this file looks like now* (only edited when this file's body changes).

**Result:** editing an upstream `.forge/` file requires ZERO edits to downstream files. `forge-sync` re-reads the upstream's current `content_hash` at sync time, compares against the downstream's `generated_from` snapshot, and reports STALE if they differ. The chain stays consistent without any cascade-write.

Artifacts with no upstream (`idea-brief.md`, `brand-identity.md`, `interaction-patterns.md`, etc.) emit `depends_on: []` and `generated_from: {}` (or omit both).

## Co-output rule

When one skill produces multiple artifacts in a single run (e.g., `planning-and-task-breakdown` writes both `tasks.yaml` and `tasks-summary.md`), **every co-output shares the upstream dependency set AND the `generated_from` snapshot**. Not the immediate sibling.

| Skill | Co-outputs | Shared `depends_on` + `generated_from` upstreams |
|---|---|---|
| `planning-and-task-breakdown` | `tasks.yaml`, `tasks-summary.md` | `[prd.md, architecture.md, contracts/*]` — both files; each carries its own `content_hash` |
| `parallel-execution-strategy` | `parallel-plan.md` | `[prd.md, architecture.md, contracts/*, tasks.yaml]` — transitive |
| `architecture-and-contracts` | `architecture.md`, `contracts/*.md`, `adr/*.md` | `[prd.md]` — all three groups |
| `database-design` | `database-design.md`, `migrations-policy.md` | `[architecture.md]` — both files |
| `cross-validation` | `cross-validation-prompt.md`, `cross-validation-synthesis.md` | inputs depend on what was reviewed |

**Why:** the alternative ("derivative" semantic where `tasks-summary` only depends on `tasks.yaml`) creates a silent staleness bug. If `prd.md` is edited after generation, only `tasks.yaml` is flagged stale; `tasks-summary.md` passes UP_TO_DATE because its single declared dep shares its generation timestamp. By pinning co-output to the full upstream set — including the snapshot in `generated_from` — both artifacts flip stale together when an upstream's content_hash drifts.

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

### UI chain

The visual / UI artifacts form their own dependency tree rooted at `brand-identity.md`. Run in order: brand → design-system → component-library → page-composition; `data-visualization` branches off design-system + component-library; `interaction-patterns` is independent (no upstream).

```
.forge/brand-identity.md
   └─▶ .forge/design-system.md
         ├─▶ .forge/component-library.md
         │     └─▶ .forge/page-composition.md
         └─▶ .forge/data-visualization.md
.forge/interaction-patterns.md            (independent — referenced by component-library and page-composition)
.forge/polish-checklist.md                (depends on every UI artifact above; runs after /build, before /ship)
```

`component-library.md` reads `design-system.md` + `interaction-patterns.md` + `brand-identity.md`. `page-composition.md` reads `component-library.md` + `design-system.md` + `interaction-patterns.md`. `data-visualization.md` reads `design-system.md` + `component-library.md`. `polish-checklist.md` reads every UI artifact that exists; depending on which are present, its `depends_on` list varies per run.

## Independent artifacts (no upstream dependency)

These can be generated at any point in the pipeline. They don't have an enforced upstream because their inputs are project-wide conventions, not pipeline artifacts:

```
.forge/design-system.md
.forge/interaction-patterns.md
.forge/seed-data.md
.forge/accessibility.md
.forge/demo-narrative.md          (soft: .forge/seed-data.md)
.forge/docs-policy.md
.forge/performance-budget.md
.forge/incident-response.md
.forge/tech-debt-registry.md
```

## Soft dependencies

A **soft dependency** is a read-only reference that shapes an artifact's content but isn't part of the strict cascade. If a soft upstream changes, the downstream is *potentially* outdated but does not require regeneration — the user reviews and decides.

```
.forge/design-system.md
   ├─(soft)▶ .forge/interaction-patterns.md   (uses tokens for motion/spacing)
   ├─(soft)▶ .forge/accessibility.md          (uses tokens for color contrast checks)
   └─(soft)▶ .forge/demo-narrative.md         (UI screenshots align to tokens)

.forge/interaction-patterns.md
   └─(soft)▶ .forge/accessibility.md          (keyboard model intersects with a11y)

.forge/seed-data.md
   └─(soft)▶ .forge/demo-narrative.md         (scene scenarios reference seeded entities)
```

`forge-sync` reports soft-stale artifacts in their own section (**SOFT_STALE**), distinct from `STALE` — they do NOT block downstream regeneration, but the user should re-read affected files before shipping.

To declare a soft dependency in a `forge:meta` header, use a separate `soft_depends_on` field:

```
<!-- forge:meta
generated_by: accessibility
generated_at: 2026-05-14T10:00:00Z
depends_on: []
soft_depends_on: [.forge/design-system.md, .forge/interaction-patterns.md]
content_hash: 3f9a2b1c
-->
```

## Externally-fed artifacts

```
.forge/cross-validation-prompt.md   (Phase 1 — produced by cross-validation, reads any .forge/ artifact)
.forge/cross-validation-synthesis.md (Phase 2 — produced by cross-validation, reads reviewer responses)
.forge/redaction-manifest.md         (produced by redaction-and-cleanup, reads any .forge/ artifact)
.forge/redacted/*                    (produced by redaction-and-cleanup, copies of originals)
.forge/sync-report.md                (produced by forge-sync, reads every .forge/ file)
.forge/feedback/*.md                 (produced by feedback skill from any downstream stage, targets one upstream artifact)
```

## Reverse-cascade: feedback entries

The forward chain (`idea → prd → arch → tasks → code`) is one-directional, but real projects discover problems downstream that imply changes upstream. The `feedback` skill captures these as structured entries under `.forge/feedback/<timestamp>-<source>.md`.

Each entry declares:
- `source` — stage that discovered the issue (build, review, security, scalability, incident, …)
- `target_artifact` — the upstream `.forge/` file that needs revision
- `status` — `PENDING` | `RESOLVED` | `DEFERRED`
- `finding` — what was discovered
- `recommended_change` — what should change in the target artifact

`forge-sync` reads `.forge/feedback/` and, for each PENDING entry, marks the **target_artifact** as **FEEDBACK_PENDING** (a separate state from STALE). When the upstream skill re-runs, it reads all PENDING entries targeting its output and addresses them; after writing, it flips matching entries to `RESOLVED` with a `resolved_at` timestamp.

**Severity order:**

```
BROKEN_REF  >  MODIFIED  >  FEEDBACK_PENDING  >  NEEDS_REVIEW  >  STALE  >  SOFT_STALE  >  UP_TO_DATE
```

- `NEEDS_REVIEW` is a sibling state for findings that recommend a human decision but no auto-cascade (e.g., a security finding that suggests adding a WAF — the human chooses whether to update architecture).
- All states above `UP_TO_DATE` block `/build` and `/ship` until resolved or explicitly dismissed.

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
| `brand-identity.md` | `design-system.md` → component-library → page-composition + data-visualization → polish-checklist |
| `design-system.md` | component-library → page-composition; data-visualization; polish-checklist |
| `component-library.md` | `page-composition.md`, `data-visualization.md`, `polish-checklist.md` |
| `interaction-patterns.md` | component-library (soft for tokens-only consumers), page-composition, polish-checklist |
| feedback entry filed | target_artifact flipped to FEEDBACK_PENDING; downstream of target inherits STALE on next sync |

Forward cascade flows downward only — regenerating a downstream artifact does NOT mark its upstreams stale. **Reverse cascade is opt-in**, mediated by feedback entries: an upstream is never auto-marked stale because a downstream changed; instead, the downstream skill (or a human) files a feedback entry that flags the upstream for review.

## Cross-artifact precedence (when two skills define the same thing)

Some skills produce overlapping definitions. When they conflict, the contract artifact wins:

| Concern | Authoritative source | Subordinate sources (must conform) |
|---|---|---|
| Module boundaries, types, error cases | `.forge/contracts/<module>.md` | `.forge/api-design.md`, `.forge/database-design.md` |
| HTTP envelope, error shape, versioning policy | `.forge/api-design.md` | per-endpoint definitions inside contracts |
| Per-module test coverage policy | `.forge/testing-strategy.md` | `tdd` skill's default ("every module needs unit tests") |
| Schema, migrations, query patterns | `.forge/database-design.md` | architecture.md's data-flow prose |

**Rule:** skills that produce subordinate artifacts MUST read the authoritative source first if it exists. `api-design` reads `contracts/` before defining endpoints; `tdd` reads `testing-strategy.md` before deciding to write unit tests; etc. `forge-sync` flags **CONFLICT** when two artifacts define the same operation/endpoint/module with divergent shapes.

## Task lifecycle schema (`tasks.yaml`)

`planning-and-task-breakdown` emits initial state; `incremental-implementation` mutates state in place.

```yaml
tasks:
  - id: T-001
    title: "..."
    size: M
    depends_on: []
    contracts: [PaymentService]
    skills: [api-design, database-design]   # optional — context-loaded by incremental-implementation
    acceptance_criteria: [...]
    verification: [...]
    status: pending          # pending | in_progress | done | split | blocked
    started_at: null         # ISO 8601 UTC; set when status flips to in_progress
    completed_at: null       # ISO 8601 UTC; set when status flips to done
    commit: null             # short sha; set on done
    notes: []                # free-form log of mid-task discoveries
```

**Status semantics:**
- `pending` — emitted by planning; no work started
- `in_progress` — `incremental-implementation` picked this task; `started_at` set; only ONE task per agent in this state at a time
- `done` — acceptance criteria verified; `completed_at` + `commit` set
- `split` — task was decomposed mid-flight; replaced by new task IDs listed in `notes`. The split task itself is closed.
- `blocked` — discovered an unmet dependency; `notes` records the blocker. `incremental-implementation` files a feedback entry.

`forge-sync` reports `tasks.yaml` as **TASKS_DIVERGED** when ≥3 tasks have been split, blocked, or have non-empty `notes` since the last `/plan` run — signal that the plan no longer matches reality and re-planning is due.

## ADR review-due semantics

ADRs encode decisions, not requirements — they don't go stale on a clock, but they can become factually wrong as the system evolves. To detect drift:

- Every ADR carries `status` (`Accepted` | `Superseded by ADR-NNN` | `Deprecated`) in its body.
- Every ADR carries `last_reviewed_at` in its `forge:meta` (ISO 8601 UTC). Set on creation; updated whenever the ADR is reaffirmed during a review pass.
- `forge-sync` flags ADRs whose `last_reviewed_at` is older than 90 days AND whose status is `Accepted` as **REVIEW_DUE**. This is a soft signal — does not block downstream work — but surfaces in the report so the user remembers to revisit.

When an ADR is superseded, the superseding ADR (`ADR-N+1`) updates the old ADR's `status` line to `Superseded by ADR-N+1` and bumps its `last_reviewed_at`. The old ADR stays in `.forge/adr/` as a historical record.

## How `forge-sync` uses this graph

1. Read this file as the canonical dependency tree.
2. Scan every file in `.forge/` for `<!-- forge:meta -->` headers (validate UTC + hash).
3. For each artifact with dependencies, compare `generated_at` of downstream against `generated_at` of upstream. Downstream older than upstream = STALE.
4. Recompute each file's content hash; mismatch → MODIFIED.
5. Read `.forge/feedback/` for PENDING entries; target artifacts → FEEDBACK_PENDING.
6. Scan ADRs for `last_reviewed_at` > 90 days old → REVIEW_DUE.
7. Compare `tasks.yaml` task statuses; ≥3 tasks split/blocked since last /plan → TASKS_DIVERGED.
8. Cross-check `api-design.md` and `contracts/` for operation-shape conflicts → CONFLICT.
9. Compare `.forge/sync-report.md` `generated_at` against newest `.forge/` mtime; if any artifact is newer → flag sync-report itself as SELF_STALE in the next run.
10. Walk the cascade table to produce the topologically-sorted list of skills to re-run.

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
| `brand-and-identity` | `.forge/brand-identity.md` | — (independent, upstream of every visual artifact) |
| `design-system` | `.forge/design-system.md` | `.forge/brand-identity.md` (soft if absent) |
| `interaction-patterns` | `.forge/interaction-patterns.md` | — (independent) |
| `component-library` | `.forge/component-library.md` | `.forge/design-system.md` + `.forge/interaction-patterns.md` + `.forge/brand-identity.md` |
| `page-composition` | `.forge/page-composition.md` | `.forge/component-library.md` + `.forge/design-system.md` + `.forge/interaction-patterns.md` |
| `data-visualization` | `.forge/data-visualization.md` | `.forge/design-system.md` + `.forge/component-library.md` |
| `visual-polish` | `.forge/polish-checklist.md` | every UI artifact that exists at run time |
| `seed-data-and-fixtures` | `.forge/seed-data.md` | — (independent) |
| `accessibility` | `.forge/accessibility.md` | — (independent) |
| `demo-narrative` | `.forge/demo-narrative.md` | `.forge/seed-data.md` (soft, if exists) |
| `documentation-hygiene` | `.forge/docs-policy.md` | — (independent) |
| `performance-and-cost-optimization` | `.forge/performance-budget.md` | — (independent — measurement-driven, not artifact-chain-driven) |
| `incident-response-and-postmortems` | `.forge/incident-response.md` | — (independent) |
| `refactoring-and-tech-debt` | `.forge/tech-debt-registry.md` | — (independent) |
| `redaction-and-cleanup` | `.forge/redaction-manifest.md`, `.forge/redacted/*` | any `.forge/` artifact |
| `forge-sync` | `.forge/sync-report.md` | every `.forge/` file + this graph |
| `feedback` | `.forge/feedback/<timestamp>-<source>.md` | the target_artifact being annotated |
| `forge-migrate` | (in-place header backfill) | every legacy `.forge/` file |
