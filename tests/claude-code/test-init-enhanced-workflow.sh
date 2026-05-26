#!/usr/bin/env bash
# Integration Test: init-enhanced-workflow template-driven setup
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"
TEMPLATE="$PLUGIN_DIR/skills/using-enhanced-workflow/docs-project-claude-template.md"
README_TEMPLATE="$PLUGIN_DIR/skills/using-enhanced-workflow/docs-superpowers-README-template.md"
WORKFLOW_TEMPLATE="$PLUGIN_DIR/skills/using-enhanced-workflow/docs-superpowers-workflow-template.md"
CONVENTIONS_TEMPLATE="$PLUGIN_DIR/skills/using-enhanced-workflow/docs-superpowers-conventions-template.md"
STATUS_TEMPLATE="$PLUGIN_DIR/skills/using-enhanced-workflow/docs-superpowers-status-template.md"
VERSION_TEMPLATE="$PLUGIN_DIR/skills/using-enhanced-workflow/docs-superpowers-version-template.json"
PACKAGE_JSON="$PLUGIN_DIR/package.json"
INIT_SKILL="$PLUGIN_DIR/skills/init-enhanced-workflow/SKILL.md"

run_init_behavior_scenario() {
  local project_dir="$1"

  if [ ! -d "$project_dir/.git" ]; then
    echo "  temp project is not initialized as a git repository" >&2
    return 1
  fi

  local plugin_version
  plugin_version="$(python3 - <<PY
import json
from pathlib import Path
print(json.loads(Path("$PACKAGE_JSON").read_text())["version"])
PY
)"

  (
    set -euo pipefail
    cd "$project_dir"

    mkdir -p docs/superpowers/{decomposition,specs,plans,execution-log,debugging-log,review-log,completion}

    if [ -f CLAUDE.md ]; then
      printf '\n\n' >> CLAUDE.md
      cat "$TEMPLATE" >> CLAUDE.md
    else
      cp "$TEMPLATE" CLAUDE.md
    fi

    cp "$README_TEMPLATE" docs/superpowers/README.md
    cp "$WORKFLOW_TEMPLATE" docs/superpowers/workflow.md
    cp "$CONVENTIONS_TEMPLATE" docs/superpowers/conventions.md
    cp "$STATUS_TEMPLATE" docs/superpowers/status.md

    local now_utc
    now_utc="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

    python3 - <<PY
import json
from pathlib import Path

template = json.loads(Path("$VERSION_TEMPLATE").read_text())
for key in ("pluginVersion", "workflowTemplateVersion"):
    template[key] = "$plugin_version"
for key in ("initializedAt", "lastUpgradedAt"):
    template[key] = "$now_utc"
Path("docs/superpowers/version.json").write_text(json.dumps(template, indent=2) + "\n")
PY
  )
}

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
echo "Test 7: version template exists..."
if [ -f "$VERSION_TEMPLATE" ]; then
  echo "  [PASS] version template exists"
else
  echo "  [FAIL] version template missing"
  FAILED=$((FAILED + 1))
fi

echo ""
echo "Test 8: version template contains required keys..."
if grep -q '"pluginVersion"' "$VERSION_TEMPLATE" 2>/dev/null \
  && grep -q '"workflowTemplateVersion"' "$VERSION_TEMPLATE" 2>/dev/null \
  && grep -q '"initializedAt"' "$VERSION_TEMPLATE" 2>/dev/null \
  && grep -q '"lastUpgradedAt"' "$VERSION_TEMPLATE" 2>/dev/null; then
  echo "  [PASS] version template keys present"
else
  echo "  [FAIL] version template keys missing"
  FAILED=$((FAILED + 1))
fi

echo ""
echo "Test 9: init skill references version template file..."
if grep -q 'docs-superpowers-version-template.json' "$INIT_SKILL" 2>/dev/null; then
  echo "  [PASS] init skill references version template"
else
  echo "  [FAIL] init skill does not reference version template"
  FAILED=$((FAILED + 1))
fi

echo ""
echo "Test 10: init skill writes docs/superpowers/version.json..."
if grep -q 'docs/superpowers/version.json' "$INIT_SKILL" 2>/dev/null; then
  echo "  [PASS] init skill documents version.json output"
else
  echo "  [FAIL] init skill does not document version.json output"
  FAILED=$((FAILED + 1))
fi

echo ""
echo "Test 11: init skill references CLAUDE template file..."
if grep -q 'docs-project-claude-template.md' "$INIT_SKILL" 2>/dev/null; then
  echo "  [PASS] init skill references CLAUDE template"
else
  echo "  [FAIL] init skill does not reference CLAUDE template"
  FAILED=$((FAILED + 1))
fi

echo ""
echo "Test 12: init skill no longer embeds project CLAUDE workflow block..."
if grep -q '## Enhanced Superpowers Workflow' "$INIT_SKILL" 2>/dev/null; then
  echo "  [FAIL] init skill still embeds workflow block inline"
  FAILED=$((FAILED + 1))
else
  echo "  [PASS] inline workflow block removed"
fi

echo ""
echo "Test 13: init skill documents append behavior..."
if grep -q 'If `CLAUDE.md` already exists, append' "$INIT_SKILL" 2>/dev/null; then
  echo "  [PASS] append behavior documented"
else
  echo "  [FAIL] append behavior missing"
  FAILED=$((FAILED + 1))
fi

echo ""
echo "Test 14: runtime reference explains CLAUDE template ownership..."
RUNTIME_SKILL="$PLUGIN_DIR/skills/using-enhanced-workflow/SKILL.md"
if grep -q 'project `CLAUDE.md` template' "$RUNTIME_SKILL" 2>/dev/null; then
  echo "  [PASS] runtime reference mentions CLAUDE template ownership"
else
  echo "  [FAIL] runtime reference missing CLAUDE template ownership note"
  FAILED=$((FAILED + 1))
fi

echo ""
echo "Test 15: metadata semantics mention workflowTemplateVersion..."
if grep -q 'workflowTemplateVersion' "$RUNTIME_SKILL" 2>/dev/null || grep -q 'workflowTemplateVersion' "$PLUGIN_DIR/ENHANCED.md" 2>/dev/null; then
  echo "  [PASS] metadata semantics documented"
else
  echo "  [FAIL] metadata semantics missing"
  FAILED=$((FAILED + 1))
fi

echo ""
echo "Test 16: temp project init creates expected guidance artifacts..."
behavior_test_dir="$(create_test_project)"
trap 'cleanup_test_project "$behavior_test_dir"' EXIT

mkdir -p "$behavior_test_dir/.git"
if [ -f "$behavior_test_dir/CLAUDE.md" ]; then
  echo "  [FAIL] temp project unexpectedly already has CLAUDE.md"
  FAILED=$((FAILED + 1))
else
  if run_init_behavior_scenario "$behavior_test_dir"; then
    expected_files=(
      "$behavior_test_dir/CLAUDE.md"
      "$behavior_test_dir/docs/superpowers/README.md"
      "$behavior_test_dir/docs/superpowers/workflow.md"
      "$behavior_test_dir/docs/superpowers/conventions.md"
      "$behavior_test_dir/docs/superpowers/status.md"
      "$behavior_test_dir/docs/superpowers/version.json"
    )

    missing=0
    for file in "${expected_files[@]}"; do
      if [ ! -f "$file" ]; then
        echo "  [FAIL] missing expected artifact: $file"
        missing=1
      fi
    done

    if [ "$missing" -eq 0 ] \
      && cmp -s "$TEMPLATE" "$behavior_test_dir/CLAUDE.md" \
      && cmp -s "$README_TEMPLATE" "$behavior_test_dir/docs/superpowers/README.md" \
      && cmp -s "$WORKFLOW_TEMPLATE" "$behavior_test_dir/docs/superpowers/workflow.md" \
      && cmp -s "$CONVENTIONS_TEMPLATE" "$behavior_test_dir/docs/superpowers/conventions.md" \
      && cmp -s "$STATUS_TEMPLATE" "$behavior_test_dir/docs/superpowers/status.md"; then
      plugin_version="$(python3 - <<PY
import json
from pathlib import Path
print(json.loads(Path("$PACKAGE_JSON").read_text())["version"])
PY
)"

      if python3 - <<PY
import json
import re
from pathlib import Path

version = json.loads(Path("$behavior_test_dir/docs/superpowers/version.json").read_text())
plugin_version = "$plugin_version"
pattern = re.compile(r'^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}Z$')
assert version["pluginVersion"] == plugin_version
assert version["workflowTemplateVersion"] == plugin_version
assert pattern.match(version["initializedAt"])
assert pattern.match(version["lastUpgradedAt"])
assert version["initializedAt"] == version["lastUpgradedAt"]
PY
      then
        echo "  [PASS] temp project init contract materialized expected artifacts"
      else
        echo "  [FAIL] version.json contents did not match init contract"
        FAILED=$((FAILED + 1))
      fi
    else
      echo "  [FAIL] guidance artifacts did not match canonical templates"
      FAILED=$((FAILED + 1))
    fi
  else
    echo "  [FAIL] temp project init scenario did not complete"
    FAILED=$((FAILED + 1))
  fi
fi

if [ $FAILED -eq 0 ]; then
  echo "STATUS: PASSED"
  exit 0
else
  echo "STATUS: FAILED"
  exit 1
fi
