# Superpowers Enhanced / Superpowers 增强版

> **This is an enhanced fork** of [obra/superpowers](https://github.com/obra/superpowers) with documentation persistence and requirement decomposition skills.
>
> **这是** [obra/superpowers](https://github.com/obra/superpowers) **的增强版 fork**，增加了文档沉淀和需求拆分能力。
>
> For detailed enhanced workflow documentation, see [ENHANCED.md](ENHANCED.md).
>
> 详细增强流程文档请参阅 [ENHANCED.md](ENHANCED.md)。

**8 new enhanced skills / 8 个新增增强 skill：**

| Skill | Purpose / 用途 |
|-------|---------------|
| `decomposing-requirements` | Break large requirements into sub-projects / 将大需求拆分为子项目 |
| `init-enhanced-workflow` | One-time project setup / 一次性项目初始化 |
| `using-enhanced-workflow` | Master flow reference / 总流程参考 |
| `documenting-execution` | Record task progress / 记录任务执行进度 |
| `documenting-verification` | Record verification results / 记录验证结果 |
| `documenting-debugging` | Record debugging sessions / 记录调试过程 |
| `documenting-review` | Record code review findings / 记录代码审查发现 |
| `documenting-completion` | Write completion summary / 编写完成总结 |

**All 14 original skills are preserved.** See [GETTING-STARTED.md](GETTING-STARTED.md) (English) / [GETTING-STARTED.zh-CN.md](GETTING-STARTED.zh-CN.md) (中文) for the install/use guide, and [MAINTENANCE.md](MAINTENANCE.md) for development and maintenance guidance.

**Note:** The enhanced skill count above includes only repo-shipped workflow skills. Local maintenance skills are intentionally kept outside this repository.

**保留了全部 14 个原始 skill。** 快速安装/使用请参阅 [GETTING-STARTED.md](GETTING-STARTED.md)（英文）或 [GETTING-STARTED.zh-CN.md](GETTING-STARTED.zh-CN.md)（中文），开发和维护指南请参阅 [MAINTENANCE.md](MAINTENANCE.md)。

**说明：** 上面的增强 skill 数量只统计仓库内共享工作流 skill。本地维护型 skill 会有意保留在仓库外。

---

# Superpowers

Superpowers is a complete software development methodology for your coding agents, built on top of a set of composable skills and some initial instructions that make sure your agent uses them.

## Quickstart

Give your agent Superpowers: [Claude Code](#claude-code), [Codex CLI](#codex-cli), [Codex App](#codex-app), [Factory Droid](#factory-droid), [Gemini CLI](#gemini-cli), [OpenCode](#opencode), [Cursor](#cursor), [GitHub Copilot CLI](#github-copilot-cli).

## How it works

It starts from the moment you fire up your coding agent. As soon as it sees that you're building something, it *doesn't* just jump into trying to write code. Instead, it steps back and asks you what you're really trying to do. 

Once it's teased a spec out of the conversation, it shows it to you in chunks short enough to actually read and digest. 

After you've signed off on the design, your agent puts together an implementation plan that's clear enough for an enthusiastic junior engineer with poor taste, no judgement, no project context, and an aversion to testing to follow. It emphasizes true red/green TDD, YAGNI (You Aren't Gonna Need It), and DRY. 

Next up, once you say "go", it launches a *subagent-driven-development* process, having agents work through each engineering task, inspecting and reviewing their work, and continuing forward. In this enhanced fork, review loops are reviewer-aware: after a fix, the main session verifies the change and prefers the original reviewer for re-checks before falling back to a fresh reviewer. It's not uncommon for Claude to be able to work autonomously for a couple hours at a time without deviating from the plan you put together.

There's a bunch more to it, but that's the core of the system. And because the skills trigger automatically, you don't need to do anything special. Your coding agent just has Superpowers.


## Sponsorship

If Superpowers has helped you do stuff that makes money and you are so inclined, I'd greatly appreciate it if you'd consider [sponsoring my opensource work](https://github.com/sponsors/obra).

Thanks! 

- Jesse


## Installation

Install this enhanced version from the fork repository. Installation differs by harness.

### Claude Code

Use the manual installation path described in [GETTING-STARTED.md](GETTING-STARTED.md).

At a high level:
- clone this repository into Claude's plugin cache
- register the plugin in `installed_plugins.json`
- ensure it is enabled in `settings.json`
- restart Claude Code and verify the enhanced skills load

<details>
<summary>Original Superpowers marketplace (without enhanced skills)</summary>

If you want the original version without enhanced skills, use the official marketplace/plugin instructions for the upstream project instead of this fork.

</details>

### Codex CLI

- Register this repository as a marketplace:

  ```bash
  codex plugin marketplace add LZY-Ricardo/superpowers-enhanced
  ```

- Install the plugin:

  ```bash
  codex plugin add superpowers@superpowers-enhanced
  ```

- Or use the plugin browser:

  ```bash
  /plugins
  ```

  Switch to the **Superpowers Enhanced** marketplace tab, then select `Install Plugin`.

### Codex App

- Register the marketplace from a terminal:

  ```bash
  codex plugin marketplace add LZY-Ricardo/superpowers-enhanced
  ```

- In the Codex app, click on **Plugins** in the sidebar.
- Find **Superpowers Enhanced** in your marketplace tab.
- Click the `+` next to it and follow the prompts.

### Gemini CLI

- Install the extension:

  ```bash
  gemini extensions install https://github.com/LZY-Ricardo/superpowers-enhanced
  ```

- Update later:

  ```bash
  gemini extensions update superpowers
  ```

### OpenCode

OpenCode uses its own plugin install; install Superpowers separately even if you
already use it in another harness.

- Tell OpenCode:

  ```
  Fetch and follow instructions from https://raw.githubusercontent.com/LZY-Ricardo/superpowers-enhanced/refs/heads/main/.opencode/INSTALL.md
  ```

- Detailed docs: [docs/README.opencode.md](docs/README.opencode.md)

### Cursor

- In Cursor Agent chat, install from marketplace:

  ```text
  /add-plugin superpowers
  ```

- Or search for "superpowers" in the plugin marketplace.

### GitHub Copilot CLI

- Register the marketplace:

  ```bash
  copilot plugin marketplace add LZY-Ricardo/superpowers-enhanced
  ```

- Install the plugin:

  ```bash
  copilot plugin install superpowers@superpowers-marketplace
  ```

## The Basic Workflow

1. **brainstorming** - Activates before writing code. Refines rough ideas through questions, explores alternatives, presents design in sections for validation. Saves design document.

2. **using-git-worktrees** - Activates after design approval. Creates isolated workspace on new branch, runs project setup, verifies clean test baseline.

3. **writing-plans** - Activates with approved design. Breaks work into bite-sized tasks (2-5 minutes each). Every task has exact file paths, complete code, verification steps.

4. **subagent-driven-development** or **executing-plans** - Activates with plan. Dispatches fresh subagent per task with two-stage review (spec compliance, then code quality), or executes in batches with human checkpoints.

5. **test-driven-development** - Activates during implementation. Enforces RED-GREEN-REFACTOR: write failing test, watch it fail, write minimal code, watch it pass, commit. Deletes code written before tests.

6. **requesting-code-review** - Activates between tasks. Reviews against plan, reports issues by severity. Critical issues block progress.

7. **finishing-a-development-branch** - Activates when tasks complete. Verifies tests, presents options (merge/PR/keep/discard), cleans up worktree.

**The agent checks for relevant skills before any task.** Mandatory workflows, not suggestions.

## What's Inside

### Skills Library

**Testing**
- **test-driven-development** - RED-GREEN-REFACTOR cycle (includes testing anti-patterns reference)

**Debugging**
- **systematic-debugging** - 4-phase root cause process (includes root-cause-tracing, defense-in-depth, condition-based-waiting techniques)
- **verification-before-completion** - Ensure it's actually fixed

**Collaboration** 
- **brainstorming** - Socratic design refinement
- **writing-plans** - Detailed implementation plans
- **executing-plans** - Batch execution with checkpoints
- **dispatching-parallel-agents** - Concurrent subagent workflows
- **requesting-code-review** - Pre-review checklist
- **receiving-code-review** - Responding to feedback
- **using-git-worktrees** - Parallel development branches
- **finishing-a-development-branch** - Merge/PR decision workflow
- **subagent-driven-development** - Fast iteration with two-stage review (spec compliance, then code quality)

**Meta**
- **writing-skills** - Create new skills following best practices (includes testing methodology)
- **using-superpowers** - Introduction to the skills system

## Philosophy

- **Test-Driven Development** - Write tests first, always
- **Systematic over ad-hoc** - Process over guessing
- **Complexity reduction** - Simplicity as primary goal
- **Evidence over claims** - Verify before declaring success

Read [the original release announcement](https://blog.fsck.com/2025/10/09/superpowers/).

## Contributing

The general contribution process for Superpowers is below. Keep in mind that we don't generally accept contributions of new skills and that any updates to skills must work across all of the coding agents we support.

1. Fork the repository
2. Switch to the 'dev' branch
3. Create a branch for your work
4. Follow the `writing-skills` skill for creating and testing new and modified skills
5. Submit a PR, being sure to fill in the pull request template.

See `skills/writing-skills/SKILL.md` for the complete guide.

## Updating

Superpowers updates are somewhat coding-agent dependent, but are often automatic.

## License

MIT License - see LICENSE file for details

## Community

Superpowers is built by [Jesse Vincent](https://blog.fsck.com) and the rest of the folks at [Prime Radiant](https://primeradiant.com).

- **Discord**: [Join us](https://discord.gg/35wsABTejz) for community support, questions, and sharing what you're building with Superpowers
- **Issues**: https://github.com/obra/superpowers/issues
- **Release announcements**: [Sign up](https://primeradiant.com/superpowers/) to get notified about new versions
