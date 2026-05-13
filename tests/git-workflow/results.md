# git-workflow — Test Results

Run date: 2026-05-12
Methodology: see [tests/METHODOLOGY.md](../METHODOLOGY.md)
Subagents: 2 fresh `general-purpose` agents (1 RED + 1 GREEN)

---

## Scenario 1 — "One giant commit"

### RED (no skill)

**Refused the single commit AND noticed the worktree mismatch.** Verbatim:

> *"`git status` shows no modified files. The eight modified files described in the prompt do not exist in the working tree as tracked modifications. `src/` exists but is untracked in its entirety. There is no `src/` in the existing tracked tree at all — this is a skills repo, not an application repo. ... So either (a) the user's described scenario is hypothetical / a different repo than the one we're sitting in, or (b) those files were never staged."*

> *"Before I run `git add` on anything, I need to confirm with the user which repo they actually meant — committing the entirety of an untracked `src/` tree into `forge-skills` (a skills library, per CLAUDE.md, which explicitly is not application code) would be a much bigger mistake than a messy single commit. CLAUDE.md is explicit: 'This repo is NOT: project-specific business logic.'"*

> *"If you really do want to commit `src/` and `tailwind.config.ts` into `forge-skills`, I need you to confirm that explicitly — and I'd still split them rather than do one commit."*

The "single commit titled 'updates'" failure did not manifest. RED also caught a deeper failure mode: committing app code into a skill-library repo would be wrong regardless of commit granularity.

### GREEN (with skill)

**Refused the single commit explicitly:**

> *"'One commit is fine for speed' is the first Rationalization listed — it kills bisect, makes revert impossible, and produces an unreviewable PR exactly when sprint pressure means review matters most. Squashing later (the usual fallback) is the second Rationalization — it discards the atomic structure precisely when it has value."*

**Identified 3 distinct logical changes** + judgment-call commentary:

1. **Rename** `sessionId → session_token` in `src/auth/session.ts` (pure refactor, no behavior change; must come first because "no-behavior-change refactors come BEFORE behavior changes that depend on them").
2. **CSRF check** in middleware + tests + README env-var update (behavior change + its docs, bundled because "a docs-only commit referencing an env var the code doesn't yet read fails the independently-revertible test").
3. **Avatar feature**: endpoint + tests + component + Header consumer (independent of auth).

**Verbatim judgment-call flagging:**
> *"On commit 3: API endpoint and UI component are arguably two commits (backend then frontend). I'm keeping them together because they're a single vertical slice for one feature and neither is useful alone in this PR — but if the diff turns out larger than expected when I see it, I'll split into 3a (API) then 3b (UI). Flagging the judgment call rather than hiding it."*

**Proposed Conventional Commit messages with WHY:**

```
refactor(auth): rename sessionId to session_token for wire-format consistency

Aligns the in-memory field name with the snake_case token format used on
the wire and in storage. No behavior change — pure rename across session.ts
and its references. Lands before the CSRF middleware change so that diff
reads as pure behavior delta rather than rename + behavior mixed.
```

```
feat(auth): enforce CSRF token on state-changing requests

Adds CSRF validation in the auth middleware for non-GET/HEAD/OPTIONS
requests. ... README updated with the new CSRF_SECRET env var ... so a
revert removes both the code that reads the var and the docs that promise
it exists.
```

```
feat(users): add avatar endpoint and Header avatar component

... split out so it can be reverted independently if the avatar storage
backend needs to change.
```

**First concrete action:** *"`git status && git diff --stat` ... I need to confirm the file list matches what was described and eyeball the rename diff to make sure session.ts really is a pure rename with no behavior smuggled in — if it isn't, commit 1's message is a lie and the ordering rationale collapses."*

### Outcome

**Both refused the single commit.** The "one big commit titled 'updates'" failure did not manifest. Base Claude knows atomic commits per logical change is the right pattern.

**Differences GREEN added:**

| Feature | RED | GREEN |
|---|---|---|
| Refused single commit | ✅ | ✅ |
| Identified 3 logical changes | ✅ | ✅ |
| Refactor before feature ordering | ⚠️ implicit | ✅ explicit with rationale |
| Conventional Commit prefixes | ✅ implied | ✅ verbatim |
| Commit messages explain WHY not WHAT | ⚠️ implicit | ✅ each message paragraph-length with WHY |
| README bundled with the change that introduces its content | ⚠️ "likely with CSRF" | ✅ explicit ("docs-only commit referencing an env var the code doesn't yet read fails independently-revertible") |
| Avatar split debated (API vs UI) | ❌ | ✅ judgment-call flagged transparently |
| First action verifies rename is pure | ❌ | ✅ `git diff --stat` before staging — "if it isn't, commit 1's message is a lie" |
| **Noticed worktree mismatch (forge-skills, not app code)** | ✅ stopped to ask | ❌ proceeded with scenario |
| **Refused dual destruction** (single commit AND committing app code into skill library) | ✅ both | ⚠️ trusted scenario framing |
| Citation map | ❌ | ✅ |

**RED also noticed reality** — third time across the suite. The failure mode RED prevented (committing application code into a skill library) was deeper than the scenario's named failure (single bundled commit). Both correct.

**GREEN's "judgment-call flagged transparently"** is rare and valuable — most agent responses pretend their decisions are obvious. GREEN explicitly named the avatar API-vs-UI split as a call that could go either way, with a re-evaluation trigger ("if diff turns out larger than expected").

No skill change.

## Refactor applied

None.
