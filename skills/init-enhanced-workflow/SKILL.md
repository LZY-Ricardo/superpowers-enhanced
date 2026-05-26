---
name: init-enhanced-workflow
description: Use when starting a new project or onboarding an existing project to the Enhanced Superpowers workflow. Creates directory structure, project CLAUDE.md rules, and README documentation.
---

# Init Enhanced Workflow

One-command setup for the Enhanced Superpowers workflow in a project. Run once per project.

**Announce at start:** "I'm using the init-enhanced-workflow skill to set up the project."

## Checklist

Complete in order:

1. **Verify project root** — confirm you're in a git repository with `git rev-parse --git-dir`
2. **Create directory structure**
3. **Write project CLAUDE.md** — concise rules, highest AI priority
4. **Write docs/superpowers/README.md** — detailed workflow reference
5. **Write docs/superpowers/version.json** — machine-readable workflow metadata
6. **Commit** — commit the initialization separately from any code changes

## Step 2: Create Directory Structure

```bash
mkdir -p docs/superpowers/{decomposition,specs,plans,execution-log,debugging-log,review-log,completion}
```

## Step 3: Write Project CLAUDE.md

Copy the project CLAUDE template from the canonical template set.

Do NOT overwrite unrelated project-specific guidance.
- If `CLAUDE.md` does not exist, create it from the template.
- If `CLAUDE.md` already exists, append the template block below existing content.
- The inserted block is marker-bounded in the template so future upgrade tooling can replace only the Enhanced Superpowers section.

Use:

```bash
TEMPLATE_DIR=~/.claude/plugins/cache/superpowers-enhanced/latest/skills/using-enhanced-workflow
CLAUDE_TEMPLATE="$TEMPLATE_DIR/docs-project-claude-template.md"

if [ -f CLAUDE.md ]; then
  printf '\n\n' >> CLAUDE.md
  cat "$CLAUDE_TEMPLATE" >> CLAUDE.md
else
  cp "$CLAUDE_TEMPLATE" CLAUDE.md
fi
```

## Step 4: Write docs/superpowers/ Docs

Copy three template files from this plugin's `using-enhanced-workflow` skill directory:

```bash
TEMPLATE_DIR=~/.claude/plugins/cache/superpowers-enhanced/latest/skills/using-enhanced-workflow

cp "$TEMPLATE_DIR/docs-superpowers-README-template.md" docs/superpowers/README.md
cp "$TEMPLATE_DIR/docs-superpowers-workflow-template.md" docs/superpowers/workflow.md
cp "$TEMPLATE_DIR/docs-superpowers-conventions-template.md" docs/superpowers/conventions.md
```

Then customize the Active Features table in `README.md` with the project's first feature (if known), or leave it as a template.

## Step 5: Write docs/superpowers/version.json

Write workflow metadata only after the guidance files have been created successfully.

Use:

```bash
VERSION_TEMPLATE="$TEMPLATE_DIR/docs-superpowers-version-template.json"
NOW_UTC="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
PLUGIN_VERSION="$(python3 - <<'PY'
import json
from pathlib import Path
print(json.loads(Path('package.json').read_text())['version'])
PY
)"

python3 - <<PY
import json
from pathlib import Path

template = json.loads(Path("$VERSION_TEMPLATE").read_text())
for key in ("pluginVersion", "workflowTemplateVersion"):
    template[key] = "$PLUGIN_VERSION"
for key in ("initializedAt", "lastUpgradedAt"):
    template[key] = "$NOW_UTC"
Path("docs/superpowers/version.json").write_text(json.dumps(template, indent=2) + "\n")
PY
```

## Step 6: Commit

```bash
git add docs/superpowers/ CLAUDE.md
git commit -m "chore: initialize Enhanced Superpowers workflow documentation structure"
```

## When to Re-Run

Do NOT re-run if `docs/superpowers/README.md` already exists. This is a one-time setup.

If the directory structure exists but README.md is missing (e.g., created by Auto-Init without the full template), re-run Step 4 only.
