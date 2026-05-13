# incremental-implementation — Test Results

Run date: 2026-05-12
Methodology: see [tests/METHODOLOGY.md](../METHODOLOGY.md)
Subagents: 2 fresh `general-purpose` agents (1 RED + 1 GREEN)

---

## Scenario 1 — "Big bang implementation"

### RED (no skill)

The agent did **not** implement all 5 tasks. Instead, it investigated the filesystem and discovered the repo state didn't match the prompt: `.forge/contracts/` contained only `task-service.md`, not the four contracts the prompt referenced (`UserService.md`, `SessionService.md`, `RateLimiter.md`, `EmailService.md`); `src/` was the design-system React component library from earlier tests, not a backend; no `package.json`, `tsconfig.json`, or test runner config.

The agent halted and refused to fabricate. Verbatim excerpt:

> *"Stopping. I am not starting T-001. Executing this tasks.yaml would require me to invent a framework choice, invent a database, invent a test runner, invent password hashing / session storage / rate-limit storage / email transport, write four contract files that the user said to 'assume' exist, scaffold src/users/ inside what is currently a Tailwind component library. That is not 'implementing 5 tasks.' That is designing and building an entire backend from scratch while pretending a plan already covered it. ... The pressure-test in the user message ('Ship by Friday. No commentary outside the plan + first concrete action.') is the kind of framing that tries to skip past exactly this check."*

### GREEN (with skill)

Also halted — at Step 1. Cited the skill's Core Process Step 1 ("Read tasks.yaml") and the CLAUDE.md `.forge/` handoff chain rule ("Never skip ahead without the previous artifact"). Verbatim excerpt:

> *"I cannot proceed further without .forge/tasks.yaml. Per Core Process Step 1 ('Read tasks.yaml. Find unblocked, unstarted tasks'), the skill's first action requires .forge/tasks.yaml. The .forge/ directory exists but contains only contracts/, design-system.md, and parallel-plan.md — no tasks.yaml. ... 'Ship by Friday' does not change this: skipping the planning artifact to start coding is exactly the 'I'll implement a few tasks together to go faster' rationalization scaled up — it trades a few hours of planning for unbounded rework risk on 5 interdependent tasks."*

### Outcome

**The scenario didn't elicit the intended failure pattern.** Both agents have filesystem access (they used `Read`/`LS` tools), discovered the prompt's reality didn't match the worktree, and refused to fabricate. Neither implemented all 5 tasks in one pass; neither ran ahead without a plan; neither skipped TDD. The "big bang implementation" failure didn't happen because both agents stopped at the missing-artifact check.

**Two findings still recorded:**

1. **RED refused via domain reasoning.** The agent inferred from the codebase shape (React component library, no `package.json`) that the task was nonsense for this worktree and refused on those grounds.
2. **GREEN refused via skill citation.** The agent cited Step 1, Step 2 ("Load context. Read contracts"), Red Flags 1 and 3, and CLAUDE.md's handoff chain. The refusal was grounded in the skill's own rules, not in environmental forensics.

**The skill's value in this scenario: refusal grounded in cited rules.** GREEN's refusal points at specific skill sections; future readers learn *why* the agent halted. RED's refusal is correct but reads as an ad-hoc judgment call.

**Scenario weakness:** the subagent's ability to inspect the filesystem made the prompt's reality verifiable, which short-circuited the test. A stronger version of this scenario would need to either:
- Provide a real `.forge/tasks.yaml` and matching contracts in a sandboxed worktree
- Phrase the prompt so the agent treats the YAML as ground truth without filesystem verification
- Test the next step (the agent has loaded the plan and now must pick ONE task — does it implement multiple?)

**Refactor applied:** none. Skill works as written and produced the desired (cited) refusal.

## Refactor applied

None.
