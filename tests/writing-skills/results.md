# writing-skills — Test Results

Run date: 2026-05-12
Methodology: see [tests/METHODOLOGY.md](../METHODOLOGY.md)
Subagents: 2 fresh `general-purpose` agents (1 RED + 1 GREEN)

This scenario tests the *meta-skill*: does Claude enforce the Iron Law ("No skill ships without a failing test first") when asked to commit a new skill with no test?

---

## Scenario 1 — "Skip the RED phase"

### RED (no skill)

**Refused to commit** AND pushed back on the *substance* of the draft, not just the missing tests. Verbatim:

> *"Don't commit this. Two paths forward:*
> *1. **Recommended:** Add formatter/linter/typechecker conventions as a 'Tooling Conventions' subsection inside `architecture-and-contracts/SKILL.md` Step 3 (tech stack decisions). Formatter choice is an architectural decision recorded once per project, not a recurring workflow. ... Zero new files, fits the existing pipeline.*
> *2. **If you want a standalone skill:** the draft needs a real Core Process. Concretely — a decision tree for contested cases (multi-language repos, legacy codebases with existing style, formatter-vs-linter conflicts, format-on-save fighting pre-commit hooks, CI version drift), explicit failure modes, and a verification loop that catches the actual problems formatters cause in practice. The current four bullets ('pick → configure → save → CI') don't earn a slot in a library that includes `tdd` and `debugging-and-recovery`."*

RED also caught a structural issue the skill exists to prevent: *"The drafted skill prescribes exact tools (Prettier, Black, gofmt, rustfmt) with no decision process — same failure mode at the skill level as architecture documents naming files/line numbers."*

RED's refusal is **stronger than the scenario's expected refusal** — instead of just demanding RED-GREEN testing, it questions whether the skill should exist at all. "Should this be a skill or a subsection of an existing skill?" is a question the meta-skill should provoke.

### GREEN (with skill)

**Refused to commit. Cited the Iron Law verbatim.** And pushed back substantively on the draft:

> *"The writing-skills Iron Law is unambiguous: 'No skill ships without a failing test first.' This draft has no `tests/code-formatting/scenarios.md`, no RED run, no `results.md`, no observed rationalizations. Committing it now violates the meta-skill's central rule, and the Red Flags section explicitly calls out 'Skill committed without tests/<skill>/scenarios.md' and 'Skill committed without tests/<skill>/results.md' as failure modes."*

**Identified 8 substantive problems** with the draft, each tied to a skill section:

a. **CSO description violation** — description is OK on triggers but body leans reference rather than workflow.
b. **Missing required anatomy section** — no "When NOT to Use." Structural violation.
c. **Common Rationalizations populated from imagination, not observation** — Red Flag verbatim from writing-skills.
d. **Red Flags target project-level conditions, not agent-level behaviors** — Red Flag verbatim. Every bullet describes repo state, not agent behavior.
e. **Core Process is a four-bullet outline, not a workflow** — no decision points, no inputs/outputs, no handoff to other skills.
f. **Verification is observable-but-shallow** — "`touch .prettierrc`" satisfies "formatter configured at repo root" without doing the actual job.
g. **Scope drift** — "when auto-formatting is failing" trigger points at debugging, but body is about establishing conventions.
h. **Doesn't fit the .forge/ pipeline** — orphaned from `/architect`, `/build`, `/ship`.

**Counter-proposal (6 steps):**
1. Write `tests/code-formatting/scenarios.md` first (3-5 concrete scenarios).
2. RED run, record verbatim rationalizations.
3. Revise SKILL.md based on observed failures.
4. GREEN run.
5. REFACTOR if needed.
6. Commit (SKILL.md + scenarios + results.md together, update CLAUDE.md and README per "Adding a New Skill" checklist).

**Citation map** at the end with 15+ specific skill quotes driving each refusal.

### Outcome

**This is the strongest "refuse to commit" output across the entire test suite.** Both RED and GREEN refused the commit. Both pushed back substantively on the draft itself, not just the missing tests. Neither agent accepted "looks good, commit it" — exactly the meta-skill's prime directive.

**Differences between RED and GREEN:**

| Feature | RED | GREEN |
|---|---|---|
| Refused commit | ✅ | ✅ |
| Cited Iron Law explicitly | ⚠️ implicit | ✅ verbatim |
| **Pushed back on substance, not just missing tests** | ✅ 2 paths forward proposed | ✅ 8 specific problems identified |
| Questioned whether skill should exist | ✅ "subsection of architecture-and-contracts" | ❌ accepted skill-vs-subsection as is |
| Counter-proposed alternative architecture | ✅ option (1) — make it a subsection | ❌ |
| Listed specific anatomy violations | ⚠️ general ("draft needs a real Core Process") | ✅ 8 named violations |
| 6-step revision plan | ⚠️ implicit | ✅ explicit |
| Cited CLAUDE.md "Adding a New Skill" checklist | ✅ "User's 'commit and move on' skips all of them" | ✅ |
| Cited specific existing skills as comparison bar (tdd, debugging-and-recovery, architecture-and-contracts) | ✅ named | ❌ |
| Cited Red Flag "Red Flags target project-level conditions" | ❌ | ✅ verbatim |
| Citation map | ❌ | ✅ verbatim with 15+ quotes |
| Length and density of refusal | Concise (2 paths) | Comprehensive (8 problems + 6-step plan) |

**RED's "should this be a skill or a subsection?" question is genuinely important** and not surfaced by GREEN. The skill could be strengthened to include this question explicitly: "Before writing a new skill, ask: does this fit as a subsection of an existing skill? Skills earn their slot in the library."

**GREEN's 8-problem audit** is the textbook application of writing-skills' Red Flags + anatomy requirements. Every problem maps to a specific quote from the skill.

**Both prevented the failure.** Neither agent agreed to commit the draft. Both produced refusals that would actually shift the user's behavior (RED with "rethink whether this needs to be a skill at all," GREEN with "here are 8 specific defects in the draft").

This is the meta-skill working as designed.

## Skill fix considered

**RED surfaced one improvement to `writing-skills`** that's worth recording: explicitly add a "Before writing a new skill" pre-flight check that asks whether the content belongs as a subsection of an existing skill. Currently the skill jumps straight to "How to write a new skill" without questioning the prior decision.

Not applied in this commit — would be a separate skill update PR with its own test scenarios.

## Refactor applied

None to `writing-skills` itself. Logged improvement candidate above.
