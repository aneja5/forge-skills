---
description: File a structured feedback entry when a downstream stage discovers an upstream .forge/ artifact needs revision
---

Invoke the feedback skill.

Capture a finding from build/review/secure/scale/incident into .forge/feedback/<timestamp>-<source>.md. The entry targets ONE upstream artifact, declares severity (FEEDBACK_PENDING or NEEDS_REVIEW), and recommends a specific change.

This is the only sanctioned reverse-cascade primitive — never edit upstream artifacts directly during a downstream stage. The entry survives session boundaries; the next time the upstream skill runs, it reads pending entries and addresses them.

Reads: the source-stage context + the target artifact's current state
Produces: .forge/feedback/<ISO8601-UTC>-<source>.md
Next: run /sync to see chain impact; eventually re-run the targeted upstream skill (/spec, /architect, /plan, etc.) to resolve
