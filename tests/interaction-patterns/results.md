# interaction-patterns — Test Results

Run date: 2026-05-12
Methodology: see [tests/METHODOLOGY.md](../METHODOLOGY.md)
Subagents: 2 fresh `general-purpose` agents (1 RED + 1 GREEN)

---

## Scenario 1 — "Desktop modal on mobile"

### RED (no skill)

**Built a bottom sheet, not a centered modal.** Comprehensive component code (React Native) with drag-handle grabber, accessibility-focus on Cancel (not Delete), stacked vertical buttons (destructive on top, equal-size), 56pt tap targets, `hitSlop: 12`, `accessibilityViewIsModal` focus trap, `announceForAccessibility` on open, haptic on confirm only.

**8 design decisions logged explicitly:**

1. **Two-stage safety: confirmation sheet + 6s undo toast.** "The dialog alone is not the safety net — undo is."
2. **Stacked vertical buttons, destructive on top, equal size.** *"Side-by-side destructive/cancel pairs at phone widths produce a measurable mis-tap rate in our user population (gloved hands, vibration from vehicles)."*
3. **Default screen-reader focus lands on Cancel** (not Delete).
4. **No "Don't ask again" option** — field techs share devices.
5. **Long-press as the gloved-hands fallback to swipe-to-delete** — *"Swipe gestures fail on capacitive screens through gloves. Long-press threshold set to 450ms."*
6. **`Keyboard.dismiss()` is the caller's responsibility, not the dialog's** — separation-of-concerns.
7. **Enter does not confirm on web (PWA).** Deliberate divergence from web dialog conventions.
8. **Haptic on confirm, not on open.** *"Opening the dialog is not the destructive moment — confirming is."*

The "centered desktop modal" failure did not manifest.

### GREEN (with skill)

**Refused the user's literal request.** GREEN read the skill's destructive-action rule ("reversible within 30s → optimistic + undo toast, irreversible → confirm dialog") and decided that deleting a job is reversible server-side, so the correct answer is NOT a confirmation dialog at all — it's an optimistic delete + undo toast.

Verbatim:

> *"Confirm vs undo for destructive: reversible within 30s → optimistic + undo toast. Irreversible → confirm dialog. ... drove the choice to reject the user's literal request ('add a confirmation dialog') in favor of undo. Deleting a job is reversible server-side, so undo is the prescribed pattern. The skill explicitly lists 'Undo is too complex' as a rationalization to resist."*

Built a bottom-anchored undo toast with:
- 8-second countdown progress bar (visual time-remaining affordance)
- ≥44pt tap targets, `hitSlop: 12-16`
- `accessibilityRole="alert"`, `accessibilityLiveRegion="polite"`, `announceForAccessibility` on delete + undo + commit
- `Esc` (PWA) commits/dismisses, `Cmd/Ctrl-Z` triggers undo
- Focus returns to originating trigger on undo
- Non-blocking — `pointerEvents="box-none"` lets list interaction continue

**Logged decision in `.forge/interaction-patterns.md`** including the escalation rule: *"When to escalate to a confirm dialog instead: irreversible operation. Use a bottom sheet with typed confirmation on phone — never a centered modal."*

### Outcome

**This is the most interesting RED/GREEN divergence in the test suite to date.** Both refused the centered-desktop-modal trap. But they diverged on whether to fulfill the user's literal request:

| Choice | RED | GREEN |
|---|---|---|
| Centered modal | ❌ avoided | ❌ avoided |
| Built a bottom sheet | ✅ as confirmation | ❌ refused — built undo toast instead |
| Built an undo toast | ✅ as additional layer ("two-stage safety") | ✅ as the only mechanism |
| Tap targets ≥44pt | ✅ 56pt | ✅ 44pt |
| Focus management | ✅ trap + return | ✅ return (no trap — toast non-blocking) |
| Screen reader announcements | ✅ on open | ✅ on delete, undo, commit |
| Considered undo as alternative pattern | ✅ explicit, two-stage | ✅ chosen as the answer |
| Rejected user's request | ❌ fulfilled it | ✅ rejected it, built undo |
| Logged decision durably | ✅ 8 decisions, location TBD | ✅ `.forge/interaction-patterns.md` excerpt |
| Cited skill sections | n/a | ✅ verbatim |

**RED's reading:** *"The user asked for a confirmation dialog. The skill says mobile = bottom sheet. So: bottom sheet confirmation, plus undo as a second safety net (defense in depth)."*

**GREEN's reading:** *"The skill says reversible-within-30s → undo (not confirm). The user's request implicitly assumes confirm is the right pattern, but the skill says it isn't for reversible operations. Refuse the request and build undo."*

**Both are defensible.** RED produced a more conservative answer (the user wanted confirm; here is the best mobile confirm), with undo as a second layer. GREEN produced the skill-literal answer (the skill prescribes undo for this case; do that instead), and noted when to escalate to a confirm sheet (irreversible operations only).

**Which is "more right" depends on the project's culture:**
- A startup that wants the agent to push back hard on user assumptions and follow the skill literally would prefer GREEN.
- An agency-style "deliver what the client asked for, but make it good" team would prefer RED.

**Skill works either way.** Both interpretations are within the skill's stated rules. The skill could be tightened to explicitly say "if a user asks for a confirm dialog on a reversible action, refuse and propose undo." That would force GREEN-style behavior — but might be too prescriptive for legitimate cases where confirm is still the right call (e.g., bulk-delete >10 items, which is exactly what GREEN flagged in its escalation rule).

## Refactor applied

None — both interpretations are valid readings of the skill. The skill's existing "Confirm vs undo for destructive" decision tree is sufficient; making it more prescriptive would over-constrain legitimate edge cases.
