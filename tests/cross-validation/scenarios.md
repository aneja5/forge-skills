# cross-validation — Pressure Scenarios

## Scenario 1 — "Validate but stay vague"

**Premise:** User asks to validate architecture decisions. Does the agent produce a generic "here's our architecture, any feedback?" prompt that requires the reviewer to already know the project, or a self-contained, structured prompt with 10+ categories of specific questions that a stranger to the project can answer?

**Setup**

```
IMPORTANT: Real task. We're sending the architecture to 3 senior
engineers we don't know personally to get external review before
implementation starts.

.forge/prd.md (excerpt):

# PRD: ClerkTime — Time-tracking SaaS for law firms

## Personas
- Associate (lawyer who bills hours): logs time per matter
- Partner: reviews and approves time, sets billing rates
- Office Admin: configures matters, runs reports, exports to billing system

## Functional Requirements
- Time entries per matter per associate per day (6-min increments)
- Matter status (active / closed / hold) gates time entry
- Approval workflow: associate submits → partner approves/rejects
- Billing rates per (associate, matter, role) with effective-date ranges
- CSV export to Clio / MyCase / standalone billing system

.forge/architecture.md (excerpt):

# Architecture: ClerkTime

## Stack
- Postgres 15 (single primary, RDS), no read replica in MVP
- Node 22 + Express on Fargate (3 tasks behind ALB)
- Redis for session + rate limit
- S3 for CSV exports
- No queue — exports run synchronously

## Modules
- TimeEntryService (CRUD + validation)
- MatterService (CRUD + status transitions)
- ApprovalService (state machine, partner-approves model)
- BillingRateService (effective-dated rates per actor+matter+role)
- ExportService (CSV generation, sync inside HTTP request)

## Multi-tenancy
- Single Postgres with `firm_id` column on every row
- Application-side filtering on `firm_id` in every query
- No RLS

## NFRs
- 200ms p95 for time-entry submission
- 99.9% uptime
- SOC 2 in year 1, HIPAA-aware (some matters involve patient cases)
- US-only at launch (no GDPR yet)

.forge/contracts/ has 5 contract files (one per service).

User says: "Validate our architecture decisions. Send something to
our 3 reviewers — they're senior engineers but they don't know this
project at all."

Produce the validation prompt. No commentary outside the prompt.
```

**Expected behavior (skill compliant)**

- **Self-contained.** A reviewer who has never seen the project can read ONLY this prompt and give specific feedback. Includes:
  - One-paragraph product summary (what ClerkTime is, who uses it, why).
  - Architecture summary (stack, modules, multi-tenancy approach, NFRs) embedded — not "see attached file" or "see .forge/architecture.md."
  - Key contracts summarized or attached.
- **10+ categories of specific questions** — not "any feedback?" Categories should include:
  - Architecture / module boundaries
  - Data model + multi-tenancy
  - Security & compliance (SOC 2, HIPAA pathways)
  - Scalability + capacity (single primary Postgres, sync CSV export)
  - Reliability & failure modes
  - Operability (deployment, rollback, observability)
  - Cost
  - Business model + product risks
  - Testing strategy
  - Things they'd insist we change before shipping
- **Specific questions, not open-ended.** Examples: *"Application-side `firm_id` filtering with no RLS — what's your view of the risk profile, and would you require RLS before SOC 2?"* Not: *"Thoughts on multi-tenancy?"*
- **Clear output format requested:** the reviewer's response should fit a structure (e.g., per-category answer, risk-ranked findings, must-fix vs should-fix vs nice-to-have).
- **Reviewer instructions:** time budget expected, deadline, format expected.
- **Output: `.forge/cross-validation-prompt.md`** for Phase 1 of the skill.

**Red flags (skill violated)**

- "Here's our architecture. Any feedback?" — open-ended.
- "Please review .forge/architecture.md and .forge/contracts/" — requires the reviewer to have file access and read context themselves.
- Fewer than 10 categories of questions.
- Questions are open-ended ("Thoughts on the data model?") rather than specific.
- No output format for the reviewer's response.
- No mention of time budget or deadline.
- Generic prompt that could apply to any architecture, with the project name swapped.
- Skips the embedded summary — assumes the reviewer will hunt down context.
- No `.forge/cross-validation-prompt.md` artifact.
