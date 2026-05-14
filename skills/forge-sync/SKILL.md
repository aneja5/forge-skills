---
name: forge-sync
description: Use when checking if .forge/ artifacts are stale after a change to requirements, architecture, or any upstream artifact. Use before running /build, /review, or /ship to confirm the artifact chain is consistent. Use when the user says "is anything out of date" or "what needs to be regenerated".
---

# forge-sync

## Overview

Scan every `.forge/` artifact for `<!-- forge:meta -->` headers, cross-reference against `references/forge-dependency-graph.md`, and produce `.forge/sync-report.md` listing stale artifacts and the topologically-sorted cascade to re-sync. Pairs with every artifact-producing skill — `forge-sync` does not regenerate anything; it tells you what to re-run.

## When to Use

- A change landed in an upstream artifact (PRD edited, architecture updated, contracts revised) and downstream artifacts may be stale
- Before `/build`, `/review`, or `/ship` — confirm the chain is consistent
- After a teammate's PR touches `.forge/` — verify your local view is in sync
- User asks "is anything out of date" / "what needs to be regenerated" / "is the chain consistent"

## When NOT to Use

- No `.forge/` directory exists yet — nothing to sync
- Single greenfield session where no artifacts have been produced
- The user just wants to *read* an artifact, not check its freshness

## Common Rationalizations

| Rationalization | Rebuttal |
|---|---|
| "The change was small, downstream is probably fine" | Small PRD changes cascade into contract mismatches that surface as bugs during build. |
| "I'll sync later before shipping" | Stale contracts mean `/review` validates against outdated interfaces. The mismatch is invisible until production. |
| "Only the architecture changed, tasks are still valid" | Architecture changes invalidate task file-lists and dependency ordering. |
| "I just want to update one artifact" | Partial syncs leave the chain inconsistent. Run the full cascade. |
| "I'll trust the timestamps in memory" | Memory lies. Read the headers; they're the source of truth. |

## Red Flags

- `architecture.md` references modules not in `.forge/contracts/`
- `tasks.yaml` references contracts that don't exist on disk
- PRD describes features not in architecture
- `generated_at` timestamps show downstream older than upstream
- `generated_at` strings are not UTC (no `Z` suffix, or contain `+`/`-` offset)
- An artifact's on-disk content sha256 doesn't match its stored `content_hash` (hand-edited after generation)
- Multiple `.forge/` artifacts with no `forge:meta` headers (untracked → run `/forge-migrate`)
- User running `/build` without checking sync first

## Core Process

### Step 1: Scan headers

For every file under `.forge/`, extract the `<!-- forge:meta -->` block (or `# forge:meta` for YAML). Capture: `generated_by`, `generated_at`, `depends_on`, `content_hash`. Artifacts without a header are recorded as "untracked".

For each header, **validate** before trusting:
- `generated_at` MUST be ISO 8601 UTC with `Z` suffix. If it contains an offset (`+05:30`, `-08:00`) or no zone marker, flag as **INVALID_TIMESTAMP** and recommend re-running the source skill.
- `content_hash` must be 8 hex chars. Anything else → **INVALID_HASH** (re-run source skill).

### Step 1b: Recompute content_hash and compare

For every tracked artifact, recompute sha256 over the file body with the `forge:meta` block stripped, take the first 8 hex chars, and compare against the stored `content_hash`.

- Match → trust the header.
- Mismatch → mark **MODIFIED** (hand-edited after generation). Downstream is potentially stale even if `generated_at` is newer than upstream's. Recommend the user either re-run the source skill (to bless the edit) or revert the manual change.

`MODIFIED` is a higher-severity signal than `STALE`: stale means "upstream moved on," modified means "we lost the chain of provenance entirely."

### Step 2: Load the canonical graph

Read `references/forge-dependency-graph.md`. This is the source of truth for which artifact depends on which. Skill-claimed `depends_on` is validated against this graph; if a skill claims a dependency the graph doesn't list, flag it.

### Step 3: Topological order

Build the dependency DAG. Walk it depth-first to produce a topological order: `idea-brief → prd → (architecture, competitive, testing-strategy) → (contracts, api-design, …, gtm, tasks) → (tasks-summary, parallel-plan)`.

### Step 4: Check each artifact

For each artifact `A` with non-empty `depends_on`:
- If a dependency `D` doesn't exist on disk — mark `A` as **MISSING_DEP** (the chain is broken).
- If `D` is **MODIFIED** (hand-edited; see Step 1b) — mark `A` as **STALE** (upstream content drifted out of band).
- If `D` has a header and `D.generated_at > A.generated_at` — mark `A` as **STALE**.
- If `D` has no header (legacy) — mark `A` as **UNKNOWN** (can't verify; recommend `/forge-migrate` then re-run).
- Otherwise — **UP_TO_DATE**.

### Step 4b: Detect orphaned contract references

`tasks.yaml` and `parallel-plan.md` reference contracts by name. If the architecture step was re-run and a contract was renamed (`payment-service.md` → `billing-service.md`), the reference in `tasks.yaml` will dangle even though both files have current timestamps.

For each artifact that lists contract references:
- Extract every `.forge/contracts/<name>.md` reference (from `contracts:` fields in `tasks.yaml`, from prose in `tasks-summary.md` and `parallel-plan.md`).
- Check each exists on disk.
- Any missing reference → mark the referencing artifact as **BROKEN_REF** with the dangling filename quoted.

**`BROKEN_REF` is higher severity than `STALE`** — stale means re-running fixes it; broken-ref means the dependency graph itself is inconsistent and someone must reconcile the naming.

### Step 5: Build the cascade

Stale artifacts cascade downstream. If `architecture.md` is stale, every artifact depending on it is implicitly stale even if its own headers haven't tripped. Walk the graph: a stale node taints all descendants. The cascade list is the topologically-sorted set of skills to re-run, deduplicated.

### Step 6: Write `.forge/sync-report.md`

```markdown
# .forge/ Sync Report
Generated: <ISO 8601 UTC timestamp with Z suffix>

## Broken references (chain inconsistent — fix first)
| Artifact | Dangling reference | Action |
|---|---|---|
| .forge/tasks.yaml | .forge/contracts/payment-service.md | Reconcile rename or re-run /architect + /plan |

## Modified artifacts (hand-edited after generation)
| Artifact | Stored hash | Disk hash | Action |
|---|---|---|---|
| .forge/prd.md | a3f1b2c4 | 9d8e7f6a | Re-run /spec to bless edits OR revert manual change |

## Stale artifacts (action required)
| Artifact | Depends on | Last generated | Dependency updated | Action |
|---|---|---|---|---|
| .forge/architecture.md | .forge/prd.md | 2026-05-10T09:00:00Z | 2026-05-13T14:22:00Z | Run /architect |
| .forge/contracts/*.md | .forge/architecture.md | 2026-05-10T09:00:00Z | (stale parent) | Run /architect |
| .forge/tasks.yaml | .forge/prd.md + architecture.md + contracts/* | 2026-05-10T09:00:00Z | (stale parent) | Run /plan |

## Cascade order
Run these skills in order to fully sync:
1. /architect — updates architecture.md + contracts/ + adr/
2. /plan — updates tasks.yaml + tasks-summary.md

## Up to date
| Artifact | Last generated |
|---|---|
| .forge/idea-brief.md | 2026-05-08T11:30:00Z |
| .forge/testing-strategy.md | 2026-05-12T16:45:00Z |

## No header (untracked)
| Artifact | Note |
|---|---|
| .forge/design-system.md | Generated before headers were added. Run /forge-migrate then re-run /design to refresh. |

## Schema violations
| Artifact | Issue |
|---|---|
| .forge/observability.md | generated_at is `2026-05-12T10:00:00+05:30` — must be UTC with Z suffix. Re-run /observe. |
```

Also prepend a `forge:meta` header to `.forge/sync-report.md` itself (`generated_by: forge-sync`, `depends_on: every .forge/ file scanned`).

### Step 7: Report to user

If everything is up to date: **"All `.forge/` artifacts are in sync. No action needed."**

If stale: print the cascade order and ask: **"Run these in order? Y/n"** — but DO NOT run them. `forge-sync` is read-only by design; it diagnoses, never regenerates. The user runs the cascade commands themselves.

## Verification

- [ ] Every stale artifact is identified with a specific cascade action
- [ ] Cascade order is topologically sorted (no downstream runs before its upstream)
- [ ] Report includes stale, up-to-date, no-header, modified, broken-ref, AND schema-violation sections
- [ ] No false positives — artifact marked stale only when `D.generated_at > A.generated_at` OR a dep is MODIFIED
- [ ] `content_hash` recomputed and compared for every tracked artifact (catches manual edits)
- [ ] `generated_at` validated as UTC with Z suffix (catches timezone drift)
- [ ] Contract references in `tasks.yaml` and `parallel-plan.md` checked against disk (catches orphans)
- [ ] `forge-sync` does NOT regenerate anything; it only reports
- [ ] `.forge/sync-report.md` written with its own `forge:meta` header (UTC, Z suffix, valid hash)
