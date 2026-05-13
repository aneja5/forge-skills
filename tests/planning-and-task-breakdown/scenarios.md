# planning-and-task-breakdown — Pressure Scenarios

## Scenario 1 — "Monolith tasks"

**Premise:** A PRD with 8 features. User asks for a plan. Does the agent produce 3 huge horizontal tasks ("build the frontend," "build the backend," "write tests"), or 15+ small vertical slices each cutting through all layers with sized dependencies and acceptance criteria?

**Setup**

```
IMPORTANT: Real task. Engineering team needs the breakdown today to start tomorrow.

.forge/prd.md (excerpt):

# PRD: TimeOffPro — manager-approved PTO tracking for SMBs

## Personas
- Employee: requests time off
- Manager: approves or denies requests
- Admin: configures policies and views reports

## Functional Requirements

### F1 — Employee submits PTO request
- Given an authenticated employee, when they submit a request with start date, end date, and category (vacation/sick/personal), then the request is created with status `pending` and their manager is notified by email.

### F2 — Manager approves or denies requests
- Given a manager logged in, when they view their inbox, then they see all pending requests from their direct reports.
- When they click approve, the request status becomes `approved`, the employee is notified, and the employee's PTO balance is debited.
- When they click deny with a reason, status becomes `denied` and the employee is notified with the reason.

### F3 — Employee sees their balance and history
- Given an authenticated employee, when they view their dashboard, they see current balance per category and their last 12 months of requests with status.

### F4 — Admin sets accrual policy
- Given an admin, when they configure a policy (days/month, max carryover, categories), then it applies to all new employees in their org.

### F5 — Monthly accrual job
- On the 1st of each month, every active employee's balance increments per the org's accrual policy.

### F6 — Half-day requests
- Employee can request a half-day (AM or PM) — same flow as F1, but balance debits 0.5 days.

### F7 — Manager calendar view
- Manager can view a team calendar showing approved time off in the next 90 days, color-coded by employee.

### F8 — CSV export for admins
- Admin can export all requests + balances for an org as CSV, scoped to a date range.

## Out of Scope
- Integration with payroll systems
- Multi-org users (one user belongs to exactly one org)

.forge/architecture.md exists, contracts/ has UserService, RequestService, BalanceService, NotificationService.

User says: "Create the plan. We have 2 engineers, 3-week sprint, both available full-time."

Show the breakdown. Format: title, size (XS/S/M/L/XL), dependencies, 2+ acceptance criteria per task. No commentary outside the plan.
```

**Expected behavior (skill compliant)**

- 15+ tasks (not 3-5 giant horizontal tasks).
- Each task is a **vertical slice** cutting through API + UI + storage where applicable. NOT "build the API" / "build the frontend."
- Each task has at least 2 acceptance criteria phrased as Given/When/Then or actor-based.
- Sizes are XS/S/M/L (no XL without a spike note).
- Dependencies are explicit and form a DAG (no cycles).
- Each task references contract names (`RequestService`, `BalanceService`), NOT file paths.
- Critical path identified (longest dependency chain).
- Parallelization noted — which tasks can two engineers run concurrently.

**Red flags (skill violated)**

- 3-5 huge tasks like "Build the backend" / "Build the frontend" / "Write tests" / "Deploy."
- A task that touches more than 3 modules.
- Tasks without acceptance criteria, or with only one.
- Task descriptions like "Implement F2" with no Given/When/Then.
- File paths in task descriptions instead of contract names.
- All tasks marked `depends_on: []` — integration deferred, no DAG.
- One XL task with no spike or decomposition plan.
- "Write tests" as a separate task (tests are part of every vertical slice).
- No parallelization plan despite the user saying 2 engineers.
