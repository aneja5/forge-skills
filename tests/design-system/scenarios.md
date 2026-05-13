# design-system — Pressure Scenarios

## Scenario 1 — "Raw hex everywhere"

**Premise:** A user asks for a component library for a dashboard app. No design tokens exist yet. Does the agent reach for hex codes and Tailwind defaults, or does it establish a semantic token layer first, define all 6 component states, and design for dark-mode parity from the start?

**Setup**

```
IMPORTANT: This is a real task. The dashboard ships in 2 weeks.

User: "Build me a component library for a dashboard app. We're using React +
TypeScript + Tailwind. We need at least a Button, Input, and Card. Get
something usable today."

Context:
- The dashboard is for B2B SaaS users — power users on desktop, lower
  density.
- Users include EU enterprise accounts (so accessibility matters — WCAG AA
  baseline expected).
- Designer is available but in another timezone — first review in 36 hours.
- Engineering will iterate on these components for the next 6 months.
- The product roadmap says "dark mode" is in Phase 2 (3 months out).

Show:
1. The tokens / theming files you would write (filenames + full content)
2. The three components (Button, Input, Card) with full code
3. Any supporting docs

No commentary outside the code/doc content.
```

**Expected behavior (skill compliant)**

- A `tokens.css` or similar with **semantic tokens** (`--surface`, `--text`, `--accent`, `--danger`) mapped from a **reference layer** (`--gray-50`, `--blue-500`, etc.) — components reference semantic tokens only, never raw hex.
- A spacing scale (4px or 8px grid with named stops) and components use the scale exclusively.
- A radius scale with one canonical radius per component type.
- Each component has **all 6 states** documented: `default`, `hover`, `active`, `focus-visible`, `disabled`, `loading`. Plus `error` for Input.
- **Dark mode parity built-in from day one** — semantic tokens remap, not a Phase-2 rewrite. The skill explicitly says retrofitting costs 5x.
- Focus-visible outlines (no `outline: none` without a replacement).
- Contrast meets WCAG AA (4.5:1 body, 3:1 large text).
- Skeleton or loading state for the async case (button shows spinner-in-button + disabled).
- `.forge/design-system.md` produced or referenced — tokens, scales, component inventory, anti-patterns.

**Red flags (skill violated)**

- `bg-[#3B82F6]` or `className="bg-blue-500"` directly in components without a semantic mapping.
- Spacing values that aren't from the scale (`p-[13px]`, `mt-7` mixed with `mt-2`).
- A `Button` without a `loading` state or without a `focus-visible` outline.
- Dark mode "deferred to Phase 2" with hex codes in components that will need rewriting.
- An `Input` without `error` state styling.
- A `Card` with hardcoded shadow/radius/padding values not from any scale.
- No `.forge/design-system.md` or equivalent contract.

---

## How this scenario was chosen

This maps to the skill's Red Flags ("Hex codes in components", "Magic spacing numbers", "Components without disabled state", "No skeleton/loading state", "Color contrast below WCAG AA") and the Common Rationalizations ("Just use Tailwind defaults", "Dark mode can wait", "Loading states aren't important"). The pressure comes from real-world tradeoffs: a tight deadline, a dark-mode roadmap deferral, Tailwind's reach-for-defaults gravity, and a designer who isn't online to push back yet.
