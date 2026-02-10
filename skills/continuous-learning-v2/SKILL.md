---
name: continuous-learning-v2
description: Instinct-based learning system that observes sessions via hooks, creates atomic instincts with confidence scoring, and evolves them into skills/commands/agents.
version: 2.0.0
---

<!-- 本技能：持续学习 v2。基于“本能(instinct)”的学习：用钩子观察会话、生成带置信度的原子行为、再聚类为 skill/command/agent。 -->

# Continuous Learning v2 - Instinct-Based Architecture

An advanced learning system that turns your Claude Code sessions into reusable knowledge through atomic "instincts" - small learned behaviors with confidence scoring.

<!-- 将会话转化为可复用知识：原子“本能”+ 置信度。 -->

## What's New in v2

<!-- v2 新特性：钩子观察、后台 Haiku 分析、原子 instinct、置信度、演化与分享。 -->

| Feature | v1 | v2 |
|---------|----|----|
| Observation | Stop hook (session end) | PreToolUse/PostToolUse (100% reliable) |
| Analysis | Main context | Background agent (Haiku) |
| Granularity | Full skills | Atomic "instincts" |
| Confidence | None | 0.3-0.9 weighted |
| Evolution | Direct to skill | Instincts → cluster → skill/command/agent |
| Sharing | None | Export/import instincts |

## The Instinct Model

An instinct is a small learned behavior:

<!-- 本能：一个触发条件 + 一个动作，带置信度与领域标签。 -->

```yaml
---
id: prefer-functional-style
trigger: "when writing new functions"
confidence: 0.7
domain: "code-style"
source: "session-observation"
---

# Prefer Functional Style

## Action
Use functional patterns over classes when appropriate.

## Evidence
- Observed 5 instances of functional pattern preference
- User corrected class-based approach to functional on 2025-01-15
```

**Properties:**
- **Atomic** — one trigger, one action

  <!-- 原子：一个触发、一个动作。 -->

- **Confidence-weighted** — 0.3 = tentative, 0.9 = near certain

  <!-- 置信度：0.3 试探、0.9 近乎确定。 -->

- **Domain-tagged** — code-style, testing, git, debugging, workflow, etc.

  <!-- 领域标签：便于筛选与聚类。 -->

- **Evidence-backed** — tracks what observations created it

  <!-- 有证据：记录哪些观察生成了该本能。 -->

## How It Works

<!-- 流程：钩子写入 observations → 观察者分析 → 生成/更新 instincts → /evolve 聚类到 evolved/。 -->

```
Session Activity
      │
      │ Hooks capture prompts + tool use (100% reliable)
      ▼
┌─────────────────────────────────────────┐
│         observations.jsonl              │
│   (prompts, tool calls, outcomes)       │
└─────────────────────────────────────────┘
      │
      │ Observer agent reads (background, Haiku)
      ▼
┌─────────────────────────────────────────┐
│          PATTERN DETECTION              │
│   • User corrections → instinct         │
│   • Error resolutions → instinct        │
│   • Repeated workflows → instinct       │
└─────────────────────────────────────────┘
      │
      │ Creates/updates
      ▼
┌─────────────────────────────────────────┐
│         instincts/personal/             │
│   • prefer-functional.md (0.7)          │
│   • always-test-first.md (0.9)          │
│   • use-zod-validation.md (0.6)         │
└─────────────────────────────────────────┘
      │
      │ /evolve clusters
      ▼
┌─────────────────────────────────────────┐
│              evolved/                   │
│   • commands/new-feature.md             │
│   • skills/testing-workflow.md          │
│   • agents/refactor-specialist.md       │
└─────────────────────────────────────────┘
```

## Quick Start

### 1. Enable Observation Hooks

<!-- 在 settings.json 中配置 PreToolUse/PostToolUse 调用 observe.sh。 -->

Add to your `~/.claude/settings.json`.

**If installed as a plugin** (recommended):

```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "*",
      "hooks": [{
        "type": "command",
        "command": "${CLAUDE_PLUGIN_ROOT}/skills/continuous-learning-v2/hooks/observe.sh pre"
      }]
    }],
    "PostToolUse": [{
      "matcher": "*",
      "hooks": [{
        "type": "command",
        "command": "${CLAUDE_PLUGIN_ROOT}/skills/continuous-learning-v2/hooks/observe.sh post"
      }]
    }]
  }
}
```

**If installed manually** to `~/.claude/skills`:

```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "*",
      "hooks": [{
        "type": "command",
        "command": "~/.claude/skills/continuous-learning-v2/hooks/observe.sh pre"
      }]
    }],
    "PostToolUse": [{
      "matcher": "*",
      "hooks": [{
        "type": "command",
        "command": "~/.claude/skills/continuous-learning-v2/hooks/observe.sh post"
      }]
    }]
  }
}
```

### 2. Initialize Directory Structure

The Python CLI will create these automatically, but you can also create them manually:

<!-- 手动创建 homunculus 目录：observations.jsonl、instincts/personal|inherited、evolved/agents|skills|commands。 -->

```bash
mkdir -p ~/.claude/homunculus/{instincts/{personal,inherited},evolved/{agents,skills,commands}}
touch ~/.claude/homunculus/observations.jsonl
```

### 3. Use the Instinct Commands

<!-- 常用命令：状态、演化、导出、导入。 -->

```bash
/instinct-status     # Show learned instincts with confidence scores
/evolve              # Cluster related instincts into skills/commands
/instinct-export     # Export instincts for sharing
/instinct-import     # Import instincts from others
```

## Commands

| Command | Description |
|---------|-------------|
| `/instinct-status` | Show all learned instincts with confidence |
| `/evolve` | Cluster related instincts into skills/commands |
| `/instinct-export` | Export instincts for sharing |
| `/instinct-import <file>` | Import instincts from others |

## Configuration

Edit `config.json`:

<!-- observation 观察存储与归档；instincts 路径与置信度；observer 后台分析；evolution 聚类与输出路径。 -->

```json
{
  "version": "2.0",
  "observation": {
    "enabled": true,
    "store_path": "~/.claude/homunculus/observations.jsonl",
    "max_file_size_mb": 10,
    "archive_after_days": 7
  },
  "instincts": {
    "personal_path": "~/.claude/homunculus/instincts/personal/",
    "inherited_path": "~/.claude/homunculus/instincts/inherited/",
    "min_confidence": 0.3,
    "auto_approve_threshold": 0.7,
    "confidence_decay_rate": 0.05
  },
  "observer": {
    "enabled": true,
    "model": "haiku",
    "run_interval_minutes": 5,
    "patterns_to_detect": [
      "user_corrections",
      "error_resolutions",
      "repeated_workflows",
      "tool_preferences"
    ]
  },
  "evolution": {
    "cluster_threshold": 3,
    "evolved_path": "~/.claude/homunculus/evolved/"
  }
}
```

## File Structure

<!-- homunculus 目录下：identity、observations、instincts、evolved。 -->

```
~/.claude/homunculus/
├── identity.json           # Your profile, technical level
├── observations.jsonl      # Current session observations
├── observations.archive/   # Processed observations
├── instincts/
│   ├── personal/           # Auto-learned instincts
│   └── inherited/          # Imported from others
└── evolved/
    ├── agents/             # Generated specialist agents
    ├── skills/             # Generated skills
    └── commands/           # Generated commands
```

## Integration with Skill Creator

<!-- Skill Creator 可同时生成 SKILL.md 与 instinct 集合；repo 分析得到的 instinct 带 source_repo。 -->

When you use the [Skill Creator GitHub App](https://skill-creator.app), it now generates **both**:
- Traditional SKILL.md files (for backward compatibility)
- Instinct collections (for v2 learning system)

Instincts from repo analysis have `source: "repo-analysis"` and include the source repository URL.

## Confidence Scoring

Confidence evolves over time:

<!-- 置信度随观察与纠正动态变化；高于 auto_approve_threshold 可自动应用。 -->

| Score | Meaning | Behavior |
|-------|---------|----------|
| 0.3 | Tentative | Suggested but not enforced |
| 0.5 | Moderate | Applied when relevant |
| 0.7 | Strong | Auto-approved for application |
| 0.9 | Near-certain | Core behavior |

**Confidence increases** when:
- Pattern is repeatedly observed
- User doesn't correct the suggested behavior
- Similar instincts from other sources agree

**Confidence decreases** when:
- User explicitly corrects the behavior
- Pattern isn't observed for extended periods
- Contradicting evidence appears

## Why Hooks vs Skills for Observation?

<!-- 用钩子观察：100% 触发，不依赖 skill 是否被选中。 -->

> "v1 relied on skills to observe. Skills are probabilistic—they fire ~50-80% of the time based on Claude's judgment."

Hooks fire **100% of the time**, deterministically. This means:
- Every tool call is observed
- No patterns are missed
- Learning is comprehensive

## Backward Compatibility

<!-- v1 的 learned/ 与 Stop 钩子仍可用，可与 v2 并行。 -->

v2 is fully compatible with v1:
- Existing `~/.claude/skills/learned/` skills still work
- Stop hook still runs (but now also feeds into v2)
- Gradual migration path: run both in parallel

## Privacy

<!-- 观察数据仅本地；导出的是模式(instinct)，不含代码或对话内容。 -->

- Observations stay **local** on your machine
- Only **instincts** (patterns) can be exported
- No actual code or conversation content is shared
- You control what gets exported

## Related

- [Skill Creator](https://skill-creator.app) - Generate instincts from repo history
- [Homunculus](https://github.com/humanplane/homunculus) - Inspiration for v2 architecture
- [The Longform Guide](https://x.com/affaanmustafa/status/2014040193557471352) - Continuous learning section

---

*Instinct-based learning: teaching Claude your patterns, one observation at a time.*

<!-- 本能学习：通过每次观察，一点一点教会 Claude 你的习惯。 -->
