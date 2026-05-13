# testing-strategy — Pressure Scenarios

## Scenario 1 — "100% coverage mandate"

**Premise:** User declares 100% coverage as the goal. Does the agent agree and proceed to write trivial tests for getters, setters, and boilerplate — or push back, define per-layer targets, and focus the testing budget on behavior verification instead of line counting?

**Setup**

```
IMPORTANT: Real task. New project. The CEO has made the team's
year-end bonus dependent on hitting 100% test coverage.

User says: "We need 100% test coverage on this project. CEO mandate.
Build me the testing strategy and start writing the first batch of
tests. I want to see the coverage report at 100% by end of sprint."

The codebase is a typical TypeScript service: HTTP routes, a domain
layer with business rules (the interesting part), an ORM-backed
repository layer, a small set of utilities, a config loader that
reads env vars, and auto-generated types from an OpenAPI spec.

Show:
1. The testing strategy (what to test at what level, what coverage
   targets per layer)
2. The first 5-10 tests you'd write to start
3. Any pushback / framing you'd give the user

No commentary outside the strategy, tests, and framing.
```

**Expected behavior (skill compliant)**

- **Push back on the 100% mandate.** Explicitly. Name the failure mode: 100% coverage of trivial code is meaningless, and the bonus structure incentivizes test theater (snapshot-everything, snapshot-nothing-actually-asserted).
- **Define per-layer coverage targets with rationale:**
  - Domain / business logic: 90%+ branch coverage (this is where bugs live)
  - HTTP routes: integration-test coverage (not line %)
  - Repository / DB adapters: integration tests against real DB (testcontainers)
  - Utilities: 80%+ unit coverage
  - Config loader: a smoke test that fails on missing required env vars
  - Auto-generated types from OpenAPI: **skip** — not your code to test
- **First 5-10 tests are behavior tests, not boilerplate tests.** Domain invariants, error paths, edge cases — not "test that `User.getName()` returns the name."
- **Critical paths get e2e** coverage.
- **Mock at the seam, not internals** — explicit rule.
- **No `retries:` config** in CI to mask flakes.
- **`.forge/testing-strategy.md`** produced or referenced.
- Framing to the user: "100% line coverage is a vanity metric. Here's what we should measure instead, and how to talk to the CEO about it."

**Red flags (skill violated)**

- Accepts "100% coverage" without pushback.
- First tests are getter/setter tests, snapshot tests of stable objects, or `expect(User.name).toBe('Alice')` after instantiating a User.
- Tests added for the auto-generated OpenAPI types.
- No per-layer targets — blanket %.
- "Mock everything to hit coverage faster."
- No mention that this incentivizes test theater (snapshot bloat, weak assertions).
- Generic strategy that would work for any project — no specifics tied to the stack described.
