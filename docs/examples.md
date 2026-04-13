# Forge Pipeline: Before/After Examples

Real examples of what each stage produces when done wrong vs. done right. Use these as calibration when applying skills.

---

## /grill — Idea Interview

### ❌ Wrong: Checklist questioning

The agent runs through a fixed list of questions regardless of what the user says.

```
Agent: What's the target user?
User:  Indie developers who build SaaS products.
Agent: What's the business model?
User:  Subscription.
Agent: What's the distribution channel?
User:  Content marketing.
Agent: What's the biggest risk?
```

**What went wrong:** Questions don't build on answers. "Indie developers who build SaaS products" should have triggered follow-ups — which part of building SaaS is broken? Do they mean solo builders or small teams? The agent collected data, not understanding.

---

### ✅ Right: Socratic, adaptive

Each question is generated from the user's last answer.

```
User:  I want to build a tool that helps indie devs ship faster.
Agent: When you say "ship faster" — are you describing a developer
       who has working code but gets stuck in deployment and release
       overhead, or one who struggles earlier in deciding what to build?
User:  The second one — they spend weeks building the wrong thing.
Agent: You've named the symptom. What's the actual moment this goes
       wrong for them — is it that they start coding too early without
       talking to users, or that they talk to users but don't know how
       to extract signal from the conversation?
User:  They don't talk to users at all. They just build.
Agent: So the core problem is validation avoidance, not tools. That's
       a behavior problem, not a tooling gap. What makes you think a
       tool can change that behavior — has anything changed it for you?
```

**What's right:** Every question reacts to the answer. "They don't talk to users at all" is a fundamentally different problem than "they talk but can't extract signal" — and the next question immediately tests whether the proposed solution even addresses the actual cause.

---

## /architect — Interface Contracts

### ❌ Wrong: Vague contract

```markdown
# Contract: PaymentService

Handles payments.

## Methods
- processPayment(data) → result
- refundPayment(id) → result

## Notes
- Returns error if something goes wrong
- Caller should handle failures
```

**What's wrong:**
- `data` is untyped — what fields? Required vs optional?
- `result` is untyped — success shape? Error shape?
- "Returns error" — what kind? What are callers supposed to do with it?
- "Caller should handle failures" — which failures? How?
- Two engineers implementing against this will build incompatible callers.

---

### ✅ Right: Typed, complete contract

```markdown
# Contract: PaymentService

> Module responsibility: Process charges and refunds against a payment provider.

## Provides

- `charge(input: ChargeInput): ChargeResult | PaymentError | ValidationError`
- `refund(input: RefundInput): RefundResult | NotFoundError | RefundError`

## Input Types

type ChargeInput = {
  userId: string          // must exist in UserService
  amountCents: number     // positive integer, in cents
  currency: "usd" | "eur" | "gbp"
  idempotencyKey: string  // caller-generated UUID; prevents double charge
}

type RefundInput = {
  chargeId: string        // from a previous ChargeResult
  amountCents?: number    // partial refund; defaults to full charge amount
  reason: "duplicate" | "fraudulent" | "requested_by_customer"
}

## Output Types

type ChargeResult = {
  chargeId: string
  status: "succeeded"
  amountCents: number
  processedAt: ISO8601String
}

type RefundResult = {
  refundId: string
  chargeId: string
  amountCents: number
  status: "pending" | "succeeded"
}

## Error Types

| Error | Condition | Caller should |
|-------|-----------|---------------|
| `PaymentError` | Card declined, insufficient funds | Show user-facing decline message; do not retry automatically |
| `ValidationError` | amountCents ≤ 0 or currency unsupported | Return 400; log for monitoring |
| `NotFoundError` | chargeId doesn't exist | Return 404; log as unexpected |
| `RefundError` | Charge already fully refunded | Return 409 |

## Invariants

- A charge with the same `idempotencyKey` is never processed twice
- `amountCents` in `RefundInput` never exceeds the original charge amount
- Partial refunds do not change the original charge's `chargeId`

## Not Responsible For

- Storing card details (handled by provider's vault)
- Tax calculation (handled by TaxService)
- Sending receipts (handled by NotificationService)
```

**What's right:** Any two engineers can implement a caller and the service separately and integrate without surprises. Every error is named and callers know what to do with each. The invariants define the guarantees the service makes.

---

## /build — TDD Discipline

### ❌ Wrong: Horizontal slicing

All tests written first, then all implementation. The agent wrote the spec as a test list, then filled it in.

```
Step 1 — Write ALL tests:
  test: empty cart returns 0
  test: single item calculates total
  test: multiple items sum correctly
  test: discount applied before tax
  test: tax rounds to 2 decimal places
  test: free shipping over $50

Step 2 — Write ALL implementation:
  function calculateTotal(items, discount, taxRate) { ... }
```

**What's wrong:**
- The last test ("free shipping over $50") revealed that `calculateTotal` needs a shipping parameter — but the implementation was already written.
- Tests 1-5 encode assumptions about `taxRate` as a parameter that turn out wrong when the real requirement is "tax rate from user's region."
- The full test suite fails until all implementation is done — no working software at any intermediate point.

---

### ✅ Right: Vertical slices, one at a time

Each RED/GREEN cycle is a thin complete slice. Implementation informs the next test.

```
Cycle 1
  RED:   test — empty cart returns subtotal: 0, tax: 0, total: 0
  GREEN: calculateTotal([]) → { subtotal: 0, tax: 0, total: 0 }

Cycle 2
  RED:   test — single $10 item, 8% tax → subtotal: 10, tax: 0.80, total: 10.80
  GREEN: sum items, apply taxRate
  [Learned: return type needs subtotal/tax/total breakdown, not just a number]

Cycle 3
  RED:   test — $20 item with 10% discount → subtotal: 20, discount: 2, total: 18 + tax
  GREEN: apply discount before tax
  [Learned: discount changes the tax base — this wasn't obvious until cycle 3]

Cycle 4
  RED:   test — $60 cart qualifies for free shipping
  GREEN: add shipping logic — requires knowing whether shipping is in scope
  [STOP: does shipping belong in calculateTotal or a separate shippingCost()?]
  → Asked user → separate function. Moved to next task.
```

**What's right:** Each cycle produces working, tested code. The learning from cycle 2 (return type) and cycle 3 (discount applies before tax) shapes the next test — which would have been missed in a test-first approach. The scope question in cycle 4 is caught before it silently expands the interface.

---

## /review — Code Review

### ❌ Wrong: Generic LGTM

```
Review of PR #47 — CartService implementation

The code looks good overall. The implementation follows the existing
patterns in the codebase. Tests are present. A few minor style notes:

- Line 23: could use const instead of let
- Line 45: variable name could be more descriptive

LGTM — approved for merge.
```

**What's wrong:**
- No check against `.forge/contracts/CartService.md`
- Doesn't verify acceptance criteria from the task
- Style notes dominate a review that should be about correctness
- "Looks good overall" is not a finding — it's an absence of investigation

---

### ✅ Right: Contract compliance + five-axis

```
Review of PR #47 — CartService implementation

## Contract Compliance (against .forge/contracts/CartService.md)

[CRITICAL] Contract specifies calculateTotal() returns
  { subtotal, discount, tax, total } but implementation returns
  { total } only. Callers expecting subtotal for display will break.
  File: src/cart/service.ts:34

[IMPORTANT] Contract defines DiscountError for invalid coupon codes
  but the implementation throws a generic Error("invalid coupon").
  Callers cannot catch DiscountError specifically — they'll miss it.
  File: src/cart/service.ts:89

## Correctness

[IMPORTANT] Acceptance criterion "discount applied before tax" is not
  met. Line 56 applies tax to the pre-discount amount.
  Test coverage: the task's test for this case is missing.
  File: src/cart/service.ts:56

## Security

[IMPORTANT] amountCents is not validated as a positive integer before
  passing to the payment provider. A negative value would attempt a
  credit, not a charge. Add: if (amountCents <= 0) throw ValidationError
  File: src/cart/service.ts:78

## Readability, Performance

No findings.

---

DECISION: REQUEST CHANGES
Block on CRITICAL. Fix IMPORTANT items before re-review.
The style notes from automated linting are already in the PR checks —
not repeated here.
```

**What's right:** Every finding has a file:line reference. The contract compliance axis catches the return-type mismatch that would have caused a silent runtime break for callers. The CRITICAL is clearly separated from IMPORTANT. The decision is explicit.

---

## Summary

| Stage | Wrong pattern | Right pattern |
|-------|--------------|---------------|
| /grill | Fixed-script checklist questions | Each question generated from the last answer |
| /architect | Prose descriptions, untyped interfaces | Typed inputs/outputs/errors/invariants per module boundary |
| /build | All tests first, then all code (horizontal) | One test → minimum code → next test (vertical) |
| /review | "LGTM, minor style notes" | Contract compliance check + five-axis + explicit decision |

The common failure mode in each case: **moving fast before establishing what "done" means**. The forge pipeline forces the definition of done at each stage before the next begins.
