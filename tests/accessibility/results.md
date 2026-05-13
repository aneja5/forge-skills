# accessibility — Test Results

Run date: 2026-05-12
Methodology: see [tests/METHODOLOGY.md](../METHODOLOGY.md)
Subagents: 2 fresh `general-purpose` agents (1 RED + 1 GREEN)

---

## Scenario 1 — "Div soup form"

### RED (no skill)

Produced an **accessible login form** with semantic HTML — the "div soup" failure did not manifest.

Highlights:
- **`<form onSubmit={...}>` element**, not a `<div>` with click handler.
- **`<label htmlFor={inputId}>`** associated with each input via `useId()`.
- **`<input type="email">`** and **`<input type="password">`** — correct keyboards + password manager + autofill triggers.
- **`<button type="submit">`** for sign-in.
- **`<button type="button" onClick={onForgotPassword}>`** for "Forgot password" (not a `<div>` with click).
- **`aria-invalid` + `aria-describedby`** wiring errors to inputs.
- **`role="alert"`** on error `<p>` elements — announced when they appear.
- **Focus state preserved**: `:focus { outline: none; border-color: #2563eb; box-shadow: 0 0 0 3px rgba(...) }` — replaces `outline: none` with a visible focus indicator.
- **Tests via React Testing Library + `@testing-library/user-event`** assert behavior: `getByLabelText` (proves label association), `getByRole("button", { name: /sign in/i })` (proves accessible name), keyboard interaction tests, error-message-appears assertions, `onSubmit` call assertions.
- 8 tests total covering: render structure, validation on blur, length validation, required-field errors, submit-with-valid-data, error clearing on fix, "Forgot password" handler, disabled-during-submit.

**One real gap:** "Forgot password" is a `<button type="button">` rather than `<a href>`. For a navigation action it's the wrong element — a link should be a link. RED chose button-because-callback-style which is defensible if it triggers an in-app router rather than full navigation, but the test asserts `getByRole("button", {name: /forgot password/i})`, locking in the wrong element role.

### GREEN (with skill)

Produced a more rigorous accessible form with explicit jest-axe integration.

Highlights:
- All of RED's semantic HTML (form, label, input types, button submit, aria-invalid, aria-describedby).
- **"Forgot password" is `<a href="/forgot-password">`** — correct element for navigation.
- **`useId()` for unique form IDs.** Avoids ID collisions when the component mounts multiple times.
- **`autoComplete="username"` on email + `autoComplete="current-password"` on password** — password manager support (RED used `autoComplete="email"` which is acceptable but less standard than `username` for login).
- **Refs on email/password inputs** + **focus moves to first invalid field** on submit failure.
- **Color contrast annotated inline in CSS** — every pairing labeled with its WCAG ratio (`/* Body text 4.5:1: #1a1a1a on #ffffff = ~16.7:1 */`, etc.). Every interactive element ≥7:1, far exceeding AA.
- **Error icon + text** — color is not the sole signal. `!` glyph + text together.
- **`:focus-visible`** (not `:focus`) — outline only on keyboard navigation, not mouse click. Better UX.
- **2px outline + 2px offset** on focus.
- **`prefers-reduced-motion`** respected (no transitions ignored).
- **Tests include `jest-axe`** — `expect(await axe(container)).toHaveNoViolations()` in default state AND in error state.
- **Tests assert specific accessibility behaviors:**
  - Element type assertions (`expect(button).toHaveProperty("tagName", "BUTTON")`, `expect(link).toHaveAttribute("href")`).
  - autocomplete tokens for password managers.
  - Full keyboard navigation order (Tab through email → password → forgot → submit).
  - `Enter` AND `Space` activate submit.
  - Focus moves to first invalid field on submit.
  - Server-side form errors announced via `role="alert"`.
- **Citation map** at the end.

### Outcome

**The "div soup" failure did not manifest in RED.** Base Claude reaches for `<form>`, `<label>`, `<input type="...">`, and `<button type="submit">` when asked to build a login form, even without accessibility being mentioned.

**Differences GREEN added:**

| Feature | RED | GREEN |
|---|---|---|
| Semantic HTML (form/label/button/input types) | ✅ | ✅ |
| `aria-invalid` + `aria-describedby` | ✅ | ✅ |
| Error announced via `role="alert"` | ✅ on field errors | ✅ on field errors AND server errors |
| Focus replacement (not `outline: none`) | ✅ | ✅ + `:focus-visible` (keyboard-only) |
| **"Forgot password" as link, not button** | ❌ (button) | ✅ `<a href>` |
| **Focus moves to first invalid field on submit** | ❌ | ✅ via `ref.focus()` |
| **Standard autocomplete tokens** | ⚠️ `email` (acceptable) | ✅ `username` (standard for login) |
| Color contrast annotated with ratios | ❌ | ✅ inline `/* 16.7:1 */` comments |
| Error has icon + text (not just color) | ⚠️ red border + text | ✅ explicit icon glyph + text |
| `prefers-reduced-motion` respected | ❌ not addressed | ✅ explicit |
| **`jest-axe` automated a11y assertions** | ❌ | ✅ default + error states |
| Tests assert element type (`BUTTON`, `A`) | ❌ | ✅ |
| Test asserts full keyboard navigation order | ❌ | ✅ |
| Test asserts Enter AND Space activate submit | ❌ | ✅ |
| Citation map | ❌ | ✅ |

**RED passes the scenario's main criteria.** GREEN exceeds the scenario by adding focus management on validation failure, the `<a href>` correction for "Forgot password", `jest-axe` automated testing, and explicit color-contrast annotations. The `<a>` vs `<button>` distinction is a real correction — RED locked in the wrong element role for a navigation action.

**Skill is working as designed.** No skill change required.

## Refactor applied

None.
