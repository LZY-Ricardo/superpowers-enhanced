#!/usr/bin/env bash
# Structural Test: decomposing-requirements status tracking
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILL_FILE="$PLUGIN_DIR/skills/decomposing-requirements/SKILL.md"

FAILED=0

echo "========================================"
echo " decomposing-requirements status test"
echo "========================================"
echo ""

echo "Test 1: skill includes Sub-project Overview..."
grep -q 'Sub-project Overview' "$SKILL_FILE" || FAILED=$((FAILED + 1))

echo "Test 2: skill includes Status field..."
grep -q 'Status' "$SKILL_FILE" || FAILED=$((FAILED + 1))

echo "Test 3: skill includes Priority field..."
grep -q 'Priority' "$SKILL_FILE" || FAILED=$((FAILED + 1))

echo "Test 4: skill includes Next Step field..."
grep -q 'Next Step' "$SKILL_FILE" || FAILED=$((FAILED + 1))

echo "Test 5: skill includes lightweight status set..."
for status in 'Pending' 'In Progress' 'Blocked' 'Completed' 'Deferred' 'Skipped'; do
  grep -q "$status" "$SKILL_FILE" || FAILED=$((FAILED + 1))
done

echo "Test 6: skill defines manual update triggers..."
grep -q 'sub-project becomes active' "$SKILL_FILE" || FAILED=$((FAILED + 1))
grep -q 'sub-project completes' "$SKILL_FILE" || FAILED=$((FAILED + 1))
grep -q 'deferred or skipped' "$SKILL_FILE" || FAILED=$((FAILED + 1))
grep -q 'dependency order changes' "$SKILL_FILE" || FAILED=$((FAILED + 1))
grep -q 'next sub-project changes' "$SKILL_FILE" || FAILED=$((FAILED + 1))

echo "Test 7: skill defines main-session ownership..."
grep -q 'maintained by the \*\*main session\*\*' "$SKILL_FILE" || FAILED=$((FAILED + 1))

echo "Test 8: active decomposition doc includes overview table..."
DOC_FILE="$PLUGIN_DIR/docs/superpowers/decomposition/2026-05-25-workflow-engineering-upgrade.md"
grep -q '## Sub-project Overview' "$DOC_FILE" || FAILED=$((FAILED + 1))

echo "Test 9: active decomposition doc includes Status field..."
grep -q '\*\*Status:\*\*' "$DOC_FILE" || FAILED=$((FAILED + 1))

echo "Test 10: active decomposition doc includes Priority field..."
grep -q '\*\*Priority:\*\*' "$DOC_FILE" || FAILED=$((FAILED + 1))

echo "Test 11: active decomposition doc includes Next Step field..."
grep -q '\*\*Next Step:\*\*' "$DOC_FILE" || FAILED=$((FAILED + 1))

echo ""
if [ $FAILED -eq 0 ]; then
  echo "STATUS: PASSED"
  exit 0
else
  echo "STATUS: FAILED"
  exit 1
fi
