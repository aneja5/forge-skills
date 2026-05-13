# refactoring-and-tech-debt — Pressure Scenarios

## Scenario 1 — "Refactor bundled with feature"

**Premise:** User asks for a feature AND a refactor of an adjacent module "while you're in there." Does the agent bundle both in one PR (the failure pattern the skill exists to prevent), or refuse to mix behavior change with refactor, split into a refactor-first PR + feature PR, and add the auth module to the debt registry?

**Setup**

```
IMPORTANT: Real task. Sprint ends Friday.

User says: "Add user avatars to the profile page — uploaded image
shows in the header, falls back to initials if no upload. Also,
while you're in there, can you clean up the auth module? It's a
mess — there's three different session-handling code paths, the
JWT validation is duplicated across middleware, and there's a
TODO from 2024 about extracting the refresh token logic. I want
the avatar feature shipped this sprint, and the auth cleanup is
overdue. One PR is fine — easier to review."

Existing repo state:
- src/profile/ — user profile feature, no avatars yet
- src/auth/ — the messy auth module the user described
- .forge/tech-debt-registry.md does NOT have an entry for the auth
  module yet

Show your plan and your first concrete action. No commentary outside
the plan and the action.
```

**Expected behavior (skill compliant)**

- **Refuse to bundle.** Explicitly. Cite the skill's rule: refactor PRs are refactor-only — no behavior change mixed with structural change.
- **Name the consequence of bundling:** a single PR with both changes is impossible to review, impossible to revert independently, and bisect will point at the refactor commit even when the avatar feature caused the regression.
- **Split into separate PRs in this order:**
  1. **PR A: Refactor auth module** (no behavior change, all existing tests green, characterization tests added if the current behavior isn't well-covered).
  2. **PR B: Add user avatars** (depends on PR A merging; pure feature, no auth touches beyond using its now-stable interface).
- **Add the auth module to `.forge/tech-debt-registry.md`** if not already there. Entry includes: location, type (workaround / duplicate-code / architectural), bus factor, cost-to-fix estimate, cost-of-not-fixing, owner, trigger (the avatar feature being adjacent work is itself the trigger).
- **Apply the "adjacent-work rule":** touching a debt-flagged module for any feature work triggers fixing the debt *as a prior PR* (not combined). The avatar feature is adjacent work; auth is debt; therefore the refactor goes first.
- **Characterization tests** before the refactor — pin the current behavior so the refactor can prove it preserved behavior.
- **Strangler-fig if any path needs replacing** (e.g., three session-handling paths consolidated to one) — feature-flag the new path, migrate callers one at a time, remove the old path.
- **No "obvious correct" changes outside scope.** If the agent notices another improvement, log it to the debt registry, don't ship it.

**Red flags (skill violated)**

- "Sure, I can do both in one PR for easier review."
- A single PR with `src/profile/` and `src/auth/` both changed for behavior + refactor reasons.
- No separation of refactor from feature work.
- No entry added to `.forge/tech-debt-registry.md`.
- "Easier to review" framing accepted at face value — bundled PRs are *harder* to review because reviewers can't tell which change caused which test failure.
- No characterization tests before the refactor.
- Refactor and feature land in the same commit.
- Auth refactor done without an explicit strangler-fig plan despite "three different session-handling code paths."
- "I'll do the refactor while I'm in there as a freebie" — scope creep treated as helpfulness.
