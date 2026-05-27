# Getting Started with Superpowers Enhanced

This is the quickest way for someone else to install and use Superpowers Enhanced.

## 1. Install the plugin

In Claude Code:

```bash
/plugin install https://github.com/LZY-Ricardo/superpowers-enhanced.git
```

If the original `superpowers` plugin is already installed, remove it first:

```bash
/plugin uninstall superpowers
```

Then install the enhanced fork again.

## 2. Restart Claude Code

After installation, restart Claude Code and open a fresh session.

## 3. Verify the plugin loaded

A quick check:

```text
/superpowers:using-enhanced-workflow
```

If the full enhanced workflow skill loads, the plugin is active.

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

**Note:** In my local setup I use a personal maintenance skill named `/upgrading-enhanced-workflow-project`, but that skill is **not** part of this repository and is not installed for other users by default.

## 7. Update the plugin later

Update the **actually loaded** plugin cache path, not just any cloned copy.

First check the path recorded in:

```text
~/.claude/plugins/installed_plugins.json
```

Then pull latest code in that path, update the registered SHA if needed, and restart Claude Code.

## Notes

- The enhanced skill inventory in this repository includes only **repo-shipped workflow skills**.
- Personal/local operational helpers such as installation or migration helpers may live in `~/.claude/skills/`, but they are not part of the shared enhanced workflow inventory.
- If the plugin loads but behavior looks old, verify which plugin cache path Claude Code is actually using.
