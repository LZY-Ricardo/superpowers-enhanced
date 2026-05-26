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

## Sub-Projects

### A. 模板与真相源收敛
- **Goal:** Unify workflow guidance, project CLAUDE template, and project docs templates behind a single source of truth.
- **Scope:** Extract project CLAUDE template; make init and upgrade consume the same template set; reduce duplicated workflow definitions.
- **Excluded:** Version metadata, status panel, version automation, broad test expansion.
- **Dependencies:** None.
- **Risks:** Template path breakage, temporary drift during refactor, incomplete reference cleanup.
- **Deliverable:** A unified template source model where future workflow rule changes are made once and propagated consistently.
- **Status:** Pending.

### B. 项目版本标识与升级机制
- **Goal:** Record project-side workflow/template version metadata and use it to drive deterministic upgrades.
- **Scope:** Define metadata format; distinguish plugin version vs template version; write metadata during init; compare metadata during upgrade.
- **Excluded:** Version bump automation, global recovery index design.
- **Dependencies:** A.
- **Risks:** Backward compatibility for old projects with no metadata, overcomplicated version model.
- **Deliverable:** A project can clearly answer which workflow template version it is using and whether it needs upgrade.
- **Status:** Pending.

### G. 分解文档状态追踪增强
- **Goal:** Make decomposition docs durable project maps rather than one-time planning notes.
- **Scope:** Add explicit per-sub-project status, priority, dependency, and next-step tracking to decomposition artifacts.
- **Excluded:** Full project-wide status panel, version automation.
- **Dependencies:** B.
- **Risks:** Overlap with later status.md, too much ceremony in decomposition docs, unclear responsibility for updating statuses.
- **Deliverable:** Decomposition docs become long-lived maps of large initiatives, not memory-dependent outlines.
- **Status:** Pending.

### C. 项目恢复与状态索引
- **Goal:** Improve resume efficiency when execution/review/debugging history grows.
- **Scope:** Add a lightweight current-state surface such as `status.md` or equivalent README enhancement; summarize active feature, phase, blockers, and open review threads.
- **Excluded:** Overwriting history, version automation.
- **Dependencies:** B, G.
- **Risks:** Creating a second source of truth if summary files drift from logs.
- **Deliverable:** A clear resume entrypoint that reduces the need to scan all historical logs before continuing work.
- **Status:** Pending.

### D. 测试体系升级
- **Goal:** Move from mostly static text/schema verification to dynamic behavior verification of enhanced workflow features.
- **Scope:** Add init, upgrade, resume, documenting-review, and enhanced e2e tests.
- **Excluded:** Rewriting every existing test.
- **Dependencies:** A, B, G, C.
- **Risks:** Slow and brittle integration tests, transcript variability, maintenance burden.
- **Deliverable:** Confidence that the enhanced workflow actually behaves as designed in end-to-end scenarios.
- **Status:** Pending.

### E. 维护型 skill 体系化
- **Goal:** Clearly separate repo-shipped workflow skills from local maintenance/operational skills.
- **Scope:** Clarify install/update/project-upgrade/local-maintenance boundaries in documentation and local skill guidance.
- **Excluded:** Core workflow feature changes.
- **Dependencies:** A, B.
- **Risks:** Boundary remains vague unless documented in multiple user-facing places.
- **Deliverable:** A cleaner distinction between shared workflow capabilities and personal operational tooling.
- **Status:** Pending.

### F. 版本自动化
- **Goal:** Extend automation so workflow template version can be bumped and checked alongside plugin version where appropriate.
- **Scope:** Review `.version-bump.json` and `bump-version.sh`; define template-version bump/check policy.
- **Excluded:** Full workflow design changes.
- **Dependencies:** A, B.
- **Risks:** Version policy becomes harder to understand; documentation-only changes may become over-structured.
- **Deliverable:** A lightweight but explicit version automation path for workflow templates.
- **Status:** Pending.

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

First sub-project to design next:
- **Name:** 模板与真相源收敛
- **Goal:** Unify workflow guidance, project CLAUDE template, and project docs templates behind a single source of truth.
- **Included:** Template-source design, project CLAUDE template extraction, init/upgrade template consumption, reference cleanup.
- **Excluded:** Version metadata, status panel, version automation, large test rollout.
- **Constraints:** Must preserve current enhanced workflow behavior; must reduce drift risk rather than add another duplicate layer.
