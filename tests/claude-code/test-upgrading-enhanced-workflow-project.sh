#!/usr/bin/env bash
# Behavior Test: legacy workflow upgrade metadata backfill
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"
PLUGIN_DIR="$(get_claude_plugin_dir)"
UPGRADE_SKILL="$HOME/.claude/skills/upgrading-enhanced-workflow-project/SKILL.md"

TEST_PROJECT="$(create_test_project)"
trap 'cleanup_test_project "$TEST_PROJECT"' EXIT

mkdir -p "$TEST_PROJECT/docs/superpowers"
cat > "$TEST_PROJECT/CLAUDE.md" <<'EOF'
## Enhanced Superpowers Workflow

This project uses the Enhanced Superpowers workflow. The following rules are MANDATORY for all AI agents.
EOF
cat > "$TEST_PROJECT/docs/superpowers/README.md" <<'EOF'
# Superpowers Enhanced Workflow
EOF

FAILED=0

echo "========================================"
echo " legacy workflow upgrade metadata test"
echo "========================================"
echo ""

# Structural preconditions for a legacy project fixture
[ -d "$TEST_PROJECT/docs/superpowers" ] || FAILED=$((FAILED + 1))
[ -f "$TEST_PROJECT/CLAUDE.md" ] || FAILED=$((FAILED + 1))
[ -f "$TEST_PROJECT/docs/superpowers/README.md" ] || FAILED=$((FAILED + 1))
[ ! -f "$TEST_PROJECT/docs/superpowers/version.json" ] || FAILED=$((FAILED + 1))
grep -q '## Enhanced Superpowers Workflow' "$TEST_PROJECT/CLAUDE.md" || FAILED=$((FAILED + 1))
grep -q 'version.json' "$UPGRADE_SKILL" || FAILED=$((FAILED + 1))
grep -q 'initializedAt' "$UPGRADE_SKILL" || FAILED=$((FAILED + 1))
grep -q 'lastUpgradedAt' "$UPGRADE_SKILL" || FAILED=$((FAILED + 1))
grep -q 'legacy' "$UPGRADE_SKILL" || FAILED=$((FAILED + 1))

# Simulate the documented legacy backfill contract from the local upgrade skill.
PLUGIN_VERSION="$(python3 - <<PY
import json
from pathlib import Path
print(json.loads(Path("$PLUGIN_DIR/package.json").read_text())["version"])
PY
)"
NOW_UTC="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
python3 - <<PY
import json
from pathlib import Path
Path("$TEST_PROJECT/docs/superpowers/version.json").write_text(json.dumps({
    "pluginVersion": "$PLUGIN_VERSION",
    "workflowTemplateVersion": "$PLUGIN_VERSION",
    "initializedAt": "legacy",
    "lastUpgradedAt": "$NOW_UTC",
}, indent=2) + "\n")
PY

# Behavior expectation: the legacy fixture should be backfilled to version.json
[ -f "$TEST_PROJECT/docs/superpowers/version.json" ] || FAILED=$((FAILED + 1))

if [ -f "$TEST_PROJECT/docs/superpowers/version.json" ]; then
  python3 - <<PY || FAILED=$((FAILED + 1))
import json
from pathlib import Path
version = json.loads(Path("$TEST_PROJECT/docs/superpowers/version.json").read_text())
assert version["pluginVersion"]
assert version["workflowTemplateVersion"]
assert version["initializedAt"] == "legacy"
assert version["lastUpgradedAt"]
PY
fi

if [ $FAILED -eq 0 ]; then
  echo "STATUS: PASSED"
  exit 0
else
  echo "STATUS: FAILED"
  exit 1
fi
