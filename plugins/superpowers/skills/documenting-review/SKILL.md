---
name: documenting-review
description: Use after an external code review cycle completes — whether findings were fixed, deferred, or rejected. Records issues found, actions taken, and deferred items so nothing is lost between review and resolution.
---

# Documenting Review

Record external review findings and their resolution. Prevents review feedback from vanishing after the reviewer session ends and creates an auditable trail of quality decisions.

**Core principle:** Every external review finding has a resolution. No finding is silently dropped.

**Announce at start:** "I'm using the documenting-review skill to record review findings."

## When to Use

**Use this only after an external review cycle:**
- Spec compliance review by a reviewer other than the implementer
- Code quality review by a reviewer other than the implementer
- External PR review
- Manual review by your human partner

**Don't use when:**
- Only the task's self-review checklist ran
- No independent external review cycle happened

A clean self-review checklist belongs in the execution log, not the review log. If an external review cycle did happen, a clean "no issues found" record still belongs in the review log.

## Output Location

`docs/superpowers/review-log/YYYY-MM-DD-<feature-name>.md`

Use the same `<feature-name>` as the execution log. One file per feature. Append entries as external review cycles complete.

## Default Lightweight Behavior

In the lightweight workflow, **review-log is not the default home for every task's review data**.

Use `review-log` only for:
- external review cycles
- deferred findings
- rejected findings with evidence
- cross-task findings that need tracking beyond the current task block

If the configured review strategy keeps task-level external review off and only self-checklist runs, no review-log entry is needed.

## Log Entry Format

```markdown
### Review Cycle N — [Timestamp]

**Cycle ID:** RC-N
**Reviewer type:** SPEC_COMPLIANCE | CODE_QUALITY | PR_REVIEW | MANUAL
**Reviewer:** subagent / external reviewer / human partner
**Scope:** Task N [task name] / Full implementation
**Re-check of:** [prior cycle, if any]

#### Findings

| # | Severity | Description | Resolution | Re-check status | Commit | Cross-task? |
|---|----------|-------------|------------|-----------------|--------|-------------|
| 1 | IMPORTANT | [What was found] | FIXED | VERIFIED_FIXED | abc1234 | — |
| 2 | IMPORTANT | [What was found] | DEFERRED | DEFERRED | — | Task 5 |
| 3 | MINOR | [What was found] | REJECTED | REJECTED | — | — |

#### Deferred / Rejected Notes
- Finding #2: reason, impact, prerequisite
- Finding #3: evidence for rejection

#### Related Debugging
- Finding #1 → [link to debugging-log entry if one exists]

---
```

## Key Principles

- **Every external finding gets a row** — even a clean external review should record "no issues found" if a review cycle occurred
- **Deferred items are first-class** — include reason, impact, and prerequisite
- **Rejected items need evidence** — don't silently ignore reviewer suggestions
- **Append only** — don't rewrite past review cycles
- **Cross-task findings stay visible** — if an issue spans tasks, track it here

## Red Flags

| Thought | Reality |
|---------|---------|
| "The self-checklist already reviewed it, so no review distinction matters" | Self-checklist and external review are different artifacts. |
| "Every task should create a review-log entry" | No. The lightweight default keeps routine review data inside the execution-log block unless an external review cycle occurred. |
| "I'll fix the deferred items later without writing them down" | Without a review-log entry, deferred findings vanish. |
