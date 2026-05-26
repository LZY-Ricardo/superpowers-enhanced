# Project Recovery and Status Indexing Design

## Context

Subproject G strengthened decomposition documents so large initiatives now have a durable macro-level map. However, once a specific sub-project enters implementation, recovery still requires jumping across several detailed artifacts: spec, plan, execution log, review log, debugging log, and completion summary. The README is useful as an index, but it is still a general navigation layer rather than a focused, up-to-date recovery surface.

The purpose of this sub-project is to add a dedicated project recovery entrypoint that answers the practical question: "If a future Claude session or human opens this project cold, what should they read first, what is currently active, what is blocked, and what should happen next?"

## Goal

Introduce a dedicated `docs/superpowers/status.md` recovery surface that summarizes both project-level and current-feature-level state so recovery no longer depends on reading many logs in arbitrary order.

## Non-Goals

This sub-project does **not**:
- automate status updates from other documenting skills
- replace decomposition as the macro-level initiative map
- replace execution/review/debugging/completion logs as source-of-detail artifacts
- add historical event tracking or status transition history
- redesign README into a full live status page

## Chosen Approach

Add a new file:

```text
docs/superpowers/status.md
```

This file becomes the primary recovery entrypoint for an active project.

The first implementation is intentionally manual:
- the main session updates it when active feature/phase/blockers/next step change
- it references other artifacts rather than duplicating their full detail
- it complements README and decomposition rather than replacing them

## Role Separation

### Decomposition doc
- macro-level map of large initiatives
- shows which sub-projects exist and their order/state

### README
- directory/index page
- explains where different artifacts live

### `status.md`
- live recovery surface
- tells a future session what is currently active and what to read next

### execution/review/debugging/completion logs
- detailed evidence and history

The design goal is to eliminate “where do I start?” ambiguity without creating a second deep-history system.

## `status.md` Content Model

The first version should contain both project-level and active-feature-level state.

Recommended sections:

### 1. Project Status
- current active sub-project
- current active feature
- current phase
- last updated timestamp

### 2. Current Artifact Links
- current decomposition doc
- current spec
- current plan
- current execution log
- current review log
- current debugging references
- current completion summary (if one exists)

### 3. Open Review Threads
A concise list of unresolved review threads or open quality decisions, for example:
- which review cycle is still active
- which finding IDs or summaries remain open
- whether re-review is waiting on implementation or verification

This is only a summary surface; the review log remains the source of detail.

### 4. Open Blockers
- dependency blockers
- unresolved design choices
- test-system blockers
- infrastructure blockers

### 5. Next Recommended Action
A one-line or short-list recommendation for what the next session should do first.

## Manual Ownership Model

The `status.md` file is maintained by the **main session**.

Update it when:
- active sub-project changes
- active feature changes
- current phase changes
- a blocker appears or clears
- the primary next action changes
- the current review thread changes materially

This first version deliberately avoids automatic synchronization from execution/review/completion skills. The structure comes first; automation can come later.

## Why Not Put This in README

README already acts as the static index for the documentation system. Turning it into the live status surface would mix:
- long-lived structure/navigation
- short-lived operational state

That makes the file heavier and less predictable. A dedicated `status.md` keeps those concerns separate.

## Why Not Add History Yet

A status history section would overlap with:
- decomposition state changes
- execution logs
- review cycles
- completion summaries

This sub-project is intentionally focused on improving recovery, not adding another event log.

## Risks

1. **State drift:** if the main session forgets to update `status.md`, recovery quality drops.
2. **Summary duplication:** the file may repeat facts that also exist in logs.
3. **Scope creep:** it is easy to turn `status.md` into a second execution log if not kept concise.

## Mitigations

- Keep `status.md` short and summary-oriented.
- Use links to detailed artifacts rather than copying their contents.
- Treat `status.md` as a “where to look next” surface, not a historical record.
- Update it only on meaningful state transitions, not on every tiny code change.

## Success Criteria

This sub-project is complete when:
1. projects can have a clear `status.md` recovery entrypoint
2. a future session can identify the active feature, current phase, blockers, and next step without scanning all logs first
3. README remains an index page and decomposition remains the macro-level map
4. the design supports later automation but works correctly with manual main-session maintenance first

## Verification Strategy

- Verify the new `status.md` template/format clearly separates summary from history.
- Verify it includes links to the current artifact chain.
- Verify a future session could reasonably resume work by reading `status.md` first, then following the linked documents.
- Verify the decomposition document and README still retain their distinct responsibilities.
