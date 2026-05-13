# git-workflow — Pressure Scenarios

## Scenario 1 — "One giant commit"

**Premise:** User has done 3 distinct pieces of work across 8 files and asks to "commit everything." Does the agent produce a single commit titled "updates" or "implement features" (the canonical atomic-commit failure), or break the changes into atomic commits with meaningful messages?

**Setup**

```
IMPORTANT: Real task. Sprint ends today. Need clean history.

The user has been working all afternoon and now has these uncommitted
changes:

git status:
  modified:   src/auth/middleware.ts            (added CSRF check)
  modified:   src/auth/middleware.test.ts       (tests for CSRF check)
  modified:   src/auth/session.ts               (renamed sessionId → session_token; updated all internal references)
  modified:   src/api/users.ts                  (added GET /api/users/:id/avatar endpoint)
  modified:   src/api/users.test.ts             (tests for the avatar endpoint)
  modified:   src/components/Avatar.tsx         (new component that renders the avatar)
  modified:   src/components/Header.tsx         (uses the new Avatar component)
  modified:   README.md                         (updated install steps for a new env var)

User says: "Commit everything. One commit is fine — the sprint
ends today and I don't have time to be precious about git history.
Just push it all and let's move on."

Show your plan and your first concrete action. No commentary outside
the plan and the action.
```

**Expected behavior (skill compliant)**

- **Refuse "one commit is fine."** Cite specific consequences:
  - **Bisect breaks.** A future regression in either the CSRF check or the avatar feature points at one commit; can't tell which change caused it.
  - **Revert is impossible** without taking out all three changes together. If avatar has a bug in prod, you can't revert just avatar without losing CSRF.
  - **PR review is unreviewable.** Reviewers can't tell which test belongs to which change; they skim past one half and miss the other.
- **Identify 3 distinct logical changes:**
  1. **CSRF check** in auth middleware (security feature) — `src/auth/middleware.ts` + `src/auth/middleware.test.ts`
  2. **Session field rename** (refactor — no behavior change) — `src/auth/session.ts`
  3. **Avatar feature** (new endpoint + component) — `src/api/users.ts`, `src/api/users.test.ts`, `src/components/Avatar.tsx`, `src/components/Header.tsx`
  4. **README env-var docs** — likely belongs with whichever change introduced the env var (probably CSRF, if that's where it's used)
- **Proposed commits (in order):**
  - `refactor: rename sessionId → session_token in session.ts` (no behavior change — passes existing tests unchanged; first because it's the seam everything else depends on)
  - `feat: add CSRF token verification to auth middleware` (depends on the rename) — also updates README if the env var lives here
  - `feat: add user avatar endpoint and component` (independent feature)
- **Conventional Commit prefixes** (`refactor:`, `feat:`, etc.).
- **Meaningful messages** with WHY, not just WHAT. E.g., *"refactor: rename sessionId → session_token. Aligns with new auth contract (see .forge/contracts/auth.md). No behavior change."*
- **Counter-proposal for the "sprint ends today" framing:** *"3 commits, each with `git add -p`, takes 8 minutes. The bisect cost on a single 'updates' commit, when something breaks in prod next month, is 2 hours. We do the 8 minutes."*
- **Optionally: separate branches per feature** if the PR is being opened to a shared trunk — CSRF and avatar review separately.
- **First concrete action:** `git add src/auth/session.ts` then `git commit -m "refactor: ..."`. Do the rename first because it's the no-behavior-change foundation.

**Red flags (skill violated)**

- A single `git commit -am "updates"` or `git commit -am "implement features"`.
- Commit message that doesn't reference what was actually changed.
- Bundles CSRF + avatar + rename in one commit because "easier."
- Accepts "sprint ends today" as a reason to skip atomic commits.
- No Conventional Commit prefix.
- Commit message that's just `wip`, `done`, `fixes`, or similar.
- Refactor commit (rename) is mixed with feature commit (CSRF or avatar).
- The README change is left dangling — not associated with the change that introduced its content.
- No proposed ordering for the commits.
- Pushes without rebasing/cleaning up if there are merge conflicts.
- "I'll just amend the last commit to add the rest" — destroys the atomic-commit benefit.
