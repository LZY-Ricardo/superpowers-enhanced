#!/usr/bin/env bash
#
# pre-commit hook: auto-sync Codex plugin files when source files change.
# Install: cp scripts/pre-commit-sync-codex.sh .git/hooks/pre-commit
#

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

# Check if any source files that affect the Codex plugin copy have changed
CHANGED=$(git diff --cached --name-only -- \
  "skills/" \
  "hooks/" \
  ".codex-plugin/" \
  "assets/" \
  "README.md" \
  "LICENSE" \
  2>/dev/null || true)

if [ -z "$CHANGED" ]; then
  exit 0
fi

echo "📦 Codex plugin source files changed, syncing to plugins/superpowers/ ..."

bash "$REPO_ROOT/scripts/sync-codex-plugin.sh"

git add "$REPO_ROOT/plugins/superpowers/"

echo "✅ Codex plugin files synced and staged."
