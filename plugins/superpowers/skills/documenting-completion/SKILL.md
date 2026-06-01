---
name: documenting-completion
description: Use when finishing a development branch or sub-project — before merge or PR. Produces a concise completion dashboard that shows delivery status, artifact links, known issues, and next steps.
---

# Documenting Completion

Write a final completion summary that acts as the handoff dashboard for the work. It should tell future readers what shipped, what remains, and where the detailed artifacts live — without retelling the entire project history.

**Core principle:** Completion summary is a dashboard, not a document.

**Announce at start:** "I'm using the documenting-completion skill to write the completion summary."

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

Before writing the summary, gather data from:
- **Spec doc** → for spec coverage status
- **Plan doc** → for artifact linkage
- **Execution log** → for what was actually completed and verified
- **Review log** → only for unresolved/deferred external review items
- **Debugging log** → only for unresolved or especially relevant investigations

Do not rely on memory or git log alone.

## Output Location

`docs/superpowers/completion/YYYY-MM-DD-<feature-name>-summary.md`

Use the same `<feature-name>` as the plan and execution log.

## Default Dashboard Format

```markdown
# [Feature Name] — Completion Summary

**Date:** YYYY-MM-DD
**Branch:** [actual branch name]
**Status:** ✅ Complete / ⚠️ Deferred items exist

## Scope
One sentence describing what the feature delivers.

## Spec coverage
| Req | Status | Notes |
|---|---|---|
| [Requirement / section] | ✅ | — |
| [Requirement / section] | ⚠️ | Deferred — see review-log |

## Artifacts
| Document | Link |
|---|---|
| Spec | [link] |
| Plan | [link] |
| Execution log | [link] |
| Review log | [link if relevant] |
| Debugging log | [link if relevant] |

## Known issues / deferred
- [Only list real deferred items. Omit the section entirely if there are none.]

## Summary
One line on what shipped.
One line on the immediate next step or deferred follow-up.
```

## Explicit Non-Goals

Do **not** use the completion summary to:
- retell the spec section by section
- replay task-by-task implementation history
- restate fixed review findings
- retell debugging narratives
- duplicate plan architecture prose

Those belong in the source artifacts. Link to them instead.

## PR Integration

When creating a PR after this summary:
- **PR description should link to this summary** rather than duplicate it
- PR body can be a condensed version: summary link + key changes + test plan
- This summary is the source-of-truth dashboard; the PR description is the short announcement

## Key Principles

- **Be honest about gaps** — deferred items are facts, not failures
- **Link to the source artifacts** — the summary should not become a recap monster
- **Known issues prevent surprises** — include real limitations and unresolved findings
- **Next steps are recommendations** — your human partner decides what to actually do
- **Write for future readers** — human and AI both need a quick, trustworthy entry page

## Red Flags

| Thought | Reality |
|---------|---------|
| "If someone reads only this file, they should know every detail" | They should know the status and where to click next, not every detail. |
| "I'll copy the execution-log into the summary so it's self-contained" | That turns the summary into a token sink. Link instead. |
| "PR description already covers this" | PR descriptions are shorter and should point back here. |
| "Nobody reads these" | Future-you and future-AI do. Keep it short enough that they actually will. |
