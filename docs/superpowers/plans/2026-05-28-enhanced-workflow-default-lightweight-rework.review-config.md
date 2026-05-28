# Review Config for enhanced-workflow-default-lightweight-rework

**Configured at:** 2026-05-28
**Plan:** docs/superpowers/plans/2026-05-28-enhanced-workflow-default-lightweight-rework.md

## Choices
- Execution mode: Inline (`superpowers:executing-plans`)
- Task-level review: Off — use self-checklist only unless plan deviation triggers escalation
- Feature-level review: Spec + code
- Review executor: Hybrid — main session for task-time decisions, independent review only at feature level or on escalation

## Hard rules
- Self-checklist runs on every task
- Plan deviation triggers one escalation review regardless of task-level setting
- Feature-level review keeps at least one dimension enabled
- TDD failing-test step cannot be skipped

## How to use
- Each task starts by reading this file
- Each task block records how config was applied
- If a task deviates from plan, escalate once and record it
