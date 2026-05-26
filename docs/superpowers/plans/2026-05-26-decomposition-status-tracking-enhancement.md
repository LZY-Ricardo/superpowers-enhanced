# Decomposition Status Tracking Enhancement Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Turn decomposition documents into durable top-level project maps by adding explicit sub-project status tracking, priority tracking, and next-step visibility.

**Architecture:** Enhance the decomposition document format directly rather than introducing a separate status file. Add a `Sub-project Overview` table for quick scanning and enrich each detailed sub-project block with `Status`, `Priority`, and `Next Step`. Keep the first version manually maintained by the main session.

**Tech Stack:** Markdown skill docs, decomposition document templates/examples, shell-based structural verification

---

## File Structure

- `skills/decomposing-requirements/SKILL.md` — update decomposition output guidance, output fields, and re-prioritization rules
- `docs/superpowers/decomposition/2026-05-25-workflow-engineering-upgrade.md` — update the current decomposition doc to the new tracked format as the first concrete instance
- `tests/claude-code/test-decomposing-requirements.sh` — new targeted test for decomposition status-tracking structure
- `tests/claude-code/run-skill-tests.sh` — register the new decomposition test if kept as a fast structural test

## Task 1: Add status-tracking requirements to the decomposition skill

**Files:**
- Modify: `skills/decomposing-requirements/SKILL.md`
- Test: `tests/claude-code/test-decomposing-requirements.sh`

- [ ] **Step 1: Write the failing test for decomposition status-tracking structure**

Create `tests/claude-code/test-decomposing-requirements.sh` with checks that fail unless the skill text includes:
- `Sub-project Overview`
- `Status`
- `Priority`
- `Next Step`
- the six allowed statuses: `Pending`, `In Progress`, `Blocked`, `Completed`, `Deferred`, `Skipped`

Test shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILL_FILE="$PLUGIN_DIR/skills/decomposing-requirements/SKILL.md"

FAILED=0

grep -q 'Sub-project Overview' "$SKILL_FILE" || FAILED=$((FAILED + 1))
grep -q 'Status' "$SKILL_FILE" || FAILED=$((FAILED + 1))
grep -q 'Priority' "$SKILL_FILE" || FAILED=$((FAILED + 1))
grep -q 'Next Step' "$SKILL_FILE" || FAILED=$((FAILED + 1))
for status in 'Pending' 'In Progress' 'Blocked' 'Completed' 'Deferred' 'Skipped'; do
  grep -q "$status" "$SKILL_FILE" || FAILED=$((FAILED + 1))
done

[ $FAILED -eq 0 ]
```

- [ ] **Step 2: Run test to verify it fails**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced && bash tests/claude-code/test-decomposing-requirements.sh
```
Expected: FAIL because the current skill does not yet define the overview table and full status-tracking structure.

- [ ] **Step 3: Update the decomposition skill format**

Modify `skills/decomposing-requirements/SKILL.md` so it explicitly requires:
- a `## Sub-project Overview` section near the top of the saved decomposition doc
- overview columns: `Sub-project | Status | Priority | Dependencies | Next Step`
- per-sub-project fields expanded to include `Status`, `Priority`, `Next Step`
- lightweight allowed status set: `Pending`, `In Progress`, `Blocked`, `Completed`, `Deferred`, `Skipped`
- main-session/manual ownership of status maintenance

- [ ] **Step 4: Run test to verify it passes**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced && bash tests/claude-code/test-decomposing-requirements.sh
```
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add skills/decomposing-requirements/SKILL.md tests/claude-code/test-decomposing-requirements.sh
git commit -m "feat: add decomposition status tracking structure"
```

## Task 2: Add manual update triggers and state-ownership rules

**Files:**
- Modify: `skills/decomposing-requirements/SKILL.md`
- Test: `tests/claude-code/test-decomposing-requirements.sh`

- [ ] **Step 1: Extend the failing test for maintenance rules**

Add assertions that the skill text includes manual update triggers for:
- sub-project becomes active
- sub-project completes
- sub-project deferred or skipped
- dependency order changes
- next sub-project changes

- [ ] **Step 2: Run test to verify it fails**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced && bash tests/claude-code/test-decomposing-requirements.sh
```
Expected: FAIL if the manual maintenance contract is incomplete.

- [ ] **Step 3: Add state-ownership guidance**

Update the skill so it explicitly says:
- the decomposition doc is maintained by the main session
- decomposition status is the macro-level map
- downstream execution/review/debugging docs remain the detailed per-sub-project source
- status should be updated on completion, deferral, skip, and reprioritization

- [ ] **Step 4: Run test to verify it passes**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced && bash tests/claude-code/test-decomposing-requirements.sh
```
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add skills/decomposing-requirements/SKILL.md tests/claude-code/test-decomposing-requirements.sh
git commit -m "docs: clarify decomposition state ownership"
```

## Task 3: Upgrade the current decomposition document to the new tracked format

**Files:**
- Modify: `docs/superpowers/decomposition/2026-05-25-workflow-engineering-upgrade.md`
- Test: `tests/claude-code/test-decomposing-requirements.sh`

- [ ] **Step 1: Add a failing structural check for the active decomposition doc**

Extend the test to assert the current decomposition doc contains:
- `## Sub-project Overview`
- at least one `Status:` line inside sub-project details
- at least one `Priority:` line
- at least one `Next Step:` line

- [ ] **Step 2: Run test to verify it fails**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced && bash tests/claude-code/test-decomposing-requirements.sh
```
Expected: FAIL because the current decomposition doc does not yet have the new tracked layout.

- [ ] **Step 3: Rewrite the decomposition doc into tracked form**

Update `docs/superpowers/decomposition/2026-05-25-workflow-engineering-upgrade.md` to include:
- `## Sub-project Overview` table with all active sub-projects
- statuses using the lightweight set
- priorities matching the approved order
- next-step values reflecting the current stage
- each detailed sub-project block extended with `Status`, `Priority`, and `Next Step`

Set the current expected state to reflect reality after A and B:
- A → `Completed`
- B → `Completed`
- G → `In Progress`
- remaining later sub-projects → `Pending`

- [ ] **Step 4: Run test to verify it passes**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced && bash tests/claude-code/test-decomposing-requirements.sh
```
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add docs/superpowers/decomposition/2026-05-25-workflow-engineering-upgrade.md tests/claude-code/test-decomposing-requirements.sh
git commit -m "feat: make decomposition docs track subproject state"
```

## Task 4: Register the decomposition test in the fast suite

**Files:**
- Modify: `tests/claude-code/run-skill-tests.sh`
- Test: `tests/claude-code/test-decomposing-requirements.sh`

- [ ] **Step 1: Run the new test directly to verify it passes standalone**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced && bash tests/claude-code/test-decomposing-requirements.sh
```
Expected: PASS.

- [ ] **Step 2: Add it to the fast test list**

Update `tests/claude-code/run-skill-tests.sh` to include:

```bash
"test-decomposing-requirements.sh"
```

near the other shell-based structural tests.

- [ ] **Step 3: Run the fast suite**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced && bash tests/claude-code/run-skill-tests.sh
```
Expected: the new decomposition test runs; if unrelated legacy tests still fail, document that explicitly rather than silently ignoring it.

- [ ] **Step 4: Commit**

```bash
git add tests/claude-code/run-skill-tests.sh tests/claude-code/test-decomposing-requirements.sh
git commit -m "test: cover decomposition status tracking"
```

## Self-Review

- **Spec coverage:**
  - Overview table → Task 1
  - Detailed status/priority/next-step fields → Task 1 and Task 3
  - Manual state-ownership rules → Task 2
  - Current active decomposition doc upgraded to tracked form → Task 3
  - Fast-suite registration → Task 4

- **Placeholder scan:**
  - No unresolved placeholders remain.
  - Status names and overview columns are explicit.

- **Type consistency:**
  - Status values are consistently `Pending`, `In Progress`, `Blocked`, `Completed`, `Deferred`, `Skipped`.
  - Overview columns are consistently `Sub-project`, `Status`, `Priority`, `Dependencies`, `Next Step`.

## Execution Handoff

**Plan complete and saved to `docs/superpowers/plans/2026-05-26-decomposition-status-tracking-enhancement.md`. Two execution options:**

**1. Subagent-Driven (recommended)** - I dispatch a fresh subagent per task, review between tasks, fast iteration

**2. Inline Execution** - Execute tasks in this session using executing-plans, batch execution with checkpoints

**Which approach?**
