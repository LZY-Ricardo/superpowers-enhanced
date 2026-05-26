#!/usr/bin/env bash
# Structural Test: status surface support
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
STATUS_TEMPLATE="$PLUGIN_DIR/skills/using-enhanced-workflow/docs-superpowers-status-template.md"

FAILED=0

echo "========================================"
echo " status surface test"
echo "========================================"
echo ""

[ -f "$STATUS_TEMPLATE" ] || FAILED=$((FAILED + 1))
for heading in '# Project Status' '## Current Artifact Links' '## Open Review Threads' '## Open Blockers' '## Next Recommended Action'; do
  grep -q "$heading" "$STATUS_TEMPLATE" || FAILED=$((FAILED + 1))
done

INIT_SKILL="$PLUGIN_DIR/skills/init-enhanced-workflow/SKILL.md"
grep -q 'docs-superpowers-status-template.md' "$INIT_SKILL" || FAILED=$((FAILED + 1))
grep -q 'docs/superpowers/status.md' "$INIT_SKILL" || FAILED=$((FAILED + 1))

RUNTIME_SKILL="$PLUGIN_DIR/skills/using-enhanced-workflow/SKILL.md"
README_DOC="$PLUGIN_DIR/docs/superpowers/README.md"
grep -q 'status.md' "$RUNTIME_SKILL" || FAILED=$((FAILED + 1))
grep -q 'status.md' "$README_DOC" || FAILED=$((FAILED + 1))

STATUS_DOC="$PLUGIN_DIR/docs/superpowers/status.md"
[ -f "$STATUS_DOC" ] || FAILED=$((FAILED + 1))
grep -q '# Project Status' "$STATUS_DOC" || FAILED=$((FAILED + 1))
grep -q 'Active sub-project' "$STATUS_DOC" || FAILED=$((FAILED + 1))
grep -q 'Current Artifact Links' "$STATUS_DOC" || FAILED=$((FAILED + 1))
grep -q 'Open Blockers' "$STATUS_DOC" || FAILED=$((FAILED + 1))
grep -q 'Next Recommended Action' "$STATUS_DOC" || FAILED=$((FAILED + 1))

echo "Test 1: status.md can serve as first recovery stop..."
grep -q 'Decomposition:' "$STATUS_DOC" || FAILED=$((FAILED + 1))
grep -q 'Current spec:' "$STATUS_DOC" || FAILED=$((FAILED + 1))
grep -q 'Current plan:' "$STATUS_DOC" || FAILED=$((FAILED + 1))
grep -q 'Next Recommended Action' "$STATUS_DOC" || FAILED=$((FAILED + 1))

if [ $FAILED -eq 0 ]; then
  echo "STATUS: PASSED"
  exit 0
else
  echo "STATUS: FAILED"
  exit 1
fi
