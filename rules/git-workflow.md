<!-- 本文件：Git 工作流规则。约定提交信息格式、PR 流程、以及功能开发时的「先规划 → TDD → 代码审查 → 提交」四步。 -->

# Git Workflow

## Commit Message Format

<!-- 约定式提交：类型 + 简短描述，可选正文。类型见下一行。 -->
```
<type>: <description>

<optional body>
```

Types: feat, fix, refactor, docs, test, chore, perf, ci
<!-- 类型：feat=新功能 fix=修复 refactor=重构 docs=文档 test=测试 chore=杂项 perf=性能 ci=CI -->

Note: Attribution disabled globally via ~/.claude/settings.json.
<!-- 说明：归属/署名已在全局设置中关闭。 -->

## Pull Request Workflow

<!-- 创建 PR 时：看完整提交历史、用 git diff 看全量变更、写完整 PR 摘要、附测试计划与 TODO、新分支推送时用 -u。 -->
When creating PRs:
1. Analyze full commit history (not just latest commit)
2. Use `git diff [base-branch]...HEAD` to see all changes
3. Draft comprehensive PR summary
4. Include test plan with TODOs
5. Push with `-u` flag if new branch

## Feature Implementation Workflow

<!-- 功能实现四步：先规划、TDD、写完代码立刻审查、最后按约定式提交。 -->
1. **Plan First**
   - Use **planner** agent to create implementation plan
   - Identify dependencies and risks
   - Break down into phases

2. **TDD Approach**
   - Use **tdd-guide** agent
   - Write tests first (RED)
   - Implement to pass tests (GREEN)
   - Refactor (IMPROVE)
   - Verify 80%+ coverage

3. **Code Review**
   - Use **code-reviewer** agent immediately after writing code
   - Address CRITICAL and HIGH issues
   - Fix MEDIUM issues when possible

4. **Commit & Push**
   - Detailed commit messages
   - Follow conventional commits format
