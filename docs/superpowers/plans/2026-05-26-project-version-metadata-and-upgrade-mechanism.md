# Project Version Metadata and Upgrade Mechanism Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add deterministic project-side workflow metadata so initialized and upgraded projects can record and compare their Enhanced Superpowers guidance version without guessing from document content.

**Architecture:** Introduce a canonical `docs/superpowers/version.json` template, then teach `init-enhanced-workflow` to write it after successful guidance creation and teach the local `upgrading-enhanced-workflow-project` skill to read, backfill, and compare it. The first version keeps `pluginVersion` and `workflowTemplateVersion` equal while preserving separate semantics for later decoupling.

**Tech Stack:** Markdown skill docs, JSON metadata template, shell-based project guidance workflow, local maintenance skill docs

---

## File Structure

- `skills/using-enhanced-workflow/docs-superpowers-version-template.json` — new canonical project metadata template
- `skills/init-enhanced-workflow/SKILL.md` — init flow updated to write `version.json` after guidance creation
- `docs/superpowers/README.md` (repo guidance copy) — optional note if needed for project guidance inventory
- `~/.claude/skills/upgrading-enhanced-workflow-project/SKILL.md` — local project-upgrade skill updated to consume and backfill `version.json`
- `tests/claude-code/test-init-enhanced-workflow.sh` — extend to cover `version.json` creation and field semantics

## Task 1: Add canonical project version metadata template

**Files:**
- Create: `skills/using-enhanced-workflow/docs-superpowers-version-template.json`
- Test: `tests/claude-code/test-init-enhanced-workflow.sh`

- [ ] **Step 1: Extend the failing test for version template existence**

Add checks to `tests/claude-code/test-init-enhanced-workflow.sh`:

```bash
VERSION_TEMPLATE="$PLUGIN_DIR/skills/using-enhanced-workflow/docs-superpowers-version-template.json"

[ -f "$VERSION_TEMPLATE" ]
grep -q '"pluginVersion"' "$VERSION_TEMPLATE"
grep -q '"workflowTemplateVersion"' "$VERSION_TEMPLATE"
grep -q '"initializedAt"' "$VERSION_TEMPLATE"
grep -q '"lastUpgradedAt"' "$VERSION_TEMPLATE"
```

- [ ] **Step 2: Run test to verify it fails**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced && bash tests/claude-code/test-init-enhanced-workflow.sh
```
Expected: FAIL because the version template file does not exist yet.

- [ ] **Step 3: Create the canonical version template**

Write `skills/using-enhanced-workflow/docs-superpowers-version-template.json` with this initial shape:

```json
{
  "pluginVersion": "5.1.0",
  "workflowTemplateVersion": "5.1.0",
  "initializedAt": "TEMPLATE_TIMESTAMP",
  "lastUpgradedAt": "TEMPLATE_TIMESTAMP"
}
```

The literal `TEMPLATE_TIMESTAMP` placeholder is intentional. `init` and `upgrade` will replace it with real timestamps at write time.

- [ ] **Step 4: Run test to verify it passes**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced && bash tests/claude-code/test-init-enhanced-workflow.sh
```
Expected: PASS for version template existence and required keys.

- [ ] **Step 5: Commit**

```bash
git add skills/using-enhanced-workflow/docs-superpowers-version-template.json tests/claude-code/test-init-enhanced-workflow.sh
git commit -m "feat: add workflow version metadata template"
```

## Task 2: Teach init-enhanced-workflow to write version.json

**Files:**
- Modify: `skills/init-enhanced-workflow/SKILL.md`
- Test: `tests/claude-code/test-init-enhanced-workflow.sh`

- [ ] **Step 1: Extend the failing test for init writing order and metadata output**

Add assertions that `init-enhanced-workflow` references `docs-superpowers-version-template.json` and documents writing `docs/superpowers/version.json` after guidance creation:

```bash
grep -q 'docs-superpowers-version-template.json' "$INIT_SKILL"
grep -q 'docs/superpowers/version.json' "$INIT_SKILL"
```

- [ ] **Step 2: Run test to verify it fails**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced && bash tests/claude-code/test-init-enhanced-workflow.sh
```
Expected: FAIL because init does not yet mention the version template or output file.

- [ ] **Step 3: Update init-enhanced-workflow Step 4/5 to write version metadata**

Add instructions to `skills/init-enhanced-workflow/SKILL.md` after the guidance templates are written:

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

Also update the checklist/order so metadata write happens only after the project guidance files are created.

- [ ] **Step 4: Run test to verify it passes**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced && bash tests/claude-code/test-init-enhanced-workflow.sh
```
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add skills/init-enhanced-workflow/SKILL.md tests/claude-code/test-init-enhanced-workflow.sh
git commit -m "feat: write project workflow metadata during init"
```

## Task 3: Define legacy backfill and version comparison in project upgrade skill

**Files:**
- Modify: `/Users/zyb/.claude/skills/upgrading-enhanced-workflow-project/SKILL.md`
- Test: `tests/claude-code/test-init-enhanced-workflow.sh`

- [ ] **Step 1: Add a failing coverage check for upgrade-skill metadata behavior**

Because this is a local skill outside the repo, validate the expected wording from the repo side with a shell assertion executed manually during verification:

```bash
grep -q 'version.json' ~/.claude/skills/upgrading-enhanced-workflow-project/SKILL.md
grep -q 'legacy' ~/.claude/skills/upgrading-enhanced-workflow-project/SKILL.md
grep -q 'pluginVersion' ~/.claude/skills/upgrading-enhanced-workflow-project/SKILL.md
grep -q 'workflowTemplateVersion' ~/.claude/skills/upgrading-enhanced-workflow-project/SKILL.md
```

- [ ] **Step 2: Run the manual check to verify it fails or is incomplete**

Run:
```bash
grep -q 'version.json' ~/.claude/skills/upgrading-enhanced-workflow-project/SKILL.md && echo found
```
Expected: current skill lacks the full metadata-based upgrade flow.

- [ ] **Step 3: Update the local upgrade skill**

Revise `~/.claude/skills/upgrading-enhanced-workflow-project/SKILL.md` so it explicitly defines:
- project `version.json` as the primary machine-readable upgrade signal
- legacy recognition rules:
  - `docs/superpowers/` exists
  - project `CLAUDE.md` exists
  - recognizable enhanced workflow block exists
  - at least one guidance file exists
- legacy backfill behavior:
  - write `initializedAt: "legacy"`
  - write `lastUpgradedAt: now`
- normal upgrade behavior:
  - compare current project metadata version to installed plugin version
  - skip by default if versions match unless user requests forced re-check

- [ ] **Step 4: Run the manual metadata wording check again**

Run:
```bash
grep -q 'version.json' ~/.claude/skills/upgrading-enhanced-workflow-project/SKILL.md \
&& grep -q 'initializedAt' ~/.claude/skills/upgrading-enhanced-workflow-project/SKILL.md \
&& grep -q 'lastUpgradedAt' ~/.claude/skills/upgrading-enhanced-workflow-project/SKILL.md \
&& grep -q 'legacy' ~/.claude/skills/upgrading-enhanced-workflow-project/SKILL.md
```
Expected: success.

- [ ] **Step 5: Commit**

No repo commit for the local skill. Instead record the local update in execution/review/completion docs and keep repo commits focused on shared workflow code.

## Task 4: Clarify semantics and future decoupling in runtime references

**Files:**
- Modify: `skills/using-enhanced-workflow/SKILL.md`
- Modify: `ENHANCED.md`
- Test: `tests/claude-code/test-init-enhanced-workflow.sh`

- [ ] **Step 1: Extend the failing test for semantic clarity**

Add assertions that the runtime reference or docs mention both `pluginVersion` and `workflowTemplateVersion` separately:

```bash
grep -q 'workflowTemplateVersion' "$PLUGIN_DIR/skills/using-enhanced-workflow/SKILL.md" || grep -q 'workflowTemplateVersion' "$PLUGIN_DIR/ENHANCED.md"
```

- [ ] **Step 2: Run test to verify it fails**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced && bash tests/claude-code/test-init-enhanced-workflow.sh
```
Expected: FAIL because the semantics are not yet documented.

- [ ] **Step 3: Add explicit semantic note**

Document that:
- project metadata records both plugin version and workflow template version
- they are equal in the initial implementation
- they are intentionally separate so future template-only versioning can be introduced without redesign

Keep this note concise; it is a design signal, not a full implementation guide.

- [ ] **Step 4: Run test to verify it passes**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced && bash tests/claude-code/test-init-enhanced-workflow.sh
```
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add skills/using-enhanced-workflow/SKILL.md ENHANCED.md tests/claude-code/test-init-enhanced-workflow.sh
git commit -m "docs: clarify project workflow metadata semantics"
```

## Self-Review

- **Spec coverage:**
  - Add canonical `version.json` template → Task 1
  - Write `version.json` during init → Task 2
  - Define legacy backfill and upgrade comparison flow → Task 3
  - Clarify pluginVersion vs workflowTemplateVersion semantics → Task 4

- **Placeholder scan:**
  - No unresolved TODO/TBD text remains.
  - Commands, files, and keys are explicit.

- **Type consistency:**
  - Metadata keys are consistently `pluginVersion`, `workflowTemplateVersion`, `initializedAt`, `lastUpgradedAt`.
  - Output file is consistently `docs/superpowers/version.json`.

## Execution Handoff

**Plan complete and saved to `docs/superpowers/plans/2026-05-26-project-version-metadata-and-upgrade-mechanism.md`. Two execution options:**

**1. Subagent-Driven (recommended)** - I dispatch a fresh subagent per task, review between tasks, fast iteration

**2. Inline Execution** - Execute tasks in this session using executing-plans, batch execution with checkpoints

**Which approach?**
