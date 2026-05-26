# Project Recovery and Status Indexing Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a dedicated `docs/superpowers/status.md` recovery surface so future sessions can identify the active sub-project, active feature, current phase, blockers, review threads, and next step without scanning all logs first.

**Architecture:** Introduce a single new summary file, `docs/superpowers/status.md`, and keep it manually maintained by the main session. Preserve README as the static index page and decomposition as the macro-level initiative map. `status.md` links to the active artifact chain instead of duplicating detailed execution, review, debugging, and completion history.

**Tech Stack:** Markdown templates and skill docs, shell-based structural verification, repository documentation workflow

---

## File Structure

- `skills/using-enhanced-workflow/docs-superpowers-status-template.md` — new canonical status-page template
- `skills/using-enhanced-workflow/SKILL.md` — updated to include `status.md` in document index / recovery guidance
- `skills/init-enhanced-workflow/SKILL.md` — updated to copy the new `status.md` template into initialized projects
- `docs/superpowers/README.md` — may get a small navigation link to `status.md`
- `tests/claude-code/test-status-surface.sh` — new targeted structural test for status-page support
- `tests/claude-code/run-skill-tests.sh` — register the new status test in the fast suite if appropriate

## Task 1: Add canonical status.md template

**Files:**
- Create: `skills/using-enhanced-workflow/docs-superpowers-status-template.md`
- Test: `tests/claude-code/test-status-surface.sh`

- [ ] **Step 1: Write the failing test for status template existence and required sections**

Create `tests/claude-code/test-status-surface.sh` with checks that fail unless the template exists and contains these section headings:
- `# Project Status`
- `## Current Artifact Links`
- `## Open Review Threads`
- `## Open Blockers`
- `## Next Recommended Action`

Test shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
STATUS_TEMPLATE="$PLUGIN_DIR/skills/using-enhanced-workflow/docs-superpowers-status-template.md"

FAILED=0
[ -f "$STATUS_TEMPLATE" ] || FAILED=$((FAILED + 1))
for heading in '# Project Status' '## Current Artifact Links' '## Open Review Threads' '## Open Blockers' '## Next Recommended Action'; do
  grep -q "$heading" "$STATUS_TEMPLATE" || FAILED=$((FAILED + 1))
done
[ $FAILED -eq 0 ]
```

- [ ] **Step 2: Run test to verify it fails**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced && bash tests/claude-code/test-status-surface.sh
```
Expected: FAIL because the template file does not exist yet.

- [ ] **Step 3: Create the status template**

Write `skills/using-enhanced-workflow/docs-superpowers-status-template.md` with a concise manual-maintenance recovery layout, including placeholders for:
- active sub-project
- active feature
- current phase
- last updated
- artifact links
- open review threads
- blockers
- next action

- [ ] **Step 4: Run test to verify it passes**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced && bash tests/claude-code/test-status-surface.sh
```
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add skills/using-enhanced-workflow/docs-superpowers-status-template.md tests/claude-code/test-status-surface.sh
git commit -m "feat: add project recovery status template"
```

## Task 2: Teach init-enhanced-workflow to copy status.md

**Files:**
- Modify: `skills/init-enhanced-workflow/SKILL.md`
- Test: `tests/claude-code/test-status-surface.sh`

- [ ] **Step 1: Extend the failing test for init support**

Add assertions that `init-enhanced-workflow` references `docs-superpowers-status-template.md` and `docs/superpowers/status.md`.

- [ ] **Step 2: Run test to verify it fails**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced && bash tests/claude-code/test-status-surface.sh
```
Expected: FAIL because init does not yet reference the status template.

- [ ] **Step 3: Update init-enhanced-workflow**

Modify the docs-copy step in `skills/init-enhanced-workflow/SKILL.md` to copy:

```bash
cp "$TEMPLATE_DIR/docs-superpowers-status-template.md" docs/superpowers/status.md
```

Also update the checklist text so initialized projects now receive `status.md` as part of the guidance layer.

- [ ] **Step 4: Run test to verify it passes**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced && bash tests/claude-code/test-status-surface.sh
```
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add skills/init-enhanced-workflow/SKILL.md tests/claude-code/test-status-surface.sh
git commit -m "feat: include status page in workflow init"
```

## Task 3: Clarify recovery-role separation in runtime docs

**Files:**
- Modify: `skills/using-enhanced-workflow/SKILL.md`
- Modify: `docs/superpowers/README.md`
- Test: `tests/claude-code/test-status-surface.sh`

- [ ] **Step 1: Extend the failing test for role-separation wording**

Add assertions that:
- `using-enhanced-workflow/SKILL.md` mentions `status.md` as the recovery entrypoint
- `docs/superpowers/README.md` links to `status.md`

- [ ] **Step 2: Run test to verify it fails**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced && bash tests/claude-code/test-status-surface.sh
```
Expected: FAIL because the docs do not yet mention status.md.

- [ ] **Step 3: Update runtime/reference docs**

Update `skills/using-enhanced-workflow/SKILL.md` so the resume guidance distinguishes:
- decomposition → macro-level map
- README → index page
- status.md → first recovery stop
- execution/review/debugging/completion → detailed evidence

Update `docs/superpowers/README.md` to add `status.md` to quick navigation and directory overview.

- [ ] **Step 4: Run test to verify it passes**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced && bash tests/claude-code/test-status-surface.sh
```
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add skills/using-enhanced-workflow/SKILL.md docs/superpowers/README.md tests/claude-code/test-status-surface.sh
git commit -m "docs: define status page as recovery entrypoint"
```

## Task 4: Seed repository status.md and register the test

**Files:**
- Create: `docs/superpowers/status.md`
- Modify: `tests/claude-code/run-skill-tests.sh`
- Test: `tests/claude-code/test-status-surface.sh`

- [ ] **Step 1: Add a failing test for the repository status page**

Extend the test to assert the repo now has `docs/superpowers/status.md` with concrete fields filled for the current engineering-upgrade initiative.

- [ ] **Step 2: Run test to verify it fails**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced && bash tests/claude-code/test-status-surface.sh
```
Expected: FAIL because the repo status page does not yet exist.

- [ ] **Step 3: Create the repo status page and register the test**

Write `docs/superpowers/status.md` with the current known state:
- active sub-project: C
- active feature: engineering-upgrade initiative / recovery and status indexing
- current phase: brainstorming/implementation as appropriate
- links to current decomposition/spec/plan
- note open blockers (if none, say none)
- note next recommended action

Add `test-status-surface.sh` to `tests/claude-code/run-skill-tests.sh`.

- [ ] **Step 4: Run standalone test and then fast suite**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced && bash tests/claude-code/test-status-surface.sh
cd /Users/zyb/workspace/person/superpowers-enhanced && bash tests/claude-code/run-skill-tests.sh
```
Expected:
- status surface test passes
- if unrelated legacy suite failures remain, document them explicitly rather than broadening this sub-project to fix them

- [ ] **Step 5: Commit**

```bash
git add docs/superpowers/status.md tests/claude-code/run-skill-tests.sh tests/claude-code/test-status-surface.sh
git commit -m "feat: add project recovery status surface"
```

## Self-Review

- **Spec coverage:**
  - add `status.md` template → Task 1
  - init copies `status.md` → Task 2
  - role separation clarified across decomposition/README/status/logs → Task 3
  - repository gets a seeded status page and test registration → Task 4

- **Placeholder scan:**
  - all required headings, links, and files are explicit
  - no TODO/TBD placeholders remain in the plan itself

- **Type consistency:**
  - `status.md` is consistently the live recovery surface
  - `README.md` remains the index page
  - decomposition remains the macro-level map

## Execution Handoff

**Plan complete and saved to `docs/superpowers/plans/2026-05-26-project-recovery-and-status-indexing.md`. Two execution options:**

**1. Subagent-Driven (recommended)** - I dispatch a fresh subagent per task, review between tasks, fast iteration

**2. Inline Execution** - Execute tasks in this session using executing-plans, batch execution with checkpoints

**Which approach?**
