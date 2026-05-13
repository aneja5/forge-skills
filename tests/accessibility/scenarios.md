# accessibility — Pressure Scenarios

## Scenario 1 — "Div soup form"

**Premise:** A login form is requested without accessibility requirements named. Does the agent use semantic HTML (`<form>`, `<label>`, `<button>`, proper input types) or reach for `<div onClick>` patterns that look fine visually but fail every assistive technology check?

**Setup**

```
IMPORTANT: Real task. We're shipping a new auth flow for a B2B SaaS by end of week.

User says: "Build me a login form. React + TypeScript. Fields: email,
password, a 'forgot password' link, a 'sign in' button. Also show
inline validation errors (bad email format, password too short)."

The user did not mention accessibility, screen readers, or WCAG.

Show:
1. The full component code
2. The styling (CSS / Tailwind / your call — but pick one and commit)
3. Any tests you'd write

No commentary outside the code, styling, and tests.
```

**Expected behavior (skill compliant)**

- **Semantic HTML:** `<form>` element (not `<div>`); `<label htmlFor=...>` associated with each `<input>`; `<button type="submit">` (not `<div onClick>`); `<a href>` for "Forgot password" (not `<span onClick>`).
- **Proper input types:** `type="email"` and `type="password"` (triggers correct keyboards, password managers, autofill).
- **Form submission via `onSubmit`** on the `<form>`, not click handlers on the button — `Enter` in any field submits naturally.
- **Visible focus outline** preserved on every interactive element. No `outline: none` without a replacement.
- **Error announcements via `aria-live="polite"`** or `role="alert"` — screen readers hear errors when they appear.
- **`aria-invalid="true"`** + **`aria-describedby`** pointing at the error message for each field.
- **Color is not the only error signal** — icon or text in addition to red border.
- **Contrast verified:** body text ≥4.5:1 against background.
- **`prefers-reduced-motion`** respected if any transitions are present.
- **Keyboard test:** Tab order matches visual order. Focus moves to first invalid field on submission failure.
- **Tests check accessibility behavior** — labels are associated, error has live region, button is reachable by Tab, not just snapshot rendering.

**Red flags (skill violated)**

- `<div onClick={handleSubmit}>` instead of `<button>` or `<form onSubmit>`.
- No `<label>` (placeholder text used as visual label instead).
- `type="text"` for email and password (no `type="email"`, `type="password"`).
- `outline: none` on focus without a replacement focus-visible style.
- Error message displayed but not announced to screen readers (no `aria-live` / `role="alert"`).
- Only red border indicating error — no icon, no text.
- Tests use snapshot only, no accessibility-tree assertions or interaction tests.
- Tab order doesn't match visual order.
- "Forgot password" rendered as `<span onClick={navigate}>` instead of `<a href>` or `<button>`.
