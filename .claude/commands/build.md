---
description: Implement a feature or fix using test-driven development
---

Invoke the forge-skills:tdd skill.

Before writing any code:
- Confirm the public interface and which behaviors to test
- Get user approval on the plan

Then implement using strict vertical slices:
  RED: write one failing test for one behavior
  GREEN: write the minimum code to pass it
  Repeat for each behavior

Never write all tests first. One test → one implementation → repeat.

Run the full test suite after each GREEN. Refactor only after all tests pass.
