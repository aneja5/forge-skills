---
description: Five-axis code review validating correctness, contracts, readability, security, performance
---

Invoke the forge-skills:code-review-and-quality skill.

For each module touched in the change, check `.forge/contracts/<module>.md`:
- Input types match contract schema
- Output types match contract schema
- Every error type in the contract is handled
- Every invariant in the contract is enforced

Then review across all five axes:
1. Contract compliance (see above)
2. Correctness — acceptance criteria met, edge cases handled
3. Readability — names, comments, function length
4. Security — input validation, authn/authz, data exposure
5. Performance — N+1 queries, blocking operations

Categorize each finding: [CRITICAL] / [IMPORTANT] / [SUGGESTION]
Cite file:line for every finding.
State a clear recommendation: APPROVE / REQUEST CHANGES / BLOCK.
