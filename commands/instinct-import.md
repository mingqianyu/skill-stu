---
name: instinct-import
description: Import instincts from teammates, Skill Creator, or other sources
command: true
---

<!-- frontmatter：命令名 instinct-import；从队友、Skill Creator 或其它来源导入直觉。 -->

# Instinct Import Command

<!-- 标题：直觉导入命令。对应 /instinct-import。 -->

## Implementation

<!-- 小节：实现方式。调用 continuous-learning-v2 的 Python 脚本，传入文件或 URL。 -->

Run the instinct CLI using the plugin root path:

```bash
python3 "${CLAUDE_PLUGIN_ROOT}/skills/continuous-learning-v2/scripts/instinct-cli.py" import <file-or-url> [--dry-run] [--force] [--min-confidence 0.7]
```

<!-- 上面：import 子命令；file-or-url 为本地路径或 URL；--dry-run 只预览不写入；--force 覆盖冲突；--min-confidence 只导入不低于某置信度的。 -->

Or if `CLAUDE_PLUGIN_ROOT` is not set (manual installation):

```bash
python3 ~/.claude/skills/continuous-learning-v2/scripts/instinct-cli.py import <file-or-url>
```

Import instincts from:

<!-- 导入来源可以是： -->

- Teammates' exports

  <!-- 队友用 /instinct-export 导出的文件。 -->

- Skill Creator (repo analysis)

  <!-- Skill Creator 对仓库分析产出的直觉。 -->

- Community collections

  <!-- 社区分享的直觉集合。 -->

- Previous machine backups

  <!-- 自己之前在其他机器上的导出备份。 -->

## Usage

<!-- 小节：用法示例。 -->

```
/instinct-import team-instincts.yaml
/instinct-import https://github.com/org/repo/instincts.yaml
/instinct-import --from-skill-creator acme/webapp
```

<!-- 上面：本地文件、远程 URL、或从 Skill Creator 指定 org/repo 导入。 -->

## What to Do

<!-- 小节：执行步骤。 -->

1. Fetch the instinct file (local path or URL)

   <!-- 第 1 步：获取直觉文件（读本地或下载 URL）。 -->

2. Parse and validate the format

   <!-- 第 2 步：解析并校验格式（YAML/JSON 等）。 -->

3. Check for duplicates with existing instincts

   <!-- 第 3 步：和已有直觉比对，找出重复或冲突。 -->

4. Merge or add new instincts

   <!-- 第 4 步：合并或新增（按策略：保留高置信度、或询问用户）。 -->

5. Save to `~/.claude/homunculus/instincts/inherited/`

   <!-- 第 5 步：写入 inherited 目录，与 personal 区分。 -->

## Import Process

```
📥 Importing instincts from: team-instincts.yaml
================================================

Found 12 instincts to import.

Analyzing conflicts...

## New Instincts (8)
These will be added:
  ✓ use-zod-validation (confidence: 0.7)
  ✓ prefer-named-exports (confidence: 0.65)
  ✓ test-async-functions (confidence: 0.8)
  ...

## Duplicate Instincts (3)
Already have similar instincts:
  ⚠️ prefer-functional-style
     Local: 0.8 confidence, 12 observations
     Import: 0.7 confidence
     → Keep local (higher confidence)

  ⚠️ test-first-workflow
     Local: 0.75 confidence
     Import: 0.9 confidence
     → Update to import (higher confidence)

## Conflicting Instincts (1)
These contradict local instincts:
  ❌ use-classes-for-services
     Conflicts with: avoid-classes
     → Skip (requires manual resolution)

---
Import 8 new, update 1, skip 3?
```

## Merge Strategies

### For Duplicates
When importing an instinct that matches an existing one:
- **Higher confidence wins**: Keep the one with higher confidence
- **Merge evidence**: Combine observation counts
- **Update timestamp**: Mark as recently validated

### For Conflicts
When importing an instinct that contradicts an existing one:
- **Skip by default**: Don't import conflicting instincts
- **Flag for review**: Mark both as needing attention
- **Manual resolution**: User decides which to keep

## Source Tracking

Imported instincts are marked with:
```yaml
source: "inherited"
imported_from: "team-instincts.yaml"
imported_at: "2025-01-22T10:30:00Z"
original_source: "session-observation"  # or "repo-analysis"
```

## Skill Creator Integration

When importing from Skill Creator:

```
/instinct-import --from-skill-creator acme/webapp
```

This fetches instincts generated from repo analysis:
- Source: `repo-analysis`
- Higher initial confidence (0.7+)
- Linked to source repository

## Flags

- `--dry-run`: Preview without importing
- `--force`: Import even if conflicts exist
- `--merge-strategy <higher|local|import>`: How to handle duplicates
- `--from-skill-creator <owner/repo>`: Import from Skill Creator analysis
- `--min-confidence <n>`: Only import instincts above threshold

## Output

After import:
```
✅ Import complete!

Added: 8 instincts
Updated: 1 instinct
Skipped: 3 instincts (2 duplicates, 1 conflict)

New instincts saved to: ~/.claude/homunculus/instincts/inherited/

Run /instinct-status to see all instincts.
```
