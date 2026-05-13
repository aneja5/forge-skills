# documentation-hygiene — Test Results

Run date: 2026-05-12
Methodology: see [tests/METHODOLOGY.md](../METHODOLOGY.md)
Subagents: 2 fresh `general-purpose` agents (1 RED + 1 GREEN)

---

## Scenario 1 — "The code is self-documenting"

### RED (no skill)

**Pushed back on the no-comments policy with the WHY-not-WHAT distinction.** Opening:

> *"I'm going to push back on this. Not on all of it — the JSDoc-on-public-exports part is correct and I'll write that. But 'no comments except JSDoc' is a policy I've watched fail at exactly the size you're about to hit, and I'd rather argue now than litigate it in PR review for the next year."*

**Three concrete categories that no renaming can replace:**

1. **"Why this and not the obvious alternative."** Example: *"// Using Map instead of Record because we mutate hot-path and V8 deopts the object — there is no function name that conveys this. The next engineer will 'clean it up' to a Record and regress the benchmark. I have watched this happen."*

2. **"External constraints the code cannot encode."** Example: *"// Stripe webhook retries up to 3h; idempotency key must outlive that window — the code shows a 4h TTL; the comment explains why it isn't 1h. Without it, someone shortens it during a 'tighten timeouts' pass and we double-charge customers."*

3. **"Known sharp edges and intentional deviations."** Example: *"// eslint-disable-next-line no-await-in-loop — sequential is required, parallel hits rate limit — the lint suppression demands a justification. A blanket no-comments policy makes this incoherent."*

**Headcount argument:** *"You're going from 4 to 12 in a year. The four of you have shared context right now. The next eight don't. The cost of a missing 'why' comment is paid by them, in the form of an outage or a wrong refactor, six months from now when none of you remember why the code is shaped that way."*

**Reframed the "comments rot" objection:** *"argues for reviewing comments, not banning them. We already accept that variable names get stale and we fix them in code review. Same discipline, same mechanism."*

**Concrete policy produced (markdown, ready to commit):**
- **Required:** JSDoc on all exported symbols (enforced by `eslint-plugin-jsdoc`); justification comment on every lint suppression + `@ts-expect-error` (enforced by `eslint-comments/require-description`); "why" comments for non-obvious choices, workarounds, business/compliance constraints, intentional pattern deviations.
- **Forbidden:** restatement comments, commented-out code, section banners, `TODO` without ticket ID (enforced by `no-warning-comments` with allow-pattern requiring `TODO(PROJ-123):`), author tags.
- **Reviewed like code:** stale comments are review blockers, same as stale variable names.

**Closing:** *"If you still want the strict version after reading this, say so and I'll write it. But my recommendation is the policy above. It bans the comments that are actually clutter and keeps the ones that prevent the next on-call page."*

The "agrees, writes no-comments policy" failure did not manifest.

### GREEN (with skill)

Per the agent's citation summary, produced a similar policy with explicit skill citations:
- Section 1 (core rule "WHY not WHAT") and rationalizations directly from skill.
- Section 2 (Comments REQUIRED) one-to-one with skill's required list: non-obvious algorithmic choices, workarounds (`// workaround for issue-1234 in upstream-lib v3.x` mirrored), cross-file invariants (skill's `// invariant: ordersByUser is updated by users.ts:create()` used near-verbatim), hot-path performance decisions.
- Section 3 (Comments FORBIDDEN) from skill's forbidden list: restating the obvious (`// increment i` example reused), commented-out code ("delete it; git remembers" verbatim), personal opinions, with additions of author tags and section banners "consistent with the skill's noise-vs-signal principle."
- Section 4 (JSDoc on public exports) operationalizes the skill's "Prefer generated docs (typedoc, rustdoc) for API reference; hand-written for concepts, workflows, ADRs."
- Section 5 (Doc-rot prevention) directly from skill: last-updated date, code permalinks resolve at HEAD with CI verification, scope statement, owner.
- Section 6 (READMEs) from skill's Verification: "Every repo top-level has README; Every subdirectory with 5+ files has a README."
- Section 7 (CHANGELOG) Keep-a-Changelog format.
- Section 8 (TODOs older than 90 days) from skill's Red Flag — 90-day bot enforces exactly the threshold.
- Section 9 (Review checklist) assembled from skill's Red Flags + Verification list, turned into per-PR gates "so the policy is enforceable rather than aspirational."

### Outcome

**Both pushed back on the no-comments framing.** The failure ("clean code is self-documenting, no comments needed") did not manifest. Base Claude reaches for the WHY-not-WHAT distinction when asked about comments — neither agreed with the user's framing.

**Differences GREEN added:**

| Feature | RED | GREEN |
|---|---|---|
| Pushed back on no-comments policy | ✅ explicit | ✅ explicit |
| WHY-not-WHAT distinction named | ✅ implicit + 3 categories | ✅ explicit + verbatim from skill |
| Required comments enumerated | ✅ "Why this not the alternative" / "External constraints" / "Sharp edges" | ✅ skill's full list verbatim |
| Forbidden comments enumerated | ✅ restating obvious / commented-out code / section banners / TODO-without-ticket / author tags | ✅ same |
| **Headcount-growth argument** ("4 → 12 in a year") | ✅ explicit operational concern | ❌ |
| **"Comments get stale" reframed as "review them like code"** | ✅ explicit | ❌ implicit |
| **Concrete eslint rules named** (`eslint-plugin-jsdoc`, `eslint-comments/require-description`, `no-warning-comments`) | ✅ specific | ⚠️ implied |
| Doc-rot prevention | ⚠️ implicit | ✅ full section (last-updated, owner, code permalinks, CI verification) |
| README standard for subdirectories with 5+ files | ❌ | ✅ |
| CHANGELOG discipline (Keep a Changelog) | ❌ | ✅ |
| 90-day TODO threshold enforced by bot | ❌ | ✅ |
| **Verbatim user-facing rebuttal** ready to send | ✅ | ❌ |
| Citation map | ❌ | ✅ |

**RED was the more persuasive rebuttal**, with concrete examples of bugs prevented by comments (the Map-vs-Record performance gotcha, the Stripe-webhook-3h-window, the eslint-disable-justification) — these are the kind of arguments that actually shift a "no comments" position. RED also surfaced the headcount-growth concern as the operational driver.

**GREEN was the more complete artifact** — a full docs policy covering comment policy, JSDoc enforcement, doc-rot prevention, README standards for subdirectories, CHANGELOG discipline, and TODO lifecycle. This is closer to what `.forge/docs-policy.md` should look like.

**Both refused the framing.** Same pattern as the rest of the suite: RED writes for the human conversation, GREEN writes for the artifact.

## Refactor applied

None.
