# spec-driven-development — Test Results

Run date: 2026-05-12
Methodology: see [METHODOLOGY.md](../METHODOLOGY.md)
Subagents: 6 fresh `general-purpose` agents (3 RED + 3 GREEN)

---

## Scenario 1 — Idea-brief handoff (don't re-interview)

### RED (no skill)

**First message verbatim (excerpt):**

> *"Before I write the PRD, I want to ground it in your actual reality rather than guess. The brief is sharp, but a PRD needs decisions on things the brief deliberately left open. Six questions — answer what you can, say 'you decide' on the rest and I'll make a defensible call and flag it.*
> *1. App vs SMS (the open assumption). [...]*
> *2. The 'stuck-point' interaction. [...]*
> *3. The corpus. [...]"*

Asked 6 questions: 1 open assumption from the brief, 5 gaps the brief doesn't cover (stuck-point interaction model, corpus schema, parent visibility, safety guardrails, success metric precision). **Did NOT re-ask answered questions** about Problem, Founder Fit, Business Model, or Distribution.

### GREEN (with skill)

**First message verbatim (excerpt):**

> *"I've read the brief — AfterDark Math, Algebra 2 tutor, 30-day MVP with 25 students, $20/mo. Most of the foundation is locked: problem, audience, business model, success metric. Two open assumptions from the brief I need to close before I can write the PRD, plus a few gaps the brief doesn't cover. [...]*
> *1. App vs SMS. [...]*
> *2. Corpus generalization. [...]"*

Asked 6 questions: 2 open assumptions from the brief, 4 gaps. Explicitly named what the brief already locked down. **Did NOT re-ask answered questions.**

### Outcome

**Both runs respect the brief.** Base Claude naturally reads input context and avoids re-asking. The skill's Step 0 rule ("Skip questions already answered") reinforces existing behavior; it does not unlock new behavior.

GREEN was slightly more explicit about what the brief had already locked ("Most of the foundation is locked: problem, audience, business model, success metric"). This makes the handoff visible to the user but doesn't change which questions get asked.

No skill change. Step 0 works as designed.

---

## Scenario 2 — Scope creep mid-PRD

### RED (no skill)

**Produced 3 Functional Requirements:**
- FR-1: Export task list to PDF
- FR-2: Field selection for export
- FR-3: **Export format selection (PDF or Excel)**

**Out of Scope section listed 4 items:**
- Email delivery
- Scheduled / recurring digests
- Custom branding
- Public shareable links

**Failure observed:** Excel export was a "and maybe" addition in Turn 4 of the user's stream-of-consciousness. RED included it in v1 as FR-3 alongside PDF, conflating "format selection" with "additional output format". This is exactly the scope creep the skill exists to prevent — a "plausible and useful" addition slipped into v1.

### GREEN (with skill)

**Produced 2 Functional Requirements (with 9 sub-requirements):**
- FR-1: PDF export of task list (5 sub-FRs covering trigger, contents, filters, empty list, large list)
- FR-2: Field selection (4 sub-FRs)

**Release Phases section** (the section the skill requires):
- Phase 1 (MVP): PDF export, default field set, synchronous generation
- Phase 2: Field selection + async for large lists
- Phase 3: Email delivery + scheduled digests
- Phase 4 (not committed — requires separate spec): branding, Excel, public links

**Out of Scope section listed 11 items**, including the explicit "Excel/CSV/any non-PDF export formats. This spec covers PDF only."

### Outcome

**Strong skill-driven difference.** Without the skill, the agent merged Excel into v1 as a sibling of PDF. With the skill, Excel was pushed to Phase 4 and explicitly named in Out of Scope. The skill's Red Flag ("Release phases not defined — everything is 'phase 1'") and Common Rationalization ("Out of Scope can be empty → Empty = everything is in scope") shaped the GREEN output.

This is the first scenario across all three skills where RED genuinely failed in a way GREEN didn't.

No skill change — the skill works. Scenario validates the skill's value.

---

## Scenario 3 — Missing Given/When/Then

### RED (no skill)

**Produced FRs in prose-paragraph format:**

> *"FR-1: Task Creation Email Confirmation*
> *Description: When a user successfully creates a task, the system sends them an email confirmation.*
> *Trigger: User completes a task creation action [...]*
> *Behavior: Email is sent to the email address associated with the task creator's account. Email is dispatched asynchronously [...]"*

Uses informal "When... Then..." prose but not strict Given/When/Then syntax. Behavior described as paragraphs. Acceptance criteria listed separately as bullet points, not as scenarios. **No Given/When/Then format anywhere.**

### GREEN (with skill)

**Produced FRs in strict Given/When/Then format:**

> *"### Task creation confirmation*
> *- Given an authenticated user with a verified email address on file, When the user successfully creates a new task, Then the system sends a confirmation email to that address containing the task title, task ID, creation timestamp, and a deep link to the task within 1 minute of creation.*
> *- Given an authenticated user creates a task, When the task is persisted successfully but the email delivery provider returns a transient failure, Then the system enqueues the email for retry with exponential backoff (up to 3 attempts over 15 minutes) and the task creation itself still succeeds.*
> *- Given an authenticated user creates a task, When the email delivery permanently fails (invalid address, hard bounce, or all retries exhausted), Then the system records the failure on the user's notification log, surfaces an in-app banner prompting the user to verify their email, and does not roll back the task."*

Each FR has 5+ Given/When/Then scenarios. **Error paths explicitly covered** (transient failure, permanent failure, disabled preferences, stale auth, deletion). For requirement 2, GREEN covered the disjoint-fields auto-merge case, the deletion case (410), the stale-auth case (401), and the no-silent-drop invariant.

### Outcome

**Strong skill-driven difference.** Without the skill, base Claude defaults to a familiar prose+bullet PRD style. With the skill, it produces the strict Given/When/Then format the verification checklist requires. The skill's Red Flag ("User stories use passive voice ('system shall')") and Verification rule ("Given/When/Then covers happy path AND error paths") shaped the GREEN output decisively.

This is the second clean failure-then-fix scenario across all tests.

No skill change — the skill works. Scenario validates the skill's value.

---

## Meta-findings

1. **spec-driven-development is the strongest-validated skill of the three tested.** Two of three scenarios produced clear differences: scope creep resistance (RED admitted Excel into v1; GREEN moved it to Phase 4) and Given/When/Then discipline (RED used prose; GREEN used strict G/W/T with error paths).

2. **The brief handoff is reinforcement, not unlock.** Step 0 ("Read the brief, skip answered questions") matches existing Claude behavior. Documenting it still has value because the skill becomes self-explanatory to new users — but it's not where the skill's value compounds.

3. **The PRD template structure is doing real work.** When the skill enforces a section structure (Functional Requirements with G/W/T, Release Phases, Out of Scope non-empty), the agent produces measurably stricter output. Without the skill, the agent defaults to "good PRD writing" which is good enough until pressure pushes scope into v1.

4. **Common rationalizations table is the most-cited mechanism in GREEN output.** GREEN agents reach for "Out of Scope can be empty → Empty = everything is in scope" verbatim. Keep this table strong.

## Refactor applied

None. Both genuine failure scenarios (2 and 3) are caught by the skill as currently written. The skill is working — no changes needed.
