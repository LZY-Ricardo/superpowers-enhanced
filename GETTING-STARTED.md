# Getting Started with Superpowers Enhanced

This is the quickest practical guide for installing and using Superpowers Enhanced.

## Who this guide is for

This guide assumes the user is comfortable editing local Claude Code JSON configuration files when needed. The current stable installation path is the **manual install path** below.

## 1. Install the plugin (manual path)

Use the manual installation path.

### Step 1: Clone the repository into Claude's plugin cache

```bash
git clone https://github.com/LZY-Ricardo/superpowers-enhanced.git ~/.claude/plugins/cache/superpowers-enhanced/latest
git -C ~/.claude/plugins/cache/superpowers-enhanced/latest checkout main
```

### Step 2: Register the marketplace

Ensure `~/.claude/plugins/known_marketplaces.json` contains an entry like:

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

If the file already contains other marketplaces, add the `superpowers-enhanced` object without removing the others.

### Step 3: Ensure the marketplace symlink exists

```bash
ln -s ~/.claude/plugins/cache/superpowers-enhanced/latest ~/.claude/plugins/marketplaces/superpowers-enhanced
```

If the symlink already exists, leave it as-is.

### Step 4: Register the plugin install

Ensure `~/.claude/plugins/installed_plugins.json` contains an entry like:

```json
{
  "version": 2,
  "plugins": {
    "superpowers@superpowers-enhanced": [
      {
        "scope": "user",
        "installPath": "/Users/<you>/.claude/plugins/cache/superpowers-enhanced/latest",
        "version": "5.2.0",
        "installedAt": "<CURRENT_TIMESTAMP>",
        "lastUpdated": "<CURRENT_TIMESTAMP>",
        "gitCommitSha": "<LATEST_COMMIT_SHA>"
      }
    ]
  }
}
```

If the file already contains other plugins, add the `superpowers@superpowers-enhanced` entry without removing the others.

Get the latest SHA with:

```bash
git -C ~/.claude/plugins/cache/superpowers-enhanced/latest rev-parse HEAD
```

### Step 5: Enable the plugin

Ensure `~/.claude/settings.json` contains:

```json
{
  "enabledPlugins": {
    "superpowers@superpowers-enhanced": true
  }
}
```

If `enabledPlugins` already contains other entries, add `superpowers@superpowers-enhanced` without removing the others.

### Step 6: Restart Claude Code

Completely restart Claude Code and open a fresh session.

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
- `~/.claude/plugins/installed_plugins.json` contains `superpowers@superpowers-enhanced`
- the active plugin path exists on disk

If any of these fail, use the troubleshooting section below.

## 4. Check the actually loaded plugin cache path

In some setups, Claude may load from a versioned cache path such as:

```text
~/.claude/plugins/cache/superpowers-enhanced/superpowers/5.2.0
```

while another manually maintained path such as `latest/` also exists.

The source of truth is:

```text
~/.claude/plugins/installed_plugins.json
```

Specifically:
- `superpowers@superpowers-enhanced.installPath`
- `superpowers@superpowers-enhanced.version`
- `superpowers@superpowers-enhanced.gitCommitSha`

If Claude appears to load old behavior after an update, check which path is actually active and update that path first.

## 5. Initialize a project

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

## 6. Start normal work

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

## 7. Upgrade an older initialized project

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

## 8. Update the plugin later

Update the **actually loaded** plugin cache path, not just any cloned copy.

### Step 1: Identify the active path

Check:

```text
~/.claude/plugins/installed_plugins.json
```

Look at:
- `installPath`
- `version`
- `gitCommitSha`

### Step 2: Pull the latest code in that path

```bash
cd <actual_loaded_plugin_path>
git pull origin main
```

### Step 3: Update the registered SHA if needed

```bash
git rev-parse HEAD
```

Then update `gitCommitSha` in `installed_plugins.json`.

### Step 4: If you also maintain `latest/`, resync it

If both a versioned cache path and `latest/` exist, update the second copy too or resync them so future sessions do not load stale skills from the wrong cache.

### Step 5: Restart Claude Code

## 9. Uninstall

1. Remove the plugin cache:

```bash
rm -rf ~/.claude/plugins/cache/superpowers-enhanced
rm -f ~/.claude/plugins/marketplaces/superpowers-enhanced
```

2. Remove the plugin entry from:
- `~/.claude/plugins/installed_plugins.json`
- `~/.claude/settings.json` → `enabledPlugins`
- `~/.claude/plugins/known_marketplaces.json`

3. Restart Claude Code.

## 10. Troubleshooting

### `/plugin install <git-url>` fails with “Marketplace not found”
Some Claude Code setups treat the URL as a marketplace name rather than a Git source. In that case, use the manual install path in this guide.

### Skills load but behavior looks old
Check the **actually loaded plugin cache path** in `installed_plugins.json`. If you updated `latest/` but Claude is loading a versioned cache path, the running session may still be reading old content.

### Multiple cache paths exist
If both of these exist:

```text
~/.claude/plugins/cache/superpowers-enhanced/latest
~/.claude/plugins/cache/superpowers-enhanced/superpowers/<version>
```

Claude may be loading only one of them. Use `installed_plugins.json` as the source of truth.

### HTTPS clone fails
If `git clone https://...` fails in your environment, fix network access first before debugging plugin registration.

### JSON file edits fail Claude startup
Validate your JSON carefully after editing. A missing comma or brace in `settings.json`, `known_marketplaces.json`, or `installed_plugins.json` can break plugin loading.

## Notes

- The enhanced skill inventory in this repository includes only **repo-shipped workflow skills**.
- Personal/local operational helpers such as installation or migration helpers may live in `~/.claude/skills/`, but they are not part of the shared enhanced workflow inventory.
- If the plugin loads but behavior looks old, verify which plugin cache path Claude Code is actually using.
