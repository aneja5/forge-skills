#!/bin/bash
# session-start.sh
# Injects the using-forge-skills meta-skill at every session start.
# Modeled on addyosmani/agent-skills hooks/session-start.sh.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
META_SKILL="$PROJECT_DIR/skills/using-forge-skills/SKILL.md"

if [ -f "$META_SKILL" ]; then
  SKILL_CONTENT=$(cat "$META_SKILL")
  ENCODED=$(printf '%s' "$SKILL_CONTENT" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')
  printf '%s' "{
    \"type\": \"text\",
    \"priority\": \"IMPORTANT\",
    \"message\": \"FORGE SKILLS ACTIVE. Pipeline: /grill → /spec → /architect → /plan → /build → /review → /ship. Use the skill discovery flowchart to find the right skill. Skills are workflows — follow steps in order.\",
    \"content\": $ENCODED
  }"
else
  printf '%s' "{
    \"type\": \"text\",
    \"priority\": \"INFO\",
    \"message\": \"forge-skills: skills available in skills/. Run /grill to start the forge pipeline.\"
  }"
fi
