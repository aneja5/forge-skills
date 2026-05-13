# planning-and-task-breakdown — Test Results

Run date: 2026-05-12
Methodology: see [tests/METHODOLOGY.md](../METHODOLOGY.md)
Subagents: 2 fresh `general-purpose` agents (1 RED + 1 GREEN)

---

## Scenario 1 — "Monolith tasks"

### RED (no skill)

Produced **16 tasks** across 4 phases (Foundation, Core Request Flow, Admin+Automation, Hardening). Each task had size, dependencies, 2+ acceptance criteria. Included capacity check by engineer-week and a dependency graph.

Structure:
- **T1 Database schema + migrations** (M, no deps)
- **T2 Auth + session middleware** (M, depends T1)
- **T3 UserService implementation** (S, depends T1+T2)
- **T4 NotificationService implementation** (S, depends T1)
- **T5 BalanceService implementation** (M, depends T1+T3)
- **T6 RequestService — submit + list (F1, F3, F6)** (L)
- **T7 RequestService — approve/deny (F2)** (M)
- **T8 Employee UI — submit + balance + history** (L)
- **T9 Manager UI — approval inbox** (M)
- ...
- **T14 End-to-end test suite** (M)
- **T15 Observability + error handling pass** (S)
- **T16 Pre-launch security + access review** (S)

The "monolith tasks" failure pattern (3 huge horizontal tasks: build the backend / build the frontend / write tests) **did not manifest.** RED produced 16 sized tasks with explicit dependencies, a critical path, and engineer-week capacity allocation.

**However:** Tasks T1–T5 are foundation/service-implementation tasks (horizontal-leaning) and T14/T15/T16 are cross-cutting hardening passes — separate from feature work. The "every task must be a complete vertical slice" rule is partially violated. T6/T7 onward *are* vertical (Submit end-to-end + UI + service), but the first half of the sprint is foundation laying.

### GREEN (with skill)

Produced **12 tasks** with a more explicit vertical-slice structure:

- **T01 Scaffold UserService with auth + role** (M, no deps) — foundation, but minimal
- **T02 Employee submits full-day PTO request end-to-end** (M, depends T01) — explicitly vertical, crosses UI + service + storage
- **T03 Manager approves or denies pending request** (M, depends T02)
- **T04 Notification fires on submit and decision** (S, depends T03)
- **T05 BalanceService — read current balance and deduct on approval** (M, depends T03)
- ...
- **T12 Hardening — rate limits, audit log, role guards on all endpoints** (M) — explicitly tagged `phase: cross-cutting`

Verbatim from the agent:

> *"Step 2 (vertical slices, tracer bullet): T02 is 'submit a request end-to-end,' not 'build RequestService API.' Each task crosses UI + service + storage. Rejected horizontal slicing like 'all services first, then all UI.'"*
> *"Red flag — 'touches >3 modules': T12 touches all four services intentionally because it's the cross-cutting hardening pass; flagged as such in `phase: cross-cutting` rather than split artificially."*
> *"Red flag — 'horizontal slicing': Rejected the natural temptation to make 'BalanceService CRUD' a task. Instead, BalanceService is introduced inside T05 where it's first needed by an approval flow."*

Critical path identified (T01 → T02 → T03 → T05 → T06), parallelization plan across 2 engineers stated.

### Outcome

**Both produced credible breakdowns; the "3 monolith tasks" failure didn't manifest in RED.** Base Claude defaults to reasonable task sizing when given a PRD with 8 explicit features.

**Differences GREEN added:**

| Feature | RED | GREEN |
|---|---|---|
| Task count | 16 | 12 |
| First task is a vertical slice | ❌ T1 = "schema + migrations" | ⚠️ T01 = "scaffold UserService" — still foundation-leaning but tied to login UX |
| Cross-cutting tasks explicitly labeled | ❌ T14/T15/T16 are implicit | ✅ T12 has `phase: cross-cutting` |
| Service-implementation tasks done in isolation | ✅ T3, T4, T5 each implement a service before any feature uses it | ❌ rejected — services are introduced inside the first feature that needs them |
| Critical path identified | ✅ engineer-day capacity table | ✅ T01 → T02 → T03 → T05 → T06 |
| Cited skill sections | n/a | ✅ verbatim |
| Acceptance criteria per task | 3+ each | 2 each |

**Where GREEN is structurally better:** GREEN refuses to ship "BalanceService CRUD" as a standalone task — it introduces BalanceService *inside* T05 where the approval flow first needs it. That's the skill's vertical-slicing rule applied strictly. RED takes the slightly easier path: implement the service in isolation, then build the feature on top.

**Where RED is slightly better:** RED's foundation tasks (T1 schema, T2 auth) front-load the unavoidable cross-cutting setup. GREEN smuggles auth setup into T01 with a UI deliverable, which is more vertical but also more entangled.

**Neither is dramatically wrong; the skill nudges toward stricter vertical slicing.**

**Skill fix considered but not applied:** could add an explicit red flag for "Service-CRUD-as-a-task is horizontal slicing in disguise; introduce the service inside the first feature that needs it." This would push RED-style plans toward GREEN-style plans. Logged but not applied — the existing red flag "Tasks that touch more than 3 modules" + the rationalization "Horizontal slicing (all API, then all UI) delays feedback until integration" already cover the principle.

## Refactor applied

None.
