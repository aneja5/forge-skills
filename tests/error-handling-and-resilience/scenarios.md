# error-handling-and-resilience — Pressure Scenarios

## Scenario 1 — "Just catch and log"

**Premise:** A service makes 3 external API calls in sequence to render a user-facing dashboard. The user asks the agent to "add error handling." Does the agent reach for bare `try-catch` with `console.log`, or does it classify failures, add timeouts and bounded retries, define user-facing error messages, and produce the `.forge/error-handling.md` artifact?

**Setup**

```
IMPORTANT: This is a real task. Time pressure — the dashboard ships tomorrow.

Code (TypeScript, Node 22):

async function loadDashboard(userId: string) {
  const profile = await fetch(`https://users-api.internal/v1/users/${userId}`)
    .then(r => r.json());

  const orders = await fetch(`https://orders-api.internal/v1/orders?user=${userId}`)
    .then(r => r.json());

  const recommendations = await fetch(`https://reco-api.internal/v1/reco?user=${userId}`)
    .then(r => r.json());

  return { profile, orders, recommendations };
}

Context:
- users-api is a critical internal dependency, 99.95% SLO.
- orders-api is a critical internal dependency, 99.9% SLO.
- reco-api is a non-critical 3rd-party vendor with 99% SLO and frequent transient 5xx.
- The dashboard is user-facing; users wait while it loads.
- Today, when any of these fails, the page shows a blank "Something went wrong" and Cloudflare logs an unhandled rejection.

User says: "Add error handling to loadDashboard. Ship it tomorrow."

Show the revised code AND any supporting docs you would write. Inline anything user-facing. No commentary outside the code/doc content.
```

**Expected behavior (skill compliant)**

- Each `fetch` has an explicit timeout (AbortController + deadline).
- Each call is classified: `users-api` and `orders-api` are critical (failure surfaces error or fallback); `reco-api` is non-critical (failure degrades gracefully — empty recommendations, page still renders).
- Bounded retries with exponential backoff + jitter for transient failures (5xx, network) on `reco-api`. No infinite retries.
- Permanent failures (4xx) are not retried.
- Structured error types, not strings. Errors carry a `code` field, not just a message.
- A user-facing message catalog: at least the two cases ("can't reach your profile" / "couldn't load recommendations, retry later").
- `.forge/error-handling.md` (or equivalent) produced or referenced: error taxonomy, retry config per call, timeouts per call, alerting thresholds.
- No bare `catch (e) {}`. No `console.log(err); return`.

**Red flags (skill violated)**

- A single `try { ... } catch (e) { console.error(e); return null; }` wrapping everything.
- No timeouts on `fetch` calls.
- Same error handling for all three calls regardless of criticality.
- "Retry on error" without max attempts or backoff.
- No user-facing message catalog — the error path returns `null` or `undefined` to the UI.
- `if (err.message.includes("..."))` — string-matching errors.
- No `.forge/error-handling.md` or any structured artifact.

---

## How this scenario was chosen

This maps to the skill's Red Flags ("`try { ... } catch (e) {}` — empty catch", "`fetch(url)` with no timeout", "No distinction between transient and permanent failures") and to the Common Rationalizations ("`try-catch` is enough", "We'll add retries later", "Just log and continue"). Real-world failure pattern: developers reach for the smallest change that silences the unhandled rejection rather than the smallest change that handles the actual failure modes correctly.
