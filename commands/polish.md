---
description: Run visual quality pass — states, skeletons, empty states, meta tags
---

Invoke the forge-skills:visual-polish skill.

Read whichever UI artifacts exist (.forge/design-system.md, .forge/component-library.md, .forge/page-composition.md, .forge/brand-identity.md, .forge/interaction-patterns.md). Run audits in order: micro-interaction (every button has hover/active/focus-visible), empty state (every list/table/chart has helpful copy + CTA), error state (specific messages with next steps, styled toasts, 404 page), loading (skeletons not spinners, no layout shift), responsive edge cases (320px + 1440px+, ≥44pt tap targets), meta (favicon + Apple touch icon + OG tags + per-route titles), dark mode parity if applicable. Output pass/fail per item with file:line for every failure.

Reads: all available .forge/ UI artifacts
Produces: .forge/polish-checklist.md
Next: fix failures, re-run /polish until clean, then /ship.
