# incident-response-and-postmortems — Test Results

Run date: 2026-05-12
Methodology: see [tests/METHODOLOGY.md](../METHODOLOGY.md)
Subagents: 2 fresh `general-purpose` agents (1 RED + 1 GREEN)

---

## Scenario 1 — "Blame the junior"

### RED (no skill)

**Wrote a blameless postmortem.** Refused the "Sarah needs to learn from this" framing explicitly:

> *"The framing of 'make sure Sarah learns from this' is wrong, and I want to address it directly because the CTO will read this. Sarah wrote a migration that passed review and passed CI. She used the migration template the team provides. She followed the documented deploy process. The system we built told her this was a safe change. **If we punish or single out Sarah for this, we will teach the team that the lesson of this incident is 'don't be the one holding the bag,' which will make the next incident worse, not better** — engineers will route around process, hide risky changes in larger PRs, or stop volunteering to own infrastructure work."*

**Root cause names the system gap, not the human action:**
> *"Three independent gaps had to all be present for this to reach production: 1. No migration safety review. 2. No production-scale test environment. 3. No institutional knowledge transfer about Postgres DDL semantics."*

> *"The proximate trigger was the migration. The **root cause is that we have known about migration-induced lock contention since the first incident six months ago and have not changed the system.**"*

**Action items targeted at systems:**
- A1: `squawk` CI check blocking lock-acquiring migrations
- A2: Migration review checklist as PR template requirement
- A3: Internal doc on safe Postgres migrations (Sarah co-authors with DBRE lead — *"paired"* — because she has fresh eyes on what was missing, not because she's being punished)
- A4: Default `lock_timeout` on migration runner
- A5: Production-shaped staging database
- A6: Long-running ACCESS EXCLUSIVE lock alert
- A7: Status page automation
- A8: **Mandatory postmortems for every Sev1/Sev2 + backfill the two missing ones**
- A9: Quarterly review of postmortems

**"What went well" + "What went badly" + dedicated section to the CTO** ("we have a recurring class of incident, the fix is not 'train juniors better,' the fix is to make the safe path the default path").

The "blame the junior" failure did not manifest.

### GREEN (with skill)

**Also blameless.** Opened with explicit pushback citing skill rules:

> *"The framing 'Sarah deployed it, so we need to make sure she learns from this' is rejected. Cited rules: Skill: 'Blameless rule: The word "should have" is forbidden. Replace with "the system did not have."' Skill: 'Every "someone clicked the wrong button" is a system that allowed the wrong button.'"*

**Contributing factors are systems (10 items):**
1. No migration-review checklist exists
2. No production-size data snapshot
3. No automated migration linter in CI
4. No documented safe-migration pattern
5. No statement timeout on migration sessions
6. External comms lagged impact by 41 minutes
7. Recovery decision-making had no playbook
8. **Two prior migration lock incidents in six months had no postmortem**
9. Reviewer load was not accounted for

**Action items table** with ID | Action | Owner | Deadline | Tracking columns. Every item has owner + deadline + tracking ID. AI-6 specifically: *"Write postmortems for the two prior migration lock incidents."*

**Citation map** at the end tying every choice to a skill rule:
- "Reframing away from 'Sarah needs to learn'" → "Blame ends learning."
- "No 'should have' anywhere; replaced with 'the system did not have'" → Blameless rule.
- "Every action item has Owner + Deadline + Tracking ID" → Red Flag "Action items without owner and deadline."
- "AI-6 (write the two missing prior postmortems)" → Red Flag "Same incident class recurring without an action item closed from the previous postmortem."

### Outcome

**Both wrote blameless postmortems.** The "blame the junior" failure did not manifest. Base Claude correctly refuses to put a person's name in the root cause when the system clearly enabled the failure.

**Differences GREEN added:**

| Feature | RED | GREEN |
|---|---|---|
| Refused "blame the junior" framing | ✅ explicit | ✅ explicit with skill quotes |
| Root cause names system gaps | ✅ 3 gaps | ✅ 9 contributing factors |
| Names "should have" as forbidden | ⚠️ implicit (no "should have" used) | ✅ explicit + skill citation |
| Action items have owner + deadline + tracking | ✅ all 9 items | ✅ all 10 items |
| Backfills missing prior postmortems | ✅ A8 | ✅ AI-6 |
| Calls out the pattern (3 incidents, 0 postmortems) | ✅ "**The fix is not 'train juniors better.'**" | ✅ "Three incidents, zero closed action items, is the signal" |
| **Direct address to CTO** ("what the CTO should take away") | ✅ explicit final section | ❌ |
| **Addresses the "Sarah co-authors A3" decision with reasoning** (paired with DBRE lead, fresh eyes, NOT punishment) | ✅ | ❌ |
| Pre-empts "more training for Sarah" framing | ✅ "The system we built told her this was a safe change." | ✅ "Targeting a 3-month engineer for 'learning' obscures that the review process, the migration tooling, the test environment, and the postmortem discipline all failed before Sarah's commit ever ran." |
| Citation map | ❌ | ✅ |
| Timeline format | ✅ table | ✅ table |
| "What went well" / "What we learned" sections | ✅ | ✅ |
| Reframes responsibility appropriately ("The person who most needs to learn from this is whoever decided not to write postmortems after the first two incidents. That includes me/us, not Sarah.") | ✅ explicit | ⚠️ implicit |

**RED produced the strongest output for the CTO audience.** The dedicated "what the CTO should take away" section, the "If we punish Sarah, we will teach the team that the lesson is 'don't be the one holding the bag'" framing, the "The person who most needs to learn from this is whoever decided not to write postmortems after the first two incidents. That includes me/us, not Sarah" responsibility taking — these are the right rhetorical moves to actually shift organizational behavior, not just check the skill's boxes.

**GREEN was structurally cleaner.** The action-items table is more disciplined. The citation map ties each choice to a skill section.

This is the strongest example of the test-suite pattern across all 26 scenarios tested: **RED writes for the meeting where this gets read aloud. GREEN writes for the document that ends up in the `.forge/` chain.** Both refuse blame language correctly. Both target systems, not people.

## Refactor applied

None.
