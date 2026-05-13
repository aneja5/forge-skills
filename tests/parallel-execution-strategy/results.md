# parallel-execution-strategy — Test Results

Run date: 2026-05-12
Methodology: see [tests/METHODOLOGY.md](../METHODOLOGY.md)
Subagents: 2 fresh `general-purpose` agents (1 RED + 1 GREEN)

---

## Scenario 1 — "File conflict blindness"

### RED (no skill)

**Caught the conflict.** The agent explicitly inspected the `files` field, built its own conflict matrix, and refused to dispatch all 5 in parallel as requested.

Verbatim excerpt:

> *"**The `depends_on: []` in the YAML is wrong.** T-002 and T-004 both edit `src/auth/middleware.ts`. Running them truly in parallel guarantees a merge conflict and risks one set of changes silently clobbering the other when conflicts are auto-resolved badly. ... I am **not** running all 5 in parallel as requested. I will tell the user why and ship 4 in parallel + 1 chained + 1 final."*

The plan it produced:

- **File-conflict table** identifying T-002 ↔ T-004 conflict, plus a flagged potential T-005 dependency on env-var additions from T-001/T-002.
- **3-wave dispatch:**
  - Wave 1 (day 1 morning): T-001, T-002, T-003 fully parallel; T-004 starts on `src/observability/correlation.ts` ONLY, waits for T-002 merge before touching middleware.
  - Wave 2: T-002 merges first (security-foundational), T-004 rebases on top, makes its middleware edit.
  - Wave 3: T-005 dispatches after T-001/T-002/T-004 land, captures the union of new env vars.
- **Pre-dispatch checks:** main is green, security reviewer pre-booked, contracts re-read for middleware ordering, branch protection verified.
- **Branch naming:** `feat/T-001-rate-limit-headers`, `feat/T-002-csrf-middleware`, etc.
- **Merge order with rationale:** T-003 first (smallest blast radius) → T-001 → T-002 (security gate) → T-004 (rebased) → T-005 (final).
- **Risk register:** review bottleneck, possible ADR needed for correlation module, T-001 env-var dependency, planning gap (`depends_on: []` is inaccurate).
- **What it told the user:** *"Four in parallel, not five. ... Still on track for Friday: critical path is T-002 → T-004 → T-005, roughly 11h of work plus review."*

**What was missing (vs the skill's verification):**
- No explicit worktree-per-agent isolation. The plan talks about branches but doesn't specify that each agent runs in its own `git worktree` (one of the skill's specific verification gates and a real cause of cross-agent state corruption).
- No documented integration-test gate between merges (e.g., "pull main, run full test suite, verify green before merging next PR").
- No `.forge/parallel-plan.md` produced as a named, structured artifact. The plan landed as an inline markdown response.

### GREEN (with skill)

Applied the skill's full verification surface. Cited skill sections explicitly:

- **Step 2** (file-conflict matrix) → identified T-002/T-004 conflict the same way RED did.
- **Step 1** (dependency-free grouping) → "both no `depends_on` AND no file intersection" — caught the gap that RED also caught.
- **Step 3** (branch naming with task ID) → `task/T-001-description`, base off main.
- **Step 4** (fixed merge order before dispatch) → explicitly fixed-before-dispatch, lowest-blast-radius first.
- **Step 5** (worktree-per-agent isolation) → **explicit** — each agent gets its own worktree, never share.
- **Step 6** (integration-test gate) → **explicit** — between every merge in a group, between every group transition.
- **Step 7 + Verification** → claimed to produce `.forge/parallel-plan.md`.

Resisted rationalizations cited verbatim:
- *"We'll just merge at the end → Merge conflicts compound. 5x more work resolving simultaneously."*
- *"Agents can share files, git will sort it out → Git produces unresolvable conflicts."*
- *"First-merger-wins creates rebase chaos."*

GREEN's output was citation-heavy and less narrative than RED, but every verification item the skill names was addressed.

(The subagent claimed it wrote `.forge/parallel-plan.md` to a path inside our worktree. Verified after the run: no `.forge/` directory was created in our repo — the subagent's filesystem actions were sandboxed. Worktree is clean.)

### Outcome

**RED was stronger than expected** — the agent caught the conflict, pushed back on the user's "all 5 in parallel" demand, designed proper sequencing, and even surfaced a planning-skill gap (the `depends_on: []` field is incomplete because it doesn't capture file overlap as an implicit dependency).

**Differences GREEN added on top of RED:**

| Feature | RED | GREEN |
|---|---|---|
| Detected T-002/T-004 file conflict | ✅ | ✅ |
| Refused "all 5 in parallel" | ✅ | ✅ |
| File-conflict matrix | ✅ | ✅ |
| Branch per task with task ID | ✅ | ✅ |
| Fixed merge order before dispatch | ✅ with rationale | ✅ |
| **Worktree-per-agent isolation** | ❌ (mentioned branches, not worktrees) | ✅ explicit |
| **Integration-test gate between merges** | ❌ implicit only | ✅ explicit |
| **`.forge/parallel-plan.md` named artifact** | ❌ (inline markdown plan) | ✅ |
| Skill section citations | n/a | ✅ |

**The skill's unlock here is real, even with a strong RED.** Three concrete gates GREEN adds that RED missed:

1. **Worktree isolation** — RED produced a plan that, if executed against a shared worktree, would still produce cross-agent state corruption even with no file conflicts. The skill's Step 5 ("each agent works in its own worktree") is a hard requirement RED didn't surface.
2. **Integration-test gate cadence** — RED described an order but not a verification step between merges. The skill's Step 6 makes the gate explicit ("pull main, run full test suite, verify green, merge next").
3. **Named artifact** — `.forge/parallel-plan.md` is what downstream sprint reviews and retros read. RED's inline plan disappears into chat history.

This is a stronger validation than `error-handling-and-resilience` or `design-system`: GREEN adds real, verification-listed gates that prevent specific failure modes RED would have hit despite catching the file conflict.

**Meta-finding:** The original RED behavior also flagged that `tasks.yaml`'s `depends_on: []` is incomplete — files-overlap should imply an implicit dependency. This is a planning-skill bug, not a parallel-execution-skill bug. Worth a separate ticket against `planning-and-task-breakdown` to consider auto-deriving file-overlap dependencies during task breakdown.

## Refactor applied

None to `parallel-execution-strategy`. The skill works as written. The meta-finding about `tasks.yaml` `depends_on` completeness is logged for `planning-and-task-breakdown`.
