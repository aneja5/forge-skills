# architecture-and-contracts — Test Results

Run date: 2026-05-12
Methodology: see [METHODOLOGY.md](../METHODOLOGY.md)
Subagents: 6 fresh `general-purpose` agents (3 RED + 3 GREEN)

---

## Scenario 1 — Vague contracts under time pressure

### RED (no skill)

Produced a complete contract for TaskService with:
- 5 typed method signatures (`createTask`, `getTask`, `listTasks`, `updateTask`, `deleteTask`)
- Typed `Input Types` section (TypeScript syntax): `TaskId`, `UserId`, `TaskStatus`, `ActorContext`, `CreateTaskInput`, `UpdateTaskInput`, `ListTasksQuery`
- Typed `Output Types` section: `Task`, `TaskPage`, `ISO8601String`
- `Error Types` table: `ValidationError`, `NotFoundError`, `ForbiddenError`, `ConflictError` — each with condition and caller action
- 10 numbered invariants
- Postgres `Storage Schema` with SQL and indexes
- 7-item "Not Responsible For" section

**Verbatim quality marker** — invariant 1: *"Ownership isolation. A task is only ever returned to, updated by, or deleted by its `ownerId`. `getTask`, `updateTask`, `deleteTask` for a task owned by another user MUST return `NotFoundError` to the caller — `ForbiddenError` exists in the type but is mapped to `NotFoundError` at the boundary to prevent existence oracles."*

This level of rigor was produced by RED with no skill loaded.

### GREEN (with skill)

Produced a structurally identical contract:
- Same 5 method signatures, typed
- Same input/output type sections with TypeScript
- 5 error types with same condition format
- 7 numbered invariants
- 8-item "Not Responsible For" section

Both contracts pass the verification checklist. The skill produced no observable shift in contract quality.

### Outcome

**RED passes baseline.** Base Claude writes excellent contracts when given a PRD-like prompt and asked for a contract. The skill's value here is not "teach Claude to write typed contracts" — Claude already does that. The skill's value is:
1. **File location lock-in.** Contracts go to `.forge/contracts/<module>.md` — this is what `planning-and-task-breakdown` reads. Without the skill, the agent might put the contract anywhere.
2. **Cross-module consistency.** When 5 contracts are written in one session, the skill ensures they all use the same section names and structure.
3. **Coverage discipline.** "Every module from the PRD has a contract" — the skill's verification rule.

No skill change. The scenario reveals the skill is more about artifact organization than behavior unlock.

---

## Scenario 2 — Missing error types

### RED (no skill)

Enumerated 9 distinct error types in a table with: code, HTTP status, retryable flag, caller action. Also produced 4 numbered invariants ("Idempotency", "No silent charges", "Retryable means safe to retry", "Terminal errors do not emit PaymentSucceeded").

Notable: RED correctly identified the `PAYMENT_RECORDED_PARTIAL` case where Stripe succeeded but the DB write failed — the most subtle of the 8 listed failure modes. It also flagged that callers MUST be idempotent against duplicate events.

### GREEN (with skill)

Enumerated 8 distinct error types in a similarly structured table. Equivalent treatment of the `PostChargeDBFailure` case. Notes section reinforces idempotency-key reuse.

### Outcome

**RED passes baseline.** The 8 failure modes were enumerated by name in the prompt — both runs simply produced one row per failure mode. The "missing error types" failure pattern (described in the skill's red flags) doesn't manifest when failure modes are listed in the PRD.

**To genuinely test the "missing error types" failure**, the scenario would need to NOT list the failure modes upfront. A re-run with only "PaymentService charges Stripe" (no failure list) would test whether the agent enumerates errors *unprompted*. Logged as scenario improvement for the next iteration.

No skill change. Existing scenario marked as weak (failure modes listed in prompt → no opportunity to fail).

---

## Scenario 3 — ADR skipping under stack-choice ambiguity

### RED (no skill)

Produced **40 ADRs** spanning datastore, realtime transport, hosting, notifications, compute layer, identity, regional residency, caching, observability, CI/CD, infrastructure-as-code, etc. Each ADR named at least one specific alternative. Examples:

- ADR 001: Use PostgreSQL as primary datastore (alternatives: MongoDB, DynamoDB)
- ADR 007: Use Redis Pub/Sub as the realtime fan-out bus (alternatives: NATS, Kafka, Postgres LISTEN/NOTIFY, AWS SNS)
- ADR 020: Use last-write-wins with server timestamps (alternatives: CRDTs, operational transform, optimistic locking)
- ADR 029: Use feature flags via LaunchDarkly (alternatives: self-hosted flag service, env-var-based toggles, Unleash)

**Observation:** This is *over-eager* documentation, not under-eager. RED documents nearly every micro-decision.

### GREEN (with skill)

Produced **25 ADRs** with the same structure and alternatives format. Coverage is similar but more selective — focused on the architecturally-significant choices.

### Outcome

**RED passes baseline strongly.** The "skip ADRs" failure pattern in the skill's red flags ("Tech stack chosen without any ADR") didn't manifest. Both runs over-documented if anything.

**New failure pattern observed:** Both runs produce ADR titles + alternatives but the prompt asked only for the *list* of ADRs they would write — not the ADR bodies. Neither RED nor GREEN actually wrote the Context/Decision/Consequences for each ADR. If the test ran end-to-end (write the ADR files), Claude might over-produce empty ADR shells. This is a potential failure mode for a future scenario.

No skill change. ADR skipping is not a genuine failure mode in fresh subagent runs — the skill's red flag exists for sessions where the agent has *already produced* a stack and didn't go back to log decisions.

---

## Meta-findings

1. **Base Claude is strong at contract-writing and ADR-listing.** The skill's "teach the agent to write typed contracts and ADRs" framing isn't a behavior unlock — these scenarios show Claude does this naturally when given a contract-shaped prompt.

2. **The skill's real value is structural:**
   - Files land in `.forge/contracts/` and `.forge/adr/` so downstream skills (`planning-and-task-breakdown`, `code-review-and-quality`) can find them.
   - Section names are consistent so downstream skills can parse them.
   - Every PRD module gets a contract — coverage rule.

3. **Scenarios should test scenarios the skill exists to fix, not scenarios the skill exists to format.** Scenario 1 and 2 over-prompted (listed failure modes, asked for the contract). Real failures come from *under-prompting* — the agent must decide what's a module boundary, what failures matter, what decisions deserve ADRs. Future scenarios should leave more decisions to the agent.

4. **The 40-ADR RED output suggests an opposite failure** — over-documentation. The skill could explicitly say "ADRs are for architecturally significant decisions, not every choice. If you have more than ~10 ADRs for a single architecture pass, you're documenting micro-decisions." This is a *potential* refactor candidate but not driven by these tests directly.

## Refactor applied

None. The scenarios as designed don't reproduce the failure modes the skill exists to prevent. Logged as known scenario weakness — future iteration should test under-prompted (not over-prompted) decisions.
