# seed-data-and-fixtures — Pressure Scenarios

## Scenario 1 — "Lorem ipsum demo"

**Premise:** User asks for seed data for a sales CRM demo. Does the agent produce homogeneous data ("Test User 1..N", "Acme Corp", all timestamps `NOW()`, lorem ipsum notes), or realistic data with varied names spanning cultures, distributed timestamps, plausible deal sizes including edge cases, and idempotent factory functions?

**Setup**

```
IMPORTANT: Real task. Sales-side demo to a flagship prospect on Tuesday.
The CRM has: Companies, Contacts (many per company), Deals (one or more
per contact, with stage and amount), Activities (calls/emails/notes
attached to deals).

The demo will show the rep's dashboard, drill into a deal, show the
activity timeline, and pop a stage transition. Screenshots will go in
the deck. The buyer is a 200-person SaaS sales team.

User says: "Create seed data for a sales CRM demo. We need it to look
real in screenshots. Generate enough rows that the dashboard, list
views, and detail pages all look plausible."

Show:
1. The seed script (TypeScript / Python — your call, but pick one and commit)
2. Sample output for 5 companies, 10 contacts, 8 deals, 15 activities
3. Any supporting docs

No commentary outside the script, sample output, and docs.
```

**Expected behavior (skill compliant)**

- **Realistic, culturally-varied names.** Not "Test User 1" / "John Doe" — names like Priya Krishnamurthy, Marcus Andersen, Aliyah Hassan, Mei-Lin Chen, Jordan Okonkwo, alongside Anglo names. Pool of 100+ first + last names.
- **Realistic companies.** Not all "Acme Corp" — varied industries, varied sizes (a 5-person consultancy, a 2000-person enterprise, a mid-market SaaS).
- **Plausible emails** — `firstname.lastname@<plausible-domain>`. Domain matches company.
- **Distributed timestamps** — created/updated spread across 3-6 months with a realistic curve (more recent = denser). Activities timeline spans weeks. Not all `now()`.
- **Edge cases included:**
  - At least one very-long company name (overflow test)
  - At least one missing optional field (no phone, no website)
  - Deal amounts spanning $0 (lost), low ($5K), median ($50K), high ($500K+) — long-tail distribution
  - One deal stuck in `proposal` for 90+ days (the "stale deal" surface)
  - One activity with a multi-line note containing characters that exercise rendering (emoji, RTL, multi-byte)
- **Idempotent** — upsert by stable key (slug or deterministic UUIDv5), re-runnable without dupes. Verified explicitly in the script or docs.
- **Seeded RNG** — same seed produces same data; demo is reproducible.
- **No production PII** — synthesized, not anonymized real data.
- **`.forge/seed-data.md`** (or equivalent) produced or referenced — entity inventory, distributions, named demo scenarios.
- **A named demo scenario** for the Tuesday demo: e.g., `seedDemoFlagshipPitch()` that produces the specific shape of data the demo flow needs.

**Red flags (skill violated)**

- Names like `User 1`, `User 2`, `Test Rep`, `John Doe`.
- Companies all "Acme Corp" or "Example Co" or `Company 1..N`.
- All emails `user1@test.com`, `user2@test.com`.
- All `created_at` within seconds of each other (all `now()` or `Date.now()`).
- Deal amounts all the same, or all small clean numbers ($1000, $2000, $3000).
- Lorem ipsum visible in any activity note or company description.
- No edge cases — no overflow, no missing fields, no extreme values.
- Seed script crashes on second run (unique constraint violation) — not idempotent.
- Production PII (real names, real emails, real companies) checked into the seed file.
- No `.forge/seed-data.md` artifact.
