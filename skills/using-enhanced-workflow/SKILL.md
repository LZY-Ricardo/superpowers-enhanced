---
name: using-enhanced-workflow
description: Use when starting any development work — defines the complete enhanced Superpowers workflow with documentation at every phase. This is the master reference for all custom skills and their execution order.
---

# Using Enhanced Workflow

The complete development workflow: Superpowers core skills + custom documentation skills. This skill is your map — consult it to know which skill to invoke at each phase.

**Core principle:** Every phase produces both working software AND a documentation artifact. Nothing is lost between phases.

**Announce at start:** "I'm using the using-enhanced-workflow skill to set up the development workflow."

## First-Time Setup

When using this workflow in a project for the first time:

1. Create the documentation directory structure:
   ```bash
   mkdir -p docs/superpowers/{decomposition,specs,plans,execution-log,debugging-log,review-log,completion}
   ```

2. Copy the README template from this plugin's template directory to `docs/superpowers/README.md`:
   ```bash
   cp ~/.claude/plugins/cache/superpowers-enhanced/latest/skills/using-enhanced-workflow/docs-superpowers-README-template.md docs/superpowers/README.md
   ```

3. Commit the structure to the project.

For subsequent features, the structure already exists — just start the workflow.

**Template ownership:** Project guidance files copied into repos come from the canonical template files in this directory, including the project `CLAUDE.md` template and `docs/superpowers/version.json` template. This `SKILL.md` is the runtime reference for Claude, not the direct copy source for project files.

**Metadata semantics:** Projects may record both `pluginVersion` and `workflowTemplateVersion` in `docs/superpowers/version.json`. In the initial implementation they are equal, but they are intentionally separate so future template-only versioning can be introduced without redesigning the metadata file.

## The Complete Flow

```
                        ┌─────────────────────────┐
                        │     Requirement In       │
                        └────────────┬────────────┘
                                     │
                          ┌──────────▼──────────┐
                          │  Multiple concerns?  │
                          └──────┬───────┬───────┘
                           Yes   │       │ No
                    ┌────────────▼─┐ ┌───▼──────────────┐
                    │ decomposing- │ │                   │
                    │ requirements │ │  brainstorming    │
                    │              │ │  (Superpowers)    │
                    │ → decom doc  │ │                   │
                    └──────┬───────┘ │ → spec doc       │
                           │         └───┬──────────────┘
                           └────► user      │
                                  picks     │
                                  sub-      │
                                  project ──┘
                                     │
                          ┌──────────▼──────────┐
                          │  writing-plans       │
                          │  (Superpowers)       │
                          │  → plan doc          │
                          └──────────┬──────────┘
                                     │
                    ┌────────────────▼────────────────┐
                    │       Plan Execution             │
                    │  (executing-plans /               │
                    │   subagent-driven-development)    │
                    │                                    │
                    │   For each task:                   │
                    │   ┌──────────────────────────┐    │
                    │   │ 1. Implement & commit     │    │
                    │   │ 2. documenting-execution   │ ←── appends to execution-log
                    │   │ 3. Verification            │    │
                    │   │ 4. documenting-verification│ ←── appends to execution-log
                    │   │ 5. Code review             │    │
                    │   │ 6. Fix + verification      │    │
                    │   │ 7. Re-review              │    │
                    │   │ 8. documenting-review       │ ←── appends to review-log
                    │   │ 9. [Debug if needed]       │    │
                    │   │ 10. documenting-debugging   │ ←── creates debugging-log entry
                    │   └──────────────────────────┘    │
                    └────────────────┬──────────────────┘
                                     │
                          ┌──────────▼──────────┐
                          │ documenting-         │
                          │ completion           │
                          │ → completion summary │
                          └──────────┬──────────┘
                                     │
                          ┌──────────▼──────────┐
                          │ finishing-a-         │
                          │ development-branch   │
                          │ (Superpowers)        │
                          │ → merge / PR         │
                          └─────────────────────┘
```

## Phase Reference

### Phase 1: Requirement Decomposition (conditional)

| Item | Detail |
|------|--------|
| **When** | Requirement involves 3+ features, is vague, or user asks "how to approach this" |
| **Skill** | `decomposing-requirements` |
| **Output** | `docs/superpowers/decomposition/YYYY-MM-DD-<topic>.md` |
| **Next** | User picks first sub-project → Phase 2 |

Skip this phase if the requirement is a single, well-scoped feature.

### Phase 2: Brainstorming

| Item | Detail |
|------|--------|
| **When** | Always, before any code |
| **Skill** | `brainstorming` (Superpowers) |
| **Output** | `docs/superpowers/specs/YYYY-MM-DD-<feature-name>-design.md` |
| **Next** | Phase 3 |

### Phase 3: Planning

| Item | Detail |
|------|--------|
| **When** | Always, after spec is approved |
| **Skill** | `writing-plans` (Superpowers) |
| **Output** | `docs/superpowers/plans/YYYY-MM-DD-<feature-name>.md` |
| **Next** | Phase 4 |

### Phase 4: Execution (loops per task)

| Item | Detail |
|------|--------|
| **When** | Plan is ready |
| **Skill** | `subagent-driven-development` or `executing-plans` (Superpowers) |
| **Output** | Working code + git commits |

**For each task in the plan, run this sub-loop:**

```
4a. Implement task → commit
    → invoke documenting-execution

4b. Run verification (tests, build, lint)
    → invoke documenting-verification

4c. If verification fails → debug
    → invoke documenting-debugging
    → re-verify → re-record

4d. Code review (spec compliance → code quality)
    → invoke documenting-review

4e. If review finds issues → implementer fixes
    → main session runs verification
    → prefer same reviewer for re-check
    → fallback to fresh reviewer if original reviewer is unavailable or still lacks context
    → update review log entry with cycle linkage and re-check status

4f. If re-check finds new issues, record them as new findings and continue the loop

4g. Move to next task
```

### Phase 5: Completion

| Item | Detail |
|------|--------|
| **When** | All tasks done, all reviews passed |
| **Skill** | `documenting-completion` |
| **Output** | `docs/superpowers/completion/YYYY-MM-DD-<feature-name>-summary.md` |
| **Next** | Phase 6 |

### Phase 6: Branch Finish

| Item | Detail |
|------|--------|
| **When** | Completion summary is written |
| **Skill** | `finishing-a-development-branch` (Superpowers) |
| **Output** | Merged branch or PR |

## Resuming Mid-Project

When joining a project that already has Superpowers docs:

1. **Check for completion summary first** — if it exists in `completion/`, the feature is done
2. **Check execution-log** — shows which tasks are done, blocked, or remaining
3. **Check review-log** — shows deferred items that might need attention
4. **Check debugging-log** — shows known issues and workarounds
5. **Resume from where the last entry left off**

Do NOT restart the workflow from scratch. Read existing docs and continue.

## Document Index

All docs for a feature share the same `<feature-name>` slug. Find the full set:

```
docs/superpowers/
  decomposition/<feature-name>.md       ← only if decomposed
  specs/<feature-name>-design.md
  plans/<feature-name>.md
  execution-log/<feature-name>.md       ← includes verification entries
  debugging-log/<issue-brief>.md        ← one per issue, may have multiple
  review-log/<feature-name>.md
  completion/<feature-name>-summary.md  ← links to all above
```

The **completion summary** is the hub — it links to all other docs for the feature.

## Red Flags

| Thought | Reality |
|---------|---------|
| "I'll skip the documenting skills this time" | Documenting is mandatory in the Superpowers workflow per CLAUDE.md |
| "I don't know which skill to use next" | Check the flow diagram above. Current phase → next skill is defined. |
| "This is too much process for a small change" | Small changes (< 30 min) can use ad-hoc approach. Larger work follows this flow. |
| "I'll figure out existing docs by reading git log" | Read the completion summary first, then execution-log. Faster than git archaeology. |
| "I'll do all the documenting at the end" | Document each phase as it completes. End-of-session documentation = incomplete documentation. |
