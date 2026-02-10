# Orchestrate Command

<!-- 标题：编排命令。对应 /orchestrate，按预设工作流顺序调用多个子代理，用交接文档在 agent 间传上下文。 -->

Sequential agent workflow for complex tasks.

<!-- 上面：用“顺序执行多个 agent”的方式处理复杂任务（一个接一个，不是同时）。 -->

## Usage

<!-- 小节：用法。 -->

`/orchestrate [workflow-type] [task-description]`

<!-- 格式：第一个参数为工作流类型，第二个为任务描述。 -->

## Workflow Types

<!-- 小节：工作流类型。每种类型对应一串固定顺序的 agent。 -->

### feature

<!-- 类型 feature：完整功能实现流程。 -->

Full feature implementation workflow:

```
planner -> tdd-guide -> code-reviewer -> security-reviewer
```

<!-- 上面：先规划 → 再 TDD 实现 → 再代码审查 → 最后安全审查。 -->

### bugfix

<!-- 类型 bugfix：查 bug 并修复。 -->

Bug investigation and fix workflow:

```
explorer -> tdd-guide -> code-reviewer
```

<!-- 上面：先探索定位 → TDD 修 bug（先写复现测试）→ 代码审查。 -->

### refactor

<!-- 类型 refactor：安全重构。 -->

Safe refactoring workflow:

```
architect -> code-reviewer -> tdd-guide
```

<!-- 上面：先架构设计 → 代码审查 → TDD 保证行为不变。 -->

### security

<!-- 类型 security：以安全为主的审查。 -->

Security-focused review:

```
security-reviewer -> code-reviewer -> architect
```

<!-- 上面：安全审查 → 代码质量审查 → 架构审查。 -->

## Execution Pattern

<!-- 小节：执行模式。每个 agent 按下面 4 步处理。 -->

For each agent in the workflow:

1. **Invoke agent** with context from previous agent

   <!-- 用“上一个 agent 的产出”作为上下文，调用当前 agent。 -->

2. **Collect output** as structured handoff document

   <!-- 把当前 agent 的产出整理成结构化的“交接文档”。 -->

3. **Pass to next agent** in chain

   <!-- 把交接文档传给链中的下一个 agent。 -->

4. **Aggregate results** into final report

   <!-- 所有 agent 跑完后，把各步结果汇总成最终报告。 -->

## Handoff Document Format

<!-- 小节：交接文档格式。agent 之间用下面结构传递信息。 -->

Between agents, create handoff document:

```markdown
## HANDOFF: [previous-agent] -> [next-agent]

### Context
[Summary of what was done]

### Findings
[Key discoveries or decisions]

### Files Modified
[List of files touched]

### Open Questions
[Unresolved items for next agent]

### Recommendations
[Suggested next steps]
```

<!-- 上面：标明从谁到谁；Context 做了什么；Findings 关键发现或决策；Files Modified 改动的文件；Open Questions 留给下一环节的问题；Recommendations 建议的下一步。 -->

## Example: Feature Workflow

<!-- 小节：示例——feature 工作流。用户输入后实际执行顺序。 -->

```
/orchestrate feature "Add user authentication"
```

<!-- 用户输入：执行 feature 类型，任务为“添加用户认证”。 -->

Executes:

1. **Planner Agent**

   <!-- 第 1 个 agent：planner。 -->

   - Analyzes requirements

     <!-- 分析需求。 -->

   - Creates implementation plan

     <!-- 产出实施计划。 -->

   - Identifies dependencies

     <!-- 标出依赖关系。 -->

   - Output: `HANDOFF: planner -> tdd-guide`

     <!-- 输出交接文档，给 tdd-guide。 -->

2. **TDD Guide Agent**

   <!-- 第 2 个 agent：tdd-guide。 -->

   - Reads planner handoff

     <!-- 读取 planner 的交接文档。 -->

   - Writes tests first

     <!-- 先写测试。 -->

   - Implements to pass tests

     <!-- 再写实现让测试通过。 -->

   - Output: `HANDOFF: tdd-guide -> code-reviewer`

     <!-- 输出交接文档，给 code-reviewer。 -->

3. **Code Reviewer Agent**

   <!-- 第 3 个 agent：code-reviewer。 -->

   - Reviews implementation

     <!-- 审查实现。 -->

   - Checks for issues

     <!-- 检查问题。 -->

   - Suggests improvements

     <!-- 提出改进建议。 -->

   - Output: `HANDOFF: code-reviewer -> security-reviewer`

     <!-- 输出交接文档，给 security-reviewer。 -->

4. **Security Reviewer Agent**

   <!-- 第 4 个 agent：security-reviewer。 -->

   - Security audit

     <!-- 安全审计。 -->

   - Vulnerability check

     <!-- 漏洞检查。 -->

   - Final approval

     <!-- 最终是否通过。 -->

   - Output: Final Report

     <!-- 输出最终报告，不再交给下一个 agent。 -->

## Final Report Format

```
ORCHESTRATION REPORT
====================
Workflow: feature
Task: Add user authentication
Agents: planner -> tdd-guide -> code-reviewer -> security-reviewer

SUMMARY
-------
[One paragraph summary]

AGENT OUTPUTS
-------------
Planner: [summary]
TDD Guide: [summary]
Code Reviewer: [summary]
Security Reviewer: [summary]

FILES CHANGED
-------------
[List all files modified]

TEST RESULTS
------------
[Test pass/fail summary]

SECURITY STATUS
---------------
[Security findings]

RECOMMENDATION
--------------
[SHIP / NEEDS WORK / BLOCKED]
```

<!-- 上面：最终报告需包含工作流类型、任务、agent 链、一段总结、各 agent 输出摘要、改动文件、测试结果、安全结论、是否可发布。 -->

## Parallel Execution

<!-- 小节：并行执行。当多个 agent 彼此独立时，可同时跑再合并结果。 -->

For independent checks, run agents in parallel:

```markdown
### Parallel Phase
Run simultaneously:
- code-reviewer (quality)
- security-reviewer (security)
- architect (design)

### Merge Results
Combine outputs into single report
```

<!-- 上面：质量审查、安全审查、架构审查互不依赖时可并行；最后把三份输出合并成一份报告。 -->

## Arguments

<!-- 小节：参数说明。 -->

$ARGUMENTS:

- `feature <description>` - Full feature workflow

  <!-- feature + 任务描述：完整功能流程。 -->

- `bugfix <description>` - Bug fix workflow

  <!-- bugfix + 描述：修 bug 流程。 -->

- `refactor <description>` - Refactoring workflow

  <!-- refactor + 描述：重构流程。 -->

- `security <description>` - Security review workflow

  <!-- security + 描述：安全审查流程。 -->

- `custom <agents> <description>` - Custom agent sequence

  <!-- custom + agent 列表 + 描述：自定义 agent 顺序。 -->

## Custom Workflow Example

<!-- 自定义工作流示例：自己指定 agent 顺序。 -->

```
/orchestrate custom "architect,tdd-guide,code-reviewer" "Redesign caching layer"
```

<!-- 上面：按 architect → tdd-guide → code-reviewer 执行，任务为“重设计缓存层”。 -->

## Tips

<!-- 小节：使用建议。 -->

1. **Start with planner** for complex features

   <!-- 复杂功能先用 planner 出计划。 -->

2. **Always include code-reviewer** before merge

   <!-- 合并前一定要经过 code-reviewer。 -->

3. **Use security-reviewer** for auth/payment/PII

   <!-- 涉及认证、支付、个人数据的要跑 security-reviewer。 -->

4. **Keep handoffs concise** - focus on what next agent needs

   <!-- 交接文档要简短，只写下一个 agent 需要的信息。 -->

5. **Run verification** between agents if needed

   <!-- 若需要，可在某几步之间跑 /verify 做检查。 -->
