---
name: documenting-execution
description: Use when completing each task in plan execution. Records task status, verification, applied review strategy, and implementation decisions to a living execution log.
---

# Documenting Execution

Append execution progress to a living log as each task completes. Creates a traceable record of what was actually built vs. what was planned.

**Core principle:** Plans describe intent. Execution logs describe reality. Both must exist.

**Announce at start:** "I'm using the documenting-execution skill to record task progress."

## When to Use

**After each task** in plan execution (`executing-plans` or `subagent-driven-development`):
- Task completed successfully
- Task blocked or skipped
- Task deviated from plan
- Task partially completed before being blocked

**Don't use when:**
- No plan exists (ad-hoc work doesn't need execution logging)
- Only exploring or researching, not implementing

## Auto-Init

If `docs/superpowers/` does not exist in the project, create it before writing:

```bash
mkdir -p docs/superpowers/{decomposition,specs,plans,execution-log,debugging-log,review-log,completion}
```

Also check if `docs/superpowers/README.md` exists. If not, copy the template:

```bash
cp ~/.claude/skills/using-enhanced-workflow/docs-superpowers-README-template.md docs/superpowers/README.md
```

This ensures the documentation structure is always ready, even if the using-enhanced-workflow skill was not invoked.

## Output Location

`docs/superpowers/execution-log/YYYY-MM-DD-<feature-name>.md`

Use the same `<feature-name>` as the plan file for traceability. One file per feature. Append entries as tasks complete.

## File Header

Create this header on first entry:

```markdown
# Execution Log: [Feature Name]

**Plan:** [link to plan doc]
**Spec:** [link to spec doc]
**Started:** YYYY-MM-DD

---
```

## Default Entry Format

The default enhanced workflow writes **one merged block per task**. Do not split execution, verification, and self-review into separate task-time entries unless a project has explicitly chosen a heavier workflow.

```markdown
## Task N: [Task Name]

**Execution**
- What was implemented
- Key plan-vs-reality deviations (if any)

**Verification**
- Exact commands run
- Actual PASS/FAIL outcomes
- Any uncovered areas or intentional skips

**Review (self-checklist)** — record the ✅/❌/N/A outcomes produced in the plan's Step 5; the agent must not re-execute the checklist here
- Spec mapping: [result + note]
- Interface consistency: [result + note]
- Tests verify behavior: [result + note]
- Smell scan: [result + note]
- Spec-stated boundaries covered: [result + note]
- Plan deviation check: [result + note]

**Review (applied config)**
- What `review-config.md` required for this task
- Whether task-level external review ran
- Whether plan-deviation escalation was triggered

**Debugging**
- `N/A`, inline note, or link to standalone debugging-log entry

**Carryover** *(optional; fill only when intentional interim state is left)*
- Interim state left behind: [specific behavior / placeholder implementation / temporary variable]
- Subsequent task that will close it out: Task N
- Why not closed now: [ordering rationale; "I didn't feel like it" is not acceptable]

---
```

**Carryover and Smell #7 (Implicit contract) — how they relate:**
- Carryover field filled in → the contract is made explicit → Smell #7 does not trigger
- Carryover not filled but code still has a placeholder → Smell #7 triggers as unhandled → ❌

## Self-Checklist Definitions

Each Step 5 self-checklist item must produce **action + evidence + a binary pass/fail call**. Writing only `✅` without evidence is not a valid checklist outcome.

| # | Item | Action | Evidence | Pass / Fail / N/A |
|---|---|---|---|---|
| 1 | **Spec mapping** | For each scope point in the task, locate the matching spec §X.Y | List of `scope point → §X.Y → one-line quote` | All mapped → ✅; any unmapped → ❌; pure refactor with no spec → N/A (requires human partner sign-off, recorded in log) |
| 2 | **Interface consistency** | For each new or changed signature / prop / type, grep call sites and verify they match | List of `signature → call-site grep results` | All match → ✅; any mismatch → ❌; task does not touch any public interface (e.g., pure CSS) → N/A with justification |
| 3 | **Tests verify behavior** | For the failing test from Step 1, name the spec behavior it asserts and the pre-implementation failure reason | One line: `test name → spec behavior → pre-impl failure reason` | Both present → ✅; spec explicitly waives tests for this work → N/A with spec §X.Y citation |
| 4 | **Smell scan** | Walk the fixed 8-item smell checklist below, mark each item | 8 bullets: `not triggered / triggered & handled / triggered & unhandled` | All not-triggered or handled → ✅; any unhandled → ❌; N/A not allowed |
| 5 | **Spec-stated boundaries covered** | List spec's "Out of scope" items and "Acceptance criteria" boundaries; verify each one | Two lists: out-of-scope vs respected; acceptance boundary vs respected | All respected → ✅; any crossed → ❌; N/A not allowed |
| 6 | **Plan deviation check** (**binary**) | `git diff` vs the plan's task description. **Any code change outside the plan's described scope is a DEVIATION**. Rationalizations like "equivalent", "lint requires it", "behaviorally identical" are NOT valid grounds for ✅ | `no deviation` line OR `deviation list: file + line range + one-line reason` | No deviation → ✅; any deviation → ❌, **escalation required** (mark in log; trigger one review per review-config regardless of task-level setting); N/A not allowed; "but it's equivalent" not allowed |

### Smell Scan Checklist (fixed 8 items, language-agnostic)

1. Type / signature escape hatches (`any`, untyped exceptions, `as unknown`)
2. Debug residue (`console.*`, `debugger`, commented-out code blocks)
3. Async path three-branch coverage (success / failure / cleanup all handled)
4. Resource lifecycle (timer / listener / ref / subscription cleaned up where appropriate)
5. Boundary inputs (null / 0 / empty collection / negative / oversized)
6. Concurrency / race conditions (multiple entry points to shared state, stale callbacks overwriting newer values)
7. **Implicit contract** (you assume a consumer / selector / regex will not match certain things, but no structural guarantee enforces it)
8. Magic literals (unnamed constants, repeated thresholds, untyped string enums)

### Smell #7 anchor examples (to prevent semantic drift)

**Triggers**:
- Focus trap sentinel `<span tabIndex={0}>` combined with selector `[tabindex]:not([tabindex="-1"])`: the code assumes the selector will not match the sentinel, but it does
- Regex `/^https?:/` assumed not to match `httpsfoo://` (if the business later allows new schemes): the future scheme list is an implicit contract
- Prop-name convention (e.g., a React upload component assuming the parent passes `onUpload`) not enforced in a TS type: the contract lives only in documentation

**Does not trigger**:
- Using `Array.isArray(x)` to guard non-arrays: the contract is enforced in code
- Using an enum to constrain a status field: the contract lives in the type
- Throwing a typed exception that consumers must catch: the contract is carried by the type

## What Belongs Here vs Elsewhere

- **Execution log (default):** the merged block above for every completed task
- **Review log:** only for external review cycles, deferred findings, or cross-task findings worth tracking independently
- **Debugging log:** only when the investigation itself has standalone reuse value

This means self-review checklist output stays in the execution log by default and does **not** create a review-log entry by itself.

## Status Definitions

| Status shape | Meaning |
|--------------|---------|
| Normal merged block | Task completed and recorded in one place |
| Blocked note inside merged block | Task stopped with a real blocker |
| Deviation note inside merged block | Task intentionally diverged from plan and recorded why |

## Key Principles

- **Append only at EOF, in temporal order** — every task block must be appended to the end of the file, ordered by completion time. Forbidden: (a) inserting new blocks into the middle of the file; (b) reordering existing blocks (even to "match task #" order). Readers trace through the timeline, not by task number; task # order is provided by the plan index, not by log file order
- **One merged block per task** — default path for the lightweight workflow
- **Record why, not just what** — the reason behind a deviation matters more than the deviation itself
- **List the actual verification evidence** — pass/fail is not assumed
- **Apply the review config explicitly** — each task block should show how the configured review policy was used
- **Cross-reference standalone debugging** — if a task required a reusable investigation, link it

## Red Flags

| Thought | Reality |
|---------|---------|
| "I'll write execution now and verification later" | The default path is one merged task block after the task's execution/verification cycle closes. |
| "This task went exactly as planned, so it doesn't need a log entry" | "As planned" is useful execution data — record it anyway. |
| "Self-review belongs in review-log" | No. Self-review checklist stays in the execution log by default. |
| "I'll skip the explicit Step 5 and just fill the checklist section in the log" | No. Step 5 is an executable task step with a stop-on-`❌` rule. The log section only records what Step 5 already produced. |
| "I need a separate documenting skill call for every task sub-step" | No. The lightweight default uses one execution-log block per task. |
| "Task N block ended up before Task M, let me swap them to match task # order" | Don't swap. The execution-log is a timeline ordered by completion time. Task # order is available in the plan. |

