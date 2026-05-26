# Template Source-of-Truth Convergence Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make project guidance files come from one canonical template set by adding a dedicated project `CLAUDE.md` template and making `init-enhanced-workflow` consume template files instead of embedding duplicated rule text.

**Architecture:** Keep the existing `skills/using-enhanced-workflow/` directory as the near-term template home. Add a new `docs-project-claude-template.md` file there, then update `init-enhanced-workflow` to consume the four template files as data sources. Introduce explicit marker boundaries in the project `CLAUDE.md` template so future upgrade logic can replace that block safely.

**Tech Stack:** Markdown skill docs, shell-based file copy workflow, repository shell tests

---

## File Structure

- `skills/using-enhanced-workflow/docs-project-claude-template.md` — new canonical project `CLAUDE.md` template with explicit marker boundaries
- `skills/init-enhanced-workflow/SKILL.md` — init procedure updated to copy/insert template content instead of embedding the project workflow block inline
- `skills/using-enhanced-workflow/SKILL.md` — optional small wording sync if needed so references to first-time setup stay consistent with template-based approach
- `tests/claude-code/test-init-enhanced-workflow.sh` — new targeted test for template-driven init behavior
- `tests/claude-code/run-skill-tests.sh` — register new fast test if needed

## Task 1: Add canonical project CLAUDE template

**Files:**
- Create: `skills/using-enhanced-workflow/docs-project-claude-template.md`
- Test: `tests/claude-code/test-init-enhanced-workflow.sh`

- [ ] **Step 1: Write the failing test for the new template file expectation**

Add a shell test that fails if the file does not exist or is missing marker boundaries:

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
TEMPLATE="$PLUGIN_DIR/skills/using-enhanced-workflow/docs-project-claude-template.md"

[ -f "$TEMPLATE" ]
grep -q '<!-- ENHANCED-SUPERPOWERS:START -->' "$TEMPLATE"
grep -q '<!-- ENHANCED-SUPERPOWERS:END -->' "$TEMPLATE"
```

- [ ] **Step 2: Run test to verify it fails**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced && bash tests/claude-code/test-init-enhanced-workflow.sh
```
Expected: FAIL because `docs-project-claude-template.md` does not exist yet.

- [ ] **Step 3: Create the canonical template file**

Write `skills/using-enhanced-workflow/docs-project-claude-template.md` with this content:

```md
<!-- ENHANCED-SUPERPOWERS:START -->

## Enhanced Superpowers Workflow

This project uses the Enhanced Superpowers workflow. The following rules are MANDATORY for all AI agents.

### Mandatory Rules

1. **Before writing ANY code**, invoke `brainstorming` skill (Superpowers). No exceptions.
2. **Before executing**, invoke `writing-plans` skill (Superpowers). No exceptions.
3. **After each task commit**, invoke `documenting-execution` skill.
4. **After each verification run**, invoke `documenting-verification` skill.
5. **After each code review cycle**, invoke `documenting-review` skill.
6. **If review finds issues, fix them, run verification, then prefer the original reviewer for re-check.** If the original reviewer is unavailable or still lacks context after a concise recap, fall back to a fresh reviewer.
7. **After resolving any bug**, invoke `documenting-debugging` skill.
8. **Before merge or PR**, invoke `documenting-completion` skill.
9. **For large requirements** (3+ features or subsystems), invoke `decomposing-requirements` skill BEFORE brainstorming.

### Strict Prohibitions

- Do NOT write code before brainstorming is approved by the human partner.
- Do NOT claim work is complete without running verification commands.
- Do NOT silently drop review findings. Every finding = FIXED, DEFERRED (with reason), or REJECTED (with evidence).
- Do NOT skip verification before re-review.
- Do NOT replace re-review with implementer self-assertion. Prefer the original reviewer; use a fresh reviewer only as fallback.
- Do NOT merge or create PR before the completion summary is written.
- Do NOT leave documentation updates uncommitted at session end.

### Documentation

- All workflow docs go in `docs/superpowers/` — see `docs/superpowers/README.md` for full details.
- Documentation is MANDATORY when using this workflow. Ad-hoc changes under 30 minutes are exempt.

<!-- ENHANCED-SUPERPOWERS:END -->
```

- [ ] **Step 4: Run test to verify it passes**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced && bash tests/claude-code/test-init-enhanced-workflow.sh
```
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add skills/using-enhanced-workflow/docs-project-claude-template.md tests/claude-code/test-init-enhanced-workflow.sh
git commit -m "feat: add canonical project claude template"
```

## Task 2: Refactor init-enhanced-workflow to consume the template file

**Files:**
- Modify: `skills/init-enhanced-workflow/SKILL.md`
- Test: `tests/claude-code/test-init-enhanced-workflow.sh`

- [ ] **Step 1: Extend the failing test to detect inline duplication**

Add assertions that the skill no longer embeds the full workflow block inline and instead references the template file:

```bash
INIT_SKILL="$PLUGIN_DIR/skills/init-enhanced-workflow/SKILL.md"
! grep -q '## Enhanced Superpowers Workflow' "$INIT_SKILL"
grep -q 'docs-project-claude-template.md' "$INIT_SKILL"
```

- [ ] **Step 2: Run test to verify it fails**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced && bash tests/claude-code/test-init-enhanced-workflow.sh
```
Expected: FAIL because the inline block still exists.

- [ ] **Step 3: Replace inline CLAUDE guidance with template-driven instructions**

Update `skills/init-enhanced-workflow/SKILL.md` so Step 3 says, in substance:

```md
## Step 3: Write Project CLAUDE.md

Copy the project CLAUDE template from the plugin template set.

If `CLAUDE.md` does not exist, create it from the template.
If `CLAUDE.md` already exists, append the template block below existing content.
Do NOT overwrite existing project-specific guidance.

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
```

Keep Step 4 for the three docs templates, but now all project guidance comes from four template files.

- [ ] **Step 4: Run test to verify it passes**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced && bash tests/claude-code/test-init-enhanced-workflow.sh
```
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add skills/init-enhanced-workflow/SKILL.md tests/claude-code/test-init-enhanced-workflow.sh
git commit -m "refactor: make init consume claude template"
```

## Task 3: Add explicit legacy-upgrade contract to the init design surface

**Files:**
- Modify: `skills/init-enhanced-workflow/SKILL.md`
- Modify: `skills/using-enhanced-workflow/SKILL.md`
- Test: `tests/claude-code/test-init-enhanced-workflow.sh`

- [ ] **Step 1: Extend the failing test for marker-based upgrade expectations**

Add assertions that the project template contains the marker boundaries and that init references append/create behavior rather than overwrite behavior:

```bash
grep -q 'ENHANCED-SUPERPOWERS:START' "$PLUGIN_DIR/skills/using-enhanced-workflow/docs-project-claude-template.md"
grep -q 'If `CLAUDE.md` already exists, append' "$INIT_SKILL"
```

- [ ] **Step 2: Run test to verify it fails if wording is missing**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced && bash tests/claude-code/test-init-enhanced-workflow.sh
```
Expected: FAIL if append/marker contract is not fully present.

- [ ] **Step 3: Add explicit wording to the runtime references**

Update the relevant sections so they explicitly state:
- project `CLAUDE.md` workflow content comes from a canonical template file
- upgrade tooling should later replace only the marker block inside project `CLAUDE.md`
- `using-enhanced-workflow/SKILL.md` remains runtime reference, not the project-copy source

- [ ] **Step 4: Run test to verify it passes**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced && bash tests/claude-code/test-init-enhanced-workflow.sh
```
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add skills/init-enhanced-workflow/SKILL.md skills/using-enhanced-workflow/SKILL.md tests/claude-code/test-init-enhanced-workflow.sh
git commit -m "docs: clarify template ownership and marker contract"
```

## Task 4: Register the new test in the standard fast test path

**Files:**
- Modify: `tests/claude-code/run-skill-tests.sh`
- Test: `tests/claude-code/test-init-enhanced-workflow.sh`

- [ ] **Step 1: Write the failing test expectation for test runner coverage**

Add an assertion block in `test-init-enhanced-workflow.sh` or check manually that the runner includes it.

- [ ] **Step 2: Run the existing fast test runner to confirm the new test is not yet included**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced && bash tests/claude-code/run-skill-tests.sh
```
Expected: `test-init-enhanced-workflow.sh` is not part of the executed test list.

- [ ] **Step 3: Register the test**

Update `tests/claude-code/run-skill-tests.sh` to include:

```bash
./test-init-enhanced-workflow.sh
```

in the fast test set near the other shell-based skill checks.

- [ ] **Step 4: Run the fast test runner to verify it passes with the new test included**

Run:
```bash
cd /Users/zyb/workspace/person/superpowers-enhanced && bash tests/claude-code/run-skill-tests.sh
```
Expected: the new init-template test runs and passes alongside the existing suite.

- [ ] **Step 5: Commit**

```bash
git add tests/claude-code/run-skill-tests.sh tests/claude-code/test-init-enhanced-workflow.sh
git commit -m "test: cover template-driven workflow init"
```

## Self-Review

- **Spec coverage:**
  - Canonical project CLAUDE template file added → Task 1
  - `init-enhanced-workflow` stops embedding duplicated CLAUDE text → Task 2
  - Marker-based future upgrade contract clarified → Task 3
  - Basic automated coverage for the new structure → Task 4

- **Placeholder scan:**
  - No `TODO`, `TBD`, or unresolved references remain.
  - All changed files and commands are explicit.

- **Type consistency:**
  - Template filename is consistently `docs-project-claude-template.md`.
  - Template directory path is consistently `skills/using-enhanced-workflow/`.
  - Marker names are consistently `ENHANCED-SUPERPOWERS:START/END`.

## Execution Handoff

**Plan complete and saved to `docs/superpowers/plans/2026-05-26-template-source-of-truth-convergence.md`. Two execution options:**

**1. Subagent-Driven (recommended)** - I dispatch a fresh subagent per task, review between tasks, fast iteration

**2. Inline Execution** - Execute tasks in this session using executing-plans, batch execution with checkpoints

**Which approach?**
