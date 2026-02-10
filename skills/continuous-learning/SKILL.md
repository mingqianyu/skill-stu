---
name: continuous-learning
description: Automatically extract reusable patterns from Claude Code sessions and save them as learned skills for future use.
---

<!-- 本技能：持续学习。在会话结束时自动从对话中抽取可复用模式并保存为“学习到的技能”。 -->

# Continuous Learning Skill

Automatically evaluates Claude Code sessions on end to extract reusable patterns that can be saved as learned skills.

<!-- 在每次会话结束时自动评估会话，抽取可复用模式并保存为技能。 -->

## How It Works

This skill runs as a **Stop hook** at the end of each session:

<!-- 本技能作为 Stop 钩子在会话结束时运行。 -->

1. **Session Evaluation**: Checks if session has enough messages (default: 10+)

   <!-- 会话评估：检查消息数是否达到阈值（默认 10+）。 -->

2. **Pattern Detection**: Identifies extractable patterns from the session

   <!-- 模式检测：从会话内容中识别可抽取的模式。 -->

3. **Skill Extraction**: Saves useful patterns to `~/.claude/skills/learned/`

   <!-- 技能抽取：将有用模式保存到 ~/.claude/skills/learned/。 -->

## Configuration

Edit `config.json` to customize:

<!-- 通过 config.json 自定义行为。 -->

```json
{
  "min_session_length": 10,
  "extraction_threshold": "medium",
  "auto_approve": false,
  "learned_skills_path": "~/.claude/skills/learned/",
  "patterns_to_detect": [
    "error_resolution",
    "user_corrections",
    "workarounds",
    "debugging_techniques",
    "project_specific"
  ],
  "ignore_patterns": [
    "simple_typos",
    "one_time_fixes",
    "external_api_issues"
  ]
}
```

<!-- min_session_length 最少消息数；extraction_threshold 提取严格程度；auto_approve 是否自动保存；patterns_to_detect 要检测的模式；ignore_patterns 要忽略的模式。 -->

## Pattern Types

| Pattern | Description |
|---------|-------------|
| `error_resolution` | How specific errors were resolved |
| `user_corrections` | Patterns from user corrections |
| `workarounds` | Solutions to framework/library quirks |
| `debugging_techniques` | Effective debugging approaches |
| `project_specific` | Project-specific conventions |

<!-- 表格：各模式含义——错误解决、用户纠正、变通方案、调试技巧、项目特定约定。 -->

## Hook Setup

<!-- 在 settings.json 的 hooks.Stop 里注册本脚本。 -->

Add to your `~/.claude/settings.json`:

```json
{
  "hooks": {
    "Stop": [{
      "matcher": "*",
      "hooks": [{
        "type": "command",
        "command": "~/.claude/skills/continuous-learning/evaluate-session.sh"
      }]
    }]
  }
}
```

## Why Stop Hook?

<!-- 为何用 Stop 而不是每条消息都跑：轻量、不阻塞、能拿到完整会话。 -->

- **Lightweight**: Runs once at session end

  <!-- 轻量：只在会话结束时跑一次。 -->

- **Non-blocking**: Doesn't add latency to every message

  <!-- 不阻塞：不会给每条消息增加延迟。 -->

- **Complete context**: Has access to full session transcript

  <!-- 完整上下文：能访问整段会话记录。 -->

## Related

<!-- 相关：Longform 文档中的持续学习章节、/learn 命令可在会话中手动抽取。 -->

- [The Longform Guide](https://x.com/affaanmustafa/status/2014040193557471352) - Section on continuous learning
- `/learn` command - Manual pattern extraction mid-session

---

## Comparison Notes (Research: Jan 2025)

<!-- 以下为调研笔记：与 Homunculus 的对比及 v2 改进方向。 -->

### vs Homunculus (github.com/humanplane/homunculus)

Homunculus v2 takes a more sophisticated approach:

<!-- Homunculus v2 用钩子观察、后台 Haiku 分析、原子 instinct、置信度与演化路径。 -->

| Feature | Our Approach | Homunculus v2 |
|---------|--------------|---------------|
| Observation | Stop hook (end of session) | PreToolUse/PostToolUse hooks (100% reliable) |
| Analysis | Main context | Background agent (Haiku) |
| Granularity | Full skills | Atomic "instincts" |
| Confidence | None | 0.3-0.9 weighted |
| Evolution | Direct to skill | Instincts → cluster → skill/command/agent |
| Sharing | None | Export/import instincts |

**Key insight from homunculus:**
> "v1 relied on skills to observe. Skills are probabilistic—they fire ~50-80% of the time. v2 uses hooks for observation (100% reliable) and instincts as the atomic unit of learned behavior."

<!-- 要点：v1 用 skill 观察不可靠；v2 用 hook 观察 100% 触发，用 instinct 作为最小学习单元。 -->

### Potential v2 Enhancements

<!-- 可能的 v2 增强：原子 instinct、后台观察者、置信度衰减、领域标签、聚类成 skill/command。 -->

1. **Instinct-based learning** - Smaller, atomic behaviors with confidence scoring
2. **Background observer** - Haiku agent analyzing in parallel
3. **Confidence decay** - Instincts lose confidence if contradicted
4. **Domain tagging** - code-style, testing, git, debugging, etc.
5. **Evolution path** - Cluster related instincts into skills/commands

See: `/Users/affoon/Documents/tasks/12-continuous-learning-v2.md` for full spec.
