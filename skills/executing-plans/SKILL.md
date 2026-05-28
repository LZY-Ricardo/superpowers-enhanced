---
name: executing-plans
description: Use when you have a written implementation plan to execute in the current session with the review strategy defined by the plan's review-config.
---

# Executing Plans

## Overview

Load the plan, check it critically, then execute all tasks in this session using the review strategy defined by the feature's `review-config.md`.

**Announce at start:** "I'm using the executing-plans skill to implement this plan."

This is the default execution path for the enhanced workflow. Use `subagent-driven-development` only when task isolation is genuinely worth the additional cost.

## The Process

### Step 1: Load and Review Plan
1. Read the plan file
2. Read the plan's `review-config.md`
3. Review the plan critically — identify any questions or concerns before starting
4. If concerns: raise them with your human partner before execution
5. If no concerns: create task tracking and proceed

### Step 2: Execute Tasks

For each task:
1. Mark as in progress
2. Run **Step 0: Load review config**
3. Follow the task steps exactly
4. Run the specified verification
5. Apply the configured review strategy
6. Write the merged execution-log block
7. Mark the task complete

### Step 3: Complete Development

After all tasks complete and the configured feature-level review passes:
- Announce: "I'm using the finishing-a-development-branch skill to complete this work."
- **REQUIRED SUB-SKILL:** Use `superpowers:finishing-a-development-branch`
- Follow that skill to verify tests, present options, and execute the chosen finish path

## Review Strategy Rules

Execution must obey the feature's `review-config.md`.

That config defines:
- task-level review setting
- feature-level review setting
- review executor
- hard rules such as self-checklist always on and deviation escalation

**Do not silently replace the configured review mode with a heavier one.**
If the config says task-level review is off, use the self-checklist and move on unless deviation escalation is triggered.

## When to Stop and Ask for Help

**STOP executing immediately when:**
- you hit a real blocker (missing dependency, command failure that changes the plan, unclear instruction)
- the plan has a critical gap preventing start
- a required command or artifact cannot be made to work after reasonable debugging
- verification fails repeatedly and the issue is not local to the current task

**Ask for clarification rather than guessing.**

## When to Revisit Earlier Steps

**Return to review before continuing when:**
- the human partner updates the plan
- the task deviates so far from the plan that the plan itself needs rewriting
- a new blocker changes the approach, not just the implementation details

## Remember
- Inline execution is the ordinary path
- Read both the plan and its `review-config.md` before starting
- Follow task steps exactly
- Don't skip verification
- Don't skip the merged execution-log closeout
- Don't upgrade review intensity unless config or deviation requires it
- Stop when blocked; don't guess
- Never start implementation on main/master branch without explicit user consent

## Integration

**Required workflow skills:**
- **superpowers:using-git-worktrees** — Ensures isolated workspace when requested
- **superpowers:writing-plans** — Creates the plan and review-config this skill executes
- **superpowers:finishing-a-development-branch** — Completes development after all tasks
