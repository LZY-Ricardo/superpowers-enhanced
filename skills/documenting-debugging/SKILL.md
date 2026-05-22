---
name: documenting-debugging
description: Use after resolving a bug, test failure, or unexpected behavior — whether fixed or deferred. Records symptoms, root cause, fix method, and results so the same issue is not re-investigated.
---

# Documenting Debugging

Record debugging sessions as searchable knowledge. Prevents re-investigating the same issue and builds a corpus of patterns over time.

**Core principle:** Every bug you debug once should never need debugging again.

**Announce at start:** "I'm using the documenting-debugging skill to record the debugging session."

## Auto-Init

If `docs/superpowers/` does not exist, create the full directory structure. See documenting-execution's Auto-Init section for the commands.

## When to Use

**After resolving (or deferring) any debugging session:**
- Test failures during execution
- Bugs found in code review
- Unexpected behavior in verification
- Performance issues

**Don't use when:**
- Quick typo fix (obvious cause, obvious fix)
- No investigation was needed

## Output Location

`docs/superpowers/debugging-log/YYYY-MM-DD-<issue-brief>.md`

One file per issue. Cross-reference from execution log or review log.

## Log Format

```markdown
# [Issue Brief Title]

**Date:** YYYY-MM-DD
**Triggered by:** EXECUTION / REVIEW / VERIFICATION / MANUAL
**Context:** Task N from [feature plan] / Code review finding #N / Verification failure
**Status:** FIXED | DEFERRED | WORKAROUND

## Symptom
[What went wrong — error message, test failure, unexpected behavior]

## Root Cause
[The actual underlying cause, not the symptom]

## Investigation Path
1. [Step 1 — what you checked, what you found]
2. [Step 2 — ...]
3. [Concluded: root cause is X]

## Fix
[What was changed and why this fixes it]

**Commit:** `abc1234`

## Verification
[How you confirmed the fix works — test command, manual check]

## Lessons *(optional)*
[Pattern to watch for, preventive measure, or anything worth remembering]

## Cross-References
- Triggered by: [link to execution-log entry or review-log entry]
- Related debugging: [link to other debugging-log entries, if any]
```

## Key Principles

- **Root cause, not symptom** — "null pointer" is a symptom, "DB migration didn't backfill" is a root cause
- **Investigation path matters** — future readers learn from your dead ends too
- **Deferred issues must explain why** — and what would be needed to fix later
- **One issue per file** — makes searching and referencing easy
- **Bidirectional cross-reference** — link from execution-log/review-log TO here, AND from here back to the source

## Status Definitions

| Status | Meaning |
|--------|---------|
| FIXED | Root cause found, fix applied, verified |
| DEFERRED | Root cause found, fix postponed with reason |
| WORKAROUND | Symptom mitigated, root cause not addressed |

## Scope Boundary

Only debug issues **within the current task's scope.** If debugging reveals an unrelated problem:
1. Record the finding briefly in the execution log
2. File a separate issue or note for later — don't fix it now
3. Don't create a debugging-log entry for issues outside current scope

## Red Flags

| Thought | Reality |
|---------|---------|
| "Root cause is obvious, no need to record" | Obvious to you now ≠ obvious in 3 months |
| "I'll just note it in the commit message" | Commit messages don't show investigation path |
| "This is a one-off issue" | Same "one-off" will happen again in a different form |
| "Debugging log is overhead" | 5 minutes of writing saves 2 hours of re-investigation |
| "I found another bug while debugging, let me fix it too" | Stay in scope. Note it. Fix it in its own task. |
