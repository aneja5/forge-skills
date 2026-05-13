# interaction-patterns — Pressure Scenarios

## Scenario 1 — "Desktop modal on mobile"

**Premise:** User asks for a confirmation dialog in a mobile-first app. Does the agent reach for a centered modal (the default desktop pattern), or a bottom sheet (the right pattern on mobile)?

**Setup**

```
IMPORTANT: Real task. App is mobile-first React Native + iOS PWA fallback.
Used by field service technicians on their phones, mostly one-thumb.

User says: "Add a confirmation dialog when the user deletes a job from
their list. Don't let them accidentally delete a job worth doing."

Show:
1. The component code (React, TypeScript)
2. The interaction spec — what triggers it, where it appears on screen,
   how it's dismissed, what the tap targets look like, what happens to
   focus/keyboard, what the screen reader announces.
3. Any decisions you'd log somewhere durable.

No commentary outside the code, spec, and decisions.
```

**Expected behavior (skill compliant)**

- **Bottom sheet, not centered modal.** Anchored to the bottom of the screen, thumb-reachable.
- **Drag handle** at the top to indicate dismissibility.
- **Swipe-to-dismiss** with visual affordance, plus a "Cancel" button.
- **Tap target ≥ 44pt** on every interactive element.
- **Destructive action treatment:** the Delete button is danger-colored AND requires a deliberate tap (not the default action that fires on Enter / outside-tap).
- **`role="alertdialog"`** (or platform equivalent) — screen reader announces it as a confirmation.
- **Focus trap** while open; focus returns to the trigger when closed.
- **Esc / back gesture dismisses** without deleting.
- **Decision logged in `.forge/interaction-patterns.md`** — "Mobile destructive confirmations: bottom sheet, drag handle, swipe-to-dismiss, danger button below cancel button."
- Considers **undo as an alternative**: the skill's destructive-action rule prefers optimistic delete + undo toast over confirm dialog when the delete is reversible. The agent should at least mention this and explain why confirm is right for "a job worth doing" (irreversible to the user's workflow).

**Red flags (skill violated)**

- Centered `<Modal>` / `<Dialog>` component imported from a desktop-first library and used as-is on mobile.
- Tap targets below 44pt.
- Confirmation that fires on `Enter` / outside-tap (a one-tap-away mis-delete).
- No screen reader announcement / no `role` attribute.
- No focus management — focus stays on the trigger, or escapes to `document.body`.
- No mention of undo as an alternative pattern (the skill's rule for reversible-within-30s actions).
- No `.forge/interaction-patterns.md` entry or decision-tree update.
- Uses the same component as the desktop version with no responsive variant.
