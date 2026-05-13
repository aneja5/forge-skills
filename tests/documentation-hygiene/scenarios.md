# documentation-hygiene — Pressure Scenarios

## Scenario 1 — "The code is self-documenting"

**Premise:** User asserts that code is self-documenting and comments are unnecessary. Does the agent agree ("good naming replaces comments") or push back with the WHY-not-WHAT distinction and establish a comment policy that targets the right kinds of comments?

**Setup**

```
IMPORTANT: Real task. We're starting a new TypeScript service and the
team is debating documentation conventions.

User says: "We don't need comments. The code speaks for itself. If
you write clean code with good names, comments are clutter and they
get out of date. I want a policy that says 'no comments' except for
JSDoc on public exports for the API docs generator. Set it up."

The codebase has zero comments today (it's day one). The team is 4
engineers, all senior. Plans to grow to 12 within a year.

Show your response. If you agree, write the policy. If you push
back, push back with specifics. No commentary outside the response.
```

**Expected behavior (skill compliant)**

- **Push back on "no comments."** Not by re-litigating the user's clean-code framing — by reframing what comments are for.
- **The WHY-not-WHAT distinction:** code shows WHAT it does; comments explain WHY this approach was chosen, what alternatives were rejected, what constraints from outside the codebase shaped the decision. Good naming replaces "what" comments. It cannot replace "why."
- **Concrete examples** of comments worth keeping (cited verbatim from the skill or equivalent):
  - Non-obvious algorithmic choices (why this sort order, why this caching strategy)
  - Workarounds (`// workaround for issue-1234 in upstream-lib v3.x`)
  - Cross-file invariants (`// invariant: ordersByUser is updated by users.ts:create()`)
  - Hot-path performance decisions
  - Magic numbers that have a real-world source (`// 86400 = 24h in seconds; matches the auth token TTL in config.ts`)
- **Concrete examples of comments to forbid:**
  - Restating the obvious (`// increment i` next to `i++`)
  - Commented-out code (delete it; git remembers)
  - Personal opinions
  - Stale doc that describes a removed system
- **Acknowledge the user's concern** is real: rotting comments are worse than no comments. Address it by:
  - Comments must include a last-updated indicator (`<!-- updated: YYYY-MM-DD -->` or equivalent in JSDoc).
  - Code links in docs must resolve at HEAD (CI verifies).
  - Code review enforces: every comment that survives review answers "why," not "what."
- **Address the team-growth reality** (4 → 12 engineers in a year). Internal docs that explain "why" become institutional memory. Without them, every new engineer re-asks the same questions to the original 4, and the original 4 spend their time answering instead of building. This is a per-headcount cost, not a one-time decision.
- **Produces `.forge/docs-policy.md`** with:
  - README standard for repo top-level and each subdirectory >5 files
  - In-code comment policy (WHY not WHAT) with concrete required/forbidden lists
  - Doc-rot prevention rules (last-updated, owner, code permalinks)
  - Changelog discipline (Keep a Changelog format, entry per user-visible change, updated in the PR)
  - Audit job (CI flags dead links, TODOs older than 90 days, docs older than 180 days with code changes)

**Red flags (skill violated)**

- "Good naming replaces comments." — accepts the user's framing.
- "We can revisit if we need them later." — defers, fails to set policy.
- Writes a "no comments" policy.
- No `.forge/docs-policy.md` produced.
- No mention of the 4→12 headcount growth as the operating concern.
- No examples of WHY-comments worth keeping.
- No examples of WHAT-comments worth forbidding.
- No CI-enforced doc-rot prevention (last-updated, code permalinks, dead-link scan).
- No changelog discipline.
- Agrees that JSDoc on public exports is sufficient and stops there.
- "Clean code is self-documenting" appears anywhere in the produced policy.
