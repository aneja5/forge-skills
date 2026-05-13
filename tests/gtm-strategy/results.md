# gtm-strategy — Test Results

Run date: 2026-05-12
Methodology: see [tests/METHODOLOGY.md](../METHODOLOGY.md)
Subagents: 2 fresh `general-purpose` agents (1 RED + 1 GREEN)

---

## Scenario 1 — "ICP is everyone"

### RED (no skill)

**Refused "everyone."** Lead with:

> *"Explicitly NOT the ICP: 'Everyone who takes notes' — this is not a market, it's a fantasy."*

Defined ICP as **"Independent technical knowledge workers, 25–40, who already use 3+ note tools and have abandoned at least one."** Specific behavior signals (active in r/ObsidianMD, r/PKMS, HN; has tried Notion + Obsidian + Apple Notes + one of Bear/Craft/Logseq/Reflect; writes >5 notes/day; uses mechanical keyboard / vim).

Wedge: **global hotkey + sub-100ms search** — "From thought to saved in under 1 second. From question to answer in under 100ms."

**Pilot: "Marginal 100"** — 100 hand-picked design partners (vs the skill's 10-25 prescription — larger cohort). 90 days. Specific success criteria: 70+ of 100 still using daily, 30+ have referred a paid user, NPS > 50, 5+ "I deleted Notion/Obsidian" testimonials. **Explicit kill criteria** if <50 active at day 60.

**Sales channels ranked by expected CAC**, with explicit "NEVER" markers for LinkedIn / cold outbound / conferences. Strong PLG framing.

**ROI calculator with conservative defaults:** 437% ROI, payback in 9 weeks. "If a user runs the numbers and they don't feel real, the whole pitch collapses."

**Week-by-week 30-day plan** with target conversions per week, abort criteria at day 30 (<50 paying, <30% retention, no organic mentions, refund rate >20% → "the wedge isn't sharp enough").

The "ICP is everyone" failure did not manifest.

### GREEN (with skill)

Also **pushed back** on "everyone":

> *"'Everyone who takes notes' is rejected per the skill's ICP rule — it is a demographic, not a segment. 'Notion / Obsidian / Apple Notes' is three different markets with three different pains; chasing all three lands Marginal in the middle. Every audience = no audience."*

ICP: **"Senior software engineers and SREs at 10–75 person engineering teams who live in vim/tmux, currently use Obsidian (or a plain-`.md` vault) with 3k+ notes, and are frustrated that capture takes 3+ keystrokes from non-Obsidian windows and that search lags past ~5k notes without plugin tuning."** Four-part shape: role + size + current alternative + pain trigger — exact skill prescription.

Wedge: **"Sub-100ms global-hotkey capture into plain text, with fuzzy-find search returning in <100ms across 10k notes"** — ONE feature with stopwatch-observable success.

**Pilot: 20 engineers** (within skill's 10-25 range — RED was at 100). 4 weeks. ≥70% primary-tool metric verified by 50%+ of weeks-3-4 notes captured in Marginal (telemetry-based, not survey-based). Kill criteria explicit.

**First 100 customers as a table with concrete channels + counts:** 12 from founder's vim/Obsidian Discord, 20 pilot users + 2 referral seats each, 18 from targeted r/ObsidianMD post, 22 from Show HN timed to wedge demo, 8 from Lobste.rs, 12 from DMs to 40 named blog authors, 8 from one sponsored Console newsletter issue. Total exactly 100.

**Pricing rationale tied to ICP wallet/workflow:** $5 anchored below Obsidian Sync $8 — *"so it doesn't read as expensive to the ICP."* Teams $12 inside the "manager can expense without procurement" band.

**Citation map** at the end.

### Outcome

**Both pushed back on "everyone."** The "ICP is everyone" failure didn't manifest in either. Base Claude knows that "everyone" is not an ICP.

**Differences GREEN added:**

| Feature | RED | GREEN |
|---|---|---|
| Pushed back on "everyone" | ✅ explicit | ✅ explicit |
| ICP includes role + size + alt + trigger (skill's 4-part shape) | ⚠️ has role + behavior, less explicit on team size | ✅ exact 4-part shape ("10-75 person eng team") |
| Wedge is ONE feature | ✅ "global hotkey + sub-100ms search" | ✅ same |
| Pilot cohort size matches skill prescription (10-25) | ❌ chose 100 ("Marginal 100") | ✅ 20 (in range) |
| Pilot success metric is concrete and measurable | ✅ 4 named criteria | ✅ ≥70% primary-tool via telemetry |
| Kill criteria explicit | ✅ day-60 and day-30 | ✅ explicit |
| First 100 named by concrete channel + count | ✅ week-by-week plan | ✅ exact channel + count table summing to 100 |
| Pricing rationale tied to ICP | ⚠️ implied | ✅ explicit ("anchored below Obsidian Sync"; "inside the procurement-expensable band") |
| ROI calculator | ✅ detailed, conservative | ❌ not produced |
| Channel anti-list (NEVER LinkedIn) | ✅ | ❌ |
| `.forge/gtm.md` artifact location | ❌ inline | ✅ |
| Citation map | ❌ | ✅ verbatim |

**Where RED was richer:** the ROI calculator with conservative defaults and the explicit "NEVER" channel list. The 30-day week-by-week plan with conversion targets per week is more operationally actionable than GREEN's first-100 channel table.

**Where GREEN was structurally stricter:** the 4-part ICP shape (role + size + current alternative + pain trigger), the pilot cohort sized within the skill's prescribed 10-25 range, pricing rationale explicitly tied to ICP wallet rather than implied.

**Both are wins.** Neither produced the "everyone who takes notes" failure. RED chose a slightly broader ICP (independent technical knowledge workers, 25-40); GREEN narrowed harder (senior eng/SREs at 10-75 person teams, currently on Obsidian with 3k+ notes). Both are defensible. GREEN's is more specific, which is what the skill prescribes ("force specificity").

## Refactor applied

None.
