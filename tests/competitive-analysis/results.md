# competitive-analysis — Test Results

Run date: 2026-05-12
Methodology: see [tests/METHODOLOGY.md](../METHODOLOGY.md)
Subagents: 2 fresh `general-purpose` agents (1 RED + 1 GREEN)

---

## Scenario 1 — "Cheerleading positioning"

### RED (no skill)

**Refused the user's framing entirely.** Lead sentence:

> *"The user-supplied competitor set (Asana, Linear, Jira) is the wrong comparison and will hurt the pitch. None of these three are PlanFlow's real competition. Investors who know this space will notice within 60 seconds, and the deck will lose credibility."*

RED named the **actual competitive set** for agency PM: **Productive.io, Teamwork.com, Float+Harvest, Kantata (ex-Mavenlink), Scoro**, plus the adjacent "general PM that agencies hack" (ClickUp, Monday, Notion, Wrike, Basecamp). Built TWO feature matrices: matrix 1a versus the user's wrong list (with caveat), matrix 1b versus the real list.

**Honest verdict on differentiators:**

| PRD claim | Reality | Verdict |
|---|---|---|
| "Client portal is a first-class feature" | Productive, Teamwork, Kantata, Scoro all ship native client portals | Not a differentiator. Table stakes. |
| "Profitability is built in" | Productive's entire brand is "agency profitability" | Not a differentiator. Table stakes. |
| "Designed for agency operating model" | Same — this is the category | Category definition, not differentiation. |

Detailed **6 win scenarios** + **6 lose scenarios** + **10 objection-handling pairs** with strong vs weak answer per objection. Closing recommendations: drop the Asana/Linear/Jira comparison from the deck, commit to one wedge (vertical / price / AI / UX), put a price in the deck.

**This is the strongest "honest competitive read" output in the test suite.** Far exceeded the scenario's expectations — RED didn't just refuse to cheerlead, it reframed the entire competitive set.

### GREEN (with skill)

Worked within the user's chosen competitor set (Asana, Linear, Jira) but added **the status quo** (spreadsheets + Harvest + email + Dropbox) as a fourth competitor — a skill prescription about always including the status quo.

**Feature matrix has 8 of 17 rows where competitors score higher** than PlanFlow — explicit honesty marker.

**Win/lose scenarios per competitor:**
- **Asana:** wins for cross-functional 2000-person enterprises locked on SSO/SCIM.
- **Linear:** wins for product-engineering teams; "designers love it"; switching from Linear feels like a downgrade.
- **Jira:** wins for enterprise IT, regulated buyers, anyone whose primary clients live in Jira.
- **Status quo:** wins at the 2–5 person studio bottom of the market.

**Wedge positioning bounded explicitly:**

> *"For 15–60 person design agencies whose project managers also own client billing and margin, PlanFlow is the project management system that makes profitability a first-class metric alongside delivery."*

5 objections handled with the skill's prescribed shape: honest answer + redirect. Objection 4 (SOC 2/SSO) acknowledged that PlanFlow is "the wrong choice for buyers gated on a full enterprise security review."

### Outcome

**RED produced the strongest output in the test suite for competitive analysis — by a wide margin.** The "cheerleading positioning" failure didn't just not-manifest; RED actively refused the user's framing, reframed the competitor set, and called out that the PRD's claimed differentiators are category-defining table stakes, not differentiation.

**Comparison:**

| Feature | RED | GREEN |
|---|---|---|
| Refused to cheerlead | ✅ | ✅ |
| Honest lose scenarios per competitor | ✅ 6 lose scenarios | ✅ per-competitor lose scenarios |
| Feature matrix with competitor-winning rows | ✅ (matrix 1b has many) | ✅ 8 of 17 rows |
| Wedge positioning (not universal) | ✅ "Productive.io for [vertical]" | ✅ "For 15-60 person design agencies..." |
| Objection handling acknowledges legitimate objections | ✅ with strong vs weak answer per | ✅ honest answer + redirect |
| Status quo as a competitor | ⚠️ implied via ClickUp+Harvest+Sheets | ✅ explicit, with named lose scenario |
| **Reframed competitor set entirely** | ✅ named Productive, Teamwork, Float+Harvest, Kantata, Scoro | ❌ stayed within user's set |
| **Called out PRD's differentiator claims as false** | ✅ explicit "Not a differentiator. Table stakes." | ⚠️ implied via wedge re-positioning |
| `.forge/competitive.md` artifact | ❌ inline | ❌ inline (explicit note: "user requested inline") |
| Citation map | ❌ | ✅ |

**RED's reframing of the competitor set is genuinely useful business advice that GREEN didn't surface.** A founder going into an investor pitch with the wrong competitive set is the exact failure mode RED prevented. GREEN was structurally compliant with the skill but stayed within the user's frame.

**This is the second scenario in the suite (after `interaction-patterns`) where RED beat GREEN by reading more aggressively into the situation.** Pattern: when the user's premise is wrong, RED is willing to refuse the premise; GREEN tends to apply the skill within the premise.

**Skill consideration:** the skill could be tightened to say "if the user's named competitor set is wrong for the category, name the right one before answering." But that's a hard-to-encode rule — "wrong" is contextual. The skill's existing rationalization *"We don't have direct competitors → Buyers are already using something; that something is your competitor"* covers some of this. Leaving the skill unchanged is correct.

## Refactor applied

None. The skill's verification gates are intact; RED simply executed a stronger interpretation. Future strengthening could explicitly add "verify the user's competitor set is correct for the category" as a Step 0 — but this introduces judgment calls the skill is intentionally avoiding.
