---
description: Add structured logging, tracing, metrics, and alerts — golden signals, SLOs, runbook links
---

Invoke the forge-skills:observability skill.

Define correlation ID flow through every service boundary.
List golden signals per service — Rate, Errors, Duration (p50/p95/p99), Saturation.
Define SLOs per user-facing endpoint with page-worthy vs ticket-worthy alert thresholds.
Every alert links to a runbook. Establish log levels, structured JSON schema, retention.
Configure trace sampling (head-based baseline + tail-based for errors).
Document PII redaction rules (cross-ref security-and-compliance).

After writing: "Observability written to .forge/observability.md. Pair with /incident for runbooks."
