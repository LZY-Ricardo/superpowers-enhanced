# Testing System Upgrade Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Stabilize the fast structural suite and add a small set of high-value behavior tests so Enhanced Superpowers changes can be verified on a dependable test foundation.

**Architecture:** First, stabilize the common headless Claude invocation contract and isolate or repair the legacy fast-suite blocker. Then add narrowly-scoped behavior tests for init, legacy upgrade metadata backfill, tracked decomposition output, and status-based recovery. Keep the test-system upgrade incremental rather than turning it into a full test framework rewrite.

**Tech Stack:** Shell-based test helpers, Claude Code headless CLI invocations, temporary test projects, structural verification + transcript/e2e behavior checks

---

## File Structure

- `tests/claude-code/test-helpers.sh` — common helper contract for headless Claude invocations
- `tests/claude-code/run-skill-tests.sh` — fast structural runner classification and test registration
- `tests/claude-code/test-subagent-driven-development.sh` — existing legacy fast-suite blocker to fix or reclassify
- `tests/claude-code/test-init-enhanced-workflow.sh` — extend from structural to stronger behavior coverage
- `tests/claude-code/test-decomposing-requirements.sh` — extend from structural to behavior coverage where feasible
- `tests/claude-code/test-status-surface.sh` — extend from structural to recovery behavior coverage where feasible
- `tests/claude-code/test-upgrading-enhanced-workflow-project.sh` — new legacy-upgrade behavior test

## Task 1: Stabilize the common headless test helper contract

**Files:**
- Modify: `tests/claude-code/test-helpers.sh`
- Test: `tests/claude-code/test-subagent-driven-development.sh`

- [ ] **Step 1: Write a failing regression test around the current helper assumptions**

Create a small shell assertion block inside `test-subagent-driven-development.sh` or a helper-focused test so the suite fails if `run_claude()` does not:
- use `--plugin-dir` against the repo root
- use `--permission-mode bypassPermissions`
- capture stdout/stderr reliably
- return a non-zero code on timeout instead of silently hanging

- [ ] **Step 2: Reproduce the current blocker explicitly**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced/tests/claude-code && timeout 120 bash ./test-subagent-driven-development.sh
```
Expected: FAIL/TIMEOUT at the current blocking path so the regression is documented before changing behavior.

- [ ] **Step 3: Repair the helper contract**

Update `tests/claude-code/test-helpers.sh` so `run_claude()` has one documented contract:
- deterministic repo-root `plugin_dir`
- explicit `--permission-mode bypassPermissions`
- stable timeout handling
- clear output capture and error propagation

Keep the helper minimal; do not redesign the whole file.

- [ ] **Step 4: Re-run the blocker test**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced/tests/claude-code && timeout 180 bash ./test-subagent-driven-development.sh
```
Expected: either PASS, or fail quickly with a clear reason rather than hanging indefinitely.

- [ ] **Step 5: Commit**

```bash
git add tests/claude-code/test-helpers.sh tests/claude-code/test-subagent-driven-development.sh
git commit -m "test: stabilize headless claude helper contract"
```

## Task 2: Fix or isolate the legacy fast-suite blocker

**Files:**
- Modify: `tests/claude-code/run-skill-tests.sh`
- Modify: `tests/claude-code/test-subagent-driven-development.sh`

- [ ] **Step 1: Write the failing suite health check**

Define the intended fast-suite outcome in the runner comments and verify that `test-subagent-driven-development.sh` either:
- runs reliably in the fast suite, or
- is explicitly reclassified out of the fast suite

- [ ] **Step 2: Run the full fast suite to capture baseline failure**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced && bash tests/claude-code/run-skill-tests.sh
```
Expected: FAIL because the existing fast suite is blocked by `test-subagent-driven-development.sh`.

- [ ] **Step 3: Apply the smallest viable fix**

If the legacy test can be made fast and stable with a small targeted change, do that.

If not, move it out of the default fast suite and document the new categorization clearly in `run-skill-tests.sh` and test comments. The fast suite should remain a healthy structural signal, not a museum for historical classifications.

- [ ] **Step 4: Re-run the fast suite**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced && bash tests/claude-code/run-skill-tests.sh
```
Expected: PASS, or only fail for newly introduced defects unrelated to the historical blocker.

- [ ] **Step 5: Commit**

```bash
git add tests/claude-code/run-skill-tests.sh tests/claude-code/test-subagent-driven-development.sh
 git commit -m "test: restore fast suite stability"
```

## Task 3: Add init behavior coverage

**Files:**
- Modify: `tests/claude-code/test-init-enhanced-workflow.sh`
- Possibly create temporary-project scaffolding inside the test

- [ ] **Step 1: Extend the failing test from structure to behavior**

Add a temp-project scenario that verifies a real init flow would produce:
- `CLAUDE.md`
- `docs/superpowers/README.md`
- `docs/superpowers/workflow.md`
- `docs/superpowers/conventions.md`
- `docs/superpowers/status.md`
- `docs/superpowers/version.json`

- [ ] **Step 2: Run test to verify current coverage is insufficient**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced && bash tests/claude-code/test-init-enhanced-workflow.sh
```
Expected: FAIL because only structural assertions exist today.

- [ ] **Step 3: Implement the minimal behavior test**

Use a temporary project and a constrained Claude invocation or explicit command-sequence simulation to verify the init contract actually materializes the expected files.

- [ ] **Step 4: Run test to verify it passes**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced && bash tests/claude-code/test-init-enhanced-workflow.sh
```
Expected: PASS with both structural and behavior assertions.

- [ ] **Step 5: Commit**

```bash
git add tests/claude-code/test-init-enhanced-workflow.sh
git commit -m "test: verify workflow init behavior"
```

## Task 4: Add legacy upgrade metadata backfill behavior test

**Files:**
- Create: `tests/claude-code/test-upgrading-enhanced-workflow-project.sh`

- [ ] **Step 1: Write the failing test**

Create a temp project representing a legacy enhanced project:
- `docs/superpowers/` exists
- `CLAUDE.md` contains legacy `## Enhanced Superpowers Workflow`
- at least one guidance file exists
- `version.json` is missing

The test should assert that the upgrade flow recognizes it as legacy-eligible and writes metadata with:
- `pluginVersion`
- `workflowTemplateVersion`
- `initializedAt: "legacy"`
- `lastUpgradedAt`

- [ ] **Step 2: Run test to verify it fails**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced && bash tests/claude-code/test-upgrading-enhanced-workflow-project.sh
```
Expected: FAIL because no behavioral test exists yet.

- [ ] **Step 3: Implement the test scenario**

Use a temp project and the local `upgrading-enhanced-workflow-project` maintenance skill contract to verify the expected metadata backfill behavior.

- [ ] **Step 4: Run test to verify it passes**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced && bash tests/claude-code/test-upgrading-enhanced-workflow-project.sh
```
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add tests/claude-code/test-upgrading-enhanced-workflow-project.sh
git commit -m "test: verify legacy workflow upgrade backfill"
```

## Task 5: Add decomposition/status behavior checks

**Files:**
- Modify: `tests/claude-code/test-decomposing-requirements.sh`
- Modify: `tests/claude-code/test-status-surface.sh`

- [ ] **Step 1: Add failing behavior assertions**

For decomposition:
- verify a generated decomposition output can be recognized as tracked and usable as a macro-level map

For status:
- verify a future session can identify `status.md` as the first recovery stop and recover the current artifact chain from it

- [ ] **Step 2: Run tests to verify they fail**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced && bash tests/claude-code/test-decomposing-requirements.sh
cd /Users/zyb/workspace/person/superpowers-enhanced && bash tests/claude-code/test-status-surface.sh
```
Expected: FAIL on the new behavior assertions.

- [ ] **Step 3: Implement minimal behavior coverage**

Keep the scenarios narrow and deterministic. Avoid broad, highly variable conversations; prefer artifact-oriented assertions when possible.

- [ ] **Step 4: Re-run both tests**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced && bash tests/claude-code/test-decomposing-requirements.sh
cd /Users/zyb/workspace/person/superpowers-enhanced && bash tests/claude-code/test-status-surface.sh
```
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add tests/claude-code/test-decomposing-requirements.sh tests/claude-code/test-status-surface.sh
git commit -m "test: add decomposition and recovery behavior checks"
```

## Self-Review

- **Spec coverage:**
  - fast suite stability → Tasks 1-2
  - helper contract stabilization → Task 1
  - init behavior → Task 3
  - legacy upgrade backfill behavior → Task 4
  - decomposition/status behavior → Task 5

- **Placeholder scan:**
  - all targeted files and commands are explicit
  - no unresolved TODO/TBD placeholders remain

- **Type consistency:**
  - fast suite = structural health check
  - behavior tests = slower, targeted scenario checks
  - metadata keys remain `pluginVersion`, `workflowTemplateVersion`, `initializedAt`, `lastUpgradedAt`

## Execution Handoff

**Plan complete and saved to `docs/superpowers/plans/2026-05-26-testing-system-upgrade.md`. Two execution options:**

**1. Subagent-Driven (recommended)** - I dispatch a fresh subagent per task, review between tasks, fast iteration

**2. Inline Execution** - Execute tasks in this session using executing-plans, batch execution with checkpoints

**Which approach?**
