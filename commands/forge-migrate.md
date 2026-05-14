---
description: Backfill forge:meta headers on legacy .forge/ artifacts so the dependency chain works
---

Invoke the forge-migrate skill.

Scan .forge/ for files without forge:meta headers. For each, infer generated_by + depends_on from the canonical artifact table in references/forge-dependency-graph.md, compute content_hash from current contents, and set generated_at to the file's mtime in UTC.

Confirm the plan with the user before writing. Never regenerate artifact content — only prepend headers.

Reads: every file in .forge/ + references/forge-dependency-graph.md
Produces: in-place forge:meta headers on legacy files
Next: run /sync to verify the chain status with the new headers

Use this after upgrading across a major forge-skills release (pre-3.2.0 → 3.2+) when /sync reports a wall of "untracked" rows.
