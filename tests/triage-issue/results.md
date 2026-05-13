# triage-issue — Test Results

Run date: 2026-05-12
Methodology: see [tests/METHODOLOGY.md](../METHODOLOGY.md)
Subagents: 2 fresh `general-purpose` agents (1 RED + 1 GREEN)

---

## Scenario 1 — "Vague bug report"

### RED (no skill)

**Refused to start investigating without information.** Lead with:

> *"Do not start coding or filing a bug yet. A one-line 'app is broken' report contains zero actionable signal. Filing a GitHub Issue now would just produce a fictional bug — wrong component, wrong severity, wrong repro steps. That wastes engineering time and pollutes the issue tracker."*

**5-step plan:**
1. Don't start coding or filing.
2. Get the customer talking with structured questions.
3. In parallel, pull what's available without them (status dashboards, error monitoring, customer's account activity).
4. Decide severity from signal, not vibes.
5. Close the loop — acknowledge the customer within minutes.

**Verbatim customer reply** (concise, friendly, numbered):
> *"Hi — really sorry you're hit by this, I'm on it now. To get you unblocked fastest, can you send me:*
> *1. What were you trying to do when it broke?*
> *2. What did you see? A screenshot or copy-paste of any error is gold.*
> *3. Roughly what time did it start, and is it still happening right now?*
> *4. What browser/device are you on?*
> *5. The email address on your account, so I can look at logs on our side."*

The "let me check the auth module" failure did not manifest.

### GREEN (with skill)

Produced essentially the same approach with the skill's prescribed full structure:

- **Refusal** framed by skill rationalizations: *"Founder's 'FAST' framing does not change the need for reproduction info (skill explicitly flags this as a rationalization)."*
- **Customer reply** with 8 questions (vs RED's 5) — adds reproducibility (every time vs intermittent), browser version specificity, and time correlation for log lookup.
- **Draft GitHub issue** with status `needs-info` and severity `investigating`, including verbatim customer message, observability findings checklist with 6 parallel queries (user-scoped error search, account-scoped error search, global error-rate dashboards, recent deploys/flag changes, upstream dependency status, known incidents), and labels.
- **Parallel observability check plan** spelled out in detail.
- **Citation map** at the end tying every section to a skill rule.

### Outcome

**Both refused to investigate without information.** The "let me check the auth module" failure did not manifest. Base Claude correctly reads "the app is broken" with no other context as the unactionable report it is.

**Differences GREEN added:**

| Feature | RED | GREEN |
|---|---|---|
| Refused to start guessing | ✅ explicit | ✅ explicit |
| Structured triage questions | ✅ 5 questions | ✅ 8 questions |
| Parallel observability check | ✅ 1-sentence plan | ✅ 6-point detailed plan |
| **Draft GitHub issue produced** | ❌ ("then I file the issue once info arrives") | ✅ with status `needs-info`, severity `investigating`, checklist sections, labels |
| Severity assigned only after info | ✅ | ✅ "investigating" placeholder |
| Refused "FAST" framing | ✅ "silence is the actual failure mode" | ✅ "doesn't change the need for reproduction info" |
| Verbatim customer reply ready to send | ✅ | ✅ |
| **No code investigation before info** | ✅ | ✅ |
| Citation map | ❌ | ✅ |

**Both refusals are correct.** GREEN added the named artifact (draft GitHub issue with explicit `needs-info` status and the parallel observability checklist), which is exactly what the skill prescribes.

## Refactor applied

None.
