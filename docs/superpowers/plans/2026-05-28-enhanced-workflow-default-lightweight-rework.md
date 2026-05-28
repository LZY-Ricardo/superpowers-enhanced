# Enhanced Workflow Default Lightweight Rework Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans by default for this plan. Use superpowers:subagent-driven-development only if a task is truly independent and the isolation cost is worth it. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the six approved workflow optimizations the shipped default behavior of the Enhanced Superpowers workflow and its downstream template outputs.

**Architecture:** Rework the workflow entrypoint and planning/completion defaults first, then align documenting semantics, supporting execution/scope skills, and shipped templates so the new lightweight path is described consistently everywhere. The implementation preserves the existing phase chain and artifact directories, but changes default execution, review, planning, logging, and completion behavior.

**Tech Stack:** Markdown skill specs, Markdown workflow templates, shell-based regression tests in `tests/claude-code/`, Node/npm test entrypoints from `package.json`

---

## File Structure

- `skills/using-enhanced-workflow/SKILL.md` — master workflow reference; must define the new lightweight default path.
- `skills/writing-plans/SKILL.md` — the most important behavioral pivot; must emit lightweight plans and review-config handoff.
- `skills/documenting-completion/SKILL.md` — must redefine completion summary as dashboard-style.
- `skills/documenting-execution/SKILL.md` — must define merged per-task execution blocks.
- `skills/documenting-verification/SKILL.md` — must align verification recording with merged execution blocks.
- `skills/documenting-review/SKILL.md` — must narrow review-log usage to external/cross-task/deferred review items.
- `skills/documenting-debugging/SKILL.md` — must keep standalone debugging docs only for issues worth preserving independently.
- `skills/brainstorming/SKILL.md` — must support lighter spec outputs and explicit size tiering.
- `skills/decomposing-requirements/SKILL.md` — must sharpen early-exit rules so decomposition does not over-trigger.
- `skills/executing-plans/SKILL.md` — must become inline-first and review-config aware.
- `skills/subagent-driven-development/SKILL.md` — must stop presenting itself as the default path.
- `skills/using-enhanced-workflow/docs-superpowers-README-template.md` — downstream README entrypoint.
- `skills/using-enhanced-workflow/docs-superpowers-workflow-template.md` — downstream workflow reference.
- `skills/using-enhanced-workflow/docs-superpowers-conventions-template.md` — downstream artifact format authority.
- `skills/using-enhanced-workflow/docs-superpowers-status-template.md` — downstream recovery/status surface.
- `tests/claude-code/` shell tests — likely need targeted expectation updates or new coverage for changed defaults.

---

### Task 1: Rework the master workflow and planning defaults

**Files:**
- Modify: `skills/using-enhanced-workflow/SKILL.md`
- Modify: `skills/writing-plans/SKILL.md`
- Test: `tests/claude-code/test-status-surface.sh`
- Test: `tests/claude-code/test-subagent-driven-development.sh`
- Test: `tests/claude-code/test-subagent-driven-development-integration.sh`

- [ ] **Step 0: Load review config**

Read or create the feature review config for this work. Because this rework changes the default workflow itself, the execution path for this plan should default to inline execution with task-level review off, feature-level review spec+code, and hybrid reviewer mode documented later in the plan.

- [ ] **Step 1: Write the failing test coverage for lightweight workflow defaults**

Add or extend shell test expectations so they assert the new defaults in text outputs. Start with checks that the workflow and plan entrypoints no longer present subagent-driven execution as the default recommendation and that size-based tiering is documented.

```bash
# Candidate checks to add to existing test scripts or a new focused shell test:
grep -q "Inline" skills/writing-plans/SKILL.md
grep -q "small / medium / large" skills/using-enhanced-workflow/SKILL.md
! grep -q "Subagent-Driven (recommended)" skills/writing-plans/SKILL.md
```

- [ ] **Step 2: Run the failing test to verify current behavior is still old**

Run: `bash tests/claude-code/test-subagent-driven-development.sh`
Expected: Existing text assumptions still reflect old defaults or the new assertions fail until the skill files are updated.

- [ ] **Step 3: Rewrite `skills/using-enhanced-workflow/SKILL.md` to define the new default workflow**

Implement these content changes in the skill:

```markdown
- Add an explicit size-tiering section: Small / Medium / Large with default phase behavior.
- Rewrite Phase 4 so the default task loop is:
  implement → verify → merged execution-log block → conditional external review → next task
- Replace fixed per-task documenting-execution / documenting-verification / documenting-review loop text with merged-block semantics and references to field ownership.
- Add review-config lifecycle: written after planning, loaded at task start, cited in task closeout.
- Reframe completion summary as a dashboard/hub.
```

Keep the phase order unchanged.

- [ ] **Step 4: Rewrite `skills/writing-plans/SKILL.md` to emit lightweight-default plans**

Implement these content changes in the skill:

```markdown
- Header text: Inline execution becomes the default recommendation; subagent-driven becomes optional.
- Task template gains:
  - Step 0: Load review config
  - failing test remains concrete
  - implementation steps use signatures + key diffs + pseudo-code + spec references
  - explicit closeout step for merged execution-log block
- Add execution handoff prompt that asks once for:
  - task-level review
  - feature-level review
  - review executor
- Require writing `docs/superpowers/plans/<feature-name>.review-config.md`
- Add self-review rule: plan should remain coherent if code blocks are stripped.
```

Use real wording in the skill, not placeholders.

- [ ] **Step 5: Run targeted verification on the rewritten workflow/planning skills**

Run: `bash tests/claude-code/test-subagent-driven-development.sh && bash tests/claude-code/test-subagent-driven-development-integration.sh`
Expected: PASS, or fail only where downstream expectations still need alignment in later tasks.

- [ ] **Step 6: Commit the workflow/planning rewrite**

```bash
git add skills/using-enhanced-workflow/SKILL.md skills/writing-plans/SKILL.md tests/claude-code/test-subagent-driven-development.sh tests/claude-code/test-subagent-driven-development-integration.sh tests/claude-code/test-status-surface.sh
git commit -m "feat: default enhanced workflow to lighter planning path"
```

- [ ] **Step 7: Write the merged execution-log block for Task 1**

Append one task block to `docs/superpowers/execution-log/2026-05-28-enhanced-workflow-default-lightweight-rework.md` with these sections:

```markdown
## Task 1: Rework the master workflow and planning defaults

**Execution**
- Rewrote `using-enhanced-workflow` and `writing-plans` to define size tiering, inline-first execution, lightweight planning, and review-config handoff.

**Verification**
- `bash tests/claude-code/test-subagent-driven-development.sh` → record actual PASS/FAIL result
- `bash tests/claude-code/test-subagent-driven-development-integration.sh` → record actual PASS/FAIL result

**Review (self-checklist)**
- Spec mapping: sections on tiering, inline default, lightweight plans, review-config covered.
- Interface consistency: terminology for task-level / feature-level / executor matches spec.
- Tests verify behavior: assertions exercise wording/defaults, not just file existence.
- Smell scan: no duplicate contradictory default language retained.
- Spec-stated boundaries covered: kept phase order unchanged.
- Plan deviation: No deviation / `DEVIATION: ...`

**Review (applied config)**
- Per review-config: task-level review off; external review deferred to feature-level unless deviation occurs.
- Plan deviation escalation: yes/no.

**Debugging**
- N/A
```

---

### Task 2: Redefine documenting semantics and completion output

**Files:**
- Modify: `skills/documenting-execution/SKILL.md`
- Modify: `skills/documenting-verification/SKILL.md`
- Modify: `skills/documenting-review/SKILL.md`
- Modify: `skills/documenting-debugging/SKILL.md`
- Modify: `skills/documenting-completion/SKILL.md`
- Test: `tests/claude-code/test-status-surface.sh`

- [ ] **Step 0: Load review config**

Read: `docs/superpowers/plans/2026-05-28-enhanced-workflow-default-lightweight-rework.review-config.md`
Apply the configured review strategy and preserve merged-block semantics.

- [ ] **Step 1: Write failing text assertions for documenting defaults**

Add or extend tests so they fail unless the documenting skills describe:
- one merged task block in execution-log
- review-log only for external/deferred/cross-task items
- debugging-log only for standalone investigations
- completion summary as dashboard/hub, not narrative recap

```bash
grep -q "merged" skills/documenting-execution/SKILL.md
grep -q "dashboard" skills/documenting-completion/SKILL.md
```

- [ ] **Step 2: Run the documenting-related test to confirm old assumptions still fail**

Run: `bash tests/claude-code/test-status-surface.sh`
Expected: FAIL or partial mismatch until the documenting skill texts and/or status expectations are updated.

- [ ] **Step 3: Rewrite execution/verification/review/debugging skill semantics**

Update the documenting skills so they express the new default behavior:

```markdown
`documenting-execution`:
- header + one task block per task
- fields: Execution / Verification / Review (self-checklist) / Review (applied config) / Debugging
- append-only stays true

`documenting-verification`:
- verification evidence belongs inside the task block by default
- standalone verification files are exceptional, not ordinary

`documenting-review`:
- self-review checklist does not create review-log entries
- review-log exists for external review cycles, deferred findings, and cross-task tracking

`documenting-debugging`:
- standalone issue files only when the investigation itself has reuse value
```

- [ ] **Step 4: Rewrite `skills/documenting-completion/SKILL.md` to use the dashboard model**

Replace recap-heavy defaults with a concise format that includes:

```markdown
- Date / branch / status
- Scope (one sentence)
- Spec coverage table
- Artifacts table
- Known issues / deferred
- Short summary / next steps
```

Also explicitly forbid retelling spec, task-by-task execution, review history, and debugging narratives.

- [ ] **Step 5: Run verification on documenting skill changes**

Run: `bash tests/claude-code/test-status-surface.sh`
Expected: PASS, or fail only where template files still need corresponding updates in later tasks.

- [ ] **Step 6: Commit the documenting rewrite**

```bash
git add skills/documenting-execution/SKILL.md skills/documenting-verification/SKILL.md skills/documenting-review/SKILL.md skills/documenting-debugging/SKILL.md skills/documenting-completion/SKILL.md tests/claude-code/test-status-surface.sh
git commit -m "feat: streamline enhanced workflow documentation defaults"
```

- [ ] **Step 7: Write the merged execution-log block for Task 2**

Append the Task 2 block to the execution log using the same field structure as Task 1, but describe the documenting-skill and completion-summary changes plus the verification command result.

---

### Task 3: Align supporting execution and scoping skills with the new defaults

**Files:**
- Modify: `skills/brainstorming/SKILL.md`
- Modify: `skills/decomposing-requirements/SKILL.md`
- Modify: `skills/executing-plans/SKILL.md`
- Modify: `skills/subagent-driven-development/SKILL.md`
- Test: `tests/claude-code/test-decomposing-requirements.sh`
- Test: `tests/claude-code/test-subagent-driven-development.sh`

- [ ] **Step 0: Load review config**

Read: `docs/superpowers/plans/2026-05-28-enhanced-workflow-default-lightweight-rework.review-config.md`
Apply it for this task.

- [ ] **Step 1: Write failing assertions for scope/execution alignment**

Add or adjust checks so the support skills fail unless they align with the new defaults:
- brainstorming supports lighter downstream planning without skipping design approval
- decomposition emphasizes early exit for single-concern work
- executing-plans no longer tells users subagents are categorically better
- subagent-driven-development no longer positions itself as the default path

```bash
! grep -q "quality of its work will be significantly higher if run on a platform with subagent support" skills/executing-plans/SKILL.md
! grep -q "Core principle: Fresh subagent per task" skills/subagent-driven-development/SKILL.md
```

- [ ] **Step 2: Run the failing support-skill tests**

Run: `bash tests/claude-code/test-decomposing-requirements.sh && bash tests/claude-code/test-subagent-driven-development.sh`
Expected: FAIL until wording and behavior are aligned.

- [ ] **Step 3: Rewrite the support skill wording**

Make these exact semantic shifts:

```markdown
`brainstorming`:
- keep hard design gate
- make medium-scope work and lighter plan handoff sound normal
- emphasize spec sections: constraints, interfaces, boundaries, acceptance criteria

`decomposing-requirements`:
- strengthen early-exit path
- avoid framing decomposition as default for merely non-trivial work

`executing-plans`:
- inline execution is the ordinary path
- must read review-config and obey it
- finish with the branch-finishing skill as before

`subagent-driven-development`:
- explicitly special-case / optional
- must read review-config
- must not imply mandatory two-stage per-task review for every task when config says otherwise
```

- [ ] **Step 4: Run verification on support-skill alignment**

Run: `bash tests/claude-code/test-decomposing-requirements.sh && bash tests/claude-code/test-subagent-driven-development.sh`
Expected: PASS.

- [ ] **Step 5: Commit the support-skill alignment**

```bash
git add skills/brainstorming/SKILL.md skills/decomposing-requirements/SKILL.md skills/executing-plans/SKILL.md skills/subagent-driven-development/SKILL.md tests/claude-code/test-decomposing-requirements.sh tests/claude-code/test-subagent-driven-development.sh
git commit -m "feat: align enhanced workflow support skills with lighter defaults"
```

- [ ] **Step 6: Write the merged execution-log block for Task 3**

Append the Task 3 block using the same field structure, including verification results for both shell tests.

---

### Task 4: Update shipped downstream templates and recovery surfaces

**Files:**
- Modify: `skills/using-enhanced-workflow/docs-superpowers-README-template.md`
- Modify: `skills/using-enhanced-workflow/docs-superpowers-workflow-template.md`
- Modify: `skills/using-enhanced-workflow/docs-superpowers-conventions-template.md`
- Modify: `skills/using-enhanced-workflow/docs-superpowers-status-template.md`
- Test: `tests/claude-code/test-init-enhanced-workflow.sh`
- Test: `tests/claude-code/test-upgrading-enhanced-workflow-project.sh`

- [ ] **Step 0: Load review config**

Read: `docs/superpowers/plans/2026-05-28-enhanced-workflow-default-lightweight-rework.review-config.md`
Apply it for this task.

- [ ] **Step 1: Write failing downstream-template assertions**

Add or update tests so generated/updated workflow docs fail unless they describe the new defaults. Ensure coverage for:
- size-based tiering
- review-config references
- merged execution-log block conventions
- dashboard-style completion summary
- status surface pointing to current config/recovery docs

```bash
grep -q "review-config" skills/using-enhanced-workflow/docs-superpowers-conventions-template.md
grep -q "dashboard" skills/using-enhanced-workflow/docs-superpowers-workflow-template.md
```

- [ ] **Step 2: Run template-generation tests to see current mismatches**

Run: `bash tests/claude-code/test-init-enhanced-workflow.sh && bash tests/claude-code/test-upgrading-enhanced-workflow-project.sh`
Expected: FAIL or mismatch until template sources are updated.

- [ ] **Step 3: Rewrite the template source files**

Apply these template changes:

```markdown
README template:
- quick navigation includes status recovery and review-config awareness
- completion summary described as final dashboard, not a narrative recap

workflow template:
- phase 4 loop shows inline-first path and merged task block
- size-tiering rules documented
- review-config lifecycle documented

conventions template:
- add `review-config.md` file purpose and format
- define merged task block fields
- define checklist and applied-config semantics
- redefine completion summary as dashboard

status template:
- include current review-config link/path
- include current execution/review mode snapshot for recovery
```

- [ ] **Step 4: Run verification on template changes**

Run: `bash tests/claude-code/test-init-enhanced-workflow.sh && bash tests/claude-code/test-upgrading-enhanced-workflow-project.sh`
Expected: PASS.

- [ ] **Step 5: Commit the template updates**

```bash
git add skills/using-enhanced-workflow/docs-superpowers-README-template.md skills/using-enhanced-workflow/docs-superpowers-workflow-template.md skills/using-enhanced-workflow/docs-superpowers-conventions-template.md skills/using-enhanced-workflow/docs-superpowers-status-template.md tests/claude-code/test-init-enhanced-workflow.sh tests/claude-code/test-upgrading-enhanced-workflow-project.sh
git commit -m "feat: ship lighter enhanced workflow templates by default"
```

- [ ] **Step 6: Write the merged execution-log block for Task 4**

Append the Task 4 block using the same field structure, including both template-upgrade test command results.

---

### Task 5: End-to-end verification and workflow artifact proof

**Files:**
- Modify: `docs/superpowers/execution-log/2026-05-28-enhanced-workflow-default-lightweight-rework.md`
- Modify: `docs/superpowers/review-log/2026-05-28-enhanced-workflow-default-lightweight-rework.md` *(only if feature-level review yields deferred/external findings)*
- Modify: `docs/superpowers/completion/2026-05-28-enhanced-workflow-default-lightweight-rework-summary.md`
- Test: `tests/claude-code/run-skill-tests.sh`
- Test: `tests/claude-code/test-init-enhanced-workflow.sh`
- Test: `tests/claude-code/test-upgrading-enhanced-workflow-project.sh`
- Test: `tests/claude-code/test-status-surface.sh`
- Test: `tests/claude-code/test-subagent-driven-development.sh`
- Test: `tests/claude-code/test-subagent-driven-development-integration.sh`
- Test: `tests/claude-code/test-decomposing-requirements.sh`

- [ ] **Step 0: Load review config**

Read: `docs/superpowers/plans/2026-05-28-enhanced-workflow-default-lightweight-rework.review-config.md`
Apply the configured feature-level review and completion rules.

- [ ] **Step 1: Write the final failing/coverage expectation for end-to-end artifacts**

Ensure the final verification checks will prove all six optimized defaults show up somewhere authoritative and that at least one representative artifact looks right.

```bash
# Artifact-oriented checks to perform after implementation:
grep -q "Step 0: Load review config" docs/superpowers/plans/2026-05-28-enhanced-workflow-default-lightweight-rework.md
grep -q "Review \(applied config\)" docs/superpowers/execution-log/2026-05-28-enhanced-workflow-default-lightweight-rework.md
```

- [ ] **Step 2: Run the full relevant regression suite**

Run: `bash tests/claude-code/run-skill-tests.sh`
Expected: PASS.

- [ ] **Step 3: Run targeted follow-up verification for touched workflow areas**

Run: `bash tests/claude-code/test-init-enhanced-workflow.sh && bash tests/claude-code/test-upgrading-enhanced-workflow-project.sh && bash tests/claude-code/test-status-surface.sh && bash tests/claude-code/test-subagent-driven-development.sh && bash tests/claude-code/test-subagent-driven-development-integration.sh && bash tests/claude-code/test-decomposing-requirements.sh`
Expected: PASS.

- [ ] **Step 4: Produce the final execution-log closeout and any external review record**

Write the Task 5 merged block into the execution log. If a feature-level external review produces deferred or cross-task findings, append them to `docs/superpowers/review-log/2026-05-28-enhanced-workflow-default-lightweight-rework.md`; otherwise keep review evidence inside the execution log only.

- [ ] **Step 5: Write the dashboard-style completion summary**

Create `docs/superpowers/completion/2026-05-28-enhanced-workflow-default-lightweight-rework-summary.md` with this exact structure:

```markdown
# Enhanced Workflow Default Lightweight Rework — Completion Summary

**Date:** 2026-05-28
**Branch:** record the actual branch name at write time
**Status:** ✅ Complete / ⚠️ Deferred items exist

## Scope
One sentence describing the delivered default-lightweight workflow behavior.

## Spec coverage
| Req | Status | Notes |
|---|---|---|
| Size-based tiering | ✅ | — |
| Inline default | ✅ | — |
| Skeleton plan output | ✅ | — |
| Merged task block | ✅ | — |
| Review config + hard rules | ✅ | — |
| Dashboard completion summary | ✅ | — |

## Artifacts
| Document | Link |
|---|---|
| Spec | `docs/superpowers/specs/2026-05-28-enhanced-workflow-default-lightweight-rework-design.md` |
| Plan | `docs/superpowers/plans/2026-05-28-enhanced-workflow-default-lightweight-rework.md` |
| Execution log | `docs/superpowers/execution-log/2026-05-28-enhanced-workflow-default-lightweight-rework.md` |
| Review log | `docs/superpowers/review-log/2026-05-28-enhanced-workflow-default-lightweight-rework.md` *(if created)* |

## Known issues / deferred
- Omit this section entirely if there are no real deferred items.
- Otherwise list each real deferred item as a checkbox with its tracking reference.

## Summary
One line on what shipped.
One line on deferred work or next step.
```

- [ ] **Step 6: Commit the verification artifacts and summary**

```bash
git add docs/superpowers/execution-log/2026-05-28-enhanced-workflow-default-lightweight-rework.md docs/superpowers/completion/2026-05-28-enhanced-workflow-default-lightweight-rework-summary.md docs/superpowers/review-log/2026-05-28-enhanced-workflow-default-lightweight-rework.md tests/claude-code/run-skill-tests.sh tests/claude-code/test-init-enhanced-workflow.sh tests/claude-code/test-upgrading-enhanced-workflow-project.sh tests/claude-code/test-status-surface.sh tests/claude-code/test-subagent-driven-development.sh tests/claude-code/test-subagent-driven-development-integration.sh tests/claude-code/test-decomposing-requirements.sh
git commit -m "test: verify lighter enhanced workflow defaults end to end"
```

---

## Self-Review Notes

### Spec coverage
- Goal / non-goals / default optimizations → Tasks 1–4 rewrite the shipped skills and templates.
- File-scope requirements → Tasks 1–4 touch every file family named in the spec.
- Artifact shape requirements → Tasks 1–4 update the generating skills/templates; Task 5 verifies produced artifacts.
- Verification strategy / acceptance criteria → Task 5 runs full and targeted test suites and writes dashboard completion output.

### Placeholder scan
- No `TBD`, `TODO`, or “similar to Task N” references used as substitute instructions.
- Paths are exact.
- Commands are concrete.
- Code-adjacent plan steps use concrete shell or markdown skeletons rather than vague prose.

### Type / terminology consistency
- `review-config.md`, `Review (self-checklist)`, `Review (applied config)`, `Step 0: Load review config`, and “inline default” wording are consistent across all tasks.
- The six optimization names match the approved spec.

---

## Review Config To Write Before Execution

When starting execution, create:
`docs/superpowers/plans/2026-05-28-enhanced-workflow-default-lightweight-rework.review-config.md`

with these initial choices:

```markdown
# Review Config for enhanced-workflow-default-lightweight-rework

**Configured at:** 2026-05-28
**Plan:** docs/superpowers/plans/2026-05-28-enhanced-workflow-default-lightweight-rework.md

## Choices
- Execution mode: Inline (`superpowers:executing-plans`)
- Task-level review: Off — use self-checklist only unless plan deviation triggers escalation
- Feature-level review: Spec + code
- Review executor: Hybrid — main session for task-time decisions, independent review only at feature level or on escalation

## Hard rules
- Self-checklist runs on every task
- Plan deviation triggers one escalation review regardless of task-level setting
- Feature-level review keeps at least one dimension enabled
- TDD failing-test step cannot be skipped

## How to use
- Each task starts by reading this file
- Each task block records how config was applied
- If a task deviates from plan, escalate once and record it
```
