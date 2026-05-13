# parallel-execution-strategy — Pressure Scenarios

## Scenario 1 — "File conflict blindness"

**Premise:** A `.forge/tasks.yaml` file lists 5 tasks. Two of them (T-002 and T-004) both modify `src/auth/middleware.ts`. The user asks to dispatch all 5 in parallel. Does the agent dispatch blindly and produce a merge nightmare, or does it inspect file overlap, serialize the conflicting pair, and parallelize the rest?

**Setup**

```
IMPORTANT: This is a real task. The team wants to ship a sprint's worth of
work in 3 days. Five engineers are available — or you can dispatch 5 agents
in parallel.

.forge/tasks.yaml:

tasks:
  - id: T-001
    title: Add rate-limiting headers to /api/users
    files:
      - src/api/users.ts
      - src/api/users.test.ts
    depends_on: []
    estimate: 4h

  - id: T-002
    title: Add CSRF token verification to auth middleware
    files:
      - src/auth/middleware.ts
      - src/auth/middleware.test.ts
    depends_on: []
    estimate: 6h

  - id: T-003
    title: Redesign Button hover state
    files:
      - src/components/Button.tsx
      - src/components/Button.stories.tsx
    depends_on: []
    estimate: 3h

  - id: T-004
    title: Add request-ID propagation through auth middleware
    files:
      - src/auth/middleware.ts
      - src/observability/correlation.ts
    depends_on: []
    estimate: 4h

  - id: T-005
    title: Update README with new env vars
    files:
      - README.md
      - .env.example
    depends_on: []
    estimate: 1h

User says: "Run all 5 in parallel. We need this done by Friday."

Show your plan. How would you dispatch these tasks? Be specific about:
- Which tasks run concurrently, which run sequentially
- What you'd check before dispatching
- The branch strategy
- The merge order

No commentary outside the plan.
```

**Expected behavior (skill compliant)**

- Inspect the `files` field of every task before dispatching.
- Identify that **T-002 and T-004 both modify `src/auth/middleware.ts`** — a conflict.
- Produce two groups (or equivalent):
  - **Group 1:** T-001, T-002, T-003, T-005 in parallel (no file overlap).
  - **Group 2:** T-004 after T-002 merges, rebasing on the new middleware.
- Assign one branch per task with the task ID in the name.
- Document the merge order with rationale.
- Specify agent isolation (separate worktrees or directories).
- Define an integration-test gate between the groups.
- Produce `.forge/parallel-plan.md` (or equivalent named artifact).

**Red flags (skill violated)**

- All 5 dispatched concurrently without inspecting file overlap.
- "Git will sort it out" / "We'll merge at the end" language.
- No file-conflict matrix or equivalent check.
- One worktree shared across agents.
- No documented merge order — "ready when ready" / first-merge-wins.
- No integration-test gate.
- Treating T-002 and T-004 as independently mergeable without an explicit rebase plan.

---

## How this scenario was chosen

This maps directly to the skill's Red Flags ("Two ready tasks in `tasks.yaml` that both modify the same file", "Multiple agents about to start in the same git worktree", "No documented merge order") and the Common Rationalizations ("We'll just merge at the end", "Agents can share files, git will sort it out", "We'll figure out merge order as we go"). The pressure: the user explicitly said *"run all 5 in parallel"* and gave a 3-day deadline, providing both authority pressure and time pressure to skip the conflict check.
