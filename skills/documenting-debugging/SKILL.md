---
name: documenting-debugging
description: Use after resolving a bug, test failure, or unexpected behavior — whether fixed or deferred — when the investigation is worth preserving as standalone knowledge.
---

# Documenting Debugging

Record debugging sessions as searchable knowledge when the investigation itself is worth preserving. Prevents re-investigating the same issue and builds a corpus of patterns over time.

**Core principle:** A substantial bug investigation should not have to happen twice.

**Announce at start:** "I'm using the documenting-debugging skill to record the debugging session."

## When to Use

**Use this after resolving (or deferring) a meaningful debugging session:**
- Test failures during execution that required real investigation
- Bugs found in external review that required root-cause work
- Unexpected behavior in verification where the investigation path is reusable
- Performance issues with non-obvious diagnosis

**Don't use when:**
- Quick typo fix
- Obvious syntax error
- Small correction that needed no real investigation
- The debugging note can fit cleanly inside the task block's `Debugging` line

## Output Location

`docs/superpowers/debugging-log/YYYY-MM-DD-<issue-brief>.md`

One file per issue. Cross-reference it from the execution log or review log.

## Lightweight Default Boundary

The default workflow does **not** create a debugging-log entry for every failed command.

Use a standalone debugging file only when at least one is true:
- the root cause was non-obvious
- the investigation path would help a future human or AI
- the issue is deferred and needs future pickup
- the issue spans multiple tasks or review cycles

Otherwise, keep the debugging note inline in the task block as `Debugging: N/A` or a short sentence.

## Log Format

```markdown
# [Issue Brief Title]

**Date:** YYYY-MM-DD
**Triggered by:** EXECUTION / REVIEW / VERIFICATION / MANUAL
**Context:** Task N from [feature plan] / Review cycle RC-N / Verification failure
**Status:** FIXED | DEFERRED | WORKAROUND

## Symptom
[What went wrong]

## Root Cause
[Underlying cause]

## Investigation Path
1. [What you checked]
2. [What you found]
3. [How you reached root cause]

## Fix
[What changed and why it fixes the issue]

## Verification
[How you confirmed the fix or characterized the deferral]

## Cross-References
- Triggered by: [execution-log or review-log link]
- Related debugging: [other debugging-log links, if any]
```

## Key Principles

- **Root cause, not symptom** — the real value is why the issue happened
- **Investigation path matters** — reusable investigations justify this file
- **Deferred issues must explain why** — and what would be needed later
- **One issue per file** — makes searching and linking easy
- **Stay in scope** — unrelated discoveries should be noted, not fixed opportunistically

## Red Flags

| Thought | Reality |
|---------|---------|
| "Every failed test deserves a debugging file" | No. Most failures only need a line in the task block. |
| "This was confusing to me once, so I should always preserve it" | Preserve only investigations with reuse value, not every bump in the road. |
| "I found another unrelated bug while debugging, let me fix it too" | Stay in scope. Note it and move on. |
