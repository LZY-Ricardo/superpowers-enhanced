---
name: requesting-code-review
description: Use when completing tasks, implementing major features, or before merging to verify work meets requirements
---

# Requesting Code Review

Dispatch a code reviewer subagent to catch issues before they cascade. The reviewer gets precisely crafted context for evaluation — never your session's history. This keeps the reviewer focused on the work product, not your thought process, and preserves your own context for continued work.

**Core principle:** Review early, review often.

## When to Request Review

**Mandatory:**
- After each task in subagent-driven development
- After completing major feature
- Before merge to main

**Optional but valuable:**
- When stuck (fresh perspective)
- Before refactoring (baseline check)
- After fixing complex bug

## How to Request

## Reviewer Continuity

On the first review cycle, record enough reviewer identity to attempt a targeted re-check later (for example: `spec-reviewer subagent #1`, `code-quality reviewer #2`). When a fix is ready:
- Main session runs verification first
- Prefer returning to the original reviewer with the original findings, fix summary, and verification evidence
- If the original reviewer is unavailable, or still cannot validate the fix after a concise recap, dispatch a fresh reviewer
- Fresh reviewers must check both: whether prior findings are truly fixed, and whether the fix introduced regressions or new issues

Reviewer continuity is preferred, not magical. If the runtime cannot continue the same reviewer instance, the fallback reviewer must be told that it is performing a re-check of prior findings, not a blind first-pass review.

**1. Get git SHAs:**
```bash
BASE_SHA=$(git rev-parse HEAD~1)  # or origin/main
HEAD_SHA=$(git rev-parse HEAD)
```

**2. Dispatch code reviewer subagent:**

Use Task tool with `general-purpose` type, fill template at `code-reviewer.md`

**Placeholders:**
- `{DESCRIPTION}` - Brief summary of what you built
- `{PLAN_OR_REQUIREMENTS}` - What it should do
- `{BASE_SHA}` - Starting commit
- `{HEAD_SHA}` - Ending commit

**3. Act on feedback:**
- Fix Critical issues immediately
- Fix Important issues before proceeding
- Note Minor issues for later
- Push back if reviewer is wrong (with reasoning)
- After fixes, run verification before re-review
- Prefer re-check by the original reviewer; if unavailable, use a fresh reviewer with the prior findings and verification evidence

## Example

```
[Just completed Task 2: Add verification function]

You: Let me request code review before proceeding.

BASE_SHA=$(git log --oneline | grep "Task 1" | head -1 | awk '{print $1}')
HEAD_SHA=$(git rev-parse HEAD)

[Dispatch code reviewer subagent]
  DESCRIPTION: Added verifyIndex() and repairIndex() with 4 issue types
  PLAN_OR_REQUIREMENTS: Task 2 from docs/superpowers/plans/deployment-plan.md
  BASE_SHA: a7981ec
  HEAD_SHA: 3df7661

[Subagent returns]:
  Strengths: Clean architecture, real tests
  Issues:
    Important: Missing progress indicators
    Minor: Magic number (100) for reporting interval
  Assessment: Not ready to proceed until issues are addressed

You: [Fix progress indicators]
[Run verification]
[Ask the same reviewer to re-check the prior findings; if unavailable, dispatch a fresh reviewer with the old findings + verification evidence]
[Continue to Task 3 only after re-review closes the open findings]
```

## Integration with Workflows

**Subagent-Driven Development:**
- Review after EACH task
- Catch issues before they compound
- Fix before moving to next task
- Verification happens before re-review
- Re-review prefers the original reviewer and falls back to a fresh reviewer only when needed

**Executing Plans:**
- Review after each task or at natural checkpoints
- Get feedback, apply, continue

**Ad-Hoc Development:**
- Review before merge
- Review when stuck

## Red Flags

**Never:**
- Skip review because "it's simple"
- Ignore Critical issues
- Proceed with unfixed Important issues
- Argue with valid technical feedback

**If reviewer wrong:**
- Push back with technical reasoning
- Show code/tests that prove it works
- Request clarification

See template at: requesting-code-review/code-reviewer.md
