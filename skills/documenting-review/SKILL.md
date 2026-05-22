---
name: documenting-review
description: Use after a code review cycle completes — whether findings were fixed, deferred, or rejected. Records issues found, actions taken, and deferred items so nothing is lost between review and resolution.
---

# Documenting Review

Record code review findings and their resolution. Prevents review feedback from vanishing after the subagent session ends and creates an auditable trail of quality decisions.

**Core principle:** Every review finding has a resolution. No finding is silently dropped.

**Announce at start:** "I'm using the documenting-review skill to record review findings."

## Auto-Init

If `docs/superpowers/` does not exist, create the full directory structure. See documenting-execution's Auto-Init section for the commands.

## When to Use

**After each code review cycle:**
- Spec compliance review (in subagent-driven-development)
- Code quality review (in subagent-driven-development)
- External PR review
- Manual review by your human partner

**Don't use when:**
- Only self-review (no external reviewer involved)
- No findings at all — still record a one-liner: "Clean review, no issues"

## Output Location

`docs/superpowers/review-log/YYYY-MM-DD-<feature-name>.md`

Use the same `<feature-name>` as the execution log. One file per feature. Append entries as review cycles complete.

## Review Flow in Subagent-Driven Development

Spec compliance review and code quality review are **sequential, not parallel:**

```
Implementer → Spec Review → (fix if needed) → Quality Review → (fix if needed) → Done
```

Record each as a separate review cycle in this log. Spec review must pass before quality review begins.

## Log Entry Format

```markdown
### Review Cycle N — [Timestamp]

**Reviewer type:** SPEC_COMPLIANCE | CODE_QUALITY | PR_REVIEW | MANUAL
**Reviewer:** subagent / external reviewer / human partner
**Scope:** Task N [task name] / Full implementation
**Preceded by:** *(if applicable)* Review Cycle N-1 (spec compliance passed)

#### Findings

| # | Severity | Description | Resolution | Commit | Cross-task? |
|---|----------|-------------|------------|--------|-------------|
| 1 | CRITICAL | [What was found] | FIXED | abc1234 | — |
| 2 | IMPORTANT | [What was found] | FIXED | abc1234 | — |
| 3 | IMPORTANT | [What was found] | DEFERRED | — | — |
| 4 | MINOR | [What was found] | REJECTED | — | — |
| 5 | IMPORTANT | [What was found] | FIXED | abc1234 | Also affects Task 3, 5 |

#### Deferred Items *(for each deferred finding)*

**Finding #3:** [Description]
- **Reason:** [Why it's deferred]
- **Impact:** [What happens if not fixed]
- **Prerequisite:** [What needs to happen before fixing]

#### Rejected Items *(for each rejected finding)*

**Finding #4:** [Description]
- **Reason:** [Why reviewer's suggestion was rejected]
- **Evidence:** [Technical justification]

#### Related Debugging *(if any findings required debugging)*
- Finding #2 → [link to debugging-log entry]

---
```

## Severity Definitions

| Severity | Meaning |
|----------|---------|
| CRITICAL | Breaks functionality or security — must fix before proceeding |
| IMPORTANT | Quality or correctness issue — should fix before merge |
| MINOR | Style, naming, small improvement — fix when convenient |

## Resolution Definitions

| Resolution | Meaning |
|------------|---------|
| FIXED | Issue addressed, verified |
| DEFERRED | Legitimate issue, postponed with documented reason |
| REJECTED | Reviewer's suggestion not applicable, with documented reason |

## Cross-Task Findings

If a review finding affects multiple tasks (e.g., a shared utility has a bug):
- Mark the finding with the tasks it affects in the "Cross-task?" column
- Fix it in the current task if possible
- If the fix needs to happen in another task, note it as DEFERRED with the target task as prerequisite

## Key Principles

- **Every finding gets a row** — even clean reviews get "no issues found"
- **Deferred items are first-class citizens** — they must include reason, impact, and prerequisite
- **Rejected items need evidence** — "I don't want to" is not a reason
- **Append only** — don't edit past review cycles
- **Bidirectional cross-reference** — link to debugging-log if a finding required debugging, and link back

## Red Flags

| Thought | Reality |
|---------|---------|
| "Review was clean, nothing to record" | "No issues" is valuable data — it means the area was verified |
| "I'll fix the deferred items later" | Without a record, "later" becomes "never" |
| "The reviewer was wrong, skip it" | Wrong = REJECTED with evidence. Silently dropping = dishonesty |
| "This is just process overhead" | Review findings that vanish create the same bugs again |
| "5 fix-review rounds, I'll stop recording" | Every round gets recorded. If rounds exceed 5, escalate to human partner. |
