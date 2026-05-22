---
name: documenting-completion
description: Use when finishing a development branch or sub-project — before merge or PR. Produces a completion summary that contrasts what was built against what was spec'd, lists known issues, and recommends next steps.
---

# Documenting Completion

Write a final completion summary that captures the full picture of what was built, what diverged from spec, and what's left. This is the handoff document for anyone (human or AI) who interacts with this work afterward.

**Core principle:** If someone reads only this document, they should understand what was done, what wasn't, and what to watch out for.

**Announce at start:** "I'm using the documenting-completion skill to write the completion summary."

## Auto-Init

If `docs/superpowers/` does not exist, create the full directory structure. See documenting-execution's Auto-Init section for the commands.

## When to Use

**At the end of a development cycle:**
- Before merge to main
- Before creating a PR
- After all tasks in a sub-project are complete
- When wrapping up a worktree

**Don't use when:**
- Mid-implementation (use documenting-execution instead)
- Only a single trivial change that took < 5 minutes

## Data Gathering

Before writing the summary, collect data from:
- **Spec doc** → for Spec vs. Implementation comparison
- **Execution log** → for task statistics, deviations, and timeline
- **Review log** → for review findings, deferred items, and rejected suggestions
- **Debugging log** → for issues encountered and patterns discovered

Do not rely on memory or git log alone — the documenting skills captured more detail than git can show.

## Output Location

`docs/superpowers/completion/YYYY-MM-DD-<feature-name>-summary.md`

Use the same `<feature-name>` as the plan and execution log.

## Document Format

```markdown
# [Feature Name] — Completion Summary

**Date:** YYYY-MM-DD
**Branch:** [branch name]
**Spec:** [link to spec doc]
**Plan:** [link to plan doc]
**Execution log:** [link to execution log]
**Review log:** [link to review log]

## What Was Built

[2-3 sentence summary of the final implementation]

## Spec vs. Implementation

| Spec Requirement | Status | Notes |
|-----------------|--------|-------|
| [Requirement 1] | DONE | — |
| [Requirement 2] | DONE | Simplified from original spec |
| [Requirement 3] | PARTIAL | See known issues |
| [Requirement 4] | CUT | Reason: YAGNI / deprioritized by human partner |

## Execution Summary

- **Tasks planned:** N
- **Tasks completed:** N
- **Tasks deviated:** N *(link to execution log for details)*
- **Tasks skipped:** N

## Review History

- **Review cycles:** N
- **Critical issues found:** N (all fixed)
- **Important issues found:** N (N fixed, N deferred)
- **Deferred items:** *(link to review log for details, or list here)*

## Debugging Summary

- **Issues debugged:** N
- **Patterns discovered:** *(if any recurring patterns from debugging-log)*
- **Deferred issues:** *(link to debugging-log for details)*

## Known Issues & Limitations

| Issue | Impact | Workaround | Priority |
|-------|--------|------------|----------|
| [Issue description] | [What it affects] | [How to work around] | HIGH/MEDIUM/LOW |

## Deferred Items *(aggregated from review log and debugging log)*

| Item | Source | Reason | Prerequisite |
|------|--------|--------|-------------|
| [What was deferred] | Review finding #N / Debugging session | [Why] | [What needs to happen first] |

## Files Changed

| File | Change Type | Purpose |
|------|------------|---------|
| `src/auth.ts` | Created | Core authentication logic |
| `tests/auth.test.ts` | Created | Auth test suite |
| `src/middleware.ts` | Modified | Added auth middleware |

## Next Steps

1. [Recommended next action]
2. [Follow-up work]
3. [Monitoring / observability needs]
```

## PR Integration

When creating a PR after this summary:
- **PR description should link to this summary** — not duplicate it
- PR body can be a condensed version: summary link + key changes + test plan
- This summary is the source of truth; PR description is the summary of the summary

## Key Principles

- **Be honest about gaps** — PARTIAL or CUT requirements are facts, not failures
- **Known issues prevent surprises** — document even minor limitations
- **Deferred items must be actionable** — include what's needed to unblock them
- **Next steps are recommendations** — your human partner decides what to actually do
- **This document is the handoff** — anyone should be able to pick up from here
- **Gather from documenting skills, not from memory** — execution/review/debugging logs have the detail

## Red Flags

| Thought | Reality |
|---------|---------|
| "Everything went as planned, summary is unnecessary" | "As planned" is the most important thing to confirm |
| "I'll list the issues later" | Without a record, issues become someone else's surprise |
| "The PR description covers this" | PR descriptions are short and don't cover deviations or deferred items |
| "Nobody reads these" | Future-you reads these. Future-AI reads these. Write for them. |
| "I can write this from git log" | Git log shows what changed, not why, and misses debugging/review context |
