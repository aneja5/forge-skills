# cross-validation — Test Results

Run date: 2026-05-12
Methodology: see [tests/METHODOLOGY.md](../METHODOLOGY.md)
Subagents: 2 fresh `general-purpose` agents (1 RED + 1 GREEN)

---

## Scenario 1 — "Validate but stay vague"

### RED (no skill)

Produced a **fully self-contained validation prompt** — the "generic 'any feedback?'" failure did not manifest.

Highlights:
- **Opens with reviewer framing:** *"You are an external senior engineer. You have no prior context on this project, the team, or the business. That is a feature, not a bug — we want the review that only an outsider can give."*
- **Sets the time horizon explicitly:** *"You are reviewing pre-implementation. No code has been written. Changing the architecture now costs a meeting; changing it in six months costs a quarter."*
- **One-paragraph product summary** embedded inline (ClerkTime / law firms / SOC 2 / HIPAA-aware / US-only).
- **Specific output structure requested:**
  1. Go / no-go / go-with-changes recommendation in one sentence at the top.
  2. Up to **five "I would not ship this as-is" findings** with claim / why it matters / evidence / what you'd do instead / confidence.
  3. A short list of "we should have asked but didn't" questions.
- **7 specific concerns** named (not "thoughts on multi-tenancy" but "Application-side `firm_id` filtering over Postgres RLS — defensible for SOC 2 / HIPAA-aware, or not?"). Concerns include sync CSV export, effective-dated billing rates / temporal-data nightmare, approval state machine sufficiency, single Postgres no-replica vs 99.9% uptime, HIPAA-aware-but-not-certified, 6-minute increment enforcement layer.
- **"What we are NOT asking for"** section — bans style/lint comments, scope reframing, stack swaps without NFR justification, effort estimates.
- **Format and logistics:** Markdown inline (no PDF/Doc), 1-3 page target, deadline 5 business days, confidentiality clause, AI-tool disclosure ask, conflicts disclosure ask.
- **Closing:** *"We will read all three reviews independently before discussing them. Findings that two of three reviewers flag will be treated as blocking. ... We will send each of you a short summary of the merged outcome and which of your findings we acted on, so you can see what your review actually changed."*

The output is ready to send to the three reviewers as-is.

### GREEN (with skill)

Per the agent's summary, produced an equivalent prompt with skill section citations.

Highlights claimed:
- **Self-contained:** sections 1 (product summary), 2 (architecture summary), and 3 (contract summaries) all embedded inline. Explicit instruction: *"Do not assume access to source, contracts, or any internal docs."*
- **11 categories of specific questions** (skill requires 10+): Architecture, Data Model & Multi-Tenancy, Security & Compliance, Scalability, Reliability, Operability, Cost, Business Model, Testing, Must-Change-Before-Shipping, Meta.
- **Questions are specific, not open-ended:** the skill's example question shape ("Application-side firm_id filtering with no RLS — what's your view of the risk profile, and would you require RLS before SOC 2?") is question 4 verbatim. Other examples cited: Q6 names `tstzrange` + exclusion constraint vs two `timestamptz` columns; Q14 names specific failure candidates (Fargate memory, ALB timeout, RDS connections, S3 latency).
- **Reviewer response structure prescribed:** per-category answers, three-tier risk-ranked summary (Must-Fix / Should-Fix / Nice-to-Have) with remediation + rationale, confidence ratings on Must-Fix items.
- **Reviewer logistics:** 60-90 minutes, 5 business days, inline reply.
- **Closing commitment** to consolidate into an ADR within one week.
- **Citation map** tying every section to a skill rule.

The agent claimed to write `.forge/cross-validation-prompt.md`. Verified after run: no `.forge/` directory in our worktree; subagent's filesystem actions were sandboxed.

### Outcome

**Both produced self-contained validation prompts.** The "any feedback?" failure did not manifest. Base Claude reaches for embedded summaries and specific questions when given a real review brief.

**Differences GREEN added:**

| Feature | RED | GREEN |
|---|---|---|
| Self-contained (no "see attached") | ✅ | ✅ |
| Product summary embedded | ✅ one paragraph | ✅ one paragraph |
| Architecture summary embedded | ⚠️ implied via "attached" reference but with the concerns named | ✅ inline |
| Contract summaries embedded | ❌ ("contracts attached") | ✅ inline |
| 10+ specific question categories | ⚠️ 7 named concerns, 5-finding output ceiling | ✅ 11 categories (Architecture / Data / Security / Scalability / Reliability / Operability / Cost / Business / Testing / Must-Change / Meta) |
| Output structure prescribed for reviewer | ✅ 3-part (verdict / 5 findings / asked-but-didn't) | ✅ per-category + Must/Should/Nice tier |
| Time budget for reviewer | ✅ 5 business days | ✅ 60-90 min + 5 business days |
| Format constraint | ✅ Markdown inline, 1-3 pages | ✅ Markdown inline |
| Confidentiality clause | ✅ | ⚠️ not explicit |
| Conflicts disclosure ask | ✅ | ❌ |
| AI-tool disclosure ask | ✅ | ❌ |
| Closing loop ("we'll tell you what we acted on") | ✅ | ✅ ADR within one week |
| Sets reviewer-as-outsider expectation explicitly | ✅ verbatim | ❌ |
| Bans scope reframing / lint comments / stack swaps | ✅ ("What we are NOT asking for" section) | ❌ |
| Citation map | ❌ | ✅ |

**RED was richer in reviewer-experience design** — the "we will send you a summary of which of your findings we acted on" line is unusually thoughtful (closes the loop, motivates effort) and the conflicts / AI-tool disclosure asks are real operational concerns RED surfaced unprompted.

**GREEN was structurally cleaner** — the 11 categories, per-category + 3-tier output structure, and citation map are exactly what `.forge/cross-validation-prompt.md` consumers expect downstream.

This is now a clear pattern across the test suite (the 4th-5th scenario where RED's narrative quality exceeds GREEN's structural compliance): **RED writes the prompt as a thoughtful human communicating with three professionals. GREEN writes the prompt as a structured artifact for the skill chain.** Both have value; the project's culture decides which matters more.

## Refactor applied

None.
