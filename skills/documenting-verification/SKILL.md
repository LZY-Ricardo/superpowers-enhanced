---
name: documenting-verification
description: Use after running any verification command — tests, build, lint, type-check. Records what was verified, results, and gaps so nothing is assumed to pass without evidence.
---

# Documenting Verification

Record verification results as structured evidence. Complements the verification-before-completion skill — that skill enforces running verification, this skill records the result.

**Core principle:** Verification without a record is unverifiable.

**Announce at start:** "I'm using the documenting-verification skill to record verification results."

## Auto-Init

If `docs/superpowers/` does not exist, create the full directory structure. See documenting-execution's Auto-Init section for the commands.

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

## Output Location

**Always append to the feature's execution log:** `docs/superpowers/execution-log/YYYY-MM-DD-<feature-name>.md`

If no execution log exists yet (e.g., standalone verification), create: `docs/superpowers/verification-log/YYYY-MM-DD-<feature-name>.md`

## Log Entry Format

```markdown
#### Verification — [Task N or Phase]

**Timestamp:** YYYY-MM-DD HH:MM

| Check | Command | Result | Notes |
|-------|---------|--------|-------|
| Tests | `pytest tests/` | 34/34 PASS | — |
| Build | `npm run build` | PASS | exit 0 |
| Lint | `eslint src/` | 2 warnings | unused vars in utils.ts |
| Type check | `tsc --noEmit` | SKIPPED | project has no typecheck step |

**Uncovered areas:** *(if any)*
- [What wasn't verified and why]

**Action items from failures:** *(if any)*
- [What needs fixing → may trigger documenting-debugging]

---
```

## Failure Handling

When verification fails:
1. Record the failure in this log
2. Invoke **documenting-debugging** after resolving the failure
3. Record the re-verification result as a new entry after fix

```
Verification (FAIL) → debugging-debugging → Fix → Verification (PASS)
```

## Key Principles

- **Record facts, not feelings** — "34/34 PASS" not "seems good"
- **Record skips too** — skipped verification is a known risk gap
- **Tie to task** — verification belongs to a specific task or phase
- **Failures become action items** — don't just record failure, state what needs fixing
- **One location** — prefer appending to execution log over creating a separate file

## Relationship to Other Skills

- **verification-before-completion** enforces running verification
- **documenting-verification** records the result
- **documenting-debugging** is triggered when verification fails and needs investigation
- **documenting-review** records issues found by code review (separate from this)

Run verification-before-completion first, then this skill to record.
