#!/usr/bin/env bash
# Integration Test: init-enhanced-workflow template-driven setup
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
TEMPLATE="$PLUGIN_DIR/skills/using-enhanced-workflow/docs-project-claude-template.md"
README_TEMPLATE="$PLUGIN_DIR/skills/using-enhanced-workflow/docs-superpowers-README-template.md"
WORKFLOW_TEMPLATE="$PLUGIN_DIR/skills/using-enhanced-workflow/docs-superpowers-workflow-template.md"
CONVENTIONS_TEMPLATE="$PLUGIN_DIR/skills/using-enhanced-workflow/docs-superpowers-conventions-template.md"
INIT_SKILL="$PLUGIN_DIR/skills/init-enhanced-workflow/SKILL.md"

FAILED=0

echo "========================================"
echo " init-enhanced-workflow template test"
echo "========================================"
echo ""

echo "Test 1: CLAUDE template file exists..."
if [ -f "$TEMPLATE" ]; then
  echo "  [PASS] template file exists"
else
  echo "  [FAIL] template file missing: $TEMPLATE"
  FAILED=$((FAILED + 1))
fi

echo ""
echo "Test 2: template contains start marker..."
if grep -q '<!-- ENHANCED-SUPERPOWERS:START -->' "$TEMPLATE" 2>/dev/null; then
  echo "  [PASS] start marker present"
else
  echo "  [FAIL] start marker missing"
  FAILED=$((FAILED + 1))
fi

echo ""
echo "Test 3: template contains end marker..."
if grep -q '<!-- ENHANCED-SUPERPOWERS:END -->' "$TEMPLATE" 2>/dev/null; then
  echo "  [PASS] end marker present"
else
  echo "  [FAIL] end marker missing"
  FAILED=$((FAILED + 1))
fi

echo ""
echo "Test 4: docs README template exists..."
if [ -f "$README_TEMPLATE" ]; then
  echo "  [PASS] README template exists"
else
  echo "  [FAIL] README template missing"
  FAILED=$((FAILED + 1))
fi

echo ""
echo "Test 5: docs workflow template exists..."
if [ -f "$WORKFLOW_TEMPLATE" ]; then
  echo "  [PASS] workflow template exists"
else
  echo "  [FAIL] workflow template missing"
  FAILED=$((FAILED + 1))
fi

echo ""
echo "Test 6: docs conventions template exists..."
if [ -f "$CONVENTIONS_TEMPLATE" ]; then
  echo "  [PASS] conventions template exists"
else
  echo "  [FAIL] conventions template missing"
  FAILED=$((FAILED + 1))
fi

echo ""
echo "Test 7: init skill references CLAUDE template file..."
if grep -q 'docs-project-claude-template.md' "$INIT_SKILL" 2>/dev/null; then
  echo "  [PASS] init skill references CLAUDE template"
else
  echo "  [FAIL] init skill does not reference CLAUDE template"
  FAILED=$((FAILED + 1))
fi

echo ""
echo "Test 8: init skill no longer embeds project CLAUDE workflow block..."
if grep -q '## Enhanced Superpowers Workflow' "$INIT_SKILL" 2>/dev/null; then
  echo "  [FAIL] init skill still embeds workflow block inline"
  FAILED=$((FAILED + 1))
else
  echo "  [PASS] inline workflow block removed"
fi

echo ""
echo "Test 9: init skill documents append behavior..."
if grep -q 'If `CLAUDE.md` already exists, append' "$INIT_SKILL" 2>/dev/null; then
  echo "  [PASS] append behavior documented"
else
  echo "  [FAIL] append behavior missing"
  FAILED=$((FAILED + 1))
fi

echo ""
echo "Test 10: runtime reference explains CLAUDE template ownership..."
RUNTIME_SKILL="$PLUGIN_DIR/skills/using-enhanced-workflow/SKILL.md"
if grep -q 'project `CLAUDE.md` template' "$RUNTIME_SKILL" 2>/dev/null; then
  echo "  [PASS] runtime reference mentions CLAUDE template ownership"
else
  echo "  [FAIL] runtime reference missing CLAUDE template ownership note"
  FAILED=$((FAILED + 1))
fi

echo ""
if [ $FAILED -eq 0 ]; then
  echo "STATUS: PASSED"
  exit 0
else
  echo "STATUS: FAILED"
  exit 1
fi
