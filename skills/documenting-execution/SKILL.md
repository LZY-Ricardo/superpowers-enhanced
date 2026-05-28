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

---
```

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

- **Append only** — never edit past task blocks
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

