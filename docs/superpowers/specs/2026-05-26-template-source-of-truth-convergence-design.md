# Template Source-of-Truth Convergence Design

## Context

Superpowers Enhanced currently defines project guidance in too many places at once. The runtime workflow is described in skills, project-facing guidance is copied from template files, and project-level `CLAUDE.md` content is still embedded directly inside `init-enhanced-workflow/SKILL.md`. This creates drift risk: skill behavior can evolve, project templates can lag, and project upgrade logic can compare against an outdated template source.

The purpose of this sub-project is to establish a single authoritative template source for all project guidance files without redesigning the entire directory layout yet. This is the foundation for later work on project-side version metadata, version-aware upgrades, stronger recovery surfaces, and deeper test coverage.

## Goal

Make project guidance files come from one canonical template set so that:
- `init-enhanced-workflow` initializes projects by copying/inserting templates rather than embedding rule text
- `upgrading-enhanced-workflow-project` can later upgrade those same files from the same template source
- future workflow changes only need to update a small number of canonical template files instead of multiple repeated copies of the same rules

## Non-Goals

This sub-project does **not**:
- add project-side version metadata
- add `status.md` or any project state surface
- automate template version bumping
- expand the full end-to-end test matrix
- redesign the repository into a separate `templates/` directory yet

## Chosen Approach

Use the existing `skills/using-enhanced-workflow/` directory as the near-term template home, and complete the template set by adding a dedicated project `CLAUDE.md` template file there.

This is a deliberate minimal-change step:
- we keep the existing README/workflow/conventions template locations
- we remove the last major embedded project guidance block from `init-enhanced-workflow`
- we let `init` and project-upgrade consume the same template set
- we postpone a larger directory reorganization until the system is already converged

## Canonical Template Set

The canonical project-guidance templates will be:

- `skills/using-enhanced-workflow/docs-project-claude-template.md` **(new)**
- `skills/using-enhanced-workflow/docs-superpowers-README-template.md`
- `skills/using-enhanced-workflow/docs-superpowers-workflow-template.md`
- `skills/using-enhanced-workflow/docs-superpowers-conventions-template.md`

These four files become the only source for content that is copied into project repositories.

## File Role Separation

### Runtime Reference Files
These are read by Claude at runtime to understand workflow behavior:
- `skills/using-enhanced-workflow/SKILL.md`
- `skills/init-enhanced-workflow/SKILL.md`
- other enhanced workflow skills

Their job is to explain how the system works and when to invoke steps.

### Project Template Files
These are copied or inserted into project repositories:
- project `CLAUDE.md` template
- project `docs/superpowers/README.md` template
- project `docs/superpowers/workflow.md` template
- project `docs/superpowers/conventions.md` template

Their job is to establish the project guidance layer used by future sessions and human readers.

### Repository Explanation Files
These explain the system to maintainers and users, but are **not** copied into projects:
- `README.md`
- `ENHANCED.md`
- repository `CLAUDE.md`
- `MAINTENANCE.md`

These may describe the workflow conceptually, but they are not part of the canonical project template source.

## `init-enhanced-workflow` Changes

`init-enhanced-workflow` should stop embedding the project-level `CLAUDE.md` block inline.

Instead it should:
1. create `docs/superpowers/` directory structure
2. copy the three docs templates
3. read the project `CLAUDE.md` template file
4. insert or append that template into the target project's `CLAUDE.md`
5. commit the initialization

This change makes `init` a template consumer rather than a second place where rules are maintained manually.

## Project `CLAUDE.md` Upgrade Model

The inserted project workflow block must be bounded with explicit markers, for example:

```md
<!-- ENHANCED-SUPERPOWERS:START -->
...
<!-- ENHANCED-SUPERPOWERS:END -->
```

### Initialization behavior
- If the project has no `CLAUDE.md`, create it and write the block.
- If the project already has `CLAUDE.md`, append the block below the existing content.
- Do not overwrite unrelated project-specific guidance.

### Future upgrade behavior
Project-upgrade logic should later:
1. locate the marker block
2. replace only the content inside the block
3. preserve everything outside the block unchanged

### Legacy compatibility
Older projects may not have marker blocks. The first upgrade path should:
- try to recognize the old `## Enhanced Superpowers Workflow` block and migrate it into the new marker form
- if the block boundary cannot be recognized safely, stop and require explicit user confirmation rather than guessing

## Why This Approach

This design intentionally chooses a smaller implementation step over a larger directory reorganization.

Compared with moving templates into a new `templates/` directory immediately, this approach:
- fixes the core duplication problem sooner
- changes fewer paths at once
- keeps existing README/workflow/conventions template references valid with smaller edits
- creates a clean path for `upgrading-enhanced-workflow-project` to share the same template source later

It does not fully eliminate every conceptual overlap in the repo, but it removes the most error-prone one: duplicating project `CLAUDE.md` guidance inside `init-enhanced-workflow`.

## Risks

1. **Path drift:** current template references are not fully consistent across all skills. This sub-project must normalize the references that matter for init/upgrade.
2. **Legacy project migration:** older projects without marker blocks need a safe fallback path.
3. **Conceptual overlap remains:** `using-enhanced-workflow/SKILL.md` will still describe the workflow while template files also encode it. This is acceptable in the short term because their responsibilities are different.

## Success Criteria

This sub-project is complete when:
1. project `CLAUDE.md` guidance exists as its own canonical template file
2. `init-enhanced-workflow` no longer embeds a duplicated CLAUDE block inline
3. the full set of project guidance files has a single canonical template source
4. the design supports safe future `CLAUDE.md` in-place upgrades through markers
5. future guidance updates require editing template files rather than searching multiple skills for duplicated rule text

## Verification Strategy

- Inspect the final file graph and confirm the four project guidance outputs each map to exactly one canonical template source.
- Verify `init-enhanced-workflow` references template files instead of embedding duplicated project guidance text.
- Verify the `CLAUDE.md` template includes explicit block markers for later upgrades.
- Add or update tests so the project-guidance template path and marker-based insertion rules are checked automatically.
