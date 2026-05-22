# Enhanced Workflow Documentation / 增强流程文档

## What is this? / 这是什么？

This fork enhances the original Superpowers with **documentation persistence** and **requirement decomposition**. Every development phase now produces a documented artifact that survives across sessions.

这个 fork 在原版 Superpowers 基础上增加了**文档沉淀**和**需求拆分**能力。每个开发阶段都会产出可跨会话保留的文档。

## Why Enhanced? / 为什么增强？

The original Superpowers workflow has a gap: review findings, debugging sessions, and execution progress exist only in temporary subagent sessions and vanish when the session ends. This fork closes that gap.

原版 Superpowers 工作流有一个缺口：审查发现、调试过程和执行进度只存在于临时子代理会话中，会话结束后就消失了。这个 fork 弥补了这个缺口。

| Problem / 问题 | Solution / 解决方案 |
|-------|---------------|
| Review findings vanish after session / 审查发现在会话后消失 | `documenting-review` records all findings with resolution status |
| Execution progress is untracked / 执行进度无追踪 | `documenting-execution` logs each task with status and deviations |
| Large requirements have no decomposition step / 大需求没有拆分步骤 | `decomposing-requirements` breaks them into sub-projects |
| Verification results are not recorded / 验证结果没有记录 | `documenting-verification` captures test/build/lint results |
| Bugs are re-investigated across sessions / Bug 在不同会话中被重复调查 | `documenting-debugging` records symptom → root cause → fix |
| No final handoff document / 没有最终交接文档 | `documenting-completion` writes a summary before merge |

## Complete Workflow / 完整流程

```
                    ┌─────────────────────┐
                    │   Requirement In    │
                    │   需求输入          │
                    └──────────┬──────────┘
                               │
                    ┌──────────▼──────────┐
                    │  Multiple concerns?  │
                    │  多个关注点？        │
                    └─────┬─────────┬─────┘
                     Yes  │         │ No
              ┌───────────▼──┐  ┌───▼───────────┐
              │ decomposing- │  │               │
              │ requirements │  │ brainstorming │
              │ 需求拆分      │  │ 头脑风暴      │
              │ → decomposition/ │ → specs/     │
              └──────┬───────┘  └───┬───────────┘
                     │              │
                     └──────► user  │
                             picks  │
                             sub-   │
                             project┘
                               │
                    ┌──────────▼──────────┐
                    │   writing-plans     │
                    │   编写计划          │
                    │   → plans/          │
                    └──────────┬──────────┘
                               │
              ┌────────────────▼────────────────┐
              │         Plan Execution           │
              │         计划执行                  │
              │                                   │
              │   Per task / 每个任务:            │
              │   ┌────────────────────────┐     │
              │   │ Implement → commit     │     │
              │   │ documenting-execution   │ ←── 执行记录
              │   │ Verify                  │     │
              │   │ documenting-verification│ ←── 验证记录
              │   │ Debug (if needed)       │     │
              │   │ documenting-debugging   │ ←── 调试记录
              │   │ Code review             │     │
              │   │ documenting-review      │ ←── 审查记录
              │   └────────────────────────┘     │
              └────────────────┬──────────────────┘
                               │
                    ┌──────────▼──────────┐
                    │ documenting-         │
                    │ completion           │
                    │ 完成总结             │
                    │ → completion/        │
                    └──────────┬──────────┘
                               │
                    ┌──────────▼──────────┐
                    │  Merge / PR         │
                    │  合并 / PR          │
                    └─────────────────────┘
```

## Enhanced Skills Reference / 增强 Skill 参考

### decomposing-requirements / 需求拆分

**When:** Requirement involves 3+ features or is vague / 需求涉及 3+ 功能或比较模糊
**Output:** `docs/superpowers/decomposition/YYYY-MM-DD-<topic>.md`

Breaks large requirements into independent sub-projects with dependencies, risks, and priorities. User controls what to build and in what order.

将大需求拆分为独立子项目，包含依赖关系、风险和优先级。用户控制做什么和顺序。

### init-enhanced-workflow / 初始化工作流

**When:** Starting a new project / 启动新项目
**Output:** Directory structure + project CLAUDE.md + docs/README.md

One-time setup that creates the documentation infrastructure. Run once per project.

一次性设置，创建文档基础设施。每个项目运行一次。

### using-enhanced-workflow / 使用增强工作流

**When:** Need to understand the complete flow / 需要了解完整流程
**Output:** None (reference only)

Master reference for all phases, skill chaining, and document structure. Consult when unsure about what to do next.

所有阶段、skill 链式调用和文档结构的主参考。不确定下一步时查阅。

### documenting-execution / 执行记录

**When:** After each task is committed / 每个任务提交后
**Output:** Appends to `docs/superpowers/execution-log/YYYY-MM-DD-<feature>.md`

Records task status (DONE/PARTIAL/BLOCKED/DEVIATED/SKIPPED), deviations from plan, implementation decisions, and commit SHAs.

记录任务状态、计划偏差、实现决策和 commit SHA。

### documenting-verification / 验证记录

**When:** After running tests, build, lint / 运行测试、构建、lint 后
**Output:** Appends to execution-log

Records verification results as structured evidence. Failures trigger `documenting-debugging`.

以结构化证据记录验证结果。失败时触发 `documenting-debugging`。

### documenting-debugging / 调试记录

**When:** After resolving or deferring a bug / 解决或推迟 bug 后
**Output:** `docs/superpowers/debugging-log/YYYY-MM-DD-<issue>.md`

Records symptom → root cause → fix → verification. Prevents re-investigating the same issue.

记录 症状→根因→修复→验证。防止重复调查同一问题。

### documenting-review / 审查记录

**When:** After each code review cycle / 每次代码审查后
**Output:** Appends to `docs/superpowers/review-log/YYYY-MM-DD-<feature>.md`

Records all findings (CRITICAL/IMPORTANT/MINOR) with resolution (FIXED/DEFERRED/REJECTED). No finding is silently dropped.

记录所有发现（严重/重要/次要）及解决方案（已修复/已推迟/已拒绝）。不会丢失任何发现。

### documenting-completion / 完成总结

**When:** Before merge or PR / 合并或 PR 之前
**Output:** `docs/superpowers/completion/YYYY-MM-DD-<feature>-summary.md`

Final handoff document: spec vs. reality, known issues, deferred items, files changed, next steps. Links to all other docs.

最终交接文档：设计 vs 现实、已知问题、遗留项目、文件变更、后续步骤。链接到所有其他文档。

## Installation / 安装

### As a Claude Code Plugin / 作为 Claude Code 插件

```bash
# Install from this repository / 从本仓库安装
claude plugin add --url https://github.com/LZY-Ricardo/superpowers-enhanced.git
```

### First-Time Setup in a Project / 项目首次设置

After installation, run in your project directory:

安装后，在项目目录运行：

```
# Tell your AI agent / 告诉 AI 代理:
"Initialize the enhanced superpowers workflow for this project"
```

Or invoke the `init-enhanced-workflow` skill directly.

或直接调用 `init-enhanced-workflow` skill。

## Relationship with Upstream / 与原仓库的关系

- This fork tracks [obra/superpowers](https://github.com/obra/superpowers) via `upstream` remote
- All 14 original skills are preserved unchanged (except `using-superpowers` with annotated addition)
- 8 enhanced skills are additive and live alongside original skills
- See [MAINTENANCE.md](MAINTENANCE.md) for sync workflow

- 本 fork 通过 `upstream` remote 跟踪 [obra/superpowers](https://github.com/obra/superpowers)
- 14 个原始 skill 保持不变（`using-superpowers` 除外，有标注的增强内容）
- 8 个增强 skill 是加法，和原始 skill 并存
- 同步工作流请参阅 [MAINTENANCE.md](MAINTENANCE.md)
