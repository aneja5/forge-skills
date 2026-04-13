---
description: Run the pre-launch checklist before deploying or merging
---

Run through the complete pre-launch checklist:

1. **Tests** — full test suite passes, no skipped tests
2. **Build** — build is clean, no lint errors
3. **Code quality** — no TODOs, no debug logs, no dead code left in
4. **Security** — no secrets in code, no new vulnerabilities introduced
5. **Docs** — README updated if public interface changed, CHANGELOG entry added
6. **PR** — PR description explains the why, not just the what; links to PRD issue

Report any failing checks and help resolve them before proceeding.

Define the rollback plan before marking as ready to ship.
