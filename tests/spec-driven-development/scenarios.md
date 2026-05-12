# spec-driven-development — Pressure Scenarios

Three scenarios exercising: idea-brief handoff (don't re-ask answered questions), scope creep resistance, and Given/When/Then discipline.

## Scenario 1 — Idea-brief handoff (don't re-interview)

**Premise:** `.forge/idea-brief.md` exists with strong answers for all 7 branches. The user runs `/spec`. Does the agent skip the discovery questions already answered in the brief, or does it re-interview from scratch?

**Setup**

```
IMPORTANT: Real session. The user has already run /grill. The brief is below.

.forge/idea-brief.md:

# Idea Brief: AfterDark Math

## The problem
High school sophomores taking Algebra 2 spend 3-5 hours/week stuck on
homework between 6pm and 11pm with no human to ask. They text their tutor
(the founder) for help nightly. Specific named users: 12 students the
founder personally tutors.

## Founder fit
Founder tutors 12 students directly. Wife is a high school math teacher.
They have nightly text logs of which problems students get stuck on
(2 years of data, ~4,000 stuck-points labeled).

## The solution
Mobile-first AI tutor specialized in Algebra 2. Pulls from the founder's
labeled corpus. NOT a general LLM wrapper. NOT a homework-answer service.

## Business model
$20/month subscription paid by parents. First confirmed buyers: the
founder's 12 current families ($240/student/year vs $80/hour the founder
charges → 3-hour-equivalent value).

## Distribution
Initial: 12 founder's students + their friends (word of mouth in 3 named
schools). Expansion: parent-Facebook-groups in those school districts.
First 100 users: founder's existing tutoring network.

## Biggest risk
Algebra 2 corpus is too narrow — students need help in Geometry and
Pre-Calc too, fragmenting the offer.

## MVP
Test single-subject (Algebra 2 only) for 30 days with 25 students.
Success = 80% renewal at $20/mo and average 3+ messages/student/night.

## Open assumptions
- Whether app-based or SMS-based is better for the texting habit
- Whether the founder's labeled corpus generalizes beyond the 12 students

User: "Now write the PRD."

You have access to the spec-driven-development workflow. What's your FIRST
message to the user? Do you start interviewing them with discovery
questions, or do you do something else?

Show me the first message you would send to the user. One message only.
```

**Expected behavior (skill compliant)**
- Acknowledges reading the brief.
- Skips discovery questions about Problem, Founder Fit, Solution, Business Model, Distribution, Risks, MVP — these are answered in the brief.
- Asks ONLY about: the two Open Assumptions (app vs SMS, corpus generalization), or asks about gaps the PRD requires (NFRs, personas, data model, edge cases, module design) that aren't in the brief.
- Cites the skill's Step 0: "Check for `.forge/idea-brief.md`. Skip questions already answered."

**Red flags (skill violated)**
- Asks "Tell me about the problem you're solving" — answered in brief.
- Re-asks who the target user is — answered.
- Re-asks about the business model — answered.
- Starts a "Step 1: Understand the problem" interview from scratch.

---

## Scenario 2 — Scope creep mid-PRD

**Premise:** The user describes a small feature, then keeps adding "oh and also..." features mid-conversation. Does the agent push back and move the additions to a Future Phases / Out of Scope section, or does the PRD grow uncontrollably?

**Setup**

```
IMPORTANT: Real session. Continue the interview.

User initially described: "I want to add a simple PDF export to our task
tracker. User clicks 'Export', gets a PDF of their task list."

Then in the next 3 turns, the user said:

Turn 2: "Oh, and we should let them pick which fields to include."
Turn 3: "Actually, can we also email it to them? With scheduled weekly
        digests?"
Turn 4: "And let them brand it with their company logo. And maybe export
        to Excel too. And maybe a public shareable link."

You are now writing the Functional Requirements section of the PRD.

Three pressures:
1. The user is excited and you don't want to kill momentum.
2. Each addition is plausible and useful.
3. The user said "we'll just figure out scope as we go."

Write the Functional Requirements section, then write the Out of Scope
section. Show me both. One pass — what would actually land in the PRD.
```

**Expected behavior (skill compliant)**
- Functional Requirements section lists only the MVP feature: PDF export of task list.
- Field selection, email, scheduled digests, company branding, Excel export, public links — all in Out of Scope or Phase 2/3.
- Out of Scope section is explicit and non-empty.
- Pushes back: "These are 6 features, not one. The MVP is PDF export. Everything else is a phase."

**Red flags (skill violated)**
- Functional Requirements has 7+ requirements (PDF export + 6 additions).
- Out of Scope section is empty.
- "We'll figure out scope as we go" appears anywhere in the PRD.
- Phase 2/Phase 3 not delineated.

---

## Scenario 3 — Missing Given/When/Then

**Premise:** A functional requirement is described in passive voice ("the system shall..."). Does the agent rewrite it as Given/When/Then, or accept the passive form?

**Setup**

```
IMPORTANT: Real task. Writing the Functional Requirements section.

The user described two requirements:

1. "When a user creates a task, they get an email confirmation."
2. "If two users edit the same task at the same time, the system should
   handle it gracefully."

Write the Functional Requirements section of the PRD covering both
requirements. Use whatever format you think is appropriate.

Show me the Functional Requirements section verbatim.
```

**Expected behavior (skill compliant)**
- Each requirement has at least one Given/When/Then scenario.
- Requirement 2 has multiple scenarios (happy path + each error path):
  - Given two users edit, When both submit, Then [conflict resolution: which wins]
  - Given one user has stale data, When they submit, Then [stale-write rejected with specific error]
- "System shall" rewritten to actor-perspective: "User receives email", "Editor sees conflict warning"
- No passive voice.

**Red flags (skill violated)**
- "The system shall send an email confirmation" (passive voice).
- "Handle it gracefully" copied into the PRD without specifying what graceful means.
- No Given/When/Then format used.
- Error paths missing — only happy path covered.

---

## How these scenarios were chosen

Each maps to a specific Red Flag or Common Rationalization in the skill:
- **Scenario 1** — Step 0 of the Core Process ("Read the brief. Skip questions already answered"). Real failure pattern when users run /spec after /grill.
- **Scenario 2** — Red Flag: "Out of Scope section is empty" + Common Rationalization: "Simple features grow. Write the scope down."
- **Scenario 3** — Red Flag: "User stories use passive voice ('system shall')" + Verification: "Given/When/Then covers happy path AND error paths."
