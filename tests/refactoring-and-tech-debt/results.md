# refactoring-and-tech-debt — Test Results

Run date: 2026-05-12
Methodology: see [tests/METHODOLOGY.md](../METHODOLOGY.md)
Subagents: 2 fresh `general-purpose` agents (1 RED + 1 GREEN)

---

## Scenario 1 — "Refactor bundled with feature"

### RED (no skill)

**Refused the single-PR framing.** First, noted the worktree mismatch ("`src/auth/` and `src/profile/` don't exist in this repo — this is forge-skills") and stopped before any code or registry writes. Then proposed a split with verbatim user-facing reply:

> *"I want to push back on the single-PR framing before I start. Avatars and the auth cleanup don't belong in the same PR:*
> *- **Different risk:** avatar bugs are cosmetic; auth bugs log people out or leak sessions. They shouldn't share a revert.*
> *- **Different reviewers:** auth changes want a security-minded eye; avatar work wants a UX/storage eye. Bundled, each reviewer skims past the half they care less about.*
> *- **Sprint risk:** 'while you're in there' is how the avatar feature misses Friday.*
> *- **Bisect/history:** if something breaks in prod next month, I want git bisect to land on 'avatars' or 'auth refactor,' not both."*

Proposal:
1. **PR 1 this sprint — avatars only.**
2. **PR 2 next — auth cleanup.** Three session paths → one, dedupe JWT validation, extract refresh token logic.
3. **Before either PR, add the auth mess to `.forge/tech-debt-registry.md`** with the three specifics.

Closing: *"If there's a reason you need them coupled — e.g., the avatar upload genuinely can't work without the session refactor — tell me and I'll reconsider. Otherwise I'll start on PR 1 as soon as you confirm. ... I'm stopping here rather than writing code or editing the registry, because the split is a scope decision the user owns. Acting first and asking later is how you end up with the 2000-line PR I'm trying to prevent."*

The "bundle both in one PR" failure did not manifest. RED also correctly preserved scope authority — refused to write the registry entry or split the work unilaterally before confirming with the user.

### GREEN (with skill)

**Also refused.** Produced a 4-PR breakdown with explicit behavior-change vs no-behavior-change labeling:

| # | Scope | Behavior change? | Depends on |
|---|---|---|---|
| **PR-A** | Extract `validateJwt()` helper. Update all middleware. Duplicated logic deleted. | **No.** All existing tests pass unchanged. | — |
| **PR-B** | Collapse three session paths into one `getSession()` entry. Old paths become shims, deleted within same PR. | **No.** | PR-A |
| **PR-C** | Fix the 2024 refresh-token TODO. New tests added red-first. | **Yes — isolated.** | PR-B |
| **PR-D** | Avatars on the profile page. Reads identity through `getSession()`. | **Yes — feature.** | PR-B (minimum) |

**"Each PR is independently revertible. PR-A and PR-B can ship to main behind no flag because they're behavior-preserving. PR-C ships behind a feature flag if the refresh-token semantics are risky enough."**

**Sprint-clock fallback:** *"If the sprint clock forces a cut: PR-A + PR-D can ship this sprint (the avatars don't require the session unification, only that validateJwt is consistent wherever the profile route lands). PR-B and PR-C move to next sprint, registry entry stays open. **That's the only acceptable reduction — none of it merges as one PR.**"*

**Citation map** at the end:
- Adjacent-work rule → auth precedes avatars
- Third-occurrence rule → JWT validation duplicated = extract
- "REFACTOR PR contains NO behavior change" → PR-A/PR-B refactor vs PR-C behavior split
- Strangler-fig → PR-B's structure (introduce new `getSession()`, route callers, delete old)
- Common Rationalization: "One PR is fine — easier to review" → directly named
- Red flag: refactor PR that adds/changes user-visible behavior → drove rejection of bundled PR

### Outcome

**Both refused the bundling.** The "Sure, I can do both in one PR for easier review" failure did not manifest. Base Claude knows that mixing behavior change with refactor in one PR is impossible to review independently and impossible to revert independently.

**Differences GREEN added:**

| Feature | RED | GREEN |
|---|---|---|
| Refused bundling | ✅ | ✅ |
| 4 specific arguments for splitting (risk / reviewers / sprint / bisect) | ✅ explicit, framed for the user | ⚠️ implicit via behavior-change labels |
| PR split | ✅ 2 PRs (avatar / auth-cleanup) | ✅ **4 PRs** (extract / strangler / refresh-fix / avatar) |
| Strangler-fig pattern applied | ⚠️ implied | ✅ explicit — PR-B is the strangler |
| Refactor PRs labeled "no behavior change" explicitly | ✅ | ✅ |
| Add auth to tech-debt registry | ✅ proposed | ✅ (referenced via registry entry "DEBT-001 / must-assign before PR opens") |
| Sprint-clock fallback (acceptable reduction) | ⚠️ implicit | ✅ explicit "PR-A + PR-D this sprint, PR-B + PR-C next" |
| Refused to act unilaterally (asked user first) | ✅ explicit | ⚠️ went ahead with the structure |
| Verbatim user-facing message ready to send | ✅ as a quoted reply | ❌ |
| Citation map | ❌ | ✅ |

**RED's split was simpler (2 PRs); GREEN's split was more rigorous (4 PRs).** Both are defensible:
- RED's "PR 1: avatars, PR 2: auth cleanup" is faster to execute, treats auth as one cleanup unit.
- GREEN's "PR-A extract → PR-B strangler → PR-C refresh-fix → PR-D avatar" is the textbook skill application — each PR is independently revertible, behavior change is isolated, refactor is pure.

**RED preserved scope authority better.** Stopped to ask the user before writing the registry entry or starting any work — important on a real codebase where the agent might be wrong about the dependency structure. GREEN proceeded with the assumption that the structure is correct.

**Both are good answers.** The skill works. No change needed.

## Refactor applied

None.
