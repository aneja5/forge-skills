# Contract Templates

Reference templates for interface contracts and ADRs.

---

## Interface Contract Template

File: `.forge/contracts/<module-name>.md`

```markdown
# Contract: <ModuleName>

> Module responsibility: [one sentence — what this module does]

## Provides

What this module exposes to its callers:

- `<OperationName>(input: InputType): OutputType` — [what it does]
- `<OperationName>(input: InputType): OutputType | ErrorType` — [what it does]

## Consumes

What this module depends on (other contracts it calls):

- `<OtherModule>.<Operation>` — [why]

## Input Types

```typescript
type InputType = {
  field: string        // description
  optionalField?: number // description, default: X
}
```

## Output Types

```typescript
type OutputType = {
  field: string
  nested: {
    field: boolean
  }
}
```

## Error Types

| Error | Condition | Caller should |
|-------|-----------|---------------|
| `NotFoundError` | Resource doesn't exist | Return 404, do not retry |
| `ValidationError` | Input fails schema check | Return 400 with field errors |
| `RateLimitError` | Request quota exceeded | Retry after `retryAfter` seconds |

## Invariants

Guarantees this module always maintains, regardless of caller behavior:

- [Invariant 1: e.g., "Output is never null — callers never need null checks"]
- [Invariant 2: e.g., "Side effects are idempotent — safe to retry on failure"]

## Not Responsible For

Explicit list of what this module does NOT handle:

- [e.g., "Authentication — callers must provide a valid session token"]
- [e.g., "Logging — callers handle their own observability"]
```

---

## ADR Template

File: `.forge/adr/NNN-<decision-slug>.md`

```markdown
# ADR-NNN: <Title>

- **Date**: YYYY-MM-DD
- **Status**: Accepted | Superseded by ADR-NNN | Deprecated

## Context

What situation, constraint, or requirement prompted this decision? Include the forces at play.

## Decision

What was decided. State it clearly in one or two sentences.
> "We will use X because Y."

## Consequences

### Positive
- [Benefit 1]
- [Benefit 2]

### Negative / Trade-offs
- [Cost or constraint accepted]

### Neutral
- [Fact that changes but is neither good nor bad]

## Alternatives Considered

| Option | Why rejected |
|--------|-------------|
| Option A | [reason] |
| Option B | [reason] |
```

---

## Module Boundary Checklist

Before writing a contract, verify the module boundary is correct:

- [ ] The module has one clear responsibility (not two)
- [ ] You can describe what it does without describing how
- [ ] The interface is stable — callers won't need to change when internals change
- [ ] The module can be tested without its callers (testable in isolation)
- [ ] Error cases are named, not implicit
- [ ] The module's invariants are meaningful guarantees, not truisms

---

## Example: Auth Contract

```markdown
# Contract: AuthService

> Module responsibility: Verify user identity and issue session tokens.

## Provides

- `authenticate(credentials: Credentials): Session | AuthError`
- `validate(token: Token): Session | ExpiredError | InvalidError`
- `revoke(token: Token): void`

## Consumes

- `UserRepository.findByEmail` — to look up user records

## Input Types

type Credentials = { email: string; password: string }
type Token = { value: string }

## Output Types

type Session = {
  userId: string
  token: string
  expiresAt: ISO8601String
}

## Error Types

| Error | Condition | Caller should |
|-------|-----------|---------------|
| AuthError | Credentials invalid or user not found | Return 401, do not reveal which field failed |
| ExpiredError | Token past expiresAt | Redirect to login |
| InvalidError | Token malformed or not found | Treat as unauthenticated |

## Invariants

- Never returns the user's password hash in any output type
- Tokens are always at least 32 bytes of entropy
- Revoked tokens are rejected within 5 seconds

## Not Responsible For

- Password reset flows
- OAuth / social login
- Role-based authorization (handled by PolicyService)
```
