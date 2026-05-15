---
description: Define page templates, layout grids, and responsive strategies
---

Invoke the forge-skills:page-composition skill.

Read .forge/component-library.md, .forge/design-system.md (breakpoints, spacing, max-width), .forge/interaction-patterns.md (scroll, sticky, overlay behavior). Define the layout system (grid, gutter, max content width, edge padding per breakpoint). Name page templates (dashboard, detail, list, form, settings, empty) and document each: section hierarchy, information density per breakpoint, sticky elements, scroll behavior, responsive collapse strategy. Decide mobile-first vs desktop-first once per product. Document navigation transformation per breakpoint. Content priority rules — nothing disappears, content relocates.

Reads: .forge/component-library.md + .forge/design-system.md + .forge/interaction-patterns.md
Produces: .forge/page-composition.md
Next: build pages from these templates during /build; run /polish before /ship.
