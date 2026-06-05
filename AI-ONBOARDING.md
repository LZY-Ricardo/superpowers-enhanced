# AI Onboarding Guide / AI 入职指南

**Read this file first when working on this project.**
**在这个项目上工作时，请先阅读此文件。**

This file tells you what to read and in what order to understand the complete project.
本文件告诉你阅读什么以及按什么顺序来了解完整项目。

---

## What is this project? / 这是什么项目？

This is a development workflow plugin for AI coding agents (Claude Code, Codex, Gemini CLI, etc.) with **documentation persistence** and **requirement decomposition** built in.

这是一个 AI 编码代理（Claude Code、Codex、Gemini CLI 等）的开发工作流插件，内置**文档沉淀**和**需求拆分**能力。

The plugin ships 22 skills covering the full development lifecycle: brainstorming, planning, execution, review, debugging, and completion.

插件包含 22 个 skill，覆盖完整的开发生命周期：头脑风暴、计划、执行、审查、调试和完成。

---

## Reading Order / 阅读顺序

Read these files **in order**. Each step builds on the previous one.

**按顺序**阅读这些文件。每一步建立在前一步的基础上。

### Step 1: Project Overview / 项目概览（5 min）

**Read:** [README.md](README.md)

You will learn:
- What this plugin is and how it works
- Installation instructions

你将了解：这个插件是什么、如何安装

### Step 2: Workflow Details / 工作流细节（10 min）

**Read:** [ENHANCED.md](ENHANCED.md)

You will learn:
- The complete workflow with all phases
- What each skill does, when to trigger, what it outputs
- Installation and first-time setup

你将了解：完整工作流、每个 skill 的用途、安装和初始化

### Step 3: Skill Inventory / Skill 清单（5 min）

**Scan:** `skills/` directory

All 22 skills are listed in `CLAUDE.md`. Each skill lives in `skills/<skill-name>/SKILL.md`.

22 个 skill 列在 `CLAUDE.md` 中。每个 skill 在 `skills/<skill-name>/SKILL.md`。

### Step 4: Development & Maintenance Guide / 开发维护指南（10 min）

**Read:** [MAINTENANCE.md](MAINTENANCE.md)

You will learn:
- How to add a new skill (step-by-step checklist)
- How to modify an existing skill
- How to manage plugin releases

你将了解：如何新增 skill、如何修改 skill、如何管理插件发布

---

## Key Rules for Working on This Project / 项目工作关键规则

1. **All skills are equal.** Modify any skill as needed, following the SKILL.md template structure.
   所有 skill 同等对待，按需修改，遵循 SKILL.md 模板结构。

2. **Bilingual documentation.** All new docs should include both English and Chinese.
   所有新文档应包含中英双语。

3. **Test before committing.** Invoke the skill in a session and verify it works.
   提交前测试：在会话中调用 skill 并验证其工作正常。

4. **Sync the Codex copy.** After changing files under `skills/`, run `./scripts/sync-codex-plugin.sh`.
   修改 `skills/` 下的文件后，运行 `./scripts/sync-codex-plugin.sh`。

---

## Quick Reference / 快速参考

| I want to... / 我想... | Read / 阅读 |
|----------------------|------------|
| Understand the project | README.md → ENHANCED.md |
| Know the full workflow | ENHANCED.md → using-enhanced-workflow/SKILL.md |
| Add a new skill | MAINTENANCE.md "Adding a New Skill" |
| Modify a skill | MAINTENANCE.md "Modifying a Skill" |
| Understand a specific skill | skills/<skill-name>/SKILL.md |
