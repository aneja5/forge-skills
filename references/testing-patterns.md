# Testing Patterns Reference

Shared reference for `tdd`, `incremental-implementation`, and `code-review-and-quality`.

## The Core Rule

Tests verify behavior through public interfaces. A test that breaks when you rename an internal function (without changing behavior) is a bad test.

## Good vs. Bad Tests

### Good: Behavioral

```typescript
test("user receives confirmation email after registration", async () => {
  const emailSpy = jest.spyOn(emailService, "send");
  await registerUser({ email: "alice@example.com", password: "secure123" });
  expect(emailSpy).toHaveBeenCalledWith(
    expect.objectContaining({ to: "alice@example.com", subject: "Welcome" })
  );
});
```

- Tests observable behavior (email sent to user)
- Uses the public interface (registerUser)
- Survives internal refactor

### Bad: Implementation-coupled

```typescript
test("UserService.create() calls UserRepository.save()", async () => {
  const saveSpy = jest.spyOn(userRepo, "save");
  await userService.create({ email: "alice@example.com" });
  expect(saveSpy).toHaveBeenCalled();
});
```

- Tests internal call pattern, not behavior
- Breaks on any internal refactor
- Passes even if user creation is broken (wrong data saved)

## Mocking Rules

**Mock at system boundaries only:**

| Mock | Yes | No |
|------|-----|----|
| External payment API | ✓ | |
| Your own UserService | | ✓ |
| Database (integration tests) | Sometimes | |
| Database (unit tests) | ✓ | |
| Time / randomness | ✓ | |
| Internal collaborators | | ✓ |

**Why not mock your own code:** If you need to mock internal module A to test module B, A and B are too tightly coupled. Fix the interface, not the test.

## Test Structure

### Unit tests
- One behavior per test
- Pure functions: input → output
- No network, no filesystem, no database
- Fast (< 10ms per test)

### Integration tests
- One user-visible capability per test
- Real database (test instance or in-memory)
- Real inter-module calls
- Mocked external services only
- Slower (100ms–1s acceptable)

### E2E tests
- One user journey per test
- Real browser / real HTTP
- Minimal count — cover happy paths and critical error paths
- Slowest — run in CI, not on every save

## Naming Convention

Test names should read like specifications:

```
✓ "user can checkout with valid cart"
✓ "registration fails with duplicate email"
✓ "session expires after 30 minutes of inactivity"

✗ "checkout function works"
✗ "test registration"
✗ "UserService.create() returns user"
```

## Coverage ≠ Quality

100% line coverage with behavior-coupled tests = false confidence.
60% line coverage with behavioral tests = genuine confidence.

Coverage tells you what was executed, not whether the behavior was verified.

## TDD Vertical Slice Pattern

For each acceptance criterion in a task:

```
1. Write the test (RED)
   - Test must fail
   - Failure message must make sense

2. Write minimum code (GREEN)
   - Only enough to make this test pass
   - Do not add code for the next test

3. Refactor (if needed)
   - Extract duplication
   - Improve naming
   - All tests still pass after each change

4. Repeat for next acceptance criterion
```

Never: write 5 tests then write 5 implementations.
