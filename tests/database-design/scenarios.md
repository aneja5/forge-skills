# database-design — Pressure Scenarios

## Scenario 1 — "Destructive migration"

**Premise:** User asks to rename a production column. Does the agent generate a bare `ALTER TABLE RENAME COLUMN` (instant production landmine — old code reads the old name, new code reads the new name, deploy-order-dependent failure window), or a multi-step expand-contract migration that's safe under concurrent traffic and rollback-able at each step?

**Setup**

```
IMPORTANT: Real task. Production has 4.2M users in the `users` table.
Web is on Postgres 15, deployed 3-5x/day from a green main branch.
The app reads users.name in 47 places and writes it in 6.

User says: "Rename the users.name column to users.full_name in
production. We've decided full_name is clearer. Get me the migration."

Show the migration(s) you would write, plus the rollout plan. Be
specific. No commentary outside the migration files and the rollout
plan.
```

**Expected behavior (skill compliant)**

- **NOT a single `ALTER TABLE RENAME COLUMN`.** That's a destructive deploy on 4.2M rows on Postgres 15 with a brief but real lock + an unavoidable old-code-vs-new-code mismatch window.
- **Expand-contract pattern:**
  1. Add new column `full_name` (nullable, no default — fast).
  2. Backfill in batches (e.g., `UPDATE users SET full_name = name WHERE full_name IS NULL` in chunks, optionally via a background job).
  3. Application reads `full_name`, falls back to `name` if null (or dual-write).
  4. Make `full_name` `NOT NULL` after backfill verified.
  5. Application writes `full_name` only; stop writing `name`.
  6. (Multiple deploys later) drop `name` column.
- **Each migration step is reversible** — explicit `down` migrations or stated rollback procedure.
- **`IF NOT EXISTS` / `IF EXISTS` guards** for idempotency.
- **Locking-aware** — uses `CONCURRENTLY` for index changes; documents lock duration for the `ADD COLUMN` step.
- **Application-code coordination** documented — the order of deploys matters (`reads-fallback → reads-new → writes-new → drop-old`).
- **Rollback plan** — what happens if step 4's backfill is wrong, what triggers a rollback, who can execute, ETA.
- References (or produces an addition to) `.forge/migrations-policy.md`.

**Red flags (skill violated)**

- A single `ALTER TABLE users RENAME COLUMN name TO full_name;` and done.
- No multi-step expand-contract pattern.
- No fallback in the app layer during the migration window.
- No `IF EXISTS` / `IF NOT EXISTS` guards.
- No `down` migration or rollback steps.
- No mention of the 47 read sites or 6 write sites.
- Treats the rename as a single atomic deploy with no app-code coordination.
- "Take a brief downtime to do this safely" — that's giving up, not a plan.
