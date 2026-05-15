---
description: Define chart types, color encoding, and data display conventions
---

Invoke the forge-skills:data-visualization skill.

Read .forge/design-system.md (colors + typography) and .forge/component-library.md (chart components). Define chart-type selection rules as a decision tree (line for trends, donut for part-of-whole, horizontal bar for comparison, histogram for distribution, etc. — no ad-hoc choices). Define data color encoding from design-system semantic tokens — never raw hex. Set axis + label conventions (Y starts at 0, units always shown, consistent date format). Define responsive behavior at each breakpoint and tap-tooltip paths (no hover-only). Empty states with context. Animation per references/motion-system.md, respecting prefers-reduced-motion. Document domain-specific patterns if the product is data-heavy.

Reads: .forge/design-system.md + .forge/component-library.md
Produces: .forge/data-visualization.md
Next: build charts during /build; run /polish to verify every chart has an empty state and tap-tooltip path.
