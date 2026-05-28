---
name: writing-plans
description: Use when you have a spec or requirements for a multi-step task, before touching code
---

# Writing Plans

## Overview

Write implementation plans that a zero-context engineer can execute safely and predictably. The plan must make file touch points, sequencing, verification, and review strategy explicit without degenerating into a dump of final production code.

Assume the implementer is skilled, but knows almost nothing about the codebase and may make poor judgment calls if the plan leaves room for interpretation.

**Announce at start:** "I'm using the writing-plans skill to create the implementation plan."

**Context:** If working in an isolated worktree, it should have been created via the `superpowers:using-git-worktrees` skill at execution time.

**Save plans to:** `docs/superpowers/plans/YYYY-MM-DD-<feature-name>.md`
- (User preferences for plan location override this default)

## Scope Check

If the spec covers multiple independent subsystems, it should have been broken into sub-project specs during brainstorming. If it wasn't, suggest breaking this into separate plans — one per subsystem. Each plan should produce working, testable software on its own.

Medium-scope work does not always need a full plan. If the spec is straightforward and sequencing is obvious, say so. Write a plan only when sequencing, coordination, or traceability benefits from it.

## File Structure

Before defining tasks, map out which files will be created or modified and what each one is responsible for. This is where decomposition decisions get locked in.

- Design units with clear boundaries and well-defined interfaces. Each file should have one clear responsibility.
- You reason best about code you can hold in context at once, and your edits are more reliable when files are focused. Prefer smaller, focused files over large ones that do too much.
- Files that change together should live together. Split by responsibility, not by technical layer.
- In existing codebases, follow established patterns. If the codebase uses large files, don't unilaterally restructure — but if a file you're modifying has grown unwieldy, including a split in the plan is reasonable.

This structure informs the task decomposition. Each task should produce self-contained changes that make sense independently.

## Bite-Sized Task Granularity

**Each step is one action (2-5 minutes):**
- "Write the failing test" — step
- "Run it to make sure it fails" — step
- "Implement the minimal behavior" — step
- "Run the tests and make sure they pass" — step
- "Commit" — step
- "Write the merged execution-log block" — step

## Plan Document Header

**Every plan MUST start with this header:**

```markdown
# [Feature Name] Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans by default for this plan. Use superpowers:subagent-driven-development only if a task is truly independent and the isolation cost is worth it. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries]

---
```

## Plan Content Standard

Plans must stay executable and specific without becoming a final-source dump.

**Default rule:**
- **Failing test steps** stay concrete and complete.
- **Implementation steps** use signatures, key diffs, pseudo-code for non-trivial logic, exact file paths, commands, and references to exact spec sections.
- **Do not** paste whole final source files unless the code is genuinely tiny.

If you strip code blocks out of the finished plan, the remaining prose should still read as a coherent plan: what changes, why, where, and how to verify it.

## Review Config Requirement

Every full plan must define the review strategy that execution will follow.

Alongside the plan, execution must create:

`docs/superpowers/plans/YYYY-MM-DD-<feature-name>.review-config.md`

That config defines:
- execution mode
- task-level review setting
- feature-level review setting
- review executor (main session / subagent / hybrid)
- hard rules (self-checklist always on, deviation escalation, etc.)

Every task must begin by loading this config.

## Task Structure

````markdown
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/new-file.ext`
- Modify: `exact/path/to/existing-file.ext`
- Test: `exact/path/to/test-file.ext`

- [ ] **Step 0: Load review config**

Read: `docs/superpowers/plans/<feature-name>.review-config.md`
Apply the configured task-level / feature-level review strategy before implementing this task.

- [ ] **Step 1: Write the failing test**

```language
# concrete test code here
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `exact command`
Expected: concrete failure reason

- [ ] **Step 3: Implement the minimal behavior**

```language
# signatures, key diffs, or pseudo-code for the non-trivial logic
# include exact spec references like: see spec §2.3
```

- [ ] **Step 4: Run verification**

Run: `exact command`
Expected: concrete pass result

- [ ] **Step 5: Commit**

```bash
git add exact/file paths
git commit -m "type: concise message"
```

- [ ] **Step 6: Write the merged execution-log block**

Append one task block to:
`docs/superpowers/execution-log/YYYY-MM-DD-<feature-name>.md`

The block must contain:

```markdown
## Task N: [Task Name]

**Execution**
- What was implemented.

**Verification**
- Exact commands run and actual PASS/FAIL outcomes.

**Review (self-checklist)**
- Spec mapping
- Interface consistency
- Tests verify behavior
- Smell scan
- Spec-stated boundaries covered
- Plan deviation check

**Review (applied config)**
- What the review-config required for this task
- Whether deviation escalation was triggered

**Debugging**
- `N/A` or a link to a standalone debugging-log entry
```
````

## No Placeholders

Every step must contain the actual content an engineer needs. These are **plan failures** — never write them:
- "TBD", "TODO", "implement later", "fill in details"
- "Add appropriate error handling" / "add validation" / "handle edge cases"
- "Write tests for the above" (without actual test code)
- "Similar to Task N" (repeat the needed code/commands — tasks must stand alone)
- Steps that describe what to do without showing how
- References to types, functions, or methods not defined anywhere in the plan
- Summary placeholders like `<result>` or `<current-branch>` when a plan can instead instruct the implementer to record the actual value at execution time

## Remember
- Exact file paths always
- Concrete failing tests always
- Implementation steps should be **skeleton + key snippets** by default, not final-file dumps
- Exact commands with expected output
- DRY, YAGNI, TDD, frequent commits
- Default execution is inline unless there is a real reason to pay for task isolation

## Self-Review

After writing the complete plan, look at the spec with fresh eyes and check the plan against it. This is a checklist you run yourself — not a subagent dispatch.

**1. Spec coverage:** Skim each section/requirement in the spec. Can you point to a task that implements it? List any gaps.

**2. Placeholder scan:** Search your plan for the red flags from the "No Placeholders" section. Fix them.

**3. Type consistency:** Do the types, method signatures, and property names you used in later tasks match what you defined in earlier tasks?

**4. Lightweight plan check:** If you strip out the code blocks, does the remaining plan still make sense? If not, the plan has drifted into implementation disguised as planning.

If you find issues, fix them inline. No need to re-review — just fix and move on. If you find a spec requirement with no task, add the task.

## Execution Handoff

After saving the plan, offer execution choice:

**"Plan complete and saved to `docs/superpowers/plans/<filename>.md`. Default execution is inline for this workflow.**

**1. Inline Execution (recommended)** — Execute tasks in this session using `superpowers:executing-plans`

**2. Subagent-Driven** — Use `superpowers:subagent-driven-development` only if task isolation is worth the cost

**Review strategy (configure once for the whole feature):**
- Task-level review: Off / Spec only / Spec + code
- Feature-level review: Spec only / Code only / Spec + code
- Review executor: Main session / Subagent / Hybrid

**Hard rules:**
- self-checklist always runs
- plan deviation triggers one escalation review regardless of task-level setting
- feature-level review must keep at least one review dimension enabled
- TDD failing-test step cannot be skipped

**Which execution mode and review strategy do you want?"**

**If Inline Execution chosen:**
- **REQUIRED SUB-SKILL:** Use `superpowers:executing-plans`
- Write `review-config.md` before starting Task 1
- Follow the task steps and merged execution-log closeout exactly

**If Subagent-Driven chosen:**
- **REQUIRED SUB-SKILL:** Use `superpowers:subagent-driven-development`
- Still write `review-config.md` before starting Task 1
- The controller must provide the config to subagents and may only use subagents where the isolation cost is justified
