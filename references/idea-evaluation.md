# Idea Evaluation Reference

Used by `idea-griller` to determine whether a branch is resolved or needs more drilling.

## The 7-Branch Checklist

An idea is ready for `spec-driven-development` when all 7 branches are resolved or explicitly deferred as open assumptions.

---

### Branch 1: Problem

**What resolved looks like:**
- Named user type (not "developers" — "backend developers at companies with 50-500 engineers")
- Specific painful moment ("when they're on-call and get paged at 2am for an alert they've never seen before")
- Frequency or impact ("happens 3-5 times per quarter, takes 2-4 hours to resolve each time")

**Not resolved:**
- "People are frustrated with X"
- "It's a big problem in the industry"
- "Everyone who has tried it says it's painful"

**Drill with:**
> "Can you tell me about the last time this happened to you or someone you know? What were they doing, what happened, and what did it cost them?"

---

### Branch 2: Founder Fit

**What resolved looks like:**
- Concrete lived experience ("I was a backend engineer at Stripe for 4 years — I felt this pain 3x per quarter")
- Unfair network access ("I know 50 on-call engineers personally and can get 10 beta customers this week")
- Unique technical insight ("I built the observability system at Netflix — I know exactly why the current tools fail")

**Not resolved:**
- "I'm passionate about this space"
- "I've always been interested in developer tools"
- "I have some experience in this area"

**Drill with:**
> "What do you know about this problem that someone reading a blog post about it wouldn't know?"

---

### Branch 3: Solution

**What resolved looks like:**
- Specific mechanism ("When an alert fires, the tool automatically queries the last 3 similar alerts and shows what resolved them")
- Explicit out-of-scope list ("We are NOT building a new alerting system — we integrate with PagerDuty")
- User workflow described step-by-step ("User gets paged → opens tool → sees 3 similar past incidents → sees what resolved them → follows same steps")

**Not resolved:**
- "A platform that helps on-call engineers"
- "We use AI to make it smarter"
- "Something like X but better"

**Drill with:**
> "Walk me through exactly what a user does from the moment they're paged to the moment the incident is resolved, using your product."

---

### Branch 4: Business Model

**What resolved looks like:**
- Clear buyer ("Engineering manager at a company with 10+ engineers on-call rotation")
- Specific price ("$50/user/month — comparable to PagerDuty's per-seat pricing")
- Payment trigger ("Per seat, billed monthly, with a 14-day free trial")

**Not resolved:**
- "We'll figure out monetization once we have users"
- "Enterprise deals"
- "Freemium"

**Drill with:**
> "Which person at a company makes the buying decision? What budget does that decision come from? What's the most they'd pay before it needs a different approval process?"

---

### Branch 5: Distribution

**What resolved looks like:**
- Named first channel ("Direct outreach to on-call engineers on the SRE subreddit and SRE Slack communities")
- Named first 10 customers ("I have 3 former colleagues who've agreed to be beta users; I'll reach out to 7 SRE leads I know from conferences")
- Acquisition motion ("Free trial → self-serve signup → seat expansion when they invite their team")

**Not resolved:**
- "Word of mouth"
- "SEO"
- "We'll run ads"
- "Virality"

**Drill with:**
> "Tell me specifically: who are the first 3 people you'll contact on Monday morning? How do you know them? What will you say?"

---

### Branch 6: Risks

**What resolved looks like:**
- Single biggest risk named ("The biggest risk is that on-call engineers don't have time to try new tools — adoption is the failure mode, not the technology")
- Why it's the biggest ("Every competitor has failed at adoption, not at building the product")
- What tests it ("If we can't get 10 engineers to use it 3 times per week for a month, we've failed")

**Not resolved:**
- A list of risks ("there's competition, and regulations, and maybe people don't want it")
- Generic risks ("execution risk", "market timing")
- Technical risks that aren't actually the biggest risk

**Drill with:**
> "If this fails 18 months from now, what's the most likely reason? Not what could go wrong — what WILL go wrong if the idea is fundamentally flawed?"

---

### Branch 7: MVP

**What resolved looks like:**
- One shippable thing ("A Slack bot that, when you type `/incident similar`, queries your past PagerDuty incidents and returns the 3 most similar with their resolution notes")
- Tests the biggest risk ("This tests whether on-call engineers will actually use a new tool during an incident — the adoption risk")
- Build estimate ("2 weeks to build, 1 month to validate with 10 users")

**Not resolved:**
- "A simple version of the full product"
- A list of MVP features
- Something that doesn't test the riskiest assumption

**Drill with:**
> "What's the one thing you could build in 2 weeks that would prove the biggest risk wrong? Not 'a simple version' — what specific thing proves people will actually use this?"
