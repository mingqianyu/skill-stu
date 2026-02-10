#!/bin/bash
# Continuous Learning - Session Evaluator
# Runs on Stop hook to extract reusable patterns from Claude Code sessions
#
# 中文：持续学习 - 会话评估脚本。在 Stop 钩子中运行，从 Claude Code 会话中抽取可复用模式。
#
# Why Stop hook instead of UserPromptSubmit:
# - Stop runs once at session end (lightweight)
# - UserPromptSubmit runs every message (heavy, adds latency)
#
# 为何用 Stop：只在会话结束跑一次（轻量）；UserPromptSubmit 每条消息都跑（重、增加延迟）。
#
# Hook config (in ~/.claude/settings.json):
# {
#   "hooks": {
#     "Stop": [{
#       "matcher": "*",
#       "hooks": [{
#         "type": "command",
#         "command": "~/.claude/skills/continuous-learning/evaluate-session.sh"
#       }]
#     }]
#   }
# }
#
# Patterns to detect: error_resolution, debugging_techniques, workarounds, project_specific
# Patterns to ignore: simple_typos, one_time_fixes, external_api_issues
# Extracted skills saved to: ~/.claude/skills/learned/

set -e

# 脚本所在目录、配置文件路径、学习技能输出目录、最少消息数
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/config.json"
LEARNED_SKILLS_PATH="${HOME}/.claude/skills/learned"
MIN_SESSION_LENGTH=10

# Load config if exists
# 若存在 config.json 则从中读取 min_session_length 与 learned_skills_path（~ 展开为 $HOME）
if [ -f "$CONFIG_FILE" ]; then
  MIN_SESSION_LENGTH=$(jq -r '.min_session_length // 10' "$CONFIG_FILE")
  LEARNED_SKILLS_PATH=$(jq -r '.learned_skills_path // "~/.claude/skills/learned/"' "$CONFIG_FILE" | sed "s|~|$HOME|")
fi

# Ensure learned skills directory exists
# 确保学习技能目录存在
mkdir -p "$LEARNED_SKILLS_PATH"

# Get transcript path from environment (set by Claude Code)
# 从环境变量获取会话记录路径（由 Claude Code 设置）
transcript_path="${CLAUDE_TRANSCRIPT_PATH:-}"

if [ -z "$transcript_path" ] || [ ! -f "$transcript_path" ]; then
  exit 0
fi

# Count messages in session
# 统计会话中 type 为 user 的消息条数
message_count=$(grep -c '"type":"user"' "$transcript_path" 2>/dev/null || echo "0")

# Skip short sessions
# 消息数不足则跳过，不进行评估
if [ "$message_count" -lt "$MIN_SESSION_LENGTH" ]; then
  echo "[ContinuousLearning] Session too short ($message_count messages), skipping" >&2
  exit 0
fi

# Signal to Claude that session should be evaluated for extractable patterns
# 输出提示：会话足够长，应评估并抽取模式；学习技能保存路径
echo "[ContinuousLearning] Session has $message_count messages - evaluate for extractable patterns" >&2
echo "[ContinuousLearning] Save learned skills to: $LEARNED_SKILLS_PATH" >&2
