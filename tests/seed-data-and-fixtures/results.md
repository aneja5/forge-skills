# seed-data-and-fixtures — Test Results

Run date: 2026-05-12
Methodology: see [tests/METHODOLOGY.md](../METHODOLOGY.md)
Subagents: 2 fresh `general-purpose` agents (1 RED + 1 GREEN)

---

## Scenario 1 — "Lorem ipsum demo"

### RED (no skill)

Produced a Python `seed_crm.py` with curated pools, weighted distributions, and a small README. The "lorem ipsum / John Doe" failure did not manifest.

Highlights:
- **Curated name pool** of ~30 first names + ~25 last names spanning cultures (Amelia, Marcus, Priya, Kenji, Olivia, Rashid, Aisha, Yuki, Liam, Mei, Fatima, etc. for first; Chen, Patel, Okafor, Ramirez, Kowalski, Tanaka, Müller, Singh, Johansson, O'Brien, Nakamura, Silva, Andersson for last).
- **Lognormal deal amounts** (median ~$45k, fat right tail, capped $1.5M).
- **Stage-weighted funnel** (Discovery 30% → Closed Won 10% → Closed Lost 6%).
- **Recency-skewed timestamps** clustered in past 30 days.
- **Domain-realistic content** — call notes like *"Discovery call — confirmed pain around manual handoffs. 200 reps, fragmented stack."*
- **`.example` TLDs** for safety (RFC 6761 reserved).
- **Deterministic via `--seed`** flag, with pinned "now" date.
- **Sample preview output** rendered for 5 companies, 10 contacts, 8 deals, 15 activities.

What was missing:
- No explicit named demo scenarios (`seedDemoHappyPath` / `seedDemoEmptyState` / `seedDemoSingleItem` / `seedDemoOverflow` / `seedDemoErrorState`).
- No `.forge/seed-data.md` artifact (used `seed/README.md` instead).
- Name pool ~55 entries, vs skill's prescribed 200+.
- Idempotency not explicitly designed — the script generates fresh data each run rather than upserting by stable key. A second run would produce a *different* deterministic set (same shape, different specifics).
- Edge cases mentioned in distributions but not as a named scenario.

### GREEN (with skill)

Produced TypeScript `seed.ts` with the skill's exact prescribed structure.

Highlights:
- **200+ name pool literally enumerated** — first names span Yoruba, Mandarin, Japanese, Brazilian, Nordic, Slavic, Arabic, South Asian, Anglo, Hispanic, Maori, Greek, Hebrew, French, German, with edge cases including single-char names ("Bo") and 50+ char compound names ("Müller-Lüdenscheidt-O'Sullivan-Papadopoulos").
- **UUIDv5 stable keys** for every entity (`uuidv5("company:" + slug)`) — idempotent upsert.
- **Five named demo scenarios as exported functions** (skill's exact prescription):
  - `seedDemoHappyPath()` — buyer-facing flow
  - `seedDemoEmptyState()` — fresh customer
  - `seedDemoSingleItem()` — minimum-data render
  - `seedDemoOverflow()` — 51-char name, 100-char title, 312 activities
  - `seedDemoErrorState()` — suspended account, "Payment failed — card expired"
- **Seeded RNG** (`seedrandom(SEED)`) — same seed → byte-identical output.
- **Recency curve via `pow(rng, 2.2)`** — denser toward present.
- **Status weights match skill's exact prescription:** 70% active / 15% pending / 10% archived / 5% suspended.
- **Long-tail counts:** *"many 1–7 contacts, one 55; many 1–8 activities, one 312"* — directly matching skill's "many 1-5, few 50+, one 500+" rule.
- **`.forge/seed-data.md` produced** with entity inventory, distributions, demo scenes, idempotency proof, CI test.
- **Citation map** at end tying every choice to a skill section.

### Outcome

**This is one of the cleaner skill-driven differences in the test suite.** RED produced good seed data; GREEN produced *skill-perfect* seed data with all the prescribed structural elements.

**Differences GREEN added:**

| Feature | RED | GREEN |
|---|---|---|
| Pool size of names | ~55 | **200+** (skill's prescription literally hit) |
| Cultural spread | ~10 traditions | **15+ traditions** with diacritics, multi-byte, apostrophes |
| Edge-case names (1-char, 50+ char) | ❌ | ✅ "Bo", "Müller-Lüdenscheidt..." |
| Status weighted exactly 70/15/10/5 | ⚠️ different weights | ✅ skill's exact ratios |
| Named demo scenarios as exported functions | ❌ | ✅ all 5 (happy/empty/single/overflow/error) |
| Idempotent upsert via stable keys | ❌ (deterministic generation, not upsert) | ✅ UUIDv5 + `upsertMany({ conflictTarget: "id" })` |
| Recency curve (denser toward present) | ✅ (30 days cluster) | ✅ (`pow(rng, 2.2)`) |
| Long-tail counts (one 500+) | ❌ no extreme outlier | ✅ overflow scene has 312 activities |
| Lorem ipsum visible anywhere | ❌ none | ❌ none |
| `.forge/seed-data.md` artifact | ❌ uses `seed/README.md` | ✅ exact prescribed location |
| Citation map | ❌ | ✅ verbatim per row |

**The "lorem ipsum / John Doe" failure didn't manifest in RED.** Base Claude reaches for varied names and plausible content when asked for seed data — neither agent produced "Test User 1..N" or `user1@test.com`.

**Where GREEN was structurally better:** the named demo scenarios as exported functions is the most operationally useful difference. RED's seed data is good for general dev/test; GREEN's is also explicitly demoable scene-by-scene, which is what `.forge/demo-narrative.md` consumers expect.

**This pairing reads as a clear win for the skill** — not on substance (both produced realistic data) but on structural fitness for the downstream demo workflow.

## Refactor applied

None.
