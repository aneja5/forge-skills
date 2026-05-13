# testing-strategy — Test Results

Run date: 2026-05-12
Methodology: see [tests/METHODOLOGY.md](../METHODOLOGY.md)
Subagents: 2 fresh `general-purpose` agents (1 RED + 1 GREEN)

---

## Scenario 1 — "100% coverage mandate"

### RED (no skill)

**Pushed back firmly on the 100% mandate.** Lead with:

> *"Coverage is a proxy metric. Coverage of code that doesn't matter buys nothing; gaps in code that does matter are catastrophic."*

Per-layer coverage targets:
| Layer | Target | Test type |
|---|---|---|
| Domain / business rules | 100% line + 100% branch + mutation testing (Stryker, ~80%) | Unit |
| HTTP routes | ~90% line, focus on wire contract | Integration |
| Repository layer | ~70% line, 100% of custom queries | Integration via Testcontainers |
| Utilities | 100% | Unit |
| Config loader | 100% of branches | Unit with `process.env` stubbed |
| **Auto-generated OpenAPI types** | **excluded from coverage** | None |
| Migrations | smoke test only | |
| `index.ts` / bootstrap | excluded | |

**First 8 tests are behavior tests, not boilerplate.** Boundary conditions (volume discount at exactly 10 units, NOT at 9 — off-by-one pinning), state-machine guards (cancellation rejects shipped orders), config-loader env-var-missing error paths.

**Pushback framing for the CEO** delivered as a 3-point statement:
1. 100% coverage of trivial code is meaningless.
2. Some files should be excluded (generated types, migrations, bootstrap).
3. The ORM layer hitting 100% means mocking, which produces useless tests.

Counter-proposal: *"100% on the domain layer (line + branch + mutation ≥80%), ~90% weighted overall, with documented exclusions."* On the record so CEO can choose between the metric and the goal.

### GREEN (with skill)

**Also pushed back firmly.** Lead with a header titled "Pushback first (read this before the strategy)" and a one-paragraph reframe to send to the CEO:

> *"The goal is 'no escaped bugs in production for the critical paths,' not '100% of lines executed in CI.' We will hit ~90%+ branch coverage on the domain layer (where bugs are expensive), integration-test the database and HTTP boundaries against real dependencies (where mocks lie), and e2e-test the top user journeys (where unit tests cannot help)."*

Plus a sharp closing line: *"If you want a single coverage figure for the board, we will publish domain-layer branch coverage — it is the one that maps to 'did we test the business rules.'"*

Per-layer targets are nearly identical to RED, with the same exclusions and the same mock-at-the-seam rule.

**10 first tests** cover boundary conditions, state-machine guards, golden tests (frozen role × resource → permissions matrix), error paths with specific exception types, integration tests against testcontainers Postgres, route-level auth enforcement (403 not 200), field-level validation error envelope, config-loader missing-env throws, plus 2 e2e tests (customer creates → views → cancels; cannot cancel someone else's order).

**Section "What I am NOT writing (and why):"**
- A test that imports every file to "hit the lines." Coverage theater.
- Unit tests for OpenAPI-generated types directory.
- Unit tests for the repository with the ORM mocked.
- A `retries: 3` line in `vitest.config.ts`.
- A project-wide 100% threshold.

**Citation map** at the end with verbatim skill quotes per choice.

### Outcome

**Both pushed back on the 100% mandate.** Base Claude knows that "100% coverage" is a vanity metric when given an actual project shape with named layers (HTTP routes, domain, ORM, utilities, config, generated types). The failure pattern (agreeing and writing trivial tests) did not manifest.

**Differences GREEN added:**

| Feature | RED | GREEN |
|---|---|---|
| Refused 100% as goal | ✅ | ✅ |
| Per-layer coverage targets with rationale | ✅ | ✅ |
| Excluded generated OpenAPI types | ✅ | ✅ |
| Behavior-first first batch of tests | ✅ 8 tests | ✅ 10 tests |
| Boundary-condition tests (off-by-one) | ✅ | ✅ |
| Golden test for invariants | ✅ (volume discount at 10) | ✅ (permission matrix as `.json` cases) |
| Error path with specific exception type | ✅ | ✅ |
| Testcontainers Postgres for repo | ✅ | ✅ explicit verbatim "Never mock the database — testcontainers" |
| Route-level auth enforcement test | ❌ | ✅ 403 check |
| E2E test for critical journey | ⚠️ mentioned, not written | ✅ written (create → view → cancel) |
| Negative e2e (cross-tenant access blocked) | ❌ | ✅ |
| Reframe paragraph the user can send to the CEO | ⚠️ implicit in framing | ✅ "send this to your CEO" paragraph |
| What NOT to write list | ❌ | ✅ explicit |
| Citation map | ❌ | ✅ verbatim |

**Both refused well; GREEN was more operationally complete** — the "send this to your CEO" paragraph is the kind of artifact the user actually needs, and the explicit "what I'm NOT writing" section forecloses the cheap path back to coverage theater.

## Refactor applied

None.
