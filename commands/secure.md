---
description: Security and compliance assessment — auth model, PII inventory, threat model, certification roadmap
---

Invoke the forge-skills:security-and-compliance skill.

Read `.forge/architecture.md` and `.forge/contracts/`. If architecture doesn't exist, tell the user to run /architect first.

Map auth model and session management for every user type.
Audit data isolation strategy (RLS, tenant separation).
Inventory all PII across every data store with retention policies.
Scan for applicable regulations (GDPR, CCPA, SOC 2, HIPAA).
Run STRIDE threat model on every trust boundary — top 5 threats get specific mitigations.
Assess every third-party vendor's security posture.
Build certification roadmap with timelines and gap analysis.

After writing: "Security assessment written to .forge/security.md."
