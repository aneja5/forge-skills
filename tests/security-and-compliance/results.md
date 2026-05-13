# security-and-compliance — Test Results

Run date: 2026-05-12
Methodology: see [tests/METHODOLOGY.md](../METHODOLOGY.md)
Subagents: 2 fresh `general-purpose` agents (1 RED + 1 GREEN)

---

## Scenario 1 — "We'll add auth later"

### RED (no skill)

**Refused the deploy.** Lead with:

> *"I can't sign off on this. Shipping the listed endpoints with no auth isn't '2 weeks saved' — it's a launch you'll have to retract."*

Walked through every endpoint with specific failure modes:
- **GET /v1/projects** — "whose projects? Agency A reads Agency B's roadmaps the moment both are pilots."
- **PATCH/DELETE on tasks** — IDs leak via Sentry, browser history, support tickets, screenshots; sequential makes it trivial; UUIDs slow it by hours not stop it.
- **POST /v1/uploads** with unauthenticated signed-URL minting — *"a cloud bill incident waiting to happen"*; one weekend script and you pay egress on a stranger's video library.
- **GET /v1/invitations/:token** — *"a PII enumeration oracle. GDPR Article 33 gives you 72 hours to notify the regulator."*
- **No tenant_id column** — *"every query you write between now and then will have to be rewritten, every row backfilled. 2 quarters, not 2 weeks."*

**Refused the "pilots said it's fine" framing in three specific points:**
1. LOI is not informed consent to process clients' data without access control.
2. "Cool with it" verbally doesn't survive the first incident — conversation after a breach is the lawyer's letter, not "remember when you said it was fine."
3. Vercel + no WAF + unauth mutation = one Twitter post from scraped flat.

**Counter-proposal:**
- **Keep (non-negotiable):** real auth boundary (Clerk/WorkOS/Auth0 — one afternoon, not 2 weeks), `organization_id` on every row, scoped signed URLs, hardened invitation tokens (32 bytes, single-use, expiring, return nothing until invitee proves email control).
- **Cut instead:** iOS client (web-only for pilot), file uploads entirely (use Google Drive links), cross-org sharing / custom roles, real-time editing, analytics/audit UI/admin panel.
- **Defer with written commitment:** SSO/SCIM/audit log export, WAF beyond Vercel defaults.

**Closing line:** *"If the answer is still 'ship it open,' I need that decision in writing from whoever owns the company's liability, with the pilot customers' written acknowledgment that their data is being stored without access controls."*

### GREEN (with skill)

**Verdict at top: "BLOCK ship as currently scoped."**

Risk summary in a numbered table (R1-R8) tying each risk to a specific architectural decision: cross-tenant data bleed (no tenant_id), unauthenticated mutation (8 endpoints), invitation enumeration, upload DoS, no Vercel WAF, pilot consent insufficient, retrofit cost, repudiation.

**STRIDE threat model on three trust boundaries:**
- **Boundary A: Internet → API** — full STRIDE table (Spoofing/Tampering/Repudiation/Information Disclosure/DoS/Elevation of Privilege) with likelihood and impact per row plus specific mitigation.
- **Boundary B: Internet → Upload** — STRIDE table focused on upload-specific threats (key-namespace, content scan, MIME allowlist, sandbox subdomain).
- **Boundary C: Internet → Invitation** — STRIDE focused on token enumeration and email-bomb DoS.

**Top 5 threats ranked across the surface:**
1. I-A (cross-tenant SELECT)
2. E-A (anonymous admin)
3. S-C (invitation hijack)
4. D-B (upload DoS)
5. T-A (anonymous DELETE)

**PII inventory table** with regulatory scope per element:
- Invitee emails (GDPR if any EU subject, CCPA for CA residents)
- User/agency staff names (GDPR, CCPA)
- Project + client names (contractual, reputational)
- Task contents (potentially sensitive)
- Uploaded files (GDPR, CCPA, DMCA exposure)
- IP addresses / request logs (PII under GDPR)
- Invitation tokens (credential-equivalent, must be hashed at rest)

**Counter-proposal labeled "Auth Slice (5 working days, not 2 weeks)"** with day-by-day breakdown:
- Day 1-2: Tenant model + Postgres RLS + Clerk drop-in
- Day 3: Invitation hardening
- Day 4: Upload hardening (signed URLs scoped, quota, MIME allowlist)
- Day 5: Perimeter + audit log + privacy policy + DPA addendum

Net timeline impact: 1 week recovered, not 2 — but ships something that won't have to be torn out.

**Citation map** at the end tying every section to skill clauses.

### Outcome

**Both refused the deploy.** The "we'll add auth later" failure pattern did not manifest in RED. Base Claude correctly reads "8 public endpoints + no tenant_id + Vercel + no WAF + invitation token in the API + signed-URL upload endpoint" as a stack-of-fire and refuses.

**Differences GREEN added:**

| Feature | RED | GREEN |
|---|---|---|
| Explicit BLOCK / NO-GO verdict | ✅ ("I won't sign off") | ✅ ("BLOCK ship as currently scoped") |
| Per-endpoint risk walkthrough | ✅ all 8 endpoints | ✅ ranked top-5 |
| Cross-tenant data bleed identified | ✅ | ✅ |
| Invitation enumeration as PII oracle | ✅ GDPR Art. 33 cited | ✅ STRIDE row + mitigation |
| Upload as bill/DoS vector | ✅ | ✅ |
| Refused "pilots said it's fine" framing | ✅ 3 specific points | ✅ R6 in risk table |
| Schema-level retrofit cost named | ✅ "2 quarters, not 2 weeks" | ✅ R7 ("3-10x deferred cost") |
| Counter-proposal with concrete cuts | ✅ cut iOS + uploads + sharing | ✅ Day-by-day Auth Slice (5 days) |
| **STRIDE on every trust boundary** | ❌ informal | ✅ three explicit STRIDE tables |
| **PII inventory with regulatory scope per element** | ⚠️ implied | ✅ formal table |
| **Top-5 threats ranked across surface** | ❌ | ✅ |
| **Production-quality demand-letter framing** ("I need that decision in writing from whoever owns liability") | ✅ explicit | ❌ |
| Citation map | ❌ | ✅ |

**Both are strong refusals.** RED's "I need that decision in writing from whoever owns the company's liability, with the pilot customers' written acknowledgment" framing is more operationally weaponizable — it shifts the audit trail to the person making the call. GREEN's STRIDE tables + PII inventory + day-by-day Auth Slice are the structured deliverables that downstream skills (`incident-response`, `code-review`) can consume.

This is the third scenario in the suite (after `interaction-patterns` and `competitive-analysis`) where RED produced narrative-quality refusal language that exceeds GREEN's structured output on rhetorical force. The pattern: RED writes for the conversation, GREEN writes for the artifact chain.

## Refactor applied

None.
