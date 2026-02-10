---
name: instinct-export
description: Export instincts for sharing with teammates or other projects
command: /instinct-export
---

<!-- frontmatter：命令名 instinct-export；描述为导出直觉以便分享。 -->

# Instinct Export Command

<!-- 标题：直觉导出命令。对应 /instinct-export。 -->

Exports instincts to a shareable format. Perfect for:

<!-- 上面：把直觉导出成可分享的格式，适合下面三种场景。 -->

- Sharing with teammates

  <!-- 和队友共享（团队统一习惯）。 -->

- Transferring to a new machine

  <!-- 换机器时把已学习的直觉迁过去。 -->

- Contributing to project conventions

  <!-- 把项目约定以直觉形式贡献给仓库。 -->

## Usage

<!-- 小节：用法。 -->

```
/instinct-export                           # Export all personal instincts
/instinct-export --domain testing          # Export only testing instincts
/instinct-export --min-confidence 0.7      # Only export high-confidence instincts
/instinct-export --output team-instincts.yaml
```

<!-- 上面：无参数导出全部个人直觉；--domain 只导出某领域；--min-confidence 只导出不低于某置信度的；--output 指定输出文件。 -->

## What to Do

<!-- 小节：执行步骤。 -->

1. Read instincts from `~/.claude/homunculus/instincts/personal/`

   <!-- 第 1 步：从 personal 目录读取所有个人直觉。 -->

2. Filter based on flags

   <!-- 第 2 步：按命令行参数过滤（领域、置信度等）。 -->

3. Strip sensitive information:

   <!-- 第 3 步：脱敏，去掉敏感信息再导出。 -->

   - Remove session IDs

     <!-- 去掉会话 ID，避免暴露具体对话。 -->

   - Remove file paths (keep only patterns)

     <!-- 去掉具体文件路径，只保留模式（如“*.go”）。 -->

   - Remove timestamps older than "last week"

     <!-- 去掉“上周以前”的时间戳，减少可关联信息。 -->

4. Generate export file

   <!-- 第 4 步：生成导出文件（YAML/JSON 等）。 -->

## Output Format

<!-- 小节：输出格式。默认生成 YAML 文件。 -->

Creates a YAML file:

```yaml
# Instincts Export
# Generated: 2025-01-22
# Source: personal
# Count: 12 instincts

version: "2.0"
exported_by: "continuous-learning-v2"
export_date: "2025-01-22T10:30:00Z"

instincts:
  - id: prefer-functional-style
    trigger: "when writing new functions"
    action: "Use functional patterns over classes"
    confidence: 0.8
    domain: code-style
    observations: 8

  - id: test-first-workflow
    trigger: "when adding new functionality"
    action: "Write test first, then implementation"
    confidence: 0.9
    domain: testing
    observations: 12

  - id: grep-before-edit
    trigger: "when modifying code"
    action: "Search with Grep, confirm with Read, then Edit"
    confidence: 0.7
    domain: workflow
    observations: 6
```

## Privacy Considerations

<!-- 小节：隐私与脱敏。导出里包含/不包含什么。 -->

Exports include:

<!-- 导出会包含（可安全分享）： -->

- ✅ Trigger patterns

  <!-- 触发模式（如“when writing new functions”）。 -->

- ✅ Actions

  <!-- 动作描述（如“Use functional patterns”）。 -->

- ✅ Confidence scores

  <!-- 置信度分数。 -->

- ✅ Domains

  <!-- 所属领域。 -->

- ✅ Observation counts

  <!-- 观测次数（用于置信度计算）。 -->

Exports do NOT include:

<!-- 导出不会包含（避免泄露）： -->

- ❌ Actual code snippets

  <!-- 真实代码片段。 -->

- ❌ File paths

  <!-- 本机文件路径。 -->

- ❌ Session transcripts

  <!-- 会话原文。 -->

- ❌ Personal identifiers

  <!-- 个人标识信息。 -->

## Flags

<!-- 小节：参数。 -->

- `--domain <name>`: Export only specified domain

  <!-- 只导出指定领域。 -->

- `--min-confidence <n>`: Minimum confidence threshold (default: 0.3)

  <!-- 最低置信度，低于此的不导出，默认 0.3。 -->

- `--output <file>`: Output file path (default: instincts-export-YYYYMMDD.yaml)

  <!-- 输出文件路径，默认带日期。 -->

- `--format <yaml|json|md>`: Output format (default: yaml)

  <!-- 输出格式：yaml/json/md。 -->

- `--include-evidence`: Include evidence text (default: excluded)

  <!-- 是否包含“证据”原文，默认不包含。 -->
