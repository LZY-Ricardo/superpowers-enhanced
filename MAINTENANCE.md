# Maintenance Guide / 维护指南

This document describes how to develop, maintain, and update this enhanced fork of Superpowers.

本文档描述如何开发、维护和更新这个 Superpowers 增强版 fork。

---

## Architecture Overview / 架构概览

```
skills/
├── [Original Skills - 14 from upstream]    ← DO NOT modify unless necessary
│   ├── brainstorming/
│   ├── writing-plans/
│   ├── executing-plans/
│   └── ...
│
└── [Enhanced Skills - 8 added by us]       ← We own these, modify freely
    ├── decomposing-requirements/
    ├── documenting-execution/
    ├── documenting-verification/
    ├── documenting-debugging/
    ├── documenting-review/
    ├── documenting-completion/
    ├── init-enhanced-workflow/
    └── using-enhanced-workflow/

ENHANCED-CHANGES.md                         ← Registry of modifications to original skills
MAINTENANCE.md                              ← THIS FILE
```

**Principle / 原则:** Enhanced skills are additive. Original skills are modified only when necessary for integration.

**原则：** 增强技能是加法。原始技能仅在必要时为集成而修改。

---

## Adding a New Enhanced Skill / 新增增强 Skill

Follow this checklist step by step:

### Step 1: Create Directory

```bash
mkdir -p skills/<skill-name>
```

**Naming convention / 命名规范:**
- Use verb-noun or gerund-noun: `documenting-*`, `decomposing-*`, `init-*`
- Lowercase with hyphens: `documenting-execution` not `DocumentingExecution`
- Be specific: `documenting-review` not `documenting`

### Step 2: Create SKILL.md

Required frontmatter fields:

```yaml
---
name: <skill-name>
description: Use when <triggering conditions> — <brief purpose>. <More trigger details>.
---
```

**Description rules / description 规则:**
- Start with "Use when..." to focus on triggering conditions
- Describe WHEN to use, NOT what the skill does
- Include specific symptoms, situations, contexts
- Keep under 500 characters
- Third person (injected into system prompt)

Required sections in body:
1. Title + overview (1-2 sentences)
2. "Announce at start" line
3. "When to Use" (with flowchart if decision is non-obvious)
4. Output Location (where docs go, if applicable)
5. Content format/template (what the output looks like)
6. Key Principles
7. Red Flags table

Optional sections:
- Auto-Init (if the skill creates files/directories)
- Cross-references to other skills
- Status/Severity definitions

### Step 3: Add Documentation Templates (if needed)

If the skill generates project documentation, create template files:

```bash
# Place templates next to SKILL.md or in a docs/ subdirectory
skills/<skill-name>/docs-<template-name>-template.md
```

Templates are copied to target projects by `init-enhanced-workflow`.

### Step 4: Update Related Files

- [ ] Add skill to the table in `CLAUDE.md` (Enhanced Skills section)
- [ ] Add skill to the table in `ENHANCED.md` (if created)
- [ ] If skill creates docs, add its directory to `init-enhanced-workflow/SKILL.md`
- [ ] If skill has templates, add copy command to `init-enhanced-workflow/SKILL.md`
- [ ] If skill changes the workflow, update `using-enhanced-workflow/SKILL.md` flow diagram

### Step 5: Test

1. Invoke the skill in a test session
2. Verify it triggers at the right moment (check description triggers correctly)
3. Verify it produces the expected output
4. Verify it chains to/from adjacent skills correctly

### Step 6: Commit

```bash
git add skills/<skill-name>/
git add CLAUDE.md  # if updated
git commit -m "feat: add <skill-name> skill"
```

---

## Modifying an Original Skill / 修改原始 Skill

**Only modify original skills when absolutely necessary for integration.** Before modifying, ask: can this be achieved by a new enhanced skill instead?

**仅在绝对必要时才修改原始 skill。** 修改前先问：能否通过新增增强 skill 来实现？

### Annotation Protocol / 标注协议

When modifying an original skill, wrap ALL changes with markers:

```markdown
<!-- ENHANCED: <marker-id> -->
[Your added content here]
<!-- /ENHANCED: <marker-id> -->
```

**Marker naming rules / 标注命名规则:**
- Format: `ENHANCED: <verb>-<noun>-<purpose>`
- Example: `ENHANCED: added-enhanced-workflow-ref`
- Unique per modification point — never reuse a marker ID
- One marker per logical change — don't bundle multiple changes under one marker

### Registration Flow / 登记流程

After modifying an original skill, register the change in `ENHANCED-CHANGES.md`:

```markdown
### skills/<skill-name>/SKILL.md

**Marker:** `ENHANCED: <marker-id>`
**Location:** [where in the file, e.g., "After 'Skill Priority' section, ~line 45"]
**Added content:**
```
[exact content between the markers]
```
**Reason:** [why this modification was needed]
```

### Verification / 验证

After modification:
1. Test the skill still works correctly
2. Test the enhanced workflow still chains properly
3. Verify the annotation markers are correctly placed
4. Verify ENHANCED-CHANGES.md matches the actual file content

---

## Upstream Sync Workflow / 上游同步流程

When the original Superpowers repo has updates:

### Step 1: Fetch and Review

```bash
# Fetch upstream changes
git fetch upstream

# Review what changed
git log --oneline HEAD..upstream/main
git diff HEAD..upstream/main --stat

# Check if any modified files overlap with our changes
git diff HEAD..upstream/main -- skills/using-superpowers/
```

### Step 2: Merge

```bash
git merge upstream/main
```

### Step 3: Handle Conflicts (if any)

If conflicts occur:

1. Open each conflicted file
2. Look for `<!-- ENHANCED:` markers — our additions are clearly marked
3. Resolve by keeping both: upstream's new content + our enhanced additions
4. For each resolved conflict, verify against `ENHANCED-CHANGES.md`:
   - Is every marker still present?
   - Is the content between markers still correct?
   - Does the marker ID match what's registered?

### Step 4: Post-Merge Verification

- [ ] All `<!-- ENHANCED:` markers still exist in modified files
- [ ] ENHANCED-CHANGES.md entries match actual file content
- [ ] Enhanced skills still load and trigger correctly
- [ ] Original skills still work as expected
- [ ] No merge artifacts (conflict markers `<<<<<<<`, `=======`, `>>>>>>>`) remain

### Step 5: Update and Commit

```bash
# Update the sync date in ENHANCED-CHANGES.md
# Change: Last synced with upstream: <old-date>
# To:     Last synced with upstream: <today>

git add .
git commit -m "chore: sync with upstream superpowers (upstream <sha>)"
```

---

## File Reference / 文件参考

| File | Purpose |
|------|---------|
| `CLAUDE.md` | Contributor guidelines (original) + enhanced skills list (added) |
| `ENHANCED-CHANGES.md` | Registry of all modifications to original skills |
| `MAINTENANCE.md` | THIS FILE — development and maintenance guide |
| `ENHANCED.md` | Detailed description of the enhanced workflow (bilingual) |
| `README.md` | Project overview (original + fork description) |
| `skills/*/SKILL.md` | Individual skill definitions |
| `skills/using-enhanced-workflow/docs-*-template.md` | Documentation templates for projects |
