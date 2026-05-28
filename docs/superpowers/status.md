# Project Status

**Active sub-project:** None — engineering-upgrade initiative complete; current active work is the lightweight workflow default rework
**Active feature:** Enhanced Workflow Default Lightweight Rework
**Current phase:** execution
**Current review config:** [2026-05-28-enhanced-workflow-default-lightweight-rework.review-config.md](plans/2026-05-28-enhanced-workflow-default-lightweight-rework.review-config.md)
**Execution mode:** inline
**Review mode:** task-level self-checklist only; feature-level spec + code review
**Last updated:** 2026-05-28 12:30

## Current Artifact Links

- **Decomposition:** [2026-05-25-workflow-engineering-upgrade.md](decomposition/2026-05-25-workflow-engineering-upgrade.md)
- **Current spec:** [2026-05-28-enhanced-workflow-default-lightweight-rework-design.md](specs/2026-05-28-enhanced-workflow-default-lightweight-rework-design.md)
- **Current plan:** [2026-05-28-enhanced-workflow-default-lightweight-rework.md](plans/2026-05-28-enhanced-workflow-default-lightweight-rework.md)
- **Current review config:** [2026-05-28-enhanced-workflow-default-lightweight-rework.review-config.md](plans/2026-05-28-enhanced-workflow-default-lightweight-rework.review-config.md)
- **Execution log:** [2026-05-28-enhanced-workflow-default-lightweight-rework.md](execution-log/2026-05-28-enhanced-workflow-default-lightweight-rework.md)
- **Review log:** none yet
- **Debugging references:** none
- **Completion summary:** none yet

## Open Review Threads

- None yet. Feature-level external review is deferred until the end-to-end verification task unless plan deviation forces an earlier escalation.

## Open Blockers

- `test-status-surface.sh` previously failed because the repo's live `status.md` still used older recovery wording. This file has now been aligned and needs re-verification.
- `test-subagent-driven-development.sh` is being re-run after restoring explicit wording that spec-compliance review comes before code-quality review when a two-stage external review is configured.

## Next Recommended Action

1. Re-run `tests/claude-code/test-status-surface.sh` now that the live status surface matches the new template shape.
2. Collect the final result of the re-run `test-subagent-driven-development.sh` and close Task 3 if it passes.
3. Continue Task 4 by validating init/upgrade template tests against the new shipped defaults.
