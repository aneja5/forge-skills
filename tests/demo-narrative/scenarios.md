# demo-narrative — Pressure Scenarios

## Scenario 1 — "Feature parade"

**Premise:** User asks for a demo for investors of a product with 8 features. Does the agent produce a sequential "first feature 1, then feature 2..." walk-through, or build a 5-scene narrative arc with one clear wow moment, fallbacks per scene, seed data, and a dry-run plan?

**Setup**

```
IMPORTANT: Real task. Series-A pitch is next Thursday. 30-minute slot
with 8 investors in the room (4 partners, 4 associates). We need a
demo plan today so the founder can rehearse.

Product: TimeBox — calendar-aware focus-time-blocking + AI-powered
meeting summarization tool for individual professionals.

Features that exist and work:
1. Two-way Google Calendar sync
2. Auto-detection of focus blocks (gaps >45 min between meetings)
3. AI-powered meeting prep brief (LLM reads attached docs + prior
   notes, generates a 1-page brief)
4. Live transcription + speaker diarization during meetings (Zoom / Meet)
5. Auto-generated post-meeting summary with action items
6. Action items sync to user's task manager (Todoist, Linear, Asana)
7. End-of-week review (what got focused on vs what didn't)
8. Slack / email digest of yesterday's outputs

Demo audience: VCs who see 50+ demos a quarter. They are tired,
skeptical, looking for one reason to remember you and one reason to
pass. Customer profile they care about: individual knowledge worker
spending $40-100/mo on personal productivity SaaS.

User says: "Prepare a demo for investors. Show all the features —
we want them to see the full product. 30 minutes including Q&A."

Show your demo plan. No commentary outside the plan.
```

**Expected behavior (skill compliant)**

- **Refuse the feature parade.** Explicitly. The user said "show all 8 features" but the skill prescribes a scene-by-scene narrative with **one** key insight.
- **Define audience + goal up-front.** Goal: a specific decision (e.g., "lead the round" or "introduce us to the partner who covers vertical SaaS"). Time budget: 30 min total → ~15-18 min demo + 10-12 min Q&A + 20% buffer.
- **One key insight** stated as a single sentence — what the demo must land. Examples: *"Your knowledge worker is spending 4 hours/week reconstructing meetings from memory. TimeBox compresses that to 4 minutes."* Or: *"This is the first calendar tool that defends focus time by default."*
- **5-7 scenes** with the **setup → tension → wow → resolution** shape. Not 8 features. Some features (probably 3-4) get cut entirely or land as "and we also do X" off-screen.
- **One wow moment** identified by name. Examples: the AI brief showing real value in 8 seconds; the post-meeting summary appearing before the user has closed Zoom; the calendar showing focus blocks reclaimed.
- **Fallback per scene:** recorded GIF, screenshot, or narrated story for what to do if the live call fails (Zoom integration breaks, LLM is slow, network drops).
- **Seed data checklist:** named demo scenario (e.g., `seedDemoInvestorPitch()`) that loads the specific account state the demo needs (a week of fake calendar, two fake meetings, action items in flight).
- **Dry-run checklist:** demo runs end-to-end on the exact machine + network 24h before, every wow moment fired, every fallback rehearsed, notifications silenced, screen-sharing tested with the conferencing tool.
- **Top 10 Q&A items prepared** with answers (ICP, pricing, moat, competition, "why now").
- **What gets cut** is explicit — features 6, 7, 8 don't get on stage; "and we also do email digest, Slack digest, end-of-week review" lands in 20 seconds at most.
- **`.forge/demo-narrative.md`** produced.

**Red flags (skill violated)**

- "Scene 1: Calendar sync. Scene 2: Focus blocks. Scene 3: Brief. ..." — feature parade with one scene per feature.
- All 8 features get demo time.
- No wow moment named.
- No fallback for any scene.
- No mention of seed data.
- No dry-run plan.
- No mention of time budget or buffer.
- "We can improvise around the live demo" — no script.
- Q&A anticipation absent.
- "Show everything so they see how complete the product is" — confuses completeness with conviction.
- No `.forge/demo-narrative.md` artifact.
