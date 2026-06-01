#!/usr/bin/env bash
#
# sync-codex-plugin.sh
#
# Copy essential plugin files into plugins/superpowers/ for Codex marketplace
# discovery. Run this before each release to keep the Codex plugin copy in sync.
#
# Usage:
#   ./scripts/sync-codex-plugin.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DEST="$ROOT/plugins/superpowers"

echo "Syncing plugin files to $DEST ..."

rm -rf "$DEST"
mkdir -p "$DEST"

# Essential plugin files for Codex
cp -R "$ROOT/.codex-plugin" "$DEST/"
cp -R "$ROOT/skills"        "$DEST/"
cp -R "$ROOT/hooks"         "$DEST/"
cp -R "$ROOT/assets"        "$DEST/"
cp    "$ROOT/README.md"     "$DEST/"
cp    "$ROOT/LICENSE"       "$DEST/"

# Remove leftover symlinks if any (from old approach)
find "$DEST" -type l -delete 2>/dev/null || true

echo "Done. Codex plugin files synced to $DEST"
echo "Files:"
find "$DEST" -maxdepth 2 -type f | head -20
