# Decomposition Status Tracking Enhancement Design

## Context

The decomposition skill already breaks large requirements into sub-projects with scope, dependencies, and order, but those sub-projects are still too easy to treat as planning notes rather than durable project maps. As the conversation continues, there is a risk that active sub-project choice, deferred work, and next-step sequencing drift back into session memory instead of remaining visible in the decomposition artifact itself.

The purpose of this sub-project is to make decomposition documents durable enough to serve as the top-level map of a large initiative. The enhancement should solve the specific problem of sub-project tracking without prematurely introducing a full project-wide state system or an additional status-history document.

## Goal

Enhance decomposition documents so they can continuously track the state of sub-projects over time, reducing dependence on session memory and making it obvious which sub-project is active, which are complete or deferred, and what should happen next.

## Non-Goals

This sub-project does **not**:
- introduce a separate `status.md`
- create a status-change event history log
- automate sub-project status updates from other documenting skills
- change the per-sub-project spec/plan/execution/review/completion lifecycle
- redesign the broader project recovery system beyond decomposition itself

## Chosen Approach

Upgrade decomposition documents directly rather than creating a parallel tracking file.

The enhancement uses:
1. a **Sub-project Overview** table near the top of the decomposition doc
2. richer per-sub-project detail blocks that include:
   - `Status`
   - `Priority`
   - `Next Step`
3. manual/main-session maintenance of those fields whenever priorities or completion states change

This keeps decomposition as the single top-level map for large initiatives while avoiding a second source of truth in the first iteration.

## Status Model

Use a lightweight status set:
- `Pending`
- `In Progress`
- `Blocked`
- `Completed`
- `Deferred`
- `Skipped`

### Status semantics
- **Pending** — accepted sub-project, not started yet
- **In Progress** — currently active sub-project
- **Blocked** — cannot progress due to dependency, unresolved decision, or external constraint
- **Completed** — sub-project lifecycle done
- **Deferred** — intentionally postponed
- **Skipped** — intentionally removed from current scope

The design intentionally avoids finer-grained statuses like `In Review` or `Ready` in this first version because they add upkeep without solving the primary memory problem.

## Document Structure Changes

### 1. Sub-project Overview table
Add a compact overview table near the top of the decomposition document:

```md
## Sub-project Overview

| Sub-project | Status | Priority | Dependencies | Next Step |
|---|---|---|---|---|
| A 模板与真相源收敛 | In Progress | 1 | — | brainstorming / implementation |
| B 项目版本标识与升级机制 | Pending | 2 | A | wait for A completion |
| G 分解文档状态追踪增强 | Pending | 3 | B | wait for B completion |
```
```

This table is the first thing a future session should read when resuming a large initiative.

### 2. Detailed sub-project blocks
Each sub-project block should add these explicit fields:
- `Status`
- `Priority`
- `Dependencies`
- `Next Step`

Example shape:

```md
### A. 模板与真相源收敛
- **Status:** Completed
- **Priority:** 1
- **Goal:** ...
- **Scope:** ...
- **Dependencies:** None
- **Risks:** ...
- **Deliverable:** ...
- **Next Step:** Start sub-project B
```

The overview table gives scanability; the detailed block preserves deeper context.

## State Ownership

The decomposition document is maintained by the **main session**, not automatically by downstream documenting skills.

### Manual update triggers
Update the decomposition document when:
- a sub-project becomes active
- a sub-project completes
- a sub-project is deferred or skipped
- dependency order changes
- the recommended next sub-project changes

### Why manual ownership first
This keeps the first implementation simple and avoids creating hidden cross-document coupling before the broader recovery/indexing work is designed.

## Relationship to Other Workflow Artifacts

The decomposition document is the **macro-level map**.
Each active sub-project still gets its own normal lifecycle:
- spec
- plan
- execution log
- review log
- debugging log
- completion summary

The decomposition status does not replace those artifacts. It tells the reader **which** sub-project to look at next.

## Why Not a Separate Status File Yet

A separate status file would create another top-level source of truth before the project-recovery/indexing sub-project is designed. This sub-project is intentionally narrower: strengthen decomposition first, then later decide whether a dedicated status surface is still needed.

## Risks

1. **Duplicate state fields:** the overview table and detailed block can drift if only one is updated.
2. **Manual update discipline:** if the main session forgets to update the decomposition doc, the artifact still goes stale.
3. **Boundary overlap with later status.md work:** some of this may later be reflected in a dedicated recovery surface.

## Mitigations

- Keep the status field set intentionally small.
- Make the overview table the primary quick-scan surface.
- Treat decomposition updates as part of sub-project completion handoff and re-prioritization.
- Delay richer history/event tracking until later recovery/indexing work.

## Success Criteria

This sub-project is complete when:
1. decomposition docs can show the live state of each sub-project without relying on session memory
2. a future session can identify the current active sub-project from the decomposition document alone
3. completed, deferred, and skipped sub-projects are explicitly visible
4. next-step sequencing is visible both globally and per sub-project

## Verification Strategy

- Verify the decomposition template/output format includes both an overview table and detailed per-sub-project status fields.
- Verify status values are limited to the lightweight status set.
- Verify a resumed session can determine current and next sub-project directly from the decomposition document without reading the whole prior conversation.
