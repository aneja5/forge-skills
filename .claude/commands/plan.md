---
description: Break a PRD into phased vertical slices and generate GitHub issues
---

Invoke the forge-skills:prd-to-plan skill, then forge-skills:prd-to-issues.

Ask the user for the PRD GitHub issue number if not already in context.

Break the PRD into tracer-bullet vertical slices — each a thin but complete path through all layers. Present the breakdown, get approval, then:

1. Write the plan to `./plans/<feature-name>.md`
2. Create GitHub issues in dependency order (blockers first)

Share all issue URLs when done.
