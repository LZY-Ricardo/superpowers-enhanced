---
name: installing-superpowers-enhanced
description: Use when installing or upgrading Superpowers Enhanced plugin — covers both /plugin command and manual installation, including marketplace registration, plugin config, and verification steps.
---

# Installing Superpowers Enhanced

Guide for installing the enhanced fork as a Claude Code plugin. Covers the standard `/plugin` command method and the manual fallback method.

**Announce at start:** "I'm using the installing-superpowers-enhanced skill to set up the plugin."

## When to Use

- First-time installation of Superpowers Enhanced
- Replacing the original superpowers with the enhanced fork
- Installing on a new machine
- Troubleshooting a failed installation

## Prerequisites

- Claude Code installed
- Git available
- Access to `https://github.com/LZY-Ricardo/superpowers-enhanced` (HTTPS or SSH)

## Method 1: /plugin Command (Preferred)

### Step 1: Remove Original (if installed)

```
/plugin uninstall superpowers
```

If installed globally and the command doesn't find it, try:

```
/plugin uninstall superpowers@claude-plugins-official --user
```

If commands fail, proceed to Method 2 (manual removal is included).

### Step 2: Install Enhanced

```
/plugin install https://github.com/LZY-Ricardo/superpowers-enhanced.git
```

### Step 3: Verify

Restart Claude Code, then check if skills are loaded. You should see 22 skills (14 original + 8 enhanced) prefixed with `superpowers:`.

If Method 1 works, you're done. If it fails (marketplace not found, network timeout, etc.), proceed to Method 2.

## Method 2: Manual Installation

Use this when `/plugin` commands fail or when you need full control over the installation.

### Step 1: Remove Original Plugin

Edit `~/.claude/plugins/installed_plugins.json` — remove the entry with key `"superpowers@claude-plugins-official"`.

Remove from `~/.claude/settings.json` `enabledPlugins` if present:

```json
// Remove this line if it exists:
"superpowers@claude-plugins-official": true
```

### Step 2: Clone the Repository

```bash
# Use SSH if HTTPS is unstable
git clone git@github.com:LZY-Ricardo/superpowers-enhanced.git ~/.claude/plugins/cache/superpowers-enhanced/latest

# Or HTTPS
git clone https://github.com/LZY-Ricardo/superpowers-enhanced.git ~/.claude/plugins/cache/superpowers-enhanced/latest

# Ensure on main branch
cd ~/.claude/plugins/cache/superpowers-enhanced/latest && git checkout main
```

### Step 3: Register Marketplace

Edit `~/.claude/plugins/known_marketplaces.json` — add entry:

```json
"superpowers-enhanced": {
  "source": {
    "source": "github",
    "repo": "LZY-Ricardo/superpowers-enhanced"
  },
  "installLocation": "<PATH_TO_CLONE>",
  "lastUpdated": "<CURRENT_TIMESTAMP>"
}
```

Replace `<PATH_TO_CLONE>` with the absolute path from Step 2 (e.g., `/Users/you/.claude/plugins/cache/superpowers-enhanced/latest`).

Replace `<CURRENT_TIMESTAMP>` with ISO 8601 format (e.g., `"2026-05-25T03:00:00.000Z"`).

### Step 4: Symlink to Marketplaces Directory

```bash
ln -s ~/.claude/plugins/cache/superpowers-enhanced/latest ~/.claude/plugins/marketplaces/superpowers-enhanced
```

### Step 5: Register Plugin

Edit `~/.claude/plugins/installed_plugins.json` — add entry:

```json
"superpowers@superpowers-enhanced": [
  {
    "scope": "user",
    "installPath": "<PATH_TO_CLONE>",
    "version": "5.1.0",
    "installedAt": "<CURRENT_TIMESTAMP>",
    "lastUpdated": "<CURRENT_TIMESTAMP>",
    "gitCommitSha": "<LATEST_COMMIT_SHA>"
  }
]
```

Get the latest commit SHA:

```bash
git -C ~/.claude/plugins/cache/superpowers-enhanced/latest rev-parse HEAD
```

### Step 6: Enable Plugin

Edit `~/.claude/settings.json` — add to `enabledPlugins`:

```json
"enabledPlugins": {
  "superpowers@superpowers-enhanced": true
}
```

Keep any existing entries.

### Step 7: Restart and Verify

1. Restart Claude Code completely
2. Send: "告诉我你有哪些 superpowers skills"
3. Confirm 22 skills are listed (14 original + 8 enhanced)

## Verification Checklist

After installation, verify each point:

- [ ] `superpowers:using-superpowers` appears in skill list (bootstrap loads)
- [ ] `superpowers:brainstorming` appears (original skills work)
- [ ] `superpowers:using-enhanced-workflow` appears (enhanced skills work)
- [ ] `superpowers:documenting-execution` appears (documenting skills work)
- [ ] `/superpowers:using-enhanced-workflow` loads full workflow content

If any check fails, the plugin is not fully loaded. Review Steps 3-6.

## Post-Install: Clean Up Local Skills

If you previously had enhanced skills installed at `~/.claude/skills/`, remove them to avoid duplicates:

```bash
rm -rf ~/.claude/skills/decomposing-requirements
rm -rf ~/.claude/skills/init-enhanced-workflow
rm -rf ~/.claude/skills/using-enhanced-workflow
rm -rf ~/.claude/skills/documenting-execution
rm -rf ~/.claude/skills/documenting-verification
rm -rf ~/.claude/skills/documenting-debugging
rm -rf ~/.claude/skills/documenting-review
rm -rf ~/.claude/skills/documenting-completion
```

Also remove their references from `~/.claude/CLAUDE.md` Skill Inventory table if present.

## Updating

To update to the latest version:

```bash
cd ~/.claude/plugins/cache/superpowers-enhanced/latest
git pull origin main

# Update commit SHA in installed_plugins.json
git rev-parse HEAD  # use this value
```

Restart Claude Code after updating.

## Red Flags

| Thought | Reality |
|---------|---------|
| "I'll just copy skills to ~/.claude/skills/" | Skills there bypass the plugin system. Use plugin installation instead. |
| "HTTPS clone timed out, it's broken" | Try SSH (`git@github.com:...`). Some networks block GitHub HTTPS. |
| "/plugin uninstall says not found" | Original plugin may be globally installed. Use manual removal (Method 2 Step 1). |
| "Skills show up but enhanced ones don't" | Check `known_marketplaces.json` — the marketplace registration is required. |
| "I'll skip the symlink step" | The symlink in marketplaces/ is needed for the plugin system to resolve the marketplace. |
