# AI Onboarding Guide / AI 入职指南

**Read this file first when working on this project.**
**在这个项目上工作时，请先阅读此文件。**

This file tells you what to read and in what order to understand the complete project.
本文件告诉你阅读什么以及按什么顺序来了解完整项目。

---

## What is this project? / 这是什么项目？

This is an **enhanced fork** of [obra/superpowers](https://github.com/obra/superpowers) — a development workflow plugin for AI coding agents (Claude Code, Codex, Gemini CLI, etc.).

这是 [obra/superpowers](https://github.com/obra/superpowers) 的**增强版 fork** —— 一个 AI 编码代理（Claude Code、Codex、Gemini CLI 等）的开发工作流插件。

We add 8 skills on top of the 14 original skills, focusing on **documentation persistence** and **requirement decomposition**.

在 14 个原始 skill 基础上新增 8 个 skill，专注于**文档沉淀**和**需求拆分**。

---

## Reading Order / 阅读顺序

Read these files **in order**. Each step builds on the previous one.

**按顺序**阅读这些文件。每一步建立在前一步的基础上。

### Step 1: Project Overview / 项目概览（5 min）

**Read:** [README.md](README.md)

You will learn:
- What Superpowers is and how it works
- What this fork adds (8 new skills)
- Installation instructions

你将了解：Superpowers 是什么、这个 fork 增加了什么、如何安装

### Step 2: Enhanced Details / 增强细节（10 min）

**Read:** [ENHANCED.md](ENHANCED.md)

You will learn:
- Why we enhanced Superpowers (what gaps we close)
- The complete workflow with all phases
- What each enhanced skill does, when to trigger, what it outputs
- Installation and first-time setup

你将了解：为什么增强、完整工作流、每个增强 skill 的用途、安装和初始化

### Step 3: Skill Inventory / Skill 清单（5 min）

**Scan:** `skills/` directory

```
skills/
  # Original skills (14) — do NOT modify unless following MAINTENANCE.md protocol
  # 原始 skill（14个）—— 除非遵循 MAINTENANCE.md 协议，否则不要修改
  brainstorming/
  dispatching-parallel-agents/
  executing-plans/
  finishing-a-development-branch/
  receiving-code-review/
  requesting-code-review/
  subagent-driven-development/
  systematic-debugging/
  test-driven-development/
  using-git-worktrees/
  using-superpowers/          ← MODIFIED: has ENHANCED annotation
  verification-before-completion/
  writing-plans/
  writing-skills/

  # Enhanced skills (8) — we own these, modify freely
  # 增强 skill（8个）—— 我们自己维护，可自由修改
  decomposing-requirements/
  documenting-completion/
  documenting-debugging/
  documenting-execution/
  documenting-review/
  documenting-verification/
  init-enhanced-workflow/
  using-enhanced-workflow/    ← contains doc templates for projects
```

### Step 4: Development & Maintenance Guide / 开发维护指南（10 min）

**Read:** [MAINTENANCE.md](MAINTENANCE.md)

You will learn:
- How to add a new enhanced skill (step-by-step checklist)
- How to modify an original skill (annotation protocol)
- How to sync with upstream (merge workflow + conflict handling)

你将了解：如何新增 skill、如何修改原 skill、如何同步上游

### Step 5: Change Registry / 变更登记（2 min）

**Read:** [ENHANCED-CHANGES.md](ENHANCED-CHANGES.md)

You will learn:
- Which original files we modified
- Exact content we added (with markers)
- Why each modification was needed

你将了解：修改了哪些原文件、加了什么内容、为什么加

---

## Key Rules for Working on This Project / 项目工作关键规则

1. **Original skills are sacred.** Only modify with annotation protocol from MAINTENANCE.md.
   原始 skill 不可随意修改，必须遵循 MAINTENANCE.md 的标注协议。

2. **Enhanced skills are ours.** Modify freely, but follow the SKILL.md template structure.
   增强 skill 可自由修改，但要遵循 SKILL.md 模板结构。

3. **Bilingual documentation.** All new docs should include both English and Chinese.
   所有新文档应包含中英双语。

4. **Test before committing.** Invoke the skill in a session and verify it works.
   提交前测试：在会话中调用 skill 并验证其工作正常。

---

## Quick Reference / 快速参考

| I want to... / 我想... | Read / 阅读 |
|----------------------|------------|
| Understand the project | README.md → ENHANCED.md |
| Know the full workflow | ENHANCED.md → using-enhanced-workflow/SKILL.md |
| Add a new skill | MAINTENANCE.md "Adding a New Enhanced Skill" |
| Modify an original skill | MAINTENANCE.md "Modifying an Original Skill" + ENHANCED-CHANGES.md |
| Sync with upstream | MAINTENANCE.md "Upstream Sync Workflow" |
| Find what changed in original files | ENHANCED-CHANGES.md |
| Understand a specific skill | skills/<skill-name>/SKILL.md |
