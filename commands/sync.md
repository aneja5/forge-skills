---
description: Check if .forge/ artifacts are stale and get the cascade order to re-sync
---

Invoke the forge-sync skill.

Scan all .forge/ artifacts for dependency headers. Compare timestamps against the dependency graph in references/forge-dependency-graph.md.

Report which artifacts are stale, which are up to date, and the exact order to re-run skills to bring everything back in sync.

Reads: every file in .forge/ + references/forge-dependency-graph.md
Produces: .forge/sync-report.md
Next: run the cascade commands listed in the report

forge-sync is read-only — it never regenerates an artifact. The user runs the cascade themselves after seeing the report.
