#!/bin/bash
# forge-skills installer
# Usage: bash install.sh <skill-name>
# Available skills: idea-griller, spec-driven-development, architecture-and-contracts,
#                   planning-and-task-breakdown, incremental-implementation, tdd,
#                   debugging-and-recovery, code-review-and-quality, git-workflow,
#                   shipping-and-launch, triage-issue, competitive-analysis,
#                   gtm-strategy, security-and-compliance, scalability-analysis,
#                   cross-validation, redaction-and-cleanup, api-design,
#                   database-design, design-system, interaction-patterns,
#                   parallel-execution-strategy, seed-data-and-fixtures,
#                   testing-strategy, error-handling-and-resilience, observability,
#                   performance-and-cost-optimization, incident-response-and-postmortems,
#                   accessibility, refactoring-and-tech-debt, demo-narrative,
#                   documentation-hygiene, writing-skills, forge-sync,
#                   forge-migrate, feedback, brand-and-identity, component-library,
#                   page-composition, data-visualization, visual-polish, using-forge-skills

set -e

SKILL=$1
BASE_URL="https://raw.githubusercontent.com/aneja5/forge-skills/main"

if [ -z "$SKILL" ]; then
  echo "Usage: bash install.sh <skill-name>"
  echo ""
  echo "Available skills:"
  echo "  idea-griller               — 7-branch Socratic interview"
  echo "  spec-driven-development    — PRD via interview + codebase exploration"
  echo "  architecture-and-contracts — system design + interface contracts"
  echo "  planning-and-task-breakdown — sized vertical slice task plan"
  echo "  incremental-implementation — execute tasks with TDD discipline"
  echo "  tdd                        — red-green-refactor workflow"
  echo "  debugging-and-recovery     — reproduce → fix → guard"
  echo "  code-review-and-quality    — five-axis review + contract compliance"
  echo "  git-workflow               — atomic commits, branch strategy"
  echo "  shipping-and-launch        — six-domain pre-launch gate"
  echo "  triage-issue               — bug investigation + fix plan"
  echo "  competitive-analysis       — market research + positioning"
  echo "  gtm-strategy               — go-to-market plan + ICP"
  echo "  security-and-compliance    — auth, PII, threat model, certification"
  echo "  scalability-analysis       — capacity math + cost projections"
  echo "  cross-validation           — external reviewer prompt + synthesis"
  echo "  redaction-and-cleanup      — redact .forge/ for external sharing"
  echo "  api-design                 — REST conventions, error envelopes, versioning"
  echo "  database-design            — schema + migrations + query review"
  echo "  design-system              — semantic tokens + component library"
  echo "  interaction-patterns       — modal vs sheet, expand vs nav, tap targets"
  echo "  parallel-execution-strategy — multi-agent dispatch from tasks.yaml"
  echo "  seed-data-and-fixtures     — realistic demo + test data"
  echo "  testing-strategy           — test pyramid + coverage targets + flake policy"
  echo "  error-handling-and-resilience — retries, timeouts, circuit breakers"
  echo "  observability              — logs + traces + metrics + alerts"
  echo "  performance-and-cost-optimization — latency + LLM cost budgets"
  echo "  incident-response-and-postmortems — severity, runbooks, postmortems"
  echo "  accessibility              — WCAG AA baseline + keyboard + screen reader"
  echo "  refactoring-and-tech-debt  — debt registry + strangler-fig rewrites"
  echo "  demo-narrative             — demo script + scenes + fallbacks"
  echo "  documentation-hygiene      — README, changelog, doc-rot prevention"
  echo "  writing-skills             — meta-skill: TDD for new skill contributions"
  echo "  forge-sync                 — check .forge/ artifact freshness + cascade order"
  echo "  forge-migrate              — backfill forge:meta headers on legacy .forge/ files"
  echo "  feedback                   — file reverse-cascade entries when downstream finds upstream needs fixing"
  echo "  brand-and-identity         — brand essence, voice, logo, icon system"
  echo "  component-library          — component catalog with props, states, accessibility"
  echo "  page-composition           — page templates + responsive collapse strategy"
  echo "  data-visualization         — chart selection, color encoding, dashboard conventions"
  echo "  visual-polish              — quality pass before demo/ship (states, skeletons, meta, dark mode)"
  echo "  using-forge-skills         — meta-skill: skill discovery + pipeline"
  exit 1
fi

DEST=".claude/skills/$SKILL"
mkdir -p "$DEST"

echo "Installing $SKILL..."
curl -fsSL "$BASE_URL/skills/$SKILL/SKILL.md" -o "$DEST/SKILL.md"

# Install supporting files for skills that have them
case "$SKILL" in
  idea-griller)
    curl -fsSL "$BASE_URL/skills/$SKILL/evaluation-criteria.md" -o "$DEST/evaluation-criteria.md"
    ;;
  tdd)
    for f in deep-modules.md interface-design.md mocking.md refactoring.md tests.md; do
      curl -fsSL "$BASE_URL/skills/$SKILL/$f" -o "$DEST/$f"
    done
    ;;
esac

# Post-install verification (issue #33)
# Catch silent-failure modes where curl returned empty/error pages but the file was still written.
verify_install() {
  local target="$DEST/SKILL.md"

  if [ ! -f "$target" ]; then
    echo "✗ Install failed: $target not written"
    return 1
  fi

  if [ ! -s "$target" ]; then
    echo "✗ Install failed: $target is empty (network error or 404?)"
    rm -f "$target"
    return 1
  fi

  if ! head -1 "$target" | grep -q '^---$'; then
    echo "✗ Install failed: $target does not start with YAML frontmatter (got an error page instead?)"
    head -3 "$target"
    rm -f "$target"
    return 1
  fi

  if ! grep -q "^name: " "$target"; then
    echo "✗ Install failed: $target missing 'name:' field in frontmatter"
    rm -f "$target"
    return 1
  fi

  return 0
}

if verify_install; then
  echo "✓ Installed $SKILL to $DEST"
else
  echo ""
  echo "Troubleshooting:"
  echo "  • Check network: curl -I $BASE_URL/skills/$SKILL/SKILL.md"
  echo "  • Verify skill name spelling against the list above"
  echo "  • Re-run this script after fixing"
  exit 1
fi
