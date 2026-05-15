---
description: Build component catalog with props, states, and accessibility
---

Invoke the forge-skills:component-library skill.

Read .forge/design-system.md (tokens), .forge/interaction-patterns.md (behaviors), .forge/brand-identity.md (voice + icons). Inventory the components the product actually needs by category (layout / navigation / feedback / input / display / overlay / data). For every component define: props with types, all 6 states (default / hover / active / disabled / loading / error), responsive behavior per breakpoint, accessibility (role + ARIA + keyboard + focus), composition rules, and prop-driven microcopy. Include domain components (ScoreCard, RepCard, CallTimeline), not just generic UI. Document naming conventions and anti-patterns.

Reads: .forge/design-system.md + .forge/interaction-patterns.md + .forge/brand-identity.md
Produces: .forge/component-library.md
Next: run /pages to define how components compose into page templates; /dataviz for chart components.
