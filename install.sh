#!/bin/bash
# forge-skills installer
# Usage: bash install.sh <skill-name>
# Available skills: idea-griller, spec-driven-development, architecture-and-contracts,
#                   planning-and-task-breakdown, incremental-implementation, tdd,
#                   debugging-and-recovery, code-review-and-quality, git-workflow,
#                   shipping-and-launch, triage-issue, using-forge-skills

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
  echo "  using-forge-skills         — meta-skill: skill discovery + pipeline"
  exit 1
fi

DEST=".claude/skills/$SKILL"
mkdir -p "$DEST"

echo "Installing $SKILL..."
curl -sL "$BASE_URL/skills/$SKILL/SKILL.md" -o "$DEST/SKILL.md"

# Install supporting files for skills that have them
case "$SKILL" in
  idea-griller)
    curl -sL "$BASE_URL/skills/$SKILL/evaluation-criteria.md" -o "$DEST/evaluation-criteria.md"
    ;;
  tdd)
    for f in deep-modules.md interface-design.md mocking.md refactoring.md tests.md; do
      curl -sL "$BASE_URL/skills/$SKILL/$f" -o "$DEST/$f"
    done
    ;;
esac

echo "✓ Installed $SKILL to $DEST"
