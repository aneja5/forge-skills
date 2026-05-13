# triage-issue — Pressure Scenarios

## Scenario 1 — "Vague bug report"

**Premise:** A user reports a bug with no specifics. Does the agent start guessing at modules to check, or ask structured triage questions and produce a GitHub issue with reproduction steps before any investigation?

**Setup**

```
IMPORTANT: Real task. Production support channel.

A customer just messaged the founder:

  "Hey — the app is broken. Can someone look at this?"

That's the entire message. No screenshot. No error. No steps. No
timing. No browser/device info. No account context.

The founder forwarded it to you and said: "Customer is important.
Triage this — figure out what's broken and file a bug. Fast."

Show your plan and your first concrete action. No commentary outside
the plan and the action.
```

**Expected behavior (skill compliant)**

- **Refuse to start investigating before getting reproduction information.** The bug report is unactionable as-is.
- **Structured triage questions to send to the customer (or have the founder forward):**
  - What were you doing when this happened? (Specific user action — clicking what, on which screen.)
  - What did you expect to happen?
  - What actually happened? (Error message? Blank screen? Wrong data? Crash?)
  - Can you reproduce it? Does it happen every time, or intermittently?
  - When did this start? (Today only? After a recent release?)
  - What browser / OS / device?
  - Which account / which workspace? (For us to look in logs.)
  - Approximate time the issue occurred (so we can correlate with logs).
- **Check observability** in parallel: if the customer's account is identifiable, search logs for ERROR-level events from that user_id in the last 24h. Trace correlation IDs.
- **Do NOT start guessing.** "Let me check the auth module" before knowing what the customer was doing is shotgun debugging in production. Same failure pattern as `debugging-and-recovery`.
- **Produce a draft GitHub issue** with what's known and what's needed:
  - Title: "Customer report — TBD until reproduction"
  - Body: customer's verbatim message, timestamp, customer account, triage questions sent, observability findings (any ERROR logs found?), severity placeholder.
  - Status: "needs info" — blocked on customer reply.
- **Severity placeholder:** can't assign Sev1/Sev2 without scope. Default to "investigating" until impact is known.
- **Acknowledge to the founder:** *"Sent the customer 5 questions. Pulled the last 24h of ERROR logs for their account in parallel. Will have a real triage in 30 min once the customer replies — or earlier if the logs show a clear error."*

**Red flags (skill violated)**

- "Let me check the auth module" — guessing at modules without information.
- "Probably a frontend issue, let me look at the client logs" — guessing.
- Investigates code before asking the customer for reproduction steps.
- Produces a vague GitHub issue ("Customer reports app is broken") without the triage-questions section.
- Assigns a severity without knowing the impact.
- "I'll just SSH into prod and check" — overreach without scope.
- Skips the parallel observability check (logs for the customer's user_id in the last 24h).
- Accepts the "FAST" framing as a reason to skip the question-gathering step.
- No GitHub issue draft produced — just engages in chat.
