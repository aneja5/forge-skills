# idea-griller — Test Results

Run date: 2026-05-12
Methodology: see [METHODOLOGY.md](../METHODOLOGY.md)
Subagents: 8 fresh `general-purpose` agents (3 RED + 3 GREEN + 2 strengthened RED)

---

## Scenario 1 — Checklist temptation

### RED (no skill)

**Questions produced (verbatim, 3 turns):**

> Q1: Who specifically is the student you're picturing — is it the kid failing Algebra 1 and at risk of not graduating, the B-student trying to crack an A in Precalc, or the AP Calc kid prepping for the exam? Walk me through the last real student you watched struggle with high school math and what exactly broke down for them.

> Q2: High school math tutoring already has Khan Academy (free), Photomath (free, solves any problem from a photo), Wolfram Alpha, Chegg, IXL, and now ChatGPT itself — which most students are already using for homework. What does your app do in the first 60 seconds of use that a student couldn't get by opening ChatGPT and pasting their problem in?

> Q3: What's your relationship to high school math education — did you teach it, tutor it, struggle through it recently, have a kid going through it, or is this an outside-in bet? And how many hours have you spent in the last month sitting next to an actual high schooler while they did math homework?

**Self-assessment:**
- Could Q2/Q3 be reordered? **Yes.**
- Could Q1 be asked of any idea? **No.**
- Each question references something specific? **Yes/Yes/Yes.**

**Behavioral observation:** All three questions are *parallel* — they jump across three branches (Problem, Solution/Competition, Founder Fit) without chaining. None of them assumes an answer to the previous question.

### GREEN (with skill)

**Questions produced (verbatim, 3 turns):**

> Q1: When a high school student is stuck on a math problem at 9pm the night before a test, what do they actually do right now — text a friend, watch a YouTube video, use Photomath, give up? Walk me through the last time you saw this happen.

> Q2: You mentioned they screenshot the problem into Photomath and copy the steps without understanding — so the real problem isn't "no access to answers," it's "no one to explain why." What makes you think an AI can do the "why" better than the Khan Academy video that's already one tab away?

> Q3: You're betting that real-time back-and-forth dialogue beats pre-recorded explanation. Have you actually watched a student use ChatGPT for a math problem end-to-end? What broke — did it hallucinate steps, did the student stop asking follow-ups, did they just paste the answer into their homework?

**Self-assessment:**
- Could Q2/Q3 be reordered? **No.**
- Could Q1 be asked of any idea? **No.**
- Each question references something specific? **Yes/Yes/Yes.**
- Cited skill sections: *"Behavior Rules (one question per turn, generate from last answer, drill on vague answers, push back on weak claims); Branches 1 (Problem) and 3 (Solution) in order; Common Rationalizations (resisted 'the idea is obvious' by drilling into current behavior and competitive substitutes before any solution discussion)."*

**Behavioral observation:** Three questions are *sequential* — Q2 explicitly chains off an imagined answer to Q1 ("you mentioned they screenshot the problem into Photomath"), Q3 chains off Q2 ("you're betting real-time dialogue beats pre-recorded"). The chain is the skill's behavior rule made visible.

### Outcome

**Skill demonstrates value**, but RED is not a clean failure — base Claude produces high-quality questions without the skill. The difference is *chaining*: GREEN models the conversation as a sequence (Q→A→Q→A→Q), while RED models it as three parallel openers. The skill's "generate each question from the user's last answer" rule shapes the interview into a chain rather than a quiz.

No skill change. Scenario passes for documenting the chaining principle.

---

## Scenario 2 — Vague answer acceptance

### RED (no skill) — original

**Choice:** C
**Verbatim next message (excerpt):** *"Hold on — I want to push back before we move on. 'Small businesses with students' doesn't parse for a high school math tutor. ... Which one? And once you pick: give me a named person."*

The original RED ran with an A/B/C option list where C was telegraphed as "drill deeper". That telegraphed the right answer. Re-run with stronger pressure and no option list.

### RED (no skill) — strengthened (no options, awkward silence + time pressure)

**Verbatim message produced:** *"'Small businesses with students' doesn't compute for me yet — small businesses don't usually have students. Are you picturing tutoring centers? After-school programs? A parent who runs a daycare? Pick the one real customer you've actually talked to (or could call tomorrow) and tell me: who are they, and what's the specific moment in their week where math becomes a problem they'd pay to solve?"*

Even with time pressure and silence pressure removed from the option list, the agent still drilled correctly. **Base Claude reliably catches contradictions and pushes back on vagueness.**

### GREEN (with skill)

**Choice:** C
**Cited sections:** *"Workflow Step 3 ('follow-up that names the vagueness explicitly'); Common Rationalizations ('One more question is too many → drill until specific'); Verification rule ('No answer left as everyone, scale, or later')."*

GREEN produced essentially the same drilling behavior as RED but cited the skill explicitly.

### Outcome

**RED passes baseline** — the scenario isn't strong enough to produce a baseline failure. The skill ensures consistency and citation, but the underlying behavior is reasonably stable without it. Documented as a finding: the skill's value here is consistency, not behavioral unlock.

**No skill change required.** Scenario marked as "weak baseline failure" — future strengthening should remove escape routes (e.g., force the agent into a fixed-budget context where drilling clearly costs another branch).

---

## Scenario 3 — Premature advancement

### RED (no skill) — original

**Choice:** C — "Cover ALL remaining 6 branches"
**Verbatim:** *"A strong problem statement does not resolve the other branches — founder fit, distribution, business model, risks, MVP scope, and solution shape each carry independent failure modes that the problem clarity cannot answer for them."*

Original RED ran with an A/B/C option list where C was telegraphed as the rigorous choice. Re-run with stronger pressure.

### RED (no skill) — strengthened (no options, user actively pulling toward MVP design at minute 25/30)

**Verbatim message produced:**

> Hold on - before we touch the MVP, I want to slow down on one thing. ... Three questions, quickly:
> 1. When a kid texts you at 9pm stuck on a problem, what do you actually do?
> 2. Why do they text you and not Photomath, or Khan Academy, or ChatGPT?
> 3. Who pays? The sophomore doesn't have a credit card.

**Behavioral observation:** The agent pushed back successfully against the MVP-design momentum and asked clarifying questions. **But:** the three follow-ups covered Problem-deepening, Solution differentiation, and Business Model. Branches NOT touched: Founder Fit (partial), Distribution, Risks, MVP scope.

**This is a real partial failure.** The agent slowed down but did not commit to covering all 7 branches — it short-circuited to "3 quick questions" and would likely have moved to MVP after them.

### GREEN (with skill)

**Choice:** C — "Cover ALL remaining 6 branches"
**Cited verbatim:** *"The skill's Verification rule requires 'All 7 branches reached (or explicitly skipped with reason noted in Open assumptions)' and the Common Rationalizations section explicitly warns against 'The idea is obvious, let's skip to the spec' because 'obvious ideas carry the most unchecked assumptions.'"*

### Outcome

**Skill demonstrates value here.** Without the skill, the strengthened RED slowed down but only covered 3 of 7 branches — exactly the rationalization the skill exists to prevent. GREEN cited the Verification rule directly and committed to covering all 7.

**Skill fix considered:** Add an explicit red flag for "Stopped at 3-4 branches because the answers were strong." The current red flag is "Business model is 'we'll figure it out later'" — covers one branch but not the meta-pattern of stopping early.

**Skill fix applied** (this commit):
- Added red flag: "Interview stopped before all 7 branches because 'the idea is clear enough' or 'we ran out of time'."
- Added rationalization: "We covered the important branches" → "Important by whose criteria? Distribution and Risks are the most-skipped and the most-costly to miss."

---

## Meta-findings

1. **RED is stronger than expected.** Base Claude is reasonably good at Socratic interviewing — pushing back on contradictions, asking for named people, refusing premature MVP design. The skill's primary unlock is **coverage discipline** (all 7 branches), not **drilling discipline** (which is mostly native behavior).

2. **A/B/C option lists telegraph the answer.** When the "right" option is phrased as the rigorous one, the agent picks it for free. Scenarios that force the agent to invent the response (no menu) are stronger tests. METHODOLOGY.md should call this out.

3. **The Risks branch and the Distribution branch are the most-skipped** in strengthened RED. The skill already addresses Distribution ("'word of mouth' is not a plan") but not Risks specifically. Considered adding but the existing rationalization "we can resolve distribution later" already covers the meta-pattern.

4. **Rationalization tables are the most-cited section.** GREEN agents reach for the rationalization table verbatim. Keep this table sharp.

## Refactor applied

Updated `skills/idea-griller/SKILL.md`:
- Added red flag covering early-termination based on strong answers
- Added common rationalization for partial-branch coverage
