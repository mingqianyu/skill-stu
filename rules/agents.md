<!-- 本文件：子代理编排规则。规定何时用哪个 agent、何时并行执行、何时用多角色分析。复制到 ~/.claude/rules/ 后，Claude 会始终参考。 -->

# Agent Orchestration

<!-- 本节：当前可用的子代理列表及其用途、推荐使用时机。安装后这些 agent 位于 ~/.claude/agents/。 -->

## Available Agents

Located in `~/.claude/agents/`:

| Agent | Purpose | When to Use |
|-------|---------|-------------|
| planner | Implementation planning | Complex features, refactoring |
| architect | System design | Architectural decisions |
| tdd-guide | Test-driven development | New features, bug fixes |
| code-reviewer | Code review | After writing code |
| security-reviewer | Security analysis | Before commits |
| build-error-resolver | Fix build errors | When build fails |
| e2e-runner | E2E testing | Critical user flows |
| refactor-cleaner | Dead code cleanup | Code maintenance |
| doc-updater | Documentation | Updating docs |

<!-- 上表中文简述：planner=实现规划；architect=系统设计；tdd-guide=测试驱动开发；code-reviewer=代码审查；security-reviewer=安全分析；build-error-resolver=修复构建错误；e2e-runner=E2E 测试；refactor-cleaner=死代码清理；doc-updater=文档更新。 -->

## Immediate Agent Usage

<!-- 无需用户额外说明，遇到下列情况应直接选用对应 agent： -->
No user prompt needed:
1. Complex feature requests - Use **planner** agent
   <!-- 复杂功能需求 → 用 planner 做实现规划 -->
2. Code just written/modified - Use **code-reviewer** agent
   <!-- 刚写完或改完代码 → 用 code-reviewer 做审查 -->
3. Bug fix or new feature - Use **tdd-guide** agent
   <!-- 修 bug 或新功能 → 用 tdd-guide 走 TDD -->
4. Architectural decision - Use **architect** agent
   <!-- 架构决策 → 用 architect -->

## Parallel Task Execution

<!-- 彼此独立的任务应并行调用多个 agent，不要无谓地串行。 -->
ALWAYS use parallel Task execution for independent operations:

```markdown
# GOOD: Parallel execution
Launch 3 agents in parallel:
1. Agent 1: Security analysis of auth.ts
2. Agent 2: Performance review of cache system
3. Agent 3: Type checking of utils.ts

# BAD: Sequential when unnecessary
First agent 1, then agent 2, then agent 3
```

## Multi-Perspective Analysis

<!-- 复杂问题可拆成多角色子代理同时分析：事实核对、高级工程师、安全专家、一致性审查、冗余检查。 -->
For complex problems, use split role sub-agents:
- Factual reviewer
- Senior engineer
- Security expert
- Consistency reviewer
- Redundancy checker
