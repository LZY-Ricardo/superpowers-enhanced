# Workflow Engineering Upgrade — Decomposition

## Requirement Restatement

Systematically upgrade Superpowers Enhanced from a usable workflow extension into a more engineered system with stronger template consistency, project upgrade safety, resume/recovery ergonomics, maintenance-skill boundaries, and dynamic behavior testing.

The goal is not a single fix. It is to close the already-identified structural gaps in versioning, templates, migration, state recovery, and test coverage.

## Dependency Graph

```text
A 模板与真相源收敛
└──→ B 项目版本标识与升级机制
      ├──→ G 分解文档状态追踪增强
      │     └──→ C 项目恢复与状态索引
      ├──→ E 维护型 skill 体系化
      └──→ F 版本自动化

A + B + G + C ──→ D 测试体系升级
```

Critical path:

```text
A → B → G → C → D
```

## Sub-project Overview

| Sub-project | Status | Priority | Dependencies | Next Step |
|---|---|---|---|---|
| A 模板与真相源收敛 | Completed | 1 | — | Start B |
| B 项目版本标识与升级机制 | Completed | 2 | A | Start G |
| G 分解文档状态追踪增强 | In Progress | 3 | B | Brainstorming / implementation |
| C 项目恢复与状态索引 | Pending | 4 | B, G | Wait for G completion |
| D 测试体系升级 | Pending | 5 | A, B, G, C | Wait for C completion |
| E 维护型 skill 体系化 | Pending | 6 | A, B | Revisit after C/D |
| F 版本自动化 | Pending | 7 | A, B | Revisit after C/D |

## Sub-Projects

### A. 模板与真相源收敛
- **Status:** Completed
- **Priority:** 1
- **Goal:** Unify workflow guidance, project CLAUDE template, and project docs templates behind a single source of truth.
- **Scope:** Extract project CLAUDE template; make init and upgrade consume the same template set; reduce duplicated workflow definitions.
- **Excluded:** Version metadata, status panel, version automation, broad test expansion.
- **Dependencies:** None.
- **Risks:** Template path breakage, temporary drift during refactor, incomplete reference cleanup.
- **Deliverable:** A unified template source model where future workflow rule changes are made once and propagated consistently.
- **Next Step:** Use the new template foundation to add explicit project metadata in sub-project B.

### B. 项目版本标识与升级机制
- **Status:** Completed
- **Priority:** 2
- **Goal:** Record project-side workflow/template version metadata and use it to drive deterministic upgrades.
- **Scope:** Define metadata format; distinguish plugin version vs template version; write metadata during init; compare metadata during upgrade.
- **Excluded:** Version bump automation, global recovery index design.
- **Dependencies:** A.
- **Risks:** Backward compatibility for old projects with no metadata, overcomplicated version model.
- **Deliverable:** A project can clearly answer which workflow template version it is using and whether it needs upgrade.
- **Next Step:** Strengthen the decomposition artifact itself so large-initiative state no longer depends on session memory.

### G. 分解文档状态追踪增强
- **Status:** In Progress
- **Priority:** 3
- **Goal:** Make decomposition docs durable project maps rather than one-time planning notes.
- **Scope:** Add explicit per-sub-project status, priority, dependency, and next-step tracking to decomposition artifacts.
- **Excluded:** Full project-wide status panel, version automation.
- **Dependencies:** B.
- **Risks:** Overlap with later status.md, too much ceremony in decomposition docs, unclear responsibility for updating statuses.
- **Deliverable:** Decomposition docs become long-lived maps of large initiatives, not memory-dependent outlines.
- **Next Step:** Implement overview table and status fields in the decomposition skill and keep this active decomposition document updated as the first concrete example.

### C. 项目恢复与状态索引
- **Status:** Pending
- **Priority:** 4
- **Goal:** Improve resume efficiency when execution/review/debugging history grows.
- **Scope:** Add a lightweight current-state surface such as `status.md` or equivalent README enhancement; summarize active feature, phase, blockers, and open review threads.
- **Excluded:** Overwriting history, version automation.
- **Dependencies:** B, G.
- **Risks:** Creating a second source of truth if summary files drift from logs.
- **Deliverable:** A clear resume entrypoint that reduces the need to scan all historical logs before continuing work.
- **Next Step:** Wait until decomposition status tracking is stable so the later state surface can build on it rather than duplicate it.

### D. 测试体系升级
- **Status:** Pending
- **Priority:** 5
- **Goal:** Move from mostly static text/schema verification to dynamic behavior verification of enhanced workflow features.
- **Scope:** Add init, upgrade, resume, documenting-review, and enhanced e2e tests.
- **Excluded:** Rewriting every existing test.
- **Dependencies:** A, B, G, C.
- **Risks:** Slow and brittle integration tests, transcript variability, maintenance burden.
- **Deliverable:** Confidence that the enhanced workflow actually behaves as designed in end-to-end scenarios.
- **Next Step:** Wait until the macro-level decomposition map and recovery surfaces are stable enough to test behavior end-to-end.

### E. 维护型 skill 体系化
- **Status:** Pending
- **Priority:** 6
- **Goal:** Clearly separate repo-shipped workflow skills from local maintenance/operational skills.
- **Scope:** Clarify install/update/project-upgrade/local-maintenance boundaries in documentation and local skill guidance.
- **Excluded:** Core workflow feature changes.
- **Dependencies:** A, B.
- **Risks:** Boundary remains vague unless documented in multiple user-facing places.
- **Deliverable:** A cleaner distinction between shared workflow capabilities and personal operational tooling.
- **Next Step:** Revisit after the recovery and testing story is more stable, so the maintenance boundary can be documented against the actual final shape.

### F. 版本自动化
- **Status:** Pending
- **Priority:** 7
- **Goal:** Extend automation so workflow template version can be bumped and checked alongside plugin version where appropriate.
- **Scope:** Review `.version-bump.json` and `bump-version.sh`; define template-version bump/check policy.
- **Excluded:** Full workflow design changes.
- **Dependencies:** A, B.
- **Risks:** Version policy becomes harder to understand; documentation-only changes may become over-structured.
- **Deliverable:** A lightweight but explicit version automation path for workflow templates.
- **Next Step:** Revisit after the manual metadata and upgrade mechanism has been exercised enough to know what should actually be automated.

## Recommended Execution Order

1. A — 模板与真相源收敛
2. B — 项目版本标识与升级机制
3. G — 分解文档状态追踪增强
4. C — 项目恢复与状态索引
5. D — 测试体系升级
6. E — 维护型 skill 体系化
7. F — 版本自动化

## Human Decision

Approved sequence:
- Start with **A. 模板与真相源收敛**
- Proceed in the order above unless new information changes dependencies or priorities

## Handoff to Brainstorming

Current active sub-project:
- **Name:** 分解文档状态追踪增强
- **Status:** In Progress
- **Goal:** Make decomposition docs durable project maps rather than one-time planning notes.
- **Included:** Overview table, per-sub-project `Status` / `Priority` / `Next Step`, manual main-session maintenance model.
- **Excluded:** Separate `status.md`, history/event log, automatic status sync from other documenting skills.
- **Constraints:** Must strengthen decomposition itself without creating a second top-level source of truth.
