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

## Default Scope Tiering

Choose the lightest workflow tier that still preserves clarity.

| Tier | Typical Shape | Default Path |
|------|----------------|--------------|
| **Small** | ~≤50 LOC, one file, no new public interface, under ~30 minutes | Work directly. Skip the enhanced workflow artifacts. |
| **Medium** | Bounded multi-step work, still one coherent concern | Brainstorming is still required. Skip `writing-plans` if sequencing is obvious; otherwise use a short plan. |
| **Large** | Cross-file, cross-subsystem, external API, non-trivial sequencing, or review-sensitive changes | Run the full enhanced workflow end to end. |

This skill defines the default behavior for medium and large work. Small changes are intentionally allowed to stay ad-hoc.

## The Complete Flow

```
                        ┌─────────────────────────┐
                        │     Requirement In       │
                        └────────────┬────────────┘
                                     │
                     ┌───────────────▼────────────────┐
                     │  Size tier? small / medium /   │
                     │           large                 │
                     └──────┬───────────────┬─────────┘
                            │               │
                        Small           Medium/Large
                            │               │
                    ┌───────▼───────┐  ┌────▼──────────────┐
                    │   Work direct │  │ Multiple concerns? │
                    │ (skip docs)   │  └────┬─────────┬─────┘
                    └───────────────┘       │         │
                                            │ Yes     │ No
                                   ┌────────▼──┐  ┌──▼──────────────┐
                                   │decomposing│  │ brainstorming    │
                                   │requirements│  │ (Superpowers)    │
                                   │ → decom doc│  │ → spec doc       │
                                   └──────┬────┘  └──┬───────────────┘
                                          │           │
                                          └────► user │
                                                 picks│
                                                 sub- │
                                                 proj ┘
                                                     │
                                  ┌──────────────────▼─────────────┐
                                  │ writing-plans (only when large │
                                  │ or medium work needs sequencing)│
                                  │   → plan doc + review-config    │
                                  └──────────────────┬─────────────┘
                                                     │
                       ┌─────────────────────────────▼────────────────────────────┐
                       │                Plan Execution                             │
                       │          (executing-plans by default)                    │
                       │                                                          │
                       │ Per task:                                                │
                       │ 1. Load review config                                    │
                       │ 2. Implement + verify                                    │
                       │ 3. If needed, debug + re-verify                          │
                       │ 4. Apply configured review strategy                      │
                       │ 5. Write one merged execution-log block                  │
                       └─────────────────────────────┬────────────────────────────┘
                                                     │
                                  ┌──────────────────▼─────────────┐
                                  │ documenting-completion          │
                                  │ → dashboard completion summary  │
                                  └──────────────────┬─────────────┘
                                                     │
                                  ┌──────────────────▼─────────────┐
                                  │ finishing-a-development-branch │
                                  │ → merge / PR                   │
                                  └────────────────────────────────┘
```

## Phase Reference

### Phase 1: Requirement Decomposition (conditional)

| Item | Detail |
|------|--------|
| **When** | Requirement involves 3+ features, is vague, or clearly spans multiple independent concerns |
| **Skill** | `decomposing-requirements` |
| **Output** | `docs/superpowers/decomposition/YYYY-MM-DD-<topic>.md` |
| **Next** | User picks first sub-project → Phase 2 |

Skip this phase if the requirement is a single, well-scoped concern.

### Phase 2: Brainstorming

| Item | Detail |
|------|--------|
| **When** | Always, before any code, for medium and large work |
| **Skill** | `brainstorming` (Superpowers) |
| **Output** | `docs/superpowers/specs/YYYY-MM-DD-<feature-name>-design.md` |
| **Next** | Phase 3 if a plan is needed; otherwise execution |

### Phase 3: Planning

| Item | Detail |
|------|--------|
| **When** | Large work, or medium work with non-trivial sequencing |
| **Skill** | `writing-plans` (Superpowers) |
| **Output** | `docs/superpowers/plans/YYYY-MM-DD-<feature-name>.md` + `docs/superpowers/plans/YYYY-MM-DD-<feature-name>.review-config.md` |
| **Next** | Phase 4 |

### Phase 4: Execution (default = inline, review-config driven)

| Item | Detail |
|------|--------|
| **When** | Spec is approved and the work is ready to implement |
| **Skill** | `executing-plans` by default; `subagent-driven-development` only when isolation is worth the cost |
| **Output** | Working code + git commits + execution-log entries |

**For each task in the plan, run this default sub-loop:**

```
4a. Step 0: Load review config
    → read docs/superpowers/plans/<feature-name>.review-config.md

4b. Implement task
    → use TDD as specified in the plan
    → commit at the task checkpoint

4c. Run verification
    → tests / build / lint / type-check / manual check as specified

4d. If verification fails → debug
    → document only if the investigation is substantial or deferred
    → re-verify

4e. Apply review strategy from review-config
    → self-checklist always runs
    → task-level external review only if configured or forced by plan deviation
    → feature-level review happens later at feature closeout

4f. Write one merged execution-log block
    → Execution
    → Verification
    → Review (self-checklist)
    → Review (applied config)
    → Debugging

4g. Move to next task
```

### Phase 5: Completion

| Item | Detail |
|------|--------|
| **When** | All tasks done, all configured reviews passed |
| **Skill** | `documenting-completion` |
| **Output** | `docs/superpowers/completion/YYYY-MM-DD-<feature-name>-summary.md` |
| **Next** | Phase 6 |

The completion summary is a dashboard and handoff surface, not a narrative retelling of the spec, execution log, review log, and debugging log.

### Phase 6: Branch Finish

| Item | Detail |
|------|--------|
| **When** | Completion summary is written |
| **Skill** | `finishing-a-development-branch` (Superpowers) |
| **Output** | Merged branch or PR |

## Review Config Lifecycle

For planned work, write one feature-level config file after planning:

`docs/superpowers/plans/YYYY-MM-DD-<feature-name>.review-config.md`

It should define:
- execution mode
- task-level review setting
- feature-level review setting
- review executor (main session / subagent / hybrid)
- hard rules (self-checklist always on, plan deviation escalation, etc.)

Every task starts by reading this file. Every task's execution-log block records how the config was applied.

## Resuming Mid-Project

When joining a project that already has Superpowers docs:

1. **Check `status.md` first** — it is the live recovery surface for the active feature, current phase, current review strategy, blockers, and next step
2. **Check decomposition/** — macro-level initiative map for large work
3. **Check README.md** — index page for where detailed artifacts live
4. **Check the current `review-config.md`** — this tells you the active execution and review defaults for the feature
5. **Check execution-log** — shows which tasks are done, blocked, or remaining
6. **Check review-log** — shows deferred and cross-task review items worth tracking separately
7. **Check debugging-log** — shows reusable issue investigations and workarounds
8. **Resume from where the current status and linked artifacts indicate**

Do NOT restart the workflow from scratch. Read existing docs and continue.

## Document Index

All docs for a feature share the same `<feature-name>` slug. Find the full set:

```
docs/superpowers/
  decomposition/<feature-name>.md       ← only if decomposed
  specs/<feature-name>-design.md
  plans/<feature-name>.md
  plans/<feature-name>.review-config.md ← planned-work review and execution config
  execution-log/<feature-name>.md       ← one merged block per completed task
  debugging-log/<issue-brief>.md        ← only for standalone investigations
  review-log/<feature-name>.md          ← only for external/deferred/cross-task review tracking
  completion/<feature-name>-summary.md  ← dashboard/hub linking to all above
```

## Red Flags

| Thought | Reality |
|---------|---------|
| "Every task deserves the full heavy workflow" | No — pick the smallest tier that preserves clarity. |
| "Subagent-driven should always be the default because it sounds more advanced" | Inline execution is the default. Use subagents only when their isolation is worth the cost. |
| "I need to call every documenting skill after every task" | The default path is one merged execution-log block per task. Separate review/debug files are only for items with independent tracking value. |
| "Completion summary should restate everything so no one has to open links" | The completion summary is a dashboard. Link to the source artifacts instead of retelling them. |
| "I don't know which skill to use next" | Check the phase order and size tiering above. The next skill is defined by current phase and work size. |
| "I'll figure out existing docs by reading git log" | Read `status.md`, `review-config.md`, then execution-log. Faster and more accurate than git archaeology. |
