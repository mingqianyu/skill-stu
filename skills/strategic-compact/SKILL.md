---
name: strategic-compact
description: Suggests manual context compaction at logical intervals to preserve context through task phases rather than arbitrary auto-compaction.
---

<!-- 本技能：策略性压缩。在任务阶段边界建议手动 /compact，避免在任务中途被自动压缩丢失上下文。 -->

# Strategic Compact Skill

Suggests manual `/compact` at strategic points in your workflow rather than relying on arbitrary auto-compaction.

<!-- 在流程中的策略节点建议手动压缩，而非依赖任意时机自动压缩。 -->

## Why Strategic Compaction?

<!-- 自动压缩常在任务中途触发；策略压缩在“探索后执行前”“里程碑后”“大任务切换前”建议。 -->

Auto-compaction triggers at arbitrary points:
- Often mid-task, losing important context
- No awareness of logical task boundaries
- Can interrupt complex multi-step operations

Strategic compaction at logical boundaries:
- **After exploration, before execution** - Compact research context, keep implementation plan
- **After completing a milestone** - Fresh start for next phase
- **Before major context shifts** - Clear exploration context before different task

## How It Works

The `suggest-compact.sh` script runs on PreToolUse (Edit/Write) and:

<!-- suggest-compact.sh 在 PreToolUse 时统计工具调用次数，达到阈值后输出建议。 -->

1. **Tracks tool calls** - Counts tool invocations in session
2. **Threshold detection** - Suggests at configurable threshold (default: 50 calls)
3. **Periodic reminders** - Reminds every 25 calls after threshold

## Hook Setup

Add to your `~/.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "tool == \"Edit\" || tool == \"Write\"",
      "hooks": [{
        "type": "command",
        "command": "~/.claude/skills/strategic-compact/suggest-compact.sh"
      }]
    }]
  }
}
```

## Configuration

Environment variables:
- `COMPACT_THRESHOLD` - Tool calls before first suggestion (default: 50)

## Best Practices

<!-- 规划后、调试后可压缩；实现中不压缩；由你决定是否执行。 -->

1. **Compact after planning** - Once plan is finalized, compact to start fresh
2. **Compact after debugging** - Clear error-resolution context before continuing
3. **Don't compact mid-implementation** - Preserve context for related changes
4. **Read the suggestion** - The hook tells you *when*, you decide *if*

## Related

- [The Longform Guide](https://x.com/affaanmustafa/status/2014040193557471352) - Token optimization section
- Memory persistence hooks - For state that survives compaction
