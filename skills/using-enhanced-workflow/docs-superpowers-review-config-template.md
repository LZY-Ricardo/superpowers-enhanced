# {{Feature Name}} — Review Config

**Plan:** `docs/superpowers/plans/{{YYYY-MM-DD-feature-name}}.md`
**Spec:** `docs/superpowers/specs/{{YYYY-MM-DD-feature-name}}-design.md`
**Date:** {{YYYY-MM-DD}}

## Execution mode

- Inline execution / Subagent-driven — pick one and state the rationale
- **Recommended default: Inline**. Use Subagent-driven only when tasks are truly independent and isolation value outweighs context-rebuild cost.

## Task-level review

- Off / Spec only / Spec + code — pick one
- **Recommended default: Off**. Predictable changes with test coverage → Off; high risk or junior-led → Spec + code.

## Feature-level review

- Spec only / Code only / Spec + code — pick one (must keep at least one dimension)
- **Recommended default: Spec + code**

## Review executor

- Main session / Subagent / Hybrid — pick one
- **Recommended default: Hybrid** (main session self-checks at task level, subagent at feature-level closeout)

## Hard rules (always-on defaults; project-specific add-ons may be appended)

1. **Self-checklist is an explicit Step 5**: any `❌` → immediate stop-and-report (write a debugging-log entry for substantive issues, inline note for minor ones); do not advance to Step 6 until the `❌` is resolved.
2. **Plan deviation is binary**: any code change inconsistent with the plan's task description is a deviation → triggers one escalation review regardless of task-level setting. **The implementer is not permitted to wave it through with "equivalent", "lint requires it", or "behaviorally identical" rationales.**
3. **Feature-level review** must keep at least one of spec or code dimensions enabled; not all-off.
4. **TDD failing-test step cannot be skipped**: even when the spec downgrades it to "capture pre-change behavior", Step 1 is retained as a baseline snapshot.
5. **Re-review continuity rule** (distinguish stateful vs stateless reviewers):
   - **Stateful reviewers** (main session self-review / human partner) → after a fix, return to the same reviewer for follow-up to preserve context.
   - **Stateless reviewers** (subagent) → do not require an "original reviewer" concept. Dispatch a fresh subagent of the same type. The input MUST include: (a) the Round 1 finding list; (b) the fix diff; (c) the original task / spec / plan paths. The follow-up review task is defined as **two things: (i) confirm the finding does not recur, AND (ii) confirm the fix introduced no secondary regression.** Confirming only that the finding is gone is insufficient.
6. **Finding disposition matrix**: every finding must land in one of FIXED / DEFERRED (with reason + prerequisite) / REJECTED (with evidence). Silent dropping is forbidden.

### Project-specific add-ons (optional)

A project may append project-specific hard rules here, e.g., "no new dependencies", "do not modify schema", "do not touch marketplace.json". **Restrict to project-specific constraints**; general engineering principles belong in skills, not here.

## Documentation hooks

| Trigger | Skill | Output |
|---|---|---|
| Each task completed | documenting-execution | Append one block to execution-log |
| After verification | documenting-verification | verification-log (typically written at feature closeout) |
| After an external review | documenting-review | Append one cycle to review-log |
| Reusable bug investigation | documenting-debugging | Standalone debugging-log entry |
| Feature closeout | documenting-completion | completion summary |
