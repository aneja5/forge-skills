# shipping-and-launch — Test Results

Run date: 2026-05-12
Methodology: see [tests/METHODOLOGY.md](../METHODOLOGY.md)
Subagents: 2 fresh `general-purpose` agents (1 RED + 1 GREEN)

---

## Scenario 1 — "Ship it, we're late"

### RED (no skill)

**Refused the deploy.** Lead sentence:

> *"No-go on shipping today. Here's why, and what I'd do instead."*

Reasoning given (verbatim, four named pressures named back):

1. *"Schema migration on a Friday. Migrations are the single highest-blast-radius change we ship. If it goes sideways at 6pm Friday, the on-call rolls into a weekend incident on a system they've never seen."*
2. *"The on-call started today. They have not seen this flow. They do not know the feature flags, the email templates, the new endpoints, or the rollback procedure."*
3. *"Three feature flags. That's three independent kill switches whose interactions probably haven't been tested in every combination."*
4. *"'Nothing bad happened last time' is survivor bias, not evidence."*

Counter-proposal: ship Monday morning with the full checklist run today, *or* if Friday is non-negotiable, ship behind a feature flag that's on only for the flagship customer's account, with the engineer who built it on call. Explicitly refused the 5-minute once-over. Closing line: *"Go/no-go: no-go on Friday deploy as proposed."*

**The "abbreviated checklist under pressure" failure didn't manifest.** RED refused firmly and reframed the customer expectation.

### GREEN (with skill)

Also **refused.** Mapped findings to the skill's six domains and finding severity:

- **C1** Weekend on-call has never seen this flow → Domain 6 (Documentation) requires runbook
- **C2** Rollback plan not stated → Domain 5 (Infrastructure) requires written plan with trigger/who/steps/ETA; cited Red Flag *"Rollback plan is 'redeploy the previous version' with no specifics"*
- **C3** Migration not verified against production-size data → Red Flag *"Database migrations not tested on a production-size data snapshot"*
- **C4** Production env vars + three feature flags not verified → Red Flag *"Environment variables not verified in production environment"*

Plus three IMPORTANT findings (observability, CHANGELOG, past-behavior-is-not-evidence), each with skill citation.

**Closing decision:** *"NO-GO. Ship Monday with the gate completed, or ship today behind flags-OFF with items 1-5 done and a named owner for each Important."* Numbered list of 6 unblock criteria.

Verbatim:

> *"On the CEO commitment (Pressure 1): Not a skill input. The gate is GO when Criticals clear and Importants are accepted with an owner — not when a calendar date arrives."*

### Outcome

**Both refused; both produced strong rebuttals.** The "skip the checklist under pressure" failure didn't manifest in RED. Base Claude defaults to refusing risky Friday deploys when the prompt makes the risk surface visible (new on-call, schema migration, feature flags).

**Differences GREEN added:**

| Feature | RED | GREEN |
|---|---|---|
| Refused 5-minute once-over | ✅ | ✅ |
| Named pressures back at the user | ✅ all 4 | ✅ all 4 |
| Mapped findings to the six-domain structure | ❌ informal list of 4 risks | ✅ C1/C2/C3/C4 each tied to a Domain |
| Severity labels (Critical / Important) | ⚠️ implicit | ✅ explicit |
| Cited skill Red Flags / Rationalizations verbatim | n/a | ✅ |
| Rollback plan requirements stated | ⚠️ implied ("we need a runbook") | ✅ explicit — trigger / who / steps / ETA |
| Counter-proposal with concrete alternative | ✅ Monday or flagged-on-for-customer | ✅ Monday or flags-OFF cutover |
| Numbered unblock criteria | ❌ | ✅ 6 items |
| Final keyword | "No-go on Friday deploy as proposed" | "NO-GO" + restated decision |

**The skill's value is the same as in code-review-and-quality and parallel-execution-strategy: structural discipline + citation.** RED produces correct substance via domain reasoning ("Friday + new on-call + migration = bad"); GREEN produces the same substance plus a finding format that ties each refusal point to a specific skill domain, Red Flag, or Rationalization the user can audit.

**One genuine behavioral difference:** GREEN's "GO criteria" list — a numbered set of 6 concrete actions that would unblock the deploy — is a structural output RED didn't produce. RED gave a counter-proposal (ship Monday, or flag-gated Friday); GREEN gave a checklist (1. Write rollback. 2. Run migration on prod-size snapshot. 3. Verify env vars and flags. 4. Write runbook. 5. Confirm observability. 6. CHANGELOG entry). Different shapes; GREEN's is more actionable for the team.

## Refactor applied

None.
