# Superpowers Enhanced 快速开始

这是一份面向其他使用者的实用安装与使用说明。

## 适用人群

这份文档默认读者愿意在需要时手动编辑 Claude Code 本地 JSON 配置文件。当前最稳定的安装方式是**手动安装**。

## 1. 安装插件（手动方式）

### 第一步：克隆仓库到 Claude 插件缓存目录

```bash
git clone https://github.com/LZY-Ricardo/superpowers-enhanced.git ~/.claude/plugins/cache/superpowers-enhanced/latest
git -C ~/.claude/plugins/cache/superpowers-enhanced/latest checkout main
```

### 第二步：注册 marketplace

确保 `~/.claude/plugins/known_marketplaces.json` 中存在类似条目：

```json
{
  "superpowers-enhanced": {
    "source": {
      "source": "github",
      "repo": "LZY-Ricardo/superpowers-enhanced"
    },
    "installLocation": "/Users/<you>/.claude/plugins/cache/superpowers-enhanced/latest",
    "lastUpdated": "<CURRENT_TIMESTAMP>"
  }
}
```

如果这个文件里已经有其他 marketplace，请只追加 `superpowers-enhanced` 这一项，不要删除其他内容。

### 第三步：确认 marketplace 的符号链接存在

```bash
ln -s ~/.claude/plugins/cache/superpowers-enhanced/latest ~/.claude/plugins/marketplaces/superpowers-enhanced
```

如果链接已经存在，就保留不动。

### 第四步：注册插件安装记录

确保 `~/.claude/plugins/installed_plugins.json` 中存在类似条目：

```json
{
  "version": 2,
  "plugins": {
    "superpowers@superpowers-enhanced": [
      {
        "scope": "user",
        "installPath": "/Users/<you>/.claude/plugins/cache/superpowers-enhanced/latest",
        "version": "5.2.0",
        "installedAt": "<CURRENT_TIMESTAMP>",
        "lastUpdated": "<CURRENT_TIMESTAMP>",
        "gitCommitSha": "<LATEST_COMMIT_SHA>"
      }
    ]
  }
}
```

可以通过下面命令拿到最新 SHA：

```bash
git -C ~/.claude/plugins/cache/superpowers-enhanced/latest rev-parse HEAD
```

### 第五步：启用插件

确保 `~/.claude/settings.json` 中包含：

```json
{
  "enabledPlugins": {
    "superpowers@superpowers-enhanced": true
  }
}
```

如果 `enabledPlugins` 里已经有其他插件，请只追加 `superpowers@superpowers-enhanced`，不要删除其他内容。

### 第六步：完全重启 Claude Code

彻底退出并重新打开 Claude Code，然后开启一个新会话。

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
- `~/.claude/plugins/installed_plugins.json` 中存在 `superpowers@superpowers-enhanced`
- 实际加载的插件路径在磁盘上存在

如果其中任意一项失败，请看下方排障部分。

## 4. 确认 Claude 实际加载的是哪套插件缓存

有些环境里，Claude 可能会从这种版本化路径加载：

```text
~/.claude/plugins/cache/superpowers-enhanced/superpowers/5.2.0
```

而不是你手动维护的：

```text
~/.claude/plugins/cache/superpowers-enhanced/latest
```

真正的判断依据是：

```text
~/.claude/plugins/installed_plugins.json
```

重点看：
- `installPath`
- `version`
- `gitCommitSha`

如果你更新后发现 Claude 还在读旧内容，优先检查实际加载路径，而不是只更新 `latest/`。

## 5. 在项目里初始化增强工作流

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

## 6. 开始正常使用

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

## 7. 升级一个已经初始化过的老项目

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

## 8. 以后如何更新插件

更新时应优先更新 **实际加载的插件缓存路径**，而不是任意一份 clone。

### 第一步：确认当前激活路径

查看：

```text
~/.claude/plugins/installed_plugins.json
```

重点看：
- `installPath`
- `version`
- `gitCommitSha`

### 第二步：在该路径下拉取最新代码

```bash
cd <actual_loaded_plugin_path>
git pull origin main
```

### 第三步：必要时更新注册的 SHA

```bash
git rev-parse HEAD
```

然后把新的 SHA 写回 `installed_plugins.json`。

### 第四步：如果你同时维护 `latest/`，顺手同步它

如果这两个路径同时存在：

```text
~/.claude/plugins/cache/superpowers-enhanced/latest
~/.claude/plugins/cache/superpowers-enhanced/superpowers/<version>
```

建议把另一份也同步一下，避免以后会话从错误路径加载旧 skill。

### 第五步：重启 Claude Code

## 9. 卸载

1. 删除插件缓存：

```bash
rm -rf ~/.claude/plugins/cache/superpowers-enhanced
rm -f ~/.claude/plugins/marketplaces/superpowers-enhanced
```

2. 删除这些文件中的相关条目：
- `~/.claude/plugins/installed_plugins.json`
- `~/.claude/settings.json` → `enabledPlugins`
- `~/.claude/plugins/known_marketplaces.json`

3. 重启 Claude Code。

## 10. 常见问题排查

### `/plugin install <git-url>` 报 “Marketplace not found”
有些 Claude Code 环境会把这个 URL 当作 marketplace 名称来解析，而不是 git 源。这种情况下请直接使用本说明里的手动安装方式。

### 技能加载了，但行为像旧版本
优先检查 `installed_plugins.json` 里记录的**实际加载路径**。如果你只更新了 `latest/`，但 Claude 实际加载的是 `superpowers/<version>`，那当前会话仍然会读到旧内容。

### 同时存在多个缓存路径
如果同时存在：

```text
~/.claude/plugins/cache/superpowers-enhanced/latest
~/.claude/plugins/cache/superpowers-enhanced/superpowers/<version>
```

Claude 可能只会加载其中一套。以 `installed_plugins.json` 为准。

### HTTPS clone 失败
如果 `git clone https://...` 在你的网络环境下失败，请先解决网络访问问题，再排查插件注册。

### 改完 JSON 后 Claude 启动异常
请仔细检查 JSON 语法。`settings.json`、`known_marketplaces.json`、`installed_plugins.json` 中只要少一个逗号或括号，都可能导致插件加载失败。

## 说明

- 本仓库里的增强 skill 数量，只统计 **repo-shipped workflow skills**。
- 安装、迁移、更新这类本地运维辅助 skill 如果存在于 `~/.claude/skills/`，它们不属于本仓库对外发布的一部分。
- 如果插件加载了但行为仍然不对，请优先检查 Claude 实际从哪套插件缓存路径读取内容。
