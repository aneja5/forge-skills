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
- `tasks.yaml` references contracts that don't exist
- PRD describes features not in architecture
- `generated_at` timestamps show downstream older than upstream
- Multiple `.forge/` artifacts with no `forge:meta` headers (untracked)
- User running `/build` without checking sync first

## Core Process

### Step 1: Scan headers

For every file under `.forge/`, extract the `<!-- forge:meta -->` block (or `# forge:meta` for YAML). Capture: `generated_by`, `generated_at`, `depends_on`, `content_hash`. Artifacts without a header are recorded as "untracked".

### Step 2: Load the canonical graph

Read `references/forge-dependency-graph.md`. This is the source of truth for which artifact depends on which. Skill-claimed `depends_on` is validated against this graph; if a skill claims a dependency the graph doesn't list, flag it.

### Step 3: Topological order

Build the dependency DAG. Walk it depth-first to produce a topological order: `idea-brief → prd → (architecture, competitive, testing-strategy) → (contracts, api-design, …, gtm, tasks) → (tasks-summary, parallel-plan)`.

### Step 4: Check each artifact

For each artifact `A` with non-empty `depends_on`:
- If a dependency `D` doesn't exist on disk — mark `A` as **MISSING_DEP** (the chain is broken).
- If `D` has a header and `D.generated_at > A.generated_at` — mark `A` as **STALE**.
- If `D` has no header (legacy) — mark `A` as **UNKNOWN** (can't verify; recommend re-run).
- Otherwise — **UP_TO_DATE**.

### Step 5: Build the cascade

Stale artifacts cascade downstream. If `architecture.md` is stale, every artifact depending on it is implicitly stale even if its own headers haven't tripped. Walk the graph: a stale node taints all descendants. The cascade list is the topologically-sorted set of skills to re-run, deduplicated.

### Step 6: Write `.forge/sync-report.md`

```markdown
# .forge/ Sync Report
Generated: <ISO 8601 timestamp>

## Stale artifacts (action required)
| Artifact | Depends on | Last generated | Dependency updated | Action |
|---|---|---|---|---|
| .forge/architecture.md | .forge/prd.md | 2026-05-10 | 2026-05-13 | Run /architect |
| .forge/contracts/*.md | .forge/architecture.md | 2026-05-10 | (stale parent) | Run /architect |
| .forge/tasks.yaml | .forge/prd.md + architecture.md | 2026-05-10 | (stale parent) | Run /plan |

## Cascade order
Run these skills in order to fully sync:
1. /architect — updates architecture.md + contracts/ + adr/
2. /plan — updates tasks.yaml + tasks-summary.md

## Up to date
| Artifact | Last generated |
|---|---|
| .forge/idea-brief.md | 2026-05-08 |
| .forge/testing-strategy.md | 2026-05-12 |

## No header (untracked)
| Artifact | Note |
|---|---|
| .forge/design-system.md | Generated before headers were added. Re-run /design to add tracking. |
```

Also prepend a `forge:meta` header to `.forge/sync-report.md` itself (`generated_by: forge-sync`, `depends_on: every .forge/ file scanned`).

### Step 7: Report to user

If everything is up to date: **"All `.forge/` artifacts are in sync. No action needed."**

If stale: print the cascade order and ask: **"Run these in order? Y/n"** — but DO NOT run them. `forge-sync` is read-only by design; it diagnoses, never regenerates. The user runs the cascade commands themselves.

## Verification

- [ ] Every stale artifact is identified with a specific cascade action
- [ ] Cascade order is topologically sorted (no downstream runs before its upstream)
- [ ] Report includes stale, up-to-date, AND no-header sections (completeness over brevity)
- [ ] No false positives — artifact marked stale only when `D.generated_at > A.generated_at`
- [ ] `forge-sync` does NOT regenerate anything; it only reports
- [ ] `.forge/sync-report.md` written with its own `forge:meta` header
