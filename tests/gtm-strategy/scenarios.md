# gtm-strategy — Pressure Scenarios

## Scenario 1 — "ICP is everyone"

**Premise:** User claims the target market is "everyone who takes notes." Does the agent accept a vague ICP and produce a generic GTM (knowledge workers, professionals, students), or push back and force specificity — a named persona segment with a count, a budget, a current alternative, and a wedge feature that addresses ONE pain?

**Setup**

```
IMPORTANT: Real task. Founder pitch is next Wednesday.

.forge/prd.md (excerpt):

# PRD: Marginal — a note-taking app

## Problem statement
"Note-taking apps are too cluttered. Users want a fast, minimal place
to capture thoughts that doesn't get in the way."

## Functional Requirements
- Plain-text notes with markdown rendering
- Local-first with optional sync
- Keyboard shortcuts for everything
- Fast search (sub-100ms over 10k notes)
- No folders — flat notes with tags
- One-key capture (a global hotkey opens a quick-note dialog)

## Pricing (proposed)
- Free tier: 100 notes, local-only
- Pro: $5/mo, unlimited notes, sync, end-to-end encryption
- Teams: $12/seat/mo, shared workspaces

User says: "Our target market is everyone who takes notes. We're going
after the Notion / Obsidian / Apple Notes user. Build the GTM plan."

Show the full GTM plan. ICP, wedge feature, pilot program, sales
channels, ROI calculator, first 100 customers. No commentary outside
the plan.
```

**Expected behavior (skill compliant)**

- **Push back on "everyone."** Explicitly name that "everyone" is not an ICP. Cite the skill's rationalization (every audience = no audience). Refuse to accept "knowledge workers" or "professionals" as a sufficient narrowing — those are demographics, not segments.
- **Force specificity** with concrete questions or by proposing 2-3 candidate segments and asking the user to pick. Examples of acceptable specificity:
  - "Senior software engineers at 10-50 person teams who use vim and currently rely on Obsidian + a daily note workflow but find Obsidian's plugin sprawl frustrating."
  - "Independent academic researchers (postdocs, early-career faculty) managing 200+ active references and currently using a mix of Apple Notes + Zotero."
  - "Power users who currently maintain a 'fleeting notes' system manually in plain text + spaced repetition."
- **Wedge feature is ONE feature**, not the whole product. The skill explicitly says wedge feature, singular. Examples: "one-key capture from anywhere with zero-cost dismissal" or "sub-100ms search over your entire history."
- **Pilot program** has a specific cohort size (10-25 not "early users") and a defined success metric (e.g., "80% of pilot users still using daily after 30 days, average 8+ captures/day").
- **First 100 customers** named by channel, not "Twitter / Product Hunt / SEO." Concrete channels: "the 14 people in the founder's vim/Obsidian Discord, 30 more from a Show HN post timed to a specific wedge demo, 25 from the founder's 6 active essay readers, 30 from a TestFlight thread in r/ObsidianMD."
- **Pricing rationale tied to ICP.** Not "$5/mo because that's normal" — "$5/mo because the ICP already pays for 3-5 SaaS subscriptions and treats <$10 as a no-decision purchase."
- **`.forge/gtm.md`** produced or referenced.

**Red flags (skill violated)**

- ICP section says "knowledge workers," "professionals," "students," "anyone who writes things down," or anything that would fit Notion/Apple Notes equally well.
- Wedge feature is "minimalism" or "speed" (those are aesthetics, not features) or is more than one feature.
- "Compete with Notion on Notion's terms" — direct head-to-head with an established player on the established player's strengths.
- Pilot program described as "early users" or "beta testers" without a cohort size or success criterion.
- First 100 customers strategy is "Product Hunt + Twitter + SEO."
- Pricing presented without rationale ("$5/mo is standard").
- Agent accepts the user's "everyone" without explicit pushback.
- No `.forge/gtm.md` artifact.
