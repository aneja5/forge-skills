---
name: idea-griller
description: Socratic interview that pressure-tests a raw idea before writing a PRD. Drills across 7 branches — problem, founder fit, solution, business model, distribution, risks, MVP — where every question builds on the previous answer. Outputs .forge/idea-brief.md for write-a-prd to consume. Use when user describes a new idea, project, or feature and wants to think it through before planning.
---

# Idea Griller

## Overview

Pressure-test a raw idea through Socratic questioning before committing to a PRD. One question per turn, each generated from the user's last answer. Output is `.forge/idea-brief.md` — a structured brief that makes `write-a-prd` fast and precise.

## When to Use

- User describes a new idea, project, or feature they haven't fully thought through
- User wants to stress-test assumptions before writing a PRD
- Idea is vague or contradictory and needs sharpening

## When NOT to Use

- PRD already exists — go straight to `write-a-prd`
- User is asking for a bug fix or code change — use `triage-issue` or `tdd`
- Idea is already well-specified with clear scope and user segment

## Common Rationalizations

| Thought | Reality |
|---------|---------|
| "The idea is obvious, let's skip to the PRD" | Obvious ideas have the most unchecked assumptions |
| "The user knows what they want" | They know symptoms; root cause is often different |
| "One more question is too many" | Vague answers compound — drill until specific |
| "I can infer the business model" | Never infer — ask. You will be wrong. |
| "The MVP is clear" | MVPs defined without drilling risks are over-scoped |

## Red Flags

- User says "everyone" or "all users" — no specific segment identified
- Answer to distribution is "word of mouth" — not a plan
- MVP scope keeps growing across turns — unresolved risk assumption
- User can't name a single person who has this problem right now
- Business model answer is "we'll figure it out later"

## Behavior Rules

- **One question per turn. Always.**
- Generate each question from the user's last answer — never from a fixed script
- If vague or contradictory: drill deeper on the same branch
- If clear and specific: acknowledge briefly, advance to next branch
- Max 3 questions per branch before moving on
- Push back on weak answers. Don't accept "people want this" without evidence.
- Note unresolved answers as open assumptions in the brief

## Branches

Work through these in order. Each is a checkpoint to *reach*, not a question to *ask*. See [evaluation-criteria.md](evaluation-criteria.md) for resolution criteria.

1. **Problem** — what's broken, for who, how often, how painfully
2. **Founder fit** — why this person, why now, what's the unfair advantage
3. **Solution** — what specifically, what's explicitly out of scope
4. **Business model** — how money flows, who pays, how much
5. **Distribution** — how the first 100 users find it, what's the acquisition motion
6. **Risks** — the single most likely way this fails
7. **MVP** — the smallest thing that tests the riskiest assumption

## Workflow

1. Ask the user to describe their idea in a few sentences. Take it in — no clarifying questions yet.
2. Start branch 1. Generate your first question from what they said, not from a template.
3. After each answer: clear → acknowledge + advance; vague → follow-up that names the vagueness explicitly.
4. When all 7 branches are resolved (or noted as open assumptions), write the brief.

## Output

Write `.forge/idea-brief.md`:

```markdown
# Idea Brief: [idea name]

## The problem
[Specific user, specific pain, specific frequency — 1-2 sentences]

## Founder fit
[Why this person. What they know or have that others don't.]

## The solution
[What it is. What it is NOT.]

## Business model
[Who pays. How much. Why they would.]

## Distribution
[How first 100 users are acquired. Specific channel, not "word of mouth".]

## Biggest risk
[The single most likely failure mode.]

## MVP
[The smallest thing that tests the biggest risk.]

## Open assumptions
[Anything unresolved. These are red flags for write-a-prd.]
```

After writing: "Brief written to `.forge/idea-brief.md`. Run `write-a-prd` to continue."

## Verification

Before closing the session, confirm:

- [ ] All 7 branches reached (or explicitly skipped with reason noted)
- [ ] No answer left as "everyone", "scale", or "later"
- [ ] At least one named person or company as the target user
- [ ] MVP is a single testable thing, not a feature list
- [ ] Open assumptions section populated (empty = suspicious)
- [ ] `.forge/idea-brief.md` written and readable
