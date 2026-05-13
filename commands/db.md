---
description: Design schema, migrations, indexes, and query patterns with safety guardrails
---

Invoke the forge-skills:database-design skill.

Define naming conventions (tables, columns, FKs, indexes, constraints, audit columns).
Audit existing schema for violations (missing FK indexes, no audit columns, soft-delete without cleanup).
Set migration guardrails — reversibility, idempotency (IF NOT EXISTS), locking-aware (CONCURRENTLY), expand-contract pattern.
Write query-review checklist — every hot query EXPLAINed, no seq scan on big tables, no N+1, cursor pagination.
Identify partition candidates. Document RLS / tenant-scoping rules for multi-tenant systems.

After writing: "Database design + migrations policy written to .forge/database-design.md and .forge/migrations-policy.md."
