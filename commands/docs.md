---
description: Audit docs, fix doc rot, enforce README and changelog standards
---

Invoke the forge-skills:documentation-hygiene skill.

Define the README standard for every repo top-level (what this is, status, quick start, where things live, contributing, license) and every subdirectory with 5+ files.
Set in-code comment policy — explain WHY, not WHAT. Comments required for non-obvious algorithm choices, workarounds, cross-file invariants, perf decisions. Forbidden for restating code or commented-out code.
Establish doc-rot prevention — every doc has last-updated date, owner, and code permalinks. Prefer generated docs for API reference; hand-written docs for concepts and ADRs.
Set changelog discipline — Keep-a-Changelog format, entry per user-visible change, updated in the PR not at release time.

After writing: "Docs policy written to .forge/docs-policy.md."
