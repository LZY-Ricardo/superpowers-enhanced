# Superpowers Enhanced 快速开始

这是一份面向其他使用者的实用安装与使用说明。

## 1. 安装插件（Claude Code）

在 Claude Code 中执行以下两条命令：

### 第一步：注册 marketplace

```text
/plugin marketplace add LZY-Ricardo/superpowers-enhanced
```

### 第二步：安装插件

```text
/plugin install superpowers@superpowers-enhanced
```

### 第三步：重新加载插件

```text
/reload-plugins
```

完成——三条命令，无需手动编辑任何配置文件。

## 1b. 安装插件（Codex CLI / App）

### 第一步：注册 marketplace

```bash
codex plugin marketplace add LZY-Ricardo/superpowers-enhanced
```

### 第二步：安装插件

```bash
codex plugin add superpowers@superpowers-enhanced
```

也可以用交互式插件浏览器：输入 `/plugins`，切换到 **Superpowers Enhanced** marketplace 标签页，选择 `Install Plugin`。

### 第三步（仅 Codex App）：从侧边栏安装

1. 在终端运行 `codex plugin marketplace add LZY-Ricardo/superpowers-enhanced`。
2. 在 Codex App 中，点击侧边栏的 **Plugins**。
3. 在你的 marketplace 标签页找到 **Superpowers Enhanced**。
4. 点击 `+` 按钮并按照提示操作。

## 2. 验证插件是否加载成功

可以先执行：

```text
/superpowers:using-enhanced-workflow
```

如果能正常加载完整增强流程说明，插件就已经生效。

也可以再问一句：

```text
告诉我你有哪些 superpowers skills
```

## 3. 安装成功判定清单

安装成功应同时满足以下条件：

- `superpowers:using-superpowers` 可用
- `superpowers:brainstorming` 可用
- `superpowers:init-enhanced-workflow` 可用
- `superpowers:using-enhanced-workflow` 可用
- `/superpowers:using-enhanced-workflow` 能正常加载
- 插件出现在你的插件列表中

如果其中任意一项失败，请看下方排障部分。

## 4. 在项目里初始化增强工作流

在一个你希望启用增强流程的项目里，告诉 Claude：

```text
Initialize the enhanced superpowers workflow for this project
```

这会调用 `superpowers:init-enhanced-workflow`，生成：

```text
docs/superpowers/
  README.md
  workflow.md
  conventions.md
  status.md
  version.json
  decomposition/
  specs/
  plans/
  execution-log/
  debugging-log/
  review-log/
  completion/
```

同时也会更新项目级 `CLAUDE.md`。

## 5. 开始正常使用

### 小需求 / 常规需求
直接描述需求，例如：

```text
Add image upload support to this project
```

Claude 应该会按增强流程自动推进。

### 大需求 / 多子项目需求
直接描述完整目标，例如：

```text
Help me redesign the workflow versioning and upgrade system
```

Claude 应该先触发需求拆分，再按子项目逐个推进。

## 6. 升级一个已经初始化过的老项目

如果一个项目已经有 `docs/superpowers/`，但其中的指导文件版本较老，**不要重新运行 init**。

应该只升级 guidance layer：
- 项目级 `CLAUDE.md`
- `docs/superpowers/README.md`
- `docs/superpowers/workflow.md`
- `docs/superpowers/conventions.md`
- `docs/superpowers/status.md`
- `docs/superpowers/version.json`

**不要覆盖**这些历史记录：
- `execution-log/`
- `review-log/`
- `debugging-log/`
- `completion/`
- `specs/`
- `plans/`
- `decomposition/`

**说明：** 我自己本地会用一个 maintenance skill（例如 `/upgrading-enhanced-workflow-project`）来做这件事，但这个 skill **不属于本仓库**，其他使用者默认安装后是没有的。

## 7. 以后如何更新插件

### Claude Code

卸载后重新安装即可获取最新版：

```text
/plugin uninstall superpowers@superpowers-enhanced
/plugin marketplace add LZY-Ricardo/superpowers-enhanced
/plugin install superpowers@superpowers-enhanced
/reload-plugins
```

### Codex CLI

```bash
codex plugin marketplace upgrade superpowers-enhanced
codex plugin add superpowers@superpowers-enhanced
```

## 8. 卸载

### Claude Code

```text
/plugin uninstall superpowers@superpowers-enhanced
/reload-plugins
```

### Codex CLI

```bash
codex plugin remove superpowers@superpowers-enhanced
```

## 9. 常见问题排查

### 技能加载了，但行为像旧版本
重新安装插件以获取最新版本。Claude Code 卸载后重装；Codex 运行 `codex plugin marketplace upgrade` 后重装。

### 注册 marketplace 失败
检查网络连接。Claude Code 和 Codex 都需要从 GitHub 克隆仓库。

### 插件安装了但 skills 找不到
重启 Claude Code 或运行 `/reload-plugins`。Codex 则开启一个新会话。

## 10. 手动安装（Claude Code 备选方案）

如果 `/plugin` 命令在你的环境里不工作，可以手动安装：

### 第一步：克隆仓库到 Claude 插件缓存目录

```bash
git clone https://github.com/LZY-Ricardo/superpowers-enhanced.git ~/.claude/plugins/cache/superpowers-enhanced/latest
git -C ~/.claude/plugins/cache/superpowers-enhanced/latest checkout main
```

### 第二步：注册 marketplace

在 `~/.claude/plugins/known_marketplaces.json` 中添加：

```json
{
  "superpowers-enhanced": {
    "source": {
      "source": "github",
      "repo": "LZY-Ricardo/superpowers-enhanced"
    },
    "installLocation": "/Users/<你>/.claude/plugins/cache/superpowers-enhanced/latest",
    "lastUpdated": "<当前时间戳>"
  }
}
```

### 第三步：创建 marketplace 符号链接

```bash
ln -s ~/.claude/plugins/cache/superpowers-enhanced/latest ~/.claude/plugins/marketplaces/superpowers-enhanced
```

### 第四步：注册插件安装记录

在 `~/.claude/plugins/installed_plugins.json` 中添加：

```json
{
  "superpowers@superpowers-enhanced": [
    {
      "scope": "user",
      "installPath": "/Users/<你>/.claude/plugins/cache/superpowers-enhanced/latest",
      "version": "5.2.0",
      "installedAt": "<当前时间戳>",
      "lastUpdated": "<当前时间戳>",
      "gitCommitSha": "<最新 commit SHA>"
    }
  ]
}
```

获取最新 SHA：

```bash
git -C ~/.claude/plugins/cache/superpowers-enhanced/latest rev-parse HEAD
```

### 第五步：启用插件

在 `~/.claude/settings.json` 中添加：

```json
{
  "enabledPlugins": {
    "superpowers@superpowers-enhanced": true
  }
}
```

### 第六步：完全重启 Claude Code

彻底退出并重新打开 Claude Code，然后开启一个新会话。

## 说明

- 本仓库里的增强 skill 数量，只统计 **repo-shipped workflow skills**。
- 安装、迁移、更新这类本地运维辅助 skill 如果存在于 `~/.claude/skills/`，它们不属于本仓库对外发布的一部分。
