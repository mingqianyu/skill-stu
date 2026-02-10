#!/bin/bash
# Continuous Learning v2 - Observer Agent Launcher
#
# 中文：启动后台观察者 agent，分析 observations 并生成 instinct；使用 Haiku 控制成本。
#
# Starts the background observer agent that analyzes observations
# and creates instincts. Uses Haiku model for cost efficiency.
#
# Usage:
#   start-observer.sh        # Start observer in background
#   start-observer.sh stop   # Stop running observer
#   start-observer.sh status # Check if observer is running

set -e

# 配置目录、PID 文件、日志与观察记录路径
CONFIG_DIR="${HOME}/.claude/homunculus"
PID_FILE="${CONFIG_DIR}/.observer.pid"
LOG_FILE="${CONFIG_DIR}/observer.log"
OBSERVATIONS_FILE="${CONFIG_DIR}/observations.jsonl"

mkdir -p "$CONFIG_DIR"

case "${1:-start}" in
  stop)
    # 若有 PID 文件则尝试 kill 并删除 PID 文件；否则报未运行
    if [ -f "$PID_FILE" ]; then
      pid=$(cat "$PID_FILE")
      if kill -0 "$pid" 2>/dev/null; then
        echo "Stopping observer (PID: $pid)..."
        kill "$pid"
        rm -f "$PID_FILE"
        echo "Observer stopped."
      else
        echo "Observer not running (stale PID file)."
        rm -f "$PID_FILE"
      fi
    else
      echo "Observer not running."
    fi
    exit 0
    ;;

  status)
    # 检查 PID 是否存活，并显示观察记录行数
    if [ -f "$PID_FILE" ]; then
      pid=$(cat "$PID_FILE")
      if kill -0 "$pid" 2>/dev/null; then
        echo "Observer is running (PID: $pid)"
        echo "Log: $LOG_FILE"
        echo "Observations: $(wc -l < "$OBSERVATIONS_FILE" 2>/dev/null || echo 0) lines"
        exit 0
      else
        echo "Observer not running (stale PID file)"
        rm -f "$PID_FILE"
        exit 1
      fi
    else
      echo "Observer not running"
      exit 1
    fi
    ;;

  start)
    # 若已有 PID 且进程存在则直接退出；否则清除旧 PID 文件
    if [ -f "$PID_FILE" ]; then
      pid=$(cat "$PID_FILE")
      if kill -0 "$pid" 2>/dev/null; then
        echo "Observer already running (PID: $pid)"
        exit 0
      fi
      rm -f "$PID_FILE"
    fi

    echo "Starting observer agent..."

    # 后台循环：每 5 分钟或收到 SIGUSR1 时分析观察记录
    (
      trap 'rm -f "$PID_FILE"; exit 0' TERM INT

      analyze_observations() {
        # 观察条数不足则不分析
        obs_count=$(wc -l < "$OBSERVATIONS_FILE" 2>/dev/null || echo 0)
        if [ "$obs_count" -lt 10 ]; then
          return
        fi

        echo "[$(date)] Analyzing $obs_count observations..." >> "$LOG_FILE"

        # 若有 claude 命令则用 Haiku 做一次简短分析，按 observer 规范写 instinct
        if command -v claude &> /dev/null; then
          claude --model haiku --max-turns 3 --print \
            "Read $OBSERVATIONS_FILE and identify patterns. If you find 3+ occurrences of the same pattern, create an instinct file in $CONFIG_DIR/instincts/personal/ following the format in the observer agent spec. Be conservative - only create instincts for clear patterns." \
            >> "$LOG_FILE" 2>&1 || true
        fi

        # 分析后将当前 observations 移到归档目录并清空当前文件
        if [ -f "$OBSERVATIONS_FILE" ]; then
          archive_dir="${CONFIG_DIR}/observations.archive"
          mkdir -p "$archive_dir"
          mv "$OBSERVATIONS_FILE" "$archive_dir/processed-$(date +%Y%m%d-%H%M%S).jsonl"
          touch "$OBSERVATIONS_FILE"
        fi
      }

      # SIGUSR1 触发立即分析（由 observe.sh 在写入新观察后发送）
      trap 'analyze_observations' USR1

      echo "$$" > "$PID_FILE"
      echo "[$(date)] Observer started (PID: $$)" >> "$LOG_FILE"

      while true; do
        # 每 5 分钟执行一次分析
        sleep 300

        analyze_observations
      done
    ) &

    disown

    # Wait a moment for PID file
    sleep 1

    if [ -f "$PID_FILE" ]; then
      echo "Observer started (PID: $(cat "$PID_FILE"))"
      echo "Log: $LOG_FILE"
    else
      echo "Failed to start observer"
      exit 1
    fi
    ;;

  *)
    echo "Usage: $0 {start|stop|status}"
    exit 1
    ;;
esac
