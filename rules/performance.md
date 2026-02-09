<!-- 本文件：性能与成本优化规则。模型选择（Haiku/Sonnet/Opus）、上下文窗口使用注意、深度推理时用 ultrathink/Plan 与多角色 agent、构建失败时的处理。 -->

# Performance Optimization

## Model Selection Strategy

<!-- 按任务选模型：Haiku 省成本适合轻量/高频调用；Sonnet 主开发与编排；Opus 做架构与深度分析。 -->
**Haiku 4.5** (90% of Sonnet capability, 3x cost savings):
- Lightweight agents with frequent invocation
- Pair programming and code generation
- Worker agents in multi-agent systems

**Sonnet 4.5** (Best coding model):
- Main development work
- Orchestrating multi-agent workflows
- Complex coding tasks

**Opus 4.5** (Deepest reasoning):
- Complex architectural decisions
- Maximum reasoning requirements
- Research and analysis tasks

## Context Window Management

<!-- 避免把大规模重构、跨文件功能、复杂调试放在上下文最后 20%（敏感区）；单文件编辑、文档更新、简单修 bug 等对上下文不敏感。 -->
Avoid last 20% of context window for:
- Large-scale refactoring
- Feature implementation spanning multiple files
- Debugging complex interactions

Lower context sensitivity tasks:
- Single-file edits
- Independent utility creation
- Documentation updates
- Simple bug fixes

## Ultrathink + Plan Mode

<!-- 需要深度推理时：开 ultrathink、开 Plan Mode、多轮批判式推敲、用多角色子代理做多角度分析。 -->
For complex tasks requiring deep reasoning:
1. Use `ultrathink` for enhanced thinking
2. Enable **Plan Mode** for structured approach
3. "Rev the engine" with multiple critique rounds
4. Use split role sub-agents for diverse analysis

## Build Troubleshooting

<!-- 构建失败时：用 build-error-resolver 子代理、分析报错、小步修复、每步修复后验证。 -->
If build fails:
1. Use **build-error-resolver** agent
2. Analyze error messages
3. Fix incrementally
4. Verify after each fix
