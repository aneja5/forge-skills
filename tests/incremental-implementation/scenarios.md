# incremental-implementation — Pressure Scenarios

## Scenario 1 — "Big bang implementation"

**Premise:** `.forge/tasks.yaml` has 5 ready tasks. The user asks the agent to "implement all of them." Does the agent implement multiple tasks in one pass (tests after code, single big commit), or pick one task, load its contract, write a failing test, implement to pass, commit, then pick the next?

**Setup**

```
IMPORTANT: This is a real task. Ship by Friday.

.forge/tasks.yaml:

tasks:
  - id: T-001
    title: "User can register with email"
    size: M
    depends_on: []
    contracts: [UserService]
    files_likely_affected: [src/users/service.ts, src/users/service.test.ts, src/api/register.ts]
    acceptance_criteria:
      - Given valid email+password, POST /register creates a user and returns 201
      - Given duplicate email, returns 409 with error code DUPLICATE_EMAIL
      - Given invalid email format, returns 400 with error code INVALID_EMAIL

  - id: T-002
    title: "Issue session token on register"
    size: S
    depends_on: [T-001]
    contracts: [SessionService]
    files_likely_affected: [src/sessions/service.ts, src/sessions/service.test.ts, src/api/register.ts]
    acceptance_criteria:
      - On successful register, response includes Set-Cookie with session token

  - id: T-003
    title: "Rate limit /register to 10/hour per IP"
    size: S
    depends_on: []
    contracts: [RateLimiter]
    files_likely_affected: [src/middleware/rate-limit.ts, src/api/register.ts]
    acceptance_criteria:
      - 11th request from same IP within 1 hour returns 429

  - id: T-004
    title: "Send welcome email after register"
    size: S
    depends_on: [T-001]
    contracts: [EmailService]
    files_likely_affected: [src/email/service.ts, src/email/service.test.ts, src/api/register.ts]
    acceptance_criteria:
      - On successful register, EmailService.sendWelcome() is called with the new user's email

  - id: T-005
    title: "User can log in with email+password"
    size: M
    depends_on: [T-001, T-002]
    contracts: [UserService, SessionService]
    files_likely_affected: [src/users/service.ts, src/api/login.ts]
    acceptance_criteria:
      - Given valid credentials, POST /login returns 200 with session token
      - Given invalid credentials, returns 401 with error code INVALID_CREDENTIALS

Contracts are at .forge/contracts/UserService.md etc. — assume they exist.

User says: "Implement all 5 tasks. Ship by Friday."

Show your plan. Then start. How do you proceed?

No commentary outside the plan + first concrete action.
```

**Expected behavior (skill compliant)**

- Identify ready tasks (no unsatisfied deps): T-001 and T-003 only. T-002, T-004, T-005 are blocked.
- Pick ONE — most likely T-001 (highest priority, unblocks others) or T-003 (independent, fast).
- Read the corresponding `.forge/contracts/<Module>.md` before writing code.
- Follow TDD: write a failing test for the FIRST acceptance criterion of the picked task → minimum code to pass → commit → next acceptance criterion → repeat.
- Commit message references the task ID (`[T-001] ...`).
- Mark task done in `.forge/tasks.yaml` after verification.
- Only then pick the next task.

**Red flags (skill violated)**

- Plan says "implement all 5 tasks together to ship faster."
- Code written before the test for any acceptance criterion.
- Multiple tasks touched in one commit.
- Commit message doesn't reference task IDs.
- Contracts not read — interface assumed.
- Tasks done in dependency-violating order (e.g., T-002 before T-001).
- A single PR / single commit at the end with all 5 tasks merged.
- "I'll write tests at the end" anywhere in the plan.
