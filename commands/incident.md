---
description: Respond to an outage or write a blameless postmortem — severity, runbooks, action items
---

Invoke the forge-skills:incident-response-and-postmortems skill.

If actively responding: declare in #incident-active (severity, what's broken, impact) → mitigate (restore service first, root cause later) → communicate (internal every 30/60min, external status page within 15/30min) → resolve → review.

Define severity levels (Sev1-4) with response-time SLAs.
For every critical service, write a runbook: owners, dashboards, common failure modes, mitigation playbook, escalation, recovery verification.
For every Sev1/Sev2: blameless postmortem within 5 business days — timeline, impact, root cause, contributing factors, action items with owners and deadlines. No blame language.

After writing: "Incident response written to .forge/incident-response.md."
