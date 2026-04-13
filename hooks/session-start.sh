#!/bin/bash
# session-start.sh
# Injects the using-forge-skills meta-skill at session start so Claude always knows the pipeline.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
META_SKILL="$PROJECT_DIR/skills/using-forge-skills/SKILL.md"

if [ -f "$META_SKILL" ]; then
  SKILL_CONTENT=$(cat "$META_SKILL")
  printf '%s' "{
    \"type\": \"text\",
    \"priority\": \"IMPORTANT\",
    \"message\": \"Use the skill discovery flowchart in using-forge-skills to find the right skill for your task. The forge pipeline is: /grill → /spec → /plan → /build → /ship.\",
    \"content\": $(printf '%s' "$SKILL_CONTENT" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')
  }"
else
  printf '%s' "{
    \"type\": \"text\",
    \"priority\": \"INFO\",
    \"message\": \"forge-skills: individual skills available in skills/. Run /grill to start.\"
  }"
fi
