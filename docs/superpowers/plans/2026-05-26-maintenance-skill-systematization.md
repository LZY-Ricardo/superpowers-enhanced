# Maintenance Skill Systematization Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the boundary between repo-shipped workflow skills and local maintenance skills explicit for both AI sessions and human maintainers.

**Architecture:** Add a short AI-facing guardrail in repository `CLAUDE.md`, a full placement framework in `MAINTENANCE.md`, and a lightweight inventory clarification note in outward-facing docs. Keep the first iteration purely documentation/governance-based, with no hooks or automation.

**Tech Stack:** Markdown repository docs and contributor guidance

---

## File Structure

- `CLAUDE.md` — short operational guardrail for AI sessions working in this repo
- `MAINTENANCE.md` — detailed placement framework, examples, and checklist
- `README.md` and/or `ENHANCED.md` — lightweight inventory clarification note

## Task 1: Add a short AI-facing guardrail to CLAUDE.md

**Files:**
- Modify: `CLAUDE.md`
- Test: manual structural verification (grep/check wording)

- [ ] **Step 1: Write the failing structural check mentally before editing**

The new rule must explicitly state that:
- local maintenance/install/migration skills do not belong in this repo by default
- only shared workflow skills that benefit all Enhanced Superpowers users belong here
- local maintenance skills are not part of the enhanced skill inventory

- [ ] **Step 2: Add the guardrail**

Insert a short section in `CLAUDE.md` near the enhanced workflow skill inventory or contributor rules, with wording like:

```md
### Local Maintenance Skills vs Repo Workflow Skills

Local maintenance skills (install/update/uninstall/migration/personal operational helpers) do not belong in this repository by default. They should live in `~/.claude/skills/` unless they directly support the shared Enhanced Superpowers project workflow used inside ordinary repos.

Do not count local maintenance skills as part of the repository's enhanced skill inventory.
```

Keep this short and operational.

- [ ] **Step 3: Verify the rule is present and concise**

Run:
```bash
grep -n "Local Maintenance Skills vs Repo Workflow Skills\|do not belong in this repository by default\|enhanced skill inventory" CLAUDE.md
```
Expected: the new guardrail is present.

- [ ] **Step 4: Commit**

```bash
git add CLAUDE.md
git commit -m "docs: add local maintenance skill guardrail"
```

## Task 2: Add the full placement framework to MAINTENANCE.md

**Files:**
- Modify: `MAINTENANCE.md`

- [ ] **Step 1: Add a dedicated section for skill placement decisions**

Create a new section with:
- definitions of repo-shipped workflow skill vs local maintenance skill
- placement checklist
- examples table
- inventory rule

Use the concrete examples from the spec:
- `installing-superpowers-enhanced` → local maintenance
- `upgrading-enhanced-workflow-project` → local maintenance
- `documenting-review` → repo workflow
- `init-enhanced-workflow` → repo workflow

- [ ] **Step 2: Keep the examples and checklist concrete**

The checklist should ask:
1. Does this affect the shared development workflow used inside project repos?
2. Would another Enhanced Superpowers user benefit from this inside normal project work?
3. Is it primarily about plugin install/update/migration/local operations?
4. Would putting it in the repo increase shared workflow complexity without improving ordinary project execution?

- [ ] **Step 3: Verify the new section exists and is usable**

Run:
```bash
grep -n "skill placement\|repo-shipped workflow skill\|local maintenance skill\|installing-superpowers-enhanced\|upgrading-enhanced-workflow-project" MAINTENANCE.md
```
Expected: the section and examples are present.

- [ ] **Step 4: Commit**

```bash
git add MAINTENANCE.md
git commit -m "docs: define maintenance skill placement framework"
```

## Task 3: Add a lightweight inventory clarification note to outward-facing docs

**Files:**
- Modify: `README.md`
- Modify: `ENHANCED.md` *(only if needed for consistency; if README alone is sufficient, keep scope smaller)*

- [ ] **Step 1: Add a concise note**

Add a lightweight clarification near the enhanced skills table or fork overview saying that:
- the enhanced skill count refers to repo-shipped workflow skills
- local maintenance skills are intentionally kept outside the repository

Keep this short and avoid turning README/ENHANCED into governance manuals.

- [ ] **Step 2: Verify the note is present and not overlong**

Run:
```bash
grep -n "repo-shipped workflow skills\|local maintenance skills" README.md ENHANCED.md
```
Expected: at least one outward-facing doc contains the clarification.

- [ ] **Step 3: Commit**

```bash
git add README.md ENHANCED.md
git commit -m "docs: clarify enhanced skill inventory scope"
```

## Task 4: Self-check for inventory consistency

**Files:**
- Read-only verification across `CLAUDE.md`, `MAINTENANCE.md`, `README.md`, `ENHANCED.md`

- [ ] **Step 1: Verify the four docs do not contradict each other**

Check that:
- `CLAUDE.md` gives the short AI-facing rule
- `MAINTENANCE.md` gives the detailed decision framework
- outward-facing docs do not imply local maintenance skills are part of the shipped enhanced workflow
- enhanced skill counts/tables still refer to the 8 repo-shipped workflow skills only

- [ ] **Step 2: Run consistency checks**

Run:
```bash
grep -n "local maintenance\|repo-shipped\|enhanced skill inventory\|8 new enhanced skills" CLAUDE.md MAINTENANCE.md README.md ENHANCED.md
```
Expected: consistent terminology and no accidental inclusion of local maintenance skills in the repo inventory.

- [ ] **Step 3: Commit**

If this step only confirms consistency and no further edits are needed, there is no separate commit.

## Self-Review

- **Spec coverage:**
  - AI-facing rule → Task 1
  - maintainer-facing framework/checklist → Task 2
  - outward-facing clarification → Task 3
  - inventory consistency → Task 4

- **Placeholder scan:**
  - no TODO/TBD placeholders remain
  - examples are concrete and explicit

- **Type consistency:**
  - `repo-shipped workflow skill` and `local maintenance skill` are used consistently across docs
  - local examples remain local, repo workflow examples remain in-repo

## Execution Handoff

**Plan complete and saved to `docs/superpowers/plans/2026-05-26-maintenance-skill-systematization.md`. Two execution options:**

**1. Subagent-Driven (recommended)** - I dispatch a fresh subagent per task, review between tasks, fast iteration

**2. Inline Execution** - Execute tasks in this session using executing-plans, batch execution with checkpoints

**Which approach?**
