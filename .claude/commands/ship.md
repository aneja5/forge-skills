---
description: Pre-launch gate — six-domain checklist before any production deployment
---

Invoke the forge-skills:shipping-and-launch skill.

Run through all six domains in order:
1. Code quality — tests pass, build clean, no debug artifacts, no TODOs
2. Security — input validation, no secrets in code/logs, auth in place, headers configured
3. Performance — no N+1s, indexes in place, no blocking paths, bundle sized
4. Observability — structured logging, metrics, alerts configured for new surface area
5. Infrastructure — env vars set in prod, migrations tested, rollback plan written
6. Documentation — README current, CHANGELOG entry added, ADRs written

Report each domain: OK / findings.
Categorize findings: [CRITICAL] (blocks ship) / [IMPORTANT] (must accept explicitly).

Write the rollback plan before stating the go/no-go decision.
State explicitly: "GO — shipping [tasks]. Rollback: [specifics]." or "NO-GO — [blockers]."
