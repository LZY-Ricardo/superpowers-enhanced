# Superpowers Enhanced Workflow

This project uses the Enhanced Superpowers workflow.

- **Workflow phases and execution defaults:** see [workflow.md](workflow.md)
- **Naming conventions, file purposes, and rules:** see [conventions.md](conventions.md)

## Directory Overview

```
docs/superpowers/
├── decomposition/     ← Requirement breakdown (large features only)
├── specs/             ← Design specifications
├── plans/             ← Implementation plans + review-config files
├── execution-log/     ← One merged task block per completed task
├── debugging-log/     ← Reusable debugging investigations only
├── review-log/        ← External/deferred/cross-task review findings
├── completion/        ← Final dashboard-style completion summaries
└── status.md          ← Current recovery entrypoint for active work
```

## Quick Navigation

| I want to... | Read this |
|-------------|-----------|
| Understand the full workflow | [workflow.md](workflow.md) |
| Know what each file contains | [conventions.md](conventions.md) |
| Start recovery from current work | [status.md](status.md) |
| Find a feature's docs | Active Features table below |
| Check current progress | `execution-log/<feature-name>.md` |
| Check the active execution/review policy | `plans/<feature-name>.review-config.md` |
| Find deferred review issues | `review-log/<feature-name>.md` |
| Find past reusable debugging notes | `debugging-log/` files |
| See final feature dashboard | `completion/<feature-name>-summary.md` |

## Active Features

<!-- Update this table as features are started and completed -->

| Feature | Status | Spec | Plan | Review Config | Execution | Review | Completion |
|---------|--------|------|------|---------------|-----------|--------|------------|
| _(example)_ user-auth | In Progress | [spec](specs/2026-05-22-user-auth-design.md) | [plan](plans/2026-05-22-user-auth.md) | [config](plans/2026-05-22-user-auth.review-config.md) | [log](execution-log/2026-05-22-user-auth.md) | [review](review-log/2026-05-22-user-auth.md) | — |

Status: `Planning` | `In Progress` | `In Review` | `Complete` | `On Hold`
