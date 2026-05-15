#!/usr/bin/env bash
# Quick .forge/ integrity check — runs without Claude Code.
# Usage: ./bin/forge-check.sh [.forge-directory]
#
# Verifies two things per tracked artifact:
#   1. content_hash matches the body's actual sha256 (catches manual edits → MODIFIED)
#   2. each generated_from snapshot still matches its upstream's current content_hash
#      (catches upstream drift → STALE)
#
# Exit codes:
#   0 = all clean
#   1 = at least one MODIFIED file
#   2 = at least one STALE file (and zero modified)
#
# Requires bash + shasum + awk + find. macOS-friendly (no sha256sum, no mapfile).

set -u

FORGE_DIR="${1:-.forge}"

if [ ! -d "$FORGE_DIR" ]; then
  echo "No $FORGE_DIR directory found." >&2
  exit 1
fi

# Extract a file's body — everything outside the forge:meta block.
# Markdown form: <!-- forge:meta ... -->
# YAML form:     # forge:meta\n#   ...  (consecutive leading-# block)
extract_body() {
  local file="$1"
  case "$file" in
    *.yaml|*.yml)
      awk '
        BEGIN { in_meta = 0; saw_meta = 0 }
        /^# forge:meta/ { in_meta = 1; saw_meta = 1; next }
        in_meta && /^#/ { next }
        in_meta && !/^#/ { in_meta = 0 }
        !in_meta { print }
      ' "$file"
      ;;
    *)
      awk '
        BEGIN { in_meta = 0 }
        /^<!-- forge:meta/ { in_meta = 1; next }
        in_meta && /-->/ { in_meta = 0; next }
        !in_meta { print }
      ' "$file"
      ;;
  esac
}

# First 8 hex chars of sha256 over the body.
body_hash() {
  extract_body "$1" | shasum -a 256 | cut -c1-8
}

# Pull a single-line scalar from the forge:meta block (e.g., content_hash).
meta_field() {
  local file="$1"
  local field="$2"
  awk -v f="$field" '
    /^<!-- forge:meta/ { in_meta = 1; next }
    in_meta && /-->/ { exit }
    /^# forge:meta/ { in_yaml = 1; next }
    in_yaml && !/^#/ { exit }
    (in_meta || in_yaml) && $0 ~ "^[# ]*" f ":" {
      v = $0
      sub("^[# ]*" f ":[ ]*", "", v)
      sub("[ ]*$", "", v)
      print v
      exit
    }
  ' "$file"
}

# Emit "path: hash" lines from the generated_from block.
generated_from_pairs() {
  local file="$1"
  awk '
    /^<!-- forge:meta/ { in_meta = 1; next }
    in_meta && /-->/ { exit }
    /^# forge:meta/ { in_yaml = 1; next }
    in_yaml && !/^#/ { exit }

    (in_meta || in_yaml) && /^[# ]*generated_from:/ { in_gf = 1; next }
    in_gf && /^[# ]*[a-z_]+:/ && !/\.forge\// { in_gf = 0 }

    in_gf && /\.forge\/.*:[ ]*[0-9a-f]/ {
      line = $0
      sub(/^[# ]*/, "", line)
      sub(/[ ]*$/, "", line)
      print line
    }
  ' "$file"
}

errors=0
stale=0
ok=0

while IFS= read -r file; do
  declared=$(meta_field "$file" "content_hash")
  if [ -z "$declared" ]; then
    continue  # untracked — no forge:meta header
  fi

  actual=$(body_hash "$file")

  if [ "$declared" != "$actual" ]; then
    echo "MODIFIED  $file (declared: $declared, actual: $actual)"
    errors=$((errors + 1))
    continue
  fi

  this_stale=0
  while IFS= read -r pair; do
    [ -z "$pair" ] && continue
    upstream_path=$(printf '%s' "$pair" | awk -F': *' '{print $1}')
    snapshot=$(printf '%s' "$pair" | awk -F': *' '{print $2}')
    if [ -f "$upstream_path" ]; then
      current=$(meta_field "$upstream_path" "content_hash")
      if [ -n "$current" ] && [ "$snapshot" != "$current" ]; then
        echo "STALE     $file (dep $upstream_path: snapshot $snapshot → now $current)"
        this_stale=1
        break
      fi
    fi
  done < <(generated_from_pairs "$file")

  if [ "$this_stale" -eq 1 ]; then
    stale=$((stale + 1))
  else
    ok=$((ok + 1))
  fi
done < <(find "$FORGE_DIR" \( -name '*.md' -o -name '*.yaml' -o -name '*.yml' \) | sort)

echo ""
echo "Results: $ok ok, $stale stale, $errors modified"

if [ "$errors" -gt 0 ]; then
  exit 1
elif [ "$stale" -gt 0 ]; then
  exit 2
fi
exit 0
