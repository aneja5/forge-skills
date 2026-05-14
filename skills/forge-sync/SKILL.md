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

### Step 4c: Read `.forge/feedback/` for reverse-cascade entries

For every file under `.forge/feedback/`:
- Read its `forge:meta` and body.
- If `status: PENDING`:
  - Extract `target_artifact` (from the `depends_on` field in the header — single-element list).
  - Mark the target artifact as **FEEDBACK_PENDING** (or **NEEDS_REVIEW** if the body's `Severity:` line says so).
  - Carry the entry's path into the report so the user can read the finding.
- If `status: RESOLVED` or `status: DEFERRED`: skip; informational only.

A target artifact in `FEEDBACK_PENDING` or `NEEDS_REVIEW` state cascades **STALE** to its downstream — the upstream is known-incomplete, so anything downstream that depends on it is suspect.

### Step 4d: Cross-artifact conflict detection

For each pair where the cross-precedence table in the dependency graph says one artifact must conform to another:
- `api-design.md` operation/endpoint definitions vs each `contracts/<module>.md` `Provides` section
- `database-design.md` schema fields vs `contracts/` `Input Types`/`Output Types`

When operations/types defined in both diverge in shape (name match, but different signature/fields), mark the subordinate artifact as **CONFLICT** with the divergence quoted. The contract artifact wins; the subordinate must update.

### Step 4e: ADR review-due and tasks-diverged

For each ADR under `.forge/adr/`:
- If `last_reviewed_at` is more than 90 days old AND status is `Accepted` → **REVIEW_DUE** (soft signal, does not cascade).

For `.forge/tasks.yaml`:
- Count tasks with `status: split` or `status: blocked` since the last `/plan` run (compare against `generated_at` of the file).
- If ≥3 → **TASKS_DIVERGED** (recommend re-running `/plan`).

### Step 4f: Sync-report self-staleness (#27)

After determining all the above, also check `.forge/sync-report.md` (the previous run's output, if it exists):
- If any tracked artifact has `generated_at` newer than `sync-report.md`'s `generated_at` → previous sync report is **SELF_STALE**. Mention this in the new report's preamble so the user knows the prior report was misleading.

### Step 4g: Soft dependencies

For each artifact whose `forge:meta` contains a `soft_depends_on` field:
- Apply the same `generated_at` comparison against each entry as Step 4 does for `depends_on`.
- If any soft upstream is newer → **SOFT_STALE** (separate section in the report; does NOT cascade to downstream as STALE).

Soft-stale is advisory. The user reviews; the downstream is not blocked.

### Step 5: Build the cascade

Stale artifacts cascade downstream. If `architecture.md` is stale, every artifact depending on it is implicitly stale even if its own headers haven't tripped. Walk the graph: a stale node taints all descendants. The cascade list is the topologically-sorted set of skills to re-run, deduplicated.

### Step 6: Write `.forge/sync-report.md`

```markdown
# .forge/ Sync Report
Generated: <ISO 8601 UTC timestamp with Z suffix>
Previous report status: SELF_STALE (3 artifacts changed since last sync at 2026-05-12T08:00:00Z)

## Broken references (chain inconsistent — fix first)
| Artifact | Dangling reference | Action |
|---|---|---|
| .forge/tasks.yaml | .forge/contracts/payment-service.md | Reconcile rename or re-run /architect + /plan |

## Modified artifacts (hand-edited after generation)
| Artifact | Stored hash | Disk hash | Action |
|---|---|---|---|
| .forge/prd.md | a3f1b2c4 | 9d8e7f6a | Re-run /spec to bless edits OR revert manual change |

## Feedback pending (reverse cascade)
| Target artifact | Severity | Source | Entry |
|---|---|---|---|
| .forge/contracts/payment-service.md | FEEDBACK_PENDING | build (T-042) | .forge/feedback/2026-05-14T103000Z-build.md |
| .forge/architecture.md | NEEDS_REVIEW | secure | .forge/feedback/2026-05-13T160000Z-secure.md |

## Conflicts (subordinate artifact diverges from authoritative)
| Subordinate | Authoritative | Divergence | Action |
|---|---|---|---|
| .forge/api-design.md `POST /payments/refund` | .forge/contracts/payment-service.md `refund()` | api-design lists no idempotency key; contract requires it | Update api-design |

## Stale artifacts (action required)
| Artifact | Depends on | Last generated | Dependency updated | Action |
|---|---|---|---|---|
| .forge/architecture.md | .forge/prd.md | 2026-05-10T09:00:00Z | 2026-05-13T14:22:00Z | Run /architect |
| .forge/contracts/*.md | .forge/architecture.md | 2026-05-10T09:00:00Z | (stale parent) | Run /architect |
| .forge/tasks.yaml | .forge/prd.md + architecture.md + contracts/* | 2026-05-10T09:00:00Z | (stale parent) | Run /plan |

## Soft-stale (advisory — review before shipping)
| Artifact | Soft upstream changed | Action |
|---|---|---|
| .forge/accessibility.md | .forge/design-system.md updated 2026-05-13T14:00:00Z | Re-read tokens; refresh contrast checks if relevant |

## Tasks diverged
| Artifact | Detail | Action |
|---|---|---|
| .forge/tasks.yaml | 4 tasks split, 1 blocked since last /plan run | Run /plan to re-baseline |

## ADRs due for review (>90 days)
| ADR | Last reviewed | Status |
|---|---|---|
| .forge/adr/003-event-bus.md | 2026-02-10 | Accepted — re-affirm or supersede |

## Cascade order
Run these skills in order to fully sync (excluding NEEDS_REVIEW items, which require human decision first):
1. Address feedback entries (re-run /architect to incorporate FEEDBACK_PENDING items targeting contracts/)
2. /architect — updates architecture.md + contracts/ + adr/
3. /plan — updates tasks.yaml + tasks-summary.md

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
- [ ] Report includes stale, up-to-date, no-header, modified, broken-ref, feedback-pending, conflict, soft-stale, tasks-diverged, ADR review-due, AND schema-violation sections
- [ ] No false positives — artifact marked stale only when `D.generated_at > A.generated_at` OR a dep is MODIFIED/FEEDBACK_PENDING/NEEDS_REVIEW
- [ ] `content_hash` recomputed and compared for every tracked artifact (catches manual edits)
- [ ] `generated_at` validated as UTC with Z suffix (catches timezone drift)
- [ ] Contract references in `tasks.yaml` and `parallel-plan.md` checked against disk (catches orphans)
- [ ] `.forge/feedback/*.md` PENDING entries surfaced; targets flipped to FEEDBACK_PENDING or NEEDS_REVIEW
- [ ] `api-design.md` ↔ `contracts/*.md` operation shapes cross-checked for CONFLICT
- [ ] Soft dependencies (`soft_depends_on` field) checked; SOFT_STALE reported separately from STALE
- [ ] ADRs older than 90 days with status `Accepted` flagged as REVIEW_DUE
- [ ] `tasks.yaml` split/blocked counts inspected → TASKS_DIVERGED if ≥3
- [ ] Previous `.forge/sync-report.md` checked against newest `.forge/` mtime; SELF_STALE noted in preamble if applicable
- [ ] `forge-sync` does NOT regenerate anything; it only reports
- [ ] `.forge/sync-report.md` written with its own `forge:meta` header (UTC, Z suffix, valid hash)
