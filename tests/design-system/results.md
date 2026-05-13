# design-system — Test Results

Run date: 2026-05-12
Methodology: see [tests/METHODOLOGY.md](../METHODOLOGY.md)
Subagents: 2 fresh `general-purpose` agents (1 RED + 1 GREEN)

---

## Scenario 1 — "Raw hex everywhere"

### RED (no skill)

Produced an unusually thorough component library, not a hex-everywhere mess. Key findings:

**Token architecture (without the skill):**
- Wrote `src/styles/tokens.ts` with **two distinct layers**: a primitive `palette` object (`gray.50…950`, `brand.50…900`, status colors) and a **semantic** export (`surface`, `border`, `text`, `intent.primary`, `intent.neutral`, `intent.danger`, `feedback`).
- Components import **semantic tokens only** — no raw hex in any component file. The primitive palette is consumed only by `tailwind.config.js`.
- WCAG AA contrast ratios annotated inline next to each token (`gray.900 → 16.1:1 on white — AAA`).

**Scales (without the skill):**
- Spacing: 4px-based scale (0, 1, 2, 3, 4, 5, 6, 8, 10, 12, 16) — components use the scale exclusively.
- Typography: 7 sizes with paired line-heights, font weight roles.
- Radius: 5-stop scale (none/sm/md/lg/xl/full).
- Motion: 4 durations (instant/fast/base/slow) + 2 easings.

**Component states (without the skill):**
- `Button` — 4 variants × 3 sizes × all 6 states (default, hover, active, focus-visible, disabled, loading), with `aria-busy`, `aria-label` enforcement for icon-only buttons, dev-mode `console.error` for missing aria-labels.
- `Input` — label + helper + error states, `aria-invalid`, `aria-describedby`, focus-within outline on wrapper.
- `Card` — `Card.Header` / `Card.Body` / `Card.Footer` composition, `interactive` variant that swaps `<section>` to `<button>` with focus ring.

**Dark mode (without the skill):**
- Pre-staged in `tailwind.config.js`: `darkMode: 'class'`.
- `color-scheme: light` declaration with `/* Phase 2: light dark */` comment.
- Token architecture makes dark mode a CSS variable swap, not a rewrite — the agent explicitly noted this.

**Accessibility (without the skill):**
- Global `:focus-visible` outline (2px + 2px offset).
- `prefers-reduced-motion` rule collapses all transitions to 0.01ms.
- Min target sizes documented (28/32/40 for sm/md/lg).
- WCAG 2.5.5 reference for target sizes.

**Documentation (without the skill):**
- `docs/component-library.md` with principles, accessibility checklist per primitive, designer review prep, Phase 2 plan, deliberate deferrals, and open questions for the designer.

**What was missing:**
- No `.forge/design-system.md` produced — used `docs/component-library.md` instead.
- No explicit `[data-theme="dark"]` block scaffolded (only `darkMode: 'class'` was wired up).

### GREEN (with skill)

Produced the same structural quality plus the skill's prescribed artifact:

- Two-layer token architecture in `src/styles/tokens.css` (reference) + `src/styles/theme.css` (semantic).
- Empty `[data-theme="dark"]` block scaffolded in `theme.css` — explicit Phase 2 mount point.
- Tailwind config **replaces** Tailwind defaults so `bg-blue-500` is unreachable from components (RED **extended** rather than replaced — slightly weaker isolation).
- Same Button / Input / Card / states pattern.
- `Card` with content-shaped **skeleton** loading (RED used a spinner inside the button but didn't address content-shaped skeletons for Card).
- **`.forge/design-system.md`** written with: brand foundation, token architecture, **contrast audit**, scales, per-primitive state matrix, composition rules, anti-patterns, verification checklist, designer review pack, Phase 2 roadmap.
- Cited skill sections explicitly (Step 1 brand, Step 2 two-level tokens, Step 3 scales, Step 4 six states, Step 6 composition + anti-patterns).

### Outcome

**RED is exceptionally strong.** Base Claude already produces semantic-token-layered, fully-stated, dark-mode-prepared component libraries without the skill. The "raw hex everywhere" failure pattern the scenario was designed to elicit **did not manifest**.

**Differences GREEN added on top of RED:**

| Feature | RED | GREEN |
|---|---|---|
| Two-layer token architecture (primitives → semantic) | ✅ | ✅ |
| Components use only semantic tokens | ✅ | ✅ |
| Spacing from scale | ✅ | ✅ |
| All 6 component states | ✅ | ✅ |
| WCAG AA contrast annotated | ✅ inline comments | ✅ contrast audit table |
| Dark mode pre-staged | ✅ `darkMode: 'class'` | ✅ `[data-theme="dark"]` block reserved |
| Tailwind defaults replaced (vs extended) | Extended | Replaced — stronger isolation |
| Content-shaped skeleton on Card | ❌ | ✅ |
| `.forge/design-system.md` (downstream-readable contract) | ❌ (used `docs/component-library.md`) | ✅ |
| Skill section citations | n/a | ✅ |

**The skill's unlock here is artifact organization, not behavior.** Same finding as the `error-handling-and-resilience` test and the earlier `architecture-and-contracts` test in this repo: base Claude is strong at the engineering work; the skill's value is producing the named `.forge/` artifact in the expected location so downstream skills (`accessibility`, `interaction-patterns`, `demo-narrative`) can read from a stable filename and section structure.

**One genuine difference:** GREEN's content-shaped skeleton on the Card was missing in RED. The skill's Step 4 explicitly says *"Skeleton screens, not spinners, for content-shaped loading"* — this rule shaped the GREEN output. A minor but real behavior unlock.

No skill change. Scenario marked as "weak baseline failure" — `raw hex everywhere` doesn't reproduce with fresh subagents on prompts that explicitly name dashboard / WCAG / TypeScript / Tailwind. A stronger version of the scenario would remove the accessibility context, the timeline-with-designer cue, and force the agent to produce code under a higher-pressure shipping scenario where token scaffolding feels overkill.

## Refactor applied

None.
