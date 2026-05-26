# Maintenance Skill Systematization Design

## Context

As Superpowers Enhanced has grown, a second class of skills has emerged alongside the shared workflow skills: local operational/maintenance skills such as plugin install/update management and project guidance upgrades. These skills are useful and legitimate, but they do not belong in the shared workflow repository in the same way that decomposition, documentation, and execution skills do. Without an explicit boundary, future maintenance work risks repeatedly reintroducing the same confusion: which skills should ship in the repo, which should stay local, and why.

The purpose of this sub-project is to formalize that boundary in a way that helps both future Claude sessions and human maintainers make consistent placement decisions.

## Goal

Systematize the boundary between:
- **repo-shipped workflow skills** that belong in the shared enhanced workflow repository, and
- **local maintenance skills** that belong in `~/.claude/skills/`

so future changes do not repeatedly mix operational/local tooling into the shared workflow plugin.

## Non-Goals

This sub-project does **not**:
- add hooks or hard enforcement automation
- reorganize local skill directories beyond lightweight naming/placement guidance
- build a local skill index system
- change the behavior of existing workflow skills
- move current local maintenance skills into the repo

## Chosen Approach

Use a **dual-layer governance model**:

1. **Short operational rule in repository `CLAUDE.md`**
   - immediate AI-facing guardrail while working in this repo
   - prevents future sessions from casually adding local maintenance skills into the repo

2. **Full decision framework in `MAINTENANCE.md`**
   - human/maintainer-facing guidance
   - includes explicit criteria, examples, and a placement checklist

3. **Lightweight consistency note in outward-facing docs**
   - a short clarification in `README.md` and/or `ENHANCED.md`
   - makes it explicit that enhanced skill counts refer only to repo-shipped workflow skills, not local maintenance skills

This gives execution-time guardrails, maintenance-time decision support, and lightweight external consistency without adding new automation.

## Skill Classes

### Repo-shipped workflow skills
These belong in the shared repository because they affect the actual development workflow for projects using Enhanced Superpowers.

Examples:
- decomposition
- init project workflow
- using the enhanced workflow
- documenting execution / verification / review / debugging / completion
- orchestration behavior tightly coupled to the enhanced workflow

### Local maintenance skills
These belong in `~/.claude/skills/` because they are operational support for the user's own environment, plugin lifecycle, migration workflow, or local maintenance habits.

Examples:
- `installing-superpowers-enhanced`
- `upgrading-enhanced-workflow-project`
- install / update / uninstall helpers
- migration helpers for older initialized projects
- personal session-management or handoff helpers that are not part of the shared workflow

## Decision Principle

A skill belongs in the shared repo **only if it changes or supports the workflow that ordinary projects should follow while being developed under Enhanced Superpowers**.

A skill belongs locally **if it primarily helps manage the plugin installation, local environment, migration, or personal operational workflow**.

## `CLAUDE.md` Requirement

Repository `CLAUDE.md` should include a short, explicit rule that says in substance:
- local maintenance/install/migration skills do not belong in this repo by default
- only shared workflow skills that benefit all Enhanced Superpowers users belong in the repo
- local maintenance skills must not be counted as part of the enhanced skill inventory

This rule should be short and operational, not a long essay.

## `MAINTENANCE.md` Requirement

`MAINTENANCE.md` should gain a dedicated section for skill placement decisions.

That section should include:

### 1. Two definitions
- repo-shipped workflow skill
- local maintenance skill

### 2. Placement checklist
For any new skill, answer:
1. Does this affect the shared development workflow used inside project repos?
2. Would another Enhanced Superpowers user benefit from this inside normal project work?
3. Is it primarily about plugin install/update/migration/local operations?
4. Would putting it in the repo increase shared workflow complexity without improving ordinary project execution?

If the answer trends toward local operations, it stays local.

### 3. Examples table
A small examples table should map representative skills into the two buckets, including at least:
- `installing-superpowers-enhanced` → local maintenance
- `upgrading-enhanced-workflow-project` → local maintenance
- `documenting-review` → repo workflow
- `init-enhanced-workflow` → repo workflow

### 4. Inventory rule
Make explicit that the repository's enhanced-skill counts/tables include only repo-shipped workflow skills, not personal/local maintenance skills.

## `README.md` / `ENHANCED.md` Requirement

At least one outward-facing summary document should include a concise note that:
- the enhanced skill count refers to repo-shipped workflow skills
- local maintenance skills are intentionally kept outside the repository

This note should remain lightweight and should not turn README/ENHANCED into governance manuals.

## Why Not Add Automation Yet

A hook or automated enforcement rule would add complexity before the governance model itself is fully documented and accepted. Right now the problem is primarily decision ambiguity, not inability to enforce. A clear documented boundary is the right first step.

## Risks

1. **Rules too vague:** future sessions may still rationalize that a local skill “helps enough” to belong in the repo.
2. **Rules too rigid:** a genuinely shared maintenance capability might be blocked unnecessarily.
3. **Documentation-only drift:** if the short rule, the maintenance checklist, and the outward-facing note diverge, confusion returns.

## Mitigations

- keep the `CLAUDE.md` rule short and categorical
- keep the `MAINTENANCE.md` checklist concrete and example-driven
- keep the README/ENHANCED note short and inventory-focused
- treat `MAINTENANCE.md` as the source of nuance and `CLAUDE.md` as the execution-time guardrail

## Success Criteria

This sub-project is complete when:
1. the repository has an explicit AI-facing rule preventing local maintenance skills from being casually added to the repo
2. maintainers have a documented placement checklist for new skills
3. local operational skills are explicitly recognized as legitimate but out-of-repo by default
4. the enhanced skill inventory is clearly defined as repo-shipped workflow skills only
5. outward-facing docs do not imply that local maintenance skills are part of the shipped enhanced workflow inventory

## Verification Strategy

- Verify `CLAUDE.md` contains a short placement rule that would actually guide an AI session in this repo.
- Verify `MAINTENANCE.md` contains concrete definitions, examples, and a placement checklist.
- Verify `README.md` and/or `ENHANCED.md` include a short inventory clarification note.
- Verify repository summary docs do not imply that local maintenance skills are part of the shipped enhanced workflow inventory.
