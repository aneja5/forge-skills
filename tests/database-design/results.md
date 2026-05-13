# database-design — Test Results

Run date: 2026-05-12
Methodology: see [tests/METHODOLOGY.md](../METHODOLOGY.md)
Subagents: 2 fresh `general-purpose` agents (1 RED + 1 GREEN)

---

## Scenario 1 — "Destructive migration"

### RED (no skill)

Produced a **full expand-contract migration plan** with 6 deploys, sync triggers, batched backfill, NOT NULL via NOT VALID + VALIDATE, and a documented rollback strategy per step. The "bare ALTER TABLE RENAME COLUMN" failure did not manifest.

Highlights:
- **Strategy stated up-front:** *"Expand → Backfill → Contract. Six deploys, never a breaking change in flight."*
- **Pre-flight check** (Step 0): scan for `SELECT *`, views, replication consumers, RLS policies referencing the column.
- **Step 1 (Deploy A):** `ALTER TABLE users ADD COLUMN full_name TEXT;` (nullable, no default — instant on PG 15). `BEFORE INSERT OR UPDATE` trigger keeps `name ↔ full_name` in sync.
- **Step 2 (Backfill):** Batched `UPDATE` in 10k chunks, `pg_sleep(0.1)` between, idempotent via `WHERE full_name IS NULL`. Run outside transaction.
- **Step 3 (Deploy B):** `CHECK (full_name IS NOT NULL) NOT VALID` then separate `VALIDATE CONSTRAINT` — avoids long `AccessExclusiveLock`.
- **Step 4 (Deploy C):** Flip all 47 read sites to `full_name`. Bake 24h.
- **Step 5 (Deploy D):** Flip all 6 write sites. Bake 24h.
- **Step 6 (Deploy E):** Drop trigger + function + column.
- **Rollback per step:** explicit, with "Step 6 is irreversible without restore. Hold for 1–2 weeks before running. Keep a backup snapshot."
- **Locking notes:** `lock_timeout = '2s'`, retry windows, off-peak guidance.

What was missing: no `.forge/migrations-policy.md` artifact, no formal citation map.

### GREEN (with skill)

Produced a structurally identical 5-migration expand-contract plan with skill section citations.

Highlights:
- Same expand-contract sequence (add → trigger → backfill → NOT NULL → drop) with `IF NOT EXISTS` / `IF EXISTS` guards on every step.
- Backfill via `FOR UPDATE SKIP LOCKED` to avoid lock contention with live writes.
- NOT NULL via NOT VALID + VALIDATE (same technique as RED).
- **Hourly audit query** (`SELECT count(*) FROM users WHERE name IS DISTINCT FROM full_name`) — automated drift detection during the 14-day deprecation window.
- **Datadog monitor names** for rollback triggers (`users-table-error-rate`, etc.) — operationalizes the abstract "rollback plan."
- **Citation map** at the end: every choice tied to a skill section (Reversibility, Idempotency, Locking-aware, Expand-contract, Backup before destructive, Red Flag avoidance).
- **Down-migration honesty:** explicitly notes that migration 003's `down` is a no-op (reverting a backfill is unsafe) and documents why, rather than faking a reversal.

### Outcome

**Both produced safe migrations.** The "bare RENAME COLUMN" failure didn't manifest. Base Claude correctly reads "4.2M rows + 47 read sites + 6 write sites + 3-5x/day deploys" as a high-blast-radius signal and reaches for expand-contract without being told.

**Differences GREEN added:**

| Feature | RED | GREEN |
|---|---|---|
| Expand-contract pattern | ✅ | ✅ |
| `IF NOT EXISTS` / `IF EXISTS` guards | ⚠️ partial | ✅ on every migration |
| NOT NULL via NOT VALID + VALIDATE | ✅ | ✅ |
| Backfill idempotency | ✅ via `WHERE full_name IS NULL` | ✅ same + `FOR UPDATE SKIP LOCKED` |
| Backfill outside transaction | ✅ | ✅ |
| Sync trigger | ✅ | ✅ |
| Per-step rollback documented | ✅ | ✅ |
| Hourly audit query during dual-write window | ❌ | ✅ |
| Concrete monitor names for rollback triggers | ❌ | ✅ Datadog names |
| Snapshot-restore procedure for the irreversible step | ✅ noted | ✅ explicit steps + ETA |
| Citation map → skill sections | ❌ | ✅ verbatim |
| Honest no-op `down` for backfill | ⚠️ implicit | ✅ explicit with reason |

**RED and GREEN converged on the same technique.** Both reached the expand-contract pattern, the trigger-based sync, the NOT VALID + VALIDATE trick, and the per-step rollback design without much difference in substance. GREEN added operational detail (audit query, monitor names) and explicit citation discipline.

This is one of the more aligned RED/GREEN pairs in the test suite — same answer, GREEN dressed it more formally.

## Refactor applied

None.
