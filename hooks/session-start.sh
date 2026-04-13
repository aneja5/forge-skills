#!/bin/bash
# session-start.sh
# Injects the using-forge-skills meta-skill at every session start.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
META_SKILL="$PROJECT_DIR/skills/using-forge-skills/SKILL.md"

json_encode() {
  if command -v jq &>/dev/null; then
    printf '%s' "$1" | jq -Rs .
  elif command -v python3 &>/dev/null; then
    printf '%s' "$1" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))'
  else
    # Minimal fallback: escape backslashes, quotes, and newlines
    printf '"%s"' "$(printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g; s/$/\\n/g' | tr -d '\n')"
  fi
}

if [ -f "$META_SKILL" ]; then
  SKILL_CONTENT=$(cat "$META_SKILL")
  ENCODED=$(json_encode "$SKILL_CONTENT")
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
