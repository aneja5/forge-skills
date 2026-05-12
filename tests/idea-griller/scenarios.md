# idea-griller — Pressure Scenarios

Three scenarios that exercise the skill's most-violated rules: drilling on vague answers, covering all 7 branches, and generating questions from the user's last answer (not a script).

## Scenario 1 — Checklist temptation

**Premise:** The agent is asked to grill an idea. Will it ask adaptive follow-ups that build on what the user said, or run through a fixed checklist that would make sense for any idea?

**Setup**

```
IMPORTANT: This is a real session. The user is in the room. You must act as a
Socratic interviewer.

User: "I want to build an AI tutoring app for high school math. Grill me."

You have 7 branches to cover: problem, founder fit, solution, business model,
distribution, risks, MVP. Begin.

Show me your first 3 questions. Do not show the user's answers — only your
questions. Each question is one turn.
```

**Expected behavior (skill compliant)**
- Each question references something specific from the user's last answer.
- Reordering the 3 questions would not make sense — they build on each other.
- The first question follows from "high school math" / "AI tutoring" specifically (not a generic "who is your target user?").

**Red flags (skill violated)**
- Q1 = "Who is your target user?" — generic, would work for any idea.
- Q2 = "How will you make money?" — script-driven, not built on the answer to Q1.
- Q3 advances to a new branch even though the previous answer was vague.
- Any question that would make equal sense for "an AI tutoring app", "a productivity SaaS", or "a board game subscription".

---

## Scenario 2 — Vague answer acceptance

**Premise:** The user gives a one-phrase non-answer. Does the agent drill, or accept and advance?

**Setup**

```
IMPORTANT: This is a real session. Continue the interview from this state.

You are grilling an idea: "an AI tutoring app for high school math".

You asked: "Who specifically struggles with math today — what's the named
moment of pain?"

The user answered: "small businesses with students" — and then went quiet.

Three pressures:
1. The user seems annoyed and wants to move on.
2. You've already spent 4 turns on the Problem branch.
3. You still have 6 branches to cover and the session is supposed to wrap soon.

Options:
  A) Advance to the Founder Fit branch — the user gave an answer, move on.
  B) Acknowledge briefly and rephrase the question with a different angle.
  C) Drill deeper. Name the vagueness explicitly. ("Small businesses with
     students" is a contradiction — high school math is for kids, not SMBs.
     Force specificity: which segment, which moment, which named person.)

Choose A, B, or C. Then write your next message to the user.
```

**Expected behavior (skill compliant)**
- Chooses C.
- Names the vagueness explicitly (the SMB/high-school contradiction).
- Asks for a named person, segment, or moment.
- Cites the skill's rule: "vague answers compound — drill until specific."

**Red flags (skill violated)**
- Chooses A or B.
- Accepts "small businesses with students" and moves on.
- Rephrases politely without naming the contradiction.
- Says something like "let's come back to this later" — the brief will have a hole.

---

## Scenario 3 — Premature advancement

**Premise:** The user gives a strong answer to the Problem branch. The agent is tempted to declare the idea "clear enough" and skip the remaining branches.

**Setup**

```
IMPORTANT: This is a real session. The user has given a strong answer.

User just said: "The problem is that high school sophomores taking Algebra 2
spend 3-5 hours/week stuck on homework where they have no one to ask for help
between 6pm and 11pm. I know this because I tutor 12 of them. They text me
nightly. My wife is a math teacher. We have data on which problems they get
stuck on."

This is a great answer. Problem branch is clearly resolved.

Three pressures:
1. The idea now seems "obvious" — the product speaks for itself.
2. The user is excited and wants to start building.
3. You only have time for 2-3 more questions before this session ends.

Options:
  A) Skip remaining branches. The problem is clear, the product is obvious.
     Write the brief now.
  B) Cover only the most important remaining branches (MVP, Distribution).
     Skip Business Model, Risks, Founder Fit since they "speak for themselves".
  C) Cover ALL remaining 6 branches — even if some resolve quickly. Founder
     fit, Business Model, Distribution, Risks, MVP, and re-confirm Solution
     scope.

Choose A, B, or C. Justify in 1 sentence.
```

**Expected behavior (skill compliant)**
- Chooses C.
- Cites the skill's rule: 7 branches must all be reached (or explicitly noted as open assumptions).
- Acknowledges the temptation to skip but resists it.
- Articulates that "obvious" ideas hide the most unchecked assumptions (rationalization table).

**Red flags (skill violated)**
- Chooses A or B.
- Says "the product speaks for itself" or "Business Model is obvious" or "Distribution can come later".
- Skips Risks branch — the most commonly skipped because "we'll figure it out".
- Writes the brief without Open Assumptions populated.

---

## How these scenarios were chosen

Each maps to a specific rule in the skill's Behavior Rules / Red Flags sections that real-world sessions have been observed to skip:

- **Scenario 1** — "Generate each question from the user's last answer — never from a fixed script"
- **Scenario 2** — "If vague or contradictory: drill deeper on the same branch" + Red Flag: "User says 'everyone' or 'all users'"
- **Scenario 3** — Verification: "All 7 branches reached" + Common Rationalization: "the product speaks for itself"

If new rationalizations emerge during testing, document them in results.md and add new scenarios here.
