# Enhanced Workflow Default Lightweight Rework

**Date:** 2026-05-28
**Status:** Draft for review
**Scope:** Redefine the default behavior of the Enhanced Superpowers workflow so it is materially cheaper in token/time cost while preserving artifact traceability and phase ordering.

## Goal

Make the six approved workflow optimizations the new default behavior of the Enhanced Superpowers workflow that this repository ships to downstream users.

## Non-Goals

- Do not introduce new runtime dependencies.
- Do not rename existing skills or reorganize the public directory structure unless a small structural edit is clearly necessary for template clarity.
- Do not create a separate “light mode” or opt-in alternate workflow. The lightweight behavior becomes the default.
- Do not change the fundamental phase order of the enhanced workflow: decomposition → brainstorming → planning → execution → completion.
- Do not add fork-specific behavior or rules that only apply to this repository’s local maintenance habits.

## Problem Statement

The current Enhanced Superpowers workflow is reliable but too expensive by default.

The main cost drivers are:
- heavyweight process applied to small and medium changes
- planning documents that duplicate large amounts of implementation code
- per-task documenting loops that encourage repeated skill invocation and fragmented logs
- review behavior that defaults to expensive per-task loops without durable configuration
- completion summaries that retell spec, execution, and review history instead of acting as a status hub
- repeated subagent usage and repeated workflow instruction loading in the most common path

The result is a workflow that preserves traceability, but spends too much time and token budget generating redundant text and repeated procedural overhead.

## Desired Outcome

The new default workflow should:
- keep the existing phase model and artifact chain
- preserve enough explicit documentation to support recovery and review
- materially reduce repeated skill-loading pressure and repeated documentation churn
- make the lowest-friction path the recommended default
- keep heavier controls available when genuinely needed

## Approved Default Optimizations

### 1. Size-Based Workflow Tiering

The workflow should explicitly classify work into three sizes:

- **Small** — approximately ≤50 LOC, single file, no new interface; may skip the full enhanced workflow.
- **Medium** — bounded multi-step work; should use brainstorming, but may skip writing-plans when sequencing is straightforward.
- **Large** — cross-file, cross-subsystem, external API, or non-trivial sequencing; should run the full enhanced workflow.

This tiering must be described in the workflow entrypoints and user-facing templates as the default behavior, not just an informal exception.

### 2. Inline Execution as the Default

Execution should default to inline plan execution rather than subagent-driven execution.

Subagent-driven execution remains available, but should be positioned as a special-case tool for:
- truly independent tasks
- worthwhile context isolation
- genuinely parallelizable work
- high-value independent review perspectives

The wording in planning and execution skills must no longer imply that subagent-driven execution is the normal recommendation.

### 3. Plans Use Skeleton + Key Snippets

Implementation plans should stop defaulting to near-final source dumps.

Default plan behavior should be:
- **Failing test steps** remain concrete and complete.
- **Implementation steps** use signatures, key diffs, pseudo-code for non-trivial logic, and references back to exact spec sections.
- Plans remain executable and specific, but avoid duplicating whole final source files.

The plan quality check should explicitly confirm that the plan still reads coherently if code blocks are stripped out.

### 4. Per-Task Documentation Merges into One Execution Block

The execution loop should default to writing one structured block per task into the execution log.

That merged block should include:
- **Execution**
- **Verification**
- **Review (self-checklist)**
- **Review (applied config)**
- **Debugging**

Separate `review-log` and `debugging-log` entries should be reserved for items with standalone tracking value:
- deferred findings
- cross-task unresolved review items
- debugging investigations worth future reuse

Documenting skills should define field semantics and artifact boundaries, not encourage three or four separate per-task skill invocations as the normal path.

### 5. Review Strategy Becomes Configurable and Durable

The execution handoff from planning must ask once, per feature, for review strategy choices.

The three configurable axes are:
- **task-level review**: off / spec only / spec + code
- **feature-level review**: spec only / code only / spec + code
- **review executor**: main session / subagent / hybrid

These choices must be persisted to a feature-specific `review-config.md` file and then consumed by plan execution.

Every planned task must begin with:
- **Step 0: Load review config**

Every task block must record how the config was applied.

The review system must also retain hard rules:
- feature-level review must keep at least one review dimension enabled
- self-checklist always runs
- plan deviation forces one escalation review regardless of task-level settings
- the TDD failing-test step cannot be skipped

The self-checklist default set is:
1. spec mapping
2. interface consistency
3. tests verify behavior
4. smell scan
5. spec-stated boundaries covered
6. plan deviation check

### 6. Completion Summary Becomes a Dashboard

Completion summaries should become short status hubs rather than narrative recaps.

The default completion summary should contain:
- date / branch / status
- one-sentence scope statement
- spec coverage table
- artifact links table
- known issues / deferred section
- short summary / next-step lines

Completion summaries must explicitly avoid:
- retelling the spec
- replaying task-by-task execution
- restating fixed review findings
- retelling debugging narratives
- duplicating plan architecture prose

## Files In Scope

### Skill files to modify

Primary workflow and plan behavior:
- `skills/using-enhanced-workflow/SKILL.md`
- `skills/writing-plans/SKILL.md`
- `skills/documenting-completion/SKILL.md`

Supporting documentation semantics:
- `skills/documenting-execution/SKILL.md`
- `skills/documenting-verification/SKILL.md`
- `skills/documenting-review/SKILL.md`
- `skills/documenting-debugging/SKILL.md`

Supporting scope / execution alignment:
- `skills/brainstorming/SKILL.md`
- `skills/decomposing-requirements/SKILL.md`
- `skills/executing-plans/SKILL.md`
- `skills/subagent-driven-development/SKILL.md`

### Template files to modify

Enhanced workflow template sources under `skills/using-enhanced-workflow/`:
- `docs-superpowers-README-template.md`
- `docs-superpowers-workflow-template.md`
- `docs-superpowers-conventions-template.md`
- `docs-superpowers-status-template.md`

These templates must be updated so downstream projects initialized or upgraded from this repository inherit the new defaults.

## Responsibilities After Rework

### `using-enhanced-workflow`
Defines the lightweight default path:
- explicit small / medium / large tiering
- inline-first execution guidance
- merged per-task execution blocks
- review-config based task execution
- dashboard-style completion summaries

### `writing-plans`
Becomes the main bridge from design into lightweight execution:
- skeleton + key snippets default
- inline default handoff
- review-strategy prompt
- `review-config.md` generation contract
- task template with Step 0 and merged-block closeout behavior

### documenting-* skills
Shift from “repeat this skill per step” pressure to “define the authoritative meaning of each record section.”

### `documenting-completion`
Defines the new completion dashboard and its explicit non-goals.

### Supporting skills and templates
Keep scope selection, execution behavior, and recovery instructions aligned with the new defaults.

## Target Artifact Shapes

### Plan Task Shape

Each plan task should include:
- exact file list
- failing test step with complete runnable example
- implementation steps using signatures, key diffs, pseudo-code, and spec references
- Step 0 to load `review-config.md`
- explicit closeout step describing the merged execution-log block

### Review Config Shape

`docs/superpowers/plans/<feature-name>.review-config.md` should contain:
- execution mode
- task-level review setting
- feature-level review setting
- review executor
- always-on hard rules
- task-time usage instructions

### Execution Log Task Block Shape

Each task should write a single block with:
- execution
- verification
- review (self-checklist)
- review (applied config)
- debugging

### Completion Summary Shape

Each completion summary should fit the dashboard pattern and remain concise enough to be treated as an entry page rather than a narrative document.

## Implementation Strategy

The implementation should proceed in this order to reduce rework:

1. Rewrite the workflow entrypoint and core plan/completion defaults:
   - `using-enhanced-workflow`
   - `writing-plans`
   - `documenting-completion`
2. Align documenting semantics:
   - documenting execution / verification / review / debugging skills
3. Align scope and execution support skills:
   - brainstorming
   - decomposition
   - executing-plans
   - subagent-driven-development
4. Update shipped templates:
   - README
   - workflow
   - conventions
   - status
5. Run end-to-end verification against representative workflow artifacts

## Verification Strategy

Success must be validated at three levels.

### 1. Static Consistency Verification
Confirm that:
- all six optimizations appear in authoritative skill/template text
- workflow entrypoint, plan behavior, documenting behavior, and completion behavior agree
- there is no obvious contradiction between skills and templates

### 2. Artifact-Level Verification
Verify that representative outputs now look correct:
- plans use skeleton + key snippets and include Step 0 + merged closeout behavior
- review-config files are well-formed and usable
- execution logs use merged task blocks
- completion summaries use dashboard format

### 3. Experience-Level Verification
Confirm that the new default user path is materially lighter:
- medium-scope work no longer naturally drifts into the heaviest process
- inline execution is the ordinary path
- repeated per-task documenting behavior is no longer the natural default
- completion no longer produces recap-heavy summaries

## Risks and Mitigations

### Risk: Skill and template drift
If skill text changes but templates do not, downstream users will see conflicting guidance.

**Mitigation:** treat the template updates as required, not optional, and verify consistency after both sides change.

### Risk: Review discipline becomes too weak
If task-level review is made configurable without hard rules, the workflow could silently lose useful controls.

**Mitigation:** enforce self-checklist, plan-deviation escalation, and mandatory feature-level review presence.

### Risk: Plans become too vague
Reducing code content in plans could accidentally drop the specificity that made them executable.

**Mitigation:** keep failing tests concrete; require signatures, key diffs, exact file paths, commands, and spec references.

### Risk: Existing wording elsewhere still nudges users into old defaults
Even if the main skills change, old phrasing in support skills can keep the old behavior alive.

**Mitigation:** include all scope/execution support skills in the same rework pass.

## Acceptance Criteria

This rework is complete when:
1. the shipped enhanced workflow defaults to the six optimized behaviors
2. the workflow skills and shipped templates consistently describe those defaults
3. representative artifacts demonstrate the new shapes
4. no separate “optimization mode” is required to get the lightweight behavior
5. the artifact chain remains intact enough for recovery, review, and completion
