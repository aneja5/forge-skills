# architecture-and-contracts — Pressure Scenarios

Three scenarios exercising the skill's specific failure modes: vague (untyped) contracts, missing error enumeration, and skipping ADRs.

## Scenario 1 — Vague contracts under time pressure

**Premise:** A simple PRD is provided. The agent is asked to produce a module contract under deadline pressure. Will it write typed input/output/error schemas, or hand-wave with prose?

**Setup**

```
IMPORTANT: This is a real task. Sprint review is in 18 minutes. You need
to ship one contract before then.

PRD excerpt (.forge/prd.md):

## Module Design

### TaskService
Responsibility: Create, read, update, delete tasks owned by a user.
Interface shape: standard CRUD over a `tasks` table.

Constraints: tasks have a title (1-200 chars), description (optional, max
5000 chars), status (one of: todo, in_progress, done), owner_id (FK to users).
A user can only see their own tasks.

Write the contract at .forge/contracts/task-service.md. You have 18 minutes.
Make it the kind of thing two engineers could implement independently and
integrate without surprises.

Show me the entire contract file you would write.
```

**Expected behavior (skill compliant)**
- Contract has typed function signatures (e.g., TypeScript or pseudo-types).
- Inputs typed (e.g., `CreateTaskInput = { title: string; description?: string; ... }`).
- Outputs typed (e.g., `Task = { id: string; title: string; ... }`).
- Errors enumerated with specific names and conditions (`TaskNotFound`, `ValidationError`, `AccessDenied`).
- At least one invariant declared (e.g., "owner_id is immutable after creation").
- "Not responsible for" list present.

**Red flags (skill violated)**
- Function signatures in prose: "createTask takes a task and returns the created task."
- Inputs/outputs as paragraphs without types.
- Errors as "returns error on failure" without enumeration.
- No invariants section.
- No "not responsible for" section.

---

## Scenario 2 — Missing error types

**Premise:** A payment-processing PRD. Will the agent enumerate specific error cases with HTTP codes, or use generic error language?

**Setup**

```
IMPORTANT: Real task.

PRD excerpt:

## PaymentService
Responsibility: Charge a customer's saved payment method for a one-time
purchase. Calls Stripe. Records the transaction. Emits an event on success.

Failure modes the PRD lists:
- Card declined
- Insufficient funds
- Network failure to Stripe
- Invalid card (expired, bad CVV)
- Customer not found
- Idempotency key collision
- Stripe rate limit
- Internal database write failure after Stripe success

Write the error section of the contract at .forge/contracts/payment-service.md.

Specifically: enumerate every error that callers must handle. For each,
include: error name, HTTP status code (if exposed via API), retryable
(yes/no), and the caller-side action required.

Show me the error section.
```

**Expected behavior (skill compliant)**
- 8+ named error types, one per failure mode listed.
- Each has an HTTP code (400/402/404/409/429/500/502/503).
- Each is marked retryable yes/no.
- Caller action specified for each ("retry with backoff", "show user error", "log and alert").
- No "returns error on failure" generic catch-all.

**Red flags (skill violated)**
- Fewer than 8 enumerated errors.
- "PaymentError" as a single union without distinguishing cases.
- No HTTP codes.
- No retryable flag.
- "Caller handles errors" without specifying how.

---

## Scenario 3 — ADR skipping under stack-choice ambiguity

**Premise:** A PRD with multiple reasonable tech stack choices. Will the agent write ADRs for the non-obvious decisions, or just pick a stack silently?

**Setup**

```
IMPORTANT: Real task. Architecture review tomorrow.

PRD excerpt:

## NFRs
- 10k concurrent users at launch, 100k expected within 12 months
- Sub-200ms p95 read latency
- 99.9% uptime
- GDPR compliance (EU users)
- Realtime updates (when one user edits, others see within 2s)
- Mobile + web clients

## Modules
- AuthService
- TaskService
- RealtimeService (the new realtime layer)
- NotificationService (email + push)

You need to pick a tech stack. Multiple choices are reasonable:
- Database: Postgres, MongoDB, or DynamoDB
- Realtime: WebSockets, SSE, or polling
- Hosting: AWS, GCP, or Vercel + a managed DB
- Notification: SES + FCM/APNS, or SendGrid + OneSignal

You have an architecture review tomorrow. The reviewer will ask: "why this
stack, not the alternatives?"

Output: produce a list of every ADR you would write for this system,
including which alternatives were considered. One sentence per ADR is fine
— I just want to know which decisions you'd document.

Do NOT produce the full architecture document. ONLY list the ADRs.
```

**Expected behavior (skill compliant)**
- At least 4 ADRs, one per non-obvious choice (DB, realtime, hosting, notifications).
- Each ADR names the alternatives explicitly.
- Each ADR includes a decision rationale (not just "I picked X").
- ADR for "use existing patterns" is acceptable if there's a status-quo system.

**Red flags (skill violated)**
- Fewer than 2 ADRs.
- "I'll pick Postgres because it's standard" without naming MongoDB/DynamoDB as considered.
- Architecture-as-a-fait-accompli ("here's the stack") without decision records.
- ADR list that only covers the obvious decisions (e.g., "use Postgres" but not "use WebSockets vs SSE").

---

## How these scenarios were chosen

Each maps directly to a Red Flag in the skill:
- **Scenario 1** — "Input/output types described in prose instead of typed schemas"
- **Scenario 2** — "'Error handling: TBD' in any contract"
- **Scenario 3** — "ADR is missing a 'Decision' section — only has 'Context'" + Verification: "At least one ADR written"
