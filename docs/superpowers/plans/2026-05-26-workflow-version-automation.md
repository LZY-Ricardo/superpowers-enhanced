# Workflow Version Automation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add workflow template version as a first-class repository-managed version source so version automation understands both plugin/package versions and the workflow template version, while still bumping them together for now.

**Architecture:** Introduce a new root-level `workflow-template-version.json` file containing `workflowTemplateVersion`, then extend `.version-bump.json` and `scripts/bump-version.sh` so the template version is part of the same managed set as existing plugin/package version fields. Keep plugin and template versions synchronized in this first phase, but preserve a separate source-of-record file for future decoupling.

**Tech Stack:** JSON config files and shell-based version automation script

---

## File Structure

- `workflow-template-version.json` — new repo-level source of truth for workflow template version
- `.version-bump.json` — declares the new managed version field
- `scripts/bump-version.sh` — check/audit/bump support for the new file

## Task 1: Add the root workflow template version source

**Files:**
- Create: `workflow-template-version.json`
- Test: `scripts/bump-version.sh --check`

- [ ] **Step 1: Create the failing precondition**

Run the existing check first to establish that workflow template version is not yet part of the managed version set:

```bash
cd /Users/zyb/workspace/person/superpowers-enhanced
bash scripts/bump-version.sh --check
```
Expected: output does not include any `workflowTemplateVersion` entry.

- [ ] **Step 2: Create the new version source file**

Write `workflow-template-version.json`:

```json
{
  "workflowTemplateVersion": "5.1.0"
}
```

- [ ] **Step 3: Verify file exists and is parseable**

Run:
```bash
jq -r '.workflowTemplateVersion' workflow-template-version.json
```
Expected: `5.1.0`

- [ ] **Step 4: Commit**

```bash
git add workflow-template-version.json
git commit -m "feat: add workflow template version source"
```

## Task 2: Declare workflowTemplateVersion in .version-bump.json

**Files:**
- Modify: `.version-bump.json`
- Test: `scripts/bump-version.sh --check`

- [ ] **Step 1: Extend the failing expectation**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced
bash scripts/bump-version.sh --check
```
Expected: still no managed `workflowTemplateVersion` until `.version-bump.json` is updated.

- [ ] **Step 2: Add the new managed file entry**

Update `.version-bump.json` so the managed file list includes:

```json
{ "path": "workflow-template-version.json", "field": "workflowTemplateVersion" }
```

Keep the existing package/plugin manifest entries unchanged.

- [ ] **Step 3: Re-run check**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced
bash scripts/bump-version.sh --check
```
Expected: output now includes `workflow-template-version.json (workflowTemplateVersion)`.

- [ ] **Step 4: Commit**

```bash
git add .version-bump.json
git commit -m "chore: add workflow template version to managed version set"
```

## Task 3: Extend bump-version.sh check/audit behavior validation

**Files:**
- Modify: `scripts/bump-version.sh` *(only if required after validating current behavior)*
- Test: `scripts/bump-version.sh --check`
- Test: `scripts/bump-version.sh --audit`

- [ ] **Step 1: Verify whether code changes are actually needed**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced
bash scripts/bump-version.sh --check
bash scripts/bump-version.sh --audit
```
Expected:
- `--check` includes the new workflow template version source
- `--audit` still works and does not regress

- [ ] **Step 2: Only if necessary, make minimal script adjustments**

If the script does not handle the new file correctly, make the smallest possible changes in `scripts/bump-version.sh`.

Prefer no change if the current generic JSON-field logic already works.

- [ ] **Step 3: Re-run verification**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced
bash scripts/bump-version.sh --check
bash scripts/bump-version.sh --audit
```
Expected: both succeed, and the template version is visible in the managed set.

- [ ] **Step 4: Commit**

If script changes were needed:
```bash
git add scripts/bump-version.sh
git commit -m "chore: support workflow template version in version automation"
```

If no script changes were needed, do not create a no-op commit.

## Task 4: Verify synchronized bump behavior

**Files:**
- Read-only verification across all version-managed files
- If needed, temporary working-tree bump and revert during verification

- [ ] **Step 1: Capture baseline versions**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced
bash scripts/bump-version.sh --check
```
Record current values.

- [ ] **Step 2: Perform a temporary test bump**

Run on a disposable branch or with the intent to keep the new version if acceptable:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced
bash scripts/bump-version.sh 5.1.1
```
Expected: plugin/package version files and `workflow-template-version.json` all update together.

- [ ] **Step 3: Verify the root template version moved with the plugin version**

Run:
```bash
jq -r '.workflowTemplateVersion' workflow-template-version.json
bash scripts/bump-version.sh --check
```
Expected: `workflowTemplateVersion` matches the bumped repo version and appears in the managed version report.

- [ ] **Step 4: Decide final version state**

If `5.1.1` should become the repository's actual new version, keep it.
If this was only a throwaway verification bump, revert or choose a different final target before any commit.

- [ ] **Step 5: Commit**

If the synchronized bump is kept as the real new version:
```bash
git add workflow-template-version.json package.json .claude-plugin/plugin.json .cursor-plugin/plugin.json .codex-plugin/plugin.json .claude-plugin/marketplace.json gemini-extension.json
git commit -m "chore: bump plugin and workflow template version"
```

## Self-Review

- **Spec coverage:**
  - add root version source → Task 1
  - declare it in managed version config → Task 2
  - validate check/audit behavior → Task 3
  - verify synchronized bump behavior → Task 4

- **Placeholder scan:**
  - no unresolved TODO/TBD placeholders remain
  - exact file paths and commands are explicit

- **Type consistency:**
  - root file field is consistently `workflowTemplateVersion`
  - `.version-bump.json` path is consistently `workflow-template-version.json`
  - plugin/template versions remain synchronized in this phase

## Execution Handoff

**Plan complete and saved to `docs/superpowers/plans/2026-05-26-workflow-version-automation.md`. Two execution options:**

**1. Subagent-Driven (recommended)** - I dispatch a fresh subagent per task, review between tasks, fast iteration

**2. Inline Execution** - Execute tasks in this session using executing-plans, batch execution with checkpoints

**Which approach?**
