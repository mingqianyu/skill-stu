---
name: instinct-status
description: Show all learned instincts with their confidence levels
command: true
---

<!-- frontmatter：命令名 instinct-status；描述为展示所学直觉及置信度；command: true 表示由插件执行。 -->

# Instinct Status Command

<!-- 标题：直觉状态命令。对应 /instinct-status。 -->

Shows all learned instincts with their confidence scores, grouped by domain.

<!-- 上面：显示 continuous-learning-v2 学到的所有“直觉”及其置信度，按领域（如 code-style、testing）分组。 -->

## Implementation

<!-- 小节：实现方式。实际是调 continuous-learning-v2 里的 Python 脚本。 -->

Run the instinct CLI using the plugin root path:

<!-- 若以插件安装，用环境变量 CLAUDE_PLUGIN_ROOT 指向插件根目录，再调 scripts 下的 instinct-cli.py。 -->

```bash
python3 "${CLAUDE_PLUGIN_ROOT}/skills/continuous-learning-v2/scripts/instinct-cli.py" status
```

Or if `CLAUDE_PLUGIN_ROOT` is not set (manual installation), use:

<!-- 若未设置（如手动复制技能到 ~/.claude），则用用户目录下的路径。 -->

```bash
python3 ~/.claude/skills/continuous-learning-v2/scripts/instinct-cli.py status
```

## Usage

<!-- 小节：用法示例。 -->

```
/instinct-status
/instinct-status --domain code-style
/instinct-status --low-confidence
```

<!-- 上面：无参数列出全部；--domain 只显示某领域；--low-confidence 只显示低置信度（便于排查或清理）。 -->

## What to Do

<!-- 小节：执行时做哪几步。 -->

1. Read all instinct files from `~/.claude/homunculus/instincts/personal/`

   <!-- 第 1 步：从 personal 目录读取“本机从会话中学到”的直觉文件。 -->

2. Read inherited instincts from `~/.claude/homunculus/instincts/inherited/`

   <!-- 第 2 步：从 inherited 目录读取“从他人/团队导入”的直觉。 -->

3. Display them grouped by domain with confidence bars

   <!-- 第 3 步：按领域分组展示，每条带置信度条（如 ████████░░ 80%）。 -->

## Output Format

```
📊 Instinct Status
==================

## Code Style (4 instincts)

### prefer-functional-style
Trigger: when writing new functions
Action: Use functional patterns over classes
Confidence: ████████░░ 80%
Source: session-observation | Last updated: 2025-01-22

### use-path-aliases
Trigger: when importing modules
Action: Use @/ path aliases instead of relative imports
Confidence: ██████░░░░ 60%
Source: repo-analysis (github.com/acme/webapp)

## Testing (2 instincts)

### test-first-workflow
Trigger: when adding new functionality
Action: Write test first, then implementation
Confidence: █████████░ 90%
Source: session-observation

## Workflow (3 instincts)

### grep-before-edit
Trigger: when modifying code
Action: Search with Grep, confirm with Read, then Edit
Confidence: ███████░░░ 70%
Source: session-observation

---
Total: 9 instincts (4 personal, 5 inherited)
Observer: Running (last analysis: 5 min ago)
```

<!-- 上面示例：每个直觉有名称、Trigger（何时触发）、Action（做什么）、Confidence 条、Source、最后更新；底部为总数与 Observer 状态。 -->

## Flags

<!-- 小节：命令行参数。 -->

- `--domain <name>`: Filter by domain (code-style, testing, git, etc.)

  <!-- 只显示指定领域的直觉。 -->

- `--low-confidence`: Show only instincts with confidence < 0.5

  <!-- 只显示低置信度（&lt; 0.5）的，便于检查或清理。 -->

- `--high-confidence`: Show only instincts with confidence >= 0.7

  <!-- 只显示高置信度（≥ 0.7）的。 -->

- `--source <type>`: Filter by source (session-observation, repo-analysis, inherited)

  <!-- 按来源过滤：会话观察、仓库分析、继承导入。 -->

- `--json`: Output as JSON for programmatic use

  <!-- 以 JSON 输出，便于脚本或工具消费。 -->
