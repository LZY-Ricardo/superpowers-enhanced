---
name: documenting-execution
description: Use when completing each task in plan execution, after code is committed. Records task status, deviations from plan, and implementation decisions to a living execution log.
---

# Documenting Execution

Append execution progress to a living log as each task completes. Creates a traceable record of what was actually built vs. what was planned.

**Core principle:** Plans describe intent. Execution logs describe reality. Both must exist.

**Announce at start:** "I'm using the documenting-execution skill to record task progress."

## When to Use

**After each task** in plan execution (executing-plans or subagent-driven-development):
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

## Log Entry Format

Append one entry per task:

```markdown
### Task N: [Task Name] — [Status]

**Status:** DONE | PARTIAL | BLOCKED | SKIPPED | DEVIATED

**Completed at:** YYYY-MM-DD HH:MM

**What was implemented:**
[Brief description of actual implementation]

**Plan vs. Reality:** *(only if different from plan)*
- Planned: [what the plan said]
- Actual: [what was actually done]
- Reason: [why it changed]

**Decisions made:**
- [Decision and brief reason, if any]

**Commits:** `abc1234` [message] | `def5678` [message] *(list all commits for this task)*

**Related debugging:** *(if applicable)*
- → [link to debugging-log entry]

---
```

## Status Definitions

| Status | Meaning |
|--------|---------|
| DONE | Implemented as planned, tests pass, committed |
| PARTIAL | Some work committed, but blocked before completion |
| BLOCKED | Cannot proceed at all, reason documented |
| SKIPPED | Deliberately skipped, reason documented |
| DEVIATED | Implemented differently from plan, reason documented |

## Key Principles

- **Append only** — never edit past entries
- **Honest about deviations** — deviations aren't failures, they're valuable data for future planning
- **Record why, not just what** — the reason behind a deviation is more useful than the deviation itself
- **One entry per task** — don't batch multiple tasks into one entry
- **List all commits** — a task may have multiple commits, list them all
- **Cross-reference debugging** — if a task required debugging, link to the debugging-log entry

## Red Flags

| Thought | Reality |
|---------|---------|
| "I'll log after a few tasks" | Memory degrades fast. Log after each task. |
| "This task went exactly as planned" | Record it anyway — "as planned" is useful data too |
| "Nobody will read this" | Future-you and future-AI will. Deviations prevent repeated mistakes. |
| "I'll just update the plan file" | Plan = intent. Log = reality. They serve different purposes. |

## Git Integration

Commit execution log updates alongside code changes, or in a separate documentation commit at natural checkpoints (after every 3-5 tasks, or after a review cycle). Do not leave execution log updates uncommitted at session end.
