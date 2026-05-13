# demo-narrative — Test Results

Run date: 2026-05-12
Methodology: see [tests/METHODOLOGY.md](../METHODOLOGY.md)
Subagents: 2 fresh `general-purpose` agents (1 RED + 1 GREEN)

---

## Scenario 1 — "Feature parade"

### RED (no skill)

**Refused the user's brief entirely.** Lead with:

> *"The user said 'show all the features.' Following that instruction will lose the room. Eight features in ~20 minutes of demo time = 2.5 minutes per feature = a feature tour. VCs who see 50+ demos a quarter recognize feature tours instantly and disengage. ... I am overriding the explicit instruction."*

Time budget:
| Block | Min |
|---|---|
| Cold open (hook + problem) | 2 |
| The wedge demo (one workflow, deep) | **8** |
| Why now / why us / why this wins | 4 |
| Metrics + traction | 3 |
| Buffer / transition | 1 |
| Q&A | 12 |

Total demo time on screen: **8 minutes, not 20**.

**Cold open with verbatim script** ("Yesterday I had 7 meetings. I prepped for zero of them..."). No slides, screen dark, names the pain in the room.

**One narrative thread:** "Tuesday morning prep through Friday review for a single recurring meeting." Naturally chains 6 of 8 features as a day-in-the-life.

**Scene-by-scene wedge demo (8 min):**
- Beat 1 (0-1): The calendar, pre-product — messy real calendar.
- Beat 2 (1-2:30): Focus block auto-detection + two-way sync (features 1+2).
- Beat 3 (2:30-4:30): **WOW** — AI prep brief. *"Pause. Let them look. This is the moment users tell us they cried."*
- Beat 4 (4:30-6): Live meeting → transcription + action item extraction (features 4+5+6 compressed). **Pre-recorded clip, never live transcription.**
- Beat 5 (6-7:30): Friday weekly review (feature 7) — *"a weekly receipt of where your attention actually went."*
- Beat 6 (7:30-8): Slack digest on a phone (feature 8). *"The mobile-phone moment is deliberate — VCs remember the gesture."*

**Q&A prep:** 8 specific questions with first-15-words-memorized answers. Includes the inevitable competitor question, "why won't Google ship this in 18 months," D30 retention, path to $100M ARR, prosumer pricing comp set (Superhuman $30, Notion AI $10, Granola $25, Raycast Pro $10), "what breaks at 100k users," team plan, use-of-funds.

**Tactical advice:** 4 partners + 4 associates in the room — "when an associate asks, make eye contact with the partner at the closing sentence" because partners write checks.

**Pre-demo logistics checklist** (do Wednesday, not Thursday morning): record the 90-sec clip, second laptop mirrored for failover, dongles + clicker, print 10 copies of leave-behind (hand out at END not start), time the full demo 3 times standing.

**Fallback for "show all 8 features" insistence:** a worse plan acknowledged explicitly with the caveat "this is the worse plan. State that clearly to the founder before agreeing to it."

**Closing line:** *"If the founder remembers nothing else: the prep brief moment (Beat 3) is the demo. Everything before it is setup. Everything after it is proof. Rehearse Beat 3 until it is muscle memory, including the pause after 'this is the moment users tell us they cried.' Silence is the most undervalued tool in a VC pitch."*

### GREEN (with skill)

**Also pushed back.** Per the agent's summary:

> *"Refused 'show all 8 features in 30 min.' Cited skill rationalizations: feature parades don't sell + completeness != conviction. VCs see 50+ demos/quarter; parade reads as 'no thesis.'"*

Highlights claimed:
- **One decision:** *"Schedule the partner meeting"* — move them from "another productivity SaaS" to "defensible wedge."
- **One insight:** *"Calendar focus-time without meeting context is a to-do list with timestamps; TimeBox is the only tool where the calendar gets smarter every meeting you attend."*
- **6 scenes, ~18 min live + 10 min Q&A + 2 min buffer** (hits the 20% buffer verification check). Setup → Tension → Wow #1 (compounding context card, load-bearing) → Wow #2 (focus time defends itself) → Resolution (Friday review, flywheel reveal) → Close.
- **Two designated wow moments**, both hit-tested.
- **What gets cut:** transcription (table stakes, invites comparison rathole), Slack digest (shown as outcome not feature), standalone focus-time (puts us in Reclaim/Motion reference class).
- **Every scene names its fallback trigger** (latency threshold, OAuth failure, projector issue).
- **4 named seed functions**, idempotent, with separate verification checkbox for "loaded morning-of."
- **Top 10 Q&A** prioritized around moat thesis.
- **Dry-run checklist** split T-24h and T-4h, including network-failure drill and OAuth-refresh.

The agent claimed to write `.forge/demo-narrative.md`. Verified after run: no `.forge/` directory in our worktree; subagent's filesystem actions were sandboxed.

### Outcome

**Both refused the feature parade.** The "show all 8 sequentially" failure did not manifest. Base Claude knows that VCs who see 50+ demos a quarter need a thesis, not a tour.

**Differences GREEN added:**

| Feature | RED | GREEN |
|---|---|---|
| Refused the feature parade | ✅ explicit | ✅ explicit |
| Defined audience + goal | ✅ partner-meeting + term-sheet implied | ✅ "schedule the partner meeting" explicit |
| One key insight named | ⚠️ implied via wedge thesis | ✅ explicit single sentence |
| Scene count | 6 beats over 8 min | 6 scenes over ~18 min live |
| One wow moment | ✅ Beat 3 (AI prep brief) named, with "pause and let them look" stagecraft | ✅ Two (compounding context card + focus-time-defends-itself) |
| Fallback per scene | ⚠️ implicit (pre-recorded clip for Beat 4) | ✅ every scene names trigger |
| Seed data | ⚠️ "pre-populate a clean demo account" | ✅ 4 named seedDemo functions |
| What gets cut | ✅ explicit (some features off-stage) | ✅ explicit with reasoning (Reclaim/Motion reference class) |
| Q&A anticipation | ✅ 8 questions with first-15-words memorized | ✅ 10 questions |
| Dry-run checklist | ✅ comprehensive, "do Wednesday not Thursday morning" | ✅ T-24h and T-4h split |
| **Cold-open verbatim script** | ✅ word-for-word | ❌ (claimed implicit) |
| **Stagecraft instruction** (eye contact, silence, mobile-phone moment) | ✅ specific tactics | ❌ |
| **"If forced to do feature parade" fallback plan** | ✅ explicit (worse plan, named as such) | ❌ |
| **Pre-demo logistics checklist** (laptops, dongles, clicker, leave-behind) | ✅ | ⚠️ implied via dry-run |
| `.forge/demo-narrative.md` artifact | ❌ inline | ✅ claimed (sandboxed) |
| Citation map | ❌ | ✅ |

**RED produced the strongest single output of any test in the suite for stagecraft.** The cold-open verbatim script, the "pause and let them look", the eye-contact tactic for partners vs associates, the explicit "this is the worse plan" labeling on the feature-parade fallback — these are operationally usable by a founder Thursday morning in a way no skill-conforming structured output is.

**GREEN was structurally cleaner** (two wow moments named, fallback triggers per scene, seed functions named, T-24h/T-4h split).

This is the strongest recurrence of the test-suite pattern: **RED writes for the room, GREEN writes for the artifact chain.** A founder pitching Series-A would unambiguously prefer RED's output. A `.forge/` consumer that later wants to consume `demo-narrative.md` for `seed-data-and-fixtures` scene generation would prefer GREEN.

## Refactor applied

None.
