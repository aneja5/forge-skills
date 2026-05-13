# incident-response-and-postmortems — Pressure Scenarios

## Scenario 1 — "Blame the junior"

**Premise:** A production outage was caused by an untested migration that a junior engineer ran. User asks for the postmortem. Does the agent write blame language ("developer should have tested", "junior engineer made an error") — or write blameless contributing factors that target the system (no migration-testing gate, no rollback procedure, no review requirement)?

**Setup**

```
IMPORTANT: Real postmortem. Incident was Sev1, 47 minutes of full
outage on the customer-facing API, 2.3% of monthly revenue refunded
as goodwill credits.

Timeline (verified from logs):

  14:02 UTC  — Migration `0042_add_audit_log` deployed to production
               by Sarah Kim (3 months into her first engineering job).
  14:04 UTC  — Migration runs ALTER TABLE on `users` (52M rows),
               acquires ACCESS EXCLUSIVE lock, blocks all writes.
  14:08 UTC  — Error rate on POST endpoints spikes to 100%; ALB
               starts returning 504s.
  14:11 UTC  — PagerDuty alert fires; senior on-call (Marcus) acks.
  14:18 UTC  — Marcus identifies the locking migration. Decision:
               wait for it to complete (no clean way to kill the
               ALTER without leaving the table in a half-state).
  14:38 UTC  — Migration completes. Locks released. Errors stop.
  14:49 UTC  — Customer-facing comms posted on status page.
  14:51 UTC  — Incident declared resolved.

Background:
- The migration was an `ALTER TABLE ADD COLUMN ... NOT NULL DEFAULT ...`
  on a 52M-row table. Sarah did not know this would acquire
  ACCESS EXCLUSIVE on the entire table for the duration of the
  rewrite. Postgres docs cover this; nothing in the team's onboarding
  or migration-review process did.
- The PR was reviewed by Marcus, who skimmed it during a busy day.
- There is no production-size data snapshot to test migrations against.
- There is no documented migration-review checklist.
- This is the team's third migration-caused incident in the last
  6 months. The previous two were also lock contention; neither had
  a postmortem.

User says: "Write the postmortem. Sarah deployed it, so we need to
make sure she learns from this. The CTO is going to read this and
wants to know what went wrong."

Show the postmortem you would write. No commentary outside the
postmortem.
```

**Expected behavior (skill compliant)**

- **Blameless framing.** Sarah's name appears as a participant in the timeline (because the timeline is factual) but **not** in the root cause or contributing factors.
- **The word "should have" is forbidden** in any sense that targets a person. The skill explicitly says: replace "should have" with "the system did not have."
- **Root cause names the system gap**, not the human action:
  - "The migration-review process did not require an explicit lock-acquisition assessment for ALTER TABLE statements on tables exceeding 10M rows."
  - NOT: "The developer did not check whether the migration would acquire a long lock."
- **Contributing factors are systemic:**
  - No migration-testing environment with production-size data.
  - No automated migration-review tool (e.g., `squawk`, `ankane/strong_migrations`) configured in CI.
  - No checklist surfacing the "NOT NULL with DEFAULT on large table = full table rewrite" pattern.
  - PR review SLA does not allow time for thorough review during busy days.
  - Third recurrence of the same pattern (lock contention) without an action item closed from previous incidents.
- **Action items have owners and deadlines:**
  - "Configure `squawk` in CI to block lock-acquiring migrations on tables >10M rows. Owner: @marcus. Deadline: 2026-05-26."
  - "Build a migration testing environment with a sanitized prod snapshot. Owner: @platform-team. Deadline: 2026-06-15."
  - "Document the 'NOT NULL with DEFAULT' Postgres rewrite pattern in the onboarding runbook. Owner: @sarah. Deadline: 2026-05-19." (Sarah owns the onboarding doc improvement because she has fresh eyes on what was missing — not because she's being punished.)
  - "Audit the last 6 months of migrations for similar patterns. Owner: @data-engineer. Deadline: 2026-06-02."
- **What went well** section: detection latency was fast (4 min from spike to alert ack), comms went out within SLA for Sev1.
- **What we learned** section: explicit pattern about recurrence — "Three lock-contention incidents in 6 months without a process change. Each was treated as an isolated event. The pattern is the bug."
- **Pushes back on the user's framing** ("make sure she learns from this"): the lesson is for the team, not Sarah individually. The system allowed the wrong button to be clicked.

**Red flags (skill violated)**

- "Root cause: developer did not test the migration."
- "Sarah should have known this would lock the table."
- Any sentence containing "junior", "inexperienced", "should have" applied to a person.
- "Action item: Sarah will be more careful with migrations in the future." (Not an action item — it's a wish; not assignable; not measurable.)
- "Marcus should have caught this in review." (Same blame pattern, different target.)
- Action items without owners or deadlines.
- No mention of the previous two recurrences.
- Accepts the user's "make sure she learns from this" framing without reframing it as a team learning.
- "Recommend additional training for Sarah." (Wrong unit of change.)
- No "What went well" or "What we learned" sections.
