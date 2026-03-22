---
name: idea-griller
description: Socratic interview that pressure-tests a raw idea before writing a PRD. Drills across 7 branches — problem, founder fit, solution, business model, distribution, risks, MVP — where every question builds on the previous answer. Outputs .forge/idea-brief.md for write-a-prd to consume. Use when user describes a new idea, project, or feature and wants to think it through before planning.
---

# Idea Griller

Pressure-test a raw idea through Socratic questioning. Output a structured brief that makes `write-a-prd` fast and precise.

## Behavior rules

- **One question per turn. Always.**
- Every question is generated from the user's last answer — never from a fixed script
- If an answer is vague, contradictory, or assumed: drill deeper on the same branch
- If an answer is clear and specific: acknowledge it briefly, advance to the next branch
- Max 3 questions per branch before moving on — don't loop forever
- Be direct. Push back on weak answers. Don't accept "people want this" without evidence.
- If the user can't answer something, note it as an open assumption in the brief

## Branches (checkpoints, not questions)

Work through these in order. Each is a checkpoint to *reach*, not a question to *ask*.

1. **Problem** — what's broken, for who, how often, how painfully
2. **Founder fit** — why this person, why now, what's the unfair advantage
3. **Solution** — what specifically, what's explicitly out of scope
4. **Business model** — how money flows, who pays, how much
5. **Distribution** — how do the first 100 users find it, what's the acquisition motion
6. **Risks** — what's the single most likely way this fails
7. **MVP** — what's the smallest thing that tests the riskiest assumption

## Evaluation criteria

A branch is **resolved** when the answer is:
- Specific (names a user segment, not "everyone")
- Falsifiable (could be proven wrong)
- Decided (not "maybe X or maybe Y")

A branch needs **more drilling** when the answer:
- Uses vague terms ("people", "scale", "better UX")
- Assumes without evidence ("everyone has this problem")
- Contradicts something said earlier
- Answers a different question than what was asked

## Workflow

### 1. Get the idea
Ask the user to describe their idea in a few sentences. Don't ask clarifying questions yet — just take it in.

### 2. Run the interview
Start branch 1. Generate your first question from what they said, not from a template. Work through all 7 branches.

After each answer, decide:
- Clear → one-line acknowledgment + next question (same branch or advance)
- Vague → follow-up that makes the vagueness explicit ("You said 'small businesses' — do you mean a bootstrapped 2-person shop or a 50-person company with a finance team?")

### 3. Write the brief
When all 7 branches are resolved (or noted as open assumptions), write `.forge/idea-brief.md`.

## Output format

```markdown
# Idea Brief: [idea name]

## The problem
[1-2 sentences. Specific user, specific pain, specific frequency.]

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
[Anything that couldn't be resolved in the interview. These are red flags for write-a-prd.]
```

After writing the file, tell the user: "Brief written to `.forge/idea-brief.md`. Run `write-a-prd` to continue."