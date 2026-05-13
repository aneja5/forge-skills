---
description: Define interaction rules — modal vs bottom sheet, expand vs navigate, optimistic UI, undo vs confirm
---

Invoke the forge-skills:interaction-patterns skill.

Inventory every interaction primitive (modal, sheet, drawer, popover, toast, swipe, long-press, drag, pull-to-refresh).
Assign one canonical pattern per category — e.g., mobile modals = bottom sheets, always.
Set tap-target minimum (44pt), keyboard rules (Esc closes overlays, focus returns to trigger), scroll behavior.
Decide optimistic UI rules — allowed where rollback is friendly, forbidden for payments / identity / security.
Document destructive-action policy — reversible = optimistic + undo toast; irreversible = confirm dialog.
Write decision tree + anti-patterns.

After writing: "Interaction patterns written to .forge/interaction-patterns.md."
