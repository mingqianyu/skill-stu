<!-- 本文件：钩子系统说明。介绍 PreToolUse/PostToolUse/Stop 三类钩子、当前配置示例、自动通过权限的注意点、以及 TodoWrite 的使用建议。 -->

# Hooks System

## Hook Types

<!-- 三类钩子：工具执行前（校验、改参数）、工具执行后（格式化、检查）、会话结束（最终检查）。 -->
- **PreToolUse**: Before tool execution (validation, parameter modification)
- **PostToolUse**: After tool execution (auto-format, checks)
- **Stop**: When session ends (final verification)

## Current Hooks (in ~/.claude/settings.json)

<!-- 以下为当前推荐钩子示例，实际配置在用户目录的 settings.json 中。 -->

### PreToolUse
- **tmux reminder**: Suggests tmux for long-running commands (npm, pnpm, yarn, cargo, etc.)
  <!-- 长耗时命令前提醒使用 tmux -->
- **git push review**: Opens Zed for review before push
  <!-- push 前用 Zed 做一次审查 -->
- **doc blocker**: Blocks creation of unnecessary .md/.txt files
  <!-- 阻止创建不必要的 .md/.txt -->

### PostToolUse
- **PR creation**: Logs PR URL and GitHub Actions status
- **Prettier**: Auto-formats JS/TS files after edit
- **TypeScript check**: Runs tsc after editing .ts/.tsx files
- **console.log warning**: Warns about console.log in edited files

### Stop
- **console.log audit**: Checks all modified files for console.log before session ends
  <!-- 会话结束前检查所有修改过的文件是否还有 console.log -->

## Auto-Accept Permissions

<!-- 自动通过工具权限要谨慎：仅在可信、计划明确时开启，探索性工作应关闭；禁止用 dangerously-skip-permissions；可用 ~/.claude.json 的 allowedTools 做细粒度配置。 -->
Use with caution:
- Enable for trusted, well-defined plans
- Disable for exploratory work
- Never use dangerously-skip-permissions flag
- Configure `allowedTools` in `~/.claude.json` instead

## TodoWrite Best Practices

<!-- 用 TodoWrite 工具：跟踪多步任务、确认理解正确、便于实时纠偏、展示细化步骤。任务列表能暴露顺序错、缺项、多余项、粒度不当或需求理解错误。 -->
Use TodoWrite tool to:
- Track progress on multi-step tasks
- Verify understanding of instructions
- Enable real-time steering
- Show granular implementation steps

Todo list reveals:
- Out of order steps
- Missing items
- Extra unnecessary items
- Wrong granularity
- Misinterpreted requirements
