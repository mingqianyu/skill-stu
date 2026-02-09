# Verification Command

<!-- 标题：验证命令。对应 /verify，对当前代码库做综合检查，判断是否可提 PR。 -->

Run comprehensive verification on current codebase state.

<!-- 上面：对“当前代码库状态”做全面验证（不改代码，只跑检查并报告）。 -->

## Instructions

<!-- 小节：执行顺序。必须按下面 1～6 的顺序做，不要跳步。 -->

Execute verification in this exact order:

1. **Build Check**

   <!-- 第 1 步：构建检查。 -->

   - Run the build command for this project

     <!-- 跑项目规定的构建命令（如 npm run build）。 -->

   - If it fails, report errors and STOP

     <!-- 若构建失败，输出错误信息并立即停止，不继续后面的检查。 -->

2. **Type Check**

   <!-- 第 2 步：类型检查。 -->

   - Run TypeScript/type checker

     <!-- 跑 TypeScript 或项目配置的类型检查（如 tsc --noEmit）。 -->

   - Report all errors with file:line

     <!-- 每条错误都要带“文件:行号”，便于定位。 -->

3. **Lint Check**

   <!-- 第 3 步：Lint 检查。 -->

   - Run linter

     <!-- 跑 ESLint 等 linter。 -->

   - Report warnings and errors

     <!-- 列出所有 warning 和 error，不要只报数量。 -->

4. **Test Suite**

   <!-- 第 4 步：测试套件。 -->

   - Run all tests

     <!-- 跑完整测试（如 npm test）。 -->

   - Report pass/fail count

     <!-- 报告通过数/失败数（如 42 passed, 2 failed）。 -->

   - Report coverage percentage

     <!-- 若有覆盖率，报告百分比。 -->

5. **Console.log Audit**

   <!-- 第 5 步：console.log 审计。 -->

   - Search for console.log in source files

     <!-- 在源码中搜索 console.log（排除 test、node_modules 等按项目约定）。 -->

   - Report locations

     <!-- 列出每个出现位置（文件:行号），提交前应清理。 -->

6. **Git Status**

   <!-- 第 6 步：Git 状态。 -->

   - Show uncommitted changes

     <!-- 显示未提交的改动（git status）。 -->

   - Show files modified since last commit

     <!-- 显示自上次提交以来修改了哪些文件。 -->

## Output

<!-- 小节：输出格式。用下面简洁格式汇总。 -->

Produce a concise verification report:

```
VERIFICATION: [PASS/FAIL]

Build:    [OK/FAIL]
Types:    [OK/X errors]
Lint:     [OK/X issues]
Tests:    [X/Y passed, Z% coverage]
Secrets:  [OK/X found]
Logs:     [OK/X console.logs]

Ready for PR: [YES/NO]
```

<!-- 上面：总结果 PASS/FAIL；各项 OK 或具体问题数；最后给出是否适合提 PR。 -->

If any critical issues, list them with fix suggestions.

<!-- 若有严重问题（如构建失败、类型错误），要逐条列出并附带修复建议。 -->

## Arguments

<!-- 小节：参数。用户可通过 $ARGUMENTS 选择检查范围。 -->

$ARGUMENTS can be:

- `quick` - Only build + types

  <!-- quick：只做构建和类型检查，省时间。 -->

- `full` - All checks (default)

  <!-- full：上述全部 6 项（默认）。 -->

- `pre-commit` - Checks relevant for commits

  <!-- pre-commit：只做与提交相关的检查（如类型、lint、快速测）。 -->

- `pre-pr` - Full checks plus security scan

  <!-- pre-pr：全量检查再加安全扫描（如密钥、依赖漏洞）。 -->
