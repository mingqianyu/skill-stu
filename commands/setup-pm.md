---
description: Configure your preferred package manager (npm/pnpm/yarn/bun)
disable-model-invocation: true
---

<!-- frontmatter：description 为配置包管理器偏好；disable-model-invocation: true 表示执行此命令时不唤醒模型，直接跑脚本。 -->

# Package Manager Setup

<!-- 标题：包管理器设置。对应 /setup-pm。 -->

Configure your preferred package manager for this project or globally.

<!-- 上面：为“当前项目”或“全局”配置你想用的包管理器（npm/pnpm/yarn/bun）。 -->

## Usage

<!-- 小节：用法。下面都是调用仓库里的 scripts/setup-package-manager.js。 -->

```bash
# Detect current package manager
node scripts/setup-package-manager.js --detect

# Set global preference
node scripts/setup-package-manager.js --global pnpm

# Set project preference
node scripts/setup-package-manager.js --project bun

# List available package managers
node scripts/setup-package-manager.js --list
```

<!-- 上面：--detect 检测当前用的是哪个包管理器；--global 设全局偏好；--project 设当前项目偏好；--list 列出本机已安装的包管理器。 -->

## Detection Priority

<!-- 小节：检测优先级。脚本决定“用哪个包管理器”时，按下面顺序查，先命中先赢。 -->

When determining which package manager to use, the following order is checked:

1. **Environment variable**: `CLAUDE_PACKAGE_MANAGER`

   <!-- 第 1 优先：环境变量 CLAUDE_PACKAGE_MANAGER（若已设置则直接用）。 -->

2. **Project config**: `.claude/package-manager.json`

   <!-- 第 2 优先：项目根目录下 .claude/package-manager.json 里的 packageManager。 -->

3. **package.json**: `packageManager` field

   <!-- 第 3 优先：package.json 里的 packageManager 字段（如 "pnpm@8.6.0"）。 -->

4. **Lock file**: Presence of package-lock.json, yarn.lock, pnpm-lock.yaml, or bun.lockb

   <!-- 第 4 优先：根据锁文件推断（存在哪个锁文件就用对应管理器）。 -->

5. **Global config**: `~/.claude/package-manager.json`

   <!-- 第 5 优先：用户主目录下的全局配置。 -->

6. **Fallback**: First available package manager (pnpm > bun > yarn > npm)

   <!-- 第 6 回退：若以上都无，按 pnpm > bun > yarn > npm 顺序选第一个本机已安装的。 -->

## Configuration Files

<!-- 小节：配置文件。包管理器偏好可写在这三类地方。 -->

### Global Configuration

<!-- 全局配置：对所有项目生效（除非被项目级或环境变量覆盖）。 -->

```json
// ~/.claude/package-manager.json
{
  "packageManager": "pnpm"
}
```

<!-- 上面：在用户目录 .claude 下放 package-manager.json，写 packageManager 即可。 -->

### Project Configuration

<!-- 项目配置：只对当前项目生效。 -->

```json
// .claude/package-manager.json
{
  "packageManager": "bun"
}
```

<!-- 上面：在项目根目录 .claude/ 下放 package-manager.json。 -->

### package.json

<!-- 也可在 package.json 里用 packageManager 字段（Node 规范）。 -->

```json
{
  "packageManager": "pnpm@8.6.0"
}
```

<!-- 上面：可带版本号，用于锁定包管理器版本。 -->

## Environment Variable

<!-- 小节：环境变量。设了则覆盖上面所有配置文件。 -->

Set `CLAUDE_PACKAGE_MANAGER` to override all other detection methods:

<!-- 设置 CLAUDE_PACKAGE_MANAGER 后，会覆盖其他所有检测方式，直接使用该值。 -->

```bash
# Windows (PowerShell)
$env:CLAUDE_PACKAGE_MANAGER = "pnpm"

# macOS/Linux
export CLAUDE_PACKAGE_MANAGER=pnpm
```

<!-- 上面：Windows 用 PowerShell 设环境变量；macOS/Linux 用 export。 -->

## Run the Detection

<!-- 小节：运行检测。想看当前会选哪个包管理器时执行。 -->

To see current package manager detection results, run:

<!-- 要查看当前检测结果（按优先级最终选了谁），运行下面命令。 -->

```bash
node scripts/setup-package-manager.js --detect
```
