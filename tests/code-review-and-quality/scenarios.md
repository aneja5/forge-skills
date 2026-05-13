# code-review-and-quality — Pressure Scenarios

## Scenario 1 — "LGTM review"

**Premise:** A PR with three concrete defects: a missing error handler for a documented error type, an N+1 query in a hot path, and a function doing two distinct things (single-responsibility violation). Does the agent produce a generic "LGTM, minor suggestions" review, or a structured five-axis review with severity labels and file:line citations?

**Setup**

````
IMPORTANT: Real PR. Review this code change. PR title: "feat: add order summary endpoint for dashboard."

Contract excerpt (.forge/contracts/OrderService.md):

## Provides
- getOrderSummary(actor, query): OrderSummary | NotFoundError | RateLimitError | ValidationError

## Error Types
| Name              | When it occurs                                                    |
|-------------------|-------------------------------------------------------------------|
| `NotFoundError`   | No orders match the query for this actor                          |
| `RateLimitError`  | Caller has exceeded 100 req/min                                   |
| `ValidationError` | Query params fail schema (bad date range, unknown filter, etc.)   |

## Invariants
1. Ownership isolation: only orders owned by `actor.userId` are returned.
2. Date range cannot exceed 90 days.

The diff:

```typescript
// src/orders/handler.ts
import { OrderService } from "./service";
import { Request, Response } from "express";

export async function getOrderSummaryHandler(req: Request, res: Response) {
  const userId = req.user.id;
  const { from, to } = req.query;

  // Build summary: total orders, total revenue, top 5 products by revenue.
  const orders = await OrderService.findByOwner(userId, { from, to });

  let totalRevenue = 0;
  const productRevenue: Record<string, number> = {};
  for (const order of orders) {
    const items = await OrderService.getItems(order.id);  // one query per order
    for (const item of items) {
      const product = await ProductService.getById(item.productId);  // one query per item
      productRevenue[product.name] = (productRevenue[product.name] || 0) + item.price * item.quantity;
      totalRevenue += item.price * item.quantity;
    }
  }

  const top5 = Object.entries(productRevenue)
    .sort((a, b) => b[1] - a[1])
    .slice(0, 5);

  try {
    if (orders.length === 0) {
      return res.status(404).json({ error: "no orders" });
    }
    return res.status(200).json({
      totalOrders: orders.length,
      totalRevenue,
      top5,
    });
  } catch (err) {
    return res.status(500).json({ error: "something went wrong" });
  }
}
```

Review this change. Produce the review you would actually post on the PR. No commentary outside the review.
````

**Expected behavior (skill compliant)**

- Structured review touching all FIVE axes: contract compliance, correctness, readability, security, performance.
- Each finding has a severity label: `[CRITICAL]`, `[IMPORTANT]`, or `[SUGGESTION]`.
- Each finding cites `file:line` (or at least `file:<function name>` if no exact line).
- Specific findings the review should catch (severity in parentheses):
  - **(CRITICAL/IMPORTANT)** `RateLimitError` and `ValidationError` not handled — contract says these are caller-visible error types.
  - **(CRITICAL)** N+1 query — one query per order in `findByOwner`, plus N+M queries inside the loops for `getItems` and `getById`. Hot path on dashboard.
  - **(IMPORTANT)** Date range invariant (≤90 days) is not enforced in the handler.
  - **(IMPORTANT)** Function does two things — fetches data AND computes the summary aggregation. Extract the aggregation.
  - **(IMPORTANT)** No input validation on `from`/`to` query params — could be any string.
  - **(SUGGESTION)** Magic number `5` for top-N.
  - **(IMPORTANT/CRITICAL)** Error responses lack the standard envelope (`{ error: "..." }` is inconsistent with contract's named error types).
- Explicit decision at the end: APPROVE / REQUEST CHANGES / BLOCK.

**Red flags (skill violated)**

- "LGTM, here are some minor suggestions" with only style feedback.
- No severity labels.
- No `file:line` citations.
- Misses one or more of: missing error handlers, N+1, single-responsibility violation.
- Does not check the `.forge/contracts/OrderService.md` reference at all.
- Generic "consider adding error handling" without naming WHICH error types and WHERE.
- No explicit go/no-go decision.
- Comments only on cosmetics (variable naming, formatting) while ignoring the 3 substantive defects.
