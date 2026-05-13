---
description: Establish error handling patterns and resilience strategy — classification, retries, timeouts, circuit breakers
---

Invoke the forge-skills:error-handling-and-resilience skill.

Inventory failure modes per component (network, validation, business rule, dependency, race).
Classify each as transient (retry with backoff), permanent (escalate), or user-correctable (catalog message).
Assign handling pattern per class — timeouts on every external call, max attempts on every retry, deadlines, idempotency keys.
Write error taxonomy with named error types, HTTP codes, circuit breaker thresholds.
Define logging + alerting per class. Document compensation for irreversible flows.

After writing: "Error handling written to .forge/error-handling.md. Pair with /observe for the dashboards."
