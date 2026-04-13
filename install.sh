#!/bin/bash
SKILL=$1
mkdir -p .claude/skills/$SKILL
curl -sL "https://raw.githubusercontent.com/aneja5/forge-skills/main/skills/$SKILL/SKILL.md" \
  > .claude/skills/$SKILL/SKILL.md
echo "✓ Installed $SKILL"