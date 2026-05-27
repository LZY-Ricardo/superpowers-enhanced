# Workflow Version Automation Design

## Context

Subproject B introduced project-side workflow metadata with both `pluginVersion` and `workflowTemplateVersion`, but the repository still lacks an explicit automation source for the template-version side of that model. Today, plugin version bumping is managed through `.version-bump.json` and `scripts/bump-version.sh`, while workflow template versioning remains implicit. That means the structure now supports version distinction, but the repository automation layer still only truly understands plugin version.

The purpose of this sub-project is to add a minimal, repository-level automation path for workflow template versioning without yet splitting the release cadence from plugin versioning.

## Goal

Add workflow template versioning to the repository's version automation system so that:
- workflow template version has a clear repo-level source of truth
- `bump-version.sh` and `.version-bump.json` are aware of it
- plugin version and workflow template version can continue to move together for now
- future decoupling remains easy because the template version already has its own automation hook

## Non-Goals

This sub-project does **not**:
- fully decouple template version from plugin version yet
- introduce project-side upgrade automation
- add template drift hashes/signatures
- scan every project artifact for template-version references
- redesign the release process beyond the minimal addition needed for template-version automation

## Chosen Approach

Introduce a new repository-root file:

```text
workflow-template-version.json
```

with a minimal shape like:

```json
{
  "workflowTemplateVersion": "5.1.0"
}
```

Then extend the existing version automation system so this file is treated as a first-class version source alongside the existing plugin/package manifests.

The initial rule is simple:
- `pluginVersion` and `workflowTemplateVersion` are still bumped together
- but they now have separate sources of record

This gives the repository an explicit template-version automation path without prematurely forcing independent release semantics.

## Why a Root-Level File

The workflow template version is repository-wide governance metadata, not private state for a single skill directory.

A root-level file is preferred because:
- it clearly communicates repo-level ownership
- it integrates cleanly with existing version tooling
- it avoids implying that one specific skill “owns” the version of the entire workflow template set
- it leaves room for future reuse by release scripts, docs, or checks

## Automation Changes

### `.version-bump.json`
Extend the managed file list so it includes the new template-version file.

That means the config should explicitly track:
- existing package/plugin manifest version fields
- `workflow-template-version.json` → `workflowTemplateVersion`

### `scripts/bump-version.sh`
The existing script already knows how to:
- read declared files/fields
- write declared files/fields
- check for drift
- audit repo references

This sub-project should reuse that structure rather than introducing a second bump script.

Expected behavior after the change:

#### `--check`
- shows plugin-related version fields
- shows `workflowTemplateVersion`
- detects drift if one side no longer matches the others

#### `--audit`
- includes the template-version source file in the declared set
- can still report undeclared files containing the current version string

#### `bump-version.sh <new-version>`
- updates the existing plugin/package version fields
- updates `workflow-template-version.json`
- re-runs the audit afterward as today

## Relationship to Project Metadata

This sub-project remains repository-scoped.

It does **not** automatically update project `docs/superpowers/version.json` files. Those continue to be managed by project init/upgrade logic.

The connection is indirect:
- repo automation maintains the authoritative template version source
- init/upgrade logic may later read from that source when materializing project metadata

## Relationship to Future Decoupling

This design intentionally prepares for future separation without forcing it now.

Today:
- plugin version and workflow template version move together

Later, if needed:
- the bump flow can grow a mode for template-only version bumps
- `workflow-template-version.json` can diverge from package/plugin manifests
- project upgrade logic can compare against a truly distinct template version

Because the root file and automation plumbing already exist, that future change becomes evolutionary instead of structural.

## Risks

1. **Overengineering risk:** if the file is added but never used beyond synchronized bumping, it may look like unnecessary complexity.
2. **Semantic confusion:** maintainers may assume the root file means versions are already decoupled when they are not.
3. **Audit noise:** because template version still matches plugin version, audit output may not yet feel meaningfully different.

## Mitigations

- keep the file minimal
- document clearly that synchronization is intentional in this phase
- treat the root file as enabling future decoupling, not as proof that decoupling already exists

## Success Criteria

This sub-project is complete when:
1. `workflow-template-version.json` exists as the repo-level source of truth for workflow template version
2. `.version-bump.json` declares it
3. `bump-version.sh --check` reports it alongside the other managed versions
4. `bump-version.sh <new-version>` updates it together with the existing plugin/package versions
5. the design makes later version decoupling easier without forcing it today

## Verification Strategy

- Verify `workflow-template-version.json` exists and is managed by `.version-bump.json`.
- Verify `bump-version.sh --check` includes `workflowTemplateVersion` in its output.
- Verify a test bump updates the root template-version file together with the existing version-managed files.
- Verify audit/check behavior remains understandable and does not regress the current version-management workflow.
