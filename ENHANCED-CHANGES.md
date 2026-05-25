# Enhanced Changes to Original Skills

This file tracks all modifications to upstream (original) Superpowers skills.
After merging upstream updates, use this file to verify and re-apply changes.

## Status

Last synced with upstream: `2026-05-22`

## Modified Files

### skills/using-superpowers/SKILL.md

**Marker:** `ENHANCED: added-enhanced-workflow-ref`
**Location:** After "Skill Priority" section, before "Skill Types" section (~line 106)
**Added content:**
```markdown
## Enhanced Workflow

This fork includes enhanced skills that add documentation at every phase. Check for these skills:

- **`using-enhanced-workflow`** — Master flow reference with complete phase map
- **`init-enhanced-workflow`** — One-time project setup (run once per project)
- **`decomposing-requirements`** — Break large requirements before brainstorming
- **`documenting-*`** — Record execution, verification, debugging, review, and completion

If this project has `docs/superpowers/` directory, the enhanced workflow is active. Follow `using-enhanced-workflow` for the complete flow.
```
**Reason:** The original `using-superpowers` skill is the first skill loaded at session start. Adding a reference here ensures the AI discovers the enhanced workflow immediately, rather than relying on description-based discovery alone.

### skills/subagent-driven-development/SKILL.md

**Marker:** `ENHANCED: reviewer-continuity-loop`
**Location:** After the opening overview, before the main process sections (~line 8)
**Added content:**
```markdown
**Enhanced review loop:** When a reviewer finds issues, the implementer/fix subagent makes the changes, the main session runs verification, then re-review is requested. Prefer continuing with the original reviewer for that finding set; if that reviewer is unavailable or no longer has enough context even after a concise recap, fall back to a fresh reviewer. The re-review must explicitly check whether each prior finding is fixed, partially fixed, still broken, or replaced by a new issue.
```
**Reason:** The upstream skill required re-review but did not specify reviewer continuity, verification before re-review, or how to handle fallback reviewers and per-finding re-check outcomes.

### skills/requesting-code-review/SKILL.md

**Marker:** `ENHANCED: reviewer-continuity-rules`
**Location:** Before the "How to Request" steps (~line 24)
**Added content:**
```markdown
## Reviewer Continuity

On the first review cycle, record enough reviewer identity to attempt a targeted re-check later (for example: `spec-reviewer subagent #1`, `code-quality reviewer #2`). When a fix is ready:
- Main session runs verification first
- Prefer returning to the original reviewer with the original findings, fix summary, and verification evidence
- If the original reviewer is unavailable, or still cannot validate the fix after a concise recap, dispatch a fresh reviewer
- Fresh reviewers must check both: whether prior findings are truly fixed, and whether the fix introduced regressions or new issues

Reviewer continuity is preferred, not magical. If the runtime cannot continue the same reviewer instance, the fallback reviewer must be told that it is performing a re-check of prior findings, not a blind first-pass review.
```
**Reason:** The upstream skill described how to request code review, but not how to organize follow-up re-review so the original reviewer is preferred and fallback reviewers get the right context.
