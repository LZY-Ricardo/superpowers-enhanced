# Getting Started with Superpowers Enhanced

This is the quickest practical guide for installing and using Superpowers Enhanced.

## 1. Install the plugin (Claude Code)

Run these two commands in Claude Code:

### Step 1: Register the marketplace

```text
/plugin marketplace add LZY-Ricardo/superpowers-enhanced
```

### Step 2: Install the plugin

```text
/plugin install superpowers@superpowers-enhanced
```

### Step 3: Reload plugins

```text
/reload-plugins
```

That's it — three commands. No manual file editing required.

## 1b. Install the plugin (Codex CLI / App)

### Step 1: Register the marketplace

```bash
codex plugin marketplace add LZY-Ricardo/superpowers-enhanced
```

### Step 2: Install the plugin

```bash
codex plugin add superpowers@superpowers-enhanced
```

Or use the interactive plugin browser: type `/plugins`, switch to the **Superpowers Enhanced** marketplace tab, and select `Install Plugin`.

### Step 3 (Codex App only): Install from the sidebar

1. Run `codex plugin marketplace add LZY-Ricardo/superpowers-enhanced` from a terminal.
2. In the Codex app, click **Plugins** in the sidebar.
3. Find **Superpowers Enhanced** in your marketplace tab.
4. Click the `+` next to it and follow the prompts.

## 2. Verify the plugin loaded

A quick check:

```text
/superpowers:using-enhanced-workflow
```

If the full enhanced workflow skill loads, the plugin is active.

You can also ask:

```text
Tell me which superpowers skills are available
```

## 3. Installation success checklist

A successful installation should satisfy all of these:

- `superpowers:using-superpowers` is available
- `superpowers:brainstorming` is available
- `superpowers:init-enhanced-workflow` is available
- `superpowers:using-enhanced-workflow` is available
- `/superpowers:using-enhanced-workflow` loads successfully
- the plugin appears in your plugin list

If any of these fail, use the troubleshooting section below.

## 4. Initialize a project

In a project you want to use with the enhanced workflow, tell Claude:

```text
Initialize the enhanced superpowers workflow for this project
```

This runs `superpowers:init-enhanced-workflow` and creates:

```text
docs/superpowers/
  README.md
  workflow.md
  conventions.md
  status.md
  version.json
  decomposition/
  specs/
  plans/
  execution-log/
  debugging-log/
  review-log/
  completion/
```

It also updates the project's `CLAUDE.md`.

## 5. Start normal work

### Small / normal feature
Just describe the feature:

```text
Add image upload support to this project
```

Claude should walk through the enhanced workflow automatically.

### Large / multi-part feature
Describe the whole goal:

```text
Help me redesign the workflow versioning and upgrade system
```

Claude should start by decomposing it into sub-projects before planning implementation.

## 6. Upgrade an older initialized project

If a project already has `docs/superpowers/` but its guidance files are older, do **not** rerun init.

Instead, upgrade only the guidance layer:
- project `CLAUDE.md`
- `docs/superpowers/README.md`
- `docs/superpowers/workflow.md`
- `docs/superpowers/conventions.md`
- `docs/superpowers/status.md`
- `docs/superpowers/version.json`

Do **not** overwrite historical records such as:
- `execution-log/`
- `review-log/`
- `debugging-log/`
- `completion/`
- `specs/`
- `plans/`
- `decomposition/`

**Note:** A local maintenance skill such as `/upgrading-enhanced-workflow-project` may be used in private setups, but that skill is **not** part of this repository and is not installed for other users by default.

## 7. Update the plugin later

This plugin is versioned. Claude Code and Codex both install into versioned cache paths such as:

```text
~/.claude/plugins/cache/superpowers-enhanced/superpowers/5.2.2
~/.codex/plugins/cache/superpowers-enhanced/superpowers/5.2.2
```

When a new release is published, the maintainer should bump the version number. If the version does not change, your local tool may keep using the previous cache.

### Claude Code

Recommended command-line update flow:

```text
/plugin marketplace update superpowers-enhanced
/plugin update superpowers@superpowers-enhanced
/reload-plugins
```

You can also update from the UI:

1. Open `/plugins`
2. Go to **Installed**
3. Select `superpowers @ superpowers-enhanced`
4. Choose **Update now**
5. Run `/reload-plugins`

If direct update behaves strangely, fall back to uninstall + install:

```text
/plugin uninstall superpowers@superpowers-enhanced
/plugin install superpowers@superpowers-enhanced
/reload-plugins
```

### Codex CLI

Recommended update flow:

```bash
codex plugin marketplace upgrade superpowers-enhanced
codex plugin add superpowers@superpowers-enhanced
```

This was verified to update the installed cache to a newer version without first removing the plugin.

If Codex still loads old files, clear the plugin cache and re-install:

```bash
codex plugin remove superpowers@superpowers-enhanced
rm -rf ~/.codex/plugins/cache/superpowers-enhanced
codex plugin marketplace upgrade superpowers-enhanced
codex plugin add superpowers@superpowers-enhanced
```

## 8. Uninstall

### Claude Code

```text
/plugin uninstall superpowers@superpowers-enhanced
/reload-plugins
```

### Codex CLI

```bash
codex plugin remove superpowers@superpowers-enhanced
```

## 9. Troubleshooting

### Skills load but behavior looks old

Re-install the plugin to get the latest version. For Claude Code, uninstall and re-install. For Codex, run `codex plugin marketplace upgrade` then re-install.

### Marketplace add fails

Check your network connection. Both Claude Code and Codex need to clone the repository from GitHub.

### Plugin installed but skills not found

Restart Claude Code or run `/reload-plugins`. For Codex, start a new session.

## 10. Manual install (fallback for Claude Code)

If the `/plugin` commands don't work in your environment, you can install manually:

### Step 1: Clone the repository into Claude's plugin cache

```bash
git clone https://github.com/LZY-Ricardo/superpowers-enhanced.git ~/.claude/plugins/cache/superpowers-enhanced/latest
git -C ~/.claude/plugins/cache/superpowers-enhanced/latest checkout main
```

### Step 2: Register the marketplace

Add to `~/.claude/plugins/known_marketplaces.json`:

```json
{
  "superpowers-enhanced": {
    "source": {
      "source": "github",
      "repo": "LZY-Ricardo/superpowers-enhanced"
    },
    "installLocation": "/Users/<you>/.claude/plugins/cache/superpowers-enhanced/latest",
    "lastUpdated": "<CURRENT_TIMESTAMP>"
  }
}
```

### Step 3: Create the marketplace symlink

```bash
ln -s ~/.claude/plugins/cache/superpowers-enhanced/latest ~/.claude/plugins/marketplaces/superpowers-enhanced
```

### Step 4: Register the plugin install

Add to `~/.claude/plugins/installed_plugins.json`:

```json
{
  "superpowers@superpowers-enhanced": [
    {
      "scope": "user",
      "installPath": "/Users/<you>/.claude/plugins/cache/superpowers-enhanced/latest",
      "version": "5.2.2",
      "installedAt": "<CURRENT_TIMESTAMP>",
      "lastUpdated": "<CURRENT_TIMESTAMP>",
      "gitCommitSha": "<LATEST_COMMIT_SHA>"
    }
  ]
}
```

Get the latest SHA with:

```bash
git -C ~/.claude/plugins/cache/superpowers-enhanced/latest rev-parse HEAD
```

### Step 5: Enable the plugin

Add to `~/.claude/settings.json`:

```json
{
  "enabledPlugins": {
    "superpowers@superpowers-enhanced": true
  }
}
```

### Step 6: Restart Claude Code

Completely restart Claude Code and open a fresh session.

## Notes

- The enhanced skill inventory in this repository includes only **repo-shipped workflow skills**.
- Personal/local operational helpers such as installation or migration helpers may live in `~/.claude/skills/`, but they are not part of the shared enhanced workflow inventory.
