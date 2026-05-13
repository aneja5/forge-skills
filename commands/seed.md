---
description: Create realistic demo and test data — factories, distributions, idempotent seed scripts
---

Invoke the forge-skills:seed-data-and-fixtures skill.

Read `.forge/architecture.md` and `.forge/database-design.md`. Inventory entities needing seed with realistic minimum counts.
Define realistic distributions per field — names spanning cultures, timestamps with realistic curves, weighted statuses, domain-appropriate content.
Write factories with overrides (`createUser(overrides?: Partial<User>): User`), seeded RNG for reproducibility.
Build named demo scenarios — happy path, empty state, single item, overflow, error state — one per `.forge/demo-narrative.md` scene.
Make idempotent — upsert by stable key. Forbid production PII in seeds.

After writing: "Seed data written to .forge/seed-data.md. Re-run before every demo."
