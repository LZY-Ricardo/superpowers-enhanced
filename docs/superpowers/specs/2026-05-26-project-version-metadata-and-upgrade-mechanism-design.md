# Project Version Metadata and Upgrade Mechanism Design

## Context

Subproject A converged the guidance layer onto canonical template files, but projects still cannot answer a basic operational question: which version of the Enhanced Superpowers workflow are they using? Today, project upgrades depend on content comparison and human judgment rather than explicit metadata. That makes old-project upgrades fragile, because the system must infer whether a project is stale instead of reading a declared template/version state.

The purpose of this sub-project is to introduce a minimal but durable project-side metadata model so initialization and upgrade operations can make deterministic decisions. The design must support old projects that predate metadata and must remain simple enough to implement before template-version automation and richer drift detection are introduced later.

## Goal

Add project-side workflow metadata so that:
- new projects initialized with `init-enhanced-workflow` record which workflow/template version they received
- existing projects can be recognized as legacy Enhanced Superpowers projects and upgraded into the metadata system
- `upgrading-enhanced-workflow-project` can decide whether a guidance-layer upgrade is needed based on explicit metadata rather than text guesswork

## Non-Goals

This sub-project does **not**:
- split plugin version and template version semantics yet
- add hash/signature-based template drift detection
- automate version bumping for workflow templates
- add `status.md` or a broader runtime status surface
- expand the full test matrix beyond what is needed to validate the metadata flow

## Chosen Approach

Use a new project-side metadata file:

```text
docs/superpowers/version.json
```

This file becomes the single machine-readable source for the workflow/template version state inside a project.

The first implementation uses a deliberately simple model:
- `pluginVersion`
- `workflowTemplateVersion`
- `initializedAt`
- `lastUpgradedAt`

In the first release of this model, `pluginVersion` and `workflowTemplateVersion` will be written with the same value. Their semantics remain separate, so they can be decoupled later without changing the file structure.

## Metadata File Format

The initial file shape is:

```json
{
  "pluginVersion": "5.1.0",
  "workflowTemplateVersion": "5.1.0",
  "initializedAt": "2026-05-26T10:00:00Z",
  "lastUpgradedAt": "2026-05-26T10:00:00Z"
}
```

### Field meanings

- **pluginVersion** — the Enhanced Superpowers plugin version used when the project guidance layer was last initialized or upgraded
- **workflowTemplateVersion** — the version of the copied workflow guidance templates currently believed to be installed in the project
- **initializedAt** — timestamp for the first known initialization of the project into the enhanced workflow system
- **lastUpgradedAt** — timestamp for the most recent guidance-layer upgrade

## Why `version.json`

A dedicated JSON file is preferred over markdown/frontmatter in README or conventions files because:
- it is easier for upgrade logic to parse deterministically
- it keeps machine state separate from human-edited narrative docs
- it is a stable foundation for later automation and version checks

## Initialization Behavior

`init-enhanced-workflow` should write `docs/superpowers/version.json` only after the guidance files have been successfully created.

The write order matters:
1. create directory structure
2. create/copy project guidance files
3. write/append project `CLAUDE.md`
4. write `version.json`
5. commit

This prevents a false-success state where metadata claims the project was initialized even though template copy failed.

On first initialization:
- `pluginVersion = current plugin version`
- `workflowTemplateVersion = current plugin version`
- `initializedAt = now`
- `lastUpgradedAt = now`

## Upgrade Behavior

`upgrading-enhanced-workflow-project` should use this decision model:

### Case 1: project has no `docs/superpowers/`
Stop. This is not an upgrade case; use `init-enhanced-workflow`.

### Case 2: project has `docs/superpowers/` but no `version.json`
Treat as a potential legacy enhanced project. Run a conservative recognition check.

### Case 3: project has `version.json`
Read the metadata and compare it to the currently installed plugin version.

- If versions differ, perform guidance-only upgrade and then update metadata.
- If versions match, default to no-op unless the user explicitly requests a forced re-check.

## Legacy Project Recognition

A project without `version.json` qualifies for automatic metadata backfill only if all of the following are true:
1. `docs/superpowers/` exists
2. project `CLAUDE.md` exists
3. `CLAUDE.md` contains a recognizable Enhanced Superpowers workflow block
   - either marker-bounded form
   - or legacy `## Enhanced Superpowers Workflow` form
4. at least one guidance file exists:
   - `docs/superpowers/README.md`
   - `docs/superpowers/workflow.md`
   - or `docs/superpowers/conventions.md`

If these conditions are not met, the upgrade process should stop and require explicit user confirmation instead of guessing.

## Legacy Metadata Backfill

When a legacy project is recognized, create `version.json` and continue the upgrade flow.

Recommended initial content:

```json
{
  "pluginVersion": "5.1.0",
  "workflowTemplateVersion": "5.1.0",
  "initializedAt": "legacy",
  "lastUpgradedAt": "2026-05-26T11:00:00Z"
}
```

This deliberately avoids fabricating a historical initialization timestamp.

## Update Rules

When a normal upgrade succeeds:
- update `pluginVersion`
- update `workflowTemplateVersion`
- update `lastUpgradedAt`
- preserve `initializedAt`

This preserves the difference between project origin time and later maintenance operations.

## Relationship to Future Evolution

Although `pluginVersion` and `workflowTemplateVersion` are initially equal, the model must not assume they are the same thing.

This means:
- the code path should read both fields explicitly
- the structure should tolerate future divergence
- later work can introduce template-only version increments without redesigning the metadata file

This sub-project therefore enables later work on:
- template version automation
- drift detection
- more granular project upgrade rules

## Risks

1. **Legacy recognition false positives:** an unrelated project could have a similar docs layout or heading structure. The conservative multi-condition gate reduces this risk.
2. **False sense of correctness:** matching versions should be treated as a default shortcut, not absolute proof that all guidance files are current.
3. **Version semantics confusion:** if the documentation does not explain the difference between plugin and template version fields, future maintainers may treat them as the same concept forever.

## Success Criteria

This sub-project is complete when:
1. new initialized projects always receive `docs/superpowers/version.json`
2. old Enhanced Superpowers projects can be upgraded into the metadata system without manual re-init
3. upgrade decisions are primarily driven by explicit metadata instead of text heuristics
4. the metadata structure remains simple now but supports later plugin/template version separation

## Verification Strategy

- Verify `init-enhanced-workflow` writes `version.json` after successful guidance creation.
- Verify a project missing `version.json` but matching the legacy recognition rules gets a `legacy` metadata record.
- Verify `upgrading-enhanced-workflow-project` can distinguish:
  - non-initialized project
  - legacy enhanced project
  - current versioned enhanced project
- Verify `initializedAt` is preserved across upgrades while `lastUpgradedAt` changes.
