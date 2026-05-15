# Motion System

The canonical motion vocabulary for forge-skills products. Generated alongside `.forge/design-system.md` and referenced by `interaction-patterns`, `component-library`, `data-visualization`, and `visual-polish`. Motion is a system, not a flourish — every duration, curve, and transition lives here.

## Duration standards

Three tiers. Pick by *what is moving*, not by *what looks good*.

| Tier | Range | Use for |
|---|---|---|
| **Micro** | 100–150ms | Hover/active feedback, focus rings, toggle flips, button press depress, link underline, tooltip fade-in |
| **Standard** | 200–300ms | Modal/sheet enter+exit, dropdown reveal, tab switch, accordion expand, toast slide-in, drawer slide |
| **Emphasis** | 400–500ms | First-load page reveal, large layout shift, dashboard data reveal, onboarding hero motion |

> Reach for **micro** by default. If the eye can't track a transition that's under 100ms, it feels broken; if a tactile micro-interaction exceeds 200ms, it feels sluggish.

## Timing curves

| Curve | CSS | Use for |
|---|---|---|
| **ease-out** | `cubic-bezier(0.0, 0.0, 0.2, 1)` | Enters — element decelerates into place; users perceive arrivals |
| **ease-in** | `cubic-bezier(0.4, 0.0, 1, 1)` | Exits — element accelerates away; users perceive departures |
| **ease-in-out** | `cubic-bezier(0.4, 0.0, 0.2, 1)` | Morphs / two-stage transitions — element transforms in place (size, color, position simultaneously) |
| **linear** | `linear` | Loops, progress indicators, anything continuous |

Never use `ease` (default). It's symmetric and dulls enter/exit asymmetry.

## Enter / exit transitions per component

| Component | Enter | Exit | Notes |
|---|---|---|---|
| Modal (desktop) | 200ms ease-out: scale 0.96→1, opacity 0→1 | 150ms ease-in: opacity 1→0 | Backdrop fades with modal |
| Bottom sheet (mobile) | 250ms ease-out: translateY(100%)→0 | 200ms ease-in: translateY(0)→100% | Backdrop opacity 0→0.5 simultaneously |
| Toast | 200ms ease-out: translateY(-8px)+opacity → 0,1 | 150ms ease-in: opacity → 0 | Auto-dismiss after 4s default |
| Dropdown / popover | 150ms ease-out: scale 0.95→1, opacity 0→1, origin = trigger | 100ms ease-in: opacity → 0 | Origin matters — feels anchored to trigger |
| Drawer (side) | 250ms ease-out: translateX(±100%)→0 | 200ms ease-in: reverse | Backdrop fades 0→0.4 in parallel |
| Page | 200ms standard, opacity 0→1 | none — instant unmount | See "Page transition rules" |
| Tooltip | 100ms ease-out: opacity 0→1 (delay 500ms) | 75ms linear: opacity 1→0 | Delay prevents flicker on incidental hover |
| Accordion | 200ms ease-in-out: height auto | 200ms ease-in-out | Height interpolation is morph, not enter |
| Skeleton → content | 150ms ease-out: opacity crossfade | — | Skeleton fades out as content fades in; no layout shift |

## Page transition rules

Pick **one** strategy per product. Mixing produces inconsistency.

- **Slide** — for hierarchical navigation (parent → detail). Forward = slide left, back = slide right. Only on mobile/native-shaped apps. Adds spatial memory.
- **Fade** — for sibling routes (tab → tab, dashboard → settings). 200ms opacity crossfade. Default for SaaS / desktop-first products.
- **None** — instant swap. Best for power-user desktop apps where motion delay = friction. Trade-off: loses spatial cues.

Persistent shell (header, sidebar) never animates between routes — only the content region transitions.

## Micro-interactions

| Interaction | Spec |
|---|---|
| Button press | 100ms ease-out: scale 1→0.98 on `:active`; 100ms ease-in back to 1 on release |
| Toggle switch | 200ms ease-in-out: knob translateX + background color cross-fade |
| Progress (determinate) | width transition 300ms ease-out per update; never linear (looks robotic) |
| Progress (indeterminate) | 1200ms linear infinite loop; no jank between cycles |
| Counter / metric roll-up | 600–800ms ease-out: animate from previous value to next; format-aware (currency, percent) |
| Focus ring | 100ms ease-out: ring opacity + offset 0→2px |
| Tab indicator | 200ms ease-in-out: underline translateX between tabs |
| Checkbox check | 150ms ease-out: stroke-dashoffset animation; checkbox fill simultaneously |
| Hover lift (cards) | 150ms ease-out: translateY 0→-2px + shadow elevation step |

## Chart / data animation

| Pattern | Spec |
|---|---|
| **Staggered reveal** | Each series/bar/segment delays by 40ms × index, 300ms ease-out duration. Caps at 600ms total — beyond that, the last item feels late. |
| **Counter roll-up** | 700ms ease-out, format-aware. Numbers update every animation frame; commas/currency reformat as values cross thresholds. |
| **Line draw** | 600ms ease-in-out: stroke-dashoffset full→0. Point markers fade in after the line completes. |
| **Bar growth** | 400ms ease-out: scaleY 0→1 from baseline; never from center. |
| **Donut sweep** | 600ms ease-out: stroke-dashoffset; sweep in CW direction from 12 o'clock. |
| **Update (data changed)** | 300ms ease-in-out interpolation between old and new values. Not a re-mount; the same bars/lines morph. |
| **Tooltip on hover/tap** | 100ms ease-out fade + 4px offset slide toward the cursor/tap point. |

First-load chart reveals are emphasis-tier. Updates after that are standard or micro.

## When NOT to animate

- `prefers-reduced-motion: reduce` is set — see below
- The action is repeated rapidly (typing, scrolling, dragging) — animation queues lag behind input
- The change is background/imperceptible (real-time data updates beyond the viewport)
- The transition crosses a user gesture (don't animate while the user is mid-swipe)
- The animation would delay a critical action (login submit → dashboard should feel instant, not "slide in")
- The motion has no narrative purpose ("just to add polish") — that's noise, not motion design

## `prefers-reduced-motion`

When `@media (prefers-reduced-motion: reduce)` matches:

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```

Specific rules:
- Collapse all durations to **0.01ms** (effectively instant, but transitions still fire so JS state machines don't hang waiting for `transitionend`).
- **Disable parallax** entirely — `transform: translateZ()` and scroll-linked motion off.
- **Disable autoplay** on carousels, animated illustrations, looping background video.
- **Keep opacity fades** at 0.01ms — opacity changes don't trigger vestibular reactions and removing them entirely makes UI feel broken.
- **Replace large translateY/scale enters** with instant appearance. Don't keep a 200ms slide "just shorter."
- **Test with the OS setting on**, not just devtools emulation — Safari's reduced-motion has subtler behavior than Chrome's.

Motion serves communication. When motion is harmful, communication still has to work — that's why opacity stays and only the vestibular triggers go.
