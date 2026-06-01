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
- [ ] Run `./scripts/sync-codex-plugin.sh` and commit the updated `plugins/superpowers/` copy (or rely on the pre-commit hook)

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

## Skill Placement Decisions / Skill 放置决策

Use this section when deciding whether a new skill belongs in the shared repository or only in local `~/.claude/skills/`.

本节用于判断一个新 skill 应该进入共享仓库，还是只放在本地 `~/.claude/skills/`。

### Two Skill Classes / 两类 Skill

**Repo-shipped workflow skill / 仓库内共享工作流 skill**
- Changes or supports the shared Enhanced Superpowers workflow used inside ordinary project repositories
- Benefits other Enhanced Superpowers users during normal project work

**Local maintenance skill / 本地维护型 skill**
- Primarily manages plugin installation, updating, migration, local environment setup, or personal operational workflow
- Useful locally, but not part of the shared project-development workflow itself

### Placement Checklist / 放置检查清单

Before adding a new skill, answer:
1. Does this affect the shared development workflow used inside project repos?
2. Would another Enhanced Superpowers user benefit from this inside normal project work?
3. Is it primarily about plugin install/update/migration/local operations?
4. Would putting it in the repo increase shared workflow complexity without improving ordinary project execution?

If the answers trend toward local operations, the skill stays local.

如果答案更偏向本地运维，那么这个 skill 应该留在本地。

### Examples / 例子

| Skill | Placement | Why |
|------|-----------|-----|
| `installing-superpowers-enhanced` | Local maintenance | Manages plugin install/update/uninstall for one user's environment |
| `upgrading-enhanced-workflow-project` | Local maintenance | Helps migrate already-initialized projects in a user's environment |
| `documenting-review` | Repo workflow | Shared workflow behavior for all Enhanced Superpowers users |
| `init-enhanced-workflow` | Repo workflow | Shared project workflow initialization behavior |

### Inventory Rule / 计数规则

The repository's enhanced skill counts and tables include only repo-shipped workflow skills. Personal/local maintenance skills are intentionally excluded.

仓库里的增强 skill 数量和表格只统计仓库内共享工作流 skill，不包含本地维护型 skill。

---

## Release Versioning / 发布版本号

Claude Code and Codex both install this plugin into versioned cache paths, for example:

Claude Code 和 Codex 都会把插件安装到带版本号的缓存路径，例如：

```text
~/.claude/plugins/cache/superpowers-enhanced/superpowers/5.2.1
~/.codex/plugins/cache/superpowers-enhanced/superpowers/5.2.1
```

For any user-visible release, bump the version in all plugin manifests before pushing. If the version does not change, users may keep loading the previous cache even after reinstalling.

对任何对外可见的发布，都要先提升所有插件 manifest 的版本号再推送。如果版本号不变，用户即使重新安装也可能继续加载旧缓存。

Update these files together:

这些文件需要一起更新：

- `package.json`
- `.claude-plugin/plugin.json`
- `.claude-plugin/marketplace.json`
- `.codex-plugin/plugin.json`
- `.cursor-plugin/plugin.json`
- `gemini-extension.json`
- `workflow-template-version.json`
- `docs/superpowers/version.json` if this repository's own workflow guidance is being upgraded

Then run the Codex sync step below before committing.

然后在提交前运行下方的 Codex 同步步骤。

---

## Codex Plugin Sync / Codex 插件同步

The `plugins/superpowers/` directory contains a **file copy** of the plugin for Codex marketplace discovery. Codex does not follow symlinks, so actual files are required.

`plugins/superpowers/` 目录包含用于 Codex marketplace 发现的插件**文件副本**。Codex 不支持符号链接，必须使用实际文件。

### Syncing / 同步

After changing any file under `skills/`, `hooks/`, `.codex-plugin/`, `assets/`, `README.md`, or `LICENSE`, sync the Codex copy:

修改 `skills/`、`hooks/`、`.codex-plugin/`、`assets/`、`README.md` 或 `LICENSE` 下的文件后，同步 Codex 副本：

```bash
./scripts/sync-codex-plugin.sh
git add plugins/superpowers/
git commit -m "chore: sync codex plugin"
```

### Pre-commit Hook / Pre-commit 钩子

A pre-commit hook can automate this. It detects changes to source files and runs the sync script before each commit:

pre-commit 钩子可以自动化此流程。它检测源文件变更并在每次提交前运行同步脚本：

```bash
# Install / 安装
cp scripts/pre-commit-sync-codex.sh .git/hooks/pre-commit
```

When the hook is installed, you do not need to run `sync-codex-plugin.sh` manually. It triggers automatically on `git commit` when relevant files have changed.

钩子安装后无需手动运行 `sync-codex-plugin.sh`。当相关文件有变更时，它会在 `git commit` 时自动触发。

### Why a Copy / 为什么是副本

The upstream `obra/superpowers` uses a separate marketplace repo (`prime-radiant-inc/openai-codex-plugins`) and a sync script to publish to Codex. This fork takes a simpler approach: the plugin copy lives in the same repo under `plugins/superpowers/`. The trade-off is that the copy must be kept in sync manually or via the pre-commit hook.

上游 `obra/superpowers` 使用独立的 marketplace 仓库（`prime-radiant-inc/openai-codex-plugins`）和同步脚本发布到 Codex。本 fork 采用更简单的方式：插件副本存放在同一仓库的 `plugins/superpowers/` 下。代价是需要手动或通过 pre-commit 钩子保持同步。

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
| `.agents/plugins/marketplace.json` | Codex marketplace catalog |
| `.codex-plugin/plugin.json` | Codex plugin manifest |
| `plugins/superpowers/` | Codex plugin file copy (synced from root) |
| `scripts/sync-codex-plugin.sh` | Sync root files → Codex plugin copy |
| `scripts/pre-commit-sync-codex.sh` | Pre-commit hook for auto-sync |
