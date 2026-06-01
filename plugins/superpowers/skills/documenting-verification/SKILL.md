---
name: documenting-verification
description: Use after running verification commands — tests, build, lint, type-check, or manual checks. Records what was verified, results, and gaps so nothing is assumed to pass without evidence.
---

# Documenting Verification

Record verification results as structured evidence. Complements the verification-before-completion skill — that skill enforces running verification, this skill records the result.

**Core principle:** Verification without a record is unverifiable.

**Announce at start:** "I'm using the documenting-verification skill to record verification results."

## When to Use

**After running verification commands:**
- Test suite execution
- Build / compilation
- Linter / formatter
- Type checking
- Manual smoke tests

**Don't use when:**
- No verification was actually run
- Only exploring, not asserting correctness

## Default Output Location

**Append verification into the current task's merged execution-log block:**
`docs/superpowers/execution-log/YYYY-MM-DD-<feature-name>.md`

This workflow's default is **not** a separate verification subsection appended later. Verification evidence belongs inside the task block produced at task closeout.

Standalone verification-only files are exceptional and should be used only when there is no plan-driven execution log yet.

## Verification Content Standard

For the `**Verification**` section of the merged task block, record:

```markdown
**Verification**
- `exact command` → PASS/FAIL with the actual observed outcome
- `exact command` → PASS/FAIL with the actual observed outcome
- Uncovered areas or deliberate skips, if any
```

Examples:

```markdown
**Verification**
- `bash tests/claude-code/test-init-enhanced-workflow.sh` → PASS
- `bash tests/claude-code/test-status-surface.sh` → FAIL before status-template alignment; expected for current task slice
- Uncovered: full integration suite deferred to end-to-end verification task
```

## Failure Handling

When verification fails:
1. Record the failure in the task's `Verification` section
2. Fix it or investigate it
3. If the investigation has standalone reuse value, create a debugging-log entry
4. Re-run verification and record the new result in the same task-closeout cycle or in the follow-up task block, depending on when the fix lands

## Relationship to Other Skills

- **verification-before-completion** enforces that verification really happens
- **documenting-verification** defines how to record the result
- **documenting-debugging** is used when a failure turns into a meaningful investigation
- **documenting-review** is for external review findings, not self-check verification notes

## Key Principles

- **Record facts, not feelings** — "34/34 PASS" or "FAIL: missing field" rather than "looks good"
- **Record skips too** — skipped checks are known risk gaps
- **Verification belongs to a task** — by default it should be attached to the task block that produced it
- **Failures create evidence and action** — don't just note failure; make the next step obvious
- **Prefer one location** — merged execution-log block first, separate files only when truly necessary
